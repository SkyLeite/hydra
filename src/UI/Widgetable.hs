module UI.Widgetable where

import Monomer

class Widgetable a where
  toWidgetNode :: a -> WidgetNode s e
