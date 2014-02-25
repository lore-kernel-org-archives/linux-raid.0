From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 hard freeze
Date: Tue, 25 Feb 2014 13:58:09 +1100
Message-ID: <20140225135809.0b1afc69@notabene.brown>
References: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TUlIm/lyYUn_fHUN=+ndGB/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis Golovan <denis.golovan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TUlIm/lyYUn_fHUN=+ndGB/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 00:01:42 +0200 Denis Golovan <denis.golovan@gmail.com>
wrote:

> Hi all
>=20
> I am struggling to diagnose a strange freeze of software RAID5 array.
> My RAID5 consists of 4 Toshiba SATA drives and has ext4 filesystem on top=
 of it.
>=20
> It works fine unless I start several process writing intensively to it.
> At first, it looks like the system is under high pressure, then the
> system starts lagging a lot and a hard freeze always follows after
> several minutes.
>=20
> No errors in system log, nothing is emitted to console. Just hard
> freeze with HDD light always on. I tried enabling kernel network
> logging to another machine and again no information when hanging.
> After reboot, my array starts reconstruction and finishes without
> errors.
>=20
> I tried disabling quotas and barriers for ext4.
> After disabling barriers, it almost seemed to work, but after some
> time the same hard freeze happens.
>=20
> I tested the same hardware configuration under Linux v3.10, 3.11, 3.12
> and now 3.13.5 (all x86 arch) behaves the same way. The same issue can
> be reproduced easily.
>=20
> So now I tested everything Google suggests on the matter.
> Could you give a hint on how to debug this issue?
>=20

The most useful thing for debugging a hard freeze is the alt-sysrq-T output
when it is frozen.  typing that magic sequence should always produce some
output unless it is hard-frozen with interrupts disabled.

So make sure you can produce the output when the system is working properly
(to a log file file the network console would be ideal), then when it hangs,
produce the output again.
To probably need to have a text console rather than a graphic console for it
to work.


If it is hard-hanging with interrupts disabled, then it gets tricky.  I
thought there was some NMI-based lockup detector which would warn if that
happened, but I cannot find it just now.

NeilBrown

--Sig_/TUlIm/lyYUn_fHUN=+ndGB/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwwGwjnsnt1WYoG5AQIjkw/9HWcVf2UzcPn0peiNhiI/TknXBq3oXkgc
//UhaoPXEOFNH1c5L/qAIHQHnsjOpPteKtPYzOKkVdTQRhdlF8lHdRyXqTHWfYGU
2pXFUSGfuA2u5okOp1fMaxdoetSt81WXXJvNE3A0HNy/7nZD/siHUI7foptM7BXm
3rAy3ZTZxpmv/nXqU7ssRM8Lv/krONEN0snCYdtqwbp+WqW9sUFlKUiLnl7SsD4s
hzIaZLQCyKaJK1WndKMEYHWoRX/qJCvqIy7C6tAbpU4vEukxNh8NYir67f1S8KCe
V5nAjjDq1kHPgtHWVpadYDu0d4a05doYRGi5c+QSHeVagCK+ARNRf4jl2G4JcSQV
zvKVl6Nn7Uzr8urav0dPknOdIdWH3YoX4V0gRkZdpqZuGrKqXOuhAi9QhnAee8io
wdAr0uKUVLOnrlCmf3mlHlHspBLa0UGH4YUN8+vuqUQidcVUp6y+o+54s8cCqnVt
vD409vbQona1IIFgNbVGfscBnm+PdDIH0pAo6uRPaucNpp3TrDYOkEYlIzn4FmKp
NKBrYGrxqf5a+YRUA2lBUxjEymmkl9EvBkvNmkVrUwkNi25SePaa1eTzj2fotvKY
w+rcmqrSPa78gH7uOwsibo1tZdfOFg0OHVmL0wfx0mWayAv2jR7nYlcu1uewC7El
xioxjKd2Auw=
=O9Dh
-----END PGP SIGNATURE-----

--Sig_/TUlIm/lyYUn_fHUN=+ndGB/--
