module Main where

import Lib (redisHosts)

main :: IO ()
main = print redisHosts
