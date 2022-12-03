module UserInfo exposing (UserInfo, decode, view)

import Html exposing (Html, div, img, p, span, text)
import Html.Attributes exposing (class, src)
import Json.Decode as Decode


type alias UserInfo =
    { id : Int
    , firstName : String
    , lastName : String
    , photoUrl : String
    }


decode : Decode.Decoder UserInfo
decode =
    Decode.map4 UserInfo
        (Decode.field "id" Decode.int)
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)
        (Decode.field "photo_url" Decode.string)


view : UserInfo -> Html a
view user =
    div [ class "user-card" ]
        [ img [ src user.photoUrl ] []
        , span [ class "first-name" ] [ text user.firstName ]
        , span [ class "last-name" ] [ text user.lastName ]
        , span [ class "telegram-id" ] [ text (String.fromInt user.id) ]
        ]
