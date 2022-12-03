module PepInfo exposing (PepInfo, decode, view)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Instant
import Json.Decode as Decode
import UserInfo exposing (UserInfo)


type alias PepInfo =
    { content : String
    , user : UserInfo
    , created : Int
    }


decode : Decode.Decoder PepInfo
decode =
    Decode.map3 PepInfo
        (Decode.field "content" Decode.string)
        (Decode.field "user" UserInfo.decode)
        (Decode.field "created" Decode.int)


view : PepInfo -> Html a
view pep =
    div [ class "pep-card" ]
        [ p [ class "pep-context" ]
            [ UserInfo.view pep.user
            , Instant.view pep.created
            ]
        , p [ class "pep-content" ] [ text pep.content ]
        ]
