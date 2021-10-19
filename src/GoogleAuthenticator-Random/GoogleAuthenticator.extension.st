Extension { #name : #GoogleAuthenticator }

{ #category : #'*GoogleAuthenticator-Random' }
GoogleAuthenticator >> randomByteArrayOfSize: byteCount [
	"Return a new byte array of size byteCount filled with random values"

	| bytes |
	bytes := ByteArray new: byteCount.
	1 to: byteCount do: [ :each | 
		bytes at: each put: 256 atRandom - 1 ].
	^ bytes
]
