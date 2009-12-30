From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 1 Disk added as faulty
Date: Wed, 30 Dec 2009 09:31:12 -0600
Message-ID: <33.F0.07778.7427B3B4@cdptpa-omtalb.mail.rr.com>
References: <20091230195246.46b02a03@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230195246.46b02a03@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Wed, 30 Dec 2009 01:18:32 -0600
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> 
> > 	Oops!  'Sorry, I was on  the wrong server.  The server with the PATA
> > drives also allowed me to add with a -W switch this time, but the logs
> on it
> > show even less:
> 
> :-)
> 
> Can you do:
> 
> mdadm /dev/md1 -f /dev/hda1
> mdadm /dev/md1 -r /dev/hda1
> mdadm -D /dev/md1
> mdadm -E /dev/hda1
> mdadm /dev/md1 -a -W /dev/hda1
> mdadm -D /dev/md1
> mdadm -E /dev/hda1
> 
> and show me all the output along with kernel log messages
> generated at the time.


	Well, like I said, it's working now, but OK.  In the log in the
previous message, that is precisely what I did.  At the command line,
everything looked perfectly normal until I checked the status of the array,
where it showed the devices failed on all three patitions.  In the log, all
it showed were the bind and unbind statements.  'No errors, no status
statements, nothing.  Anyway, here is the output now that it is working:

RAID-Server:/tmp# mdadm /dev/md1 -f /dev/hda1
mdadm: set /dev/hda1 faulty in /dev/md1
RAID-Server:/tmp# mdadm /dev/md1 -r /dev/hda1
mdadm: hot removed /dev/hda1
RAID-Server:/tmp# mdadm -D /dev/md1
/dev/md1:
        Version : 01.00
  Creation Time : Wed Dec 23 23:46:28 2009
     Raid Level : raid1
     Array Size : 401580 (392.23 MiB 411.22 MB)
  Used Dev Size : 401580 (392.23 MiB 411.22 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Dec 30 09:18:58 2009
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : 'RAID-Server':1
           UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
         Events : 218

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8        1        1      active sync   /dev/sda1
RAID-Server:/tmp# mdadm -E /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
           Name : 'RAID-Server':1
  Creation Time : Wed Dec 23 23:46:28 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 803160 (392.23 MiB 411.22 MB)
     Array Size : 803160 (392.23 MiB 411.22 MB)
   Super Offset : 803168 sectors
          State : clean
    Device UUID : 28fa09ed:07bf99e2:e3a3b396:9fe389d3

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Dec 30 07:55:41 2009
       Checksum : 9d6dd6e5 - correct
         Events : 214


    Array Slot : 2 (failed, 1, 0)
   Array State : Uu 1 failed
RAID-Server:/tmp# mdadm /dev/md1 -a -W /dev/hda1
mdadm: re-added /dev/hda1
RAID-Server:/tmp# mdadm -D /dev/md1
/dev/md1:
        Version : 01.00
  Creation Time : Wed Dec 23 23:46:28 2009
     Raid Level : raid1
     Array Size : 401580 (392.23 MiB 411.22 MB)
  Used Dev Size : 401580 (392.23 MiB 411.22 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Dec 30 09:18:58 2009
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : 'RAID-Server':1
           UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
         Events : 226

    Number   Major   Minor   RaidDevice State
       2       3        1        0      active sync writemostly   /dev/hda1
       1       8        1        1      active sync   /dev/sda1
RAID-Server:/tmp# mdadm -E /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
           Name : 'RAID-Server':1
  Creation Time : Wed Dec 23 23:46:28 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 803160 (392.23 MiB 411.22 MB)
     Array Size : 803160 (392.23 MiB 411.22 MB)
   Super Offset : 803168 sectors
          State : clean
    Device UUID : 28fa09ed:07bf99e2:e3a3b396:9fe389d3

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Dec 30 09:18:58 2009
       Checksum : 9d6dea76 - correct
         Events : 226


    Array Slot : 2 (failed, 1, 0)
   Array State : Uu 1 failed


RAID-Server:/tmp# tail -n 80 /var/log/syslog
Dec 30 09:18:58 RAID-Server kernel: [424760.811675] raid1: Disk failure on
hda1, disabling device.
Dec 30 09:18:58 RAID-Server kernel: [424760.811675] raid1: Operation
continuing on 1 devices.
Dec 30 09:18:58 RAID-Server kernel: [424760.818778] RAID1 conf printout:
Dec 30 09:18:58 RAID-Server kernel: [424760.818778]  --- wd:1 rd:2
Dec 30 09:18:58 RAID-Server kernel: [424760.818778]  disk 0, wo:1, o:0,
dev:hda1
Dec 30 09:18:58 RAID-Server kernel: [424760.818778]  disk 1, wo:0, o:1,
dev:sda1
Dec 30 09:18:58 RAID-Server kernel: [424760.839325] RAID1 conf printout:
Dec 30 09:18:58 RAID-Server kernel: [424760.839328]  --- wd:1 rd:2
Dec 30 09:18:58 RAID-Server kernel: [424760.839330]  disk 1, wo:0, o:1,
dev:sda1
Dec 30 09:18:58 RAID-Server kernel: [424760.842763] md: unbind<hda1>
Dec 30 09:18:58 RAID-Server kernel: [424760.842763] md: export_rdev(hda1)
Dec 30 09:18:58 RAID-Server kernel: [424761.251480] md: bind<hda1>
Dec 30 09:18:58 RAID-Server kernel: [424761.272603] RAID1 conf printout:
Dec 30 09:18:58 RAID-Server kernel: [424761.272603]  --- wd:1 rd:2
Dec 30 09:18:58 RAID-Server kernel: [424761.272603]  disk 0, wo:1, o:1,
dev:hda1
Dec 30 09:18:58 RAID-Server kernel: [424761.272603]  disk 1, wo:0, o:1,
dev:sda1
Dec 30 09:18:58 RAID-Server kernel: [424761.275141] md: recovery of RAID
array md1
Dec 30 09:18:58 RAID-Server kernel: [424761.275141] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Dec 30 09:18:58 RAID-Server kernel: [424761.275141] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 30 09:18:58 RAID-Server kernel: [424761.275141] md: using 128k window,
over a total of 401580 blocks.
Dec 30 09:18:58 RAID-Server kernel: [424761.278610] md: md1: recovery done.
Dec 30 09:18:58 RAID-Server kernel: [424761.294051] RAID1 conf printout:
Dec 30 09:18:58 RAID-Server kernel: [424761.294051]  --- wd:2 rd:2
Dec 30 09:18:58 RAID-Server kernel: [424761.294051]  disk 0, wo:0, o:1,
dev:hda1
Dec 30 09:18:58 RAID-Server kernel: [424761.294051]  disk 1, wo:0, o:1,
dev:sda1

