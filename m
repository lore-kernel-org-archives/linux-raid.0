From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm-3.2.5: segfault in "--grow --continue"
Date: Mon, 16 Jul 2012 16:26:38 +1000
Message-ID: <20120716162638.31b66823@notabene.brown>
References: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de>
	<20120710230205.171ee562@notabene.brown>
	<BC57DF1E-7CA3-429E-8935-44A94003B5E5@tu-dresden.de>
	<20120711122626.51cf7070@notabene.brown>
	<0A5D7060-7727-4CBD-A1D7-34ED7D9747BC@tu-dresden.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BgHiJlTn3xZZbVQ2V+p_X9B"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0A5D7060-7727-4CBD-A1D7-34ED7D9747BC@tu-dresden.de>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Cc: linux-raid@vger.kernel.org, 681056@bugs.debian.org
List-Id: linux-raid.ids

--Sig_/BgHiJlTn3xZZbVQ2V+p_X9B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 13:15:38 +0200 Sebastian Hegler
<sebastian.hegler@tu-dresden.de> wrote:

> Hi!
>=20
> Am 11.07.2012 um 04:26 schrieb NeilBrown:
> > I should have asked which kernel you were running. =20
> > I'm guessing that it is earlier than 2.6.25, and so is missing upstream=
 commit
> >   25156198235325805cd7295ed694509fd6e3a29e
> >=20
> > that fixes a bug which causes reshape not to restart if array was assem=
bled auto-read-only.
> The system is running vanilla 3.4.4, actually. So maybe there's another c=
ode path where this is missing...

Odd..  I cannot reproduce this (as RAID5 reshaping to more devices always
starts reshaping once it becomes writable).

>=20
> Thank you four your help. My RAID6 arrays are up again, and all data is s=
till there.
>
Thanks this important thing!

Thanks,
NeilBrown

--Sig_/BgHiJlTn3xZZbVQ2V+p_X9B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAO0Hjnsnt1WYoG5AQL1pxAAoFL2d4k1U15IJ4itSPsupYM3+sC3j2Hl
tvLLzDfnOhg4EJkwHtQPPLslQ6LPtBfH/bbIs45SflwSWkB6sZjLZ2J8gp6HjMZW
0qyqKHjqTj4rfshIPzT2JG4ImtCbqr6j1YtGuRQclcaeJCL6nm6MG1eO9mMaEgyb
ZetdU3WHUOgmQDXXKROaLDqzHDuRnGXD5vRR9AlmVxEpogalsP6TckFUfI1xRuHF
fumK7UtV3YOeJw4cgGWwD0l33EZ5smnDHqyHRTRXcOdFF0u1mdk8JJh54UOw/XXk
I3Ry482BJgqBEe4MFCaj+Fhkoa7BTy9Vr+kG7R6bpmc6qBKrbenQ/NQmk9HEJ0KQ
C4PF0Vrf7W3pg3fUyhv5XvG0xOVBsSzKzz0WGXsKyV4pzXm4aeuaSCQPMqCBLlZ1
ixz5oQMSLgHT3F8+7OouIP57MAGORPajwZJNAoBYtoHwqHc7O1TpbtUekkqsFoSY
a2PIRk/k7x4PcUuCWUQK/0XmntLVf0GaO6B2lW90IrDu8LDB+4nT2LIylPpUewG6
zVnYVSt7vaiLrH6AUVycPrtxQjjjMOQrjNGcKFGQBprFOkpi9VTuy+YQZRFBp4Lm
HPCDfLcre2qux+GtVD2u9y28pA1o8TVGIL/S9KA5Mf95bLodjd3GLSG0kaEEsHZd
Sn65Ay13g5Y=
=O5eX
-----END PGP SIGNATURE-----

--Sig_/BgHiJlTn3xZZbVQ2V+p_X9B--
