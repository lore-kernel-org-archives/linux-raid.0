From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Fri, 7 Jan 2011 06:17:46 +0500
Message-ID: <20110107061746.0395196b@natsu>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
	<20110107003827.GD21627@tango.0pointer.de>
	<AANLkTi=4U9E4GtYkmj+XvXLDHKTbP9AHkZ_=DhC7xNBd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t8FbUxgLd9Qv0j7Eyn+0Vai"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=4U9E4GtYkmj+XvXLDHKTbP9AHkZ_=DhC7xNBd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Biebl <mbiebl@gmail.com>
Cc: Lennart Poettering <lennart@poettering.net>, Andrey Borzenkov <arvidjaar@gmail.com>, linux-raid@vger.kernel.org, SystemD Devel <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

--Sig_/t8FbUxgLd9Qv0j7Eyn+0Vai
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Jan 2011 02:09:32 +0100
Michael Biebl <mbiebl@gmail.com> wrote:

> 2011/1/7 Lennart Poettering <lennart@poettering.net>:
> >
> > Well, I have been discussing this with Kay and we'll most likely add
> > something like DontKillOnShutdown=3Dyes or so, which if added to a unit
>=20
> Make that KillOnShutdown=3Dno, please.

Agreed :) That reminds me of "hal-disable-polling --enable-polling"
( http://ur1.ca/2rmis )

--=20
With respect,
Roman

--Sig_/t8FbUxgLd9Qv0j7Eyn+0Vai
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0maboACgkQTLKSvz+PZwgp2wCdHHPVlgR6mLC5tPQUJ5qOGWbO
PbQAoIDHpklXCauKRSArPrw3av/PV2sV
=BVBc
-----END PGP SIGNATURE-----

--Sig_/t8FbUxgLd9Qv0j7Eyn+0Vai--
