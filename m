From: rob <rob@fantinibakery.com>
Subject: Re: RAID1-Device won't survive reboot
Date: Wed, 08 Oct 2003 17:38:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8483CE.2070309@fantinibakery.com>
References: <OFBE4F4C3A.AD55E9B4-ONC1256DB9.0052F11A@pta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OFBE4F4C3A.AD55E9B4-ONC1256DB9.0052F11A@pta.de>
To: alexander.weber@pta.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not familiar with SuSE 8.2,   but here are some hints:

-is it possible that  either the mount of md0 is getting done before  
md0 is assembled, or hdb1  is getting mounted directly?  check  df -v  
right after boot.

- is /boot included in  /   ?     -   It could have been dated info, but 
I read not to include /boot.
     someone please correct this if I'm wrong.

-  do you use  /etc/mdadm.conf  and or  /etc/raidtab ?   maybe there is 
some inconsistent info in those files?

- try  grep  md0  /var/log/   ,  maybe info there will help you debug.

in case it helps, this the info I've got on one of my systems:


root@fbc5:/var/log # mdadm -V
mdadm - v1.0.1 - 20 May 2002

root@fbc5:/var/log # grep md0 syslog
Oct  7 12:48:49 fbc5 kernel: md: created md0
Oct  7 12:48:49 fbc5 kernel: md0: max total readahead window set to 124k
Oct  7 12:48:49 fbc5 kernel: md0: 1 data-disks, max readahead per 
data-disk: 124k
Oct  7 12:48:49 fbc5 kernel: raid1: raid set md0 active with 2 out of 2 
mirrors
Oct  7 12:48:49 fbc5 kernel: md: updating md0 RAID superblock on device
Oct  7 13:13:51 fbc5 kernel: md: created md0
Oct  7 13:13:51 fbc5 kernel: md0: max total readahead window set to 124k
Oct  7 13:13:51 fbc5 kernel: md0: 1 data-disks, max readahead per 
data-disk: 124k
Oct  7 13:13:51 fbc5 kernel: raid1: raid set md0 active with 2 out of 2 
mirrors
Oct  7 13:13:51 fbc5 kernel: md: updating md0 RAID superblock on device



alexander.weber@pta.de wrote:

