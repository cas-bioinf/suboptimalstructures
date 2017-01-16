module Init exposing (init)

import Types

init : (Types.Model, Cmd Types.Msg)
init =
    ({state = Types.Welcome,
    requestID = Nothing,
    message = ""
    }, Cmd.none)