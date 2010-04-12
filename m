From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: stuck tasks
Date: Mon, 12 Apr 2010 14:02:21 +0100
Message-ID: <hpv5kt$o52$1@dough.gmane.org>
References: <hputbs$qq2$1@dough.gmane.org> <4BC2FE9E.9040802@shiftmail.org> <hpuvbb$13t$1@dough.gmane.org> <4BC316EC.9040808@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MRK wrote:

> 
> Mistake of mine, but I might have gotten the right answer by chance
> I had read resyncing but you wrote rsyncing.
> But you were in fact also resyncing from what you write below:

Not at the time of crash! Sorry for the confusion. This happened on reboot 
as the drive didn't properly unmount.

> Resync speed is indeed quite low if you confirm there is no other disk
> activity.

It's not doing anything else on that drive. I think it would be faster but 
the option  CONFIG_MULTICORE_RAID456 was switched on in this kernel, so 
there are lots of async processes fighting each other (190 of them on this 
system).

> Instead if rsync is also running, you need to stop that one to have a
> proper resync speed measurement (to compute the value to be entered into
> sync_speed_max as per my previous email).
> Do you have disk write caches activated? See that with tw_cli (3ware's
> CLI) How much is /sys/block/md{n}/md/stripe_cache_size? Pump it up to
> 32768.

The disk write caches are on. The raid device is fast if you do bonnie tests 
to them (>100MBs).

I tried the strip_cache_size option. The speed stays around 10 MB/s on this 
system. It looks like the sync speed has slowed down a lot since the sync 
started.

Jeremy


