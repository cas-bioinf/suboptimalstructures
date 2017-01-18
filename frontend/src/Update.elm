module Update exposing (update)

import Http
import HttpUtils
import Types
import BLASTJson
import Json.Decode
import FileReader
import Task
import Set


update : Types.Msg -> Types.Model -> ( Types.Model, Cmd Types.Msg )
update msg model =
    case msg of
        Types.ShowWelcome ->
            ( { model | state = Types.Welcome }, Cmd.none )

        Types.ShowEnterRequestID ->
            ( { model | state = Types.EnterRequestID }, Cmd.none )

        Types.RequestIDChanged newID ->
            ( { model | requestID = Just newID }, Cmd.none )

        Types.RequestIDSubmit ->
            let
                requestURL =
                    HttpUtils.url "https://blast.ncbi.nlm.nih.gov/Blast.cgi"
                        [ ( "CMD", "Get" )
                        , ( "FORMAT_OBJECT", "SearchInfo" )
                        , ( "FORMAT_TYPE", "JSON2" )
                        , ( "RID", Maybe.withDefault "" model.requestID )
                        ]

                checkCompleteRequest =
                    Http.getString (Debug.log "URL" requestURL)
            in
                { model | state = Types.CheckingSearchComplete } ! [ Http.send Types.SearchCompleteResult checkCompleteRequest ]

        Types.SearchCompleteResult result ->
            ( case result of
                Ok stringResponse ->
                    { model | state = Types.FetchingResult, message = stringResponse }

                Err error ->
                    { model | state = Types.FetchingResult, message = "Error" }
            , Cmd.none
            )

        Types.ShowEnterBLASTResult ->
            ( { model | state = Types.EnterBLASTResult }, Cmd.none )

        Types.BLASTTextChanged text ->
            ( { model
                | blastTextResult =
                    if text == "" then
                        Nothing
                    else
                        Just (Json.Decode.decodeString BLASTJson.decoder text)
              }
            , Cmd.none
            )

        Types.BLASTFileChosen files ->
            { model | blastFileResult = Nothing }
                ! List.map readBLASTFileTask files

        Types.BLASTFileRead result ->
            let
                parseResult =
                    result
                        |> Result.mapError fileReaderErrorToString
                        |> Result.andThen (Json.Decode.decodeString BLASTJson.decoder)
            in
                { model
                    | blastFileResult =
                        case model.blastFileResult of
                            Just oldResult ->
                                Just (Result.map2 List.append parseResult oldResult)

                            Nothing ->
                                Just parseResult
                }
                    ! []

        Types.ShowChooseBLASTAlignments results ->
            { model
                | state = Types.ChooseBLASTAlignments
                , resultsToChooseFrom = results
                , ignoredAlignments = Set.empty
            }
                ! []

        Types.BLASTAlignmentSelectionChagned alignmentIndex selected ->
            let
                newIgnoredAlignments =
                    if selected then
                        Set.remove alignmentIndex model.ignoredAlignments
                    else
                        Set.insert alignmentIndex model.ignoredAlignments
            in
                { model | ignoredAlignments = newIgnoredAlignments } ! []

        Types.SelectAllBLASTAlignments selected ->
            let
                newIgnoredAlignments =
                    if selected then
                        Set.empty
                    else
                        Set.fromList
                            (model.resultsToChooseFrom
                                |> List.indexedMap
                                    (\resultIndex result ->
                                        result.sequenceResults
                                            |> List.indexedMap
                                                (\sequenceIndex sequenceResult ->
                                                    sequenceResult.alignments |> List.indexedMap (\alignmentIndex _ -> ( resultIndex, sequenceIndex, alignmentIndex ))
                                                )
                                            |> List.foldl (++) []
                                    )
                                |> List.foldl (++) []
                            )

                --TODO
            in
                { model | ignoredAlignments = newIgnoredAlignments } ! []


readBLASTFileTask : FileReader.NativeFile -> Cmd Types.Msg
readBLASTFileTask fileValue =
    FileReader.readAsTextFile fileValue.blob
        |> Task.attempt Types.BLASTFileRead


fileReaderErrorToString : FileReader.Error -> String
fileReaderErrorToString _ =
    "File reader error"
