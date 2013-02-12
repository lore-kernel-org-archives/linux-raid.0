From: Phillip Susi <psusi@ubuntu.com>
Subject: Size inconsistencies and rounding errors
Date: Tue, 12 Feb 2013 11:23:26 -0500
Message-ID: <511A6C7E.3070307@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

mdadm -D and -E use inconsistent units and round incorrectly.  It
appears that -E lists the size in sectors, but -D lists it in KiB, and
both list 1024.16 MiB on a loop device that is exactly 1024 MiB long.
 Given the listed KiB/sector count, the correct value should be
1023.99 MiB.  This happens both with mdadm 3.2.3-2ubuntu1 on Ubuntu
12.04, as well as with a freshly built git head.

mdadm -E /dev/loop0
/dev/loop0:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 7c24e61e:4e28fb01:79299569:864ea4e3
           Name : devserv:1  (local to host devserv)
  Creation Time : Tue Feb 12 10:36:51 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 2097128 (1024.16 MiB 1073.73 MB)
     Array Size : 1048564 (1024.16 MiB 1073.73 MB)
   Super Offset : 2097136 sectors
          State : clean
    Device UUID : f4cd17ea:5a311275:f74f2fa2:ffa1b41a

    Update Time : Tue Feb 12 10:39:36 2013
       Checksum : 8314a161 - correct
         Events : 8


   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)

mdadm -D /dev/md1
/dev/md1:
        Version : 1.0
  Creation Time : Tue Feb 12 10:36:51 2013
     Raid Level : raid1
     Array Size : 1048564 (1024.16 MiB 1073.73 MB)
  Used Dev Size : 1048564 (1024.16 MiB 1073.73 MB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Feb 12 10:39:36 2013
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : devserv:1  (local to host devserv)
           UUID : 7c24e61e:4e28fb01:79299569:864ea4e3
         Events : 8

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       2       0        0        2      removed

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRGmx+AAoJEJrBOlT6nu75Ar8IAK/PZud5chvVnJzS7yA8zyu2
f6wt4obdwDzKCIwhC+jR4Xc1n/T5oOPxVQH/Ciwdm2sB6zr/8xZLI02mACZsLBqr
vGLoHbpFASwh5NieWKnbcAnTLNHb1CFCc0v4jNaNL/7eLIxgDceW20a6RPMVwgdd
vSPE3QIwkuctJ+HSsLtwjJkpIkCBu32XsruIkdSkV1VBrrWxF/AiqEOyVYK5bLF0
1LjbaKARR4/k60/9MiuyNGz1/GUP+thxo5aaBhhf5ynZOPR79c/j1aGs28zsBVtW
xW7wFzcdoIConXCzpvXYQtudUkqRrLlRTZD8oNmZift7EIha+iOpcD9T+9LcaeM=
=CmVu
-----END PGP SIGNATURE-----
