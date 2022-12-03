module Instant exposing (view)

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Time exposing (Month(..), Posix, Zone, millisToPosix, toDay, toHour, toMinute, toMonth, toYear, utc)


toMonthIndex : Month -> String
toMonthIndex month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


toMonthShort : Month -> String
toMonthShort month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"

stringLeftPadding : Int -> Char -> String -> String
stringLeftPadding len char str =
    (String.repeat len (String.fromChar char) ++ str) |> String.right (max len <| String.length str)

view : Int -> Html a
view time =
    let
        posix =
            millisToPosix (time * 1000)
    in
    span [ class "date" ]
        [ text "utc "
        , text (String.fromInt (toYear utc posix))
        , text " "
        , text (toMonthShort (toMonth utc posix))
        , text " "
        , text (String.fromInt (toDay utc posix))
        , text " "
        , text (String.fromInt (toHour utc posix))
        , text ":"
        , text (stringLeftPadding 2 '0' <| String.fromInt (toMinute utc posix))
        ]
