module Types
    exposing
        ( Msg(..)
        , State(..)
        , Model        
        , MaybeParsingResult
        , AlignmentIndex
        )

import Http
import BLAST
import FileReader
import Set

type Msg
    = ShowWelcome
    | ShowEnterRequestID
    | ShowEnterBLASTResult
    | RequestIDChanged String
    | RequestIDSubmit
    | SearchCompleteResult (Result Http.Error String)
    | BLASTTextChanged String
    | BLASTFileChosen (List FileReader.NativeFile)
    | BLASTFileRead (Result FileReader.Error String)
    | ShowChooseBLASTAlignments (List BLAST.Result)
    | BLASTAlignmentSelectionChagned AlignmentIndex Bool
    | SelectAllBLASTAlignments Bool

type alias Model =
    { state : State
    , requestID : Maybe String
    , message : String
    , blastTextResult : MaybeParsingResult
    , blastFileResult : MaybeParsingResult
    , resultsToChooseFrom: List BLAST.Result
    , ignoredAlignments: Set.Set AlignmentIndex
    }


type State
    = Welcome
    | EnterRequestID
    | CheckingSearchComplete
    | FetchingResult
    | EnterBLASTResult
    | ChooseBLASTAlignments


type alias MaybeParsingResult =
    Maybe (Result String (List BLAST.Result))

type alias AlignmentIndex = (Int,Int,Int) 
 

