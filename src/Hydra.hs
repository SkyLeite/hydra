module Hydra where

import Control.Concurrent (threadDelay)
import Control.Lens
import Hydra.Action
import Hydra.Action (recursePure)
import Hydra.Prompt
import UI.Msg qualified

data Hydra = Hydra
  { _prompts :: [Prompt Hydra],
    _title :: Text
  }
  deriving (Eq)

makeLenses ''Hydra

toKeystrokeCombination :: Hydra -> [(Text, UI.Msg.Msg Hydra)]
toKeystrokeCombination = map promptToKeystroke . view prompts
  where
    promptToKeystroke :: Prompt Hydra -> (Text, UI.Msg.Msg Hydra)
    promptToKeystroke prompt = (prompt ^. key, toUIMsg . view action $ prompt)
