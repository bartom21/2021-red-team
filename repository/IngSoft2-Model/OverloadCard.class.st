Class {
	#name : #OverloadCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
OverloadCard >> activateEffectWith: game and: aMove [ 
	( game currentPlayer = aMove source) ifFalse: [ self error: 'cant use a permanent card on anothers turn' ].
	game addPermanentEffect: aMove.
]

{ #category : #queries }
OverloadCard >> effect [
	^ -2
]

{ #category : #queries }
OverloadCard >> equals: anotherCard [
	^ self class = anotherCard class.
]
