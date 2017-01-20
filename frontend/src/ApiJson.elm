module ApiJson exposing (computeDecoder, statusDataDecoder, resultDataDecoder)

import Json.Decode as Decode
import TypesCompute exposing (..)


computeDecoder : Decode.Decoder String
computeDecoder =
    Decode.field "requestID" Decode.string


-- Checks whether requestID matches the provided ID
statusDataDecoder : Decode.Decoder StatusData
statusDataDecoder =
    Decode.map2 StatusData (requestIDDecoder) (Decode.field "status" requestStatusDecoder)


requestStatusDecoder : Decode.Decoder RequestStatus
requestStatusDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "Complete" ->
                        Decode.succeed Complete

                    "Running" ->
                        Decode.succeed Running

                    _ ->
                        Decode.fail ("Unrecognized status value: " ++ str)
            )

resultDataDecoder : Decode.Decoder ResultData 
resultDataDecoder =
    Decode.map2 ResultData (requestIDDecoder) (Decode.field "result" Decode.string)
    
requestIDDecoder : Decode.Decoder String
requestIDDecoder =
    Decode.field "requestID" Decode.string 