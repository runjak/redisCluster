{-# LANGUAGE OverloadedStrings #-}
module Cluster (
  hashSlots, meet
) where

import Data.ByteString (ByteString)
import Database.Redis (Redis, Reply, HostName, PortID)
import qualified Data.ByteString as ByteString
import qualified Data.ByteString.Char8 as Char8
import qualified Data.Maybe as Maybe
import qualified Database.Redis as Redis

hashSlots :: Int
hashSlots = 2^14

toClusterPortNumber :: PortID -> Maybe ByteString
toClusterPortNumber (Redis.Service _)    = Nothing
toClusterPortNumber (Redis.UnixSocket _) = Nothing
toClusterPortNumber (Redis.PortNumber p) = Just . Char8.pack . show $ 10000 + p

meet :: HostName -> PortID -> Redis (Either Reply Redis.Status)
meet host port = do
  let host' = Char8.pack host
      port' = toClusterPortNumber port
  if Maybe.isNothing port'
    then return . Left $ Redis.Error "Invalid PortID"
    else Redis.sendRequest ["CLUSTER", "MEET", host', Maybe.fromJust port']
