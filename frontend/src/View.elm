module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attributes
import Types
import ViewInput
import ViewChooseAlignments
import ViewCompute
import ViewResult


view : Types.Model -> Html Types.Msg
view model =
    div [ Attributes.class "wrapper" ]
        ((h1 [] [ text ("Suboptimal structures") ])
            :: (case model.state of
                    Types.Input ->
                        ViewInput.view model.inputModel

                    Types.ChooseAlignments ->
                        ViewChooseAlignments.view model.chooseAlignmentsModel

                    Types.Compute ->
                        ViewCompute.view model.computeModel

                    Types.Result ->
                        ViewResult.view model.resultModel
               )
        )
