port module Ports exposing (..)

import Json.Encode


sendToJS : Msg -> Cmd msg
sendToJS msg =
    case msg of
        ShowLock ->
            toJS { tag = "ShowLock", data = Json.Encode.null }

        LogOut ->
            toJS { tag = "LogOut", data = Json.Encode.null }



-- getFromJS : (Data -> msg) (String -> msg) -> Sub msg
-- getFromJS tagger onError =
-- For implentation see: https://github.com/splodingsocks/a-very-im-port-ant-topic/blob/master/example/src/OutsideInfo.elm
--     fromJS
--         (\data ->
--             case data.tag of
--         )


type Msg
    = ShowLock
    | LogOut


type alias Data =
    { tag : String, data : Json.Encode.Value }


port toJS : Data -> Cmd msg


port fromJS : (Data -> msg) -> Sub msg
