From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 20:39:01 +1100
Message-ID: <51346BB5.2010403@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org> <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad
 4@email.android.com> <5133F95A.5040508@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5133F95A.5040508@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/03/13 12:31, Phil Turmel wrote:
> On 03/03/2013 10:19 AM, Adam Goryachev wrote:
>> Phil Turmel <philip@turmel.org> wrote:
>>
>>> On 03/02/2013 04:15 AM, Stan Hoeppner wrote:
>>>> On 3/1/2013 10:06 AM, Adam Goryachev wrote:
>>>
>>>>> 15) "Make sure all LVs are aligned to the underlying md device
>>>>> geometry. This will eliminate any possible alignment issues."
>>>>> What does this mean? The drive partitions are now aligned properly,
>>>>> but how does LVM allocate the blocks for each LV, and how do I
>>>>> ensure it does so optimally? How do I even check this?
>>>>
>>>> I'm not an LVM user so I can't give you command lines.  But what I
>>>> can tell you follows, and it is somewhat critical to RMW performance,
>>>> more for rust but also for SSD to a lesser degree.
>>> Run "dmsetup table" and look at the start sectors for your volumes:
>>> Fast-Root: 0 314572800 linear 9:3 3072
>>> This volume starts at sector 3072 (1.5MB) on /dev/sda3.  So the volume
>>> alignment within LVM is 512K.
>>
>> I see this (for the first LV)
>> vg0-hostname: 0 204808192 linear 147:2 512
>> So, I'm guessing mine is starting at 512, and is also aligned at 512k ?
> 
> Not quite.  Those size and offset numbers are shown in *sectors*, so you
> have 256k alignment.  But that's exactly the minimum you need to match
> your raid5 chunk size, so you are good for the moment.

Probably a silly question, but how do you convert from the information:
Fast-Root: 0 314572800 linear 9:3 3072
vg0-hostname: 0 204808192 linear 147:2 512

My example was 512 sectors, assuming a sector size of 512 bytes, that
provides 256kB (as you advised above).

Your example was 3072 sectors, again assuming a sector size of 512
bytes, that becomes 1.5MB (as you stated above).

So how come my system has an alignment of 256k (1 x offset) while yours
has 512k (1.5M/3) ?

I'm assuming that in any case, as you suggested, the main thing is that
the answer I got (256kB offset) was equal to the MD chunk size (64kB)
multiplied by the number of data drives (4), or 256kB.


>> Also, pvdisplay tells me the PE Size is 4M, so I'm assuming that regardless of how the LV's are arranged, they will always be 512k aligned?
> 
> 256k, but yeah.

So LVM will not allocate any LV a block of space smaller than 4M, and
I'm assuming will always be on a 4M boundary from the beginning of the
device. Since 4MB is a mulitple of 256kB, then alignment is OK?

If the MD stripe size was larger, eg, if I added 2 more drives it would
become 64kB chunk x 6 data drives = 384kB. This would mean my LVM is no
longer properly aligned. The first block of 4MB would start at 256kB
which is smaller than the stripe size, and each 4MB block would most
likely not line up since 4MB is not divisible by 384kB?

So, if I ever choose to expand the array to include a larger number of
devices (as opposed to replacing all members with larger drives), what
would I need to do to fix all this up?

Re-partition to start the partition at a higher starting sector (such
that 4M / start sector * 512 produces an integer)?

That resolves the first LVM block, but to ensure all other blocks are
properly aligned, is the best answer to upgrade to 8 x data drives
(512kB stripe size)? Or is there some other magic solution I'm missing here?

>> So, is that enough to be sure that this is not an issue?
> It looks to me like you are good on alignment.

Thanks.

On 04/03/13 16:25, Stan Hoeppner wrote:
> If you have no gaps between this one and your other LVs, and each of 
> them is evenly divisible by 512 sectors, then they should all be
> aligned.

Given the 4MB size of the LVM blocks, does that automatically make this
true? I thought it did, but given your above comment, I'm unsure.

Thanks,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
