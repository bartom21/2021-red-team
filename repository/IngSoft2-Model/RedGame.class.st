Class {
	#name : #RedGame,
	#superclass : #Object,
	#instVars : [
		'dieHandle',
		'board',
		'laps',
		'playerSequence',
		'cardDealer',
		'lastToRoll'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
RedGame class >> assert: aCircularBoard hasEqual: players [
	(aCircularBoard arePlaying: players)
		ifFalse: [ self error: 'game and board must have the same players' ]
]

{ #category : #'instance creation' }
RedGame class >> assertGraeterThanZero: aNumberOfLaps [
	aNumberOfLaps > 0
		ifFalse: [ self error: 'invalid number of laps' ]
]

{ #category : #'instance creation' }
RedGame class >> assertIfEmpty: players [
	players
		ifEmpty: [ self error: 'cannot create a RedGame without players' ]
]

{ #category : #'instance creation' }
RedGame class >> with: aCircularBoard with: aDieHandle with: aDeck withLaps: aNumberOfLaps with: players andWith: aNumberOfAssignatedCards [
	| aSequence cardDealer |
	self assertIfEmpty: players.
	self assertGraeterThanZero: aNumberOfLaps.
	self assert: aCircularBoard hasEqual: players.
	aSequence := Sequence with: players.
	cardDealer := CardDealer
		with: players
		with: aNumberOfAssignatedCards
		andWith: aDeck.
	^ self new
		initializeWith: aCircularBoard
		with: aDieHandle
		withLaps: aNumberOfLaps
		with: aSequence
		andWith: cardDealer
]

{ #category : #actions }
RedGame >> addPermanentEffect: aMove [
	cardDealer addPermanentEffect: aMove.
]

{ #category : #actions }
RedGame >> assertCorrespondentTurn: playerName [
	playerName = playerSequence currentElement 
		ifFalse: [ self error: 'cant play on anothers turn' ]
]

{ #category : #actions }
RedGame >> assertIfGameHasEnded [
	self hasEnded
		ifTrue: [ self error: 'the game has ended' ]
]

{ #category : #actions }
RedGame >> assertIfHasRolledMax: playerName with: rollValue [
	(dieHandle hasRolledMax: rollValue)
		ifTrue: [ board assertFreedomOf: playerName ].
]

{ #category : #actions }
RedGame >> assertIfItsPlaying: playerName [
	(playerSequence assertIfIncluded: playerName)
		ifFalse: [ self error: 'Cannot roll for a player that is not playing' ]
]

{ #category : #actions }
RedGame >> assertLastToRoll: playerName [
	playerName = lastToRoll 
		ifTrue: [ self error: 'can only roll the dice once on your turn' ]
]

{ #category : #actions }
RedGame >> breakFree: playerName [ 
	board breakFree: playerName .
]

{ #category : #queries }
RedGame >> currentPlayer [
	^ playerSequence currentElement.
]

{ #category : #actions }
RedGame >> finishTurn [
	^ playerSequence nextElement.
]

{ #category : #queries }
RedGame >> hasEnded [
	^ board anyPlayerFinished: laps.
]

{ #category : #initialize }
RedGame >> initializeWith: aCircularBoard with: aDieHandle withLaps: aNumberOfLaps with: aSequenceOfPlayers andWith: aCardDealer [
	dieHandle := aDieHandle.
	board := aCircularBoard.
	laps := aNumberOfLaps.
	playerSequence := aSequenceOfPlayers.
	cardDealer := aCardDealer.
]

{ #category : #queries }
RedGame >> lapOf: playerName [
	^ board lapOf: playerName.
]

{ #category : #actions }
RedGame >> play: aMove [
	self assertIfGameHasEnded.
	cardDealer handle: aMove with: self.
]

{ #category : #queries }
RedGame >> positionOf: nameOfPlayer [
	^ board positionOf: nameOfPlayer.
]

{ #category : #queries }
RedGame >> rankingOf: name [
	^ board rankingOf: name.
]

{ #category : #actions }
RedGame >> removePermanentEffect: aMove [ 
	cardDealer removePermanentEffect: aMove.
]

{ #category : #actions }
RedGame >> rollDiceFor: playerName [
	| permanentCardsResult rollValue |
	self assertIfGameHasEnded.
	self assertIfItsPlaying: playerName.
	self assertCorrespondentTurn: playerName.
	self assertLastToRoll: playerName. 
	rollValue := dieHandle roll .
	self assertIfHasRolledMax: playerName with: rollValue .
	permanentCardsResult := cardDealer
		accumulatePermanentEffectsOnPlayer: playerName.
	board
		with: cardDealer
		move: playerName
		with: rollValue + permanentCardsResult.
	lastToRoll := playerName. 
]

{ #category : #actions }
RedGame >> useLastBoardEffectOn: playerName [
	board repeatLastEffectOn: playerName with: self.
]

{ #category : #actions }
RedGame >> useLastCardEffectWith: aMove [ 
	cardDealer useLastCardEffectWith: aMove andWith: self. 
]

{ #category : #queries }
RedGame >> winner [
	self hasEnded
		ifFalse: [ self error: 'the game is still running' ].
	^board winner.
]
