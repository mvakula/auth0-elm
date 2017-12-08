module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Events exposing (onClick)
import Json.Decode
import Ports


---- MODEL ----


type alias Model =
    { profileData : Maybe Ports.ProfileData }


init : Flags -> ( Model, Cmd Msg )
init initialUser =
    case initialUser of
        Just profileData ->
            ( { profileData = mapInitialUser (profileData) }, Cmd.none )

        Nothing ->
            ( { profileData = Nothing }, Cmd.none )


mapInitialUser : Json.Decode.Value -> Maybe Ports.ProfileData
mapInitialUser initialUser =
    case Ports.decodeProfileData initialUser of
        Ok profileData ->
            Just profileData

        Err e ->
            Nothing



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


type alias Flags =
    Maybe Json.Decode.Value


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
