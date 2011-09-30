From: Andre Noll <maan@systemlinux.org>
Subject: Re: Safely swapping a disk in a RAID456
Date: Fri, 30 Sep 2011 19:07:10 +0200
Message-ID: <20110930170710.GF30935@systemlinux.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
 <4E85E921.1020808@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E85E921.1020808@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 30, 18:06, Rudy Zijlstra wrote:
> Replacing without degrade:
> - stop the raid
> - do a dd from old disk to new disk
> - replace the disk
> - re-start the raid

This works but the array needs to be stopped during the dd, which may take a
long time. Creating a raid1 first allows you to restart the raid456 immedia=
tely
after the raid1 has been started, no need to wait for the initialization to
complete.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6F9z4ACgkQWto1QDEAkw/yMQCgqtlBKjSfm1Y64mD2pvYj4FZO
KbQAnR8lpQvER26H24CDtAEwxN4zdw6c
=bX6K
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
