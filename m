From: Andy Smith <andy@lug.org.uk>
Subject: lvm extent sizes, and mke2fs stride values
Date: Fri, 10 Feb 2006 11:16:08 +0000
Message-ID: <20060210111608.GY32687@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y8PUpsPJkqCiojFW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Y8PUpsPJkqCiojFW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Given (what I imagine to be) the fairly common scenario of using an
md device as a PV for LVM and then using multiple LVs from that:

a) is there any benefit to altering the LV's extent size to match
   the RAID stripe size?

b) is there any point in using the -E stride= option of mke2fs to
   match up with the RAID stripe size?

Thanks,
Andy

--Y8PUpsPJkqCiojFW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD7HX4IJm2TL8VSQsRArIjAKDHp4U/YnJU7eihzR+Q9ccYkX6V8gCg1Fog
SLwzuOT8sQ5JERWa4De3aB0=
=57QH
-----END PGP SIGNATURE-----

--Y8PUpsPJkqCiojFW--
