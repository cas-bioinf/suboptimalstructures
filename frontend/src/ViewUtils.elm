module ViewUtils exposing (backButton, errorMessage, httpErrorToString)

import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import Types
import Http

backButton : Types.Msg -> Html Types.Msg
backButton msg =
    a [ Attributes.class "backButton", Events.onClick msg ] [ text "Back" ]

errorMessage : String -> String -> Html Types.Msg
errorMessage body detail =
    div [ Attributes.class "errorMessage" ]
        [ p [ Attributes.class "messageBody" ] [ text body ]
        , p [ Attributes.class "messageDetail" ] [ text detail ]
        ]

httpErrorToString: Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl msg ->
            "Bad request URL: '" ++ msg  ++ "'"
        Http.Timeout -> 
            "The request timed out."
        Http.NetworkError ->
            "Network error."
        Http.BadStatus response ->
            "The server returned error status: " ++ (toString response.status.code) ++ " - " ++ response.status.message
        Http.BadPayload payloadMsg _ ->
            "The contents of the response could not be parsed: " ++ payloadMsg