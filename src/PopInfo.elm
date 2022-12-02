module PopInfo exposing (PopInfo, decode, view)

import Html exposing (Html, div, p, text)
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
    div []
        [ p [] [ text pop.title ]
        , p [] [ text pop.description ]
        , p [] [ text "created UNIX-TIME ", text (String.fromInt pop.created) ]
        , p [] [ text "number of peps ", text (String.fromInt pop.peps) ]
        ]


decode : Decode.Decoder PopInfo
decode =
    Decode.map5 PopInfo
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "created" Decode.int)
        (Decode.field "peps" Decode.int)
        (Decode.field "user" UserInfo.decode)
