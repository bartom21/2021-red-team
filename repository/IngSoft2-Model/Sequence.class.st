Class {
	#name : #Sequence,
	#superclass : #Object,
	#instVars : [
		'elements'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Sequence class >> with: someElements [ 
	^self new initializeWith: someElements.
]

{ #category : #initialize }
Sequence >> assertIfIncluded: element [ 
	^elements includes: element.
]

{ #category : #initialize }
Sequence >> currentElement [
	^elements first.

]

{ #category : #initialize }
Sequence >> initializeWith: someElements [ 
	elements := someElements asOrderedCollection.
]

{ #category : #initialize }
Sequence >> nextElement [
	| value |
	value := elements removeFirst.
	elements addLast: value. 
	^value.
]
