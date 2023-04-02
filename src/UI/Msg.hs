module UI.Msg where

data Msg hydra
  = Init
  | Increase
  | Quit
  | RunShellCommand Text
  | HydraChanged hydra
  | ChangeActiveHydra (IO hydra)
