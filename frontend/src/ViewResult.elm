module ViewResult exposing (view)

import TypesResult exposing (..)
import Html exposing (..)
import Types


view : Model -> List (Html Types.Msg)
view model =
    [ h2 [] [ text "Result" ]
    , text
        (case model.result of
            Just result ->
                result

            Nothing ->
                "<<Nothing to see here>>"
        )
    ]
