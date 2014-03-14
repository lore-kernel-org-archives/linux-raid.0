From: Thorsten von Eicken <tve@voneicken.com>
Subject: mapping disk sectors to files
Date: Fri, 14 Mar 2014 06:23:42 +0000
Message-ID: <00000144bf42b0b6-2fe18839-c08d-4c8a-a358-a68135c6d340-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just had a disk in a raid1 mirror set die and that exposed some bad
block on the remaining drive -- ooops! I'd now like to map the bad
blocks to files so I can restore the affected files from backups, but I
can't figure out the mapping. What I've done:
- while I had only one drive, I ran badblocks on the md device, that
gave me a list of bad blocks, I verified that they were indeed bad with
dd, and I used debugfs to map them to files, verified the files gave a
read error, wrote zeroes to the blocks to get the drive to reallocate, done!
- I rebuilt the mirror set with a fresh drive, but that exposed two more
bad blocks, ouch!
- Now I can't run badblocks anymore easily because the second drive will
"cover" for the first one as far as I understand
- I've tried converting sectors to blocks, subtracting partition offset
and data offset, but it's just not working, i.e. I can't get dd to hit
the error when I try

This is the set of bad blocks I'm trying to deal with:
Mar 13 01:12:24 h kernel: [522839.210723] end_request: I/O error, dev
sda, sector 1147023664
Mar 13 01:12:24 h kernel: [522839.211618] ata1: EH complete
Mar 13 01:12:24 h kernel: [522839.211635] md/raid1:md0: sda:
unrecoverable I/O read error for block 1146085632

Mar 13 01:11:49 h kernel: [522804.763467] end_request: I/O error, dev
sda, sector 1147020360
Mar 13 01:11:49 h kernel: [522804.765146] ata1: EH complete
Mar 13 01:11:49 h kernel: [522804.765180] md/raid1:md0: sda:
unrecoverable I/O read error for block 1146082304

Mar 13 01:11:30 h kernel: [522785.944248] end_request: I/O error, dev
sda, sector 1147017056
Mar 13 01:11:30 h kernel: [522785.945926] ata1: EH complete
Mar 13 01:11:30 h kernel: [522785.945961] md/raid1:md0: sda:
unrecoverable I/O read error for block 1146078976

Mar 13 01:09:23 h kernel: [522658.983066] end_request: I/O error, dev
sda, sector 1129050144
Mar 13 01:09:23 h kernel: [522658.984750] ata1: EH complete
Mar 13 01:09:23 h kernel: [522658.984781] md/raid1:md0: sda:
unrecoverable I/O read error for block 1128112128

Mar 13 01:06:44 h kernel: [522499.760134] end_request: I/O error, dev
sda, sector 1098724456
Mar 13 01:06:44 h kernel: [522499.761829] ata1: EH complete
Mar 13 01:06:44 h kernel: [522499.761869] md/raid1:md0: sda:
unrecoverable I/O read error for block 1097786368

The GPT is:
Disk /dev/sda: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): FD188278-C58A-41C7-9943-AD5E94EDF1F8
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 4061 sectors (2.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          409600   199.0 MiB   EF00  EFI System
   2          411648          935935   256.0 MiB   0700  Microsoft basic
data
   3          935936      3907029134   1.8 TiB     FD00  Linux RAID

The md device says:
# mdadm --examine /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1f3118f3:ee5a644b:d8d3df40:8decaa30
           Name : h2:0
  Creation Time : Sun Mar 18 00:37:55 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3906091151 (1862.57 GiB 1999.92 GB)
     Array Size : 1953045575 (1862.57 GiB 1999.92 GB)
  Used Dev Size : 3906091150 (1862.57 GiB 1999.92 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7a87b471:48f6c853:0a5dd5ad:15fa79a4

    Update Time : Thu Mar 13 19:43:14 2014
       Checksum : 1522576c - correct
         Events : 8076588


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

- I'm using an ext4 filesystem and dumpfs says:
First block:              0
Block size:               4096

If I take the bad sector number from the first error message
(1147023664) subtract the partition start (935936) and then divide by 8
(4096 byte blocks) I can get dd to trigger the bad block:
# dd if=/dev/sda3 of=/dev/null bs=4096 count=10 iflag=direct skip=143260966
dd: reading `/dev/sda3': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 15.7246 s, 0.0 kB/s

But I need the block number in the md device so I can map it back to a
file. I've tried various calculations and used dd on the md device but I
see no error in syslog indicating hitting a bad block. Does someone know
how to do the mapping and/or how to fix the situation?

Thanks!


