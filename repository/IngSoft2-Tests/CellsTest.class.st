Class {
	#name : #CellsTest,
	#superclass : #RedGameTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CellsTest >> testLandOnACardCell [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards move |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: SpeedCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: CardCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	amountOfInitialCards := 0.
	game := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'martin' with: SpeedCard new) against: 'martin'.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 13.
]

{ #category : #tests }
CellsTest >> testLandOnAMoonWalkCell [
	| aCircularBoard aDieHandle players aGame twelveCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	twelveCells := OrderedCollection new.
	self add: RegularCell new times: 11 to: twelveCells.
	self add: (MoonWalkCell with: 4) times: 1 to: twelveCells.
	aCircularBoard := CircularBoard with: players andWithAll: twelveCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards .
	4 timesRepeat: [ self playATurnWithoutMoves: aGame ].
	self assert: (aGame positionOf: 'martin') equals: 12.
	self assert: (aGame positionOf: 'juan') equals: 2.
	self assert: (aGame positionOf: 'roman') equals: 2
]

{ #category : #tests }
CellsTest >> testLandOnAPrisionCell [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards die dice |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: SpeedCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	die := LoadedDie with: 6 andWith: #(6 4 5).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice. 
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: PrisionCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	amountOfInitialCards := 0.
	game := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	game rollDiceFor: 'martin'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 6.
]

{ #category : #tests }
CellsTest >> testLandOnARegularCell [
	| aCircularBoard aDieHandle players aGame tenRegularCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	tenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 10 to: tenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: tenRegularCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards .
	self playATurnWithoutMoves: aGame.
	self assert: (aGame positionOf: 'martin') equals: 6
]

{ #category : #tests }
CellsTest >> testLandOnASpeedUpCell [
	| aCircularBoard aDieHandle players aGame sixCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	sixCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: sixCells.
	self add: SpeedUpCell new times: 1 to: sixCells.
	aCircularBoard := CircularBoard with: players andWithAll: sixCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 2
		with: players
		andWith: amountOfInitialCards.
	self playATurnWithoutMoves: aGame.
	self assert: (aGame positionOf: 'martin') equals: 4
]

{ #category : #tests }
CellsTest >> testLandOnAWormHoleCell [
	| aCircularBoard aDieHandle players aGame sixCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	sixCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: sixCells.
	self add: WormHoleCell new times: 1 to: sixCells.
	aCircularBoard := CircularBoard with: players andWithAll: sixCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards .
	self playATurnWithoutMoves: aGame.
	self assert: (aGame positionOf: 'martin') equals: 2
]

{ #category : #tests }
CellsTest >> testLandOnAnAtomicBombCell [
	| aCircularBoard aDieHandle players aGame twelveCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	twelveCells := OrderedCollection new.
	self add: RegularCell new times: 11 to: twelveCells.
	self add: AtomicBombCell new times: 1 to: twelveCells.
	aCircularBoard := CircularBoard with: players andWithAll: twelveCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards.
	4 timesRepeat: [ self playATurnWithoutMoves: aGame ].
	self assert: (aGame positionOf: 'martin') equals: 1.
	self assert: (aGame positionOf: 'juan') equals: 1.
	self assert: (aGame positionOf: 'roman') equals: 1
]

{ #category : #tests }
CellsTest >> testLandOnAnAtomicBombCellAndStayOnCurrentLap [
	| aCircularBoard aDieHandle players aGame tenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	tenCells := OrderedCollection new.
	self add: RegularCell new times: 1 to: tenCells.
	self add: AtomicBombCell new times: 1 to: tenCells.
	self add: RegularCell new times: 8 to: tenCells.
	aCircularBoard := CircularBoard with: players andWithAll: tenCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 2
		with: players
		andWith: amountOfInitialCards.
	4 timesRepeat: [ self playATurnWithoutMoves: aGame ].
	self assert: (aGame positionOf: 'martin') equals: 1.
	self assert: (aGame lapOf: 'martin') equals: 2.
	self assert: (aGame positionOf: 'juan') equals: 1.
	self assert: (aGame lapOf: 'juan') equals: 1.
	self assert: (aGame positionOf: 'roman') equals: 1.
	self assert: (aGame lapOf: 'roman') equals: 1
]

{ #category : #tests }
CellsTest >> testLandOnAntomicBombWhileSomePlayerIsArrested [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards die dice rollValues |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: SpeedCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	rollValues := #(6 5 5 7).
	die := LoadedDie with: 8 andWith: rollValues.
	dice := Array with: die.
	aDieHandle := DieHandle with: dice. 
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: PrisionCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: AtomicBombCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 3 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	amountOfInitialCards := 0.
	game := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 1
		with: players
		andWith: amountOfInitialCards.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 6.
	self assert: (game positionOf: 'juan') equals: 1.
]
