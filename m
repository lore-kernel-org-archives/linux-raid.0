From: "John Stoffel" <stoffel@lucent.com>
Subject: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 10:08:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16658.16220.904470.117836@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: stoffel@sekrit.inse.lucent.com
List-Id: linux-raid.ids


Hi folks,

I've run into a problem on my debian SMP system, running kernels
2.6.7-rc3 (as well as 2.6.8-rc2-mm2 and 2.6.8-rc3) where I can't seem
to add or removed devices from my /dev/md0 array.  The system is a
dual processor Xeon, 550mhz.  Debian unstable, fairly aggressively
updated.

The root filesystems are all on SCSI disks, and I have a pair of WD
120gb drives on a Promise HPT302 controller which are mirrored.  These
are /dev/hde and /dev/hdg respectively.  The other day while I was
mucking around with getting a third 120gb drive working in a
USB2.0/Firewire external case, I noticed that /dev/md0 had lost one of
it's two disks, /dev/hdg.  I've been trying to re-add it back in, but
I can't.  

What I'm doing is setting up the two disks mirrored as /dev/md0 using
/dev/hde1 and /dev/hdg1.  Then I've setup a volume group using
DeviceMapper to hold a pair of filesystems on there, so that I can
grow/shrink them as needed down the line.  So far so good.  The data
is all there and I can still access it no problem, but I can't get my
data mirrored again!

I've run a complete badblocks on /dev/hdg and it passes without any
problems.  I suspect that because I have what looks to be two UUIDs
associated with /dev/md0, that it's somehow screwed up somewhere.  I
really don't want to lose this data if I can help it.  

Here's some info on versions and setup.

    # mdadm --version
    mdadm - v1.6.0 - 4 June 2004

I had been using 1.4.0-3 before, but I upgraded in case there was
something wrong.  I can drop back if need be.

   # cat /proc/partitions
   major minor  #blocks  name

     33     0  117220824 hde
     33     1  117218241 hde1
     34     0  117220824 hdg
     34     1  117218241 hdg1
      8     0   17783000 sda
      8     1     248976 sda1
      8     2    4000185 sda2
      8     3     996030 sda3
      8     4          1 sda4
      8     5    4000153 sda5
      8     6    8000338 sda6
      8    16   17782540 sdb
      8    17     248976 sdb1
      8    18     996030 sdb2
      8    19   16530885 sdb3
      9     0  117218176 md0
      8    32  117220824 sdc
      8    33   58593496 sdc1
      8    34   48828024 sdc2
    253     0   53477376 dm-0
    253     1   36700160 dm-1
    253     2  117218241 dm-2
    253     3     248976 dm-3
    253     4     996030 dm-4
    253     5   16530885 dm-5
    253     6   58593496 dm-6
    253     7   48828024 dm-7


    # mdadm -QE --scan
    ARRAY /dev/md0 level=raid1 num-devices=2 UUID=2e078443:42b63ef5:cc179492:aecf0094
       devices=/dev/hde1
    ARRAY /dev/md0 level=raid1 num-devices=2 UUID=9835ebd0:5d02ebf0:907edc91:c4bf97b2
       devices=/dev/hde

This bothers me, why am I seeing two different UUIDs here?
	
    # mdadm --detail /dev/md0
    /dev/md0:
	    Version : 00.90.01
      Creation Time : Fri Oct 24 19:23:41 2003
	 Raid Level : raid1
	 Array Size : 117218176 (111.79 GiB 120.03 GB)
	Device Size : 117218176 (111.79 GiB 120.03 GB)
       Raid Devices : 2
      Total Devices : 1
    Preferred Minor : 0
	Persistence : Superblock is persistent

	Update Time : Thu Aug  5 09:33:35 2004
	      State : clean, degraded
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 0
      Spare Devices : 0


	Number   Major   Minor   RaidDevice State
	   0      33        1        0      active sync   /dev/hde1
	   1       0        0       -1      removed
	       UUID : 2e078443:42b63ef5:cc179492:aecf0094
	     Events : 0.990424


Here's another strange thing.  I have Raid Devices = 2, but the Active
and Working Devices are both 1.  

I've unmounted both filesystems, stopped the volume group (vgchange -a
n) and now stopped the /dev/md0 device with:

   mdadm --stop --scan

