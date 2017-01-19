module TypesChooseAlignments
    exposing
        ( Msg(..)
        , Model
        , AlignmentIndex
        )

import BLAST
import Set


type Msg
    = Show (List BLAST.Result)
    | SelectionChagned AlignmentIndex Bool
    | SelectAll Bool


type alias Model =
    { resultsToChooseFrom : List BLAST.Result
    , ignoredAlignments : Set.Set AlignmentIndex
    }


type alias AlignmentIndex =
    ( Int, Int, Int )
