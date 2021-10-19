"
I am GoogleAuthenticator.
I implement time based one time passwords (TOTP).

I can be configured with a number of parameters, my defaults corresponds to the current GoogleAuthenticator implementation (SHA1 HMAC, 80 bit keys, 64 bit message size, 6 digit code length, 30 second period) .

This mechanism is used to improve username/password authentication by requiring one time passwords generated from a previously shared secret.  This effectively constitutes two factor authentication (2FA).


Usage

On the server side initialization starts with the generation of a new shared secret.

  GoogleAuthenticator new randomSecret.

Next #base32Secret is used to turn the secret into a more human friendly form. Next this secret is shared with the client (this is often done using a QR code).

On the client side initialization starts based on the shared secret.

  GoogleAuthenticator new base32Secret: 'HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ'.

One time passwords are computed using #next or #nextPadded. The server asks the client to provide the next one time password. The client uses his instance to compute it and informs the server of it. The server then does the same computation to validate the one time password.

Obviously, client & server clocks must be synchronized. One time passwords remain valid during #timeRemaining


References

https://en.wikipedia.org/wiki/Google_Authenticator
https://github.com/google/google-authenticator
https://tools.ietf.org/html/rfc6238
https://tools.ietf.org/html/rfc4226
"
Class {
	#name : #GoogleAuthenticator,
	#superclass : #Object,
	#instVars : [
		'secret',
		'time',
		'hashMode',
		'codeLength',
		'period'
	],
	#category : #'GoogleAuthenticator-Core'
}

{ #category : #accessing }
GoogleAuthenticator >> base32Secret [
	"Return my secret as Base32 string"
	
	^ Base32Encoder new encode: self secret
]

{ #category : #initialization }
GoogleAuthenticator >> base32Secret: string [
	"Set my secret based on a Base32 encoded string"
	
	self secret: (Base32Encoder new decode: string)
]

{ #category : #private }
GoogleAuthenticator >> clock [
	"Return the clock, the number of seconds since midnight Jan 1, 1970, UTC (Unix time)"
	
	^ DateAndTime now asUnixTime
]

{ #category : #accessing }
GoogleAuthenticator >> codeLength [
	"Returnt my code length as number of digits"
	
	^ codeLength
]

{ #category : #initialization }
GoogleAuthenticator >> codeLength: count [
	"Set my code length to the specified number of digits"
	
	codeLength := count
]

{ #category : #accessing }
GoogleAuthenticator >> hashMode [
	"Return my hash mode (class)"
	
	^ hashMode
]

{ #category : #initialization }
GoogleAuthenticator >> hashMode: hashClass [
	"Set the hash algorithm to use when doing a HMAC. Typically SHA1 (the default) or SHA256."
	
	hashMode := hashClass
]

{ #category : #private }
GoogleAuthenticator >> hmac: message [
	"Compute a HMAC on message using my hashing algorithm"
	
	^ (HMAC on: self hashMode new)
		key: self secret;
		digestMessage: message
]

{ #category : #initialization }
GoogleAuthenticator >> initialize [
	super initialize.
	self hashMode: SHA1.
	self codeLength: 6.
	self period: 30.
	self useClock
]

{ #category : #private }
GoogleAuthenticator >> messageSize [
	"Return the byte size of our time message"
	
	^ 8
]

{ #category : #accessing }
GoogleAuthenticator >> movingFactor [
	"Return the moving factor to use. Normally this value changes every period unless a fixed time was set."
	
	^ self time // self period
]

{ #category : #accessing }
GoogleAuthenticator >> next [
	"Return the next one time password as an integer of codeLength.
	This value remains constant for #timeRemaining (the current period),
	unless a fixed time is used, then it never changes."
	
	| message hmac truncatedValue |
	message := self movingFactor asByteArrayOfSize: self messageSize.
	hmac := self hmac: message.
	truncatedValue := self truncate: hmac.
	^ truncatedValue \\ (10 ** self codeLength)
]

{ #category : #accessing }
GoogleAuthenticator >> nextPadded [
	"Return the next one time password as a padded string of code length"
	
	^ self next printStringPadded: self codeLength
]

{ #category : #accessing }
GoogleAuthenticator >> period [
	"Return the period in seconds within which one time passwords are identical. The default is 30 seconds. See also #timeRemaining."
	
	^ period
]

{ #category : #initialization }
GoogleAuthenticator >> period: seconds [
	"Set the period to seconds. Within this period, one time passwords are identical. The default is 30 seconds. See also #timeRemaining."
	
	period := seconds
]

{ #category : #private }
GoogleAuthenticator >> randomByteArrayOfSize: byteCount [
	"Return a new byte array of size byteCount filled with random values"

	| bytes |
	bytes := ByteArray new: byteCount.
	1 to: byteCount do: [ :each | 
		bytes at: each put: 256 atRandom - 1 ].
	^ bytes
]

{ #category : #initialization }
GoogleAuthenticator >> randomSecret [
	"Initialize me to a random secret"
	
	self randomSecretOfSize: 10
]

{ #category : #initialization }
GoogleAuthenticator >> randomSecretOfSize: byteCount [
	"Initialize me to a random byte array secret of size byteCount"
	
	self secret: (self randomByteArrayOfSize: byteCount)
]

{ #category : #accessing }
GoogleAuthenticator >> secret [
	"Return my secret as byte array"
	
	^ secret
]

{ #category : #initialization }
GoogleAuthenticator >> secret: byteArray [
	"Set my secret to byteArray"
	
	secret := byteArray
]

{ #category : #accessing }
GoogleAuthenticator >> time [
	"Return the time value, an integer. Either the current clock or a fixed value."
	
	^ time ifNil: [ self clock ]
]

{ #category : #initialization }
GoogleAuthenticator >> time: fixedTime [
	"Configure me to use fixedTime as time value. The time value will never change after this and each computed one time password will be identical."
	
	time := fixedTime 
]

{ #category : #accessing }
GoogleAuthenticator >> timeRemaining [
	"Return how many seconds are remaining in the current period. This is effectively the period in which the one time password computed in #next is valid."
	
	^ self time \\ self period
]

{ #category : #private }
GoogleAuthenticator >> truncate: byteArray [
	"Truncate byte array to a smaller 32 bit integer, using a specific algorithm described in the specification (use last half byte to offset a 4 byte sub array, convert it to an integer, clearing the top bit)."
	
	| offset quad |
	offset := byteArray last bitAnd: 16rF.
	quad := byteArray copyFrom: offset + 1 to: offset + 4.
	^ quad asInteger bitAt: 32 put: 0
]

{ #category : #initialization }
GoogleAuthenticator >> useClock [
	"Configure me to use the (unix time) clock (the default). One time passwords will change every period."
	
	time := nil
]
