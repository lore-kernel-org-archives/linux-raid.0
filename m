From: bernd@rhm.de
Subject: Problems while replacing a disk in RAID1
Date: Fri, 21 Jan 2005 17:53:15 +0100 (MEZ)
Message-ID: <200501211653.RAA05778@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

sorry if the problems described here are off-topic. But they follow a disk 
failure of an RAID1 array if the broken disk has to be replaced online. May 
be it's more a SCSI problem, if so please let me know...

We are using a simple RAID1 configuration (SuSE 9.2 prof. Kernel 2.6.10):

 - 2 SCSI controllers (adaptec 7902):
   two disks (sda/1.0.0.0 and sdb/1.0.4.0) on controller 1
   one disk (sdc/2.0.8.0) on controller 2

 - 3 SCSI disks (SCA), two working (sda/sdc), one spare (sdb).

 - /dev/md0 is swap (sda1, sdc1) spare is sdb1
   /dev/md1 is root (sda2, sdc2) spare is sdb2

   Output from cat /proc/mdstat:
       Personalities : [raid1] 
       md1 : active raid1 sdc2[1] sdb2[2] sda2[0]
             131588288 blocks [2/2] [UU]
       md0 : active raid1 sdc1[1] sdb1[2] sda1[0]
             12064704 blocks [2/2] [UU]
       unused devices: <none>

   Output from mdadm --detail /dev/md1 (/dev/md0 looks similar):
       /dev/md1:
               Version : 00.90.01
         Creation Time : Thu Dec 23 20:31:59 2004
            Raid Level : raid1
            Array Size : 131588288 (125.49 GiB 134.75 GB)
           Device Size : 131588288 (125.49 GiB 134.75 GB)
          Raid Devices : 2
         Total Devices : 3
       Preferred Minor : 1
           Persistence : Superblock is persistent
       
           Update Time : Fri Jan  7 19:07:54 2005
                 State : clean
        Active Devices : 2
       Working Devices : 3
        Failed Devices : 0
         Spare Devices : 1
       
           Number   Major   Minor   RaidDevice State
              0       8        2        0      active sync   /dev/sda2
              1       8       34        1      active sync   /dev/sdc2
              2       8       18       -1      spare   /dev/sdb2
                  UUID : 3f75a816:ea0cb9a4:cddc9187:cbb64753
                Events : 0.556954

If a disk fails with 2.4.x the situation was clear and our procedures for
handling this worked fine in the past. With 2.6.10 the following happens:

 1) if disk sda fails (pulled of off the box) then syncing of partition
    sdc2 (root) against spare sdb2 starts immediately, fine! But the swap
    partition is not synced, even it's accessed (dd if=dev/md0...). We see
    lots of the following errors in the log but the partition stays ok:

     linux kernel: SCSI error : <1 0 0 0> return code = 0x10000
     linux kernel: end_request: I/O error, dev sda, sector 24129477
     linux kernel: Buffer I/O error on device sda1, logical block 24129414

      array md0 looks not like expected:
      Number   Major   Minor   RaidDevice State
         0       8        1        0      active sync   /dev/sda1
         1       8       33        1      active sync   /dev/sdc1
         2       8       17       -1      spare   /dev/sdb1

      array md1 looks like expected, sdc2 is synced:
      Number   Major   Minor   RaidDevice State
         0       8       18        0      active sync   /dev/sdb2
         1       8       34        1      active sync   /dev/sdc2
         2       8        2       -1      faulty   /dev/sda2

    May be dd isn't the right tool to force a degration of an array?
    Anyway, mdadm -f /dev/md0 /dev/sda1 solves the situation...

 2) After everything is synced, disk sdb and sdc are the working disks, 
    sda is faulty, fine. The procedur for replacing sda can take place:

   a) Remove the broken disk from the system:

      echo "scsi remove-single-disk 1 0 0 0" >/proc/scsi/scsi 
      !! This removes the device-files sda, sda1, sda2 too, which is
         different compared to 2.4.x, why? Is this done by all this
         SuSEplugger oder hotplug tools? The device files don't come
         back even not after reboot. So good old mknod has to be used.

   b) Insert a new disk and spin it up:
      echo "scsi add-single-disk 1 0 0 0" >/proc/scsi/scsi 
      It gets the device-file /dev/sdd, because sda was removed before.

      And now, while the disk spins up, the working disk sdb on the same 
      controller is set faulty!!!! From now the array consists of only 
      one working disk sdc.
      
      Why is disk sdb offlined, too? Is it a controller or driver 
      problem (remember, same Box with 2.4.x works ok). I have appended
      the contents of the log for this at the end of this mail, it's 
      a little bit longer, sorry. 

   c) Well, the situation can be fixed by use of some mdadm -a/-f/-r 
      commands given in the right order including the necessary syncs.
      After that the working disks are sdd/1.0.0.0 (before sda) and
      sdc/2.0.8.0, the spare is sdb/1.0.4.0.

   d) Another problem shows up when running lilo while a sync is in 
      progress. This problem disappears when the array is ok, lilo then 
      writes to all three disks of the array as expected. I googled
      around for this problem but the cases described aren't related
      to RAID. What says 'unnamed device 0x000' in the last line of 
      the lilo output:

        LILO version 22.3.4, Copyright (C) 1992-1998 Werner Almesberger
        Development beyond version 21 Copyright (C) 1999-2002 John Coffman
        Released 01-Nov-2002 and compiled at 20:49:59 on Oct  4 2004.

        Warning: using BIOS device code 0x80 for RAID boot blocks
        Reading boot sector from /dev/sdb
        Warning: /dev/sdb is not on the first disk
        Fatal: Trying to map files from unnamed device 0x0000 (NFS ?)

