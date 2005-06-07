From: Brad Campbell <brad@wasp.net.au>
Subject: Re: entire array lost when some blocks unreadable?
Date: Wed, 08 Jun 2005 01:10:55 +0400
Message-ID: <42A60D5F.2060407@wasp.net.au>
References: <42A60A1A.9030302@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A60A1A.9030302@gmx.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Eicher <tom.eicher@gmx.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom Eicher wrote:
> Hi list,
> 
> I might be missing the point here... I lost my first Raid-5 array 
> (apparently) because one drive was kicked out after a DriveSeek error. 
> When reconstruction startet at full speed, some blocks on another drive 
> appeared to have uncorrectable errors, resulting in that drive also 
> being kicked... you get it.

Join the long line next to the club trophy cabinet :)

> Now here is my question: On a normal drive, I would expect that a drive 
> seek error or uncorrectable blocks would typically not take out the 
> entire drive, but rather just corrupt the files that happen to be on 
> those blocks. With RAID, a local error seems to render the entire array 
> unusable. This would seem like an extreme measure to take just for some 
> corrupt blocks.

Perhaps.. I believe something may be on the cards in regard to trying to do a reconstruction 
re-write of the dodgy sector to try and force a reallocation prior to kicking the drive, but I only 
recall a rumbling of the ground type of rumour there.

> - Is it correct that a relatively small corrupt area on a drive can 
> cause the raid manager to kick out a drive?

At the moment, yes..

> - How does one prevent the scenario above?
>  - periodically run drive tests (smart -t...) to early detect problems 
> before multiple drives fail?

I run a short test on every drive 6 days a week, and a long test on every drive, every sunday.
This does a good job of locating pending errors and smartd E-mails me any issues it spots. My server 
is not a heavily loaded machine however, and I generally have a chance to trigger a write to 
reallocate the sectors prior to a read hitting it and kicking the drive out (or with the bug I have 
at the moment, killing the box - but that is not an md issue)

>  - periodically run over the entire drives and copy the data around so 
> the drives can sort out the bad blocks?

Something along those lines.
Generally if I get an error notification from smartd I pull the drive from the array and re-add it. 
This causes a rewrite of the entire disk and everyone is happy. (Unless the drive is dying, in which 
case the rewrite of the entire disk usually finishes it off nicely)

Another interesting thought is to unmount the drive and run a badblocks non-destructive media test 
on the array. This will read a stripe into memory (depending on how you configure badblocks) and 
write a series of patterns to the stripe (which will re-write every sector in the stripe). It will 
then write back the original data. Although, I guess in thinking about it, the reading the stripe 
will cause the drive to be kicked if it has a bad block anyway.. so scratch that. It's late here :)

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
