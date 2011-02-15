From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 00:45:24 +0500
Message-ID: <20110216004524.67abe977@natsu>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5ACE4B.9040309@gmail.com>
	<4D5AD613.3040402@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fUQ2CcW+MQ_xtLnDIIS+KHg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5AD613.3040402@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: simonmcnair@gmail.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fUQ2CcW+MQ_xtLnDIIS+KHg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Feb 2011 14:37:55 -0500
Phil Turmel <philip@turmel.org> wrote:

> > For some reason blkid doesn't exist on my machine even though I have
> > e2fs-utils installed.  V weird.

Weird is that you think it is somehow a "e2fs-utils" program.

dpkg -S blkid
...
util-linux: /sbin/blkid
...

>=20
> FWIW, on my VPS running Ubuntu Server 10.10, the blkid executable is part=
 of
> util-linux, and installed in /sbin.  You might need to re-install it.

--=20
With respect,
Roman

--Sig_/fUQ2CcW+MQ_xtLnDIIS+KHg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1a19QACgkQTLKSvz+PZwgzRgCggc5PkkLeGXlGvKlLiAL/iXvc
JRYAnjvEhUbHENECZNV0QHpsZV+MOR+o
=WXj6
-----END PGP SIGNATURE-----

--Sig_/fUQ2CcW+MQ_xtLnDIIS+KHg--
