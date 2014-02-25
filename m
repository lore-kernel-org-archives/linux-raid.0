From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 22:08:29 +1100
Message-ID: <530C79AD.2020400@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>	<530AA09B.3090708@fnarfbargle.com>	<530AA460.602@eyal.emu.id.au>	<530AAA55.2080508@fnarfbargle.com>	<530ABF21.7030200@eyal.emu.id.au>	<BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>	<530BADF2.3090907@eyal.emu.id.au>	<20140225141650.56b8dac4@notabene.brown>	<530C4D18.4090403@eyal.emu.id.au> <20140225193501.080a8e61@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140225193501.080a8e61@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is helpful Neil.

I am running blktrace/blkparse and trying to understand what it is telling
me.

If I got it right then I see that doing a check of md127 (from the start)
starts reading with this entry

8,129  6      327     0.992307218 20259  D   R 264200 + 504 [md127_resync]

which means that the real data starts rather further into the stripes.
Actually, further than the bad block: sector 259648 of sdi1 is before the
first read operation. Though I am not even sure that the blkparse 264200
is sectors and now 1KB blocks or 4KB blocks.

Following is some speculation.

Does md127 store a header before it starts striping the data? May this
be why it rarely actually needs to read parts of this header?
(I thought that superblocks and what not are stored at the far end).

If so, then the content of this sector is not part of the redundant data and may
not be trivial to recover. Then again, I expect important data is recorded more
than once.

If this is the case then the calculation to correlate the bad sector to the fs
block (which I need to do whenever I find a bad sector in order to investigate
my data loss) is more complicated than I assumed.

Final thought: if this sector is in an important header, when it *does* need
to be read (and fail), how bad a reaction should I expect?

Eyal

On 02/25/14 19:35, NeilBrown wrote:
> On Tue, 25 Feb 2014 18:58:16 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
> wrote:
>
>> BTW, Is there a monitoring tool to trace all i/o to a device? I could then
>> log activity to /dev/sd[c-i]1 during a (short) 'check' and see if all sectors
>> are really read. Or does md have a debug facility for this?
>
> blktrace will collect a trace, blkparse will print it out for you.
> You need to trace the 'whole' device.
>
> So something like
>
>    blktrace /dev/sd[c-i]
>    # run the test
>    ctrl-C
>    blkparse sd[c-i]*
>
> blktrace creates several files, I think one for each device on each CPU.
>
>
> NeilBrown
>
>>
>> Eyal
>>
>> On 02/25/14 14:16, NeilBrown wrote:
>>> On Tue, 25 Feb 2014 07:39:14 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
>>> wrote:
>>>
>>>> My main interest is to understand why 'check' does not actually check.
>>>> I already know how to fix the problem, by writing to the location I
>>>> can force the pending reallocation to happen, but then I will not have
>>>> the test case anymore.
>>>>
>>>> The OP asks for a specific solution, but I think that the 'check' action
>>>> should already correctly rewrite failed (i/o error) sectors. It does not
>>>> always know which sector to rewrite when it finds a raid6 mismatch
>>>> without an i/o error (with raid5 it never knows).
>>>>
>>>
>>> I cannot reproduce the problem.  In my testing a read error is fixed by
>>> 'check'.  For you it clearly isn't.  I wonder what is different.
>>>
>>> During normal 'check' or 'repair' etc the read requests are allowed to be
>>> combined by the io scheduler so when we get a read error, it could be one
>>> error for a megabyte of more of the address space.
>>> So the first thing raid5.c does is arrange to read all the blocks again but
>>> to prohibit the merging of requests.  This time any read error will be for a
>>> single 4K block.
>>>
>>> Once we have that reliable read error the data is constructed from the other
>>> blocks and the new block is written out.
>>>
>>> This suggests that when there is a read error you should see e.g.
>>>
>>> [  714.808494] end_request: I/O error, dev sds, sector 8141872
>>>
>>> then shortly after that another similar error, possibly with a slightly
>>> different sector number (at most a few thousand sectors later).
>>>
>>> Then something like
>>>
>>> md/raid:md0: read error corrected (8 sectors at 8141872 on sds)
>>>
>>>
>>> However in the log Mikael Abrahamsson posted on 16 Jan 2014
>>> (Subject: Re: read errors not corrected when doing check on RAID6)
>>>
>>> we only see that first 'end_request' message.  No second one and no "read
>>> error corrected".
>>>
>>> This seems to suggest that the second read succeeded, which is odd (to say
>>> the least).
>>>
>>> In your log posted 21 Feb 2014
>>> (Subject: raid 'check' does not provoke expected i/o error)
>>> there aren't even any read errors during 'check'.
>>> The drive sometimes reports a read error and something doesn't?
>>> Does reading the drive with 'dd' already report an error, and with 'check'
>>> never report an error?
>>>
>>>
>>>
>>> So I'm a bit stumped.  It looks like md is doing the right thing, but maybe
>>> the drive is getting confused.
>>> Are all the people who report this using the same sort of drive??
>>>
>>> NeilBrown
>>>
>>
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
