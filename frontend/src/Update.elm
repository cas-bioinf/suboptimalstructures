module Update exposing (update)

import Http
import HttpUtils
import Types
import BLASTJson
import Json.Decode


update : Types.Msg -> Types.Model -> ( Types.Model, Cmd Types.Msg )
update msg model =
    case msg of
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
            ( {model | blastTextResult = Just (Json.Decode.decodeString BLASTJson.decoder text)}, Cmd.none)            