Class {
	#name : #RedoCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
RedoCard >> activateEffectWith: game and: aMove [ 
	game useLastCardEffectWith: aMove.
]

{ #category : #actions }
RedoCard >> equals: anotherCard [
	^ self class = anotherCard class.
]
