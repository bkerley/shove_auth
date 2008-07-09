shove_auth
==========

shove_auth is a centralized authentication repository for webapps,
using the HMAC protocol to verify passwords without any plaintext
passwords at rest or in motion.

protocol
--------

POST /verification/new - return a new nonce and verification_id (i.e. 4f4ca3d5d68ba7cc0a1208c9c61e9c5da0403c0a / 768359313)
PUT username, hmac(pass. nonce) /verification/768359313 - 200 = accepted, 403 = not accepted