Summary:
  Starting with 2.6.10 the kernel survives a disk failure, fine! But the
  online replacement of a broken disk is a little bit harder compared to
  2.4.x which ends up in the following three questions:

  1) why is the swap-partition not detected as faulty when accessed with
     one partition gone?

  2) why are the device-files sda, sda1, sda2 removed when removing the 
     broken disk and why do they never come back, even not after reboot?

  3) why is a disk on the same controller declared as faulty if another
     disk is inserted in any slot of this controller? The system should
     handle this as before. It's not ok to detect a disk failure on all
     disks of that controller setting all arrays with a mirrored partition
     on that controler into degraded mode.

  4) What says tho message from lilo:
        Fatal: Trying to map files from unnamed device 0x0000 (NFS ?)

Thanks in advance for your help.
Bernd Rieke

Contents of the log for Step 2) b):
-----------------------------------
Jan  7 21:43:18 linux kernel:   scsi1: ILLEGAL_PHASE 0x80
Jan  7 21:43:18 linux kernel: (scsi1:A:0:0): Abort Message Sent
Jan  7 21:43:52 linux kernel: scsi1:0:0:0: Attempting to abort cmd f6c07080: 0x12 0x0 0x0 0x0 0x24 0x0
Jan  7 21:43:52 linux kernel: scsi1: At time of recovery, card was not paused
Jan  7 21:43:52 linux kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jan  7 21:43:52 linux kernel: scsi1: Dumping Card State at program address 0x1ae Mode 0x11
Jan  7 21:43:52 linux kernel: Card was paused
Jan  7 21:43:52 linux kernel: HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
Jan  7 21:43:52 linux kernel: SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
Jan  7 21:43:52 linux kernel: SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
Jan  7 21:43:52 linux kernel: LASTPHASE[0xa0]:(P_MESGOUT) SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
Jan  7 21:43:52 linux kernel: SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
Jan  7 21:43:52 linux kernel: SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x8]:(BUSFREE) 
Jan  7 21:43:52 linux kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) 
Jan  7 21:43:52 linux kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
Jan  7 21:43:52 linux kernel: LQOSTAT1[0x0] LQOSTAT2[0x0] 
Jan  7 21:43:52 linux kernel: 
Jan  7 21:43:52 linux kernel: SCB Count = 32 CMDS_PENDING = 2 LASTSCB 0x11 CURRSCB 0x11 NEXTSCB 0xff02
Jan  7 21:43:52 linux kernel: qinstart = 52611 qinfifonext = 52612
Jan  7 21:43:52 linux kernel: QINFIFO: 0x1b
Jan  7 21:43:52 linux kernel: WAITING_TID_QUEUES:
Jan  7 21:43:52 linux kernel: Pending list:
Jan  7 21:43:52 linux kernel:  27 FIFO_USE[0x0] SCB_CONTROL[0x68]:(STATUS_RCVD|TAG_ENB|DISCENB) 
Jan  7 21:43:52 linux kernel: SCB_SCSIID[0x47] 
Jan  7 21:43:52 linux kernel:  17 FIFO_USE[0x0] SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x7] 
Jan  7 21:43:52 linux kernel: Total 2
Jan  7 21:43:52 linux kernel: Kernel Free SCB list: 10 11 6 25 31 18 13 28 22 20 4 8 21 2 26 30 12 23 14 9 24 3 16 5 0 1 7 15 29 19 
Jan  7 21:43:52 linux kernel: Sequencer Complete DMA-inprog list: 
Jan  7 21:43:52 linux kernel: Sequencer Complete list: 
Jan  7 21:43:52 linux kernel: Sequencer DMA-Up and Complete list: 
Jan  7 21:43:52 linux kernel: 
Jan  7 21:43:52 linux kernel: scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x11
Jan  7 21:43:52 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:43:52 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:43:52 linux kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
Jan  7 21:43:52 linux kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
Jan  7 21:43:52 linux kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0] 
Jan  7 21:43:52 linux kernel: scsi1: FIFO1 Active, LONGJMP == 0x8278, SCB 0x11
Jan  7 21:43:52 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:43:52 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:43:52 linux kernel: SG_CACHE_SHADOW[0x3]:(LAST_SEG_DONE|LAST_SEG) SG_STATE[0x0] 
Jan  7 21:43:52 linux kernel: DFFSXFRCTL[0x0] SOFFCNT[0x0] MDFFSTAT[0x14]:(DLZERO|LASTSDONE) 
Jan  7 21:43:52 linux kernel: SHADDR = 0x06, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
Jan  7 21:43:52 linux kernel: CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
Jan  7 21:43:52 linux kernel: LQIN: 0x55 0x3c 0x0 0x11 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Jan  7 21:43:52 linux kernel: scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
Jan  7 21:43:52 linux kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Jan  7 21:43:52 linux kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
Jan  7 21:43:52 linux kernel: CCSCBCTL[0x4]:(CCSCBDIR) 
Jan  7 21:43:52 linux kernel: scsi1: REG0 == 0x60, SINDEX = 0x1ff, DINDEX = 0x102
Jan  7 21:43:52 linux kernel: scsi1: SCBPTR == 0x11, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xfff9
Jan  7 21:43:52 linux kernel: CDB 0 0 0 0 0 0
Jan  7 21:43:52 linux kernel: STACK: 0x125 0x125 0x125 0x125 0x0 0x25f 0x241 0xa7
Jan  7 21:43:52 linux kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jan  7 21:43:52 linux kernel: DevQ(0:0:0): 0 waiting
Jan  7 21:43:52 linux kernel: DevQ(0:4:0): 0 waiting
Jan  7 21:43:52 linux kernel: DevQ(0:6:0): 0 waiting
Jan  7 21:43:52 linux kernel: scsi1:0:0:0: Device is active, asserting ATN
Jan  7 21:43:52 linux kernel: Recovery code sleeping
Jan  7 21:43:57 linux kernel: Recovery code awake
Jan  7 21:43:57 linux kernel: Timer Expired
Jan  7 21:43:57 linux kernel: scsi1:0:4:0: Attempting to abort cmd f6c48680: 0x2a 0x0 0x11 0x1f 0xf1 0xde 0x0 0x0 0x8 0x0
Jan  7 21:43:57 linux kernel: scsi1: At time of recovery, card was not paused
Jan  7 21:43:57 linux kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jan  7 21:43:57 linux kernel: scsi1: Dumping Card State at program address 0x1ae Mode 0x11
Jan  7 21:43:57 linux kernel: Card was paused
Jan  7 21:43:57 linux kernel: HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
Jan  7 21:43:57 linux kernel: SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
Jan  7 21:43:57 linux kernel: SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
Jan  7 21:43:57 linux kernel: LASTPHASE[0xa0]:(P_MESGOUT) SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
Jan  7 21:43:57 linux kernel: SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
Jan  7 21:43:57 linux kernel: SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x8]:(BUSFREE) 
Jan  7 21:44:27 linux kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) 
Jan  7 21:44:27 linux kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
Jan  7 21:44:27 linux kernel: LQOSTAT1[0x0] LQOSTAT2[0x0] 
Jan  7 21:44:27 linux kernel: 
Jan  7 21:44:27 linux kernel: SCB Count = 32 CMDS_PENDING = 1 LASTSCB 0x11 CURRSCB 0x11 NEXTSCB 0xff02
Jan  7 21:44:27 linux kernel: qinstart = 52611 qinfifonext = 52612
Jan  7 21:44:27 linux kernel: QINFIFO: 0x1b
Jan  7 21:44:27 linux kernel: WAITING_TID_QUEUES:
Jan  7 21:44:27 linux kernel: Pending list:
Jan  7 21:44:27 linux kernel:  27 FIFO_USE[0x0] SCB_CONTROL[0x68]:(STATUS_RCVD|TAG_ENB|DISCENB) 
Jan  7 21:44:27 linux kernel: SCB_SCSIID[0x47] 
Jan  7 21:44:27 linux kernel:  17 FIFO_USE[0x0] SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x7] 
Jan  7 21:44:27 linux kernel: Total 2
Jan  7 21:44:27 linux kernel: Kernel Free SCB list: 10 11 6 25 31 18 13 28 22 20 4 8 21 2 26 30 12 23 14 9 24 3 16 5 0 1 7 15 29 19 
Jan  7 21:44:27 linux kernel: Sequencer Complete DMA-inprog list: 
Jan  7 21:44:27 linux kernel: Sequencer Complete list: 
Jan  7 21:44:27 linux kernel: Sequencer DMA-Up and Complete list: 
Jan  7 21:44:27 linux kernel: 
Jan  7 21:44:27 linux kernel: scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x11
Jan  7 21:44:27 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:44:27 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:44:27 linux kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
Jan  7 21:44:27 linux kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
Jan  7 21:44:27 linux kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0] 
Jan  7 21:44:27 linux kernel: scsi1: FIFO1 Active, LONGJMP == 0x8278, SCB 0x11
Jan  7 21:44:27 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:44:27 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:44:27 linux kernel: SG_CACHE_SHADOW[0x3]:(LAST_SEG_DONE|LAST_SEG) SG_STATE[0x0] 
Jan  7 21:44:27 linux kernel: DFFSXFRCTL[0x0] SOFFCNT[0x0] MDFFSTAT[0x14]:(DLZERO|LASTSDONE) 
Jan  7 21:44:27 linux kernel: SHADDR = 0x06, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
Jan  7 21:44:27 linux kernel: CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
Jan  7 21:44:27 linux kernel: LQIN: 0x55 0x3c 0x0 0x11 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Jan  7 21:44:27 linux kernel: scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
Jan  7 21:44:27 linux kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Jan  7 21:44:27 linux kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
Jan  7 21:44:27 linux kernel: CCSCBCTL[0x4]:(CCSCBDIR) 
Jan  7 21:44:27 linux kernel: scsi1: REG0 == 0x60, SINDEX = 0x1ff, DINDEX = 0x102
Jan  7 21:44:27 linux kernel: scsi1: SCBPTR == 0x11, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xfff9
Jan  7 21:44:27 linux kernel: CDB 0 0 0 0 0 0
Jan  7 21:44:27 linux kernel: STACK: 0x125 0x125 0x125 0x125 0x0 0x25f 0x241 0xa7
Jan  7 21:44:27 linux kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jan  7 21:44:27 linux kernel: DevQ(0:0:0): 0 waiting
Jan  7 21:44:27 linux kernel: DevQ(0:4:0): 0 waiting
Jan  7 21:44:27 linux kernel: DevQ(0:6:0): 0 waiting
Jan  7 21:44:27 linux kernel: scsi1:0:4:0: Cmd aborted from QINFIFO
Jan  7 21:44:27 linux kernel: scsi1:0:4:0: Attempting to abort cmd f6c48680: 0x0 0x0 0x0 0x0 0x0 0x0
Jan  7 21:44:27 linux kernel: scsi1: At time of recovery, card was not paused
Jan  7 21:44:27 linux kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jan  7 21:44:27 linux kernel: scsi1: Dumping Card State at program address 0x1ae Mode 0x11
Jan  7 21:44:27 linux kernel: Card was paused
Jan  7 21:44:27 linux kernel: HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
Jan  7 21:44:27 linux kernel: SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
Jan  7 21:44:27 linux kernel: SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
Jan  7 21:44:27 linux kernel: LASTPHASE[0xa0]:(P_MESGOUT) SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
Jan  7 21:44:27 linux kernel: SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
Jan  7 21:44:27 linux kernel: SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x8]:(BUSFREE) 
Jan  7 21:44:27 linux kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) 
Jan  7 21:44:27 linux kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
Jan  7 21:44:27 linux kernel: LQOSTAT1[0x0] LQOSTAT2[0x0] 
Jan  7 21:44:27 linux kernel: 
Jan  7 21:44:27 linux kernel: SCB Count = 32 CMDS_PENDING = 1 LASTSCB 0x11 CURRSCB 0x11 NEXTSCB 0xff02
Jan  7 21:44:27 linux kernel: qinstart = 52611 qinfifonext = 52612
Jan  7 21:44:27 linux kernel: QINFIFO: 0x1b
Jan  7 21:44:27 linux kernel: WAITING_TID_QUEUES:
Jan  7 21:44:27 linux kernel: Pending list:
Jan  7 21:44:27 linux kernel:  27 FIFO_USE[0x0] SCB_CONTROL[0x68]:(STATUS_RCVD|TAG_ENB|DISCENB) 
Jan  7 21:44:27 linux kernel: SCB_SCSIID[0x47] 
Jan  7 21:44:27 linux kernel:  17 FIFO_USE[0x0] SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x7] 
Jan  7 21:44:27 linux kernel: Total 2
Jan  7 21:44:27 linux kernel: Kernel Free SCB list: 10 11 6 25 31 18 13 28 22 20 4 8 21 2 26 30 12 23 14 9 24 3 16 5 0 1 7 15 29 19 
Jan  7 21:44:27 linux kernel: Sequencer Complete DMA-inprog list: 
Jan  7 21:44:27 linux kernel: Sequencer Complete list: 
Jan  7 21:44:27 linux kernel: Sequencer DMA-Up and Complete list: 
Jan  7 21:44:27 linux kernel: 
Jan  7 21:44:27 linux kernel: scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x11
Jan  7 21:44:27 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:44:27 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:44:27 linux kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
Jan  7 21:44:27 linux kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
Jan  7 21:44:27 linux kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0] 
Jan  7 21:44:27 linux kernel: scsi1: FIFO1 Active, LONGJMP == 0x8278, SCB 0x11
Jan  7 21:44:27 linux kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
Jan  7 21:44:27 linux kernel: SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
Jan  7 21:44:27 linux kernel: SG_CACHE_SHADOW[0x3]:(LAST_SEG_DONE|LAST_SEG) SG_STATE[0x0] 
Jan  7 21:44:27 linux kernel: DFFSXFRCTL[0x0] SOFFCNT[0x0] MDFFSTAT[0x14]:(DLZERO|LASTSDONE) 
Jan  7 21:44:27 linux kernel: SHADDR = 0x06, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
Jan  7 21:44:27 linux kernel: CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
Jan  7 21:44:27 linux kernel: LQIN: 0x55 0x3c 0x0 0x11 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
Jan  7 21:44:27 linux kernel: scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
Jan  7 21:44:27 linux kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Jan  7 21:44:27 linux kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
Jan  7 21:44:27 linux kernel: CCSCBCTL[0x4]:(CCSCBDIR) 
Jan  7 21:44:27 linux kernel: scsi1: REG0 == 0x60, SINDEX = 0x1ff, DINDEX = 0x102
Jan  7 21:44:27 linux kernel: scsi1: SCBPTR == 0x11, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xfff9
Jan  7 21:44:27 linux kernel: CDB 0 0 0 0 0 0
Jan  7 21:44:27 linux kernel: STACK: 0x125 0x125 0x125 0x125 0x0 0x25f 0x241 0xa7
Jan  7 21:44:27 linux kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jan  7 21:44:27 linux kernel: DevQ(0:0:0): 0 waiting
Jan  7 21:44:27 linux kernel: DevQ(0:4:0): 0 waiting
Jan  7 21:44:27 linux kernel: DevQ(0:6:0): 0 waiting
Jan  7 21:44:27 linux kernel: scsi1:0:4:0: Cmd aborted from QINFIFO
Jan  7 21:44:27 linux kernel: Recovery code sleeping
Jan  7 21:44:27 linux kernel: Recovery code awake
Jan  7 21:44:27 linux kernel: Timer Expired
Jan  7 21:44:27 linux kernel: scsi1: Device reset returning 0x2003
Jan  7 21:44:27 linux kernel: Recovery code sleeping
Jan  7 21:44:27 linux kernel: Recovery code awake
Jan  7 21:44:27 linux kernel: Timer Expired
Jan  7 21:44:27 linux kernel: scsi1: Device reset returning 0x2003
Jan  7 21:44:27 linux kernel: Recovery SCB completes
Jan  7 21:44:27 linux last message repeated 2 times
Jan  7 21:44:27 linux kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
Jan  7 21:44:27 linux kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 4 lun 0
Jan  7 21:44:27 linux kernel: SCSI error : <1 0 4 0> return code = 0x8000002
Jan  7 21:44:27 linux kernel: Info fld=0x0, Current sdb: sense key Aborted Command
Jan  7 21:44:27 linux kernel: end_request: I/O error, dev sdb, sector 287306206
Jan  7 21:44:27 linux kernel: md: write_disk_sb failed for device sdb2
Jan  7 21:44:27 linux kernel: md: errors occurred during superblock update, repeating
Jan  7 21:44:27 linux kernel: scsi1 (4:0): rejecting I/O to offline device
Jan  7 21:44:27 linux kernel: md: write_disk_sb failed for device sdb2
Jan  7 21:44:27 linux kernel: md: errors occurred during superblock update, repeating
...........
>>>>>>>>>> the last 3 lines repeated 100 times
............
Jan  7 21:44:27 linux kernel: scsi1 (4:0): rejecting I/O to offline device
Jan  7 21:44:27 linux kernel: md: write_disk_sb failed for device sdb2
Jan  7 21:44:27 linux kernel: md: excessive errors occurred during superblock update, exiting
Jan  7 21:44:27 linux kernel: scsi1 (4:0): rejecting I/O to offline device
Jan  7 21:44:27 linux kernel: raid1: Disk failure on sdb2, disabling device. 
Jan  7 21:44:27 linux kernel:     Operation continuing on 1 devices
Jan  7 21:44:27 linux kernel: RAID1 conf printout:
Jan  7 21:44:27 linux kernel:  --- wd:1 rd:2
Jan  7 21:44:27 linux kernel:  disk 0, wo:1, o:0, dev:sdb2
Jan  7 21:44:27 linux kernel:  disk 1, wo:0, o:1, dev:sdc2
Jan  7 21:44:27 linux kernel: RAID1 conf printout:
Jan  7 21:44:27 linux kernel:  --- wd:1 rd:2
Jan  7 21:44:27 linux kernel:  disk 1, wo:0, o:1, dev:sdc2
