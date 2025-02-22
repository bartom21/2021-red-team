Class {
	#name : #TargetedMove,
	#superclass : #Object,
	#instVars : [
		'target',
		'move'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
TargetedMove class >> assertTargetedCard: aMove [
	(aMove card equals: AccelerationCard new)
		ifTrue: [ self error: 'Cant create a Target Move with an AccelerationCard' ]
]

{ #category : #'instance creation' }
TargetedMove class >> with: aMove against: objetive [
	self assertTargetedCard: aMove.
	^ self new initializeWith: aMove against: objetive
]

{ #category : #actions }
TargetedMove >> activateEffect: aRedGame [ 
	move activateEffect: aRedGame with: self .
]

{ #category : #queries }
TargetedMove >> card [
	^ move card
]

{ #category : #actions }
TargetedMove >> changeCard: aCard [ 
	^ self class with: (move changeCard: aCard) against: target.
]

{ #category : #actions }
TargetedMove >> effectOn: aTarget [ 
	^ target = aTarget 
		ifTrue: [ move effectOn: aTarget ]
		ifFalse: [ 0 ]
]

{ #category : #actions }
TargetedMove >> effectWith: aCardDealer andWith: aCircularBoard [ 
	move effecWith: aCardDealer andWith: aCircularBoard 
]

{ #category : #queries }
TargetedMove >> equalsMove: anotherMove [ 
	^ (anotherMove isTargeted) and: [ (move equalsMove: anotherMove move) and: [ target = anotherMove target ]].
]

{ #category : #initialize }
TargetedMove >> initializeWith: aMove against: objetive [
	move := aMove .
	target := objetive.
]

{ #category : #actions }
TargetedMove >> isTargeted [
	^true
]

{ #category : #queries }
TargetedMove >> move [
	^ move
]

{ #category : #actions }
TargetedMove >> source [
	^ move source.
]

{ #category : #queries }
TargetedMove >> target [
	^ target
]
