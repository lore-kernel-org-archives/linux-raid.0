From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 00:08:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408310408.i7V48p307444@watkins-home.com>
References: <Pine.LNX.4.58.0408302237580.1949@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408302237580.1949@web1.mmaero.com>
To: 'Jon Lewis' <jlewis@lewis.org>, linux-raid@vger.kernel.org
Cc: aaron@america.com
List-Id: linux-raid.ids

I have read where someone else had a similar problem.
The slowdown was caused by a bad hard disk.

Do a dd read test of each disk in the array.

Example:
time dd if=/dev/sdj of=/dev/null bs=64k

Open different windows and test all of the disks at the same time, 1 per
window.  If you test them all from the same window using "&" the output will
get mixed.

The time command is to compare the performance of each disk.
The time command is optional.

Someone else has said:
Performance can be bad if the disk controller is sharing an interrupt with
another device.
It is ok for 2 of the same model cards to share 1 interrupt.

Use this to determine which interrupts are being used:
cat /proc/interrupts

Moving the card may change the interrupt.
You may also change the interrupts from the BIOS.

I don't think an interrupt problem would cause a slow down over time.
I bet you have a problem with a disk drive.

I hope this helps!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jon Lewis
Sent: Monday, August 30, 2004 11:09 PM
To: linux-raid@vger.kernel.org
Cc: aaron@america.com
Subject: raid5 won't resync

We had a large mail server lose a drive today (not the first time), but
we've been having alot of trouble with the resync this time.

mdadm told us /dev/sde1 had failed.  Coworker did a raidhotadd with a hot
spare (/dev/sdg1).  Machine was under heavy load so we weren't surprised
that the rebuild was going kind of slowly.  About 4 hours later, the
system locked up with lots of "qlogifc0: no handles slots, this should not
happen" error messages.

At this point, we moved the drives (fiber channel attached SCA scsi drive
array) to a spare system with its own qlogic card.  Kernel sees the RAID5
and says that /dev/sde1 is bad.  It starts trying to resync it, but
it's using a different spare drive.  After about 10% of the resync, the
K/s resync speed slows to a few hundred K/sec, and keeps getting slower.
At this point the FS on the RAID5 isn't even mounted, so there shouldn't
be any system activity competing with the RAID rebuild.
/proc/sys/dev/raid/speed_limit_max is set to 100000.

Personalities : [raid5]
read_ahead 1024 sectors
md2 : active raid5 sdf1[10] sdm1[9] sdl1[8] sdk1[7] sdj1[6] sdn1[5]
sdg1[3]
sdd1[2] sdc1[1] sdb1[0]
     315266688 blocks level 5, 64k chunk, algorithm 2 [10/9] [UUUU_UUUUU]
     [==>..................]  recovery = 11.6% (4065836/35029632)
finish=1400.0min speed=368K/sec

kernel version in the original system where the drive failed and the
lockup happened during resync was 2.4.20-28.rh8.0.atsmp from
http://atrpms.net.  ATrpms are simply rebuilding the redhat kernel with
the XFS patches applied.

That system will also crash with the following ATrpms kernels:
2.4.20-35
2.4.20-19
2.4.18-14

Kernel version on spare system doing the slow resync is 2.4.22 from
kernel.org with XFS patches from http://oss.sgi.com/projects/xfs/.  The
big raid5 is an XFS fs.

Each system has 2 qlogic cards (all of which are the same).  The one where
it's resyncing now are:

QLogic ISP2100 SCSI on PCI bus 01 device 10 irq 27 base 0xe800
QLogic ISP2100 SCSI on PCI bus 01 device 18 irq 23 base 0xe400

The drives are all:
  Vendor: IBM      Model: DRHL36L  CLAR36  Rev: 3347
  Type:   Direct-Access                    ANSI SCSI revision: 02

Both systems are dual PIII 1.4's with 4GB RAM.

Anyone have any idea what bug(s) we're running into or have suggestions
for getting this RAID5 back in sync and in service?

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

