From: Andreas-Sokov <andre.s@j8.com.ru>
Subject: mdadm: /dev/md1: Cannot reshape array without increasing size (yet).
Date: Sat, 2 Feb 2008 05:59:58 +0300
Message-ID: <1656519910.20080202055958@j8.com.ru>
Reply-To: Andreas-Sokov <andre.s@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi linux-raid.

What is problem with raid ?
why "mdadm: /dev/md1: Cannot reshape array without increasing size (yet=
)."

i have

root@raid01:~# mdadm -D /dev/md1
/dev/md1:
        Version : 00.91.03
  Creation Time : Tue Nov 13 18:42:36 2007
     Raid Level : raid5
     Array Size : 1465159488 (1397.29 GiB 1500.32 GB)
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sat Feb  2 05:45:11 2008
          State : clean, degraded
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (4->5)

           UUID : 4fbdc8df:07b952cf:7cc6faa0:04676ba5
         Events : 0.683510

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       0        0        4      removed

       5       8       16        -      spare   /dev/sdb
root@raid01:~#




--=20
=D1 =F3=E2=E0=E6=E5=ED=E8=E5=EC,
 Andreas-Sokov                          mailto:andre.s@j8.com.ru

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
