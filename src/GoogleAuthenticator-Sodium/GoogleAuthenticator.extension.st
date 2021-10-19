Extension { #name : #GoogleAuthenticator }

{ #category : #'*GoogleAuthenticator-Sodium' }
GoogleAuthenticator >> randomByteArrayOfSize: byteCount [
	"Use Libsodium binding Crypto-Nacl to get cryptographically secure random bytes."
	^ Nacl randomBytes: byteCount
]
