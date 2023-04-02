module Main where

import Hydra
import Hydra.Action
import Hydra.Collection.Window qualified
import Hydra.Prompt
import Main.Utf8 qualified as Utf8
import UI

-- |
-- Main entry point.
--
-- The `, run` script will invoke this function.
main :: IO ()
main = do
  Utf8.withUtf8 $ do
    -- let closeWindowCommand = "swaymsg -t get_tree | jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.visible and .name == \"Hydra\") | .id' | xargs -I {} swaymsg \"[con_id={}] kill\""
    UI.start mainHydra
    putTextLn "Hello"

mainHydra :: Hydra
mainHydra =
  Hydra
    { _title = "Main",
      _prompts =
        [ Prompt {_key = "q", _action = Command Quit, _description = "Quit"},
          Prompt {_key = "s", _action = ShellCommand "flameshot gui", _description = "Take a screenshot"},
          Prompt {_key = "r", _action = ShellCommand "rofi -show drun", _description = "Run a program in rofi"},
          Prompt {_key = "p", _action = ShellCommand "pavucontrol", _description = "Open volume mixer"},
          Prompt {_key = "f", _action = ShellCommand "rofi -show firefox", _description = "Switch to a tab in Firefox"}
        ]
    }
