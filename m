From: Keith Phillips <spootsy.ootsy@gmail.com>
Subject: Re: Fwd: Help with failed RAID-5 -> 6 migration
Date: Tue, 11 Jun 2013 11:38:49 +0930
Message-ID: <CAASLJ=52pzLpk179U=SY+5aGmEe+XcSfrEuBLC_o1ThPvAXfew@mail.gmail.com>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
	<51B3B7FF.9080800@turmel.org>
	<CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com>
	<CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com>
	<51B62A8A.9070108@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B62A8A.9070108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi  Phil,

> A big stack trace suggests other problems in your system.  Not that you
> don't have potential I/O error issues, but there might be a kernel problem.
>
> Please show "uname -a" and "mdadm --version".

These are the verisons I currently have, which the migration was
attempted with. The array was originally constructed years ago,
probably with older kernel/mdadm versions:

Linux muncher 3.0.0-32-server #51-Ubuntu SMP Thu Mar 21 16:09:49 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

mdadm - v3.1.4 - 31st August 2010

> The key thing to look for is a nonzero mismatch count in sysfs for that
> array.  I'm not familiar with Ubuntu's script, so you might want to look
> by hand at some future point.

I'll have a look in future. I do also have mdadm running daily via
cron with "--monitor --oneshot" - do you know if this checks the
"mismatch_cnt" file and reports errors?

>> Also, while poking yesterday I noticed I was getting warnings of the
>> form "Device has wrong state in superblock but /dev/sde seems ok", so
>> I tried a forced assemble:
>> mdadm --assemble /dev/md0 --force
>>
>> Looks like it updated some info in the superblocks (and yes, I forgot
>> to save the original output first!), but the array remains inactive. I
>> have now sworn off poking around by myself, because I've no idea what
>> to do from here.
>
> Please show /proc/mdstat again, along with "mdadm -D /dev/md0".

---------------------------
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sde[4] sdc[1] sdb[0] sdd[3]
      7814054240 blocks super 1.2

unused devices: <none>
---------------------------
/dev/md0:
        Version : 1.2
  Creation Time : Sun Jul 17 00:41:57 2011
     Raid Level : raid6
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Jun  8 11:00:43 2013
          State : active, degraded, Not Started
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 512K

     New Layout : left-symmetric

           Name : muncher:0  (local to host muncher)
           UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
         Events : 50599

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       3       8       48        2      active sync   /dev/sdd
       4       8       64        3      spare rebuilding   /dev/sde
---------------------------

>> for x in /sys/block/sd[acde]/device/timeout ; do echo $x $(< $x) ; done
>> ----------------------------
>> /sys/block/sdb/device/timeout 30
>> /sys/block/sdc/device/timeout 30
>> /sys/block/sdd/device/timeout 30
>> /sys/block/sde/device/timeout 30
>
> Due to your green drives, you cannot leave these timeouts at 30 seconds.
>  I recommend 180 seconds:
>
> for x in /sys/block/sd[bcde]/device/timeout ; do echo 180 >$x ; done
>
> (You should do this ASAP.  On the run is fine.)
>
> You will need your system to do this at every boot.  Most distros have
> rc.local or a similar scripting mechanism you can use.
>
> Phil

Done - thanks for the tip.
