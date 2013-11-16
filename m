From: kustep <kustep@web.de>
Subject: multiple device failure of mdadm array
Date: Sat, 16 Nov 2013 17:55:19 +0100
Message-ID: <5287A377.6020504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

several hard drives of my raid assembly missed out almost at the same
time yesterday. Besides that I would like to know how this can happen
(its apperantly some bus problem, that should be avoided in the future,
thats why I think it might be interesting for developers and send it to
this mailing list), I also appreciate any advice how to rebuild the
array. I am using Arch linux with mdadm v3.3 (3rd September 2013).

/dev/sdk missed out yesterday morning and the raid continued happily (as
stated by journalctl):

Nov 15 10:49:24 pc kernel: ata16.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
Nov 15 10:49:24 pc kernel: ata16.00: failed command: FLUSH CACHE EXT
Nov 15 10:49:24 pc kernel: ata16.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
                                                         res
40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
Nov 15 10:49:24 pc kernel: ata16.00: status: { DRDY }
Nov 15 10:49:24 pc kernel: ata16: hard resetting link

endig up so that sdk1 is removed, and sdg1 (hot spare before) takes over
slot 6 in the Array:

Nov 15 10:50:11 pc kernel: RAID conf printout:
Nov 15 10:50:11 pc kernel:  --- level:6 rd:11 wd:10
Nov 15 10:50:11 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 10:50:11 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 10:50:11 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 10:50:11 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 10:50:11 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 10:50:11 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 10:50:11 pc kernel:  disk 6, o:1, dev:sdg1
Nov 15 10:50:11 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 10:50:11 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 10:50:11 pc kernel:  disk 9, o:1, dev:sdi1
Nov 15 10:50:11 pc kernel:  disk 10, o:1, dev:sdh1

Starting 7 minutes later, every 10 minutes the following error is raised
for Disk with Serial number Z2F0T2LR which is actually /dev/sdk (as
smartctl tells me now after restart):

Nov 15 10:57:36 pc udisksd[19583]: Error performing housekeeping for
drive /org/freedesktop/UDisks2/drives/ST2000DM001_1CH164_Z2F0T2LR: Error
updating SMART data: sk_disk_check_sleep_mode: Operation not supported
(udisks-error-quark, 0)

2.5 Hours later a similar (as above  + housekeeping smart data) error
occurs for Z1E3Y17X (/dev/sdh):

Nov 15 13:27:36 pc udisksd[19583]: Error performing housekeeping for
drive /org/freedesktop/UDisks2/drives/ST2000DM001_1CH164_Z2F0T2LR: Error
updating SMART data: sk_disk_check_sleep_mode: Operation not supported
(udisks-error-quark, 0)
Nov 15 13:27:44 pc kernel: ata9.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
Nov 15 13:27:44 pc kernel: ata9.00: failed command: IDENTIFY DEVICE
Nov 15 13:27:44 pc kernel: ata9.00: cmd
ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
                                                         res
40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
Nov 15 13:27:44 pc kernel: ata9.00: status: { DRDY }
Nov 15 13:27:44 pc kernel: ata9: hard resetting link
Nov 15 13:27:50 pc kernel: ata9: link is slow to respond, please be
patient (ready=0)
Nov 15 13:27:54 pc kernel: ata9: COMRESET failed (errno=-16)
Nov 15 13:27:54 pc kernel: ata9: hard resetting link
Nov 15 13:28:00 pc kernel: ata9: link is slow to respond, please be
patient (ready=0)
Nov 15 13:28:05 pc kernel: ata9: COMRESET failed (errno=-16)
Nov 15 13:28:05 pc kernel: ata9: hard resetting link
Nov 15 13:28:10 pc kernel: ata9: link is slow to respond, please be
patient (ready=0)
Nov 15 13:28:40 pc kernel: ata9: COMRESET failed (errno=-16)
Nov 15 13:28:40 pc kernel: ata9: limiting SATA link speed to 3.0 Gbps
Nov 15 13:28:40 pc kernel: ata9: hard resetting link
Nov 15 13:28:45 pc udisksd[19583]: Error performing housekeeping for
drive /org/freedesktop/UDisks2/drives/ST2000DM001_1CH164_Z1E3Y17X: Error
updating SMART data: sk_disk_check_sleep_mode: Input/output error
(udisks-error-quark, 0)
Nov 15 13:28:45 pc kernel: ata9: COMRESET failed (errno=-16)
Nov 15 13:28:45 pc kernel: ata9: reset failed, giving up
Nov 15 13:28:45 pc kernel: ata9.00: disabled
Nov 15 13:28:45 pc kernel: ata9: EH complete
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] Unhandled error code
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] 
Nov 15 13:28:45 pc kernel: Result: hostbyte=0x04 driverbyte=0x00
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] CDB:
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] Unhandled error code
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] 
Nov 15 13:28:45 pc kernel: Result: hostbyte=0x04 driverbyte=0x00
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] CDB:
Nov 15 13:28:45 pc kernel: cdb[0]=0x28:
Nov 15 13:28:45 pc kernel: cdb[0]=0x28
Nov 15 13:28:45 pc kernel: :
Nov 15 13:28:45 pc kernel:  28
Nov 15 13:28:45 pc kernel:  00
Nov 15 13:28:45 pc kernel:  2b
Nov 15 13:28:45 pc kernel:  0f
Nov 15 13:28:45 pc kernel:  0a
Nov 15 13:28:45 pc kernel:  8b
Nov 15 13:28:45 pc kernel:  00
Nov 15 13:28:45 pc kernel:  02
Nov 15 13:28:45 pc kernel:  00
Nov 15 13:28:45 pc kernel:  00
Nov 15 13:28:45 pc kernel: Nov 15 13:28:45 pc kernel:
blk_update_request: 141 callbacks suppressed
Nov 15 13:28:45 pc kernel: end_request: I/O error, dev sdh, sector 722406027
Nov 15 13:28:45 pc kernel:  28 00 2b 0f 06 8b 00 04 00 00
Nov 15 13:28:45 pc kernel: end_request: I/O error, dev sdh, sector 722405003
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] Unhandled error code
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] 
Nov 15 13:28:45 pc kernel: Result: hostbyte=0x04 driverbyte=0x00
Nov 15 13:28:45 pc kernel: sd 8:0:0:0: [sdh] CDB:
Nov 15 13:28:45 pc kernel: cdb[0]=0x2a: 2a 00 00 00 08 08 00 00 01 00
Nov 15 13:28:45 pc kernel: end_request: I/O error, dev sdh, sector 2056
Nov 15 13:28:45 pc kernel: end_request: I/O error, dev sdh, sector 2056
Nov 15 13:28:45 pc kernel: md: super_written gets error=-5, uptodate=0
Nov 15 13:28:45 pc kernel: md/raid:md127: Disk failure on sdh1,
disabling device.
                                                md/raid:md127: Operation
