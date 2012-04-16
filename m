From: NeilBrown <neilb@suse.de>
Subject: Re: question about raid10 near copy info in man mdadm.
Date: Mon, 16 Apr 2012 15:41:26 +1000
Message-ID: <20120416154126.2fb059da@notabene.brown>
References: <201204161328097657740@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JgK2agu8WSB4c3jw2RY+rd4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204161328097657740@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/JgK2agu8WSB4c3jw2RY+rd4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 13:28:14 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> Hi:
> 	I readed the information about raid10 near copy in man mdadm.
> 	It is:
> 	'n' signals 'near' copies.  Multiple copies of one data block are at sim=
ilar offsets in different
>               devices.
> 	But I think this wrong.
> 	If raid10 had five disks and near copy is equal three.
> 	The layout like:
> 			5 disks
> --------------------
> A1 A1 A1 A2 A2
> A2 A3 A3 A3 A4
>=20
> But the copies of datablock A2 are not at similar offset in different dev=
ice.
>=20

They are certainly on different devices so I guess you are questioning the
use of the word "similar".

What do you understand "similar" to mean?

How would you describe offsets which might be the same, or might differ by
one chunk-size?

I'm happy to change the text if it is confusing, but only if the result is
undoubtedly less confusing.

NeilBrown

--Sig_/JgK2agu8WSB4c3jw2RY+rd4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4uxBjnsnt1WYoG5AQKgkxAAom5KBYbZQc4Uv6ikjZb0DZPNH+BIAv0N
pgkzJyCwpLlGSByALi4HuHWXlkV9QIwM3fyLSDK7uTdpH20uz/IR5iGBdXn3Ite1
sAt8e2l2E2ScyhXpdI+3WwpKWcmEg7CRn9FSJvIYnlyvGNmlvRJyZ/1J2p1NcHK5
MYUKcAaW07OQguoDuPsxHIHQXcbR201lHRQ6iYO2dyC2ngaVW1RsTEzvEiYLRUxr
ei9Gwd4zN5PnaqUN+qjZ9sKl/lMsfQwrTMGYHonNaM+lMGyi70BXtf9bQ7e95Ea1
6t7YUXK2yOCQutOjPP6ZnhTa5jb7TkYwhgNl27JCtS4CO4h6HNzhVXDu1A5BJe8u
5qPwiAlHg0NtudLgn0eaLO8rWDEJm9YY2+WCYcUz1KpZuMalAyaFNY2D0GmVHt5i
a/6zwRKEJWTFh+ONugTuj9piOR/pVHbTT0P8vLUaLtJre5i2vNDMGTdkB9ysJXcJ
GCi+EbbOE5/9AO78j5nJxOxnMEE3tzusUwckxKzOGgG+USm1RQY6yp7s/qb5sQqA
k5VqodtjPTcXVRlBU4SfQn3XrgWCzdrYvjtuxOthQIoY2ziv59/+HaCxX+nryQ20
sHEwe/YUh8WTOyKITPs19QXHHuc6z9rYRiwdNmc38PFaccwtKOV1MAtx1TdooW4c
71uyvrLSOsM=
=UYfJ
-----END PGP SIGNATURE-----

--Sig_/JgK2agu8WSB4c3jw2RY+rd4--
