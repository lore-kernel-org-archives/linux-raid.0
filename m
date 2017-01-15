From: "J. Cassidy" <sean@jdcassidy.eu>
Subject: MDADM grow /dev/md0 - chunk size
Date: Sun, 15 Jan 2017 11:33:34 +0100
Message-ID: <8ef3e9f2d526ebba88b94a0e6f09fdef.webmail@mx1bln1.prossl.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hello all/Neil,




I am trying to change the chunk size on a RAID 0 (two SSD) from 512K to 64K.

I am running Debian Stretch with a 4.10 kernel.

MDADM version is 4.0 (GIT).

This is the command string being issued -

mdadm --grow -c 64 --backup-file=/zz/backup.file /dev/md0

or

mdadm --grow -c 64  /dev/md0

both of the abovementioned commands produce this message -


"mdadm: /dev/md0: could not set level to raid4"


A snippet from dmesg -
.
.
md/raid:md0: cannot takeover raid0 with more than one zone.
md: md0: raid4 would not accept array
.
.

My MDADM setup -


mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Jan 14 16:51:54 2017
     Raid Level : raid0
     Array Size : 497783808 (474.72 GiB 509.73 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Jan 14 16:51:54 2017
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : Pezenas:0  (local to host Pezenas)
           UUID : 77cd6f4e:f98bf2b0:862948df:12da38fa
         Events : 0

    Number   Major   Minor   RaidDevice State
       0     259        4        0      active sync   /dev/nvme0n1p2
       1     259        2        1      active sync   /dev/nvme1n1p1


I recall doing something similiar a few years ago and it worked, though not using
NVME drives.


Any help/pointers much appreciated.




Regards,



John






John Cassidy

Obere Bühlstrasse 21
8700 Küsnacht (ZH)
Switzerland / Suisse / Schweiz


Mobile:    +49  152 58961601 (Germany)
Mobile:    +352 621 577 149  (Luxembourg)
Mobile:    +41  78 769 17 97 (CH)
Landline:  +41  44 509 1957
Mobile email: mobile@jdcassidy.eu

http://www.jdcassidy.eu

"Aut viam inveniam aut faciam" - Hannibal.


