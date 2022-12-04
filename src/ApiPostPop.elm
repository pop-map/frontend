port module ApiPostPop exposing (main)

import Angle exposing (Angle)
import Browser
import Html exposing (Html, button, div, h3, input, p, text)
import Html.Attributes exposing (class, placeholder, disabled)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Status
import UserAuth exposing (UserAuth)


port receiveUserAuthPop : (Decode.Value -> msg) -> Sub msg


type alias Model =
    { title : String
    , description : String
    , latitude : Angle
    , longitude : Angle
    , user : Maybe UserAuth
    , status : Status.Status
    }


type Msg
    = Title String
    | Description String
    | Send
    | Sent (Result Http.Error String)
    | Latitude Angle.Update
    | Longitude Angle.Update
    | Authenticate (Result Decode.Error UserAuth)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" Angle.default Angle.default Nothing Status.NeedAuth, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        [ h3 [] [ text "Post a pop" ]
        , Angle.form "latitude" Latitude
        , Angle.form "longitude" Longitude
        , input [ placeholder "title", onInput Title ] []
        , input [ placeholder "description", onInput Description ] []
        , button [ onClick Send, disabled (model.user == Nothing || model.status == Status.Loading)] [ text "send" ]
        , Status.view model.status
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Authenticate (Ok user) ->
            ( {model | user = Just user, status = Status.None }, Cmd.none )
        
        Authenticate (Err _) ->
            ( model, Cmd.none )

        Title title ->
            ( { model | title = title }, Cmd.none )

        Description description ->
            ( { model | description = description }, Cmd.none )

        Latitude updater ->
            ( { model | latitude = updater model.latitude }, Cmd.none )

        Longitude updater ->
            ( { model | longitude = updater model.longitude }, Cmd.none )

        Send ->
            ( { model | status = Status.Loading }
            , Http.post
                { url = "https://popmap.org/api/pop"
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "title", Encode.string model.title )
                            , ( "description", Encode.string model.description )
                            , ( "user"
                              , UserAuth.encode <| Maybe.withDefault UserAuth.default model.user
                              )
                            , ( "location"
                              , Encode.object
                                    [ ( "lat", Angle.encode model.latitude )
                                    , ( "lng", Angle.encode model.longitude )
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
        , subscriptions = \_ -> receiveUserAuthPop (Authenticate << Decode.decodeValue (UserAuth.decode))
        }
