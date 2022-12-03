module PopInfo exposing (PopInfo, decode, view)

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
    }


view : PopInfo -> Html a
view pop =
    div [ class "pop-card" ]
        [ p [ class "pop-context" ]
            [ UserInfo.view pop.user
            , Instant.view pop.created
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
    Decode.map5 PopInfo
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "created" Decode.int)
        (Decode.field "peps" Decode.int)
        (Decode.field "user" UserInfo.decode)
