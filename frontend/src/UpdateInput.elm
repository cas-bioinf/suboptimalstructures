module UpdateInput exposing (update)

import Http
import HttpUtils
import TypesInput exposing(..)
import Types
import BLASTJson
import Json.Decode
import FileReader
import Task

update : Msg -> Model -> ( Model, Cmd Types.Msg )
update msg model =
    case msg of
        ShowWelcome ->
            ( { model | state = Welcome }, Cmd.none )

        ShowEnterRequestID ->
            ( { model | state = EnterRequestID }, Cmd.none )

        RequestIDChanged newID ->
            ( { model | requestID = Just newID }, Cmd.none )

        RequestIDSubmit ->
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
                { model | state = CheckingSearchComplete } ! [ Http.send (Types.inputMsg SearchCompleteResult) checkCompleteRequest ]

        SearchCompleteResult result ->
            ( case result of
                Ok stringResponse ->
                    { model | state = FetchingResult, message = stringResponse }

                Err error ->
                    { model | state = FetchingResult, message = "Error" }
            , Cmd.none
            )

        ShowEnterBLASTResult ->
            ( { model | state = EnterBLASTResult }, Cmd.none )

        BLASTTextChanged text ->
            ( { model
                | blastTextResult =
                    if text == "" then
                        Nothing
                    else
                        Just (Json.Decode.decodeString BLASTJson.decoder text)
              }
            , Cmd.none
            )

        BLASTFileChosen files ->
            { model | blastFileResult = Nothing }
                ! List.map readBLASTFileTask files

        BLASTFileRead result ->
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




readBLASTFileTask : FileReader.NativeFile -> Cmd Types.Msg
readBLASTFileTask fileValue =
    FileReader.readAsTextFile fileValue.blob
        |> Task.attempt (Types.inputMsg BLASTFileRead)


fileReaderErrorToString : FileReader.Error -> String
fileReaderErrorToString _ =
    "File reader error"
