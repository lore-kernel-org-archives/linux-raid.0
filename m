From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Wed, 22 May 2002 06:46:42 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15594.45618.113616.670740@notabene.cse.unsw.edu.au>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
	<NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cal Webster on Tuesday May 21
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 21, kc130iseo@coastalnet.com wrote:
> 
> 1. Is there anything I need to change in "/etc/raidtab"?
> 	- Should it match the actual configuration?

raidtab is only really used by mkraid.
raidstart uses it to find one drive in the array, and ignores the rest
of raidtab.  Given that one drive, it reads the superblock to find
other drives.  You shouldn't need to change raidtab.

> 	- Differences between raidtools 0.90-6 and 1.00.2-1.3

Don't know.  Not much I think.

> 
> 2. Will the "Version" number in the superblock automatically be updated when
> I start the RAID?

No, the version of the superblock is still 0.90.0.  This number
describes the format.

> ==================
> Things to do next:
> ==================
> 
> ## Update the superblock:
> 
> mdadm --examine --sparc2.2update /dev/sda1
> 
> ## Re-check after updating:
> 
> mdadm --examine --sparc2.2 /dev/sda1

This should show (different) garbage.
After you have updated, your superblock no longer has the
sparc-on-2.2 breakage, and
   mdadm --examine /dev/sda1
should show the correct superblock.

> 
> ## Assemble the array (use raid device order):
> ## Only assemble active devices, not spare.
> 
> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdf1 /dev/sdd1 /dev/sde1
> 
> ## Start the RAID
> 
> raidstart /dev/md0

No, you don't need to do this. "mdadm --assemble" assembles the raid
and starts it..  

> 
> ## Verify that raid is running
> 
> cat /proc/mdstat
> 
> ## Verify that data is intact
> 

NeilBrown
