From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 16:40:38 +0100
Message-ID: <4F3BD1F6.8080309@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <20120215083058.GA8821@cthulhu.home.robinhill.me.uk> <4F3BB385.4000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3BB385.4000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/02/2012 14:30, Stan Hoeppner wrote:
> On 2/15/2012 2:30 AM, Robin Hill wrote:
>> On Tue Feb 14, 2012 at 05:27:43PM -0600, Stan Hoeppner wrote:
>>
>>> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
>>>   If you only read the "faster half" of a spindle, does this mean writes
>>> go to the slower half?  If that's the case, how can you read data that's
>>> never been written?
>>>
>> Writes go to both halves, as normal for a mirrored setup, which is why
>
> Huh?  A 'normal' RAID setup mirrors one disk to another.  You're
> describing data being mirrored from the outer half of a single disk to
> the inner half.  Where's the Redundancy in this?  This doesn't make sense.
>

Like Robin said, and like I said in my earlier post, the second copy is 
on a different disk.

>> its write performance is lower than that of a near layout array (more
>> head movement required). Reads will (normally) come from the faster
>> (outer) half of the disk though, so read performance is better. In most
>> cases workloads are read-heavy, so this comes out as a significant gain.
>
> Again, this makes no sense.  You're simply repeating what David said.
> Neither of you seem to really understand this, or are simply unable to
> explain it correctly, technically.
>

As far as I can see, you are the only one in this thread who doesn't 
understand this.  I'm not sure where the problem lies, as several people 
(including me) have given you explanations that seem pretty clear to me. 
  But maybe there is some fundamental point that we are assuming is 
obvious, but you don't get - hopefully it will suddenly click in place 
for you.

Have a look at this:

<http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10>

Forget writes for a moment.  Forget the second copy on the inner halves 
of the disks.  Then as far as reading is concerned, the raid10,f2 layout 
looks /exactly/ like a raid0 stripe, using only the outer halves of the 
disks.  That means large reads use all the spindles as they read whole 
stripes at a time, just like raid0.  And because all data is on the 
outer halves of the disks, the average bandwidth is higher than if it 
were spread over the whole disk, and the average seek is faster because 
the head movement is smaller - this is standard "short stroking" speed 
improvement.

Write performance is lower because it needs more head movement to make 
the second copy in the inner halves of the disks (as well as the copy to 
the outer halves).  But if you have a reasonable read-to-write ratio, 
the total performance is higher overall.

> Maybe Neil will jump into the fray and answer my original question.
>

