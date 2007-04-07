From: Andy Smith <andy@lug.org.uk>
Subject: raid10_make_request bug: can't convert block across chunks or bigger [...]
Date: Sat, 7 Apr 2007 03:10:27 +0000
Message-ID: <20070407031027.GT2737@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C92BGBoQeSqt4vh9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--C92BGBoQeSqt4vh9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm now seeing the exact same problem as Ask did in:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06762.html

again using md raid10 under LVM, trying to export an LV to a xen
domain.

This is on the latest Debian Etch kernel based on 2.6.18.4.

Ask didn't seem to get any on list replies - can anyone shed any light?

Cheers,
Andy

--C92BGBoQeSqt4vh9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGFwujIJm2TL8VSQsRApEyAJ4uyuGvnjPnqlHKkJ6FVlpZjhUNAACbB8DS
k3XvlwCbVGo95La5vLlHLeE=
=GxNG
-----END PGP SIGNATURE-----

--C92BGBoQeSqt4vh9--