>Hello fellows,
>
>I have set up a SuSE 8.2-box with two harddrives making up a RAID1-Array,
>including the root-partition on /dev/md0. The system works just fine, but
>what me keeps uncomfortable is the fact that after reboot /dev/md0 works on
>only one disk. Look:
>
>cat /proc/mdstat
>Personalities : [raid1]
>read_ahead 1024 sectors
>md0 : active raid1 hdb1[0]
>      5245120 blocks [2/1] [U_]
>
>md1 : active raid1 hdb5[0] hda5[1]
>      5245120 blocks [2/2] [UU]
>
>md2 : active raid1 hdb6[0] hda6[1]
>      15735552 blocks [2/2] [UU]
>
>md3 : active raid1 hdb7[0] hda7[1]
>      5245120 blocks [2/2] [UU]
>
>unused devices: <none>
>
>After
>raidhotadd /dev/md0 /dev/hda1
>/dev/hda1 is added to the array, and after resyncing it will do its job,
>but the next reboot will leave it failed again.
>
>What can I do to make my RAID-array survive a reboot?
>Thanks for hints.
>
>Alexander
>
>
>
>Before raidhotadd:
> # mdadm -E /dev/hda1
>/dev/hda1:
>          Magic : a92b4efc
>        Version : 00.90.00
>           UUID : 2598fd96:1021343c:b783de9d:198f6167
>  Creation Time : Fri Sep 12 17:42:02 2003
>     Raid Level : raid1
>    Device Size : 5245120 (5.00 GiB 5.37 GB)
>   Raid Devices : 2
>  Total Devices : 3
>Preferred Minor : 0
>
>    Update Time : Mon Sep 29 15:31:47 2003
>          State : dirty, no-errors
> Active Devices : 2
>Working Devices : 2
> Failed Devices : 1
>  Spare Devices : 0
>       Checksum : 2f2368bf - correct
>         Events : 0.106
>
>
>      Number   Major   Minor   RaidDevice State
>this     1       3        1        1      active sync   /dev/hda1
>   0     0       3       65        0      active sync   /dev/hdb1
>   1     1       3        1        1      active sync   /dev/hda1
>
>Then:
>
># raidhotadd /dev/md0 /dev/hda1
># mdadm -E /dev/hda1
>/dev/hda1:
>          Magic : a92b4efc
>        Version : 00.90.00
>           UUID : 2598fd96:1021343c:b783de9d:198f6167
>  Creation Time : Fri Sep 12 17:42:02 2003
>     Raid Level : raid1
>    Device Size : 5245120 (5.00 GiB 5.37 GB)
>   Raid Devices : 2
>  Total Devices : 3
>Preferred Minor : 0
>
>    Update Time : Wed Oct  8 16:21:39 2003
>          State : dirty, no-errors
> Active Devices : 1
>Working Devices : 2
> Failed Devices : 1
>  Spare Devices : 1
>       Checksum : 2f2f51eb - correct
>         Events : 0.112
>
>
>      Number   Major   Minor   RaidDevice State
>this     2       3        1        2        /dev/hda1
>   0     0       3       65        0      active sync   /dev/hdb1
>   1     1       0        0        1      faulty removed
>   2     2       3        1        2        /dev/hda1
># cat /proc/mdstat
>Personalities : [raid1]
>read_ahead 1024 sectors
>md0 : active raid1 hda1[2] hdb1[0]
>      5245120 blocks [2/1] [U_]
>      [======>..............]  recovery = 31.1% (1632712/5245120)
>finish=1.8min speed=32243K/sec
>md1 : active raid1 hdb5[0] hda5[1]
>      5245120 blocks [2/2] [UU]
>
>md2 : active raid1 hdb6[0] hda6[1]
>      15735552 blocks [2/2] [UU]
>
>md3 : active raid1 hdb7[0] hda7[1]
>      5245120 blocks [2/2] [UU]
>
>unused devices: <none>
>
># cat /proc/mdstat
>Personalities : [raid1]
>read_ahead 1024 sectors
>md0 : active raid1 hda1[1] hdb1[0]
>      5245120 blocks [2/2] [UU]
>
>md1 : active raid1 hdb5[0] hda5[1]
>      5245120 blocks [2/2] [UU]
>
>md2 : active raid1 hdb6[0] hda6[1]
>      15735552 blocks [2/2] [UU]
>
>md3 : active raid1 hdb7[0] hda7[1]
>      5245120 blocks [2/2] [UU]
>
>unused devices: <none>
>
># mdadm -E /dev/hda1
>/dev/hda1:
>          Magic : a92b4efc
>        Version : 00.90.00
>           UUID : 2598fd96:1021343c:b783de9d:198f6167
>  Creation Time : Fri Sep 12 17:42:02 2003
>     Raid Level : raid1
>    Device Size : 5245120 (5.00 GiB 5.37 GB)
>   Raid Devices : 2
>  Total Devices : 3
>Preferred Minor : 0
>
>    Update Time : Wed Oct  8 16:24:14 2003
>          State : dirty, no-errors
> Active Devices : 2
>Working Devices : 2
> Failed Devices : 1
>  Spare Devices : 0
>       Checksum : 2f2f5291 - correct
>         Events : 0.113
>
>
>      Number   Major   Minor   RaidDevice State
>this     1       3        1        1      active sync   /dev/hda1
>   0     0       3       65        0      active sync   /dev/hdb1
>   1     1       3        1        1      active sync   /dev/hda1
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>**********************************************************************
>http://www.pta.de
>Mit 783 Erfahrungsberichten aus 34 Jahren erfolgreicher Projektarbeit!
>**********************************************************************
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

