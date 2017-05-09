From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 12:27:18 +0100
Message-ID: <878tm65kyx.fsf@esperi.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5911A371.3030008@hesbynett.no> (David Brown's message of "Tue,
        09 May 2017 13:09:37 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, David Brown uttered the following:

> On 09/05/17 11:53, Nix wrote:
>> This turns out not to be the case. See this ten-year-old paper:
>> <https://indico.cern.ch/event/13797/contributions/1362288/attachments/115080/163419/Data_integrity_v3.pdf>.
>> Five weeks of doing 2GiB writes on 3000 nodes once every two hours
>> found, they estimated, 50 errors possibly attributable to disk problems
>> (sector- or page-size regions of corrupted data) on 1/30th of their
>> nodes. This is *not* rare and it is hard to imagine that 1/30th of disks
>> used by CERN deserve discarding. It is better to assume that drives
>> misdirect writes now and then, and to provide a means of recovering from
>> them that does not take days of panic. RAID-6 gives you that means: md
>> should use it.
>
> RAID-6 does not help here.  You have to understand the types of errors
> that can occur, the reasons for them, the possibilities for detection,
> the possibilities for recovery, and what the different layers in the
> system can do about them.
>
> RAID (1/5/6) will let you recover from one or more known failed reads,
> on the assumption that the driver firmware is correct, memories have no
> errors, buses have no errors, block writes are atomic, write ordering
> matches the flush commands, block reads are either correct or marked as
> failed, etc.

I think you're being too pedantic. Many of these things are known not to
be true on real hardware, and at least one of them cannot possibly be
true without a journal (atomic block writes). Nonetheless, the md layer
is quite happy to rebuild after a failed disk even though the write hole
might have torn garbage into your data, on the grounds that it
*probably* did not. If your argument was used everywhere, md would never
have been started because 100% reliability was not guaranteed.

The same, it seems to me, is true of cases in which one drive in a
RAID-6 reports a few mismatched blocks. It is true that you don't know
the cause of the mismatches, but you *do* know which bit of the mismatch
is wrong and what data should be there, subject only to the assumption
that sufficiently few drives have made simultaneous mistakes that
redundancy is preserved. And that's the same assumption RAID >0 makes
all the time anyway!

The only difference in the disk-failure case is that you know that one
drive has failed without needing to ask other drives to be sure. I mean,
yeah, *possibly* in the RAID-6 mismatch case *five* drives have gone
simultaneously wrong in such a way that their syndromes all match and
the one surviving drive is mistakenly misrepaired, but frankly you'd
need to wait for black holes to evaporate of old age before this became
an issue.

(I'm not suggesting repairing RAID-5 mismatches. That's clearly
impossible. You can't even tell what disk is affected. But in the RAID-6
case none of this is impossible, or so it seems to me. You have at least
three and probably four or more drives with consistent syndromes, and
one that is out of whack. You know which one must be wrong -- the
"minority vote" -- and you know what has to be done to make it
consistent with the others again. Why not do it? It's no more risky than
that aspect of a RAID rebuild from a failed disk would be.)

> RAID will /not/ let you reliably detect or correct other sorts of
> errors.

... only it clearly can. What stops it from handling the RAID-6-and-
one-disk-is-wrong case where it cannot handle the RAID-6-and-one-disk-
has-failed case, given that you can unambiguously determine which disk
is wrong using the data on the surviving drives, with an undetected-
failure probability of something way below 2^128? (I could work out the
actual value but I haven't had any coffee yet and it seems pointless
when it's that low.)

> What does /not/ work, however, is trying to squeeze magic capabilities
> out of existing layers in the system, or expecting more out of them that
> they can give.

I don't see that these capabilities are any more magic than what RAID-6
does already. It can recover from two failed drives: why can't it
recover from one wrong one? (Or, rather, from one drive with very
occasionally wrong sectors on it. Obviously if it was always getting
things wrong its presence is not a benefit and you have essentially
fallen back to nothing better than RAID-5, only with worse performance.
But that's what error thresholds are for, which md already employs in
similar situations.)

-- 
NULL && (void)
