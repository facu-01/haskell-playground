module Lib (sorted', elem') where

elem' :: (Eq a) => [a] -> a -> Bool
elem' [] _ = False
elem' (x : xs) y = x == y || elem' xs y

sorted' :: (Ord a) => [a] -> Bool
sorted' [] = True
sorted' [_] = True
sorted' (h : n : xs) = h < n && sorted' xs
