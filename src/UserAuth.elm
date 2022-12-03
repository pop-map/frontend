module UserAuth exposing (UserAuth, default, encode, decode)

import Json.Encode as Encode
import Json.Decode as Decode


type alias UserAuth =
    { id : Int
    , authDate : Int
    , firstName : String
    , lastName : String
    , photoUrl : String
    , hash : String
    }


default : UserAuth
default =
    { id = 777111
    , authDate = 0
    , firstName = "David"
    , lastName = "Iwanoa"
    , photoUrl = "https://popmap.org/popmap.jpg"
    , hash = String.repeat 64 "0"
    }


encode : UserAuth -> Encode.Value
encode user =
    Encode.object
        [ ( "id", Encode.int user.id )
        , ( "auth_date", Encode.int user.authDate )
        , ( "first_name", Encode.string user.firstName )
        , ( "last_name", Encode.string user.lastName )
        , ( "photo_url", Encode.string user.photoUrl )
        , ( "hash", Encode.string user.hash )
        ]

decode : Decode.Decoder UserAuth
decode = Decode.map6 UserAuth
    (Decode.field "id" Decode.int)
    (Decode.field "auth_date" Decode.int)
    (Decode.field "first_name" Decode.string)
    (Decode.field "last_name" Decode.string)
    (Decode.field "photo_url" Decode.string)
    (Decode.field "hash" Decode.string)
