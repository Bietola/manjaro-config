#!/usr/bin/env stack
{- stack script
 --optimize
 --resolver lts-17.2
 --package turtle
 --package time
-}

{-# LANGUAGE OverloadedStrings #-}

import Turtle
import Data.Time
import Prelude hiding (FilePath)

aparse = (,,,) <$> argPath "INPUT_VIDEO" ""
               <*> argText "BEGINNING_TIME_IN_MINS" ""
               <*> argText "ENDING_TIME_IN_MINS" ""
               <*> argPath "OUTPUT_VIDEO_DESTINATION" ""

mins2secs mins =
    case doParse $ repr mins of
         Just res -> repr $ nominalDiffTimeToSeconds res
         Nothing -> error "Malformed time value: " <> mins
    where doParse = parseTimeM True defaultTimeLocale "%M:%S"

main = sh $ do
    (inp, begMins, endMins, outDest) <- options "Crop video with ffmpeg" aparse

    let begSecs = mins2secs begMins
    let endSecs = mins2secs endMins

    shell
        (format ("ffmpeg -i "%fp%" -ss "%s%" -t "%s%" "%fp)
            inp begSecs endSecs outDest)
        stdin
