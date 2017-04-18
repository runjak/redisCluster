module Lib (
  redisHosts
) where

import Database.Redis (ConnectInfo(..))
import qualified Database.Redis as Redis

redisHosts :: [ConnectInfo]
redisHosts = do
  port <- [7000..7005]
  return Redis.defaultConnectInfo {
    connectPort = Redis.PortNumber port
  }
