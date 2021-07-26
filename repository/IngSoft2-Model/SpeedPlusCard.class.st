Class {
	#name : #SpeedPlusCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #actions }
SpeedPlusCard >> activateEffectWith: game and: aMove [ 
	( game currentPlayer = aMove source) ifFalse: [ self error: 'cant use a permanent card on anothers turn' ].
	self assertTargeted: aMove.
	game addPermanentEffect: aMove.
]

{ #category : #actions }
SpeedPlusCard >> assertTargeted: aMove [ 
	(aMove isTargeted) ifFalse: [ self error: self className , ' must be played on a Targeted Move' ].
]

{ #category : #actions }
SpeedPlusCard >> effectOn: player  with: aCardDealer andWith: aCircularBoard [
	(SpeedUpCell new) activateEffect: aCircularBoard from: player with: aCardDealer
	
]

{ #category : #queries }
SpeedPlusCard >> equals: anotherCard [
	^ self class = anotherCard class.
]
