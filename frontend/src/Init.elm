module Init exposing (init)

import Types
import Set

init : ( Types.Model, Cmd Types.Msg )
init =
    ( { state = Types.EnterBLASTResult
      , requestID = Nothing
      , message = ""
      , blastTextResult = Nothing
      , blastFileResult = Nothing
      , resultsToChooseFrom = []
      , ignoredAlignments = Set.empty
      }
    , Cmd.none
    )
