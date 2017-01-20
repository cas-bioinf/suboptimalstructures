module TypesResult
    exposing
        ( Msg
        , Model
        , Data
        )


type Msg
    = NoOp


type alias Model =
    { result : Maybe Data
    }

type alias Data = String
