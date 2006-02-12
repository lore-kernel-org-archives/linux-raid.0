From: Neil Brown <neilb@suse.de>
Subject: RE: Procedure for growing RAID1 array
Date: Mon, 13 Feb 2006 09:50:43 +1100
Message-ID: <17391.48067.361040.963459@cse.unsw.edu.au>
References: <17391.46015.6373.474659@cse.unsw.edu.au>
	<20060212224242.C28851CC4D@mx2.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Hilbush on Sunday February 12
Sender: linux-raid-owner@vger.kernel.org
To: mark@hilbush.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 12, mark@hilbush.com wrote:
> Thanks for the suggestion, Neil.  I had totally overlooked that approach.
> 
> So, let's say I can add another physical drive -- /dev/sdc.  It's not clear
> how mdadm knows sdc is the 3rd component device for md0.  Do you tell mdadm
> to use sdc on the command line as shown below?
> 
> 	mdadm --grow /dev/md0 --raid-devices=3 /dev/sdc1
> 
> Or, do you give all three devices?
> 
> 	mdadm --grow /dev/md0 --raid-devices=3 /dev/sd[abc]1

Nether.  You just add it as a spare:
       mdadm /dev/md0 --add /dev/sdc1
this can be done either before or after you --grow.  Once md notices
that the array has room to include another device, and another device
is available, it will start recovery.

> 
> If so, then would the revised procedure look like this?
> 
> - First, make sure I have a good backup
> 
> - Add new drive and partition to be max size of new drive
> 
> - Grow the array to be 3 component devices and wait for resync to complete
> 
> - Set drive 2 as faulty (e.g. mdadm --manage /dev/md0 --fail /dev/sdb1)
> 
> - Remove drive 2 (e.g. mdadm --manage /dev/md0 --remove /dev/sdb1)
> 
> - Grow the array back to 2 component devices
> 
> But wait, what goes on the command line when you shrink it back to 2
> component devices?  Would it be:
> 
> 	mdadm --grow /dev/md0 --raid-devices=2 /dev/sd[ab]1
No, just 
 	mdadm --grow /dev/md0 --raid-devices=2

This will only work (I think) if there are  2 or fewer active devices
in md0, so you do have to fail a device before 'grow'ing down.

Apart from that, this all looks fine.

NeilBrown
