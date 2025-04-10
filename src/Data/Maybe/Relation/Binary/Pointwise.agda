------------------------------------------------------------------------
-- The Agda standard library
--
-- Pointwise lifting of relations to maybes
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.Maybe.Relation.Binary.Pointwise where

open import Data.Product.Base using (∃; _×_; -,_; _,_)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Maybe.Relation.Unary.Any using (Any; just)
open import Function.Bundles using (_⇔_; mk⇔)
open import Level using (Level; _⊔_)
open import Relation.Binary.Bundles using (Setoid; DecSetoid)
open import Relation.Binary.Core using (REL; Rel; _⇒_)
open import Relation.Binary.Definitions using (Reflexive; Sym; Trans; Decidable)
open import Relation.Binary.PropositionalEquality.Core as ≡ using (_≡_)
open import Relation.Binary.Structures using (IsEquivalence; IsDecEquivalence)
open import Relation.Nullary.Negation.Core using (¬_)
open import Relation.Unary using (_⊆_)
open import Relation.Nullary.Decidable as Dec using (yes; no; map)

------------------------------------------------------------------------
-- Definition

data Pointwise
       {a b ℓ} {A : Set a} {B : Set b}
       (R : REL A B ℓ) : REL (Maybe A) (Maybe B) (a ⊔ b ⊔ ℓ) where
  just    : ∀ {x y} → R x y → Pointwise R (just x) (just y)
  nothing : Pointwise R nothing nothing

------------------------------------------------------------------------
-- Properties

module _ {a b ℓ} {A : Set a} {B : Set b} {R : REL A B ℓ} where

  drop-just : ∀ {x y} → Pointwise R (just x) (just y) → R x y
  drop-just (just p) = p

  just-equivalence : ∀ {x y} → R x y ⇔ Pointwise R (just x) (just y)
  just-equivalence = mk⇔ just drop-just

  nothing-inv : ∀ {x} → Pointwise R nothing x → x ≡ nothing
  nothing-inv nothing = ≡.refl

  just-inv : ∀ {x y} → Pointwise R (just x) y → ∃ λ z → y ≡ just z × R x z
  just-inv (just r) = -, ≡.refl , r

------------------------------------------------------------------------
-- Relational properties

module _ {a r} {A : Set a} {R : Rel A r} where

  refl : Reflexive R → Reflexive (Pointwise R)
  refl R-refl {just _}  = just R-refl
  refl R-refl {nothing} = nothing

  reflexive : _≡_ ⇒ R → _≡_ ⇒ Pointwise R
  reflexive reflexive ≡.refl = refl (reflexive ≡.refl)

module _ {a b r₁ r₂} {A : Set a} {B : Set b}
         {R : REL A B r₁} {S : REL B A r₂} where

  sym : Sym R S → Sym (Pointwise R) (Pointwise S)
  sym R-sym (just p) = just (R-sym p)
  sym R-sym nothing  = nothing

module _ {a b c r₁ r₂ r₃} {A : Set a} {B : Set b} {C : Set c}
         {R : REL A B r₁} {S : REL B C r₂} {T : REL A C r₃} where

  trans : Trans R S T → Trans (Pointwise R) (Pointwise S) (Pointwise T)
  trans R-trans (just p) (just q) = just (R-trans p q)
  trans R-trans nothing  nothing  = nothing

module _ {a r} {A : Set a} {R : Rel A r} where

  dec : Decidable R → Decidable (Pointwise R)
  dec R-dec (just x) (just y) = Dec.map just-equivalence (R-dec x y)
  dec R-dec (just x) nothing  = no (λ ())
  dec R-dec nothing  (just y) = no (λ ())
  dec R-dec nothing  nothing  = yes nothing

  isEquivalence : IsEquivalence R → IsEquivalence (Pointwise R)
  isEquivalence R-isEquivalence = record
    { refl  = refl R.refl
    ; sym   = sym R.sym
    ; trans = trans R.trans
    } where module R = IsEquivalence R-isEquivalence

  isDecEquivalence : IsDecEquivalence R → IsDecEquivalence (Pointwise R)
  isDecEquivalence R-isDecEquivalence = record
    { isEquivalence = isEquivalence R.isEquivalence
    ; _≟_           = dec R._≟_
    } where module R = IsDecEquivalence R-isDecEquivalence

  pointwise⊆any : ∀ {x} → Pointwise R (just x) ⊆ Any (R x)
  pointwise⊆any (just Rxy) = just Rxy

module _ {c ℓ} where

  setoid : Setoid c ℓ → Setoid c (c ⊔ ℓ)
  setoid S = record
    { isEquivalence = isEquivalence S.isEquivalence
    } where module S = Setoid S

  decSetoid : DecSetoid c ℓ → DecSetoid c (c ⊔ ℓ)
  decSetoid S = record
    { isDecEquivalence = isDecEquivalence S.isDecEquivalence
    } where module S = DecSetoid S
