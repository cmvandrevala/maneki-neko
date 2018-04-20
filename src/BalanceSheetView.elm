module BalanceSheetView exposing (view)

import Html exposing (button, div, h1, Html, table, td, text, th, tr)
import Html.Attributes exposing (class)
import Model exposing (..)
import Date exposing (Date, day, month, year)
import FormatNumber
import Html.Events exposing (onClick)
import DateFormatter exposing (formatMonth)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Balance Sheet" ]
        , button [ class "get-balance-sheet", onClick GetBalanceSheetRowsFromApi ] [ text "Refresh the Balance Sheet" ]
        , table [] (allRows model)
        ]


allRows : Model -> List (Html Msg)
allRows model =
    [ formattedHeaders ] ++ (List.map formattedBalanceSheetRow model.balanceSheet.assets)


formattedHeaders : Html Msg
formattedHeaders =
    tr []
        [ th [ class "last-updated-header" ] [ text "Last Updated" ]
        , th [ class "institution-header" ] [ text "Institution" ]
        , th [ class "account-header" ] [ text "Account" ]
        , th [ class "investment-header" ] [ text "Investment" ]
        , th [ class "owner-header" ] [ text "Owner" ]
        , th [ class "value-header" ] [ text "Value" ]
        ]


formattedBalanceSheetRow : BalanceSheetRow -> Html Msg
formattedBalanceSheetRow row =
    tr [ class "balance-sheet-row" ]
        [ td [] [ text (formattedDate row.lastUpdated) ]
        , td [] [ text row.institution ]
        , td [] [ text row.account ]
        , td [] [ text row.investment ]
        , td [] [ text row.owner ]
        , td [] [ text (formattedValue row.value) ]
        ]


formattedDate : Date -> String
formattedDate date =
    (toString (year date))
        ++ "-"
        ++ (formatMonth (month date))
        ++ "-"
        ++ (toString (day date))


formattedValue : Float -> String
formattedValue value =
    let
        locale =
            { decimals = 2
            , thousandSeparator = ","
            , decimalSeparator = "."
            , negativePrefix = "−"
            , negativeSuffix = ""
            }
    in
        FormatNumber.format locale value
