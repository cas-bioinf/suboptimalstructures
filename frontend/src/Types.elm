module Types
    exposing
        ( Msg(..)
        , State(..)
        , Model
        , inputMsg
        , chooseAlignmentsMsg
        )

import TypesInput
import TypesChooseAlignments
import BLAST


type Msg
    = InputMsg TypesInput.Msg
    | ShowChooseAlignments (List BLAST.Result)
    | ChooseAlignmentsMsg TypesChooseAlignments.Msg


type State
    = Input
    | ChooseAlignments


type alias Model =
    { state : State
    , inputModel : TypesInput.Model
    , chooseAlignmentsModel : TypesChooseAlignments.Model
    }


inputMsg : (a -> TypesInput.Msg) -> (a -> Msg)
inputMsg msg a =
    InputMsg (msg a)


chooseAlignmentsMsg : (a -> TypesChooseAlignments.Msg) -> (a -> Msg)
chooseAlignmentsMsg msg a =
    ChooseAlignmentsMsg (msg a)
