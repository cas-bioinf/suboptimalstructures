module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed
import Types
import BLAST


mainMenuItem : String -> Types.Msg -> Html Types.Msg
mainMenuItem caption msg =
    a [ Attributes.class "mainMenuItem", Events.onClick msg ]
        [ text caption ]


viewWelcome : List (Html Types.Msg)
viewWelcome =
    [ div [ Attributes.id "mainMenu" ]
        [ mainMenuItem "I have a BLAST result" Types.ShowEnterBLASTResult
        , mainMenuItem "I have a BLAST request ID" Types.ShowEnterRequestID
        , mainMenuItem "I have an RNA sequence" Types.ShowEnterRequestID
        ]
    ]


viewEnterRequestID : Types.Model -> List (Html Types.Msg)
viewEnterRequestID model =
    [ h2 [] [ text "Enter BLAST request ID" ]
    , form [ Events.onSubmit Types.RequestIDSubmit ]
        [ input
            [ Attributes.type_ "text"
            , Attributes.defaultValue (Maybe.withDefault "" model.requestID)
            , Events.onInput Types.RequestIDChanged
            ]
            []
        , input [ Attributes.type_ "submit", Attributes.value "Submit" ] []
        ]
    ]

viewMaybeParsingResult : Types.MaybeParsingResult -> Html Types.Msg
viewMaybeParsingResult maybeResult =
    case maybeResult of
        Just (Ok result) ->
            ul [] <| List.map (\x -> li [] [text x.title]) result
        Just (Err error) ->
            text ("parse error:" ++ error)
        Nothing ->
            text ""

viewEnterBLASTResult : Types.Model -> List (Html Types.Msg)
viewEnterBLASTResult model =
    [ h2 [] [ text "Upload a BLAST result" ]
    , form []
        [ Html.Keyed.node "fieldset"
            []
            [ ( "legend", legend [] [ text "Upload a File" ] )
            , ( "file", input [ Attributes.type_ "file" ] [] )
            ]
        , Html.Keyed.node "fieldset"
            []
            [ ( "legend", legend [] [ text "-OR- Paste the result below" ] )
            , ( "text"
              , textarea
                    [ Attributes.placeholder "BLAST hit in JSON format"
                    , Events.onInput Types.BLASTTextChanged
                    ]
                    []
              )
            , ( "preview", div [] [ viewMaybeParsingResult model.blastTextResult])
            ]
        ]
    ]


view : Types.Model -> Html Types.Msg
view model =
    div [ Attributes.class "wrapper" ]
        ((h1 [] [ text ("Suboptimal structures") ])
            :: (case model.state of
                    Types.Welcome ->
                        viewWelcome

                    Types.EnterRequestID ->
                        viewEnterRequestID model

                    Types.CheckingSearchComplete ->
                        [ div [ Attributes.class "processing" ] [ text "Checking request status" ] ]

                    Types.FetchingResult ->
                        [ div [ Attributes.class "message" ] [ text model.message ] ]

                    Types.EnterBLASTResult ->
                        viewEnterBLASTResult model
               )
        )
