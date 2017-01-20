module UpdateCompute exposing (update, updateResultResponse)

import TypesCompute exposing (..)
import TypesResult
import Http
import Types
import ApiJson


apiRoot : String
apiRoot =
    "http://localhost:5000/"


update : Msg -> Model -> ( Model, Cmd Types.Msg )
update msg model =
    case msg of
        SendRequest query ->
            { model | state = WaitingForCompute query, error = Nothing }
                ! [ sendComputeRequest query ]

        ComputeResponse result ->
            case model.state of
                WaitingForCompute _ ->
                case result of
                    Ok requestID ->
                        { model | state = WaitingForStatus requestID, error = Nothing }
                            ! [ sendStatusRequest requestID ]

                    Err error ->
                        { model | error = Just error } ! []
                _ ->
                    model ! []

        StatusResponse result ->
            case model.state of
                WaitingForStatus requestID ->
                    case result of
                        Ok statusData ->
                            if statusData.requestID /= requestID then
                                model ! []
                            else
                                case statusData.status of
                                    Complete ->
                                        { model | state = WaitingForResult requestID, error = Nothing }
                                            ! [ sendResultRequest requestID ]

                                    Running ->
                                        model ! [ sendStatusRequest requestID ]

                        Err error ->
                            { model | error = Just error } ! []

                _ ->
                    model ! []
        Retry ->
            case model.state of
                None ->
                    model ! []
                WaitingForCompute query ->
                    (model, sendComputeRequest query)
                WaitingForStatus requestID ->
                    (model, sendStatusRequest requestID)
                WaitingForResult requestID ->
                    (model, sendResultRequest requestID)


updateResultResponse: Result Http.Error ResultData -> Model -> (Model, Maybe TypesResult.Data)
updateResultResponse result model =
            case model.state of
                WaitingForResult requestID ->
                    case result of
                        Ok resultData ->
                            if resultData.requestID /= requestID then
                                (model, Nothing)
                            else
                                ({model | state = None}, Just resultData.result)

                        Err error ->
                            ({ model | error = Just error }, Nothing)

                _ ->
                    (model, Nothing)


sendComputeRequest : Query -> Cmd Types.Msg
sendComputeRequest query =
    let
        requestURL =
            apiRoot ++ "compute"

        requestBody =
            Http.emptyBody

        computeRequest =
            Http.post requestURL requestBody ApiJson.computeDecoder
    in
        Http.send (Types.computeMsg ComputeResponse) computeRequest


sendStatusRequest : String -> Cmd Types.Msg
sendStatusRequest requestID =
    let
        requestURL =
            apiRoot ++ "status/" ++ requestID

        statusRequest =
            Http.get requestURL ApiJson.statusDataDecoder
    in
        Http.send (Types.computeMsg StatusResponse) statusRequest


sendResultRequest : String -> Cmd Types.Msg
sendResultRequest requestID =
    let
        requestURL =
            apiRoot ++ "result/" ++ requestID

        resultRequest =
            Http.get requestURL ApiJson.resultDataDecoder
    in
        Http.send (Types.ComputeResultResponse) resultRequest
