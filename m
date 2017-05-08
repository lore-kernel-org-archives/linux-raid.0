From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 08 May 2017 15:50:16 +0100
Message-ID: <87h90v8kt3.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590DC905.60207@youngman.org.uk> (Wols Lists's message of "Sat, 6
        May 2017 14:00:53 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6 May 2017, Wols Lists outgrape:

> On 06/05/17 12:21, Ravi (Tom) Hale wrote:
>>> Bear in mind also, that any *within* *spec* drive can have an "accident"
>>> > every 10TB and still be considered perfectly okay. Which means that if
>>> > you do what you are supposed to do (rewrite the block) you're risking
>>> > the drive remapping the block - and getting closer to the drive bricking
>>> > itself. But if you trap the error yourself and add it to the badblocks
>>> > list, you are risking throwing away perfectly decent blocks that just
>>> > hiccuped.
>
>> For hiccups, having a bad-read-count for each suspected-bad block could
>> be sensible. If that number goes above <small-threshold> it's very
>> likely that the block is indeed bad and should be avoided in future.
>
> Except you have the second law of thermodynamics in play - "what man
> proposes, nature opposes". This could well screw up big time.
>
> DRAM memory needs to be refreshed by a read-write cycle every few
> nanoseconds. Hard drives are the same, actually, except that the
> interval is measured in years, not nanoseconds. Fill your brand new hard
> drive with data, then hammer it gently over a few years. Especially if a
> block's neighbours are repeatedly rewritten but this particular block is
> never touched, it is likely to become unreadable.
>
> So it will fail your test - reads will repeatedly fail - but if the
> firmware was given a look-in (by rewriting it) it wouldn't be remapped.

You mean it *would* be remapped (and all would be well).

I wonder... scrubbing is not very useful with md, particularly with RAID
6, because it does no writes unless something mismatches, and on failure
there is no attempt to determine which of the N disks is bad and rewrite
its contents from the other devices (nor, as I understand it, does it
clearly say which drive gave the error, so even failing it out and
resyncing it is hard).

If there was a way to get md to *rewrite* everything during scrub,
rather than just checking, this might help (in addition to letting the
drive refresh the magnetization of absolutely everything). "repair" mode
appears to do no writes until an error is found, whereupon (on RAID 6)
it proceeds to make a "repair" that is more likely than not to overwrite
good data with bad. Optionally writing what's already there on non-error
seems like it might be a worthwhile (and fairly simple) change.

-- 
NULL && (void)
