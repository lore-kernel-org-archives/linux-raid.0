From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm does not create partition devices whatsoever,
 "partitionable" functionality broken
Date: Fri, 13 May 2011 23:40:55 +0600
Message-ID: <20110513234055.4307c536@natsu>
References: <4DCD4A83.8060202@pulseforce.com>
	<4DCD6119.3080705@turmel.org>
	<4DCD67EF.1070602@pulseforce.com>
	<4DCD6B27.70402@pulseforce.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s9pE_stIpQp39OPD/tjml_A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD6B27.70402@pulseforce.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher White <linux@pulseforce.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s9pE_stIpQp39OPD/tjml_A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 May 2011 19:32:23 +0200
Christopher White <linux@pulseforce.com> wrote:

> I forgot to mention that I've also tried "sudo fdisk /dev/md1" and=20
> creating two partitions that way. It fails too.
>=20
> This leads me to conclude that /dev/md1 was never created in=20
> partitionable mode and that the kernel refuses to create anything beyond=
=20
> a single partition on it.

Did you try running "blockdev --rereadpt /dev/md1"?

--=20
With respect,
Roman

--Sig_/s9pE_stIpQp39OPD/tjml_A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3NbScACgkQTLKSvz+PZwgRPQCgkLBQN80LW8e6q+W5jWBRda6Z
RygAnjC/a+ynLQSnylCjvyWQ08h9uqBl
=H5Fp
-----END PGP SIGNATURE-----

--Sig_/s9pE_stIpQp39OPD/tjml_A--
