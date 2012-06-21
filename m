From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Thu, 21 Jun 2012 16:58:33 +0200
Message-ID: <5100581.utCIcpy8f5@peanut>
References: <10900468.MPSjVn2C3J@peanut> <4FE315CE.9090201@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5219557.7jpx7dvSWE"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE315CE.9090201@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart5219557.7jpx7dvSWE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello John,

On Thursday, June 21, 2012 01:38:38 PM John Robinson wrote:
> On 20/06/2012 18:41, Robert Buchholz wrote:
> [...]
> 
> > When repairing a full raid6 with no missing drives
> > (raid-devices=n+2), a single inconsistent data block could be
> > detected
> 
> Yes, it could. See Neil Brown's blog post as to the many reasons why
> this isn't implemented: http://neil.brown.name/blog/20100211050355

Thank you for the pointer, I did not find the article before.
I agree with Neil's premise, this should not be run on a mounted raid as 
changing data blocks can be a problem, and it should not be the default 
for resync. However, as both Neil and commenters point out, this is a 
valuable (offline) repair option.

Do you know whether the "smart" algorithm or the API necessary to 
construct a user space program are on the agenda?


Cheers

Robert
--nextPart5219557.7jpx7dvSWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJP4zaZAAoJECaaHo/OfoM5R3IP/0w0Rku6agGMsUbmfko71rer
L7cFAWo9Cx1rE2MqN+6967bAKSLqs3MND0Lh9IgdGJVvluH2dmkfsBh2/3YEstwD
gnkHmHRdGIgF9j5XCVVJtyC3W5OyEZaG30R2Axgfawrw64JcA7C/3BLA/+qjLEkJ
oE0VKOaHS504uQBVdCz9BzcPgj/raRGNOlPHKPB0IRMnLyInmahM5IcSUyACwf3/
9ovXB4VedftJgACLOC+p3tZlrL9CptyyQ3VPpRkt/BhUJW2cDb1v9sARoTXaNLKW
NjMjpe4A/YS0sBlyoxluZHNcpb82xGaaSRYblrGjc313xxhHNz/YMZmO9zUeUh2q
4If36whoOuys8fWR+uWrWXceXOgX3i92GSP8sAGnxXGgK4rvAeH9x4ltcqBYOAHE
Id3ctB0ybFYHdSC1+9XFo8mNGAJH6ps5tI6cs6uP8Kk0jNMPJqQUm/2Lm6UdmZui
5cpZUz/CuDYtgOLlXKNzUZazD0JQwqp8sGKcuOPf4utBRxqfGUhXVUza7lI/J4lq
yP6xZMutWUJMzJgFdrNRNrEGkn4mE9qYaoVDtaZLOtegpEk7J8uHwQUjGfYQ39c6
j66T9KGeyDWDTzl/0KTzlL5lvoFazXe7nnxA9mqjPoCT7heNYnULI8NScnxDX59J
+iziZe7LYE6TrXGTnHsx
=C0WL
-----END PGP SIGNATURE-----

--nextPart5219557.7jpx7dvSWE--

