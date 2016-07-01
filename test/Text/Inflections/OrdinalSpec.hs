{-# LANGUAGE CPP               #-}
{-# LANGUAGE OverloadedStrings #-}

module Text.Inflections.OrdinalSpec (spec) where

import Test.Hspec
import Test.QuickCheck.Property
import qualified Data.Text as T

import Text.Inflections (ordinal, ordinalize)

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

spec :: Spec
spec = do
  describe "ordinal" $ do
    one
    two
    thousands
    negatives
    ordinalReturnsNotEmpty
  describe "ordinalize" $ do
    fullOrdinals
    ordinalizeContainsTheSameNumber

one :: Spec
one =
  it "returns the ordinal for 1" $
    ordinal 1 `shouldBe` "st"

two :: Spec
two =
  it "returns the ordinal for 2" $
    ordinal 2 `shouldBe` "nd"

thousands :: Spec
thousands = do
  it "returns the ordinal for 1002" $
    ordinal 1002 `shouldBe` "nd"
  it "returns the ordinal for 1003" $
    ordinal 1003 `shouldBe` "rd"

negatives :: Spec
negatives = do
  it "returns the ordinal for -11" $
    ordinal (-11) `shouldBe` "th"
  it "returns the ordinal for -1021" $
    ordinal (-1021) `shouldBe` "st"

fullOrdinals :: Spec
fullOrdinals = do
  it "returns the full ordinal for 1" $
     ordinalize 1 `shouldBe` "1st"
  it "returns the full ordinal for -1021" $
     ordinalize (-1021) `shouldBe` "-1021st"

ordinalReturnsNotEmpty :: Spec
ordinalReturnsNotEmpty =
  it "never returns empty" $ property $
    property <$> not . T.null . ordinal

ordinalizeContainsTheSameNumber :: Spec
ordinalizeContainsTheSameNumber =
  it "always returns the number as part of the result" $ property ordinalizeSamePrefix

ordinalizeSamePrefix :: Integer -> Bool
ordinalizeSamePrefix n = T.pack s == T.take (length s) (ordinalize n)
  where s = show n
