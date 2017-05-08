From: Phil Turmel <philip@turmel.org>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 8 May 2017 16:56:24 -0400
Message-ID: <e2196f02-2b94-8afb-06a0-9695d441c890@turmel.org>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vapb6s9h.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/08/2017 03:52 PM, Nix wrote:
> On 8 May 2017, Phil Turmel verbalised:
> 
>> On 05/08/2017 10:50 AM, Nix wrote:

> And... then what do you do? On RAID-6, it appears the answer is "live
> with a high probability of inevitable corruption".

No, you investigate the quality of your data and the integrity of the
rest of the system, as something *other* than a drive problem caused the
mismatch.  (Swap is a known exception, though.)

> That's not very good.
> (AIUI, if a check scrub finds a URE, it'll rewrite it, and when in the
> common case the drive spares it out and the write succeeds, this will
> not be reported as a mismatch: is this right?)

This is also wrong, because you are assuming sparing-out is the common
case.  A read error does not automatically trigger relocation.  It
triggers *verification* of the next *write*.  In young drives,
successful rewrite in place is the common case.  As the drive ages,
rewrites will begin relocating because there really is a new problem at
that spot, not simple thermal/magnetic decay.

But keep in mind that the firmware of the drive will start verification
of a sector only if it gets a *read* error.  Such sectors get marked as
"pending" relocations until they are written again.  If that write
verifies correct, the "pending" status simply goes away.  Ordinary
writes to presumed-ok sectors are *not* verified.  (There'd be a huge
difference between read and write speeds on rotating media if they were.)

{ Drive self tests might do some pre-emptive rewriting of marginal
sectors -- it's not something drive manufacturers are documenting.  But
a drive self-test cannot fix an unreadable sector -- it doesn't know
what to write there. }

>> This is actually counterproductive.  Rewriting everything may refresh
>> the magnetism on weakening sectors, but will also prevent the drive from
>> *finding* weakening sectors that really do need relocation.
> 
> If a sector weakens purely because of neighbouring writes or temperature
> or a vibrating housing or something (i.e. not because of actual damage),
> so that a rewrite will strengthen it and relocation was never necessary,
> surely you've just saved a pointless bit of sector sparing? (I don't
> know: I'm not sure what the relative frequency of these things is. Read
> and write errors in general are so rare that it's quite possible I'm
> worrying about nothing at all. I do know I forgot to scrub my old
> hardware RAID array for about three years and nothing bad happened...)

Drives that are in applications that get *read* pretty often don't need
much if any scrubbing -- the application itself will expose problem
sectors.  Hobbyists and home media servers can go months with specific
files unread, so developing problems can hit in clusters.  Regular
scrubbing will catch these problems before they take your array down.

And you can't compare hardware array behavior to MD -- they have their
own algorithms to take care of attached disks without OS intervention.

Phil
