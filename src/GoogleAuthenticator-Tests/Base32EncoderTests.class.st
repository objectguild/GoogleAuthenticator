"
Test vectors partially based on https://tools.ietf.org/html/rfc4648#section-10
"
Class {
	#name : #Base32EncoderTests,
	#superclass : #TestCase,
	#category : #'GoogleAuthenticator-Tests'
}

{ #category : #accessing }
Base32EncoderTests >> hexTestVectors [
	^ #(
		'' ''
		'f' 'CO======'
		'fo' 'CPNG===='
		'foo' 'CPNMU==='
		'foob' 'CPNMUOG='
		'fooba' 'CPNMUOJ1'
		'foobar' 'CPNMUOJ1E8======'
		)
]

{ #category : #accessing }
Base32EncoderTests >> standardTestVectors [
	^ #(
		'' ''
		'f' 'MY======'
		'fo' 'MZXQ===='
		'foo' 'MZXW6==='
		'foob' 'MZXW6YQ='
		'fooba' 'MZXW6YTB'
		'foobar' 'MZXW6YTBOI======'
		)
]

{ #category : #accessing }
Base32EncoderTests >> standardTestVectorsFull [
	^ #(
		''	''
		'fooba' 'MZXW6YTB'
		'FOOBA' 'IZHU6QSB'
		'12345'	'GEZDGNBV'
		'ABCDE' 'IFBEGRCF'
		'*****'	'FIVCUKRK'
		'**********'	'FIVCUKRKFIVCUKRK'
		'abcdefghij' 'MFRGGZDFMZTWQ2LK'
		'1234567890' 'GEZDGNBVGY3TQOJQ'
		)
]

{ #category : #testing }
Base32EncoderTests >> testDecodeHex [
	| encoder |
	encoder := Base32Encoder new useHexAlphabet.
	self hexTestVectors pairsDo: [ :in :out |
		| result |
		result := encoder decode: out.
		self assert: result asString equals: in ]
]

{ #category : #testing }
Base32EncoderTests >> testDecodeStandard [
	| encoder |
	encoder := Base32Encoder new.
	self standardTestVectors pairsDo: [ :in :out |
		| result |
		result := encoder decode: out.
		self assert: result asString equals: in ]
]

{ #category : #testing }
Base32EncoderTests >> testDecodeStandardFull [
	| encoder |
	encoder := Base32Encoder new.
	self standardTestVectorsFull pairsDo: [ :in :out |
		| result |
		result := encoder decode: out.
		self assert: result asString equals: in ]
]

{ #category : #testing }
Base32EncoderTests >> testEncodeHex [
	| encoder |
	encoder := Base32Encoder new useHexAlphabet.
	self hexTestVectors pairsDo: [ :in :out |
		| result |
		result := encoder encode: in asByteArray.
		self assert: result equals: out ]
]

{ #category : #testing }
Base32EncoderTests >> testEncodeStandard [
	| encoder |
	encoder := Base32Encoder new.
	self standardTestVectors pairsDo: [ :in :out |
		| result |
		result := encoder encode: in asByteArray.
		self assert: result equals: out ]
]

{ #category : #testing }
Base32EncoderTests >> testEncodeStandardFull [
	| encoder |
	encoder := Base32Encoder new.
	self standardTestVectorsFull pairsDo: [ :in :out |
		| result |
		result := encoder encode: in asByteArray.
		self assert: result equals: out ]
]
