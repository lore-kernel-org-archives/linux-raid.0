From: Jure Pecar <pegasus@telemach.net>
Subject: What is the logic behind 'Device or resource busy' ?
Date: Tue, 27 May 2003 01:59:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030527015918.047bf247.pegasus@telemach.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1"; boundary="pd/q08uAj=.Ld3.w"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--pd/q08uAj=.Ld3.w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Hi all,


Consider the situation where a drive sdx gets kicked out of a mirror md9. If
i want to add it back with mdadm /dev/md9 -a /dev/sdx1, i get the 'device
busy' error.

However, if i stop the mirror and start it right after, i can easily add the
sdx1 back into md9. But this also requires me to stop any services using
this mirror and unmount the filesystem on it...


Any particular reason that this must work that way?



-- 

Jure Pecar

--pd/q08uAj=.Ld3.w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+0qpYOHUMrcOSg+8RAmZ7AKDx8xus+TkUiJNAGY8cFfHfqKNlaQCeNDVg
CYWn5cD3Zlcdj0AgL/b/SSI=
=JvSP
-----END PGP SIGNATURE-----

--pd/q08uAj=.Ld3.w--
