module ViewInput exposing (view)

import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import TypesInput exposing (..)
import Types
import ViewEnterBLASTResult


view : Model -> List (Html Types.Msg)
view model =
    case model.state of
        Welcome ->
            viewWelcome

        EnterRequestID ->
            viewEnterRequestID model

        CheckingSearchComplete ->
            [ div [ Attributes.class "processing" ] [ text "Checking request status" ] ]

        FetchingResult ->
            [ div [ Attributes.class "message" ] [ text model.message ] ]

        EnterBLASTResult ->
            ViewEnterBLASTResult.view model


viewWelcome : List (Html Types.Msg)
viewWelcome =
    [ div [ Attributes.id "mainMenu" ]
        [ mainMenuItem "I have a BLAST result" ShowEnterBLASTResult
        , mainMenuItem "I have a BLAST request ID" ShowEnterRequestID
        , mainMenuItem "I have an RNA sequence" ShowEnterRequestID
        ]
    ]


mainMenuItem : String -> Msg -> Html Types.Msg
mainMenuItem caption msg =
    a [ Attributes.class "mainMenuItem", Events.onClick (Types.InputMsg msg) ]
        [ text caption ]


viewEnterRequestID : Model -> List (Html Types.Msg)
viewEnterRequestID model =
    [ h2 [] [ text "Enter BLAST request ID" ]
    , form [ Events.onSubmit (Types.InputMsg RequestIDSubmit) ]
        [ input
            [ Attributes.type_ "text"
            , Attributes.defaultValue (Maybe.withDefault "" model.requestID)
            , Events.onInput (Types.inputMsg RequestIDChanged)
            ]
            []
        , input [ Attributes.type_ "submit", Attributes.value "Submit" ] []
        ]
    ]
