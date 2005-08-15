From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID readonly before final shutdown
Date: Mon, 15 Aug 2005 14:24:35 +1000
Message-ID: <17152.6403.579491.428656@cse.unsw.edu.au>
References: <Pine.SOL.4.58.0508101126520.23305@titan.cfa.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gaspar Bakos on Wednesday August 10
Sender: linux-raid-owner@vger.kernel.org
To: gbakos@cfa.harvard.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 10, gbakos@cfa.harvard.edu wrote:
> Hi,
> 
> The entire OS I am using is running on software RAID-1. Before killing
> the power of the UPS (in case of a power outage), I issue:
> 
> /sbin/mdadm --readonly $RAIDDEV
> on all the RAID devices I have.
> 
> This, however, does not seem to be enough, and when i power the system
> back on, the RAID arrays are not clean, and a long syncing starts. A
> last step is missing; something like marking the arrays that they are
> clean. I see this happening for a flash of a second when i tell the PC
> to "/sbin/poweroff", i.e. "halt -p". The very last second, before the
> ATX power is turned OFF, the kernel does something to the md arrays.
> 
> My questions are:
> 1. What exactly is this last step?

It is exactly switching the arrays to readonly.


> 2. Can I achieve it manually by sth like
>  echo *** > /proc/***

no (maybe echo ?? > /sys/block/.... one day).

> or by using mdadm?

no.  You can only switch an array to read-only when it is not in use.
So you have to unmount it first.  That possibly sounds a bit
pointless, and it probably is.  But it hasn't been a high priority.

If you are using 2.6, then the arrays will be automatically marked
clean after 20ms of inactivity.  If you "kill -9" the "md*_raid1"
processes, then it will start marking the array clean the instant of
inactivity.

NeilBrown
