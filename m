From: NeilBrown <neilb@suse.de>
Subject: Re: Accesses to not yet running array
Date: Wed, 21 Aug 2013 09:06:34 +1000
Message-ID: <20130821090634.413491d8@notabene.brown>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hDab+UD6H8XZqvd4r8Q6eNj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hDab+UD6H8XZqvd4r8Q6eNj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Aug 2013 16:08:47 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> hi,
>=20
> It looks like a process wait uninterruptibly when it tries to access
> an array which is not running yet.
>=20
> Furthermore once the process is waiting, I can't start/stop the array any=
more.
>=20
> So I need to reboot my system and be sure next time that any processes
> don't try to access a not yet running array.
>=20
> Is that expected ?
>

No.

To be able to say more I would need lots more details.
What is the exact state of the array (cat /proc/mdstat ;mdadm -D ...)
Where is the process waiting (cat /proc/PID/stack)
What sort of "access"
How did the array get to the "not running yet" state?
Any kernel messages?
Anything else that might be relevant.

NeilBrown

--Sig_/hDab+UD6H8XZqvd4r8Q6eNj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhP2ejnsnt1WYoG5AQIfKBAAkFBb+f7g9aXjdOLmq1gHd6mbUPTl1U51
1+CppFeWr1+yPewGWtAzkyhu26aYiGlYALPceSd3zVuQBSikXqwVaDwFM89l7lNI
w2hPRsKFxNhw/6pNTk96o4ugtOUOaaL77h/gjICoRd3gNLtrTSjPP8cyJakHC/k4
q9jGAolLPoakuMcHN6XdOYsoVoDLNyPKTsoBKBg927vfFHxpYmmhZy+4WV667d3P
3j2PPYhUNxF/B7C+juM9PvxelnUNxZ+mSGfbNc6rBfILK6IE6WlDodT6Ttnp0e+l
h8w6B8ECpPCkNeMYxBVmnh8aSbTeymOSRZYW4AhX/n5ol1ANPf15dVRmxmz8BDtO
YUhuzTS8x9gDrCnQfwDtqG26cDfDdclVL1+EHJWYdn2hQtpXFAf8TfaqnWEO6eV1
0rIdesORsxoUPWbMfNLNsIn2MGex/ictKh6Zp9ZpuaoHq3pxW1KQzxFv9o6Cqpws
YLb8H+meTrNXMbAkEjoY6OANwy9F5SRtvk65zCBhkYJJOhJgiJTf/U7h/hsido7O
zR33L32JGJDVYS61TvRRF2KsQT5yfzkXyIiesxJc9uFGvHURJkmlj9KRtPkFyr6M
rgB8iY5mKhTKxsZp3lFb1bnGMYQ9Dw4CJ5GrXq9NLjIDZPXmnzyaPNrClpDSvbRx
2K4FL36eT1Y=
=6Ccx
-----END PGP SIGNATURE-----

--Sig_/hDab+UD6H8XZqvd4r8Q6eNj--
