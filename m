From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Tue, 7 Jul 2009 15:44:53 +0200
Message-ID: <20090707134453.GC9869@skl-net.de>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19026.50240.504728.428875@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:42, Neil Brown wrote:

> We need to be consistent.
> Either all devices that are bound to the array - whether active,
> spare, or failed - are considered, or only the active devices are
> considered.

OK, I'll look at this and send a revised version of the patch.

Get well soon.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKU1FVWto1QDEAkw8RAnqOAJ45OcToiXb96qMi/NifotsziXwD2gCgo0TG
V6zZkMPP8/Y19W1ZTZ3weuU=
=pWIN
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