continuing on 9 devices.

and then just 4 seconds (!) later for ata7 and ata10, resulting in:

Nov 15 13:29:39 pc kernel: md: super_written gets error=-5, uptodate=0
Nov 15 13:29:39 pc kernel: md: super_written gets error=-5, uptodate=0
Nov 15 13:29:39 pc kernel: md/raid:md127: Disk failure on sdi1,
disabling device.
                                                md/raid:md127: Operation
continuing on 8 devices.
Nov 15 13:29:39 pc kernel: md/raid:md127: Disk failure on sdg1,
disabling device.
                                                md/raid:md127: Operation
continuing on 8 devices.
Nov 15 13:29:40 pc kernel: md: md127: recovery done.
Nov 15 13:29:40 pc kernel: XFS (md127): metadata I/O error: block 0x0
("xfs_buf_iodone_callbacks") error 5 numblks 8
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 6, o:0, dev:sdg1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 13:29:40 pc kernel:  disk 9, o:0, dev:sdi1
Nov 15 13:29:40 pc kernel:  disk 10, o:0, dev:sdh1
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 13:29:40 pc kernel:  disk 9, o:0, dev:sdi1
Nov 15 13:29:40 pc kernel:  disk 10, o:0, dev:sdh1
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 13:29:40 pc kernel:  disk 9, o:0, dev:sdi1
Nov 15 13:29:40 pc kernel:  disk 10, o:0, dev:sdh1
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 13:29:40 pc kernel:  disk 10, o:0, dev:sdh1
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1
Nov 15 13:29:40 pc kernel:  disk 10, o:0, dev:sdh1
Nov 15 13:29:40 pc kernel: RAID conf printout:
Nov 15 13:29:40 pc kernel:  --- level:6 rd:11 wd:8
Nov 15 13:29:40 pc kernel:  disk 0, o:1, dev:sdc1
Nov 15 13:29:40 pc kernel:  disk 1, o:1, dev:sdd1
Nov 15 13:29:40 pc kernel:  disk 2, o:1, dev:sde1
Nov 15 13:29:40 pc kernel:  disk 3, o:1, dev:sdf1
Nov 15 13:29:40 pc kernel:  disk 4, o:1, dev:sdm1
Nov 15 13:29:40 pc kernel:  disk 5, o:1, dev:sdb1
Nov 15 13:29:40 pc kernel:  disk 7, o:1, dev:sdj1
Nov 15 13:29:40 pc kernel:  disk 8, o:1, dev:sdl1


saying that the raid device is now running with less devices than
needed. (How is this possible?) At that time the computer froze and the
log file shows massive XFS File System I/O Errors (of course, the raid
was mounted as /home).

After Restarting i was able to access ALL devices on a block device
level without any problems and smartctl worked fine, although the
logfile says, that the inital problem was to read out the smart data
from /dev/sdk.
Assembling the Array using --force did not work

