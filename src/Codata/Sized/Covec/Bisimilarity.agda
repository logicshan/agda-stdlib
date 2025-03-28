------------------------------------------------------------------------
-- The Agda standard library
--
-- Bisimilarity for Covecs
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --sized-types #-}

module Codata.Sized.Covec.Bisimilarity where

open import Level using (_⊔_)
open import Size using (Size; ∞)
open import Codata.Sized.Thunk using (Thunk; Thunk^R; force)
open import Codata.Sized.Conat hiding (_⊔_)
open import Codata.Sized.Covec using (Covec; _∷_; [])
open import Relation.Binary.Definitions
  using (Reflexive; Symmetric; Transitive; Sym; Trans)
open import Relation.Binary.PropositionalEquality.Core as ≡ using (_≡_)

data Bisim {a b r} {A : Set a} {B : Set b} (R : A → B → Set r) (i : Size) :
           ∀ m n (xs : Covec A ∞ m) (ys : Covec B ∞ n) → Set (r ⊔ a ⊔ b) where
  []  : Bisim R i zero zero [] []
  _∷_ : ∀ {x y m n xs ys} → R x y → Thunk^R (λ i → Bisim R i (m .force) (n .force)) i xs ys →
        Bisim R i (suc m) (suc n) (x ∷ xs) (y ∷ ys)

infixr 5 _∷_

module _ {a r} {A : Set a} {R : A → A → Set r} where

 reflexive : Reflexive R → ∀ {i m} → Reflexive (Bisim R i m m)
 reflexive refl^R {i} {m} {[]}     = []
 reflexive refl^R {i} {m} {r ∷ rs} = refl^R ∷ λ where .force → reflexive refl^R

module _ {a b} {A : Set a} {B : Set b}
         {r} {P : A → B → Set r} {Q : B → A → Set r} where

 symmetric : Sym P Q → ∀ {i m n} → Sym (Bisim P i m n) (Bisim Q i n m)
 symmetric sym^PQ []       = []
 symmetric sym^PQ (p ∷ ps) = sym^PQ p ∷ λ where .force → symmetric sym^PQ (ps .force)

module _ {a b c} {A : Set a} {B : Set b} {C : Set c}
         {r} {P : A → B → Set r} {Q : B → C → Set r} {R : A → C → Set r} where

 transitive : Trans P Q R → ∀ {i m n p} → Trans (Bisim P i m n) (Bisim Q i n p) (Bisim R i m p)
 transitive trans^PQR []       []       = []
 transitive trans^PQR (p ∷ ps) (q ∷ qs) =
   trans^PQR p q ∷ λ where .force → transitive trans^PQR (ps .force) (qs .force)

-- Pointwise Equality as a Bisimilarity
------------------------------------------------------------------------

module _ {ℓ} {A : Set ℓ} where

 infix 1 _,_⊢_≈_
 _,_⊢_≈_ : ∀ i m → Covec A ∞ m → Covec A ∞ m → Set ℓ
 _,_⊢_≈_ i m = Bisim _≡_ i m m

 refl : ∀ {i m} → Reflexive (i , m ⊢_≈_)
 refl = reflexive ≡.refl

 sym : ∀ {i m} → Symmetric (i , m ⊢_≈_)
 sym = symmetric ≡.sym

 trans : ∀ {i m} → Transitive (i , m ⊢_≈_)
 trans = transitive ≡.trans
