From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: problems with dm-raid 6
Date: Sun, 20 Mar 2016 23:37:27 +0100
Message-ID: <20160320223727.GA29895@EIS>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
 <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 20, 2016 at 10:44:57PM +0100, Patrick Tschackert wrote:
> After rebooting the system, one of the harddisks was missing from my md raid 6 (the drive was /dev/sdf), so i rebuilt it with a hotspare that was already present in the system.
> I physically removed the "missing" /dev/sdf drive after the restore and replaced it with a new drive.

Exact commands involved for those steps?

mdadm --examine output for your disks?

> $ cat /sys/block/md0/md/mismatch_cnt
> 311936608

Basically the whole array out of whack.

This is what you get when you use --create --assume-clean on disks 
that are not actually clean... or if you somehow convince md to 
integrate a disk that does not have valid data on, for example 
because you copied partition table and md metadata - but not  
everything else - using dd.

Something really bad happened here and the only person who 
can explain it, is probably yourself.

Your best bet is that the data is valid on n-2 disks.

Use overlay https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

Assemble the overlay RAID with any 2 disks missing (try all combinations) and see if you get valid data.

Regards
Andreas Klauer
