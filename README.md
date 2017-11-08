# randomized

The pseudorandom number is composed as follows:
1. seed - a common seed value
2. S - a private key (RSA)
3. P - a public key (RSA)

number = keccak256( rsa( keccak256(seed), S ), seed )

keccak256 operations are used to make the number generation one way from the private keys owners point of view.


