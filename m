From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Wed, 10 May 2017 20:03:59 +0100
Message-ID: <87wp9o1qlc.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
        <87inla73vz.fsf@esperi.org.uk>
        <87lgq5n2c0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgq5n2c0.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 10 May 2017 07:32:31 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, NeilBrown outgrape:

> On Tue, May 09 2017, Nix wrote:
>> Neil decided not to do any repair work in this case on the grounds that
>> if the drive is misdirecting one write it might misdirect the repair as
>> well
>
> My justification was a bit broader than that.

I noticed your trailing comment on the blog post only after sending all
these emails out :( bah!

>  If you get a consistency error on RAID6, there is not one model to
>  explain it which is significantly more likely than any other model.

Yeah, I'm quite satisfied with "we don't have enough data to know if
repairing is safe" as reasoning: among other things it suggests that
mismatches are really rare, which is reassuring! This certainly suggests
that repairing should be, at the very least, off by default, and I'm not
terribly unhappy for it to not exist.

... but I do want to at least report the location of stripes that fail
checks, as in my earlier ugly patch. That's useful for any array with >1
partition or LVM LV on it. ("Oh, that mismatch is harmless, it's in
swap. That one is in small_but_crucial_lv, I'll restore it from backup,
without affecting the massive_messy_lv which had no mismatches and would
take weeks to restore.")

(As far as I'm concerned, if you don't *have* a backup of some fs, you
deserve what's coming to you! Good backups are easy and with md you can
even make them as resilient as the main RAID arrays. I'm interested in
maximizing availability here: having to take a big array with many LVs
down for ages for a restore because you don't know which bit is
corrupted just seems *wrong*.)
