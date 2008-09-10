shove_auth
==========

shove\_auth is a centralized authentication repository for webapps, using
the HMAC protocol to verify passwords without any plaintext passwords at
rest or in transit.

Concepts and variables
----------------------
* server - the system running shove_auth
* client - an application acting on behalf of a user; in our case, the push2 webapp
* auth_secret - sha1(username+pass) expressed in base64
* session_secret - unique per session, keyed to particular client
* sid - session_id, probably a big base64-encoded string (base64 looks cool)
* signed request - requests relying on authentication should include a signature consisting of:
	* the action (for example, `GET /user/username`)
	* the current sid (even if this is already included in the action URL)
	* any arguments (such as the password for update user)
	* the output of the hmac function is passed as the hmac request parameter
* legacy object - client-side object for the benefit of push2.  If you don't
    know what that is, ignore it.  Legacy features will be removed in the
    future.

REST protocol
-------------

* Session management:
  * Create session: `POST /session/create` - returns the nonce and sid
  * Update session: `PUT /session/sid` username, hmac(auth\_secret, `PUT /session/sid nonce`)
		* 200 OK - successful authentication, includes session\_secret
		* 400 Bad Request - failed authentication or malformed request
  * Show session: `GET /session/sid` hmac(session\_secret, `GET /session/sid sid`)
		* 404 Not Found - no session with this sid
		* 403 Forbidden - session not authenticated
		* 200 OK - return session secret 
	* Destroy session: `DELETE /session/sid` hmac(session\_secret, `DELETE /session/sid`)
		* 403 Forbidden - delete failed for permissions or something
		* 204 No Content - deletion happened
* User management, returns 403 when provided session doesn't have permissions
  * Show user: `GET /user/username` sid, hmac(session\_secret, `GET /user/username sid`) - show username, time and client of last login(s)
  * Update user: `PUT /user/username` sid, password, hmac(session\_secret, `PUT /user/username sid password`) - set password
  * Destroy user: `DELETE /user/username` sid, hmac(session\_secret, `DELETE /user/username sid`) - delete said user
  * Create user: `POST /user/username` sid, hmac(session\_secret, `POST /user/username sid`) - create user with specified name
* ACL checking, no hmac needed
  * Check access: `GET /access/` sid, resource\_selector - 200 when allowed, 403 when not

Protocol security
-----------------

The session\_secret is used instead of the auth\_secret for maintenance of the session, since it must have a short lifetime,
preferably 24 idle hours or less.  If the client stores the session\_secret in a cookie store over plaintext HTTP (i.e. Rails
cookie sessions), the server **must** validate that data is coming from a valid client, either by whitelisting IP addresses
or use of client SSL certs.

SSL/TLS should be used to protect the client-shove\_auth session from replay attacks, allow secure transfer of the session\_secret, password changes, and SSL certificate authentication of clients.

Logging in
----------

* Create a new session
* Obtain username and password from user
* Update the session with username and hmac from hashed password and nonce
  * On a 400 or 403, discard the session and nonce, and let the user know they suck
* Allow the user to perform their normal tasks

