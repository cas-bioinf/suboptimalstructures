module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed
import Types
import BLAST
import FileReader
import Json.Decode


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


viewEnterBLASTResult : Types.Model -> List (Html Types.Msg)
viewEnterBLASTResult model =
    [ backButton Types.ShowWelcome
    , h2 [] [ text "Upload a BLAST result" ]
    , form []
        [ Html.Keyed.node "fieldset"
            []
            [ ( "legend", legend [] [ text "Upload a File" ] )
            , ( "file"
              , div
                    [ Attributes.class "formContent"
                    ]
                    [ input [ Attributes.type_ "file", onFileChange Types.BLASTFileChosen ] [] ]
              )
            , ( "preview", div [] [ viewMaybeParsingResult model.blastFileResult ] )
            ]
        , Html.Keyed.node "fieldset"
            []
            [ ( "legend", legend [] [ text "-OR- Paste the result below" ] )
            , ( "text"
              , div
                    [ Attributes.class "formContent" ]
                    [ textarea
                        [ Attributes.placeholder "BLAST hit in JSON format"
                        , Events.onInput Types.BLASTTextChanged
                        ]
                        []
                    ]
              )
            , ( "preview", div [] [ viewMaybeParsingResult model.blastTextResult ] )
            ]
        ]
    ]


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
        Just (Ok results) ->
            div []
                [ strong []
                    [ text
                        ("Parsing OK. Found "
                            ++ (toString <| List.length results)
                            ++ " search results."
                        )
                    ]
                , ol [] <| List.map (\x -> li [] (viewBLASTResultSummary x)) results
                ]

        Just (Err error) ->
            errorMessage
                "Error parsing result. Note that we require the result in JSON format."
                error

        Nothing ->
            text ""


viewBLASTResultSummary : BLAST.Result -> List (Html Types.Msg)
viewBLASTResultSummary result =
    [ text "Query: "
    , em [Attributes.class "blastQuery"] [ text result.title ]
    , ul [] [ li [] [ text ((toString <| numMatches result) ++ " segments in " ++ (toString <| List.length result.hits) ++ " sequences.")]]
    ]


numMatches : BLAST.Result -> Int
numMatches result =
    result.hits |> List.map (.hsps >> List.length) |> List.sum


mainMenuItem : String -> Types.Msg -> Html Types.Msg
mainMenuItem caption msg =
    a [ Attributes.class "mainMenuItem", Events.onClick msg ]
        [ text caption ]


backButton : Types.Msg -> Html Types.Msg
backButton msg =
    a [ Attributes.class "backButton", Events.onClick msg ] [ text "Back" ]


errorMessage : String -> String -> Html Types.Msg
errorMessage body detail =
    div [ Attributes.class "errorMessage" ]
        [ p [ Attributes.class "messageBody" ] [ text body ]
        , p [ Attributes.class "messageDetail" ] [ text detail ]
        ]


onFileChange : (List FileReader.NativeFile -> Types.Msg) -> Html.Attribute Types.Msg
onFileChange action =
    Events.on
        "change"
        (Json.Decode.map action FileReader.parseSelectedFiles)
