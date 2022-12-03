module PopInfo exposing (PopInfo, decode, view)

import Angle exposing (Angle)
import Html exposing (Html, div, h3, p, pre, span, text)
import Html.Attributes exposing (class)
import Instant
import Json.Decode as Decode
import UserInfo exposing (UserInfo)


type alias PopInfo =
    { title : String
    , description : String
    , created : Int
    , peps : Int
    , user : UserInfo
    , latitude : Angle
    , longitude : Angle
    }


view : PopInfo -> Html a
view pop =
    div [ class "pop-card" ]
        [ p [ class "pop-context" ]
            [ UserInfo.view pop.user
            , Instant.view pop.created
            , span [ class "geolocation" ]
                [ Angle.view pop.latitude
                , text " / "
                , Angle.view pop.longitude
                ]
            ]
        , h3 [ class "pop-title" ] [ text pop.title ]
        , p [ class "pop-description" ] [ text pop.description ]
        , p [ class "peps-cardinal" ]
            [ text (String.fromInt pop.peps)
            , text
                (if pop.peps > 1 then
                    " responses"

                 else
                    " response"
                )
            ]
        ]


decode : Decode.Decoder PopInfo
decode =
    Decode.map7 PopInfo
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "created" Decode.int)
        (Decode.field "peps" Decode.int)
        (Decode.field "user" UserInfo.decode)
        (Decode.field "location" <| Decode.field "lat" Angle.decode)
        (Decode.field "location" <| Decode.field "lng" Angle.decode)
