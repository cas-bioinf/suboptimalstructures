module Init exposing (init)

import Types
import TypesInput
import Set


init : ( Types.Model, Cmd Types.Msg )
init =
    ( { state = Types.Input
      , inputModel =
            { state = TypesInput.EnterBLASTResult
            , requestID = Nothing
            , message = ""
            , blastTextResult = Nothing
            , blastFileResult = Nothing
            }
      , chooseAlignmentsModel =
            { resultsToChooseFrom = []
            , ignoredAlignments = Set.empty
            }
      }
    , Cmd.none
    )
