module ApiGetPop exposing (main)

import Browser
import Html exposing (Html, button, div, h3, hr, input, li, p, text, ul)
import Html.Attributes exposing (class, placeholder, disabled)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import PopInfo exposing (PopInfo)
import Status


type alias Model =
    { popId : String
    , popInfo : Maybe PopInfo
    , status : Status.Status
    }


type Msg
    = InputId String
    | Fetch
    | Received (Result Http.Error PopInfo)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" Nothing Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        ([ h3 [] [ text "Get specific pop" ]
         , input [ onInput InputId, placeholder "pop uuid" ] []
         , button [ onClick Fetch, disabled (model.status == Status.Loading) ] [ text "fetch" ]
         , Status.view model.status
         ]
            ++ (case model.popInfo of
                    Just popInfo ->
                        [ PopInfo.view popInfo ]

                    Nothing ->
                        []
               )
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputId id ->
            ( { model | popId = id }
            , Cmd.none
            )

        Fetch ->
            ( { model | status = Status.Loading }
            , Http.get
                { url = "https://popmap.org/api/pop/" ++ model.popId
                , expect = Http.expectJson Received PopInfo.decode
                }
            )

        Received (Ok popInfo) ->
            ( { model | popInfo = Just popInfo, status = Status.Success }, Cmd.none )

        Received (Err _) ->
            ( { model | status = Status.Failed }, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
