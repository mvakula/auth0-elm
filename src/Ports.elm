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
                    mapNewProfileData msgFromJS.data tagger onError

                _ ->
                    onError <| "Unexpected message from JS: " ++ toString msgFromJS
        )


mapNewProfileData : Json.Decode.Value -> (MsgFromJS -> msg) -> (String -> msg) -> msg
mapNewProfileData data tagger onError =
    case decodeProfileData data of
        Ok profileData ->
            tagger <| NewProfileData (Just profileData)

        Err e ->
            onError e


decodeProfileData : Json.Decode.Value -> Result String ProfileData
decodeProfileData data =
    Json.Decode.decodeValue profileDataDecoder data


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
    = NewProfileData (Maybe ProfileData)


type alias Data =
    { tag : String, data : Json.Encode.Value }


port toJS : Data -> Cmd msg


port fromJS : (Data -> msg) -> Sub msg
