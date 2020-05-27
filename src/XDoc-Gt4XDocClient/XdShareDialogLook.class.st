Class {
	#name : #XdShareDialogLook,
	#superclass : #BrLook,
	#traits : 'TXdShareInformationHolderAccess + TXdShareActionsAccess',
	#classTraits : 'TXdShareInformationHolderAccess classTrait + TXdShareActionsAccess classTrait',
	#instVars : [
		'pager',
		'document'
	],
	#category : #'XDoc-Gt4XDocClient-Dialog - Look'
}

{ #category : #execution }
XdShareDialogLook >> executeAsTaskIt: aBlock [ 
	BlTktWorkerProvider highUIExternalResourceBoundPool 
		schedule: aBlock
]

{ #category : #execution }
XdShareDialogLook >> executeDeleteAction [
	self pager addPage: (self 
		newProgressPageLabel: 'Deleting...').
	self pager smoothScrollToLast.
	self executeAsTaskIt: [ 
		| anAnswer |
		anAnswer := self actions delete.
		self pager addPage: anAnswer asElement.
		self pager smoothScrollToLast ].
]

{ #category : #execution }
XdShareDialogLook >> executePublishAction [
	self pager addPage: (self 
		newProgressPageLabel: 'Publishing...').
	self pager smoothScrollToLast.
	self executeAsTaskIt: [ 
		| anAnswer |
		anAnswer := self actions publish.
		self pager addPage: anAnswer asElement.
		self pager smoothScrollToLast ].
]

{ #category : #execution }
XdShareDialogLook >> executeUpdateAction [
	self pager addPage: (self 
		newProgressPageLabel: 'Updating...').
	self pager smoothScrollToLast.
	self executeAsTaskIt: [ 
		| anAnswer |
		anAnswer := self actions update.
		self pager addPage: anAnswer asElement.
		self pager smoothScrollToLast ]
]

{ #category : #initialization }
XdShareDialogLook >> initialize [ 
	super initialize.
	self initializeInformationHolder.
	self initializeActions.
	pager := BrPager new.
	self addChangeAddChildAs: #(content pager) with: [ pager ].
	self initializeFirstPage.
]

{ #category : #initialization }
XdShareDialogLook >> initializeFirstPage [
	self pager addPage: self newInitialPage
]

{ #category : #initialization }
XdShareDialogLook >> initializeListeners [
	super initializeListeners.
	
	self 
		addEventHandlerOn: XdShareInformationChanged 
		do: [ :anEvent | self onInformationChange: anEvent information ].
	self 
		addEventHandlerOn: XdShareActionsChanged 
		do: [ :anEvent | self onActionsChange: anEvent actions ].
]

{ #category : #initialization }
XdShareDialogLook >> initializeRequests [
	super initializeRequests.
	
	self request: XdShareInformationRequest new.
	self request: XdShareActionsRequest new.
]

{ #category : #'instance creation' }
XdShareDialogLook >> newDeletePage: aString action: aBlock [
	<return: #BlElement>
	^ XdShareDeleteDialogWithAuthenticationStencil new
		informationHolder: self informationHolder;
		nextAction: aBlock;
		nextActionLabel: aString;
		asElement 
]

{ #category : #'instance creation' }
XdShareDialogLook >> newInitialPage [
	<return: #BlElement>
	^ XdInitialDialogStencil new 
		informationHolder: self informationHolder;
		publishAction: [ self proceedPublishStep ];
		updateAction: [ self proceedUpdateStep ];
		deleteAction: [ self proceedDeleteStep ];
		asElement
]

{ #category : #'instance creation' }
XdShareDialogLook >> newProgressPage [
	<return: #BlElement>
	^ XdProgressDialogStencil new
		informationHolder: self informationHolder
		asElement
]

{ #category : #'instance creation' }
XdShareDialogLook >> newProgressPageLabel: aString [
	<return: #BlElement>
	^ XdProgressDialogStencil new
		informationHolder: self informationHolder;
		title: aString;
		asElement
]

{ #category : #'instance creation' }
XdShareDialogLook >> newPublishPage: aString action: aBlock [ 
	<return: #BlElement>
	^ XdSharePublishDialogWithAuthenticationStencil new
		informationHolder: self informationHolder;
		nextAction: aBlock;
		nextActionLabel: aString;
		asElement 
]

{ #category : #'instance creation' }
XdShareDialogLook >> newUpdatePage: aString action: aBlock [ 
	<return: #BlElement>
	^ XdShareUpdateDialogWithAuthenticationStencil new
		informationHolder: self informationHolder;
		nextAction: aBlock;
		nextActionLabel: aString;
		asElement 
]

{ #category : #hooks }
XdShareDialogLook >> onActionsChange: anInformation [
	self actions: anInformation.
]

{ #category : #hooks }
XdShareDialogLook >> onInformationChange: anInformation [
	self information: anInformation.
]

{ #category : #accessing }
XdShareDialogLook >> pager [
	<return: #BrPager>
	^ pager
]

{ #category : #accessing }
XdShareDialogLook >> pages [
	^ self pager pages
]

{ #category : #steps }
XdShareDialogLook >> proceedDeleteStep [
	self pager viewModel removePagesAfter: self pager viewModel pages first.
	self pager addPage: (self newDeletePage: 'Delete' action: [self executeDeleteAction]).
	self pager smoothScrollToLast.
]

{ #category : #steps }
XdShareDialogLook >> proceedPublishStep [
	self pager viewModel removePagesAfter: self pager viewModel pages first.
	self pager addPage: (self newPublishPage: 'Publish' action: [self executePublishAction]).
	self pager smoothScrollToLast.
]

{ #category : #steps }
XdShareDialogLook >> proceedUpdateStep [
	self pager viewModel removePagesAfter: self pager viewModel pages first.
	self pager addPage: (self newUpdatePage: 'Update' action: [self executeUpdateAction]).
	self pager smoothScrollToLast.
]