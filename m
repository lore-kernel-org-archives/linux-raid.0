From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 11:18:55 +0100
Message-ID: <8760ha72pc.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <17fe9ff3-1096-8303-a228-e910a77d8146@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17fe9ff3-1096-8303-a228-e910a77d8146@youngman.org.uk> (Anthony
        Youngman's message of "Mon, 8 May 2017 19:00:44 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 May 2017, Anthony Youngman verbalised:

> On 08/05/17 15:50, Nix wrote:
>> I wonder... scrubbing is not very useful with md, particularly with RAID
>> 6, because it does no writes unless something mismatches, and on failure
>> there is no attempt to determine which of the N disks is bad and rewrite
>> its contents from the other devices (nor, as I understand it, does it
>> clearly say which drive gave the error, so even failing it out and
>> resyncing it is hard).
>
> With redundant raid (and that doesn't include a two-disk, or even
> three-disk mirror), it SHOULD recalculate the failed block. If it
> doesn't bother even though it can, I'd call that a bug in scrub. What

It didn't, once upon a time (in 2010), and as far as I can tell from the
code it still doesn't.

> I thought happened was that it reads a stripe direct from disk, and if
> that failed it read the same stripe via the raid code, to get the raid
> error correction to fire, and then it rewrote the stripe.

There's *failed*, which does trigger a rewrite, and there's 'we got a
mismatch', which on RAID-6 arguably should trigger a rewrite but instead
just tells you there was a mismatch, but not where, nor even on what
disk.

> What would be a nice touch, is that if we have a massive timeout for
> non-SCT drives, if the scrub has to wait more than, say, 10 seconds
> for a read to succeed it then assumes the block is failing and
> rewrites it.

What tends to happen is that the drive gets reset, which from md's
perspective is the drive vanishing and reappearing again. I don't see
any sane way for md to interpret *that* as anything but a possibly
rather major failure that should be reacted to by failing the drive out.
I mean, all it knows is there was a timeout: for all it knows there are
electrical problems there or something. The drive doesn't say (and
doesn't get a chance to say, because we reset it rather than wait five
minutes for it to tell us what's up).

>              Actually, scrub that (groan... :-) - if the drive takes
> longer than 1/3 of the timeout to respond, then the scrub assumes it's
> dodgy and rewrites it.

It's hard to rewrite anything on a drive that's too busy failing a read
to do anything else.

-- 
NULL && (void)
