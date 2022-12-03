module Angle exposing (Angle, Update, form, decode, encode, default)

import Html exposing (Html, div, input)
import Html.Attributes as Attr exposing (class, placeholder, type_)
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Json.Encode as Encode

type alias Update = (Angle -> Angle)

default : Angle
default = Angle 0 0 0


updateDeg : String -> Update
updateDeg deg angle =
    { angle | deg = deg |> String.toInt |> Maybe.withDefault 0 }

updateMin : String -> Update
updateMin min angle =
    { angle | min = min |> String.toInt |> Maybe.withDefault 0 }

updateSec : String -> Update
updateSec sec angle =
    { angle | sec = sec |> String.toInt |> Maybe.withDefault 0 }


form : String -> (Update -> a) -> Html a
form angle msg =
    div [ class "angle-form" ]
        {- TODO: try (msg <| updateDeg) -}
        [ input [ class "degree", onInput (\s -> msg <| updateDeg s), placeholder (angle ++ " degree"), type_ "number", Attr.min "-179", Attr.max "180" ] []
        , input [ class "minute", onInput (\s -> msg <| updateMin s), placeholder "minute", type_ "number", Attr.min "0", Attr.max "59" ] []
        , input [ class "second", onInput (\s -> msg <| updateSec s), placeholder "second", type_ "number", Attr.min "0", Attr.max "59" ] []
        ]

type alias Angle =
    { deg : Int
    , min : Int
    , sec : Int
    }

decode : Decode.Decoder Angle
decode = Decode.map3 Angle
    (Decode.index 0 Decode.int)
    (Decode.index 1 Decode.int)
    (Decode.index 2 Decode.int)

encode : Angle -> Encode.Value
encode angle = Encode.list Encode.int [angle.deg, angle.min, angle.sec]
