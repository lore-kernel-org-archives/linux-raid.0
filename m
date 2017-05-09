From: David Brown <david.brown@hesbynett.no>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 12:11:07 +0200
Message-ID: <591195BB.7080200@hesbynett.no>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk> <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk> <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <17fe9ff3-1096-8303-a228-e910a77d8146@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17fe9ff3-1096-8303-a228-e910a77d8146@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/05/17 20:00, Anthony Youngman wrote:

> With redundant raid (and that doesn't include a two-disk, or even
> three-disk mirror), it SHOULD recalculate the failed block. If it
> doesn't bother even though it can, I'd call that a bug in scrub. 

Please read:
<http://neil.brown.name/blog/20100211050355>

> What I
> thought happened was that it reads a stripe direct from disk, and if
> that failed it read the same stripe via the raid code, to get the raid
> error correction to fire, and then it rewrote the stripe.

That /is/ what happens.

As I mentioned in another reply, /reading/ is enough to trigger a
re-write on the disk if significant /correctable/ errors are discovered
by the disk's firmware.  It is extremely rare that the raid level will
see an error (see the linked article by Neil Brown) - usually, the raid
level sees a missing block because the disk firmware could not read the
block correctly.  In such cases, the raid software will write the
correct data back to the disk at the same logical block, and the disk
firmware will re-map it to a different block.

> 
> What would be a nice touch, is that if we have a massive timeout for
> non-SCT drives, if the scrub has to wait more than, say, 10 seconds for
> a read to succeed it then assumes the block is failing and rewrites it.

I don't think the raid level can do that - it must wait for the drive to
finish handling the read request, or drop the drive entirely.

If the disk takes a long time to read a block, then it will either fail
and mark the block bad, or it will get the data off the disk and then
automatically re-write the data to a re-mapped block.  The scrub can
therefore handle it like any other read.

> Actually, scrub that (groan... :-) - if the drive takes longer than 1/3
> of the timeout to respond, then the scrub assumes it's dodgy and
> rewrites it.
>>
>> If there was a way to get md to *rewrite* everything during scrub,
>> rather than just checking, this might help (in addition to letting the
>> drive refresh the magnetization of absolutely everything). "repair" mode
>> appears to do no writes until an error is found, whereupon (on RAID 6)
>> it proceeds to make a "repair" that is more likely than not to overwrite
>> good data with bad. Optionally writing what's already there on non-error
>> seems like it might be a worthwhile (and fairly simple) change.
>>
> Agreed. But without some heuristic, it's actually going to make a scrub
> much slower, and achieve very little apart from adding unnecessary wear
> to the drive.
> 
> Cheers,
> Wol
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