[root@pc /]# mdadm --assemble --force /dev/md127 /dev/sd[b-m]1
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
mdadm: /dev/sde1 is busy - skipping
mdadm: /dev/sdf1 is busy - skipping
mdadm: /dev/sdg1 is busy - skipping
mdadm: /dev/sdh1 is busy - skipping
mdadm: /dev/sdi1 is busy - skipping
mdadm: /dev/sdj1 is busy - skipping
mdadm: /dev/sdk1 is busy - skipping
mdadm: /dev/sdl1 is busy - skipping
mdadm: /dev/sdm1 is busy - skipping
[root@pc /]# mdadm --stop /dev/md127
mdadm: stopped /dev/md127
[root@pc /]# mdadm --assemble --force /dev/md127 /dev/sd[b-m]1
mdadm: /dev/md127 assembled from 8 drives - not enough to start the array.

As I understood the only option left now is to recreate the array. Since
I do not know which defaults have changed, I need to specify all
possible options. Did miss one in the following example, that I would
try next:

# mdadm --create --assume-clean --raid-devices=11 --chunk=256KB
--level=6 --layout=left-symetric  --metadata=1.2 /dev/md0
/dev/sd[cdefmb]1 missing /dev/sd[jl]1 missing /dev/sdh1

Is this really the last option now? And if, is there any way, that mdadm
autodetects at least the order of the devices or anything else from the
superblock that is still there. In principle I dont need a new raid, the
superblock still knows how to connect 8 of those devices. Is there a way
to use this information instead of overwriting it? Maybe from some
config file for the raid, e.g. is 'mdadm --create --assume-clean
--config=/etc/mdadm.conf' valid? The Data is very important and the
RAID_Recovery Wiki page told me to ask if I am in doubt. So I do.

Any help is greatly appreciated!

Stephan

Here is the full output for all drives of mdadm --examine (oh and i also
coudnt find what the meaning of "Feature Map" is.  it is 0x2 for sdg1
and 0x0 otherwise):


/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=197632 sectors
          State : active
    Device UUID : a532a892:fde5a520:4cbd1577:a227eebf

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : dcf6f0a6 - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 5
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906572288 (1862.80 GiB 2000.17 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=5120 sectors
          State : clean
    Device UUID : 898f8502:137f3552:ed82094d:e166b59d

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : 321bfb7a - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906572288 (1862.80 GiB 2000.17 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=5120 sectors
          State : active
    Device UUID : 08b6bdfc:0acac7b9:ca27c761:e3af8244

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : 4f715ad1 - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 1
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906572288 (1862.80 GiB 2000.17 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=5120 sectors
          State : active
    Device UUID : 6a4cd1fc:eddb246c:9f65eced:92e0446e

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : b7c9719b - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 2
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906572288 (1862.80 GiB 2000.17 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=5120 sectors
          State : active
    Device UUID : db86a600:0b13430e:6fd570c0:758deb03

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : c5e7ffdd - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 3
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
Recovery Offset : 712278403 sectors
   Unused Space : before=257448 sectors, after=197632 sectors
          State : clean
    Device UUID : 8b08e44f:f40f6777:a49af747:a4f0e3d3

    Update Time : Fri Nov 15 13:27:33 2013
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 52183d - correct
         Events : 106513

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 6
   Array State : AAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257448 sectors, after=197632 sectors
          State : clean
    Device UUID : 74ae18d7:d0643097:9f048e77:0aa1ae2e

    Update Time : Fri Nov 15 13:27:33 2013
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 73cabdf - correct
         Events : 106513

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 10
   Array State : AAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257448 sectors, after=197632 sectors
          State : clean
    Device UUID : d61bef09:01313dfb:9fa45866:ebf6601d

    Update Time : Fri Nov 15 13:27:33 2013
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 7b9cdb53 - correct
         Events : 106513

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 9
   Array State : AAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=197632 sectors
          State : active
    Device UUID : b5c50f96:0aaf64ca:1b4324a3:00a29e1b

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : 11dc4cf2 - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 7
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=197632 sectors
          State : clean
    Device UUID : 69561cf6:11c77488:9070fd3f:fa95ddd9

    Update Time : Fri Nov 15 10:48:11 2013
       Checksum : 8b1ae616 - correct
         Events : 103637

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 6
   Array State : AAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=197632 sectors
          State : active
    Device UUID : 73210e1d:b87a37b1:3f80ead1:f06265d8

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : 6b3a7274 - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 8
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d5863af4:8a1b9505:c35f4a00:8667c808
           Name : archiso:0
  Creation Time : Wed Sep 19 19:17:25 2012
     Raid Level : raid6
   Raid Devices : 11

 Avail Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Array Size : 17579572992 (16765.19 GiB 18001.48 GB)
  Used Dev Size : 3906571776 (1862.80 GiB 2000.16 GB)
    Data Offset : 257536 sectors
   Super Offset : 8 sectors
   Unused Space : before=257456 sectors, after=197632 sectors
          State : active
    Device UUID : 9322a9d3:28c0c946:e3567fb6:7bc2f9b9

    Update Time : Fri Nov 15 13:29:40 2013
       Checksum : 7d90ef2f - correct
         Events : 106518

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 4
   Array State : AAAAAA.AA.. ('A' == active, '.' == missing, 'R' ==
replacing)




