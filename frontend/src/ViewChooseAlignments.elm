module ViewChooseAlignments exposing (view)

import Html exposing (..)
import TypesChooseAlignments exposing (..)
import Types
import Html.Attributes as Attributes
import Html.Events as Events
import BLAST
import ViewUtils
import Set


view : Model -> List (Html Types.Msg)
view model =
    [ h2 [] [ text "Choose BLAST matches" ]
    , button [ Events.onClick (Types.ChooseAlignmentsMsg (SelectAll True)) ] [ text "Select All" ]
    , button [ Events.onClick (Types.ChooseAlignmentsMsg (SelectAll False)) ] [ text "Select None" ]
    , button [ Events.onClick (Types.RunQuery (model.resultsToChooseFrom)) ] [ text "Find Homologs" ]
    , ol [ Attributes.class "resultList" ]
        (model.resultsToChooseFrom
            |> List.indexedMap (viewResult model.ignoredAlignments)
        )
    ]


viewResult : Set.Set AlignmentIndex -> Int -> BLAST.Result -> Html Types.Msg
viewResult ignoredMatches resultIndex result =
    li []
        [ text "Query: "
        , em [ Attributes.class "blastQuery" ] [ text result.queryTitle ]
        , ol [] (result.sequenceResults |> List.indexedMap (viewSequenceResult ignoredMatches resultIndex))
        ]


viewSequenceResult : Set.Set AlignmentIndex -> Int -> Int -> BLAST.SequenceResult -> Html Types.Msg
viewSequenceResult ignoredMatches resultIndex sequenceIndex sequenceResult =
    li []
        [ text "Sequence: "
        , em [] [ text sequenceResult.sequenceTitle ]
        , ol [] (sequenceResult.alignments |> List.indexedMap (viewAlignment ignoredMatches resultIndex sequenceIndex))
        ]


viewAlignment : Set.Set AlignmentIndex -> Int -> Int -> Int -> BLAST.Alignment -> Html Types.Msg
viewAlignment ignoredMatches resultIndex sequenceIndex alignmentIndex alignment =
    let
        compoundIndex =
            ( resultIndex, sequenceIndex, alignmentIndex )

        ignored =
            Set.member compoundIndex ignoredMatches
    in
        li []
            [ input [ Attributes.type_ "checkbox", Attributes.checked (not ignored), Events.onCheck (Types.chooseAlignmentsMsg (SelectionChagned compoundIndex)) ] []
            , pre [] [ text (alignment.querySequence ++ "\n" ++ alignment.midLine ++ "\n" ++ alignment.hitSequence) ]
            ]
