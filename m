From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 08 May 2017 20:52:10 +0100
Message-ID: <87vapb6s9h.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org> (Phil Turmel's
        message of "Mon, 8 May 2017 15:02:10 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 May 2017, Phil Turmel verbalised:

> On 05/08/2017 10:50 AM, Nix wrote:
>
>> I wonder... scrubbing is not very useful with md, particularly with RAID
>> 6, because it does no writes unless something mismatches,
>
> This is wrong.  The purpose of scrubbing is to expose any sectors that
> have degraded (as Wol describes) to the point of generating a read
> error.  A "check" scrub only writes back to the sectors that report a
> URE, giving the drive firmware a chance to fix or relocate the sector.
>
> A check scrub will NOT write on mismatch, just increment the mismatch
> counter.  This is the recommended regular scrubbing operation.  You want
> to know when mismatches occur.

And... then what do you do? On RAID-6, it appears the answer is "live
with a high probability of inevitable corruption". That's not very good.
(AIUI, if a check scrub finds a URE, it'll rewrite it, and when in the
common case the drive spares it out and the write succeeds, this will
not be reported as a mismatch: is this right?)

>> If there was a way to get md to *rewrite* everything during scrub,
>> rather than just checking, this might help (in addition to letting the
>> drive refresh the magnetization of absolutely everything).
>
> This is actually counterproductive.  Rewriting everything may refresh
> the magnetism on weakening sectors, but will also prevent the drive from
> *finding* weakening sectors that really do need relocation.

If a sector weakens purely because of neighbouring writes or temperature
or a vibrating housing or something (i.e. not because of actual damage),
so that a rewrite will strengthen it and relocation was never necessary,
surely you've just saved a pointless bit of sector sparing? (I don't
know: I'm not sure what the relative frequency of these things is. Read
and write errors in general are so rare that it's quite possible I'm
worrying about nothing at all. I do know I forgot to scrub my old
hardware RAID array for about three years and nothing bad happened...)

-- 
NULL && (void)
