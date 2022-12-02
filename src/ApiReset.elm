module ApiReset exposing (main)

import Browser
import Html exposing (Html, button, div, h3, input, li, p, pre, text, ul)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Status exposing (Status)


type alias Model =
    { status : Status
    }


type Msg
    = Send
    | Received (Result Http.Error ())


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Server reset" ]
        , div [ class "action-group" ]
            [ button [ onClick Send ] [ text "Clear all data" ]
            , Status.view model.status
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Send ->
            ( { model | status = Status.Loading }
            , Http.get
                { url = "https://popmap.org/api/reset"
                , expect = Http.expectJson Received (Decode.null ())
                }
            )

        Received (Ok _) ->
            ( { model | status = Status.Success }, Cmd.none )

        Received (Err _) ->
            ( { model | status = Status.Failed }, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
