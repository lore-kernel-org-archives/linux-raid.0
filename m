From: "Jeff Breidenbach" <jeff@jab.org>
Subject: unable to remove failed drive
Date: Fri, 7 Dec 2007 17:55:19 -0800
Message-ID: <e03b90ae0712071755l1defdcaft511b2c41a10fe838@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

... and all access to array hangs indefinitely, resulting in unkillable zombie
processes. Have to hard reboot the machine. Any thoughts on the matter?

===

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sde1[6](F) sdg1[1] sdb1[4] sdd1[3] sdc1[2]
      488383936 blocks [6/4] [_UUUU_]

unused devices: <none>

# mdadm --fail /dev/md1 /dev/sde1
mdadm: set /dev/sde1 faulty in /dev/md1

# mdadm --remove /dev/md1 /dev/sde1
mdadm: hot remove failed for /dev/sde1: Device or resource busy

# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Sun Dec 25 16:12:34 2005
     Raid Level : raid1
     Array Size : 488383936 (465.76 GiB 500.11 GB)
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Dec  7 11:37:46 2007
          State : active, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

           UUID : f3ee6aa3:2f1d5767:f443dfc0:c23e80af
         Events : 0.22331500

    Number   Major   Minor   RaidDevice State
       0       0        0        -      removed
       1       8       97        1      active sync   /dev/sdg1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       17        4      active sync   /dev/sdb1
       5       0        0        -      removed

       6       8       65        0      faulty   /dev/sde1


# dmesg
sd 4:0:0:0: SCSI error: return code = 0x8000002
sde: Current: sense key: Aborted Command
    Additional sense: Scsi parity error
end_request: I/O error, dev sde, sector 594882271
raid1: sde1: rescheduling sector 594882208
ata5: command timeout
ata5: translated ATA stat/err 0xff/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata5: status=0xff { Busy }
sd 4:0:0:0: SCSI error: return code = 0x8000002
sde: Current: sense key: Aborted Command
    Additional sense: Scsi parity error
end_request: I/O error, dev sde, sector 528737607
raid1: sde1: rescheduling sector 528737544
ata5: command timeout
ata5: translated ATA stat/err 0xff/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata5: status=0xff { Busy }
sd 4:0:0:0: SCSI error: return code = 0x8000002
sde: Current: sense key: Aborted Command
    Additional sense: Scsi parity error
end_request: I/O error, dev sde, sector 814377071

[...]

md: cannot remove active disk sde1 from md1 ...
md: could not bd_claim sde1.
md: error, md_import_device() returned -16

# cat /proc/version
Linux version 2.6.17-2-amd64 (Debian 2.6.17-7) (waldi@debian.org) (gcc
version 4.1.2 20060814 (prerelease) (Debian 4.1.1-11)) #1 SMP Thu Aug
24 16:13:57 UTC 2006
