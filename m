From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Re: Hints on reducing kickouts
Date: Sat, 3 Mar 2012 22:28:20 +0100
Message-ID: <CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
	<20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, John Obaterspok <john.obaterspok@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Please see below for errors I get when trying to add internal bitmap.

2012/3/1 Bryan Mesich <bryan.mesich@ndsu.edu>:
> On Thu, Mar 01, 2012 at 07:14:38PM +0100, John Obaterspok wrote:
>> Hello,
>>
>> Occasionally my system don't shutdown cleanly and almost all time
>> mdadm kicks one of the disks on the RAID5 array.
>> Is there anything I can do to help prevent this?
>>
>> I'm using sw raid 5 with 3 x 3TB Hitachi Deskstar (7K3000 HDS723030A=
LA640 64MB).
>>
>> --------
>
> [snip...]
>
> I'm guessing you're trying to avoid re-syncing a 6TB array in the
> event that your host goes down in an un-clean state. =A0In that
> case, I would suggest using a write-intent bitmap on the array.
> If you're concerned about loss of performance when using a
> bitmap, use an external bitmap that is located on another
> spindle(s).

okay, I'm trying to add an interal bitmap to see how much it slows down=
 things:

[root@Emperor ~]# mdadm --version
mdadm - v3.2.3 - 23rd December 2011


[root@Emperor ~]# mdadm --grow --bitmap=3Dinternal /dev/md2
mdadm: failed to set internal bitmap.


[root@Emperor ~]# mdadm --examine-bitmap /dev/md2
        Filename : /dev/md2
           Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupte=
d
         Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted
or you need to upgrade your tools


[root@Emperor ~]# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Jul 28 07:23:45 2011
     Raid Level : raid5
     Array Size : 5706313728 (5441.96 GiB 5843.27 GB)
  Used Dev Size : 2853156864 (2720.98 GiB 2921.63 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sat Mar  3 22:24:21 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : Emperor:2  (local to host Emperor)
           UUID : a9f823df:05acab4f:1b02cfb9:70173894
         Events : 1041

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       4       8       19        1      active sync   /dev/sdb3
       3       8       35        2      active sync   /dev/sdc3

This appears in 'dmesg'


[50068.295573] mdadm: sending ioctl 1261 to a partition!
[50068.295577] mdadm: sending ioctl 1261 to a partition!
[50068.320235] mdadm: sending ioctl 800c0910 to a partition!
[50068.320239] mdadm: sending ioctl 800c0910 to a partition!
[50174.085742] scsi_verify_blk_ioctl: 76 callbacks suppressed
[50174.085745] mdadm: sending ioctl 1261 to a partition!
[50174.085748] mdadm: sending ioctl 1261 to a partition!
[50174.086052] mdadm: sending ioctl 1261 to a partition!
[50174.086056] mdadm: sending ioctl 1261 to a partition!
[50174.086261] mdadm: sending ioctl 1261 to a partition!
[50174.086263] mdadm: sending ioctl 1261 to a partition!
[50174.091615] md2: invalid bitmap file superblock: bad magic
[50174.091618] md2: bitmap file superblock:
[50174.091620]          magic: 00400000
[50174.091622]        version: 4194320
[50174.091623]           uuid: 00400020.20005fe0.00010000.00000000
[50174.091625]         events: 2510791976631140352
[50174.091626] events cleared: 18014471528120321
[50174.091628]          state: 00030000
[50174.091629]      chunksize: 0 B
[50174.091630]   daemon sleep: 0s
[50174.091631]      sync size: 1152991873353122064 KB
[50174.091633] max write behind: -1180360704
[50174.095699] mdadm: sending ioctl 1261 to a partition!
[50174.095701] mdadm: sending ioctl 1261 to a partition!
[50174.121531] mdadm: sending ioctl 800c0910 to a partition!
[50174.121535] mdadm: sending ioctl 800c0910 to a partition!
[50226.959946] scsi_verify_blk_ioctl: 76 callbacks suppressed
[50226.959949] mdadm: sending ioctl 1261 to a partition!
[50226.959952] mdadm: sending ioctl 1261 to a partition!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
