module Init exposing (init)

import Types
import TypesInput
import TypesCompute
import Set


init : ( Types.Model, Cmd Types.Msg )
init =
    ( { state = Types.ChooseAlignments
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
      , computeModel = 
            { state = TypesCompute.None 
            , error = Nothing
            }
      , resultModel =
            { result = Nothing
            } 
      }
    , Cmd.none
    )
