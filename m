From: Robin Whittle <rw@firstpr.com.au>
Subject: Thanks for software RAID!
Date: Thu, 26 Jun 2003 22:31:47 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EFAE7B3.5010205@firstpr.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A few days ago one of the two IBM 60 GXP drives (20 gig) in my RH 7.2
server failed.  Two sectors were unreadable, generating these lines in
/var/log/messages, all in the one second:

 hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
 hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=32778538,
      sector=12810992
 end_request: I/O error, dev 03:09 (hda), sector 12810992
 raid1: Disk failure on hda9, disabling device.
 ^IOperation continuing on 1 devices
 raid1: hda9: rescheduling block 12810992
 md: updating md5 RAID superblock on device
 md: hdc9 [events: 000000c9]<6>(write) hdc9's sb offset: 10080384
 md: recovery thread got woken up ...
 md5: no spare disk to reconstruct array! -- continuing in degraded mode
 md: recovery thread finished ...
 hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
 hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=32778538,
      sector=12811000
 end_request: I/O error, dev 03:09 (hda), sector 12811000
 raid1: hda9: rescheduling block 12811000
 md: (skipping faulty hda9 )
 raid1: hdc9: redirecting sector 12810992 to another mirror
 raid1: hdc9: redirecting sector 12811000 to another mirror

There is an hourly cron job which uses "cat /proc/mdstat" to look for
trouble and email me if there is any.  There are no-doubt other ways of
doing this which are faster and more direct.

The computer kept running like a charm and the next day I replaced the
two 20 Gig IBM drives with 40 Gig Seagate Barracuda IV.  I used "cat
/dev/hda > /dev/hdc" (after booting single user) to byte-for-byte clone
the first half of the two new drives from the two old drives.  (This is
possible since both drives have the same number of heads and sectors as
far as Linux is concerned.  I could have used the second half of the 40
gig drives for another partition, but I don't need it.)

Then by recreating the md5 device (I first had to temporarily delete the
md5 section of /etc/raidtab and reboot - probably there is a better
way), which was the one which had a partition fail, and creating a file
system there:

  mkraid /dev/md5     (It took a while to synch the drives.)
  mkfs -j /dev/md5

I was nearly ready to roll.  I copied the data from the good 20 gig
drive by mounting that raw partition (not as part of a RAID device) and
then the system was ready to run.

Software RAID-1 worked perfectly - the computer kept running and no data
was lost.  There was no extra hardware and so no extra cost and no extra
sources of unreliability.

Thanks for Software RAID!


  Cheers

    - Robin

