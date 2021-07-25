Class {
	#name : #Move,
	#superclass : #Object,
	#instVars : [
		'player',
		'card'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Move class >> from: aPlayer with: aCard [
	^ self new initializeWith: aPlayer andWith: aCard.
]

{ #category : #actions }
Move >> activateEffect: game [ 
	card activateEffectWith: game and: self.
]

{ #category : #actions }
Move >> activateEffect: game with: aTargetedMove [
	card activateEffectWith: game and: aTargetedMove.
]

{ #category : #queries }
Move >> card [
	^ card
]

{ #category : #actions }
Move >> changeCard: aCard [ 
	^ self class from: player with: aCard.
]

{ #category : #queries }
Move >> effectOn: aTarget [
	^ card effect.
]

{ #category : #queries }
Move >> equalsMove: anotherMove [ 
	^ (self class = anotherMove class) and: [(player = anotherMove source ) and: [ card equals: anotherMove card ]]
]

{ #category : #initialize }
Move >> initializeWith: aPlayer andWith: aCard [
	player := aPlayer.
	card := aCard.
]

{ #category : #actions }
Move >> isTargeted [
	^false
]

{ #category : #actions }
Move >> source [
	^ player.
]
