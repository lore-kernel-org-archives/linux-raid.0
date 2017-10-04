From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 22:08:04 +0100
Message-ID: <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
 <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk>
 <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 21:01, Curt wrote:
> Hello,
> 
> Thanks for clarifying. All current good drives report that they are
> part of a 8 drive array.  I only grew the raid by 1 device, so it
> would from 7-8, which is what they all report.

That's good.

> The 3rd failed doesn't
> report anything on examine, I haven't touched it at all and was not
> included in my assemble. 

So this wasn't part of your original "assemble --force"? This wasn't 
part of the array you managed to get working and then failed again?

> The 2 I replaced, the original drives I
> yanked,  think they are still part of a 7 drive array.

Okay. The remaining five original disks are the ones we NEED. I'm 
seriously concerned that if that third drive was one of these five, 
we're in big trouble - we've lost the superblock.
> 
> I'll be doing a ddrescue on the drives tonight, but will wait till
> Phil or someone chimes in with my next steps after I do that.

If you've got enough to ddrescue all of those five original drives, then 
that's absolutely great.

Remember - if we can't get five original drives (or copies thereof) the 
array is toast.
> 
> lol, chalk one more up for FML. "SCT Error Recovery Control command
> not supported".  I'm guessing this is a real bad thing now?  I didn't
> buy these drives or org set it up.
> 
I'm not sure whether this is good news or bad. Actually, it *could* be 
great news for the rescue! It's bad news for raid though, if you don't 
deal with it up front - I guess that wasn't done ...

*************

Go and read the wiki - the "When Things Go Wrogn" section. That will 
hopefully help a lot and it explains the Error Recovery stuff (the 
timeout mismatch page). Fix that problem and your dodgy drives will 
probably dd without trouble at all.

Hopefully with all copied drives, but if you have to mix dd'd and 
original drives you're probably okay, you should now be able to assemble 
a working array with five drives by doing an

mdadm --assemble blah blah blah --update=revert-reshape

That will put you back to a "5 drives out of 7" working array. The 
problem with this is that it will be a degraded, linear array.

I'm not sure whether a --display will list the failed drives - if it 
does you can now --remove them. So you'll now have a working, 7-drive 
array, with two drives missing.

Now --add in the two new drives. MAKE SURE you've read the section on 
timeout mismatch and dealt with it! The rebuild/recovery will ALMOST 
CERTAINLY FAIL if you don't! Also note that I am not sure about how 
those drives will display while rebuilding - they may well display as 
being spares during a rebuild.

Lastly, MAKE SURE you set up a regular scrub. There's a distinct 
possibility that this problem wouldn't have arisen (or would have been 
found quicker) if a scrub had been in place. And if you can set up a 
trigger that emails you the contents of /proc/mdstat every few days. 
It's far too easy to miss a failed drive if you don't have something 
shoving it in your face every few days.

Cheers,
Wol

> On Wed, Oct 4, 2017 at 3:46 PM, Anthony Youngman
> <antlists@youngman.org.uk> wrote:
>> On 04/10/17 20:09, Curt wrote:
>>>
>>> Ok, thanks.
>>>
>>> I'm pretty sure I'll be able to DD from at least one of the failed
>>> drives, as I could still query them before I yanked them.  Assuming I
>>> can DD one of the old drives to one of my new ones.
>>>
>>> I'd DDrescue old to new drive. Then do an assemble for force, with a
>>> mix of the dd drives and my old good ones? So if sda/b are new DD'd
>>> drives and sdc/d/e are hosed grow drives, I'd do an assemble force
>>> revert-reshape /dev/md127 sda sdb sdc sdd and sde? Then assemble can
>>> use my info from the DD drives to assemble the array back to 7 drives?
>>>    Did I understand that right?
>>
>>
>> This sounds like you need to take a great big step backwards, and make sure
>> you understand EXACTLY what is going on. We have a mix of good drives,
>> copies of bad drives, and an array that doesn't know whether it is supposed
>> to have 7 or 9 drives. One wrong step and your array will be toast.
>>
>> You want ALL FOUR KNOWN GOOD DRIVES. You want JUST ONE ddrescue'd drive.
>>
>> But I think the first thing we need to do, is to wait for an expert like
>> Phil to chime in and sort out that reshape. Your four good drives all think
>> they are part of a 9-drive array. Your first two drives to fail think they
>> are part of a 7-drive array. Does the third drive think it's part of a
>> 7-drive or 9-drive array?
>>
>> Can you do a --examine on this drive? I suspect the grow blew up because it
>> couldn't access this drive. I this drive thinks it is part of a 7-drive
>> array, we have a bit of a problem on our hands.
>>
>> I'm hoping it thinks it's part of a 9-drive array - I think we may be able
>> to get out of this ...
>>>
>>>
>>> Oh and how can I tell if I have a timeout mismatch.  They should be raid
>>> drives.
>>
>>
>> smartctl -x /dev/sdX
>>
>> This will give you both the sort of drive you have - yes if it's in a
>> datacentre chances are it is a raid drive - and then search the output for
>> Error Recovery Control. This is from my hard drive...
>>
>> SCT capabilities:              (0x003f) SCT Status supported.
>>                                          SCT Error Recovery Control
>> supported.
>>                                          SCT Feature Control supported.
>>                                          SCT Data Table supported.
>>
>> You need error recovery to be supported. If it isn't ...
>>
>>>
>>> Cheers,
>>> Curt
>>
>>
>> Cheers,
>> Wol
> 
