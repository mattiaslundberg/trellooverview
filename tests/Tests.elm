module Tests exposing (..)

import Test exposing (..)
import CardTime
import SummaryTime


all : Test
all =
    describe "Time"
        [ CardTime.all
        , SummaryTime.all
        ]
