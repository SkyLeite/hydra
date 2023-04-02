{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE TemplateHaskell #-}

module UI (start) where

import Control.Lens
import Hydra
import Monomer
import System.Process as Process
import UI.Msg
import UI.Widgetable (Widgetable (toWidgetNode))

data AppModel a = AppModel
  { _clickCount :: Int,
    _hydra :: a
  }
  deriving (Eq)

makeLenses ''AppModel

build ::
  WidgetEnv (AppModel Hydra) (Msg Hydra) ->
  AppModel Hydra ->
  WidgetNode (AppModel Hydra) (Msg Hydra)
build _wenv model = keystroke (toKeystrokeCombination (model ^. hydra)) $ widgetTree
  where
    widgetTree =
      hgrid
        [ vstack
            . map toWidgetNode
            . view (hydra . prompts)
            $ model
        ]
        `styleBasic` [padding 15]

update ::
  WidgetEnv (AppModel Hydra) (Msg Hydra) ->
  WidgetNode (AppModel Hydra) (Msg Hydra) ->
  AppModel Hydra ->
  Msg Hydra ->
  [AppEventResponse (AppModel Hydra) (Msg Hydra)]
update _wenv _node model evt = case evt of
  Init -> []
  Increase -> [Model (model & clickCount +~ 1)]
  Quit -> [exitApplication]
  RunShellCommand cmd -> [Task $ Quit <$ (Process.spawnCommand . toString) cmd]
  HydraChanged newHydra -> [Model (model & hydra .~ newHydra)]
  ChangeActiveHydra task -> [Task $ HydraChanged <$> task]

start :: Hydra -> IO ()
start mainHydra =
  startApp model update build config
  where
    config =
      [ appWindowTitle "Hydra",
        appTheme darkTheme,
        appFontDef "Regular" "./assets/fonts/NotoSansSymbols-Regular.ttf",
        appInitEvent Init,
        appWindowResizable False,
        appWindowBorder True,
        appWindowState $ MainWindowNormal (800, 200)
      ]
    model = AppModel {_clickCount = 0, _hydra = mainHydra}
