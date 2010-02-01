From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Mon, 01 Feb 2010 11:56:39 +0100
Message-ID: <4B66B367.6030803@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B65943A.4040800@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B65943A.4040800@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Asdo wrote:
> Asdo wrote:
>> Giovanni Tessore wrote:
>>> Hm funny ... I just read now from md's man:
>>>
>>> "In  kernels  prior to about 2.6.15, a read error would cause the 
>>> same effect as a write error.  In later kernels, a read-error will 
>>> instead cause md to attempt a recovery by overwriting the bad block. 
>>> .... "
>>>
>>> So things have changed since 2.6.15 ... I was not so wrong to expect 
>>> "the old behaviour" and to be disappointed.
>>> [CUT]
>>
>> I have the feeling the current behaviour is the correct one at least 
>> for RAID-6.
>>
>> [CUT]
>>
>> RAID-5 unfortunately is inherently insecure, here is why:
>> If one drive gets kicked, MD starts recovering to a spare.
>> At that point any single read error during the regeneration (that's a 
>> scrub) will fail the array.
>> This is a problem that cannot be overcome in theory.
>> Even with the old algorithm, any sector failed after the last scrub 
>> will take the array down when one disk is kicked (array will go down 
>> during recovery).
>> So you would need to scrub continuously, or you would need 
>> hyper-reliable disks.
>>
>> Yes, kicking a drive as soon as it presents the first unreadable 
>> sector can be a strategy for trying to select hyper-reliable disks...
>>
>> Ok after all I might agree this can be a reasonable strategy for 
>> raid1,4,5...
Yes, the new behaviour is good for raid-6.
But unsafe for raid 1, 4, 5, 10.
The old behaviour saved me in the past, and would have saved also this 
time, allowing me to replace the disk as soon as possible.. the new one 
didn't at all...
The new one must at least clearly alert the user that a drive is getting 
read errors on raid 1,4,5,10.
>>
>> I'd also agree that with 1.x superblock it would be desirable to be 
>> able to set the maximum number of corrected read errors before a 
>> drive is kicked, which could be set by default to 0 for raid 1,4,5 
>> and to... I don't know... 20 (50? 100?) for raid-6.
Now seems to be hard coded set to 256 ...

> I can add that this situation with raid 1,4,5,10 would be greatly 
> ameliorated when the hot-device-replace feature gets implemented.
> The failures of raid 1,4,5,10 are due to the zero redundancy you get 
> in the time frame from when a drive is kicked to the end of the 
> regeneration.
> However if the hot-device-replace feature is added, and gets linked to 
> the drive-kicking process, the problem would disappear.
>
> Ideally instead of kicking (=failing) a drive directly, the 
> hot-device-replace feature would be triggered, so the new drive would 
> be replicated from the one being kicked (a few damaged blocks can be 
> read from parity in case of read error from the disk being replaced, 
> but don't "fail" the drive during the replace process just for this) 
> In this way you get 1 redundancy instead of zero during rebuild, and 
> the chances of the array going down during the rebuild process are 
> pratically nullified.
>
> I think the "hot-device-replace" action can replace the "fail" action 
> in the most used scenarios, which is the drive being kicked due to:
> 1 - unrecoverable read error (end of relocation sectors available)
> 2 - surpassing the threshold for max corrected read errors (see above, 
> if/when this gets implemented on 1.x superblock)
Both solutions seems good to me ... even if, yes, #1 is problably 
overcame by #2.
And personally I'd keep zero, or a very low value, for max corrected 
error threshold in raid 1,4,5,10.

I may suggest also this for emergency situation (no hot spares 
available, already degraded array, read error on remaining disk(s)):
suppose you have a single disk which is getting read errors: maybe you 
lose some data, but you can still do a backup and save most data.
If you have a degraded array which gets an unrecoverable read error, 
reconstruction is not feasible any more, the disk is mark failed and the 
whole array fails. The you have to recreate with --force or 
--assume-clean, start to backup data.. but on each other read errors you 
get the array offline again ... recreate in --force mode .. and so on 
(which needs skill and it's error prone).
Maybe would be useful to have unrecoverable read errors on degraded 
array to:
1) sent a big alert to admin, with detailed info
2) don't fail the disk and whole array, but set it into readonly mode
3) report read errors to the OS (as for a single drive)

This would allow to do a partial backup and save as most data as 
possible without having to tamper with create --force etc..
Experienced use may still try to overcome the situation readding devices 
(maybe one gone out simply due to timeout), with create --force, etc.. 
but many persons may have big troubles doing so, and they just see all 
their data gone, when just a few sectors over many Tb are unreadable and 
most data cab be saved.

Bets regards.

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


