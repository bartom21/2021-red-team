Class {
	#name : #TargetedMove,
	#superclass : #Object,
	#instVars : [
		'player',
		'card',
		'target'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
TargetedMove class >> from: aPlayer with: aCard against: objetive [
	(aCard equals: AccelerationCard new) ifTrue: [ self error: 'Cant create a Target Move with an AccelerationCard' ].
	^ self new initializeWith: aPlayer with: aCard against: objetive.
]

{ #category : #actions }
TargetedMove >> activateEffect: aRedGame [ 
	card activateEffectWith: aRedGame and: self.
]

{ #category : #queries }
TargetedMove >> card [
	^ card
]

{ #category : #actions }
TargetedMove >> changeCard: aCard [ 
	^ self class from: player with: aCard against: target.
]

{ #category : #actions }
TargetedMove >> effectOn: aPlayer [
	^ target = aPlayer
		ifTrue: [ card effect]
		ifFalse: [ 0 ]
]

{ #category : #queries }
TargetedMove >> equalsMove: anotherMove [ 
	^ (self class = anotherMove class) and: [(player = anotherMove source) and: [ target = anotherMove target ]]
]

{ #category : #initialize }
TargetedMove >> initializeWith: aPlayer with: aCard against: objetive [
	player := aPlayer.
	card := aCard.
	target := objetive.
]

{ #category : #actions }
TargetedMove >> source [
	^ player.
]

{ #category : #queries }
TargetedMove >> target [
	^ target
]
