module Types
    exposing
        ( Msg(..)
        , State(..)
        , Model
        , inputMsg
        , chooseAlignmentsMsg
        , computeMsg
        )

import TypesInput
import TypesChooseAlignments
import TypesCompute
import TypesResult
import BLAST
import Http


type Msg
    = InputMsg TypesInput.Msg
    | ShowChooseAlignments (List BLAST.Result)
    | ChooseAlignmentsMsg TypesChooseAlignments.Msg
    | RunQuery TypesCompute.Query
    | ComputeMsg TypesCompute.Msg
    | ComputeResultResponse (Result Http.Error TypesCompute.ResultData)
    | Reset


type State
    = Input
    | ChooseAlignments
    | Compute
    | Result


type alias Model =
    { state : State
    , inputModel : TypesInput.Model
    , chooseAlignmentsModel : TypesChooseAlignments.Model
    , computeModel : TypesCompute.Model
    , resultModel : TypesResult.Model
    }


inputMsg : (a -> TypesInput.Msg) -> (a -> Msg)
inputMsg msg a =
    InputMsg (msg a)


chooseAlignmentsMsg : (a -> TypesChooseAlignments.Msg) -> (a -> Msg)
chooseAlignmentsMsg msg a =
    ChooseAlignmentsMsg (msg a)


computeMsg : (a -> TypesCompute.Msg) -> (a -> Msg)
computeMsg msg a =
    ComputeMsg (msg a)
