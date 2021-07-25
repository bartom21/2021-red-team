Class {
	#name : #Position,
	#superclass : #Object,
	#instVars : [
		'player',
		'station',
		'state'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Position class >> from: playerName [
	^ self from: playerName with: 0 andWith: Active new.
]

{ #category : #'instance creation' }
Position class >> from: playerName with: newValue andWith: aState [
	playerName ifEmpty: [ self error: 'cant create a Position without a name' ].
	^ self new initializeWith: playerName with: newValue andWith: aState.
]

{ #category : #queries }
Position >> >= aPosition [ 
	^ (station >= aPosition valueOfPosition).
]

{ #category : #actions }
Position >> getActivate [
	 ^ self class from: player with: station andWith: Active new.
	
	
	
]

{ #category : #actions }
Position >> getBlocked [.
	 ^ self class from: player with: station andWith: Blocked new.
	
	
	
]

{ #category : #initialize }
Position >> initializeWith: name with: newValue andWith: aState [
	player := name.
	station := newValue .
	state := aState.
]

{ #category : #queries }
Position >> isBlocked [
	^ state isBlocked.
]

{ #category : #queries }
Position >> nameOfPlayer [
	^ player.
]

{ #category : #actions }
Position >> updateWith: distance [
	| newStation newPosition newDistance |
	newDistance := state assertValue: distance.
	newStation := (newDistance + station) max: 1 .
	newPosition := self class from: player with: newStation andWith: state.
	^newPosition.
	
	
]

{ #category : #queries }
Position >> valueOfPosition [
	^ station.
]
