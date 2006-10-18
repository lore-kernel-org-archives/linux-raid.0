From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Problem with Software RAID5
Date: Wed, 18 Oct 2006 11:39:44 +0200
Message-ID: <4535F660.90901@cgv.tugraz.at>
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

I=B4ve got a problem with a software raid5.
PC runs debian sarge/sid/etch mix with 2.6.16 self built and mdadm mdad=
m
2.5.3.git200608202239-7.
1 of 6 SATA 400GB drives failes and I rebooted the PC.
After reboot RAID was resyncing.
But again the HD died and the PC rebooted again, I pulled off the bad H=
D
and now the RAID5 won=B4t resync again.
I built a 2.6.17 kernel and replaced mdadm to  mdadm 2.5.4-1 and still
RAID5 won=B4t resync again:
cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid5] [raid4]
[raid6] [multipath] [faulty]
md0 : inactive sda1[0] sde1[5] sdd1[4] sdc1[3] sdb1[1]
      1953543680 blocks

unused devices: <none>

 mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Fri May 12 16:10:24 2006
     Raid Level : raid5
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Oct 17 14:11:56 2006
          State : active, degraded, Not Started
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           UUID : 5ce125ae:b76d7567:a531953b:fbba92fc
         Events : 0.2818447

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       0        0        2      removed
       3       8       33        3      active sync   /dev/sdc1
       4       8       49        4      active sync   /dev/sdd1
       5       8       65        5      active sync   /dev/sde1

mdadm --stop /dev/md0
mdadm: stopped /dev/md0

sinope:~# mdadm --assemble /dev/md0
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

Any hints? tips?


MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFNfZgmWhuE0qbFyMRAqBBAJoCcE4gMx83NQl8pksSqgEpBHWNiACfTpKr
NVHtinnXRPIbY2Rfv3BUC0s=3D
=3Dsvsf
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
