"
I am Base32Encoder.
An implementation of Base32 encoding according to RFC 4648.

See also https://en.wikipedia.org/wiki/Base32

Base32 encoding uses an alphabet of 32 characters, each of which represents a 5 bit value,  to encode bytes to a string. 

To encode 5 bytes (40 bits) 8 characters are used. The padding character $= is used when necessary.

Usage:

  Base32Encoder new encode: 'foo' asByteArray.

  (Base32Encoder new decode: 'MZXW6===') asString.

"
Class {
	#name : #Base32Encoder,
	#superclass : #Object,
	#instVars : [
		'alphabet'
	],
	#category : #'GoogleAuthenticator-Core'
}

{ #category : #accessing }
Base32Encoder >> alphabet [
	"Return the alalphabet I am using"
	
	^ alphabet
]

{ #category : #initialization }
Base32Encoder >> alphabet: string [
	"Configure me to use string of size 32 as alphabet"
	
	alphabet := string
]

{ #category : #converting }
Base32Encoder >> decode: string [
	"Decode a Base32 encoded string into a byte array"
	
	^ ByteArray streamContents: [ :byteStream |
		self decode: string readStream to: byteStream ]
]

{ #category : #converting }
Base32Encoder >> decode: stringStream to: byteStream [
	"Decode Base32 encoded characters to bytes, in blocks of 8 characters / 5 bytes"
	
	| bits count character value |
	[ stringStream atEnd ] whileFalse: [
		bits := count := 0.
		8 timesRepeat: [ 
			(character := stringStream next) = self padCharacter 
				ifTrue: [ value := 0 ]  
				ifFalse: [ 
					value := (alphabet indexOf: character) - 1.
					count := count + 1 ].
			bits := (bits << 5) bitXor: value ].
		byteStream 
			next: count * 5 // 8 
			putAll: (bits asByteArrayOfSize: 5) ]
]

{ #category : #converting }
Base32Encoder >> encode: byteArray [
	"Encode a byte array into a Base32 encoded string"
	
	^ String streamContents: [ :stringStream |
		self encode: byteArray readStream to: stringStream ]
]

{ #category : #converting }
Base32Encoder >> encode: byteStream to: stringStream [
	"Encode bytes to Base32 encoded characters, in blocks of 5 bytes / 8 characters"
	
	| bits count value buffer actual |
	buffer := String new: 8.
	[ byteStream atEnd ] whileFalse: [ 
		bits := count := 0.
		5 timesRepeat: [
			(value := byteStream next)
				ifNil: [ value := 0 ]
				ifNotNil: [ count := count + 1 ].
			bits := (bits << 8) bitXor: value ].
		8 to: 1 by: -1 do: [ :each | 
			value := bits bitAnd: 2r11111.
			buffer at: each put: (alphabet at: value + 1).
			bits := bits >> 5 ].
		actual := (count * 8 / 5) ceiling.
		stringStream next: actual putAll: buffer.
		(8 - actual) timesRepeat: [ 
			stringStream nextPut: self padCharacter ] ]
]

{ #category : #initialization }
Base32Encoder >> initialize [
	super initialize.
	self useStandardAlphabet 
]

{ #category : #accessing }
Base32Encoder >> padCharacter [
	"Return the pad character to use"
	
	^ $=
]

{ #category : #initialization }
Base32Encoder >> useHexAlphabet [
	"Configure me to use the hex32, double hex or triacontakaidecimal alphabet"
	
	self alphabet: ($0 to: $9) , ($A to: $V)
]

{ #category : #initialization }
Base32Encoder >> useStandardAlphabet [
	"Configure me to use the standard Base32 alphabet"
	
	self alphabet: ($A to: $Z) , ($2 to: $7)
]
