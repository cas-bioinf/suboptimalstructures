module Main exposing (..)

import Html
import Update
import View
import Init


main =
    Html.program
        { init = Init.init
        , view = View.view
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }
