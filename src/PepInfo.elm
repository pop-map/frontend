module PepInfo exposing (PepInfo, decode, view)

import Html exposing (Html, p, text, div)
import Json.Decode as Decode
import UserInfo exposing (UserInfo)

type alias PepInfo =
    { content : String
    , user : UserInfo
    }

decode : Decode.Decoder PepInfo
decode = Decode.map2 PepInfo
    (Decode.field "content" Decode.string)
    (Decode.field "user" UserInfo.decode)

view : PepInfo -> Html a
view pep = div []
    [ p [] [ text "content: ", text pep.content ]
    , UserInfo.view pep.user
    ]
