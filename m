From: rrk <rrk@prairie.lakes.com>
Subject: Raid1 problem can't add remove or mark faulty -- it did work
Date: Sat, 26 Mar 2005 20:36:55 -0600
Message-ID: <42461C47.8090706@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have a strange problem -- can't get a fully funtional 2 drive raid 
back up running-- it may or may not be a drive bios interaction don't 
know. none of the mdadm manage functions will work add remove or mark faulty
i have purged and reinstalled the mdadm package twice.

below is all the info i could think  of .   the kernel is 2.6.10 
patched  -- stock kanotix
either drive will boot and the behavior is the same no matter which one 
is active




@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
current installed version of mdadm

mdadm:
  Installed: 1.9.0-2
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
hda partition table

Disk geometry for /dev/hda: 0.000-152627.835 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031 151629.125  primary   ext3        raid
2     151629.126 152625.344  primary   linux-swap
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
hdc partition table

Disk geometry for /dev/hdc: 0.000-152627.835 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031 151629.125  primary   ext3        raid
2     151629.126 152625.344  primary


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
examine /dev/hda1

root@crm_svr:/home/rob# mdadm -E /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : bcbf4556:4aba6daf:5661e4a2:32fcc1db
  Creation Time : Mon Mar 21 17:22:34 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Sat Mar 26 19:33:08 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : c7caacc2 - correct
         Events : 0.17321


      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1

   0     0       3        1        0      active sync   /dev/hda1
   1     1       0        0        1      faulty removed

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
examine /dev/hdc1

root@crm_svr:/home/rob# mdadm -E /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : bcbf4556:4aba6daf:5661e4a2:32fcc1db
  Creation Time : Mon Mar 21 17:22:34 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Sat Mar 26 20:23:04 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c7cabae4 - correct
         Events : 0.17613


      Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1

   0     0       0        0        0      removed
   1     1      22        1        1      active sync   /dev/hdc1

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
what happens when i try a hot add remove or set faulty
 
root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hda1
mdadm: hot add failed for /dev/hda1: Invalid argument
root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hdc1
mdadm: hot add failed for /dev/hdc1: Invalid argument

root@crm_svr:/home/rob# mdadm /dev/md0 -r /dev/hda1
mdadm: hot remove failed for /dev/hda1: No such device or address
root@crm_svr:/home/rob# mdadm /dev/md0 -r /dev/hdc1
mdadm: hot remove failed for /dev/hdc1: Device or resource busy

root@crm_svr:/home/rob# mdadm /dev/md0 -f /dev/hda1
mdadm: set device faulty failed for /dev/hda1:  No such device
root@crm_svr:/home/rob# mdadm /dev/md0 -f /dev/hdc1
mdadm: set /dev/hdc1 faulty in /dev/md0


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
boot info from dmesg


Probing IDE interface ide0...
hda: WDC WD1600JB-00GVA0, ATA DISK drive
hdb: SAMSUNG CD-ROM SH-152A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: WDC WD1600JB-00GVA0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15

hda: max request size: 1024KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63, 
UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2
hdc: max request size: 1024KiB
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63, 
UDMA(100)
hdc: cache flushes supported
 hdc: hdc1 hdc2
hdb: ATAPI 52X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20


md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid10 personality registered as nr 9
md: raid5 personality registered as nr 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  1448.000 MB/sec
raid5: using function: pIII_sse (1448.000 MB/sec)
raid6: int32x1    621 MB/s
raid6: int32x2    777 MB/s
raid6: int32x4    468 MB/s
raid6: int32x8    457 MB/s
raid6: mmxx1     1363 MB/s
raid6: mmxx2     2484 MB/s
raid6: sse1x1    1246 MB/s
raid6: sse1x2    2140 MB/s
raid6: using algorithm sse1x2 (2140 MB/s)
md: raid6 personality registered as nr 8
md: multipath personality registered as nr 7
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
device-mapper: 4.3.0-ioctl (2004-09-30) initialised: dm-devel@redhat.com

md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdc1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdc1>
md: running: <hdc1><hda1>
md: kicking non-fresh hda1 from array!
md: unbind<hda1>
md: export_rdev(hda1)
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 276k freed
kjournald starting.  Commit interval 5 seconds
Warning: /proc/ide/hd?/settings interface is obsolete, and will be 
removed soon!
EXT3 FS on md0, internal journal
Adding 1020116k swap on /dev/hda2.  Priority:-1 extents:1
EXT3 FS on md0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
reiser4[mount(1122)]: _init_read_super 
(fs/reiser4/init_super.c:198)[nikita-2608]:
WARNING: hdc2: wrong master super block magic.
NTFS driver 2.1.22 [Flags: R/W MODULE].









