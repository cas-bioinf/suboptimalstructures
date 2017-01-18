module BLASTJson exposing (decoder)

import Json.Decode exposing (..)
import Json.Decode.Pipeline as Pipeline
import BLAST


decoder : Decoder (List BLAST.Result)
decoder =
    field "BlastOutput2" <|
        list <|
            field "report" <|
                field "results" <|
                    field "search" <|
                        map2 BLAST.Result
                            (field "query_title" string)
                            (field "hits" <| list hitDecoder)


hitDecoder : Decoder BLAST.SequenceResult
hitDecoder =
    map2 BLAST.SequenceResult
        (field "description" <| index 0 <| field "title" string)
        (field "hsps" <| list matchDecoder)


matchDecoder : Decoder BLAST.Alignment
matchDecoder =
    Pipeline.decode BLAST.Alignment
        |> Pipeline.required "score" float
        |> Pipeline.required "query_from" int
        |> Pipeline.required "query_to" int
        |> Pipeline.required "query_strand" strandDecoder
        |> Pipeline.required "hit_from" int
        |> Pipeline.required "hit_to" int
        |> Pipeline.required "hit_strand" strandDecoder
        |> Pipeline.required "qseq" string
        |> Pipeline.required "hseq" string
        |> Pipeline.required "midline" string


strandDecoder : Decoder BLAST.Strand
strandDecoder =
    andThen
        (\strand ->
            case strand of
                "Plus" ->
                    succeed BLAST.Plus

                "Minus" ->
                    succeed BLAST.Minus

                _ ->
                    fail ("Unrecognized strand type:" ++ strand)
        )
        string
