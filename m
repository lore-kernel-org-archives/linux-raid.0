From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 0/2] md: More block -> sector conversions.
Date: Mon, 26 Jan 2009 17:08:14 +0100
Message-ID: <20090126160814.GD17185@skl-net.de>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org> <497DD740.8080306@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <497DD740.8080306@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16:31, Peter Rabbitson wrote:

> Is it possible that the following issue is related to your earlier
> patches: http://marc.info/?l=3Dlinux-raid&m=3D123202024116493&w=3D2

I don't think this is possible because you are using Linux 2.6.24.7
which does not contain any of the block -> sector conversion changes.

Moreover, those changes should be invisible to userspace. In
particular, mdadm does not need to know whether the kernel uses blocks
or sectors for its internal representations. In fact, no changes to
mdadm were made wrt. the block -> sector conversions.

Can you reproduce the incorrect output for the used device size
with the recent master branch of the mdadm git tree?

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJfd/uWto1QDEAkw8RAlF8AJ9AiPdwb+2Re1RWTgAQ62TEzF35egCeMvPV
TX3vsm8g31N92KfxDYVKeyg=
=kmDa
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
