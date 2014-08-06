From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Full stripe write in RAID6
Date: Wed, 6 Aug 2014 13:03:54 +0600
Message-ID: <20140806130354.43b0ba6a@natsu>
References: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dzi1X97_HKn9F0fh=dv6Ny/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mandar Joshi <mandar.joshi@calsoftinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dzi1X97_HKn9F0fh=dv6Ny/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 5 Aug 2014 21:55:46 +0530
"Mandar Joshi" <mandar.joshi@calsoftinc.com> wrote:

> # time (dd if=3D/dev/zero of=3D/dev/md127 bs=3D2M count=3D1 && sync)

You could re-check adding the "oflag=3Ddirect" to the dd command and see if=
 this
makes it behave as you expect.

--=20
With respect,
Roman

--Sig_/dzi1X97_HKn9F0fh=dv6Ny/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPh01oACgkQTLKSvz+PZwj1vwCfXBkwPEkWSqjr5+OIIG3uvvmM
zvwAn3Dqqwxl5QQssNER8YvdvzJQ/VFg
=zP6u
-----END PGP SIGNATURE-----

--Sig_/dzi1X97_HKn9F0fh=dv6Ny/--
