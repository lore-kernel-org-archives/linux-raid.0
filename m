From: Mark Keisler <grimm26@gmail.com>
Subject: RAID10 failure(s)
Date: Mon, 14 Feb 2011 10:09:07 -0600
Message-ID: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry in advance for the long email :)


I had a RAID10 array set up using 4 WD 1TB caviar black drives (SATA3)
on 64 bit on a 2.6.36 kernel using mdadm 3.1.4.  I noticed last night
that one drive had faulted out of the array.  It had a bunch of errors
like so:

Feb  8 03:39:48 samsara kernel: [41330.835285] ata3.00: exception
Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Feb  8 03:39:48 samsara kernel: [41330.835288] ata3.00: irq_stat 0x40000008
Feb  8 03:39:48 samsara kernel: [41330.835292] ata3.00: failed
command: READ FPDMA QUEUED
Feb  8 03:39:48 samsara kernel: [41330.835297] ata3.00: cmd
60/f8:00:f8:9a:45/00:00:04:00:00/40 tag 0 ncq 126976 in
Feb  8 03:39:48 samsara kernel: [41330.835297]          res
41/40:00:70:9b:45/00:00:04:00:00/40 Emask 0x409 (media error) <F>
Feb  8 03:39:48 samsara kernel: [41330.835300] ata3.00: status: { DRDY ERR }
Feb  8 03:39:48 samsara kernel: [41330.835301] ata3.00: error: { UNC }
Feb  8 03:39:48 samsara kernel: [41330.839776] ata3.00: configured for UDMA/133
Feb  8 03:39:48 samsara kernel: [41330.839788] ata3: EH complete
....

Feb  8 03:39:58 samsara kernel: [41340.423236] sd 2:0:0:0: [sdc]
Unhandled sense code
Feb  8 03:39:58 samsara kernel: [41340.423238] sd 2:0:0:0: [sdc]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Feb  8 03:39:58 samsara kernel: [41340.423240] sd 2:0:0:0: [sdc]
Sense Key : Medium Error [current] [descriptor]
Feb  8 03:39:58 samsara kernel: [41340.423243] Descriptor sense data
with sense descriptors (in hex):
Feb  8 03:39:58 samsara kernel: [41340.423244]         72 03 11 04 00
00 00 0c 00 0a 80 00 00 00 00 00
Feb  8 03:39:58 samsara kernel: [41340.423249]         04 45 9b 70
Feb  8 03:39:58 samsara kernel: [41340.423251] sd 2:0:0:0: [sdc]  Add.
Sense: Unrecovered read error - auto reallocate failed
Feb  8 03:39:58 samsara kernel: [41340.423254] sd 2:0:0:0: [sdc] CDB:
Read(10): 28 00 04 45 9a f8 00 00 f8 00
Feb  8 03:39:58 samsara kernel: [41340.423259] end_request: I/O error,
dev sdc, sector 71670640
Feb  8 03:39:58 samsara kernel: [41340.423262] md/raid10:md0: sdc1:
rescheduling sector 143332600
....
Feb  8 03:40:10 samsara kernel: [41351.940796] md/raid10:md0: read
error corrected (8 sectors at 2168 on sdc1)
Feb  8 03:40:10 samsara kernel: [41351.954972] md/raid10:md0: sdb1:
redirecting sector 143332600 to another mirror

and so on until:
Feb  8 03:55:01 samsara kernel: [42243.609414] md/raid10:md0: sdc1:
Raid device exceeded read_error threshold [cur 21:max 20]
Feb  8 03:55:01 samsara kernel: [42243.609417] md/raid10:md0: sdc1:
Failing raid device
Feb  8 03:55:01 samsara kernel: [42243.609419] md/raid10:md0: Disk
failure on sdc1, disabling device.
Feb  8 03:55:01 samsara kernel: [42243.609420] <1>md/raid10:md0:
Operation continuing on 3 devices.
Feb  8 03:55:01 samsara kernel: [42243.609423] md/raid10:md0: sdb1:
redirecting sector 143163888 to another mirror
Feb  8 03:55:01 samsara kernel: [42243.609650] md/raid10:md0: sdb1:
redirecting sector 143164416 to another mirror
Feb  8 03:55:01 samsara kernel: [42243.610095] md/raid10:md0: sdb1:
redirecting sector 143164664 to another mirror
Feb  8 03:55:01 samsara kernel: [42243.633814] RAID10 conf printout:
Feb  8 03:55:01 samsara kernel: [42243.633817]  --- wd:3 rd:4
Feb  8 03:55:01 samsara kernel: [42243.633820]  disk 0, wo:0, o:1, dev:sdb1
Feb  8 03:55:01 samsara kernel: [42243.633821]  disk 1, wo:1, o:0, dev:sdc1
Feb  8 03:55:01 samsara kernel: [42243.633823]  disk 2, wo:0, o:1, dev:sdd1
Feb  8 03:55:01 samsara kernel: [42243.633824]  disk 3, wo:0, o:1, dev:sde1
Feb  8 03:55:01 samsara kernel: [42243.645880] RAID10 conf printout:
Feb  8 03:55:01 samsara kernel: [42243.645883]  --- wd:3 rd:4
Feb  8 03:55:01 samsara kernel: [42243.645885]  disk 0, wo:0, o:1, dev:sdb1
Feb  8 03:55:01 samsara kernel: [42243.645887]  disk 2, wo:0, o:1, dev:sdd1
Feb  8 03:55:01 samsara kernel: [42243.645888]  disk 3, wo:0, o:1, dev:sde1


