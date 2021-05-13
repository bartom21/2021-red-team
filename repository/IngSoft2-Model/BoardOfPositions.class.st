Class {
	#name : #BoardOfPositions,
	#superclass : #Object,
	#instVars : [
		'positions'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
BoardOfPositions class >> with: players [
	^ self new initializeWith: players.
]

{ #category : #initialize }
BoardOfPositions >> initializeWith: players [
	| auxiliarPositions playerName |
	auxiliarPositions := OrderedCollection new.
	1 to: players size do: [ :i | 
		playerName := players at: i.
		auxiliarPositions add: (Position from: playerName) ].
	positions := auxiliarPositions
]

{ #category : #queries }
BoardOfPositions >> lapOfPlayer: playerName withLapSize: lapSize [
	| positionOfPlayer |
	positionOfPlayer := (positions detect: [ :position | position nameOfPlayer = playerName]) valueOfPosition.
	^ (positionOfPlayer // lapSize) + 1.
]

{ #category : #actions }
BoardOfPositions >> moveEveryone: n except: player [
	| playersToMove |
	playersToMove := (self selectAllPositionsExcept: player) collect: [ :position | position nameOfPlayer ].
	playersToMove do: [ :name | self updatePositionOf: name with: n ]
]

{ #category : #actions }
BoardOfPositions >> moveEveryoneToTheBeginningOfTheLapWithSize: lapSize [
	| moveBackwards |
	positions do: [ :position | 
		moveBackwards := (-1)*((position valueOfPosition) \\ lapSize).
		self updatePositionOf: (position nameOfPlayer) with: moveBackwards ].
]

{ #category : #queries }
BoardOfPositions >> positionOfPlayer: player [ 
	| position |
	position := positions detect: [ :p | p nameOfPlayer = player ].
	^ position valueOfPosition.
]

{ #category : #actions }
BoardOfPositions >> selectAllPositionsExcept: player [
	^ positions
		select: [ :position | (position nameOfPlayer ~= player) ]
]

{ #category : #actions }
BoardOfPositions >> updatePositionOf: player with: value [ 
	(positions detect: [ :aPosition | aPosition nameOfPlayer = player ]) updatePosition: value.
	^ (positions detect: [ :aPosition | aPosition nameOfPlayer = player ]) valueOfPosition.
	
	
]