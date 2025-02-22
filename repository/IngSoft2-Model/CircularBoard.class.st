Class {
	#name : #CircularBoard,
	#superclass : #Object,
	#instVars : [
		'cells',
		'lastCell',
		'positionsBoard'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
CircularBoard class >> assertIfEmpty: collection withError: block [
	collection
		ifEmpty: [ self error: block ].
	
]

{ #category : #'instance creation' }
CircularBoard class >> with: players andWithAll: cells [
	| boardOfPositions positions |
	self assertIfEmpty: cells withError: 'cant create a board without cells'. 
	self assertIfEmpty: players withError: 'cant create a board without players'.
	positions := players collect: [ :player | Position from: player ].
	boardOfPositions := PositionsBoard
		with: positions asOrderedCollection.
	^ self new initializeWith: boardOfPositions andWithAll: cells
]

{ #category : #queries }
CircularBoard >> anyPlayerFinished: laps [
	^ positionsBoard anyPlayerFinished: laps withBoardOfSize: cells size.
]

{ #category : #queries }
CircularBoard >> arePlaying: players [ 
	^positionsBoard arePlaying: players.
]

{ #category : #actions }
CircularBoard >> assertFreedomOf: playerName [ 
	positionsBoard assertPossibleUnblockFor: playerName.

]

{ #category : #actions }
CircularBoard >> breakFree: playerName [
	positionsBoard activatePositionOf: playerName.
]

{ #category : #initialize }
CircularBoard >> initializeWith: positions andWithAll: collectionOfCells [
	cells := collectionOfCells.
	positionsBoard := positions.
	lastCell := RegularCell new.
	
]

{ #category : #queries }
CircularBoard >> lapOf: playerName [
	^ positionsBoard lapOf: playerName withLapSize: (cells size).
]

{ #category : #actions }
CircularBoard >> moveEveryone: n except: player [
	positionsBoard moveEveryone: n except: player. 
]

{ #category : #actions }
CircularBoard >> moveEveryoneToTheBeginningOfTheLap [
	positionsBoard moveEveryoneToTheBeginningOfTheLapWithSize: cells size.
]

{ #category : #queries }
CircularBoard >> positionOf: player [
	| position |
	position := positionsBoard positionOf: player.
	^ (position > (cells size)) ifTrue: [ position \\ (cells size)]
									  ifFalse: [ position ].
]

{ #category : #actions }
CircularBoard >> positionOnLap: player [
	| position positionOnLap |
	position := positionsBoard positionOf: player.
	positionOnLap := position \\ cells size.
	positionOnLap = 0
		ifTrue: [ positionOnLap := cells size ].
	^ positionOnLap
]

{ #category : #queries }
CircularBoard >> rankingOf: name [ 
	^ positionsBoard rankingOf: name .
]

{ #category : #actions }
CircularBoard >> repeatLastEffectOn: playerName with: aRedGame [ 
		lastCell activateEffect: self from: playerName with: aRedGame
]

{ #category : #actions }
CircularBoard >> takeToPrision: playerName [
	positionsBoard blockPositionOf: playerName.
]

{ #category : #actions }
CircularBoard >> updatePositionOf: player with: value [  
	positionsBoard updatePositionOf: player with: value. 
]

{ #category : #queries }
CircularBoard >> winner [
	^positionsBoard whosFirst.
]

{ #category : #actions }
CircularBoard >> with: cardDealer  move: player with: rollValue [
	| currentPosition currentCell|
	positionsBoard updatePositionOf: player with: rollValue .
	currentPosition := self positionOnLap: player.
	currentCell := cells at: currentPosition.
	lastCell := currentCell .
	currentCell activateEffect: self from: player with: cardDealer.
	cardDealer activatePermanentEffectsFor: player on: currentPosition with: self.
]
