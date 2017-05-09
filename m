From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 11:28:53 +0100
Message-ID: <871sry728q.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <e2196f02-2b94-8afb-06a0-9695d441c890@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e2196f02-2b94-8afb-06a0-9695d441c890@turmel.org> (Phil Turmel's
        message of "Mon, 8 May 2017 16:56:24 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 May 2017, Phil Turmel said:

> On 05/08/2017 03:52 PM, Nix wrote:
>> And... then what do you do? On RAID-6, it appears the answer is "live
>> with a high probability of inevitable corruption".
>
> No, you investigate the quality of your data and the integrity of the
> rest of the system, as something *other* than a drive problem caused the
> mismatch.  (Swap is a known exception, though.)

Yeah, I'm going to "rely" on the fact that this machine has heaps of
memory and won't be swapping much when it does a RAID scrub. :)

But "you investigate the quality of your data"... so now, on a single
mismatch that won't go away, I have to compare all my data with backups,
taking countless hours and emitting heaps of spurious errors because no
backup is ever quite up to date? Those backups *live* on hard drives, so
it has exactly the same chance of spurious disk-layer errors as the
thing that preceded it (quite possibly higher).

Honestly, scrubs are looking less and less desirable the more I talk
about them. Massive worry inducers that don't actually spot problems in
any meaningful sense (not even at the level of "there is a problem on
this disk", just "there is a problem on this array").

>> That's not very good.
>> (AIUI, if a check scrub finds a URE, it'll rewrite it, and when in the
>> common case the drive spares it out and the write succeeds, this will
>> not be reported as a mismatch: is this right?)
>
> This is also wrong, because you are assuming sparing-out is the common
> case.  A read error does not automatically trigger relocation.  It
> triggers *verification* of the next *write*.  In young drives,

So I guess we only need to worry about mismatches if they don't go away
and are persistently in the same place on the same drive. (Only you
can't tell what place that is, or what drive that is, because md doesn't
tell you. I'm really tempted to fix *that* at least, a printk() or
something.)

> { Drive self tests might do some pre-emptive rewriting of marginal
> sectors -- it's not something drive manufacturers are documenting.  But
> a drive self-test cannot fix an unreadable sector -- it doesn't know
> what to write there. }

Agreed.

>>> This is actually counterproductive.  Rewriting everything may refresh
>>> the magnetism on weakening sectors, but will also prevent the drive from
>>> *finding* weakening sectors that really do need relocation.
>> 
>> If a sector weakens purely because of neighbouring writes or temperature
>> or a vibrating housing or something (i.e. not because of actual damage),
>> so that a rewrite will strengthen it and relocation was never necessary,
>> surely you've just saved a pointless bit of sector sparing? (I don't
>> know: I'm not sure what the relative frequency of these things is. Read
>> and write errors in general are so rare that it's quite possible I'm
>> worrying about nothing at all. I do know I forgot to scrub my old
>> hardware RAID array for about three years and nothing bad happened...)
>
> Drives that are in applications that get *read* pretty often don't need
> much if any scrubbing -- the application itself will expose problem
> sectors.  Hobbyists and home media servers can go months with specific
> files unread, so developing problems can hit in clusters.  Regular
> scrubbing will catch these problems before they take your array down.

Yeah, and I have plenty of archival data on this array -- it's the first
one I've ever had that's big enough to consider using for that as well
as for frequently-used stuff whose integrity I care about. (But even the
frequently-read stuff is bcached, so even that is in effect archival
much of the time, from the perspective of its read.)

> And you can't compare hardware array behavior to MD -- they have their
> own algorithms to take care of attached disks without OS intervention.

I don't see what the difference is between a hardware array controller
with its own noddy OS, barely-maintained software, creaking processor,
and not very big battery-backed RAM and md with a decent OS, much faster
processor, decent software, and often masses of RAM and a journal on
SSD, except that the md array will be far faster and if anything goes
wrong you have much higher chance of actually getting your data back
with md. :)

The days of saying "hardware arrays are just different/better, md cannot
compete with them" are many years in the past. People are *replacing*
hardware arrays with md these days because the hardware arrays are
*worse* on almost every metric. If hardware arrays have magic recovery
algorithms that md and/or the Linux block layer don't, the question now
is why not? not "oh we cannot compare"
