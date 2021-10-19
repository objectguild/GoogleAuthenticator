"
Test vectors based on https://tools.ietf.org/html/rfc6238#appendix-B
"
Class {
	#name : #GoogleAuthenticatorTests,
	#superclass : #TestCase,
	#category : #'GoogleAuthenticator-Tests'
}

{ #category : #accessing }
GoogleAuthenticatorTests >> secretSHA1 [
	^ ByteArray readHexFrom: '3132333435363738393031323334353637383930'
]

{ #category : #accessing }
GoogleAuthenticatorTests >> secretSHA256 [
	^ ByteArray readHexFrom: '3132333435363738393031323334353637383930313233343536373839303132'
]

{ #category : #accessing }
GoogleAuthenticatorTests >> sha1TestVectors [
	^ #(
		59 				94287082
		1111111109 	07081804
		1111111111 	14050471
		1234567890 	89005924
		2000000000 	69279037
		20000000000 	65353130
		)
]

{ #category : #accessing }
GoogleAuthenticatorTests >> sha256TestVectors [
	^ #(
		59 				46119246
		1111111109 	68084774
		1111111111 	67062674
		1234567890 	91819424
		2000000000 	90698825
		20000000000	77737706
		)
]

{ #category : #testing }
GoogleAuthenticatorTests >> testClientServer [
	| server sharedSecret client |
	"Server side an authenticator is set up, initialized with a secret"
	server := GoogleAuthenticator new.
	server randomSecret.
	"The shared secret is exchanged between the server and the client"
	sharedSecret := server base32Secret.
	"The client sets up its authenticator, initialized wit the shared secret"
	client := GoogleAuthenticator new.
	client base32Secret: sharedSecret.
	"Make sure we're not too close to the end of the current period"
	client timeRemaining < 2 ifTrue: [ 2 seconds wait ].
	"From now on, both are in sync, generating the same one time passwords"
	self assert: client next equals: server next.
	self assert: client next equals: server next
]

{ #category : #testing }
GoogleAuthenticatorTests >> testSimple [
	| time secret authenticator |
	time := 1478167454.
	secret := 'HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ'.
	authenticator := GoogleAuthenticator new.
	authenticator base32Secret: secret.
	authenticator time: time.
	self assert: authenticator nextPadded equals: '488676'.
]

{ #category : #testing }
GoogleAuthenticatorTests >> testVectorsSHA1 [
	| authenticator |
	authenticator := GoogleAuthenticator new.
	authenticator secret: self secretSHA1.
	authenticator codeLength: 8.
	self sha1TestVectors pairsDo: [ :time :totp |
		authenticator time: time.
		self assert: authenticator next equals: totp ]
]

{ #category : #testing }
GoogleAuthenticatorTests >> testVectorsSHA256 [
	| authenticator |
	authenticator := GoogleAuthenticator new.
	authenticator hashMode: SHA256.
	authenticator secret: self secretSHA256.
	authenticator codeLength: 8.
	self sha256TestVectors pairsDo: [ :time :totp |
		authenticator time: time.
		self assert: authenticator next equals: totp ]
]
