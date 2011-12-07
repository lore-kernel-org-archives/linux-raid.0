From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 and page cache
Date: Wed, 7 Dec 2011 15:28:53 +1100
Message-ID: <20111207152853.42594fc9@notabene.brown>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
	<20111207092625.7140c5dc@notabene.brown>
	<CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
	<20111207120133.70ca294c@notabene.brown>
	<CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EkQMCsEdI=rSEhMrODNgYbZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Yucong Sun (=?GB2312?B?0rbT6rfJ?=)" <sunyucong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EkQMCsEdI=rSEhMrODNgYbZ
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 20:04:33 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9) <sunyucon=
g@gmail.com>
wrote:

> The problem with using page-flush as a write cache here is that write
> to MD don't go through IO scheduler, which is a very big problem,
> because when flush thread decide to write to MD,  it's impossible to
> control the write speed, or prioritize them with read, every requests
> basically is a fifo,  and when flush size is big, no read can be
> served.
>=20

I'm not sure I understand....

Requests don't go through an IO scheduler before they hit md, but they do
after md sends them on down, so they can be re-ordered there.

There was a bug where raid10 would allow an arbitrary number of writes to
queue up so that flushing code didn't know when to stop.

This was fixed by=20
   commit 34db0cd60f8a1f4ab73d118a8be3797c20388223

nearly 2 months ago :-)

NeilBrown


--Sig_/EkQMCsEdI=rSEhMrODNgYbZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt7rhTnsnt1WYoG5AQKElRAAmeYvD7VJp+jiB6Qcsuri4qmGRAkOEZbR
ubDMilaK0bNO7D0vwgVgz0Sr8hyn3GQphLUlUxekRuS+H36/pC1M+BhSi8TaQXsH
XjLRO9KPmKgFi7iShBwK9ZzUNtahFj7v8VfaYp9W0IoDrm87WGE39LHlcoFI5l0u
NWbuzbHdBnf5yiye+zBZTqDh7Mr3vW/V98EUBqzozYINomPRiP5m+3fGZgp8uCGd
/8mXoeIPp0D4+VyRsU1cxLGcsRr7so3C+T4IrV0NSDb72Td6RwZqFWV1/s4bK4tK
oWspjebCi7hbPxICcAWITnotAL5ZQ92G9n4vb/6R0fRXVzZT6vVtYRiIu/OQ5FeV
z5f99KmnRDIWR3ixQA95WMWiTeDTnJXWG93yl2aV1NJ6sPP3nHw/qSoaS0lPAiQb
bDMjl8fIb37qnkBFawVjrm8W2H76Sw9pvrhsAQh8VJs4gHm5XsRK0YEEg+JuIOs0
k+D6M//8yOoT8S8r7NYTy3aAmvnzah94RKd8VIxIbx53Mf+VPKqqN4I5/4LzRZPJ
ely8divAvUgKtx9swdelBpTUyJkW3JzcSxeJQLUqKWn1daRkAUgeYdwHIOk9v+au
xviEw7AuAX0T0C1dxfw1+f71Gf0NFLCPdKIgKsOx8YyMEcZtydfjuGfa7vPz3qQp
N1GUq5ilwe0=
=C0HJ
-----END PGP SIGNATURE-----

--Sig_/EkQMCsEdI=rSEhMrODNgYbZ--
