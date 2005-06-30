From: Sandro Dentella <sandro@e-den.it>
Subject: Hung rebuilding
Date: Thu, 30 Jun 2005 15:45:37 +0200
Message-ID: <20050630134537.GA14145@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for this pretty log mail. there are several different questions
related to the same problem.
	1. stuck rebuilding speed=0K/sec
	2. disk added as spare instead of normal
	3. kernel messages I don't know how to handle

The server of a school had problem this morning, 2 RAID1 arrays got out of
sync. The firsr one was fixed just w/ "mdadm /dev/md2 --add ..." the other
says rebuilding but really hangs:

   md3 : active raid1 ide/host0/bus0/target0/lun0/part7[2] ide/host0/bus1/target0/lun0/part7[1]
	 74340672 blocks [2/1] [_U]
	 [>....................]  recovery =  0.0% (192/74340672) finish=308306.9min speed=0K/sec


Following a similar thread some days ago I used hdparm:

   srv-ornago:~#  hdparm -Tt /dev/hdc

   /dev/hdc:
    Timing cached reads:   1000 MB in  2.00 seconds = 500.00 MB/sec
    Timing buffered disk reads:  172 MB in  3.02 seconds =  56.95 MB/sec
   srv-ornago:~#  hdparm -Tt /dev/hda

   /dev/hda:
    Timing cached reads:   944 MB in  2.00 seconds = 472.00 MB/sec

That seems to me reasonable.
What is strange is the result of mdadm -D:

      srv-ornago:~# mdadm -D /dev/md3
      /dev/md3:
	      Version : 00.90.00
	Creation Time : Wed Dec  8 12:28:15 2004
	   Raid Level : raid1
	   Array Size : 74340672 (70.90 GiB 76.12 GB)
	  Device Size : 74340672 (70.90 GiB 76.12 GB)
	 Raid Devices : 2
	Total Devices : 2
      Preferred Minor : 3
	  Persistence : Superblock is persistent

	  Update Time : Thu Jun 30 12:53:14 2005
		State : dirty, degraded, recovering
       Active Devices : 1
      Working Devices : 2
       Failed Devices : 0
	Spare Devices : 1

       Rebuild Status : 0% complete

		 UUID : 1ea38e0e:050ac659:7e84e367:2d256edd
	       Events : 0.171

	  Number   Major   Minor   RaidDevice State
	     0       0        0        0      faulty removed
	     1      22        7        1      active sync   /dev/ide/host0/bus1/target0/lun0/part7

	     2       3        7        2      spare rebuilding   /dev/ide/host0/bus0/target0/lun0/part7


I added the array w/ "mdadm /dev/md3 --add /dev/ide/host0/bus0/target0/lun0/part7" 
and it become "spare" what did I do wrong?

On /dev/md3 there is a reiserfs filesystem that I know is corrupted (I can't
mount it). I thought to first sync the array and then try to fix the
filesystem. Would it be generally better to do the opposite (so as to keep
the *bad* array as a "backup")?

TYA
sandro
*:-)

PS: now kern.log shows something that may help understanding...:





   Jun 30 14:33:48 srv-ornago kernel: RAID1 conf printout:
   Jun 30 14:33:48 srv-ornago kernel:  --- wd:1 rd:2 nd:2
   Jun 30 14:33:48 srv-ornago kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part7
   Jun 30 14:33:48 srv-ornago kernel:  disk 2, s:1, o:1, n:2 rd:2 us:1 dev:ide/host0/bus0/target0/lun0/part7
   Jun 30 14:33:48 srv-ornago kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel: RAID1 conf printout:
   Jun 30 14:33:48 srv-ornago kernel:  --- wd:1 rd:2 nd:2
   Jun 30 14:33:48 srv-ornago kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part7
   Jun 30 14:33:48 srv-ornago kernel:  disk 2, s:1, o:1, n:2 rd:2 us:1 dev:ide/host0/bus0/target0/lun0/part7
   Jun 30 14:33:48 srv-ornago kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel:  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
   Jun 30 14:33:48 srv-ornago kernel: md: cannot remove active disk ide/host0/bus0/target0/lun0/part7 from md3 ...
   Jun 30 14:40:30 srv-ornago kernel: reiserfs: found format "3.6" with standard journal
   Jun 30 14:40:31 srv-ornago kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
   Jun 30 14:40:31 srv-ornago kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=15584452, sector=4194304
   Jun 30 14:40:31 srv-ornago kernel: end_request: I/O error, dev 03:07 (hda), sector 4194304
   Jun 30 14:40:31 srv-ornago kernel: ide0(3,7):sh-2029: reiserfs read_bitmaps: bitmap block (#524288) reading failed
   Jun 30 14:40:31 srv-ornago kernel: ide0(3,7):sh-2014: reiserfs_read_super: unable to read bitmap
   Jun 30 14:40:33 srv-ornago kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
   Jun 30 14:40:33 srv-ornago kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=16108740, sector=4718592
   Jun 30 14:40:33 srv-ornago kernel: end_request: I/O error, dev 03:07 (hda), sector 4718592


-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
