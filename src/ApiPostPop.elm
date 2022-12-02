module ApiPostPop exposing (main)

import Browser
import Html exposing (Html, button, div, input, p, text, h3)
import Html.Attributes exposing (placeholder, class)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode

import Status
import UserAuth exposing (UserAuth)


type alias Model =
    { title : String
    , description : String
    , status : Status.Status
    }


type Msg
    = Title String
    | Description String
    | Send
    | Sent (Result Http.Error String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Post a pop"]
        , input [ placeholder "title", onInput Title ] []
        , input [ placeholder "description", onInput Description ] []
        , button [ onClick Send ] [ text "send" ]
        , Status.view model.status
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Title title ->
            ( { model | title = title }, Cmd.none )

        Description description ->
            ( { model | description = description }, Cmd.none )

        Send ->
            ( { model | status = Status.Loading }
            , Http.post
                { url = "http://127.0.0.1:5000/pop"
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "title", Encode.string model.title )
                            , ( "description", Encode.string model.description )
                            , ( "user"
                              , UserAuth.encode UserAuth.default
                              )
                            , ( "location"
                              , Encode.object
                                    [ ( "lat", Encode.list Encode.int [ 0, 0, 0 ] )
                                    , ( "lng", Encode.list Encode.int [ 0, 0, 0 ] )
                                    ]
                              )
                            , ( "expire", Encode.int 0 )
                            ]
                        )
                , expect = Http.expectJson Sent Decode.string
                }
            )

        Sent (Err _) ->
            ( { model | status = Status.Failed }, Cmd.none )

        Sent (Ok _) ->
            ( { model | status = Status.Success }, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
