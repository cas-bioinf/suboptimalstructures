module Types exposing(
    Msg(..), State(..), Model
    )

import Http

type Msg
  = ShowEnterRequestID
  | RequestIDChanged String
  | RequestIDSubmit
  | SearchCompleteResult (Result Http.Error String)

type State 
    = Welcome
    | EnterRequestID 
    | CheckingSearchComplete     
    | FetchingResult
--    | ShowResult

type alias Model =
    {
        state: State,
        requestID: Maybe String,
        message: String
    }

