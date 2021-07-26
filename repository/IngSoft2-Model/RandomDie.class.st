Class {
	#name : #RandomDie,
	#superclass : #Object,
	#instVars : [
		'faces'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
RandomDie class >> assertMinimumOfFaces: aNumberOfFaces [
	aNumberOfFaces >= 3
		ifFalse: [ self error: 'invalid number of faces' ]
]

{ #category : #'instance creation' }
RandomDie class >> with: aNumberOfFaces [
	self assertMinimumOfFaces: aNumberOfFaces.
	^ self new initializeWith: aNumberOfFaces
]

{ #category : #queries }
RandomDie >> faces [
	^ faces
]

{ #category : #initialize }
RandomDie >> initializeWith: aNumberOfFaces [
	faces := aNumberOfFaces.
	
]

{ #category : #actions }
RandomDie >> roll [
	^ faces atRandom.
]
