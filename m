From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 8 May 2017 19:00:44 +0100
Message-ID: <17fe9ff3-1096-8303-a228-e910a77d8146@youngman.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h90v8kt3.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/05/17 15:50, Nix wrote:
> On 6 May 2017, Wols Lists outgrape:
> 
>> On 06/05/17 12:21, Ravi (Tom) Hale wrote:
>>>> Bear in mind also, that any *within* *spec* drive can have an "accident"
>>>>> every 10TB and still be considered perfectly okay. Which means that if
>>>>> you do what you are supposed to do (rewrite the block) you're risking
>>>>> the drive remapping the block - and getting closer to the drive bricking
>>>>> itself. But if you trap the error yourself and add it to the badblocks
>>>>> list, you are risking throwing away perfectly decent blocks that just
>>>>> hiccuped.
>>
>>> For hiccups, having a bad-read-count for each suspected-bad block could
>>> be sensible. If that number goes above <small-threshold> it's very
>>> likely that the block is indeed bad and should be avoided in future.
>>
>> Except you have the second law of thermodynamics in play - "what man
>> proposes, nature opposes". This could well screw up big time.
>>
>> DRAM memory needs to be refreshed by a read-write cycle every few
>> nanoseconds. Hard drives are the same, actually, except that the
>> interval is measured in years, not nanoseconds. Fill your brand new hard
>> drive with data, then hammer it gently over a few years. Especially if a
>> block's neighbours are repeatedly rewritten but this particular block is
>> never touched, it is likely to become unreadable.
>>
>> So it will fail your test - reads will repeatedly fail - but if the
>> firmware was given a look-in (by rewriting it) it wouldn't be remapped.
> 
> You mean it *would* be remapped (and all would be well).
> 
No. The data would be lost, the block would be overwritten successfully 
and there would be no need to remap. Basically, the magnetism has 
decayed (so it can't be reconstructed from the extra error recovery bits 
on disk) and rewriting it fixes the problem. But the data's been lost ...

> I wonder... scrubbing is not very useful with md, particularly with RAID
> 6, because it does no writes unless something mismatches, and on failure
> there is no attempt to determine which of the N disks is bad and rewrite
> its contents from the other devices (nor, as I understand it, does it
> clearly say which drive gave the error, so even failing it out and
> resyncing it is hard).

With redundant raid (and that doesn't include a two-disk, or even 
three-disk mirror), it SHOULD recalculate the failed block. If it 
doesn't bother even though it can, I'd call that a bug in scrub. What I 
thought happened was that it reads a stripe direct from disk, and if 
that failed it read the same stripe via the raid code, to get the raid 
error correction to fire, and then it rewrote the stripe.

What would be a nice touch, is that if we have a massive timeout for 
non-SCT drives, if the scrub has to wait more than, say, 10 seconds for 
a read to succeed it then assumes the block is failing and rewrites it. 
Actually, scrub that (groan... :-) - if the drive takes longer than 1/3 
of the timeout to respond, then the scrub assumes it's dodgy and 
rewrites it.
> 
> If there was a way to get md to *rewrite* everything during scrub,
> rather than just checking, this might help (in addition to letting the
> drive refresh the magnetization of absolutely everything). "repair" mode
> appears to do no writes until an error is found, whereupon (on RAID 6)
> it proceeds to make a "repair" that is more likely than not to overwrite
> good data with bad. Optionally writing what's already there on non-error
> seems like it might be a worthwhile (and fairly simple) change.
> 
Agreed. But without some heuristic, it's actually going to make a scrub 
much slower, and achieve very little apart from adding unnecessary wear 
to the drive.

Cheers,
Wol
