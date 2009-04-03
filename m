From: "Steven Ellis" <steven@openmedia.co.nz>
Subject: Troubleshooting raid1 data corruption and mismatch_cnt
Date: Fri, 3 Apr 2009 16:14:35 +1300 (NZDT)
Message-ID: <51541.60.234.49.2.1238728475.squirrel@webmail.stevencherie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been noticing a number of corrupted files since installing a new
raid1 set in my server, and the most troubling part is the corruption is
happening on existing raid1 volumes as well as the new raid1 set

Initial environment is as follows

ASRock VT8378/VT8237 based motherboard (K7VM4)
Sii 680 IDE controller - PCI
AMD Athlon XP2000+
1.5 GB Ram
Intel E100 ethernet card - PCI
OS = Centos 5.2 Xen Dom0 with a series of Centos 5.2 VMs.

All raid and LVM is managed at the Xen level.

The onboard VIA IDE controller has a two disk raid 1 set (md1) and the
sii680 controller has a 4 disk raid 5 set. To date this has been very
stable with no raid issues.

I needed some extra storage and as I had no on board SATA installed a
common sii3114 quad sata PCI card, and a pair of WD10EACS 1TB disks Raid1
(md3).

Now my problems begin. I started to notice that files on the 1TB volume
are corrupted with varying MD5SUM values. I then did a

echo check > /sys/block/md3/md/sync_action

Which produced several thousand errors. I corrected this with

echo repair > /sys/block/md1/md/sync_action

The errors were fixed, but soon started to re-occur.

Next I decided to check the core root raid1 set (md1) and found it also
had errors, but thankfully not as many.

After a couple of days I took the Sata controller and disks out to make
sure it wasn't another problem, and no more issues occured on the primary
md1 array.

My next thought was the server might be under powered. I bumped the PSU
from 400W to 550W and put the SATA controller and disks back in. All of my
previous problems re-occured.

Interestingly no issues on the sii680 based raid5 set.

So what should be my next point of action?

1. Are their known issues with sii3114 iand via based motherboards?
2. Is there a conflict between the sii3114 and sii680 cards?
3. Should I try a different motherboard?
4. Should I try a different Sata card?
5. Should I move to a motherboard with onboard sata?

I'm going to leave a memory test running tonight, but I've run one quite
recently on this hardware. I'll also try swapping the 3 PCI cards around.

Sadly here in NZ there isn't a lot of choice in Sata cards unless you want
high end hardware raid models.

I'm not sure what else I can do at this stage in the way of
troubleshooting. I've also tried using the system with a vanilla Centos
5.2 kernel (2.6.18-92.1.22.el5) and the problem still appears to be
present.

Steve

--------------------------------------------
Steven Ellis - Technical Director
OpenMedia Limited - The Home of myPVR
email   - steven@openmedia.co.nz
website - http://www.openmedia.co.nz
