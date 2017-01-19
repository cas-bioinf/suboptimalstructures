module Update exposing (update)

import Types exposing (..)
import TypesChooseAlignments
import UpdateInput
import UpdateChooseAlignments


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
