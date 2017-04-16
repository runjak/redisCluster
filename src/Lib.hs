module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

redisHosts :: [(String, Int)]
redisHosts = [("127.0.0.1", port) | port <- [7000..7005]]
