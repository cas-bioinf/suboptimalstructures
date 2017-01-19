module UpdateChooseAlignments exposing (update)

import TypesChooseAlignments exposing (..)
import Types
import Set


update : Msg -> Model -> ( Model, Cmd Types.Msg )
update msg model =
    case msg of
        Show results ->
            { model
                | resultsToChooseFrom = results
                , ignoredAlignments = Set.empty
            }
                ! []

        SelectionChagned alignmentIndex selected ->
            let
                newIgnoredAlignments =
                    if selected then
                        Set.remove alignmentIndex model.ignoredAlignments
                    else
                        Set.insert alignmentIndex model.ignoredAlignments
            in
                { model | ignoredAlignments = newIgnoredAlignments } ! []

        SelectAll selected ->
            let
                newIgnoredAlignments =
                    if selected then
                        Set.empty
                    else
                        Set.fromList
                            (model.resultsToChooseFrom
                                |> List.indexedMap
                                    (\resultIndex result ->
                                        result.sequenceResults
                                            |> List.indexedMap
                                                (\sequenceIndex sequenceResult ->
                                                    sequenceResult.alignments |> List.indexedMap (\alignmentIndex _ -> ( resultIndex, sequenceIndex, alignmentIndex ))
                                                )
                                            |> List.foldl (++) []
                                    )
                                |> List.foldl (++) []
                            )

                --TODO
            in
                { model | ignoredAlignments = newIgnoredAlignments } ! []

