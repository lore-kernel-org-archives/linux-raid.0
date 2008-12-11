From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: problem with software RAID5
Date: Thu, 11 Dec 2008 15:03:24 +0100
Message-ID: <49411DAC.8000502@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

I run a 3 disk RAID5 on a debian 2.6.26 machine.

Last weekend one of that disk went bad and the raid went on with 2 disk=
s.

Now I restarted and added the 3d disk and the RAID5 went crazy, callind
disks after disk faulty and (S)... and I do not know why.

Information:

mdadm -E /dev/md1 /dev/sde1
mdadm: No md superblock detected on /dev/md1.
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : d9fde523:3bcc01a6:041868f5:0ec5fcb6
  Creation Time : Tue Jan 17 14:30:37 2006
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Thu Dec 11 14:46:37 2008
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 9972dbb9 - correct
         Events : 2851680

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       49        3      spare   /dev/sdd1


trinculo:~# mdadm -E /dev/md1 /dev/sdg1
mdadm: No md superblock detected on /dev/md1.
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : d9fde523:3bcc01a6:041868f5:0ec5fcb6
  Creation Time : Tue Jan 17 14:30:37 2006
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 1

    Update Time : Thu Dec 11 14:55:06 2008
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 9972ddaf - correct
         Events : 2851688

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync   /dev/sdg1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync


mdadm -E /dev/md1 /dev/sdd1
mdadm: No md superblock detected on /dev/md1.
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : d9fde523:3bcc01a6:041868f5:0ec5fcb6
  Creation Time : Tue Jan 17 14:30:37 2006
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Thu Dec 11 14:46:49 2008
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 9972dbca - correct
         Events : 2851686

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      spare   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       49        3      spare   /dev/sdd1


In which /dev/sdd went bad and was offline.

How can I try to reassemble that raid5?

MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklBHasACgkQmWhuE0qbFyM1ugCeMwRpI6mv8rps8B51l4sNxBZo
KH0An3OsTEOlKtoQugxiE7pC5S7xnQl2
=3D7rDg
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
