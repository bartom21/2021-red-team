Class {
	#name : #LoadedDie,
	#superclass : #Object,
	#instVars : [
		'faces',
		'rollValues'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
LoadedDie class >> assert: rollValues areLessThan: aNumberOfFaces [
	(rollValues anySatisfy: [ :rollValue | rollValue > aNumberOfFaces ])
		ifTrue:
			[ self error: 'A loaded die cannott roll a number greater than its faces']
]

{ #category : #'instance creation' }
LoadedDie class >> assertIfEmpty: cards [
	cards
		ifEmpty: [ self error: 'Cannot create a LoadedDie without roll values' ]
]

{ #category : #'instance creation' }
LoadedDie class >> assertMinimumOfFaces: aNumberOfFaces [
	aNumberOfFaces >= 3
		ifFalse: [ self error: 'invalid number of faces' ]
]

{ #category : #'instance creation' }
LoadedDie class >> with: aNumberOfFaces andWith: rollValues [
	self assertMinimumOfFaces: aNumberOfFaces.
	self assertIfEmpty: rollValues.
	self assert: rollValues areLessThan: aNumberOfFaces.
	^ self new initializeWith: aNumberOfFaces andWith: rollValues
]

{ #category : #queries }
LoadedDie >> faces [
	^ faces
]

{ #category : #initialize }
LoadedDie >> initializeWith: aNumberOfFaces andWith: loadedValues [
	faces := aNumberOfFaces.
	rollValues := Sequence with: loadedValues.
]

{ #category : #actions }
LoadedDie >> roll [
	^ rollValues nextElement.
]
