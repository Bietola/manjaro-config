#!/usr/bin/env stack
{- stack script
 --resolver lts-17.2
 --optimize
 --package turtle
-}

import Turtle

{-# LANGUAGE OverloadedStrings #-}

frick = putStrLn

main = frick "Hello There!"
