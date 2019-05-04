Class {
	#name : #XdGlamorousDocumentsListLook,
	#superclass : #XdDocumentsLook,
	#instVars : [
		'list',
		'toolbar',
		'listHandler'
	],
	#category : #'XDoc-Client-Documents - Brick'
}

{ #category : #'as yet unclassified' }
XdGlamorousDocumentsListLook >> initialize [
	super initialize.
	changes
		add:
			(#(widget layout)
				asBrLookPropertyChangeWithValue: [ BlLinearLayout vertical ])
]

{ #category : #initialization }
XdGlamorousDocumentsListLook >> initializeList [
	listHandler := XdDocumentsHandler new.
	list := BrColumnedList new.
	list addEventHandler: listHandler.
	list column 
		title: 'Author';
		stencil: [ :aFileInfo :anIndex | 
			BrLabel new
				look: BrGlamorousListLabelLook;
				text: aFileInfo author;
				hMatchParent. ].
	list column 
		title: 'Title';
		stencil: [ :aFileInfo :anIndex | 
			BrLabel new
				look: BrGlamorousListLabelLook;
				text: aFileInfo title;
				hMatchParent. ].
	self widget addChild: list as: #list.
]

{ #category : #initialization }
XdGlamorousDocumentsListLook >> initializeLook [
	super initializeLook.
	self initializeToolbar.
	self initializeList
]

{ #category : #initialization }
XdGlamorousDocumentsListLook >> initializeToolbar [
	| aButton |
	toolbar := BrToolbar new.
	toolbar look: BrGlamorousToolbarLook horizontal.
	toolbar constraintsDo: [ :c | 
		c linear horizontal alignRight ].
	aButton := BrButton new
		look: BrGlamorousButtonWithIconAndLabelLook;
		label: 'Refresh published documents';
		icon: BrGlamorousIcons refresh asElement;
		action: [ self refreshList ].
	toolbar addItem: aButton.
	self widget addChild: toolbar as: #toolbar.
]

{ #category : #hooks }
XdGlamorousDocumentsListLook >> onClientChange [
	self widgetDo: [ :aWidget | 
		listHandler client: self client.
		self updateList ]
]

{ #category : #actions }
XdGlamorousDocumentsListLook >> refreshList [
	self widgetDo: [ :aWidget | 
		self updateList.
	 ]
]

{ #category : #private }
XdGlamorousDocumentsListLook >> updateList [
	self client async 
		callback: [ :aList | 
			self widgetDo: [ :aWidget | 
				list enqueueTask: (BlTaskAction new action: [ 
					list display: aList ]) ] ];
		documents
]