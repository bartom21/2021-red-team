Class {
	#name : #CardDealer,
	#superclass : #Object,
	#instVars : [
		'assignatedCards',
		'deck',
		'lastMove',
		'permanentEffects'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
CardDealer class >> assertPositiveNumberOfAssignatedCards: aNumberOfAssignatedCards [
	aNumberOfAssignatedCards >= 0
		ifFalse: [ self error: 'invalid number of initial cards' ]
]

{ #category : #'instance creation' }
CardDealer class >> with: players with: value andWith: deck [
	self assertPositiveNumberOfAssignatedCards: value.
	^ self new
		initializeWith: value
		with: players
		andWith: deck
]

{ #category : #actions }
CardDealer >> accumulatePermanentEffectsOn: target [
	^permanentEffects ifEmpty: [ 0 ] ifNotEmpty: [permanentEffects sum: [ :move | move effectOn: target]].
	
	
]

{ #category : #actions }
CardDealer >> activatePermanentEffectsFor: player on: target  with: aCircularBoard [
	| effects |
	effects := permanentEffects select: [ :move | (move isTargeted) and: [move target = target]].
	effects ifNotEmpty: [effects do: [ :move | move effectWith: self andWith: aCircularBoard ]].
	
	
]

{ #category : #actions }
CardDealer >> addCardTo: aPlayerName [
	assignatedCards add: (AssignatedCard from: aPlayerName with: deck takeACard).
]

{ #category : #actions }
CardDealer >> addPermanentEffect: aMove [
	permanentEffects add: aMove copy.
]

{ #category : #actions }
CardDealer >> assertIfCardIsAssignated: aMove [
	assignatedCards
		detect: [ :assignatedCard | 
			assignatedCard isAssignated: aMove card To: aMove source ]
		ifFound: [ :assignatedCard | assignatedCards remove: assignatedCard ]
		ifNone: [ self error: 'cant use a card thats not yours' ]
]

{ #category : #actions }
CardDealer >> handle: aMove with: aGame [ 
	self assertIfCardIsAssignated: aMove.
	aMove activateEffect: aGame .
	self updateLastMove: aMove
]

{ #category : #initialize }
CardDealer >> initializeWith: aNumberOfAssignatedCards with: players andWith: aDeck [
	| auxCards |
	auxCards := OrderedCollection new.
	players do: [ :playerName | aNumberOfAssignatedCards timesRepeat: [auxCards add: (AssignatedCard from: playerName with: (aDeck takeACard))]].
	assignatedCards := auxCards.
	deck := aDeck.
	permanentEffects := OrderedCollection new.
]

{ #category : #actions }
CardDealer >> removePermanentEffect: aMove [
	permanentEffects ifEmpty: [ self error: 'there are no permanent cards' ].
	(permanentEffects anySatisfy: [ :move | move equalsMove: aMove ]) ifFalse: [ self error: 'Cant cancel a card that wasnt played' ].
	permanentEffects := permanentEffects reject: [ :move | move equalsMove: aMove ].
]

{ #category : #actions }
CardDealer >> updateLastMove: aMove [
	(aMove card equals: RedoCard new)
		ifFalse: [ lastMove := aMove copy ]
]

{ #category : #actions }
CardDealer >> useLastCardEffectWith: aMove andWith: aGame [
	| newCard newMove |
	lastMove ifNil: [ self error: 'Cant use a Redo Card without previews moves' ].
	newCard := lastMove card copy.
	newMove := aMove changeCard: newCard.
	newMove activateEffect: aGame .
]
