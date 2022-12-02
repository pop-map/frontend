module UserInfo exposing (UserInfo, decode, view)

import Html exposing (Html, div, p, text)
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
    div []
        [ p [] [ text "id: ", text (String.fromInt user.id) ]
        , p [] [ text "first name: ", text user.firstName ]
        , p [] [ text "last name: ", text user.lastName ]
        ]
