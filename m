From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: irq timeout: status=0xd0 { Busy }
Date: Thu, 27 Jan 2005 00:13:57 -0500
Message-ID: <200501270512.j0R5C1908897@www.watkins-home.com>
References: <41F7F4F6.2010405@mail.fsix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41F7F4F6.2010405@mail.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: cknowlton@science.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why would you fsck the failed member of a RAID5?
You said "format", please elaborate!

You should verify the disk is readable.

It looks like your disk is bad.  But a read test would be reasonable.

Try this:
dd if=/dev/had of=/dev/null bs=64k

It should complete without errors.  It will do a full read test.
I expect it will fail.

Do you have 2 disks on the same data cable?  If so, can you re-configure so
that each disk has a dedicated data cable?

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Carlos Knowlton
Sent: Wednesday, January 26, 2005 2:52 PM
To: linux-raid@vger.kernel.org
Subject: hda: irq timeout: status=0xd0 { Busy }

Hi

I'm new to this list, but I have a lot of projects that involve RAID and 
Linux.  And consequently, a lot of questions.  (But maybe a few answers 
too :)

I have a 3 disk RAID5 array, and one of the member was recently 
rejected, and I'm trying to get to the bottom of it.  I reformatted the 
failed member, and started an fsck on it.  The fsck came up clean, but 
dmesg pulled up the following error:

"hda: irq timeout: status=0xd0 { Busy }
ide: failed opcode was: 0xb0
hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: drive not ready for command"

Is this a hardware issue, configuration, or driver?

I'm running kernel version 2.6.9-667 (FC3) on a 2.4GHz P4 Celeron.  Here 
more details:
-------------------------------------------------------------------
Dev1 ~]# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 hdc3[2] hdb3[1]
      156376576 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>
-------------------------------------------------------------------
Dev1 ~]# dmesg
...
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
...
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: IC35L080AVVA07-0, ATA DISK drive
hdb: IC35L080AVVA07-0, ATA DISK drive
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: IC35L080AVVA07-0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide2...
ide2: Wait for ready failed before probe !
Probing IDE interface ide3...
ide3: Wait for ready failed before probe !
Probing IDE interface ide4...
ide4: Wait for ready failed before probe !
Probing IDE interface ide5...
ide5: Wait for ready failed before probe !
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, 
UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3
hdb: max request size: 128KiB
hdb: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, 
UDMA(100)
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3
hdc: max request size: 128KiB
hdc: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, 
UDMA(100)
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3
ide-floppy driver 0.99.newide
...
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
...
Freeing unused kernel memory: 184k freed
SCSI subsystem initialized
libata version 1.02 loaded.
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
...
inserting floppy driver for 2.6.9-1.667smp
floppy0: no floppy controllers found
...
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdc3 ...
md:  adding hdc3 ...
md: hdc1 has different UUID to hdc3
md:  adding hdb3 ...
md:  adding hda3 ...
md: created md0
md: bind<hda3>
md: bind<hdb3>
md: bind<hdc3>
md: running: <hdc3><hdb3><hda3>
md: kicking non-fresh hda3 from array!
md: unbind<hda3>
md: export_rdev(hda3)
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  2240.000 MB/sec
raid5: using function: pIII_sse (2240.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device hdc3 operational as raid disk 2
raid5: device hdb3 operational as raid disk 1
raid5: allocated 3162kB for md0
raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 1, o:1, dev:hdb3
 disk 2, o:1, dev:hdc3
md: considering hdc1 ...
md:  adding hdc1 ...
md: md0 already running, cannot run hdc1
md: export_rdev(hdc1)
md: ... autorun DONE.
...
EXT3 FS on hda1, internal journal
SGI XFS with ACLs, security attributes, large block numbers, no debug 
enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem md0
Ending clean XFS mount for filesystem: md0
Adding 128512k swap on /dev/hda2.  Priority:-1 extents:1
...
hda: irq timeout: status=0xd0 { Busy }

ide: failed opcode was: 0xb0
hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }

ide: failed opcode was: unknown
hda: drive not ready for command
----------------------------------------------------------------------------
-

Thanks,

Carlos Knowlton
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

