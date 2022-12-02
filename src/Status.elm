module Status exposing (Status(..), view)

import Html exposing (Html, p, span, text)
import Html.Attributes exposing (class)


type Status
    = None
    | Loading
    | Success
    | Failed


view : Status -> Html a
view status =
    case status of
        None ->
            span [ class "request-status", class "request-status-none" ] [ text "" ]

        Loading ->
            span [ class "request-status", class "request-status-loading" ] [ text "loading" ]

        Success ->
            span [ class "request-status", class "request-status-success" ] [ text "success" ]

        Failed ->
            span [ class "request-status", class "request-status-failed" ] [ text "failed" ]
