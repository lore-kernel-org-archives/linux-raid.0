From: Philip Molter <philip@corp.texas.net>
Subject: Cannot remove failed drive
Date: Thu, 24 Jun 2004 08:49:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40DADBF2.3030105@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a drive that failed out:

scsi1: ERROR on channel 0, id 1, lun 0, CDB:
   Read (10) 00 00 c2 a0 3f 00 00 28 00
Info fld=0xc2a03f, Current sdf: sense key Medium Error
Additional sense: Read retries exhausted
end_request: I/O error, dev sdf, sector 12755007
raid1: Disk failure on sdf1, disabling device.
^IOperation continuing on 1 devices
raid1: sdf1: rescheduling sector 12754944
raid1: sdb1: redirecting sector 12754944 to another mirror

/proc/mdstat shows the drive failed:

md4 : active raid1 sdf1[2](F) sdb1[0]
       35905152 blocks [2/1] [U_]

When I try to remove the drive:

# mdadm /dev/md4 -r /dev/sdf1
mdadm: hot remove failed for /dev/sdf1: Device or resource busy

I've also tried manually setting the drive faulty and then removing it 
and still no luck.  The md4 mirror is part of a larger raid0 array, but 
I've also had this problem with straight-up raid5 arrays.  The drive 
itself is not locked up or unresponsive (I can access it via fdisk just 
fine).

Here is the detailed output from md4:

# mdadm --detail /dev/md4
/dev/md4:
         Version : 00.90.01
   Creation Time : Thu Jun 10 10:41:28 2004
      Raid Level : raid1
      Array Size : 35905152 (34.24 GiB 36.77 GB)
     Device Size : 35905152 (34.24 GiB 36.77 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 4
     Persistence : Superblock is persistent

     Update Time : Thu Jun 24 08:45:23 2004
           State : dirty, no-errors
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0


     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       0        0       -1      removed
        2       8       81        1      faulty   /dev/sdf1
            UUID : e46c58b4:42f0b4a8:c1bd4d97:51d9c528
          Events : 0.6005122

It seems that the only way I can really remove the drive is by stopping 
all access to the mirror, stopping it, then restarting it, at which 
time, the drive is gone and can be readded.  Why?  That defeats the 
purpose of my highly redundant hot-swappable server setup.

The system is a Fedora Core 2 box, running FC2 stock kernel 
2.6.5-1.358smp.  I have had this problem with other RAID arrays 
throughout the 2.6 series.

Any assistance would be greatly appreciated.
Philip
