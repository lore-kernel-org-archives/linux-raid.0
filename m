From: NeilBrown <neilb@suse.de>
Subject: Last call for input to mdadm-3.2.4
Date: Thu, 3 May 2012 14:22:01 +1000
Message-ID: <20120503142201.649766de@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9btdBHCeIledLV27zmBwHhj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Dan Williams <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>, Clint Byrum <clint@ubuntu.com>
List-Id: linux-raid.ids

--Sig_/9btdBHCeIledLV27zmBwHhj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,
 I hope to release mdadm-3.2.4 next week.

This is mostly a bugfix release though there are a few small features
like "--prefer=3D" which guides the selection of the device names reported =
by
--detail and --monitor.
It also now defaults /run/mdadm for runtime files rather than /dev/.mdadm or
/var/run/mdadm.

I hope it will be just what I currently have in the 'master' branch of my g=
it
tree, plus changes to the version numbers.  However if anyone has anything
that they really want to go in *now* I'm open to contributions if they are
important.

I'll then try to focus more on preparing for 3.3 which will include:
 - badblock log support
 - hot-replace support
 - raid10 reshape

and maybe other stuff.

NeilBrown

--Sig_/9btdBHCeIledLV27zmBwHhj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6IH6Tnsnt1WYoG5AQIj0Q/+LEALugAqVuelyNBiGceScc3ZHvl3vBmm
9mRsPtJtym+gkXuZTxU8E8QbnmP+BGPQ1AaQAzLLO/qW2TS4Dcb+hpFhzXtYkqbG
Okx1Z50lZfH3bd3I530VBN7q7MU+6DnIaOKfYANTOSLp+ZHofrtOQY5UW0ozVAQd
AtWDFy019wrfep8wZXYsHP9DkjMAC9MNDUbC6mrpnSSofRhunKTRZGpgpjUE0erI
ALKKKag8K7FLLpmCdiX1esIdT7juVffPn5SeL149eGlv70DaDY0CuNN1lxGL5QAu
JPsvfj01ymzsKFZXb1oopckCqiG5YRW7pAUh4WE+9OuD7A0gGp/gu/26Npk77tiI
Dsy59vN6Vi1C89SDOiGXCXGS+mx7V/vGxETg2rGXICFTSJD5XRHmWNfNY/tpjhVJ
kXjFfO6ttl8Zunt1bddR+YE9vwlWV0zUKsKNr7ig2O7KOvJNMxr7FKGK072rogDI
orplpBHLGU7PgiFDSW5JyAZLuKCY+3y8//v6HpMKZNbltNaVNJ2fpNFEVc2ZKDVy
TKUrwQeOCaHFLCnSqQWi8/Ej0E4Do1YZsxWTsehIH90dZsCr+1c2IDKz7M+zoPNM
QIYoZM/rzdPsAHLIcP0WsJw8LIPwQzOfz1TKwvSR1C9PQXx5dASgw4K/jbGc3g4d
UylC8jPG0iY=
=ox3L
-----END PGP SIGNATURE-----

--Sig_/9btdBHCeIledLV27zmBwHhj--
