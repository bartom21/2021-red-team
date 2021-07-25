Class {
	#name : #ExceptionsTest,
	#superclass : #RedGameTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
ExceptionsTest >> testCannotAskARandomSourceToProduceAnInvalidNumberOfItems [
	| randomSource |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: AccelerationCard new with: 1).
	randomSource := RandomSource basedOn: cardsDistribution.
	self should: [ randomSource produce: -1 ] raise: Error withMessage: 'Cant produce an invalid number of items'.
]

{ #category : #tests }
ExceptionsTest >> testCannotAskPositionOfAnInvalidPlayer [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards |
	deck := self randomDeck.
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
	self should: [game positionOf: 'Juan Roman Riquelme'] raise: Error withMessage: 'That player is not in the game'.
]

{ #category : #tests }
ExceptionsTest >> testCannotAskWhoWonBeforeTheGameEnded [
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
	4 timesRepeat: [ self playATurnWithoutMoves: aGame ].
	self
		should: [ aGame winner ]
		raise: Error
		withMessage: 'the game is still running'
]

{ #category : #tests }
ExceptionsTest >> testCannotCancelACardIfNoPermanentCardsAreActive [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards cards objectiveMove |
	cards := OrderedCollection new.
	cards
		add: SpeedCard new;
		add: RepeatCard new;
		add: OverloadCard new;
		add: CancellationCard new.
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
	game rollDiceFor: 'juan'.
	objectiveMove := TargetedMove with: (Move from: 'martin' with: OverloadCard new) against: 'juan'.
	move := TargetedMove with: (Move from: 'juan' with: CancellationCard new) against: objectiveMove .
	
	self
		should: [ game play: move ]
		raise: Error
		withMessage: 'there are no permanent cards'.
]

{ #category : #tests }
ExceptionsTest >> testCannotCancelACardThatHasntBeenPlayed [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards cards objectiveMove |
	cards := OrderedCollection new.
	cards
		add: SpeedCard new;
		add: RepeatCard new;
		add: OverloadCard new;
		add: CancellationCard new.
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
		with: (Move from: 'martin' with: SpeedCard new) against: 'martin'.
	game play: move.
	game finishTurn.
	game rollDiceFor: 'juan'.
	objectiveMove := TargetedMove
		with: (Move from: 'martin' with: OverloadCard new) against: 'juan'.
	move := TargetedMove
		with: (Move from: 'juan' with: CancellationCard new) against: objectiveMove .
	
	self
		should: [ game play: move ]
		raise: Error
		withMessage: 'Cant cancel a card that wasnt played'.
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateABoardWithoutCells [
	| players cells |
	players := #('martin' 'juan' 'roman').
	cells := OrderedCollection new.
	self
		should: [ CircularBoard with: players andWithAll: cells ]
		raise: Error
		withMessage: 'cant create a board without cells'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateABoardWithoutPlayers [
	| players tenRegularCells |
	players := Array new.
	tenRegularCells := OrderedCollection new.
	self add: RegularCell new times: 10 to: tenRegularCells.
	self
		should: [ CircularBoard with: players andWithAll: tenRegularCells ]
		raise: Error
		withMessage: 'cant create a board without players'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateADieHandleWithoutDice [
	| dice |
	dice := Array new.
	self
		should: [ DieHandle with: dice ]
		raise: Error
		withMessage: 'cannot create an empty die handle'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateADieWithLessThanThreeFaces [
	self
		should: [ RandomDie with: 2 ]
		raise: Error
		withMessage: 'invalid number of faces'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateADiscreteProbabilityEventWithAnInvalidProbability [
	self should: [DiscreteProbabilityEvent of: AccelerationCard new with: 2] raise: Error withMessage: 'Cant create a DiscreteProbabilityEvent with an invalid probabilty'.
	self should: [DiscreteProbabilityEvent of: AccelerationCard new with: -1] raise: Error withMessage: 'Cant create a DiscreteProbabilityEvent with an invalid probabilty'.
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateAGameWithDiffetenPlayersThanBoard [
	| aCircularBoard aDieHandle fifteenCells deck amountOfInitialCards playersBoard playersGame |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	playersBoard := #('martin' 'juan' 'roman').
	playersGame := #('mateo' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: playersBoard
		andWithAll: fifteenCells.
	deck := self randomDeck.
	amountOfInitialCards := -1.
	self
		should: [ RedGame
				with: aCircularBoard
				with: aDieHandle
				with: deck
				withLaps: 2
				with: playersGame
				andWith: amountOfInitialCards ]
		raise: Error
		withMessage: 'game and board must have the same players'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateAGameWithInvalidNumberOfInitialCards [
	| aCircularBoard aDieHandle players fifteenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	deck := self randomDeck.
	amountOfInitialCards := -1.
	self
		should: [ RedGame
				with: aCircularBoard
				with: aDieHandle
				with: deck
				withLaps: 2
				with: players
				andWith: amountOfInitialCards ]
		raise: Error
		withMessage: 'invalid number of initial cards'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateAGameWithInvalidNumberOfLaps [
	| aCircularBoard aDieHandle players fifteenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	deck := self randomDeck.
	amountOfInitialCards := 2.
	self
		should: [ RedGame
				with: aCircularBoard
				with: aDieHandle
				with: deck
				withLaps: 0
				with: players
				andWith: amountOfInitialCards ]
		raise: Error
		withMessage: 'invalid number of laps'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateAGameWithoutPlayers [
	| aCircularBoard die dice aDieHandle players fifteenCells deck amountOfInitialCards |
	die := LoadedDie with: 6 andWith: #(6).
	dice := Array with: die.
	aDieHandle := DieHandle with: dice.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	deck := self randomDeck.
	players := #().
	amountOfInitialCards := 2.
	self
		should: [ RedGame
				with: aCircularBoard
				with: aDieHandle
				with: deck
				withLaps: 2
				with: players
				andWith: amountOfInitialCards ]
		raise: Error
		withMessage: 'cannot create a RedGame without players'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateALoadedDeckWithoutCards [
	self should: [LoadedDeck with: OrderedCollection new] raise: Error withMessage: 'Cannot create a LoadedDeck without cards'.
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateAPositionWithoutName [
	self
		should: [ Position from: '' ]
		raise: Error
		withMessage: 'cant create a Position without a name'
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateARandomSourceWithEventsProbabilitiesWhichDontSum1 [
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RepeatCard new with: 0.6);
		add: (DiscreteProbabilityEvent of: AccelerationCard new with: 0.6).
	self should: [Deck with: (RandomSource basedOn: cardsDistribution)] raise: Error withMessage: 'The sum of all events probabilities must sum 1'.
	
]

{ #category : #tests }
ExceptionsTest >> testCannotCreateARandomSourceWithoutAEventsDistribution [
	self
		should: [ RandomSource basedOn: OrderedCollection new ]
		raise: Error
		withMessage: 'cant create a RandomSource without a events distribution'.
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayACardYouDontHave [
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
	move := Move
		from: 'martin'
		with: AccelerationCard new.
	self
		should: [ game play: move ]
		raise: Error
		withMessage: 'cant use a card thats not yours'
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayAMoveWithTargetedCard [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards move |
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
	move := Move from: 'martin' with: OverloadCard new .
	self
		should: [ game play: move]
		raise: Error
		withMessage: 'OverloadCard must be played on a Targeted Move'
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayAPermanentCardWhenItsNotYourTurn [
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
	move := TargetedMove with: (Move from: 'juan' with: OverloadCard new) against: 'martin'.
	self
		should: [ game play: move ]
		raise: Error
		withMessage: 'cant use a permanent card on anothers turn'
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayARedoMoveWithoutAnyPreviewsMoves [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck move amountOfInitialCards |
	cardsDistribution := OrderedCollection new.
	cardsDistribution
		add: (DiscreteProbabilityEvent of: RedoCard new with: 1).
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
	move := TargetedMove with: (Move from: 'martin' with: RedoCard new) against: 'martin'.
	self
		should: [ game play: move ]
		raise: Error
		withMessage: 'Cant use a Redo Card without previews moves'
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayATargetMoveWithAnAccelerationCard [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards |
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
	self
		should: [ TargetedMove with: (Move from: 'martin' with: AccelerationCard new) against: 'martin'.]
		raise: Error
		withMessage: 'Cant create a Target Move with an AccelerationCard'
]

{ #category : #tests }
ExceptionsTest >> testCannotPlayAfterTheGameHasEnded [
	| aCircularBoard aDieHandle players aGame fifteenCells deck amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	cardsDistribution := OrderedCollection new.
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
	self
		should: [ self playATurnWithoutMoves: aGame ]
		raise: Error
		withMessage: 'the game has ended'
]

{ #category : #tests }
ExceptionsTest >> testCannotRollDiceForAnInvalidPlayer [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards |
	deck := self randomDeck.
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
	self should: [game rollDiceFor: 'Juan Roman Riquelme'] raise: Error withMessage: 'Cannot roll for a player that is not playing'.
]

{ #category : #tests }
ExceptionsTest >> testCannotRollTheDiceTwiceOnTheSameTurn [
	| aDieHandle players fifteenRegularCells aCircularBoard game deck amountOfInitialCards |
	deck := self randomDeck.
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
	self should: [game rollDiceFor: 'martin'] raise: Error withMessage: 'can only roll the dice once on your turn'.
]

{ #category : #tests }
ExceptionsTest >> testCannotUseACardAfterTheGameHasEnded [
	| aCircularBoard aDieHandle players aGame fifteenCells deck move amountOfInitialCards |
	aDieHandle := self dieHandleWithALoadedDieThatRollsSix.
	players := #('martin' 'juan' 'roman').
	fifteenCells := OrderedCollection new.
	self add: RegularCell new times: 15 to: fifteenCells.
	aCircularBoard := CircularBoard
		with: players
		andWithAll: fifteenCells.
	cardsDistribution := OrderedCollection new.
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
	move := Move from: 'martin' with: AccelerationCard new.
	self
		should: [ aGame play: move ]
		raise: Error
		withMessage: 'the game has ended'
]
