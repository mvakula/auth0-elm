port module Ports exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, optionalAt, hardcoded)


sendToJS : MsgToJS -> Cmd msg
sendToJS msg =
    case msg of
        ShowLock ->
            toJS { tag = "ShowLock", data = Json.Encode.null }

        LogOut ->
            toJS { tag = "LogOut", data = Json.Encode.null }


getFromJS : (MsgFromJS -> msg) -> (String -> msg) -> Sub msg
getFromJS tagger onError =
    fromJS
        (\msgFromJS ->
            case msgFromJS.tag of
                "NewProfileData" ->
                    case Json.Decode.decodeValue (profileDataDecoder) msgFromJS.data of
                        Ok profileData ->
                            tagger <| NewProfileData profileData

                        Err e ->
                            onError e

                _ ->
                    onError <| "Unexpected message from JS: " ++ toString msgFromJS
        )


profileDataDecoder : Json.Decode.Decoder ProfileData
profileDataDecoder =
    decode ProfileData
        |> required "profile" userProfileDecoder
        |> required "token" Json.Decode.string


userProfileDecoder : Json.Decode.Decoder UserProfile
userProfileDecoder =
    decode UserProfile
        |> required "email" Json.Decode.string
        |> optional "email_verified" Json.Decode.bool False


type alias ProfileData =
    { profile : UserProfile
    , token : String
    }


type alias UserProfile =
    { email : String
    , email_verified : Bool
    }


type MsgToJS
    = ShowLock
    | LogOut


type MsgFromJS
    = NewProfileData ProfileData


type alias Data =
    { tag : String, data : Json.Encode.Value }


port toJS : Data -> Cmd msg


port fromJS : (Data -> msg) -> Sub msg
