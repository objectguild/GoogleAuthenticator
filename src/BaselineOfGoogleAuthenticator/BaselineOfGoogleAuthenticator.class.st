Class {
	#name : #BaselineOfGoogleAuthenticator,
	#superclass : #BaselineOf,
	#category : #BaselineOfGoogleAuthenticator
}

{ #category : #baselines }
BaselineOfGoogleAuthenticator >> baseline: spec [

	<baseline>

	spec for: #common do: [ 

		"Dependencies"
		spec baseline: 'CryptoNacl' with: [ spec loads: #( 'core' ); repository: 'github://objectguild/Crypto-Nacl:master' ].

		"Packages"
		spec 
			package: 'GoogleAuthenticator-Core' ;

			package: 'GoogleAuthenticator-Sodium' with: [ spec requires: #( 'GoogleAuthenticator-Core' 'CryptoNacl' ) ] ;
			package: 'GoogleAuthenticator-Random' with: [ spec requires: #( 'GoogleAuthenticator-Core' ) ] ;

			package: 'GoogleAuthenticator-Tests' with: [ spec requires: #( 'GoogleAuthenticator-Random' ) ] .

		"Groups"
		spec 
			group: 'default' with: #( 'Core' ) ;

			"Using Sodium by default, which is more secure. 
			If you want default (shared) random, you must explicitly load it."
			group: 'Core' with: #( 'GoogleAuthenticator-Sodium' ) ;
			group: 'Random' with: #( 'GoogleAuthenticator-Random' ) ;

			group: 'Tests' with: #( 'GoogleAuthenticator-Tests' ).
		
	 ]
]
