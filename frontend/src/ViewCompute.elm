module ViewCompute exposing (view)

import TypesCompute exposing (..)
import Html exposing (..)
import Html.Events as Events
import Types
import ViewUtils


view : Model -> List (Html Types.Msg)
view model =
    let
        subheading =
            case model.state of
                None ->
                    "Nothing - this is in error"

                WaitingForCompute _ ->
                    "Sending request for computation"

                WaitingForStatus _ ->
                    "Waiting for computation to finish"

                WaitingForResult _ ->
                    "Getting results"
    in
        (h2 [] [ text subheading ])
            :: (case model.error of
                    Just error ->
                        [ ViewUtils.errorMessage "Error performing request"
                            (ViewUtils.httpErrorToString error)
                        , case model.state of
                            None ->
                                text ""

                            _ ->
                                retryButton
                        ]

                    Nothing ->
                        [ text "" ]
               )


retryButton : Html Types.Msg
retryButton =
    button [ Events.onClick (Types.ComputeMsg Retry) ] [ text "Retry" ]
