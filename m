From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 13:50:01 +0100
Message-ID: <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

addendum: when going through the logs I found the reason:

Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Dec 23 02:55:40 alfred kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond, please be patient (ready=0)
Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=-16), forcing hardreset
Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond, please be patient (ready=0)
Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=-16)
Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond, please be patient (ready=0)
Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=-16)
Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond, please be patient (ready=0)
Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=-16)
Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link speed to 1.5 Gbps
Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=-16)
Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
Dec 23 02:56:50 alfred kernel: ata1.00: disabled
Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out command, waited 30s
Dec 23 02:56:50 alfred kernel: ata1: EH complete
Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000
Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sector 1244700223
Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000
Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sector 1554309191
Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000
Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sector 1554309439
Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000
Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sector 572721343
Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, disabling device. Operation continuing on 3 devices
Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
Dec 23 02:56:50 alfred kernel:  --- rd:4 wd:3 fd:1
Dec 23 02:56:50 alfred kernel:  disk 0, o:1, dev:sdb1
Dec 23 02:56:50 alfred kernel:  disk 1, o:1, dev:sdd1
Dec 23 02:56:50 alfred kernel:  disk 2, o:0, dev:sda1
Dec 23 02:56:50 alfred kernel:  disk 3, o:1, dev:sdc1
Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
Dec 23 02:56:50 alfred kernel:  --- rd:4 wd:3 fd:1
Dec 23 02:56:50 alfred kernel:  disk 0, o:1, dev:sdb1
Dec 23 02:56:50 alfred kernel:  disk 1, o:1, dev:sdd1
Dec 23 02:56:50 alfred kernel:  disk 3, o:1, dev:sdc1
Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not capable of SMART self-check
Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mail to root ...
Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: successful
Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, failed to read SMART Attribute Data
Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mail to root ...
Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: successful
Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of SMART self-check
Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, failed to read SMART Attribute Data
Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not capable of SMART self-check
Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, failed to read SMART Attribute Data
Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of SMART self-check
 [...]
Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of SMART self-check
Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, failed to read SMART Attribute Data
 (crash here)
 

RF> hi,

RF> got a "nice" early christmas present this morning: after a crash, the raid5
RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't start :-(

RF> the history:
RF> sometimes, the raid kicked out one disk, started a resync (which
RF> lasted for about 3 days) and was fine after that. a few days ago I
RF> replaced drive sdd (which seemed to cause the troubles) and synced the
RF> raid again which finished yesterday in the early afternoon. at 10am
RF> today the system crashed and the raid won't start:

RF> OS is Centos 5
RF> mdadm - v2.6.9 - 10th March 2009
RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:47 EST 2009 i686 athlon i386 GNU/Linux


RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID arrays.
RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
RF> Dec 23 12:30:19 alfred kernel: md:  adding sdd1 ...
RF> Dec 23 12:30:19 alfred kernel: md:  adding sdc1 ...
RF> Dec 23 12:30:19 alfred kernel: md:  adding sdb1 ...
RF> Dec 23 12:30:19 alfred kernel: md:  adding sda1 ...
RF> Dec 23 12:30:19 alfred kernel: md: created md0
RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><sda1>
RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from array!
RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not clean -- starting background reconstruction
RF>     (no reconstruction is actually started, disks are idle)
RF> Dec 23 12:30:19 alfred kernel: raid5: automatically using best checksumming function: pIII_sse
RF> Dec 23 12:30:19 alfred kernel:    pIII_sse  :  7085.000 MB/sec
RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_sse (7085.000 MB/sec)
RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1    896 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2    972 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4    893 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8    934 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1     1845 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2     3250 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1    1799 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2    3067 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1    2980 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2    4015 MB/s
RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x2 (4015 MB/s)
RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality registered for level 6
RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality registered for level 5
RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality registered for level 4
RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operational as raid disk 1
RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational as raid disk 3
RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational as raid disk 0
RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degraded array for md0
RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
RF> Dec 23 12:30:19 alfred kernel:  --- rd:4 wd:3 fd:1
RF> Dec 23 12:30:19 alfred kernel:  disk 0, o:1, dev:sdb1
RF> Dec 23 12:30:19 alfred kernel:  disk 1, o:1, dev:sdd1
RF> Dec 23 12:30:19 alfred kernel:  disk 3, o:1, dev:sdc1
RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid set md0
RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath: version 1.0.5 loaded

RF> # cat /proc/mdstat
RF> Personalities : [raid6] [raid5] [raid4]
RF> unused devices: <none>

RF> filesystem used on top of md0 is xfs.

RF> please advice what to do next and let me know if you need further
RF> information. really don't want to lose 3TB worth of data :-(


RF> tnx in advance.

RF> --
RF> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
RF> the body of a message to majordomo@vger.kernel.org
RF> More majordomo info at  http://vger.kernel.org/majordomo-info.html


------------------------------------------------------------------------------
Unix gives you just enough rope to hang yourself -- and then a couple of more 
feet, just to be sure.
(Eric Allman)
------------------------------------------------------------------------------

