module Hydra.Action where

import UI.Msg qualified

data Action a
  = ShellCommand Text
  | Command HydraCommand
  | Recurse (IO a)

instance Eq (Action a) where
  (==) :: Action a -> Action a -> Bool
  (==) _ _ = True

data HydraCommand
  = Quit
  deriving (Eq)

toUIMsg :: Action a -> UI.Msg.Msg a
toUIMsg (ShellCommand cmd) = UI.Msg.RunShellCommand cmd
toUIMsg (Recurse hydra) = UI.Msg.ChangeActiveHydra hydra
toUIMsg (Command cmd) = case cmd of Quit -> UI.Msg.Quit

recursePure :: a -> Action a
recursePure = Recurse . pure
