From: Sebastian Henschel <shensche@xtops.de>
Subject: compile errors in 2.6.8.1 in drivers/md/*
Date: Fri, 27 Aug 2004 11:36:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040827093634.GA4853@fuchi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello folks...

hopefully i am right here... i just compiled a kernel 2.6.8.1 and two
similar errors occurred:

drivers/md/dm-raid.c:1241 - the workqueue creation misses an argument. i
have set the flag to 0.
drivers/md/kcopyd.c:612 - the singlethread workqueue creation misses an
argument. i have set the flag to 0.

the kernel compiles now, but i do not if it really is a fix. since the
machine this kernel was compiled on, does not make use of a software
raid, i cannot test it.

cheers,
 sebastian

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBLwCireHfL3pi+bQRAlYtAKCBNydavUdrHG8K02wiF6GInz0jmwCgj+Fx
3iiOQULb3/mAXlvytuni67E=
=uSkc
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
