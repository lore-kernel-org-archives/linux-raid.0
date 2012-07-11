From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm-3.2.5: segfault in "--grow --continue"
Date: Wed, 11 Jul 2012 12:26:26 +1000
Message-ID: <20120711122626.51cf7070@notabene.brown>
References: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de>
	<20120710230205.171ee562@notabene.brown>
	<BC57DF1E-7CA3-429E-8935-44A94003B5E5@tu-dresden.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/080n8m8Qadw/8Saf8T/daBk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC57DF1E-7CA3-429E-8935-44A94003B5E5@tu-dresden.de>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Cc: linux-raid@vger.kernel.org, 681056@bugs.debian.org
List-Id: linux-raid.ids

--Sig_/080n8m8Qadw/8Saf8T/daBk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2012 18:51:22 +0200 Sebastian Hegler
<sebastian.hegler@tu-dresden.de> wrote:

> Hi!
>=20

Hi,
 thanks for all the extra details.

I should have asked which kernel you were running.  I'm guessing that it is
earlier than 2.6.25, and so is missing upstream commit
   25156198235325805cd7295ed694509fd6e3a29e

that fixes a bug which causes reshape not to restart if array was assembled
auto-read-only.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitdi=
ff;h=3D25156198235325805cd7295ed694509fd6e3a29e

The mdadm bug is because we never tested the code with anything but IMSM
arrays because those are the only ones that need to use it.
Adding a test for 'mdstat' being NULL and not trying to call
verify_reshape_position in that case is the simplest fixed I expect, though=
 I
haven't tested yet. Possibly something more thorough is needed.


NeilBrown

--Sig_/080n8m8Qadw/8Saf8T/daBk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/zkUznsnt1WYoG5AQJ8EA//QT06dg5wMwxvpwzRZVut8AChRHsULln0
qrBqnEcoTnLp9+DW8NaGm0kzX4jL2M61yoX3ItXR0739LwE444XwGqxIzHIqIOaR
VZ3tqFXyIu+0MGY825IRONkqwSTlKlQ0JKyN88MsCA3V8X53aeYlDUoYLgxuRnwx
p01GqTD6HqtRmqTAwyc6VB2L8WmrKsB8dl7AUASVfvmkTSic+K7zMjKSC9imxSvx
0SMtm3v2YdB1Q8883Pk3EOaxA3po8GlHjKjYLAdreXbsYY2Yd49wUzj9AmHPoIps
wUo7RC68rvnsI1rXWtm0DDKRRneXnPgkTyUu8Ca3i/kRW6fC8RlMaGkT7M2C0gXr
iT9gGHlGgBwnVNszyEfHBmFUtKk5DfL/g4N2pWNgiHS41/paxyyh7uxxGSA3Hj6x
x0NYAVclbaW+rVcbI0UkpEQ//Sjcub7J0dNLjt9avcOYf546sgwsqsAHb1WYYxqU
QJLJk89dm7CsQq4i/3B3YajkQHFoPnOtBYgEMIloeOqdThMKkCJmc7mkq4e7xXIN
UCiBi7zXUDgbsKg5YVdunDu350aEWjP7Wu+lGe8IogW08hBSvtihfe90eFwsyJmh
7D0Nc3T82/sObB/Ao9orfY+mJgi7LrG7P8GMi99HLhWIC3DI6/8yc96CJ8lylyYE
SM1Xp4EGOfs=
=Dgqd
-----END PGP SIGNATURE-----

--Sig_/080n8m8Qadw/8Saf8T/daBk--
