From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Starting RAID 5
Date: Wed, 20 May 2009 15:45:47 -0400
Message-ID: <4A145DEB.2080602@tmr.com>
References: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com>    <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>    <4A117B0D.5040804@tmr.com> <bd12c2abf38ab775bf40fd52654daa36.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bd12c2abf38ab775bf40fd52654daa36.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, May 19, 2009 1:13 am, Bill Davidsen wrote:
>   
>> NeilBrown wrote:
>>     
>>> On Fri, May 15, 2009 12:15 pm, Leslie Rhorer wrote:
>>>
>>>       
>>>> OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID
>>>> 5.
>>>> I've had problems with this before, and I'm having them, again.  I
>>>> created
>>>> the array with:
>>>>
>>>> mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
>>>> --level=5 /dev/sd[a-g]
>>>>
>>>> whereupon it creates the array and then immediately removes /dev/sdg
>>>> and
>>>> makes it a spare.  I think I may have read where this is normal
>>>> behavior.
>>>>
>>>>         
>>> Correct. Maybe you read it in the mdadm man page.
>>>
>>>
>>>
>>>       
>> While I know about that, I have never understood why that was desirable,
>> or even acceptable, behavior. The array sits half created doing nothing
>> until the system tries to use the array, at which time it's slow because
>> it's finally getting around to actually getting the array into some
>> sensible state. Is there some benefit to wasting time so the array can
>> be slow when needed?
>>     
>
> Is the "that" which you refer to the content of the previous paragraph,
> or the following paragraph.
>
>   
The problem in the following paragraph is caused by the behavior in the 
first. I don't understand what benefit there is to bringing up the array 
with a spare instead of N elements needing a rebuild. Is adding a spare 
in place of the failed device the best (or only) way to kick off a resync?

> The content of your comment suggests the following paragraph which,
> as I hint, is a misfeature that should be fixed by having mdadm
> "poke it out of that" (i.e. set the array to read-write if it is
> read-mostly).
>
> But the positioning of your comment makes it seem to refer to
> the previous paragraph which is totally unrelated to your complaint,
> but I will explain anyway.
>
> When a raid5 performs a 'resync' it reads every block, tests parity,
> then if the parity is wrong, it writes out the correct parity block.
> For an array with mostly correct parity, this involves sequential
> reads across all devices in parallel and so is as fast as possible.
> For an array with mostly incorrect parity (as is quite likely at
> array creation) there will be many writes to parity block as well
> as the reads, which will take a lot longer.
>
> If we instead make one drive a spare then raid5 will perform recovery
> which involves reading N-1 drives and writing to the Nth drive.
> All sequential IOs.  This should be as fast as resync on a mostly-clean
> array, and much faster than resync on a mostly-dirty array.
>   

It's not the process I question, just leaving the resync until the array 
is written by the user rather than starting it at once so the create 
actually results in a fully functional array. I have the feeling that 
raid6 did that, but I haven't hardware to test today.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


