From: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Subject: Strangeness when booting raid1: md5 already running?
Date: Mon, 21 Mar 2005 12:26:18 +0000
Message-ID: <1111407978.757.7.camel@filestore.ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I had to pull the plug on my box today, and when it rebooted got this
rather strange raid issue. The box has 5 raid1 arrays, consisting of 5
partitions on each of 2 drives. When it rebooted, the md5 array came up
like so:

raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda9 ...
md:  adding hda9 ...
md: md5 already running, cannot run hda9
md: export_rdev(hda9)
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda9 ...
md:  adding hda9 ...
md: md5 already running, cannot run hda9
md: export_rdev(hda9)
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda9 ...
md:  adding hda9 ...
md: md5 already running, cannot run hda9
md: export_rdev(hda9)
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda9 ...
md:  adding hda9 ...
md: md5 already running, cannot run hda9
md: export_rdev(hda9)
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda9 ...
md:  adding hda9 ...
md: md5 already running, cannot run hda9
md: export_rdev(hda9)
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
EXT3-fs: recovery complete.

Now this was the first time the string "md5" appears in the log. And
indeed, it appears that hda9 has been kicked out of the array:

mdadm --examine /dev/hdc9
/dev/hdc9:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a3f13998:4c0f70df:ea732842:0133b262
  Creation Time : Thu Nov 25 11:50:26 2004
     Raid Level : raid1
    Device Size : 3301248 (3.15 GiB 3.38 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 5

    Update Time : Mon Mar 21 12:23:24 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 906511c - correct
         Events : 0.937092


      Number   Major   Minor   RaidDevice State
this     0      22        9        0      active sync   /dev/hdc9
   0     0      22        9        0      active sync   /dev/hdc9
   1     1       0        0        1      faulty removed


The equivalent command on hda9 produces the same info, barring the event
count and that it says "active sync /dev/hda9" for itself.

Any thoughts on why this happened?

Ruth


-- 
Ruth Ivimey-Cook <ruth@ivimey.org>

