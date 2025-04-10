------------------------------------------------------------------------
-- The Agda standard library
--
-- Properties of operations on machine words
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.Word64.Properties where

import Data.Nat.Base as ℕ
open import Data.Bool.Base using (Bool)
open import Data.Word64.Base using (_≈_; toℕ; Word64; _<_)
import Data.Nat.Properties as ℕ
open import Relation.Nullary.Decidable.Core using (map′; ⌊_⌋)
open import Relation.Binary
  using ( _⇒_; Reflexive; Symmetric; Transitive; Substitutive
        ; Decidable; DecidableEquality; IsEquivalence; IsDecEquivalence
        ; Setoid; DecSetoid; StrictTotalOrder)
import Relation.Binary.Construct.On as On using (decidable; strictTotalOrder)
open import Relation.Binary.PropositionalEquality.Core
  using (_≡_; refl; cong; sym; trans; subst)
open import Relation.Binary.PropositionalEquality.Properties
  using (setoid; decSetoid)

------------------------------------------------------------------------
-- Primitive properties

open import Agda.Builtin.Word.Properties
  renaming (primWord64ToNatInjective to toℕ-injective)
  public

------------------------------------------------------------------------
-- Properties of _≈_

≈⇒≡ : _≈_ ⇒ _≡_
≈⇒≡ = toℕ-injective _ _

≈-reflexive : _≡_ ⇒ _≈_
≈-reflexive = cong toℕ

≈-refl : Reflexive _≈_
≈-refl = refl

≈-sym : Symmetric _≈_
≈-sym = sym

≈-trans : Transitive _≈_
≈-trans = trans

≈-subst : ∀ {ℓ} → Substitutive _≈_ ℓ
≈-subst P x≈y p = subst P (≈⇒≡ x≈y) p

infix 4 _≈?_
_≈?_ : Decidable _≈_
x ≈? y = toℕ x ℕ.≟ toℕ y

≈-isEquivalence : IsEquivalence _≈_
≈-isEquivalence = record
  { refl  = λ {i} → ≈-refl {i}
  ; sym   = λ {i j} → ≈-sym {i} {j}
  ; trans = λ {i j k} → ≈-trans {i} {j} {k}
  }

≈-setoid : Setoid _ _
≈-setoid = record
  { isEquivalence = ≈-isEquivalence
  }

≈-isDecEquivalence : IsDecEquivalence _≈_
≈-isDecEquivalence = record
  { isEquivalence = ≈-isEquivalence
  ; _≟_           = _≈?_
  }

≈-decSetoid : DecSetoid _ _
≈-decSetoid = record
  { isDecEquivalence = ≈-isDecEquivalence
  }
------------------------------------------------------------------------
-- Properties of _≡_

infix 4 _≟_
_≟_ : DecidableEquality Word64
x ≟ y = map′ ≈⇒≡ ≈-reflexive (x ≈? y)

≡-setoid : Setoid _ _
≡-setoid = setoid Word64

≡-decSetoid : DecSetoid _ _
≡-decSetoid = decSetoid _≟_

------------------------------------------------------------------------
-- Boolean equality test.

infix 4 _==_
_==_ : Word64 → Word64 → Bool
w₁ == w₂ = ⌊ w₁ ≟ w₂ ⌋

------------------------------------------------------------------------
-- Properties of _<_

infix 4 _<?_
_<?_ : Decidable _<_
_<?_ = On.decidable toℕ ℕ._<_ ℕ._<?_

<-strictTotalOrder-≈ : StrictTotalOrder _ _ _
<-strictTotalOrder-≈ = On.strictTotalOrder ℕ.<-strictTotalOrder toℕ
