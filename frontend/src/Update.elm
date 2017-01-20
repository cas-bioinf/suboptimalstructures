module Update exposing (update)

import Types exposing (..)
import TypesChooseAlignments
import TypesCompute
import UpdateInput
import UpdateChooseAlignments
import UpdateCompute
import Init


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputMsg inputMsg ->
            let
                ( inputModel, cmd ) =
                    UpdateInput.update inputMsg model.inputModel
            in
                ( { model | inputModel = inputModel }, cmd )

        ChooseAlignmentsMsg chaMsg ->
            let
                ( newModel, cmd ) =
                    UpdateChooseAlignments.update chaMsg model.chooseAlignmentsModel
            in
                ( { model | chooseAlignmentsModel = newModel }, cmd )

        ShowChooseAlignments results ->
            let
                ( newModel, cmd ) =
                    UpdateChooseAlignments.update (TypesChooseAlignments.Show results) model.chooseAlignmentsModel
            in
                ( { model
                    | state = ChooseAlignments
                    , chooseAlignmentsModel = newModel
                  }
                , cmd
                )

        RunQuery query ->
            let
                ( newModel, cmd ) =
                    UpdateCompute.update (TypesCompute.SendRequest query) model.computeModel
            in
                ( { model
                    | state = Compute
                    , computeModel = newModel
                  }
                , cmd
                )
        
        ComputeMsg computeMsg ->
            let
                ( newModel, cmd ) =
                    UpdateCompute.update computeMsg model.computeModel
            in 
                ( {model | computeModel = newModel}, cmd)

        ComputeResultResponse result ->
            let 
                (newModel, maybeData) = 
                    UpdateCompute.updateResultResponse result model.computeModel                
            in 
                case maybeData of
                    Just data ->
                        ({model | state = Result,
                            computeModel = newModel,
                            resultModel = { result = Just data }
                        }, Cmd.none )
                    Nothing ->
                        ({model | computeModel = newModel
                        }, Cmd.none )
        Reset ->
            Init.init   