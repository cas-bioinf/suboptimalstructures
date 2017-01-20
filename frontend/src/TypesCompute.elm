module TypesCompute
    exposing
        ( Msg(..)
        , Model
        , State(..)
        , RequestStatus(..)
        , StatusData
        , ResultData
        , Query
        )

import BLAST
import Http
import TypesResult


type alias Query =
    List BLAST.Result


type Msg
    = SendRequest Query
    | ComputeResponse (Result Http.Error String)
    | Retry
    | StatusResponse (Result Http.Error StatusData)


type alias Model =
    { state : State
    , error : Maybe Http.Error
    }


type State
    = None
    | WaitingForCompute Query
    | WaitingForStatus String
    | WaitingForResult String


type RequestStatus
    = Complete
    | Running


type alias StatusData =
    { requestID : String
    , status : RequestStatus
    }


type alias ResultData =
    { requestID : String
    , result : TypesResult.Data
    }
