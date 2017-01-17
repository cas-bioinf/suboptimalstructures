module Types
    exposing
        ( Msg(..)
        , State(..)
        , Model        
        , MaybeParsingResult
        )

import Http
import BLAST

type Msg
    = ShowEnterRequestID
    | ShowEnterBLASTResult
    | RequestIDChanged String
    | RequestIDSubmit
    | SearchCompleteResult (Result Http.Error String)
    | BLASTTextChanged String


type State
    = Welcome
    | EnterRequestID
    | CheckingSearchComplete
    | FetchingResult
    | EnterBLASTResult



--    | ShowResult

type alias MaybeParsingResult =
    Maybe (Result String (List BLAST.Result))

type alias Model =
    { state : State
    , requestID : Maybe String
    , message : String
    , blastTextResult : MaybeParsingResult
    }
