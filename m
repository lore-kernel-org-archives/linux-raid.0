From: Andre Noll <maan@systemlinux.org>
Subject: Re: md devices disappearing on system reboot
Date: Wed, 2 Jul 2008 18:21:08 +0200
Message-ID: <20080702162108.GF4981@skl-net.de>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:52, thomas62186218@aol.com wrote:

> I have what I am sure is a simple problem to solve but I cannot figure=20
> it out. I am running 64-bit Linux 2.6.20.11 (custom build) and my md=20
> devices are not appearing after system reboot. Any ideas?

Show us your /etc/mdadm.conf and the output of mdadm -E --scan.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIa6r0Wto1QDEAkw8RAlIrAKCnNWCCVckQ84yvJzu40bTeFZNCpQCfa9EU
YogqPQ4p0Zk14c5NmoRzteQ=
=7O39
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
