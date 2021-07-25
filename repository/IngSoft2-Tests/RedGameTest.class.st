Class {
	#name : #RedGameTest,
	#superclass : #TestCase,
	#instVars : [
		'cardsDistribution'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
RedGameTest >> add: type times: n to: effectsDistribution [
	n timesRepeat: [ effectsDistribution add: type ]
]

{ #category : #tests }
RedGameTest >> dieHandleWithALoadedDieThatRollsSix [
	| aDieHandle dice die rollValues |
	rollValues := #(6).
	die := LoadedDie with: 6 andWith: rollValues.
	dice := Array with: die.
	aDieHandle := DieHandle with: dice.
	^ aDieHandle
]

{ #category : #tests }
RedGameTest >> effectsDistribution [
	| effectsDistribution |
	effectsDistribution := OrderedCollection new.
	effectsDistribution
		add: (DiscreteProbabilityEvent of: (RegularCell new) with: 0.38);
		add: (DiscreteProbabilityEvent of: (WormHoleCell new) with: 0.20);
		add: (DiscreteProbabilityEvent of: (SpeedUpCell new) with: 0.20);
		add: (DiscreteProbabilityEvent of: (CardCell new) with: 0.10);
		add: (DiscreteProbabilityEvent of: (MoonWalkCell with: 5) with: 0.10);
		add: (DiscreteProbabilityEvent of: (AtomicBombCell new) with: 0.02).
	^ effectsDistribution
]

{ #category : #tests }
RedGameTest >> playATurnWithoutMoves: game [
	| player |
	player := game currentPlayer.
	game rollDiceFor: player.
	game finishTurn.
]

{ #category : #actions }
RedGameTest >> playWithoutMoves: game [
	[ game hasEnded ] whileFalse: [ self playATurnWithoutMoves: game ].
]

{ #category : #tests }
RedGameTest >> randomBoardWith: players andWith: numberOfCells [
	| effectSource randomCells effectsDistribution aCircularBoard |
	effectsDistribution := self effectsDistribution.
	effectSource := RandomSource basedOn: effectsDistribution.
	randomCells := effectSource produce: numberOfCells.
	aCircularBoard := CircularBoard with: players andWithAll: randomCells.
	^ aCircularBoard
]

{ #category : #tests }
RedGameTest >> randomDeck [
	| deck  |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: (OverloadCard new) with: 0.17);
		add: (DiscreteProbabilityEvent of: (RedoCard  new) with: 0.17);
		add: (DiscreteProbabilityEvent of: (AccelerationCard  new) with: 0.17);
		add: (DiscreteProbabilityEvent of: (RepeatCard  new) with: 0.17);
		add: (DiscreteProbabilityEvent of: (CancellationCard new) with: 0.16);
		add: (DiscreteProbabilityEvent of: (SpeedCard  new) with: 0.16).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	^ deck
]

{ #category : #tests }
RedGameTest >> should: block raise: kindOfError withMessage: expectedMessage [
	self
		should: block
		raise: kindOfError
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedMessage ]
]

{ #category : #tests }
RedGameTest >> testAskInWhichLapIsThePlayer [
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
		withLaps: 3
		with: players
		andWith: amountOfInitialCards.
	4 timesRepeat: [ self playATurnWithoutMoves: aGame ].
	self assert: (aGame lapOf: 'martin') equals: 2.
	self assert: (aGame lapOf: 'juan') equals: 1.
	self assert: (aGame lapOf: 'roman') equals: 1
]

{ #category : #tests }
RedGameTest >> testAskRankingOfPlayerAfterTheGameEnded [
	| aCircularBoard aDieHandle players aGame fifteenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 2
		with: players
		andWith: amountOfInitialCards.
	self playWithoutMoves: aGame.
	self assert: (aGame rankingOf: 'martin') equals: 1.
	self assert: (aGame rankingOf: 'juan') equals: 2.
	self assert: (aGame rankingOf: 'roman') equals: 3
]

{ #category : #tests }
RedGameTest >> testAskRankingOfPlayerDuringTheGame [
	| aCircularBoard aDieHandle players aGame fifteenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
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
	self assert: (aGame rankingOf: 'martin') equals: 1.
	self assert: (aGame rankingOf: 'juan') equals: 2.
	self assert: (aGame rankingOf: 'roman') equals: 3
]

{ #category : #tests }
RedGameTest >> testBreakeFreeByAFreedomCard [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards die dice move |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: FreedomCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	die := LoadedDie with: 6 andWith: #(3 4 5).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice. 
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 2 to: fifteenRegularCells.
	self add: PrisionCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 12 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	amountOfInitialCards := 2.
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
	move := Move from: 'martin' with: FreedomCard new.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 8.
]

{ #category : #tests }
RedGameTest >> testBreakeFreeByMaxRollValue [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: SpeedCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	self assert: (game positionOf: 'martin') equals: 12.
]

{ #category : #tests }
RedGameTest >> testGoBackwardsIfAccumulatedEffectsGiveANegativeResult [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards die dice |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: OverloadCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	die := LoadedDie with: 3 andWith: #(3).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice.
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	amountOfInitialCards := 2.
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
	move := TargetedMove
		with: (Move from: 'martin' with: OverloadCard new) against: 'juan'.
	game play: move.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'juan' with: OverloadCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 2
]

{ #category : #tests }
RedGameTest >> testPlayAGameAndAskWhoWon [
	| aCircularBoard aDieHandle players aGame fifteenRegularCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 2
		with: players
		andWith: amountOfInitialCards .
	self playWithoutMoves: aGame.
	self assert: aGame winner equals: 'martin'
]

{ #category : #tests }
RedGameTest >> testPlayAGameWithARandomBoardAndRandomDice [
	| aCircularBoard dice aDieHandle players aGame die1 die2 die3 numberOfCells deck amountOfInitialCards |
	die1 := RandomDie with: 10.
	die2 := RandomDie with: 8.
	die3 := RandomDie with: 6.
	dice := Array with: die1 with: die2 with: die3.
	aDieHandle := DieHandle with: dice.
	players := #('martin' 'juan' 'roman').
	numberOfCells := 50.
	aCircularBoard := self
		randomBoardWith: players
		andWith: numberOfCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 3
		with: players
		andWith: amountOfInitialCards .
	self playWithoutMoves: aGame.
	self assert: aGame hasEnded
]

{ #category : #tests }
RedGameTest >> testPlayAGameWithRegularCells [
	| aCircularBoard aDieHandle players aGame fifteenRegularCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenRegularCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenRegularCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	aGame := RedGame
		with: aCircularBoard
		with: aDieHandle
		with: deck
		withLaps: 2
		with: players
		andWith: amountOfInitialCards.
	self playWithoutMoves: aGame.
	self assert: aGame hasEnded
]

{ #category : #tests }
RedGameTest >> testRollALoadedDie [
	| aDie |
	aDie := LoadedDie with: 8 andWith: #(5 6 7).
	self assert: aDie roll equals: 5.
	self assert: aDie roll equals: 6.
	self assert: aDie roll equals: 7.
	self assert: aDie roll equals: 5.
]

{ #category : #tests }
RedGameTest >> testRollARandomDie [
	| aDie |
	aDie := RandomDie with: 8.
	self assert: (aDie roll between: 1 and: 8)
]

{ #category : #tests }
RedGameTest >> testRollingADieHandleGivesTheSumOfItsDiceRollValues [
	| aDieHandle die1 die2 die3 dice |
	die1 := LoadedDie with: 4 andWith: #(4).
	die2 := LoadedDie with: 8 andWith: #(8).
	die3 := LoadedDie with: 6 andWith: #(6).
	dice := Array with: die1 with: die2 with: die3.
	aDieHandle := DieHandle with: dice.
	self assert: aDieHandle roll equals: 18
]
