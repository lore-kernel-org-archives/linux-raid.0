From: Roman Mamedov <rm@romanrm.net>
Subject: md resync ignoring unreadable sectors
Date: Sun, 8 Feb 2015 02:47:45 +0500
Message-ID: <20150208024745.01b9d3ff@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've got some bad sectors on one drive:

dd: reading `/dev/sdh1': Input/output error
260200+0 records in
260200+0 records out
133222400 bytes (133 MB) copied, 2.97188 s, 44.8 MB/s

[ 3908.350331] ata9.00: exception Emask 0x0 SAct 0x40000 SErr 0x0 action 0x0
[ 3908.350385] ata9.00: irq_stat 0x40000008
[ 3908.350427] ata9.00: failed command: READ FPDMA QUEUED
[ 3908.350474] ata9.00: cmd 60/06:90:6a:00:04/00:00:00:00:00/40 tag 18 ncq 3072 in
[ 3908.350474]          res 51/40:06:6a:00:04/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[ 3908.350628] ata9.00: status: { DRDY ERR }
[ 3908.350669] ata9.00: error: { UNC }
[ 3908.354643] ata9.00: configured for UDMA/133
[ 3908.354664] sd 8:0:0:0: [sdh] Unhandled sense code
[ 3908.354668] sd 8:0:0:0: [sdh]  
[ 3908.354671] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 3908.354674] sd 8:0:0:0: [sdh]  
[ 3908.354677] Sense Key : Medium Error [current] [descriptor]
[ 3908.354681] Descriptor sense data with sense descriptors (in hex):
[ 3908.354683]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3908.354695]         00 04 00 6a 
[ 3908.354701] sd 8:0:0:0: [sdh]  
[ 3908.354705] Add. Sense: Unrecovered read error - auto reallocate failed
[ 3908.354708] sd 8:0:0:0: [sdh] CDB: 
[ 3908.354710] Read(10): 28 00 00 04 00 6a 00 00 06 00
[ 3908.354721] end_request: I/O error, dev sdh, sector 262250
[ 3908.354773] Buffer I/O error on device sdh1, logical block 260202
[ 3908.354825] Buffer I/O error on device sdh1, logical block 260203
[ 3908.354891] Buffer I/O error on device sdh1, logical block 260204
[ 3908.354942] Buffer I/O error on device sdh1, logical block 260205
[ 3908.354992] Buffer I/O error on device sdh1, logical block 260206
[ 3908.355042] Buffer I/O error on device sdh1, logical block 260207
[ 3908.355125] ata9: EH complete

Generally I believe these should go away when overwritten, but how do I
overwrite them? The drive is an md RAID1 member:

/dev/md4:
        Version : 1.2
  Creation Time : Mon May 26 13:40:18 2014
     Raid Level : raid1
     Array Size : 1953379936 (1862.89 GiB 2000.26 GB)
  Used Dev Size : 1953379936 (1862.89 GiB 2000.26 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Feb  8 02:39:58 2015
          State : active 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : natsu.romanrm.net:4  (local to host natsu.romanrm.net)
           UUID : 3b8c3166:073249b5:e1384bd6:4611df90
         Events : 50426

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8      113        1      active sync   /dev/sdh1

I thought I would run a 'check' or 'repair', this will read from both drives,
fail to read from sdh, then try to overwrite the affected areas on sdh. But
nope:

# echo 0 > /sys/block/md4/md/sync_min 
# echo check > /sys/block/md4/md/sync_action 

[ 4059.451036] md: data-check of RAID array md4
[ 4059.451040] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 4059.451042] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 4059.451046] md: using 128k window, over a total of 1953379936k.

This happily proceeds through the supposedly unreadable area:

md4 : active raid1 sdd1[0] sdh1[1]
      1953379936 blocks super 1.2 [2/2] [UU]
      [>....................]  check =  0.0% (1479680/1953379936) finish=1116.8min speed=29128K/sec
      bitmap: 2/8 pages [8KB], 131072KB chunk

at 1.5GB already, while the unreadable sectors are at ~133MB. And no new ATA
errors in dmesg. How is this possible?

If I retry the 'dd' command right now, it fails exactly in the same way as
before (and ATA errors do indeed appear).

-- 
With respect,
Roman
