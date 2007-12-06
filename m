From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid6 check/repair
Date: Thu, 6 Dec 2007 19:27:11 +0100
Message-ID: <20071206182711.GN32704@skl-net.de>
References: <474431BF.30103@ph.tum.de> <18244.64972.172685.796502@notabene.brown> <4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown> <474F4880.8080300@eyal.emu.id.au> <47502140.1080601@ph.tum.de> <1196650421.14411.10.camel@elara.tcw.local> <47546019.5030300@ph.tum.de> <18261.49547.588360.436369@base.ty.sabi.co.UK> <47570A92.1090307@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t5C3/nrmPumNj5sH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47570A92.1090307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--t5C3/nrmPumNj5sH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:31, Bill Davidsen wrote:

> Thiemo posted metacode which I find appears correct,

It assumes that _exactly_ one disk has bad data which is hard to verify
in practice. But yes, it's probably the best one can do if both P and
Q happen to be incorrect. IMHO mdadm shouldn't do this automatically
though and should always keep backup copies of the data it overwrites
with "good" data.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--t5C3/nrmPumNj5sH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHWD7/Wto1QDEAkw8RAv37AJ0S7l1g2BnfaIwSHkbHeWPCvM6SiACgi4Pb
FUgGcO09icQLxwZcW7ZXPDc=
=dIEP
-----END PGP SIGNATURE-----

--t5C3/nrmPumNj5sH--
