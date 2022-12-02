module ApiPostPep exposing (main)

import Browser
import Html exposing (Html, button, div, h3, input, p, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Status
import UserAuth exposing (UserAuth)


type alias Model =
    { inPopId : String
    , content : String
    , status : Status.Status
    }


type Msg
    = InputInPopId String
    | InputContent String
    | Send
    | Sent (Result Http.Error Int)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Post a pep" ]
        , input [ placeholder "Pop id", onInput InputInPopId ] []
        , input [ placeholder "content", onInput InputContent ] []
        , button [ onClick Send ] [ text "send" ]
        , Status.view model.status
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputInPopId inPopId ->
            ( { model | inPopId = inPopId }, Cmd.none )

        InputContent content ->
            ( { model | content = content }, Cmd.none )

        Send ->
            ( { model | status = Status.Loading }
            , Http.post
                { url = "https://popmap.org/api/in/" ++ model.inPopId
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "content", Encode.string model.content )
                            , ( "user", UserAuth.encode UserAuth.default )
                            ]
                        )
                , expect = Http.expectJson Sent Decode.int
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
