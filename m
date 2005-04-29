From: Mitchell Laks <mlaks@verizon.net>
Subject: anatomy of a disaster and how to assess suitability of hard drives
 after raid1 failure?
Date: Fri, 29 Apr 2005 04:26:04 -0400
Message-ID: <200504290426.04341.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have had a spate  of failed drives/raids in raid1 systems lately. 

system: asus K8v-x motherboard with amd64, 
uname -a
Linux A2 2.6.8-1-386 #1 Mon Jan 24 03:01:58 EST 2005 i686 GNU/Linux
debian stock kernel
mdadm-v1.9.0

All harddrives are 250GB  pata ide drives, WD2500 JB drives (3 year warranty) 

Initially, one raid failed:
/dev/md0 between /dev/hda1 and 
/dev/hdg1 with the /dev/hdg1 on a highpoint rocket 133 controller. 

there is also a /dev/md1 between /dev/hdc1 and  /dev/hdi1 (/dev/hdi1 lives on 
a separate channel on the same highpoint controller).  This seemed to be ok.

This is the second time that /dev/md0 failed on this system with /dev/hda1 
and /dev/hdg1.  I partially described it last time a month or so ago on this 
list....

This time: From reading the log files I see that initially /dev/hda1 died 

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
following sort till /var ran out of space and filled 6GB partition.

2.6GB of         /var/log/kern.log and 
2.6GB of        /var/log/syslog and 
1GB of          /var/log/messages


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

I then put a pair of new drives in for /dev/hda1 and /dev/hdg1 and 
and created /dev/md0 anew

I then tested the raid. I copied data to fill /dev/md0. 
I then had a repeat drive failure on /dev/hdg1. 
I then replaced the cable  to /dev/hdg1 and added /dev/hdg1 to the raid. Still 
remained failed. 

Then i replaced the highpoint rocket 133 controller with a 
iwill 66 card with HPT368 controller.

This new controller controlled the 2 drives
/dev/hdg1 and /dev/hdi1. 
I also replaced the drive /dev/hdg1.   

(It turned out that the second /dev/hdg1 (that I just removed actually had 
errors on it using 
WD diagnostics
quick scan :        Read element failure 0007 do full scan
full scan :    errors found the drive has been repaired error code 0223
Question1: would you put such a drive back into service?
Question2: can i send it back to Western Digital if the errors are repaired?
)

I then rebuilt a raid 1 between /dev/hda1 and /dev/hdg1, and 
I left the previously existing raid1  unchanged between
/dev/hdc1 and /dev/hdi1, with the /dev/hdi1 living on a new controller ...
(was this a mistake...)

Now /dev/md0 is fine. I tested by filling with data and still is intact.

Now I began to have trouble with /dev/hdi1 on /dev/md1.

Here is the kern.log output 
Apr 27 16:31:02 A2 kernel: hdi: dma_intr: status=0x51 { DriveReady 
SeekComplete Error }
Apr 27 16:31:02 A2 kernel: hdi: dma_intr: error=0x84 { DriveStatusError 
BadCRC }
Apr 27 16:31:22 A2 kernel: hdi: dma_timer_expiry: dma status == 0x20
Apr 27 16:31:22 A2 kernel: hdi: DMA timeout retry
Apr 27 16:31:22 A2 kernel: PDC202XX: Primary channel reset.
Apr 27 16:31:22 A2 kernel: PDC202XX: Secondary channel reset.
Apr 27 16:31:22 A2 kernel: hdi: set_drive_speed_status: status=0x01 { Error }
Apr 27 16:31:22 A2 kernel: hdi: set_drive_speed_status: error=0x04 
{ DriveStatusError }
Apr 27 16:31:22 A2 kernel: hdi: timeout waiting for DMA
Apr 27 16:37:58 A2 kernel: hdi: dma_timer_expiry: dma status == 0x21
Apr 27 16:38:08 A2 kernel: hdi: DMA timeout error
Apr 27 16:38:08 A2 kernel: hdi: dma timeout error: status=0x58 { DriveReady 
SeekComplete DataRequest }
Apr 27 16:38:08 A2 kernel: 
Apr 27 16:39:19 A2 kernel: hdi: dma_timer_expiry: dma status == 0x21
Apr 27 16:39:29 A2 kernel: hdi: DMA timeout error
Apr 27 16:39:29 A2 kernel: hdi: dma timeout error: status=0x58 { DriveReady 
SeekComplete DataRequest }
Apr 27 16:39:29 A2 kernel: 

later that day, after a system reboot (subsequent to a rebuild of problematic 
raid1 md0 ...)   i see

Apr 27 17:52:33 A2 kernel: md: md1 stopped.
Apr 27 17:52:33 A2 kernel: md: bind<hdc1>
Apr 27 17:52:33 A2 kernel: md: bind<hdi1>
Apr 27 17:52:33 A2 kernel: raid1: raid set md1 active with 2 out of 2 mirrors

(so at that point raid1 is still intact). Then I see
later on 

Apr 27 20:43:00 A2 kernel: hdi: dma_intr: status=0x51 { DriveReady 
SeekComplete Error }
Apr 27 20:43:00 A2 kernel: hdi: dma_intr: error=0x84 { DriveStatusError 
BadCRC }
Apr 27 20:43:20 A2 kernel: hdi: dma_timer_expiry: dma status == 0x20
Apr 27 20:43:20 A2 kernel: hdi: DMA timeout retry
Apr 27 20:43:20 A2 kernel: PDC202XX: Primary channel reset.
Apr 27 20:43:20 A2 kernel: PDC202XX: Secondary channel reset.
Apr 27 20:43:20 A2 kernel: hdi: set_drive_speed_status: status=0x01 { Error }
Apr 27 20:43:20 A2 kernel: hdi: set_drive_speed_status: error=0x04 
{ DriveStatusError }
Apr 27 20:43:20 A2 kernel: hdi: timeout waiting for DMA

then later on I see the following

Apr 27 20:54:38 A2 kernel: md: md1 stopped.
Apr 27 20:54:38 A2 kernel: md: bind<hdi1>
Apr 27 20:54:38 A2 kernel: md: bind<hdc1>
Apr 27 20:54:38 A2 kernel: md: kicking non-fresh hdi1 from array!
Apr 27 20:54:38 A2 kernel: md: unbind<hdi1>
Apr 27 20:54:38 A2 kernel: md: export_rdev(hdi1)
Apr 27 20:54:38 A2 kernel: raid1: raid set md1 active with 1 out of 2 mirrors

I then noticed that the partition (drive) /dev/hdi1 is no longer active in the 
raid1 /dev/md1 array and was failed.

What to do? 

I took the drive out - a WD2500JB (3 year warranty, 3 months old....) and ran 
the WD data lifeguard diagnostics on it.
It said no errors found even on the long 1hour test....

So can someone tell me more information about this disaster situation.

So did I mess up the raid /dev/md1 by moving the device /dev/hdi1 between the 
two physical devices highpoint rocket 133 and the iwill 66 (hpt  368 
controller)? 

So is it safe to reuse this (old /dev/hdi1)  disk (i am afraid to). How can i 
send it back to WD if there are no errors found on the diagnostics?

what about intermediate old /dev/hdg1 (corrected errors above)?

what about old /dev/hdg1 - WD diagnostics (not yet mentioned above) -the cause 
of the original crash - Diagnostics say no errors.

Should I trust the hard drive still?

Or am I just going crazy....( should i move to hardware raid or should i just 
shoot my computer ).

Mitchell
