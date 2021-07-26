Class {
	#name : #LoadedDeck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
LoadedDeck class >> assertIfEmpty: cards [
	cards
		ifEmpty: [ self error: 'Cannot create a LoadedDeck without cards' ]
]

{ #category : #'instance creation' }
LoadedDeck class >> with: cards [
	self assertIfEmpty: cards.
	^ self new intializeWith: cards
]

{ #category : #initialize }
LoadedDeck >> intializeWith: someCards [ 
	cards := Sequence with: someCards.
]

{ #category : #actions }
LoadedDeck >> takeACard [
	^ cards nextElement.
]
