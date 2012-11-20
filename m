From: Stephen Haran <steveharan@gmail.com>
Subject: RAID5 NAS Recovery...00.90.01 vs 00.90
Date: Tue, 20 Nov 2012 15:41:57 -0500
Message-ID: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I'm trying to recover a Western Digital Share Space NAS.
I'm able to assemble the RAID5 and restore the LVM but it can't see
any filesystem.

Below is a raid.log file that shows how the raid was configured when
it was working.
And also the output of mdadm -D showing the raid in it's current state.
Note the Version difference 00.90.01 vs. 0.90. And the array size
difference 2925293760  vs. 2925894144
I'm thinking this difference may be the reason Linux can not see a filesystem.

My question is would the version difference explain the array size difference?
And is it possible to create a version 00.90.01 array? I do not see
that in the mdadm docs.

....original working raid config....
/dev/md2:
        Version : 00.90.01
  Creation Time : Wed Jun 24 19:00:59 2009
     Raid Level : raid5
     Array Size : 2925293760 (2789.78 GiB 2995.50 GB)
    Device Size : 975097920 (929.93 GiB 998.50 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jun 25 02:36:31 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 6860a291:a5479bc6:e782da22:90dbd792
         Events : 0.45705

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       8       52        3      active sync   /dev/sdd4


....and here is the raid as it stands now. Note the end user I'm
helping tried to rebuild back on Sunday...

 % mdadm -D /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Sun Nov 18 12:07:53 2012
     Raid Level : raid5
     Array Size : 2925894144 (2790.35 GiB 2996.12 GB)
  Used Dev Size : 975298048 (930.12 GiB 998.71 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Nov 20 16:06:10 2012
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 2ac5bacd:b40dc3f5:cb031839:58437670
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0     253       19        0      active sync   /dev/dm-19  <<<
Note I am using cow devices via dmsetup
       1     253       11        1      active sync   /dev/dm-11
       2     253       15        2      active sync   /dev/dm-15
       3     253        7        3      active sync   /dev/dm-7

Thank you for any and all help.

Regards,
Stephen
