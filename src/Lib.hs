module Lib (
  redisHosts,
  connect,
  meet
) where

import Database.Redis (ConnectInfo(..), Connection)
import Data.ByteString (ByteString)
import qualified Database.Redis as Redis
import qualified Data.ByteString as ByteString

import qualified Cluster as Cluster

redisHosts :: [ConnectInfo]
redisHosts = do
  port <- [7000..7005]
  return Redis.defaultConnectInfo {
    connectHost = "127.0.0.1"
  , connectPort = Redis.PortNumber port
  }

connect :: [ConnectInfo] -> IO [Connection]
connect = mapM Redis.checkedConnect

meet :: [ConnectInfo] -> IO ()
meet (x:xs) = do
  let hostName = Redis.connectHost x
      portID = Redis.connectPort x
      command = Cluster.meet hostName portID
  connections <- connect xs
  meetings <- mapM (Redis.runRedis `flip` command) connections
  mapM_ (\m -> putStrLn "Meeting:" >> print m) meetings
meet _ = return ()
