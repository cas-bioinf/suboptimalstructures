module BLAST
    exposing
        ( Strand(..)
        , Result
        , SequenceResult
        , Alignment
        )


type Strand
    = Plus
    | Minus


type alias Result =
    { queryTitle : String
    , sequenceResults : List SequenceResult
    }


type alias SequenceResult =
    { sequenceTitle : String
    , alignments : List Alignment
    }


type alias Alignment =
    { score : Float
    , queryFrom : Int
    , queryTo : Int
    , queryStrand : Strand
    , hitFrom : Int
    , hitTo : Int
    , hitStrand : Strand
    , querySequence : String
    , hitSequence : String
    , midLine : String
    }
