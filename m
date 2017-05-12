From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 12 May 2017 12:14:47 +0100
Message-ID: <87tw4qxr6g.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
        <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
        <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        <87bmr14u5f.fsf_-_@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmr14u5f.fsf_-_@esperi.org.uk> (nix@esperi.org.uk's message of
        "Tue, 09 May 2017 22:06:36 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9 May 2017, nix@esperi.org.uk outgrape:

> On 9 May 2017, Chris Murphy verbalised:
>
>> 1. md reports all data drives and the LBAs for the affected stripe
>
> Enough rambling from me. Here's a hilariously untested patch against
> 4.11 (as in I haven't even booted with it: my systems are kind of in
> flux right now as I migrate to the md-based server that got me all
> concerned about this). It compiles! And it's definitely safer than
> trying a repair, and makes it possible to recover from a real mismatch
> without losing all your hair in the process, or determine that a
> mismatch is spurious or irrelevant. And that's enough for me, frankly.
> This is a very rare problem, one hopes.
>
> (It's probably not ideal, because the error is just known to be
> somewhere in that stripe, not on that sector, which makes determining
> the affected data somewhat harder. But at least you can figure out what
> filesystem it's on. :) )

Aside: this foolish optimist hopes that it might be fairly easy to tie
the new GETFSMAP ioctl() into mismatch reports if the filesystem(s)
overlying a mismatched stripe support it: it looks like we could get the
necessary info for a whole stripe in a single call. Being automatically
told "these files may be corrupted, restore them" or "oops you lost some
metadata on fses A and B, run fsck" would be wonderful. (Though the
actual corruption would be less wonderful.)

This feels like something mdadm's monitor mode should be able to do, to
me. I'll have a look in a bit, but I know nothing about the
implementation of monitor mode at all so I have some learning to do
first...

-- 
NULL && (void)
