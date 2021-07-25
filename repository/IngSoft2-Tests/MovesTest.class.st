Class {
	#name : #MovesTest,
	#superclass : #RedGameTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
MovesTest >> testACancellationMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move cards objectiveMove amountOfInitialCards|
	cards := OrderedCollection new.
	cards
		add: OverloadCard new;
		add: CancellationCard new;
		add: OverloadCard new;
		add: RepeatCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove
		with: (Move from: 'martin' with: OverloadCard new) against: 'juan'.
	game play: move.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'juan' with: OverloadCard new) against: 'martin'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	objectiveMove := TargetedMove
		with: (Move from: 'juan' with: OverloadCard new) against: 'martin'.
	move := TargetedMove
		with: (Move from: 'martin' with: CancellationCard new) against: objectiveMove .
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 8.
	self assert: (game positionOf: 'martin') equals: 12
]

{ #category : #tests }
MovesTest >> testACancellationMoveAgainstASpeedPlus [
	| deck aDieHandle players fifteenRegularCells aCircularBoard amountOfInitialCards game move cards objectiveMove |
	cards := OrderedCollection new.
	cards
		add: SpeedPlusCard new;
		add: CancellationCard new;
		add: SpeedPlusCard new;
		add: CancellationCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove with: (Move from: 'martin' with: SpeedPlusCard new) against: 6.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	objectiveMove := TargetedMove with: (Move from: 'martin' with: SpeedPlusCard new) against: 6.
	move := TargetedMove
		with: (Move from: 'juan' with: CancellationCard new) against: objectiveMove .
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 10.
	self assert: (game positionOf: 'juan') equals: 6
]

{ #category : #tests }
MovesTest >> testARedoMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move cards amountOfInitialCards |
	cards := OrderedCollection new.
	cards
		add: OverloadCard new;
		add: RedoCard new;
		add: SpeedCard new;
		add: RepeatCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove
		with: (Move from: 'martin' with: OverloadCard  new) against: 'juan'.
	game play: move.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'juan' with: SpeedCard  new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'martin' with: RedoCard new) against: 'martin'.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 10.
	self assert: (game positionOf: 'martin') equals: 13
]

{ #category : #tests }
MovesTest >> testARedoMoveAfterARedoMoveReusesTheSameCard [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move cards amountOfInitialCards |
	cards := OrderedCollection new.
	cards
		add: RedoCard new;
		add: OverloadCard new;
		add: SpeedCard new;
		add: RedoCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove
		with: (Move from: 'juan' with: SpeedCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'martin' with: RedoCard new) against: 'martin'.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	move := TargetedMove
		with: (Move from: 'juan' with: RedoCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 15.
	self assert: (game positionOf: 'martin') equals: 13
]

{ #category : #tests }
MovesTest >> testARepeatMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards die dice |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	die := LoadedDie with: 6 andWith: #(4 4 2 3).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice. 
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: (MoonWalkCell with: 3) times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
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
	game finishTurn.
	move := TargetedMove with: (Move from: 'juan' with: RepeatCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 4.
	self assert: (game positionOf: 'martin') equals: 3
	
]

{ #category : #tests }
MovesTest >> testASpeedMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: SpeedCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove
		with: (Move from: 'martin' with: SpeedCard new) against: 'martin'.
	game play: move.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 12.
	self assert: (game positionOf: 'martin') equals: 13
]

{ #category : #tests }
MovesTest >> testASpeedPlusMoveToARegularCell [
	| deck aDieHandle players fifteenRegularCells aCircularBoard amountOfInitialCards game move cards |
	cards := OrderedCollection new.
	cards
		add: SpeedPlusCard new;
		add: CancellationCard new;
		add: SpeedPlusCard new;
		add: CancellationCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove with: (Move from: 'martin' with: SpeedPlusCard new) against: 6.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 10
]

{ #category : #tests }
MovesTest >> testAnAccelerationMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: AccelerationCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := Move from: 'martin' with: AccelerationCard new.
	game play: move.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 14.
	self assert: (game positionOf: 'martin') equals: 13
]

{ #category : #tests }
MovesTest >> testAnOverloadMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: OverloadCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
	move := TargetedMove with: (Move from: 'martin' with: OverloadCard new) against: 'juan'.
	game play: move.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 4
]

{ #category : #tests }
MovesTest >> testPlayAnInstantCardWhenItsNotYourTurn [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: SpeedUpCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
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
	move := TargetedMove
		with: (Move from: 'juan' with: RepeatCard new) against: 'juan'.
	game play: move.
	game finishTurn.

	self assert: (game positionOf: 'juan') equals: 4.
	self assert: (game positionOf: 'martin') equals: 10.
]

{ #category : #tests }
MovesTest >> testPlayingARepeatCardHasNoEffectIfAnyoneRollsTheDice [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
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
		andWith: amountOfInitialCards .
	move := TargetedMove
		with: (Move from: 'juan' with: RepeatCard new) against: 'juan'.
	game play: move.
	self assert: (game positionOf: 'juan') equals: 0
]

{ #category : #tests }
MovesTest >> testRedoAnAccelerationMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move cards amountOfInitialCards |
	cards := OrderedCollection new.
	cards
		add: AccelerationCard new;
		add: RedoCard new;
		add: AccelerationCard new;
		add: AccelerationCard new.
	deck := LoadedDeck with: cards.
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 30 to: fifteenRegularCells.
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
		andWith: amountOfInitialCards .
	game rollDiceFor: 'martin'.
	game finishTurn.
	move := Move from: 'juan' with: AccelerationCard new.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	move := Move from: 'martin' with: RedoCard new.
	game play: move.
	game rollDiceFor: 'martin'.
	game finishTurn.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'martin') equals: 14.
	self assert: (game positionOf: 'juan') equals: 15
]

{ #category : #tests }
MovesTest >> testRepeatAMoonWalkMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards die dice |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	die := LoadedDie with: 6 andWith: #(4 4 2 3).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice. 
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: (MoonWalkCell with: 3) times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
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
	game finishTurn.
	move := TargetedMove with: (Move from: 'juan' with: RepeatCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 4.
	self assert: (game positionOf: 'martin') equals: 3
	
]

{ #category : #tests }
MovesTest >> testRepeatASpeedUpCellMove [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 1).
	deck := Deck with: (RandomSource basedOn: cardsDistribution).
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan').
	fifteenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 5 to: fifteenRegularCells.
	self add: SpeedUpCell new times: 1 to: fifteenRegularCells.
	self add: RegularCell new times: 9 to: fifteenRegularCells.
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
	move := TargetedMove with: (Move from: 'juan' with: RepeatCard new) against: 'juan'.
	game play: move.
	game rollDiceFor: 'juan'.
	game finishTurn.
	self assert: (game positionOf: 'juan') equals: 10.
	self assert: (game positionOf: 'martin') equals: 10
	
]
