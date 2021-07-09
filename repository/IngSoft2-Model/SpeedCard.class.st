Class {
	#name : #SpeedCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
SpeedCard >> activateEffectWith: game and: aMove [ 
	( game currentPlayer = aMove source) ifFalse: [ self error: 'cant use a permanent card on anothers turn' ].
	game addPermanentEffect: aMove.
]

{ #category : #queries }
SpeedCard >> effect [
	^ 1.
]

{ #category : #queries }
SpeedCard >> equals: anotherCard [
	^ self class = anotherCard class.
]
