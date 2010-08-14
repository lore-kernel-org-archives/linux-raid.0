From: =?ISO-8859-2?Q?Pavel_Piln=FD?= <pavel@pjp.cz>
Subject: Problem with raid in QNAP TS-639Pro
Date: Sat, 14 Aug 2010 15:39:31 +0200
Message-ID: <4C669C93.5000509@pjp.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear,
 I have an problem with mdadm based NAS, Unfortunately producer support
don't have any interest to solve anything (Unfortunately as usually).
 What's happens - I created 6 HDD array RAID 5 by standard web
interface, because I had an problem with HDD, array was created in order
HDD 2,3,4,5,1,6. After appr. 1.5 year one hdd have problem, some chaos
to understand which hdd had problem (web interface), when I replaced
hdd, array was restore, but in different order of hdd - 2,3,4,5,6,1, hdd
6 and 1 are switch and result - inaccessible array ... unfortunately ...
 What I have there - better say no comment.
 My small question is simple - exist some solution for this situation
and restore standard work (of course - with (any) data there) ?
 
mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sat Jun 20 20:14:35 2009
     Raid Level : raid5
     Array Size : 7317848000 (6978.84 GiB 7493.48 GB)
  Used Dev Size : 1463569600 (1395.77 GiB 1498.70 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Aug 14 14:00:22 2010
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : bcb3df8c:c65faf60:784485de:5b9c58ae
         Events : 0.1040290

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       8       35        1      active sync   /dev/sdc3
       2       8       51        2      active sync   /dev/sdd3
       3       8       67        3      active sync   /dev/sde3
       4       8       83        4      active sync   /dev/sdf3
       5       8        3        5      active sync   /dev/sda3

 Original report I don't have, only mdadm.conf - ARRAY /dev/md0
devices=/dev/sdb3,/dev/sdc3,/dev/sdd3,/dev/sde3,/dev/sda3,/dev/sdf3

 mdadm  --examine /dev/md0
mdadm: No md superblock detected on /dev/md0.

 mdadm --examine-bitmap /dev/md0
        Filename : /dev/md0
           Magic : 6461646d
mdadm: invalid bitmap magic 0x6461646d, the bitmap file appears to be
corrupted
         Version : 1310734957
mdadm: unknown bitmap version 1310734957, either the bitmap file is
corrupted or you need to upgrade your tools

 I'll happy for any help.

 Best regards, Pavel

 
