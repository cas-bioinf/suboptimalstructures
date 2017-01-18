module ViewUtils exposing (backButton, errorMessage)

import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import Types

backButton : Types.Msg -> Html Types.Msg
backButton msg =
    a [ Attributes.class "backButton", Events.onClick msg ] [ text "Back" ]

errorMessage : String -> String -> Html Types.Msg
errorMessage body detail =
    div [ Attributes.class "errorMessage" ]
        [ p [ Attributes.class "messageBody" ] [ text body ]
        , p [ Attributes.class "messageDetail" ] [ text detail ]
        ]
