From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recovery not starting: wrong superblock? multipath instead of raid1
 !? (long!)
Date: Fri, 12 Sep 2003 14:38:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.19910.726790.810174@notabene.cse.unsw.edu.au>
References: <3F5E0F4E.5090404@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Ems on Tuesday September 9
To: r.ems@gmx.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 9, r.ems@gmx.net wrote:
> 
> /proc/mdstat and mdadm --examine show that /dev/hdb2 is active, so I 
> tried setting /dev/hda2 to faulty, remove it and add it back again, but 
> no recovery was started.

I suggest you try to boot with hda2 not in the array at all.  Just
hdb2.
Probably this means usinf fdisk to tell hda2 that it isn't a raid
device so it doesn't get auto-detected.
Then When you have a raid1 array working off just hdb2, hot add hda2.
Then set the partition type back, and reboot.
> 
> Why does it show "Raid Level : multipath" ???

Weird.  No idea.  But it is getting it from hda2 which is why I say
start the array without that.
> 
> What are "Raid Devices"? The ones defined in /etc/raidtab?
Yes, the number of devices in a fully working array.


> Why "Total Devices : 1"? Is this the same as "Working Devices"?

No.  It includes spares.  hdb2 thinks there is only 1 device of any
sort at the moment.

> Could devices be working but not active?

Yes.  A hot spare is working but not active.

NeilBrown
