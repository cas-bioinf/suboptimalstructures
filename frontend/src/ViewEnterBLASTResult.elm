module ViewEnterBLASTResult exposing (view)

import Html exposing (..)
import TypesInput exposing (..)
import Types
import Html.Keyed
import Html.Attributes as Attributes
import Html.Events as Events
import BLAST
import ViewUtils
import FileReader
import Json.Decode


view : Model -> List (Html Types.Msg)
view model =
    [ ViewUtils.backButton (Types.InputMsg ShowWelcome)
    , h2 [] [ text "Upload a BLAST result" ]
    , Html.Keyed.node "fieldset"
        []
        [ ( "legend", legend [] [ text "Upload a File" ] )
        , ( "file"
          , div
                [ Attributes.class "formContent"
                ]
                [ input [ Attributes.type_ "file", onFileChange (Types.inputMsg BLASTFileChosen) ] [] ]
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
                    , Events.onInput (Types.inputMsg BLASTTextChanged)
                    ]
                    []
                ]
          )
        , ( "preview", div [] [ viewMaybeParsingResult model.blastTextResult ] )
        ]
    ]


viewMaybeParsingResult : MaybeParsingResult -> Html Types.Msg
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
                , button [ Events.onClick (Types.ShowChooseAlignments results) ] [ text "Continue" ]
                ]

        Just (Err error) ->
            ViewUtils.errorMessage
                "Error parsing result. Note that we require the result in JSON format."
                error

        Nothing ->
            text ""


viewBLASTResultSummary : BLAST.Result -> List (Html Types.Msg)
viewBLASTResultSummary result =
    [ text "Query: "
    , em [ Attributes.class "blastQuery" ] [ text result.queryTitle ]
    , ul [] [ li [] [ text ((toString <| numMatches result) ++ " alignments in " ++ (toString <| List.length result.sequenceResults) ++ " sequences.") ] ]
    ]


numMatches : BLAST.Result -> Int
numMatches result =
    result.sequenceResults |> List.map (.alignments >> List.length) |> List.sum


onFileChange : (List FileReader.NativeFile -> Types.Msg) -> Html.Attribute Types.Msg
onFileChange action =
    Events.on
        "change"
        (Json.Decode.map action FileReader.parseSelectedFiles)