Then I rebuilt it with:

    # mdadm --assemble /dev/md0 --auto --scan --update=summaries --verbose
    mdadm: looking for devices for /dev/md0
    mdadm: /dev/hde has wrong uuid.
    mdadm: /dev/hde1 is identified as a member of /dev/md0, slot 0.
    mdadm: no RAID superblock on /dev/hdg
    mdadm: /dev/hdg has wrong uuid.
    mdadm: no RAID superblock on /dev/hdg1
    mdadm: /dev/hdg1 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda
    mdadm: /dev/sda has wrong uuid.
    mdadm: no RAID superblock on /dev/sda1
    mdadm: /dev/sda1 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda2
    mdadm: /dev/sda2 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda3
    mdadm: /dev/sda3 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda4
    mdadm: /dev/sda4 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda5
    mdadm: /dev/sda5 has wrong uuid.
    mdadm: no RAID superblock on /dev/sda6
    mdadm: /dev/sda6 has wrong uuid.
    mdadm: no RAID superblock on /dev/sdb
    mdadm: /dev/sdb has wrong uuid.
    mdadm: no RAID superblock on /dev/sdb1
    mdadm: /dev/sdb1 has wrong uuid.
    mdadm: no RAID superblock on /dev/sdb2
    mdadm: /dev/sdb2 has wrong uuid.
    mdadm: no RAID superblock on /dev/sdb3
    mdadm: /dev/sdb3 has wrong uuid.
    mdadm: no RAID superblock on /dev/sdc
    mdadm: /dev/sdc has wrong uuid.
    mdadm: no RAID superblock on /dev/sdc1
    mdadm: /dev/sdc1 has wrong uuid.
    mdadm: no RAID superblock on /dev/sdc2
    mdadm: /dev/sdc2 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/hdg1
    mdadm: /dev/evms/.nodes/hdg1 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/sdb1
    mdadm: /dev/evms/.nodes/sdb1 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/sdb2
    mdadm: /dev/evms/.nodes/sdb2 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/sdb3
    mdadm: /dev/evms/.nodes/sdb3 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/sdc1
    mdadm: /dev/evms/.nodes/sdc1 has wrong uuid.
    mdadm: no RAID superblock on /dev/evms/.nodes/sdc2
    mdadm: /dev/evms/.nodes/sdc2 has wrong uuid.
    mdadm: no uptodate device for slot 1 of /dev/md0
    mdadm: added /dev/hde1 to /dev/md0 as 0
    mdadm: /dev/md0 has been started with 1 drive (out of 2).

Which is great, I can still see it without a problem.

    jfsnew:/etc/init.d# mdadm --detail /dev/md0
    /dev/md0:
	    Version : 00.90.01
      Creation Time : Fri Oct 24 19:23:41 2003
	 Raid Level : raid1
	 Array Size : 117218176 (111.79 GiB 120.03 GB)
	Device Size : 117218176 (111.79 GiB 120.03 GB)
       Raid Devices : 2
      Total Devices : 1
    Preferred Minor : 0
	Persistence : Superblock is persistent

	Update Time : Thu Aug  5 09:33:35 2004
	      State : clean, degraded
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 0
      Spare Devices : 0


	Number   Major   Minor   RaidDevice State
	   0      33        1        0      active sync   /dev/hde1
	   1       0        0       -1      removed
	       UUID : 2e078443:42b63ef5:cc179492:aecf0094
	     Events : 0.990424


Well, no change there.  

    jfsnew:/etc/init.d# mdadm /dev/md0 -a /dev/hdg1
    mdadm: hot add failed for /dev/hdg1: Invalid argument

And this just fails.  I get the following error in /var/log/syslog.  

    Aug  5 09:58:09 jfsnew kernel: md: trying to hot-add hdg1 to md0 ... 
    Aug  5 09:58:09 jfsnew kernel: md: could not lock hdg1.
    Aug  5 09:58:09 jfsnew kernel: md: error, md_import_device() returned -16

Which doesn't seem to make any sense.  Can someone tell me what the
heck is going on here?  

Thanks,
John
   John Stoffel - Senior Unix Systems Administrator - Lucent Technologies
	 stoffel@lucent.com - http://www.lucent.com - 978-952-7548



