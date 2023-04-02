module Hydra.Prompt where

import Control.Lens
import Hydra.Action
import Monomer
import Text.Show qualified
import UI.Widgetable

data Prompt a = Prompt
  { _key :: Text,
    _action :: Action a,
    _description :: Text
  }
  deriving (Eq)

makeLenses ''Prompt

instance Show (Prompt a) where
  show :: Prompt a -> String
  show prompt = toString $ prompt ^. key <> ": " <> prompt ^. description

instance Widgetable (Prompt a) where
  toWidgetNode prompt =
    hstack
      [ label (prompt ^. key) `styleBasic` [width 15],
        label separator,
        spacer,
        label $ prompt ^. description
      ]
    where
      separator = "→"
