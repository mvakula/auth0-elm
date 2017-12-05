module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Events exposing (onClick)
import Ports


---- MODEL ----


type alias Model =
    { profileData : Ports.ProfileData }


initProfileData : Ports.ProfileData
initProfileData =
    { profile = initUserProfile
    , token = ""
    }


initUserProfile : Ports.UserProfile
initUserProfile =
    { email = ""
    , email_verified = False
    }


init : ( Model, Cmd Msg )
init =
    ( { profileData = initProfileData }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | LogErr String
    | ShowLock
    | LogOut
    | FromJS Ports.MsgFromJS


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LogErr err ->
            logErr err model

        ShowLock ->
            ( model, (Ports.sendToJS Ports.ShowLock) )

        LogOut ->
            ( model, Cmd.none )

        FromJS msgFromJS ->
            case msgFromJS of
                Ports.NewProfileData profileData ->
                    ( { model | profileData = profileData }, Cmd.none )


logErr : String -> Model -> ( Model, Cmd Msg )
logErr err model =
    let
        e =
            Debug.log "LogErr" err
    in
        ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ onClick ShowLock ]
        [ div [] [ text "Log in" ]
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.getFromJS FromJS LogErr



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
