From: "Tomi Orava" <tomimo+linux-raid@ncircle.nullnet.fi>
Subject: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 08:57:31 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi everybody,

I have a slight problem here with my RAID 1+0 setup.
One of the discs just failed and I'm unable to figure
out why (for example) mdadm is unable to start the
particular RAID1 (/dev/md4-submirror, failed disc is /dev/sdd).

The setup is this:
------- /etc/raidtab -----------------------------------

##
## Data-Disk - Part 1
##
raiddev /dev/md3
        raid-level              1
        nr-raid-disks           2
        nr-spare-disks          0
        persistent-superblock   1

        ## device               /dev/hdk2
        device                  /dev/hde2
        raid-disk               0

        ## device               /dev/hdm2
        device                  /dev/hdg2
        raid-disk               1
        ## failed-disk          1


##
## Data-Disk - Part 2
##
raiddev /dev/md4
        raid-level              1
        nr-raid-disks           2
        nr-spare-disks          0
        persistent-superblock   1

        ## device               /dev/hdi2
        device                  /dev/sdd2
        raid-disk               0
        ## failed-disk          1

        ## device               /dev/hdg2
        device                  /dev/sdc2
        raid-disk               1
        ## failed-disk          1

##
## Data-Disk - Raid 1+0
##
raiddev /dev/md5
        raid-level              0
        nr-raid-disks           2
        nr-spare-disks          0
        persistent-superblock   1
        chunk-size              32

        device                  /dev/md3
        raid-disk               0

        device                  /dev/md4
        raid-disk               1
--------------------------------------------------------------

mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.00
  Creation Time : Mon Sep 16 23:33:02 2002
     Raid Level : raid1
     Array Size : 58616640 (55.90 GiB 60.02 GB)
    Device Size : 58616640 (55.90 GiB 60.02 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Fri Sep 26 08:06:35 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       0        0        0      faulty removed   /dev/swap
       1      33        2        1      active sync   /dev/hde2
       2      34        2        2      spare   /dev/hdg2
           UUID : fb702fa9:a4c55dcf:87cccecb:31f1e9ba
         Events : 0.465

mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d5c2d1f7:cf7cb245:2d9e7057:097ec133
  Creation Time : Mon Sep 16 22:05:35 2002
     Raid Level : raid1
    Device Size : 60034880 (57.25 GiB 61.48 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 4

    Update Time : Thu Mar 13 05:03:45 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 512475a - correct
         Events : 0.423


      Number   Major   Minor   RaidDevice State
this     2       8       50        2      spare   /dev/sdd2
   0     0       0        0        0      faulty removed   /dev/swap
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       8       50        2      spare   /dev/sdd2

-------------------------------------------------------
>mdadm -v -R /dev/md4
mdadm: failed to run array /dev/md4: No such device

The problem occurred while resynccing the /dev/md4 RAID1-mirror
and of course the "master" device was the faulty one.
The question now is, is someone capable of describing how to get
this /dev/md4-mirror started so that I can continue copying data
out of RAID1+0 (dev/md5) mirror ?

Regards,
Tomi Orava






