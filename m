From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: safely removing RAID information?
Date: Thu, 9 Nov 2006 11:19:09 +0100
Message-ID: <20061109101909.GA10711@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

I have the following 'leftover setup' from testing:

---snip---
/dev/hda:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 533fb996:8989f533:2dc6aaa9:74fdd762
  Creation Time : Sat Jun 24 08:37:43 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 488396928 (465.77 GiB 500.12 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Jul  7 17:49:52 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c0941be6 - correct
         Events : 0.1780

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      34        0        1      active sync

   0     0      33       64        0      active sync
   1     1      34        0        1      active sync
   2     2      34       64        2      active sync
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3559ffcf:14eb9889:3826d6c2:c13731d7
  Creation Time : Fri Jul  7 20:12:10 2006
     Raid Level : raid1
    Device Size : 497856 (486.27 MiB 509.80 MB)
     Array Size : 497856 (486.27 MiB 509.80 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Nov  9 05:12:56 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 76d7e7e8 - correct
         Events : 0.1990


      Number   Major   Minor   RaidDevice State
this     1       3        1        1      active sync   /dev/hda1

   0     0       3       65        0      active sync   /dev/hdb1
   1     1       3        1        1      active sync   /dev/hda1
   2     2      22        1        2      active sync   /dev/hdc1

---snap---

Now, /dev/hda1 (and hda[35678]) are parts of active RAID arrays.
/dev/hda (whole disk) was part of an array I set up for testing/playing
around with mdadm. I then created the partitions and set up RAIDs for them.

Is it safe to issue the following command now:

root@ceres:~# mdadm --zero-superblock /dev/hda

or will that nuke my setup along with my precious data?
My software versions are the following:

root@ceres:/usr/src/wip/installer/package/base/installer# mdadm --version
mdadm - v2.4 - 30 March 2006
root@ceres:/usr/src/wip/installer/package/base/installer# uname -a
Linux ceres 2.6.17.7-rock-dragon #2 SMP Wed Aug 30 17:21:35 CEST 2006 i686 =
GNU/Linux


Thanks in advance,
	Benjamin
--=20
#!/bin/sh #!/bin/bash #!/bin/tcsh #!/bin/csh #!/bin/kiss #!/bin/ksh
#!/bin/pdksh #!/usr/bin/perl #!/usr/bin/python #!/bin/zsh #!/bin/ash

Feel at home? Got some of them? Want to show some magic?

	http://shellscripts.org

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFUwCdAsME5O4xgqgRAsO9AJ978QoCkNc8gqCHU70Aok2eMsZ8ZgCg8KTu
VBiVef8EWYb8bWhE3/nD/8Y=
=X0BA
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
