# GoogleAuthenticator
An implementation of time based one time passwords (TOTP) in Pharo, adapted to use Sodium for random number generation.

[![Build Status](https://github.com/objectguild/GoogleAuthenticator/workflows/Build/badge.svg)](https://github.com/objectguild/GoogleAuthenticator/actions?query=workflow%3ABuild)
[![Coverage Status](https://coveralls.io/repos/github/objectguild/GoogleAuthenticator/badge.svg?branch=master)](https://coveralls.io/github/objectguild/GoogleAuthenticator?branch=master)
[![Pharo 7.0](https://img.shields.io/badge/Pharo-7.0-informational)](https://pharo.org)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)

The original author is [Sven van Caekenberghe](https://github.com/svenvc). See Sven's article [The code behind Google Authenticator](https://medium.com/concerning-pharo/the-code-behind-google-authenticator-9c59c606a572). There is still a static copy of the original repository of SmalltalkHub [to be found here](http://smalltalkhub.com/SvenVanCaekenberghe/GoogleAuthenticator).

## Collective Code Construction Contract (C4)
It is Object Guild's intention to use the [Collective Code Construction Contract (C4)](https://rfc.zeromq.org/spec/42/) for collaboration on this project. Please familiarize yourself with its contents when you want to collaborate on GoogleAuthenticator.

The C4 states that the project should have clearly documented guidelines for code style. Since these are currently missing (20 October 2021), these will be created as needed and will thus be a work in progress.

We will use incoming issues and pull requests for purposes of learning to apply C4, so please be patient with us :-) 

Comments are welcome. You are kindly requested to use the [project issue tracker](https://github.com/objectguild/GoogleAuthenticator/issues) for this purpose.

## Loading
A new baseline `GoogleAuthenticator` has been created, which defines the groups `Core`, `Random` and `Tests`, with the default only loading the `Core` group. This group includes the `GoogleAuthenticator-Sodium` package, which loads the Sodium implementation of the `#randomByteArrayOfSize: byteCount` method (as extension).

```Smalltalk
Metacello new
  baseline: 'GoogleAuthenticator';
  repository: 'github://objectguild/GoogleAuthenticator:main';
  load.
```

## Additional instructions Sodium
In order to use the secure Sodium random implementation, which is the default, make sure you have the Libsodium native library installed on your system. See details on how to do this in the [README of the `Crypto-Nacl` repository](https://github.com/objectguild/Crypto-Nacl/#installing-libsodium).
