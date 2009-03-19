From: Neil Brown <neilb@suse.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Fri, 20 Mar 2009 10:35:39 +1100
Message-ID: <18882.54987.332211.49180@notabene.brown>
References: <87ljr4hsk9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Tuesday March 17
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 17, goswin-v-b@web.de wrote:
> Hi,
> 
> I'm wondering why the kernel requires a raid6 to have at least 4
> disks (of which at most 2 can be missing). Why not 3 disks?
> 
> I know a 1+2 disk raid6 sounds stupid but it has an use case. Let me
> demonstrate this with raid5:
> 
> Lets say you started with a raid1 when you bought your computer:
> mdadm --create -l 1 -n 2 /dev/md9 /dev/sda1 /dev/sdb1
> a fewyears of use on /dev/md9 
> 
> Now you run out of space and went and bought a 3rd harddisk. What to
> do now?
> mdadm --stop /dev/md9
> mdadm --create -l 5 -n 2 --assume-clean /dev/sda1 /dev/sdb1
> mdadm --add /dev/md9 /dev/sdc1
> mdadm --grow -n 3 /dev/md9
> 
> Voila. A nice raid5 with twice the size of the raid1. And no single
> point of failure like degrading the raid1 and copying the data to a
> degraded raid5 would have. And the downtime is just a minute to create
> the new superblock.

In 2.6.30 and later you wont even need the downtime.  Just
  echo raid5 > /sys/block/md9/md/level
in place of the "stop" and "create" steps.

> 
> 
> 
> Now for the raid6 case. With only 1 data disk and 2 parity disks all 3
> disks should end up with identical data on them. In effect this should
> be a 3 disk raid1, a cpu intensive one. Take an existing raid1 with 2
> or 3 disks, stop the raid, create a new raid6 ovver it with
> --assume-clean, start the raid. After that one can add more disks and
> --grow -n 4/5/6/.. the raid6 to a sensible size. Again without going
> into degraded mode.
> 
> 
> So back to my original question: Why does the kernel require 4 disks
> for a raid6 instead of allowing 3?

I have occasionally wondered that.  But I didn't write that code and
never saw a need to change it.  As Andre says, it is very likely that
just relaxing the restriction will allow it to "just work".

Maybe that will happen in 2.6.31...

NeilBrown
