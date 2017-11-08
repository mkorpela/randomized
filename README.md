# randomized

The pseudorandom number is composed as follows:
1. seed - a common seed value
2. S - a private key (RSA)
3. P - a public key (RSA)

number = keccak256( rsa( keccak256(seed), S ), seed )

keccak256 operations are used to make the number generation one way from the private keys owners point of view.
They are also there to ensure that distribution is even.

This tries to ensure that the only way for a private key owner to precalculate a number is by executing the whole algorithm.

We can experiment with different methods.

First only an rsa:

number = rsa(seed, S)

This can be easily reversed by the private key owner:
seed = rsa(number, P)

We can prevent this by adding keccak256:

number = rsa(keccak256(seed), S)

now what happens is:
keccak256(seed) = rsa(number, P)

And seed is not anymore reversible.

RSA has some weaker keys, that might cause a problem too. Especially distribution of random numbers might be tweeked by cleaverly selecting a private and a public key that are weak. This might give advantage to the private key owner.

Let's prevent that by rehashing the result with rsa result + the original seed:
number = keccak256( rsa( keccak256(seed), S), seed )