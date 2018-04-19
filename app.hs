#!/usr/bin/env stack
-- stack script --resolver lts-11.3

{-# LANGUAGE OverloadedStrings #-}
import Control.Monad (void)
import Control.Monad.Trans.Resource (ResourceT)
import Data.Conduit
import Data.Conduit.Combinators (encodeUtf8, stdout)
import Data.Text (Text, unpack, intercalate, snoc)
import Data.XML.Types (Event, Name, nameLocalName)
import System.Environment (getArgs)
import Text.XML.Stream.Parse

-- a parser for a list of attributes
lAttrParser :: [Name] -> AttrParser [Text]
lAttrParser = go $ return [] where
  go a [] = a
  go a (n:ns) = go ((:) <$> requireAttr n <*> a) ns

toCSV :: [Text] -> Text
toCSV = flip snoc '\n' . intercalate ";"

-- skips all children, f is the Conduit constructor for the element itself
ignDesc :: (b -> ConduitT Event o (ResourceT IO) c)
         -> b -> ConduitT Event o (ResourceT IO) c
ignDesc f x = many' ignoreAnyTreeContent >> f x

-- the attribets into a line using lTxtToLn
attrsToTxt :: NameMatcher a -> [Name] -> ConduitT Event o (ResourceT IO) (Maybe Text)
attrsToTxt n a = tag' n (lAttrParser a <* ignoreAttrs) $ ignDesc (return . toCSV)

actAttrs :: [Name]
actAttrs = [ "dateComponents", "activeEnergyBurned"
           , "appleExerciseTime", "appleStandHours"]

wrkAttrs :: [Name]
wrkAttrs = [ "workoutActivityType", "duration", "totalDistance"
           , "totalEnergyBurned", "startDate", "endDate" ]

printer :: NameMatcher a -> [Name] -> FilePath -> IO ()
printer tagName attrNames fn = do
  putStr . unpack . toCSV . fmap nameLocalName $ attrNames
  runConduitRes
     $ parseFile def fn
    .| void (tagIgnoreAttrs "HealthData" $ manyYield' parser')
    .| encodeUtf8
    .| stdout where
        parser' = attrsToTxt tagName $ reverse attrNames

printUsage :: IO ()
printUsage = putStrLn "usage: ./app filename content"

main :: IO ()
main = do
  a <- getArgs
  if length a < 2
    then printUsage
    else case a !! 1 of
      "wrk" -> printer "Workout" wrkAttrs (a !! 0)
      "act" -> printer "ActivitySummary" actAttrs (a !! 0)
      _ -> printUsage >> putStrLn "'content' must be either 'act' or 'wrk'."

