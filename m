From: Asdo <asdo@shiftmail.org>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Sun, 31 Jan 2010 15:31:22 +0100
Message-ID: <4B65943A.4040800@shiftmail.org>
References: <4B5F6C73.30707@texsoft.it>
 <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
 <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B64A779.6070809@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Asdo wrote:
> Giovanni Tessore wrote:
>> Hm funny ... I just read now from md's man:
>>
>> "In  kernels  prior to about 2.6.15, a read error would cause the 
>> same effect as a write error.  In later kernels, a read-error will 
>> instead cause md to attempt a recovery by overwriting the bad block. 
>> .... "
>>
>> So things have changed since 2.6.15 ... I was not so wrong to expect 
>> "the old behaviour" and to be disappointed.
>> [CUT]
>
> I have the feeling the current behaviour is the correct one at least 
> for RAID-6.
>
> [CUT]
>
> This is with RAID-6.
>
> RAID-5 unfortunately is inherently insecure, here is why:
> If one drive gets kicked, MD starts recovering to a spare.
> At that point any single read error during the regeneration (that's a 
> scrub) will fail the array.
> This is a problem that cannot be overcome in theory.
> Even with the old algorithm, any sector failed after the last scrub 
> will take the array down when one disk is kicked (array will go down 
> during recovery).
> So you would need to scrub continuously, or you would need 
> hyper-reliable disks.
>
> Yes, kicking a drive as soon as it presents the first unreadable 
> sector can be a strategy for trying to select hyper-reliable disks...
>
> Ok after all I might agree this can be a reasonable strategy for 
> raid1,4,5...
>
> I'd also agree that with 1.x superblock it would be desirable to be 
> able to set the maximum number of corrected read errors before a drive 
> is kicked, which could be set by default to 0 for raid 1,4,5 and to... 
> I don't know... 20 (50? 100?) for raid-6.
>
> Actually I believe the drives should be kicked for this threshold only 
> AFTER the end of the scrub, so that they are used for parity 
> computation till the end of the scrub. I would suggest to check for 
> this threshold at the end of each scrub, not before, and during normal 
> array operation only if a scrub/resync is not in progress (will be 
> checked at the end anyway).
>
> Thank you

I can add that this situation with raid 1,4,5,10 would be greatly 
ameliorated when the hot-device-replace feature gets implemented.
The failures of raid 1,4,5,10 are due to the zero redundancy you get in 
the time frame from when a drive is kicked to the end of the regeneration.
However if the hot-device-replace feature is added, and gets linked to 
the drive-kicking process, the problem would disappear.

Ideally instead of kicking (=failing) a drive directly, the 
hot-device-replace feature would be triggered, so the new drive would be 
replicated from the one being kicked (a few damaged blocks can be read 
from parity in case of read error from the disk being replaced, but 
don't "fail" the drive during the replace process just for this) In this 
way you get 1 redundancy instead of zero during rebuild, and the chances 
of the array going down during the rebuild process are pratically nullified.

I think the "hot-device-replace" action can replace the "fail" action in 
the most used scenarios, which is the drive being kicked due to:
1 - unrecoverable read error (end of relocation sectors available)
2 - surpassing the threshold for max corrected read errors (see above, 
if/when this gets implemented on 1.x superblock)

The reason for why #2 is feasible is trivial

#1 is more difficult (and it's useless to implement this if threshold 
for max corrected read errors gets implemented, because such threshold 
would trigger before the first unrecoverable read error happens), but I 
think it's still feasible. This would be the algorithm: you don't kick 
the drive, you ignore the write error on the bad disk (the correct data 
for that block can still be stored on the parity). Then you immediately 
trigger the hot-device-replace. When the scrub of the bad disk reaches 
the damaged sector, that one will be unreadable (I hope that it will not 
return the old data), but data can be read from the parity so the 
regeneration process can continue. So it should work, I think.

One case when you cannot replace the "fail" with "hot-device-replace" is 
when a disk dies suddenly (e.g. the electronic part dies). Maybe the 
"hot-device-replace" could still be triggered first, but then if the bad 
drive turns out to be completely unresponsive (timeout? number of 
commands without response?) you fall back on "fail".

Thank you
Asdo
