From: =?iso-8859-1?Q?Agust=EDn_Ciciliani?= <agustin@maderonet.net.ar>
Subject: Raid 1 - md "Total Disks" question
Date: Mon, 13 Sep 2004 13:03:26 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <019801c499ab$405f20d0$6800a8c0@Agus>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everybody,

I was wondering if you could take a look to the following and give some=
 advice... I just
have TWO SATA WD800 disks and "mdadm" says I have "three" and one of th=
em has "failed"!!!

I have 8 more raid devices and all of them saying exactly the same. I'm=
 running debian
with 2.4.19 kernel if that helps.

Thanks in advance,

Agust=EDn



maria:/# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Wed Sep  8 22:31:30 2004
     Raid Level : raid1
     Array Size : 14464 (14.12 MiB 14.81 MB)
    Device Size : 14464 (14.12 MiB 14.81 MB)
    Raid Disks : 2
***    Total Disks : 3 ***
Preferred Minor : 1
    Persistance : Superblock is persistant

    Update Time : Wed Sep  8 23:03:53 2004
          State : dirty, no-errors
  Active Drives : 2
 Working Drives : 2
***  Failed Drives : 1 ***
   Spare Drives : 0

    Number   Major   Minor   RaidDisk   State
       0       3        1        0      active sync   /dev/hda1
       1      22        1        1      active sync   /dev/hdc1
           UUID : 2bf99542:45c208ee:df7011a5:0e8b602f

maria:/# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 hda1[0] hdc1[1]
      14464 blocks [2/2] [UU]


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
