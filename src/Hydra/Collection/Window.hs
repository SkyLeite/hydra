module Hydra.Collection.Window where

import Data.Aeson (FromJSON, eitherDecode, parseJSON)
import Hydra
import Relude (ToString (toString), ToText (toText))
import System.Process as Process
import System.Process qualified as Process

data NodeType
  = Root
  | Output
  | Workspace
  | Container
  deriving (Show, Generic)

instance FromJSON NodeType

data WaylandNode = WaylandNode
  { id :: Int,
    _type :: NodeType,
    orientation :: Text,
    percent :: Maybe Float,
    urgent :: Bool,
    focused :: Bool,
    name :: Text
  }
  deriving (Show, Generic)

instance FromJSON WaylandNode

run :: IO Hydra
run = do
  output <- (eitherDecode @WaylandNode) . fromString <$> Process.readProcess "bash" ["-r", "-t", "get_tree"] ""
  let node = case output of
        Right node -> trace (show node) node
        Left err -> trace (show err) WaylandNode {}

  print node

  return Hydra {_title = "test", _prompts = []}
  where
    windowListCommand = "swaymsg -t get_tree"
