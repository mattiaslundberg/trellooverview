module Tests exposing (..)

import Test exposing (..)
import CardTime
import SummaryTime
import DecoderTests


all : Test
all =
    describe "Time"
        [ CardTime.all
        , SummaryTime.all
        , DecoderTests.all
        ]
