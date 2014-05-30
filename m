From: Thomas Leuxner <tlx@leuxner.net>
Subject: Keep existing slot number after replacing drive
Date: Fri, 30 May 2014 13:53:26 +0200
Message-ID: <20140530115326.GB4500@nihlus.leuxner.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after removing a faulty drive from an array the slot number gets increased =
for the drive replaced:

# mdadm -D /dev/md1
/dev/md1:
       Version : 1.2
 Creation Time : Thu May  8 22:42:14 2014
    Raid Level : raid1
    Array Size : 979953 (957.15 MiB 1003.47 MB)
 Used Dev Size : 979953 (957.15 MiB 1003.47 MB)
  Raid Devices : 2
 Total Devices : 2
   Persistence : Superblock is persistent

   Update Time : Fri May 30 13:26:45 2014
         State : clean=20
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

          Name : nihlus:1
          UUID : dde5fcbe:2f49d417:6b2fd8cf:a0a5a71c
        Events : 107

   Number   Major   Minor   RaidDevice State
      0       8        2        0      active sync   /dev/sda2
      2       8       18        1      active sync   /dev/sdb2

Is there a way to to reuse the old slot (1 in this case) when adding the ne=
w disk rather than skipping a slot?

Regards
Thomas

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOIcTYACgkQ+meF/S97aXgyUgCeOncFtrSw1rU8q27zPqfkDOVO
txsAn1679AnGZ5K/jck+mtjY4Kz/F3Gf
=RHyL
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
