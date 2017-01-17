module Init exposing (init)

import Types


init : ( Types.Model, Cmd Types.Msg )
init =
    ( { state = Types.EnterBLASTResult
      , requestID = Nothing
      , message = ""
      , blastTextResult = Nothing
      }
    , Cmd.none
    )
