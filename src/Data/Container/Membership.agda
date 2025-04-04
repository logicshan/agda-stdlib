------------------------------------------------------------------------
-- The Agda standard library
--
-- Membership for containers
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.Container.Membership where

open import Data.Container.Core using (Container; ⟦_⟧)
open import Data.Container.Relation.Unary.Any using (◇)
open import Level using (_⊔_)
open import Relation.Binary.PropositionalEquality.Core using (_≡_)
open import Relation.Unary using (Pred)

module _ {s p} {C : Container s p} {x} {X : Set x} where

  infix 4 _∈_
  _∈_ : X → Pred (⟦ C ⟧ X) (p ⊔ x)
  x ∈ xs = ◇ C (_≡_ x) xs
