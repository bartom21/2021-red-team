Class {
	#name : #DieHandle,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
DieHandle class >> assertIfEmpty: dice [
	dice ifEmpty: [ self error: 'cannot create an empty die handle' ]
]

{ #category : #'instance creation' }
DieHandle class >> with: dice [
	self assertIfEmpty: dice.
	^ self new initializeWith: dice
]

{ #category : #queries }
DieHandle >> hasRolledMax: rollValue [ 
	| maxValue |
	maxValue := dice sum: [ :die | die faces ].
	^ rollValue = maxValue.
]

{ #category : #initialize }
DieHandle >> initializeWith: anArrayOfDie [
	dice := anArrayOfDie asOrderedCollection .
]

{ #category : #actions }
DieHandle >> roll [
	^ dice inject: 0 into: [ :inicial :die | inicial + die roll ]. 
]
