Class {
	#name : #RandomSource,
	#superclass : #Object,
	#instVars : [
		'pool',
		'randomness'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
RandomSource class >> assertEqualsToOne: probability [
	(probability < 0.99 or: [ probability > 1.01 ])
		ifTrue: [ self error: 'The sum of all events probabilities must sum 1' ]
]

{ #category : #'instance creation' }
RandomSource class >> assertIfEmpty: eventsDistribution [
	eventsDistribution
		ifEmpty: [ self
				error: 'cant create a RandomSource without a events distribution' ]
]

{ #category : #'instance creation' }
RandomSource class >> basedOn: eventsDistribution [
	| probability |
	self assertIfEmpty: eventsDistribution.
	probability := eventsDistribution sum: [ :event | event probability ].
	self assertEqualsToOne: probability.
	^ self new initializeWith: eventsDistribution
]

{ #category : #initialize }
RandomSource >> initializeWith: eventsDistribution [
	randomness := Random new.
	pool := OrderedCollection new.
	eventsDistribution
		do: [ :probabilityEvent | 
			pool
				add: probabilityEvent event
				withOccurrences: (probabilityEvent probability * 100) asInteger ].
]

{ #category : #actions }
RandomSource >> produce: size [
	| collection |
	(size < 1) ifTrue: [ self error: 'Cant produce an invalid number of items' ].
	collection := OrderedCollection new.
	size timesRepeat: [ collection add: (pool atRandom: randomness) copy  ].
	^collection.
]
