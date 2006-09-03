From: Clive Messer <clive@vacuumtube.org.uk>
Subject: RAID-5 recovery
Date: Sun, 3 Sep 2006 11:48:56 +0100
Message-ID: <200609031148.56910.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

I lost a disk from a 4 disk RAID-5 array; usually not a problem, investigate 
and add it back in. Normally nothing wrong with the disk, possibly a ICH6 
libata bug when heavy IO is taking place. Yesterday when adding it back to 
the array, I run into a problem with 3 badblocks on one of the other disks 
which caused the rebuilding to stop. Anyway, got my array back (only one lost 
file) with ddrescue.

This leads me to a question. I understand from reading the linux-raid archives 
that the current behaviour when rebuilding with a single badblock on another 
disk is for that disk to also be kicked from the array. For some time I have 
considered buying a 3ware 9500 card and using that instead of my current ICH6 
and md solution. Can anyone tell me what would happen in the same scenario 
with a 3ware card. ie. would that transparently handle a RAID-5 disk failure 
and rebuild, with a badblock on another disk? Or would I have even less 
chance of getting my data back?

Regards

Clive
-- 
Clive Messer <clive@vacuumtube.org.uk>

-- 
VGER BF report: U 0.520926
