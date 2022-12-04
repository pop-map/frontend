module ApiGetArea exposing (main)

import Angle exposing (Angle)
import Browser
import Html exposing (Html, button, div, h3, input, li, p, pre, text, ul)
import Html.Attributes as Attr exposing (class, placeholder, type_, disabled)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Status


type alias Model =
    { latitude : Angle
    , longitude : Angle
    , radius : Int
    , list : List String
    , status : Status.Status
    }


type Msg
    = Fetch
    | Received (Result Http.Error (List String))
    | InputLatitude Angle.Update
    | InputLongitude Angle.Update
    | InputRadius Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Angle.default Angle.default 1 [] Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Get in area" ]
        , Angle.form "latitude" InputLatitude
        , Angle.form "longitude" InputLongitude
        , input [ class "radius", Attr.min "1", onInput (\s -> String.toInt s |> Maybe.withDefault 0 |> InputRadius), placeholder "radius in meter", type_ "number" ] []
        , div [ class "action-group" ]
            [ button [ onClick Fetch, disabled (model.status == Status.Loading) ] [ text "fetch" ]
            , Status.view model.status
            ]
        , div [ class "uuid-list" ] (List.map (\s -> pre [] [ text s ]) model.list)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( { model | status = Status.Loading }
            , Http.post
                { url = "https://popmap.org/api/area"
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "lat", Angle.encode model.latitude )
                            , ( "lng", Angle.encode model.longitude )
                            , ( "radius", Encode.int 10 )
                            ]
                        )
                , expect = Http.expectJson Received (Decode.list Decode.string)
                }
            )

        Received (Ok list) ->
            ( { model | list = list, status = Status.Success }, Cmd.none )

        Received (Err _) ->
            ( { model | status = Status.Failed }, Cmd.none )

        InputLatitude updater ->
            ( { model | latitude = updater model.latitude }, Cmd.none )

        InputLongitude updater ->
            ( { model | longitude = updater model.longitude }, Cmd.none )

        InputRadius radius ->
            ( { model | radius = radius }, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