This seemed weird as the machine is only a week or two old.  I powered
down to open it up and get the serial number off the drive fro an RMA.
 I powered back up and mdadm had automatically removed the drive from
the RAID.  Fine.  The RAID had already been running on just 3 disks
since the 8th.  For some reason, I thought to add the drive back into
the array to see if it failed out again thinking worst case scenario
I'm back to a degraded RAID10 again.  So I added it back in and did an
mdadm --detail to check on it after a little while and found this:
samsara log # mdadm --detail /dev/md0
/dev/md0:
       Version : 1.2
 Creation Time : Sat Feb  5 22:00:52 2011
    Raid Level : raid10
    Array Size : 1953519104 (1863.02 GiB 2000.40 GB)
 Used Dev Size : 976759552 (931.51 GiB 1000.20 GB)
  Raid Devices : 4
 Total Devices : 4
   Persistence : Superblock is persistent

   Update Time : Mon Feb 14 00:04:46 2011
         State : clean, FAILED, recovering
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
 Spare Devices : 0

        Layout : near=2
    Chunk Size : 256K

 Rebuild Status : 99% complete

          Name : samsara:0  (local to host samsara)
          UUID : 26804ec8:a20a4365:bc7d5b4e:653ade03
        Events : 30348

   Number   Major   Minor   RaidDevice State
      0       8       17        0      faulty spare rebuilding   /dev/sdb1
      1       8       33        1      faulty spare rebuilding   /dev/sdc1
      2       8       49        2      active sync   /dev/sdd1
      3       8       65        3      active sync   /dev/sde1
samsara log # exit

It had faulted drive 0 also during the rebuild.
[ 1177.064359] RAID10 conf printout:
[ 1177.064362]  --- wd:2 rd:4
[ 1177.064365]  disk 0, wo:1, o:0, dev:sdb1
[ 1177.064367]  disk 1, wo:1, o:0, dev:sdc1
[ 1177.064368]  disk 2, wo:0, o:1, dev:sdd1
[ 1177.064370]  disk 3, wo:0, o:1, dev:sde1
[ 1177.073325] RAID10 conf printout:
[ 1177.073328]  --- wd:2 rd:4
[ 1177.073330]  disk 0, wo:1, o:0, dev:sdb1
[ 1177.073332]  disk 2, wo:0, o:1, dev:sdd1
[ 1177.073333]  disk 3, wo:0, o:1, dev:sde1
[ 1177.073340] RAID10 conf printout:
[ 1177.073341]  --- wd:2 rd:4
[ 1177.073342]  disk 0, wo:1, o:0, dev:sdb1
[ 1177.073343]  disk 2, wo:0, o:1, dev:sdd1
[ 1177.073344]  disk 3, wo:0, o:1, dev:sde1
[ 1177.083323] RAID10 conf printout:
[ 1177.083326]  --- wd:2 rd:4
[ 1177.083329]  disk 2, wo:0, o:1, dev:sdd1
[ 1177.083330]  disk 3, wo:0, o:1, dev:sde1


So the RAID ended up being marked "clean, FAILED."  Gee, glad it is
clean at least ;).  I'm wondering wtf went wrong and if it actually
makes sense that I had a double disk failure like that.  I can't even
force it to assemble the raid anymore:
 # mdadm --assemble --verbose --force /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.

Am I totally SOL?  Thanks for any suggestions or things to try.

--
Mark
Tact is the ability to tell a man he has an open mind when he has a
hole in his head.
