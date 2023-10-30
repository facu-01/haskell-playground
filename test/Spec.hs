import Lib
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "elem'" $ do
    it "returns true if element is in the list" $ do
      elem' [1, 65, 123, 12, 11, 12] 12 `shouldBe` True

    it "returns false if element is not in the list" $ do
      elem' [1, 65, 123, 12, 11, 12] 99 `shouldBe` False

    it "returns false if the list is empty" $ do
      elem' [] 99 `shouldBe` False

  describe "sorted" $ do
    it "returns true if the list is sorted" $ do
      sorted' [1, 2, 3, 7] `shouldBe` True

    it "returns false if the list is not sorted" $ do
      sorted' [1, 2, 7, 4] `shouldBe` False

    it "returns true if the list is empty" $ do
      sorted' ([] :: [Int]) `shouldBe` True

    it "returns true if the list have one elem" $ do
      sorted' [10] `shouldBe` True
