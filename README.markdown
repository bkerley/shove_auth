shove_auth
==========

shove_auth is a centralized authentication repository for webapps, using
the HMAC protocol to verify passwords without any plaintext passwords at
rest or in transit.

SHA1 is the digest used. SHA512 is a more secure choice but not available
everywhere, and in my opinion shove_auth SHA1 is secure enough for our
uses.

Concepts and variables
----------------------
* secret - sha1(username+pass) expressed in base64
* sid - session_id, 768359313 as example, not constrained to integers (use a varchar type)
* 

REST protocol
-------------

* Session management:
  * Create session: `POST /session/new` - returns the nonce and session\_id (example session\_id: 768359313)
  * Update session: `PUT /session/sid` username, hmac(sha1(username+pass), nonce)
    * 303 See Other & redirect to show session - successful authentication
    * 400 Bad Request - malformed request
    * 403 Forbidden - failed authentication
  * Show session: `GET /session/sid` hmac(secret, 'GET /session/sid') - show if session is invalid, waiting, or authenticated
* User management, returns 403 when provided session doesn't have permissions
  * Show user: `GET /user/username` sid, hmac(secret, 'GET /user/username 768359313') - show username, time and client of last login(s)
  * Update user: `PUT /user/username` sid, password, hmac(secret, 'PUT /user/username 768359313') - set password
  * Destroy user: `DELETE /user/username` sid, hmac(secret, 'DELETE /user/username 768359313') - delete said user
  * Create user: `POST /user/username` sid, hmac(secret, 'POST /user/username 768359313') - create user with specified name

Logging in
----------

* Create a new session
* Obtain username and password from user
* Update the session with username and hmac from hashed password and nonce
  * On a 400 or 403, discard the session and nonce, and let the user know they suck
* Allow the user to perform their normal tasks