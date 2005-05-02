From: Mitchell Laks <mlaks@verizon.net>
Subject: apparent but not real raid1 failure. what happened? still confused.
 Gurus Please help...
Date: Mon, 02 May 2005 12:24:35 -0400
Message-ID: <200505021224.35396.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently had what appeared to be 
a raid1 failure and was wondering what insight I should draw. The kernel 
diagnostics suggested a dual drive failure - but the data turned out to still 
be there. What does this mean?

I described what happened in an earlier post, but I really don't understand 
and would be very grateful for insight from the gurus on the list.

Is it a bug in the kernel? in software raid? Is it my stupidity?

my system: 

asus K8v-x motherboard with amd64 processor,
uname -a
Linux A2 2.6.8-1-386 #1 Mon Jan 24 03:01:58 EST 2005 i686 GNU/Linux
(this was the debian stock 2.6.8 kernel circa January)

mdadm-v1.9.0

All harddrives are 250GB  parallel ata ide drives, 
WD2500 JB drives (3 year warranty)

Initially, one raid failed:
/dev/md0 between /dev/hda1 and
/dev/hdg1 with the /dev/hdg1 on a highpoint rocket 133 controller.

From reading the log files I see that initially /dev/hda1 died

Apr 21 07:36:01 A2 kernel: hda: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
Apr 21 07:36:01 A2 kernel: hda: dma_intr: error=0x40 { UncorrectableError },
LBAsect=209715335, high=12, low=8388743, sector=209
715335
Apr 21 07:36:01 A2 kernel: end_request: I/O error, dev hda, sector 209715335
Apr 21 07:36:01 A2 kernel: raid1: Disk failure on hda1, disabling device.
Apr 21 07:36:01 A2 kernel: ^IOperation continuing on 1 devices
Apr 21 07:36:01 A2 kernel: raid1: hda1: rescheduling sector 209715272
Apr 21 07:36:01 A2 kernel: RAID1 conf printout:
Apr 21 07:36:01 A2 kernel:  --- wd:1 rd:2
Apr 21 07:36:01 A2 kernel:  disk 0, wo:1, o:0, dev:hda1
Apr 21 07:36:01 A2 kernel:  disk 1, wo:0, o:1, dev:hdg1
Apr 21 07:36:01 A2 kernel: RAID1 conf printout:
Apr 21 07:36:01 A2 kernel:  --- wd:1 rd:2
Apr 21 07:36:01 A2 kernel:  disk 1, wo:0, o:1, dev:hdg1
Apr 21 07:36:01 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
another mirror
Apr 21 07:36:21 A2 kernel: hdg: dma_timer_expiry: dma status == 0x20
Apr 21 07:36:21 A2 kernel: hdg: DMA timeout retry
Apr 21 07:36:21 A2 kernel: hdg: timeout waiting for DMA
Apr 21 07:36:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekComplete DataRequest }
Apr 21 07:36:21 A2 kernel:
Apr 21 07:36:21 A2 kernel: hdg: drive not ready for command
Apr 21 07:36:21 A2 kernel: raid1: hdg1: rescheduling sector 209715272
Apr 21 07:36:21 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
another mirror
Apr 21 07:36:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekComplete DataRequest }
Apr 21 07:36:21 A2 kernel:
Apr 21 07:36:21 A2 kernel: hdg: drive not ready for command
Apr 21 07:36:41 A2 kernel: hdg: dma_timer_expiry: dma status == 0x20
Apr 21 07:36:41 A2 kernel: hdg: DMA timeout retry
Apr 21 07:36:41 A2 kernel: hdg: timeout waiting for DMA
Apr 21 07:36:41 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekComplete DataRequest }
Apr 21 07:36:41 A2 kernel:
Apr 21 07:36:41 A2 kernel: hdg: drive not ready for command
Apr 21 07:36:41 A2 kernel: raid1: hdg1: rescheduling sector 209715272
Apr 21 07:36:41 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
another mirror
Apr 21 07:36:41 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekComplete DataRequest }
Apr 21 07:36:41 A2 kernel:

and then /dev/hdg1 immediately began to spew forth error messages of the
following sort 

Apr 22 22:29:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekComplete DataRequest }
Apr 22 22:29:21 A2 kernel:
Apr 22 22:29:21 A2 kernel: hdg: drive not ready for command
Apr 22 22:29:21 A2 kernel: raid1: hdg1: rescheduling sector 209715272
Apr 22 22:29:21 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
another
mirror
Apr 22 22:29:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
SeekCompl
ete DataRequest }
Apr 22 22:29:21 A2 kernel:
Apr 22 22:29:21 A2 kernel: hdg: drive not ready for command
Apr 22 22:29:21 A2 kernel: raid1: hdg1: rescheduling sector 209715272
Apr 22 22:29:21 A2 kernel: raid1: hdg1: redirecting sector 209715272 to other
 ....

These errors continued nonstop all day/night until /
var ran out of space and errors filled the 6GB /var partition.

2.6GB of         /var/log/kern.log and
2.6GB of        /var/log/syslog and
1GB of          /var/log/messages
were filled by these errors.

I then pulled the two drives out of the system and 
put a pair of new drives in for /dev/hda1 and /dev/hdg1 and
and created /dev/md0 anew, and restored the data to my servers from backups.


I then took the two drives /dev/hda1 and /dev/hdg1 to another machine

and ran the Western Digital drive diagnostics on both of them and they 
are both fine. No errors.

I then took /dev/hda1 on the new system and did
modprobe raid1
mknod /dev/md0 b 9 0
mdadm -A /dev/md0  /dev/hda1 

and then mount /dev/md0 /mnt and i see my data which looks intact.
Similarly if I do that with /dev/hdg1 i see the same data.

(note if i then try to do mdadm -A /dev/md0 /dev/hda1 /dev/hdc1 
(where /dev/hdc1 was /dev/hdg1 on the other machine) then i get a message
saying effectively that they are not up to date to each other ...)
 
Has anyone else had this trouble? Could someone explain what happened?

What should I have done when I found the errors when my system failed?

Is it safe for me to continue to use raid1?

Thanks,

Mitchell

