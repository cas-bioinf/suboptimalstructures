module BLAST
    exposing
        ( Strand(..)
        , Result
        , Hit
        , Match
        )


type Strand
    = Plus
    | Minus


type alias Result =
    { title : String
    , hits : List Hit
    }


type alias Hit =
    { title : String
    , hsps : List Match
    }


type alias Match =
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
