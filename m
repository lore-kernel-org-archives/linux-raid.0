From: Asdo <asdo@shiftmail.org>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Sat, 30 Jan 2010 22:41:13 +0100
Message-ID: <4B64A779.6070809@shiftmail.org>
References: <4B5F6C73.30707@texsoft.it>
 <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
 <4B647E0E.6050609@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B647E0E.6050609@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Giovanni Tessore wrote:
>
>>>> Is this some kind of bug?        
>>> No
>>>     
>> I'm not sure I agree.
>>   
>
> Hm funny ... I just read now from md's man:
>
> "In  kernels  prior to about 2.6.15, a read error would cause the same 
> effect as a write error.  In later kernels, a read-error will instead 
> cause md to attempt a recovery by overwriting the bad block. .... "
>
> So things have changed since 2.6.15 ... I was not so wrong to expect 
> "the old behaviour" and to be disappointed.
> But something important was missing during this change imho:
> 1) let the old behaviour be the default: add 
> /sys/block/mdXX/max_correctale_read_errors, with default to 0.
> 2) let the new behaviour be the default, but update mdadm and 
> /proc/mdstat to report read error events.
>
> I think the situation is now quite clear.
> Thanks

I have the feeling the current behaviour is the correct one at least for 
RAID-6.

If you scrub often enough, read errors should be catched when you still 
have enough good disks in that stripe.
At that point rewrite will kick in.
If the disk has enough relocation sectors available, the sector will 
relocate, otherwise the disk gets kicked.

As other people have written, disks now are much bigger than in the 
past, and a damaged sector can happen. It's not necessary to kick the 
drive yet.

This is with RAID-6.

RAID-5 unfortunately is inherently insecure, here is why:
If one drive gets kicked, MD starts recovering to a spare.
At that point any single read error during the regeneration (that's a 
scrub) will fail the array.
This is a problem that cannot be overcome in theory.
Even with the old algorithm, any sector failed after the last scrub will 
take the array down when one disk is kicked (array will go down during 
recovery).
So you would need to scrub continuously, or you would need 
hyper-reliable disks.

Yes, kicking a drive as soon as it presents the first unreadable sector 
can be a strategy for trying to select hyper-reliable disks...

Ok after all I might agree this can be a reasonable strategy for 
raid1,4,5...

I'd also agree that with 1.x superblock it would be desirable to be able 
to set the maximum number of corrected read errors before a drive is 
kicked, which could be set by default to 0 for raid 1,4,5 and to... I 
don't know... 20 (50? 100?) for raid-6.

Actually I believe the drives should be kicked for this threshold only 
AFTER the end of the scrub, so that they are used for parity computation 
till the end of the scrub. I would suggest to check for this threshold 
at the end of each scrub, not before, and during normal array operation 
only if a scrub/resync is not in progress (will be checked at the end 
anyway).

Thank you
Asdo
