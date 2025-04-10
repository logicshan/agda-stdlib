------------------------------------------------------------------------
-- The Agda standard library
--
-- A universe polymorphic unit type, as a Lift of the Level 0 one.
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.Unit.Polymorphic.Base where

open import Level using (Level; Lift; lift)
import Data.Unit.Base as ⊤

------------------------------------------------------------------------
-- A unit type defined as a synonym

⊤ : {ℓ : Level} → Set ℓ
⊤ {ℓ} = Lift ℓ ⊤.⊤

tt : {ℓ : Level} → ⊤ {ℓ}
tt = lift ⊤.tt
