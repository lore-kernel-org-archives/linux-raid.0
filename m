From: "John Madden" <jmadden@ivytech.edu>
Subject: md multipath restart problem
Date: Fri, 10 Jun 2005 17:07:53 -0500 (EST)
Message-ID: <59129.10.0.15.208.1118441273.squirrel@postal2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm connecting to an IBM 6800 SAN via two QLogic 2340's to a single LUN and I've
been wrestling with multipathing to them for about a week now.  "Both" LUNs
are visible as two scsi devices, /dev/sda and /dev/sdb.

So I slap a Linux (0x83) partition on the device (and it is visible through
the "second" lun) and I create the md device:

# ./mdadm --create /dev/md0 --force --level=multipath --raid-disks=2 \
/.dev/scsi/host0/bus0/target0/lun0/part1 \
/.dev/scsi/host1/bus0/target0/lun0/part1
mdadm: array /dev/md0 started.

That can be formatted, mounted, written to, etc., all reliably.  Info:

# dmesg
multipath: array md0 active with 2 out of 2 IO paths

# ./mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun 10 16:07:16 2005
     Raid Level : multipath
     Array Size : 314568640 (299.100 GiB 322.12 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun 10 16:07:16 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : a917893d:4570204d:bcf77929:a2564bef
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sda1
       1       8       65        1      active sync   /dev/sdb1

The config file, switched to devfs names since sda and sdb could move
around:

DEVICE /.dev/scsi/host0/bus0/target0/lun0/part1
/.dev/scsi/host0/bus0/target0/lun0/part1
ARRAY /dev/md0 level=multipath num-devices=2
UUID=a917893d:4570204d:bcf77929:a2564bef
devices=/.dev/scsi/host0/bus0/target0/lun0/part1,/.dev/scsi/host1/bus0/target0/l

And then we reboot.

When the device is brought up the second time (and I don't think a reboot is
even needed), only one of the paths to the storage will be added, the other
failing with "Device or resource busy."

dmesg after boot:
md: md0 stopped.
md: bind<sdb1>
md: export_rdev(sda1)
multipath: array md0 active with 1 out of 2 IO paths

When I stop it manually, then re-activate it:

# ./mdadm -A /dev/md0
mdadm: device 1 in /dev/md0 has wrong state in superblock, but
/.dev/scsi/host1/bus0/target0/lun0/part1 seems ok
mdadm: failed to add /.dev/scsi/host0/bus0/target0/lun0/part1 to /dev/md0:
Device or resource busy
mdadm: /dev/md0 has been started with 1 drive (out of 2).

So I'd guess that something's going wrong there but I have little idea what.
The bad part is that while troubleshooting this, I managed to make any
number of things go wrong, so I'm not even sure anymore if this is the root
of my problem, but it's where I am right now.  Any suggestions?

Thanks,
  John



-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

