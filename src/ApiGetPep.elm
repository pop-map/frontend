module ApiGetPep exposing (main)

import Browser
import Html exposing (Html, button, div, h3, input, li, p, text, ul)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import PepInfo exposing (PepInfo)
import Status


type alias Model =
    { popId : String
    , pepIndex : Int
    , pepInfo : Maybe PepInfo
    , status : Status.Status
    }


type Msg
    = InputId String
    | InputIndex String
    | Fetch
    | Received (Result Http.Error PepInfo)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" 0 Nothing Status.None, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "api-block" ]
        ([ h3 [] [ text "Get specific pep" ]
         , input [ onInput InputId, placeholder "pop uuid" ] []
         , input [ onInput InputIndex, placeholder "pep index", type_ "number" ] []
         , button [ onClick Fetch ] [ text "Fetch pep" ]
         , Status.view model.status
         ]
            ++ (case model.pepInfo of
                    Just pepInfo ->
                        [ PepInfo.view pepInfo ]

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

        InputIndex index ->
            ( { model | pepIndex = String.toInt index |> Maybe.withDefault 0 }
            , Cmd.none
            )

        Fetch ->
            ( { model | status = Status.Loading }
            , Http.get
                { url = "http://127.0.0.1:5000/in/" ++ model.popId ++ "/" ++ String.fromInt model.pepIndex
                , expect = Http.expectJson Received PepInfo.decode
                }
            )

        Received (Ok pepInfo) ->
            ( { model | pepInfo = Just pepInfo, status = Status.Success }, Cmd.none )

        Received (Err _) ->
            ( { model | status = Status.Failed }, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
