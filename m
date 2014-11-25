From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID5 hang on make_request
Date: Tue, 25 Nov 2014 13:39:22 +1100
Message-ID: <20141125133922.7f4a07d0@notabene.brown>
References: <CANH1pmsL4dHvsmkj52=jpWGQmx5B39hY3w480pkJs7ZmKnpptg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rNbH=0jn7iWkl5hqJhA3XO_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANH1pmsL4dHvsmkj52=jpWGQmx5B39hY3w480pkJs7ZmKnpptg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Henry Cai <henryplusplus@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rNbH=0jn7iWkl5hqJhA3XO_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Nov 2014 09:08:55 +0800 Henry Cai <henryplusplus@gmail.com> wrot=
e:

> With kernel-3.10, when raid5 is doing resync, unplug one of the
> raid5's disk, RAID5 will hang on raid5's make_request function, and
> cat /proc/mdstat show the RAID "resync=3DPENDING", mdadm version is
> 3.3.2. The platform is arm.
>=20
> Any similar problems?

Not that I know of...

Can you test a more recent kernel and see if the problem persists?

Can you provide more specifics than "the make_request function".
e.g. a stack trace (from /proc/PID/stack), or similar.

NeilBrown

--Sig_/rNbH=0jn7iWkl5hqJhA3XO_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPr2jnsnt1WYoG5AQJjQA//UZPEAkvP7ySoOR/8E2Q8V7cGZHECAe6Z
+b4x/iTCcuxB/x/7qSn8r19vDSHG4aswjY60i/mU9aMlnxPIU670ZCmU5jsznpKQ
4VIGvJy8j6Fks0eaxQS92q1hJlNScZc0g3wMYHKc+dGyG5CIOsT69c6+3HOSahOI
4QeQWViaopCLzmkOH6k5d64hsj8fVAocMnfLE8br6mwQlaWKLU+SEgzDc75Lvjvf
m3x9QATwLKwxZkfVN1DHQHbGHqM1VXdQuW5DzTSGagypjOA+EgZZ+gebfAZhyxmt
Mu4u7k2Vy1QhVRda60tGtscG0R9ZbmMyTNrhO7fjgmG+X0LELnRbgXbRnCfOtnQ0
82CXmoz88sVIbDr/NmOyZlUOBXt88/qpCtCEdn6gmdrPdedJRhNH6GgaKiSZOR+V
4asVmoqioMVxIvL5y8qtfBkmeo+umxnEz2i9WLXAnzHwv+E9KMPPABUFfZQIj/L1
Ze46kWfEq90aGdAimywdFu1r2TH/mVhu2llbLSn/AegeyLja4LRnFTWk0gLSDJdy
hQHVB+U4bN2Xy9YajocxpO2sRqQBoMndq8P6dOWQeK3u3qv08Wh9bKVlEBDtVTPQ
I54twxzhJknFYMLuXukR4DB6LwlxllK4NrLChpU0/G4ldVSvZxamxb327H8Ly5sN
Jlh8ebzOs/g=
=Q8Dd
-----END PGP SIGNATURE-----

--Sig_/rNbH=0jn7iWkl5hqJhA3XO_--
