module ApiGetArea exposing (main)

import Browser
import Html exposing (Html, button, div, h3, input, li, p, pre, text, ul)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Status


type alias Model =
    { list : List String
    , status : Status.Status
    }


type Msg
    = Fetch
    | Received (Result Http.Error (List String))


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Get in area" ]
        , div [ class "action-group" ]
            [ button [ onClick Fetch ] [ text "Fetch in area" ]
            , Status.view model.status
            ]
        , div [] (List.map (\s -> pre [] [ text s ]) model.list)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( { model | status = Status.Loading }
            , Http.post
                { url = "http://popmap.org/api/area"
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "lat", Encode.list Encode.int [ 0, 0, 0 ] )
                            , ( "lng", Encode.list Encode.int [ 0, 0, 0 ] )
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


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
