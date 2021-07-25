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
LoadedDie class >> with: aNumberOfFaces andWith: rollValues [
	(aNumberOfFaces >= 3 ) ifFalse: [ self error: 'invalid number of faces' ].
	^ self new initializeWith: aNumberOfFaces andWith: rollValues .
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
