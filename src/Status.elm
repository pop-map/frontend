module Status exposing (Status(..), view)

import Html exposing (Html, p, text)
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
            p [class "request-status", class "request-status-none" ] [ text "" ]

        Loading ->
            p [class "request-status", class "request-status-loading" ] [ text "loading" ]

        Success ->
            p [class "request-status", class "request-status-success" ] [ text "success" ]

        Failed ->
            p [class "request-status", class "request-status-failed" ] [ text "failed" ]
