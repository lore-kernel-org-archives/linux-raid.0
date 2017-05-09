From: David Brown <david.brown@hesbynett.no>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 13:58:12 +0200
Message-ID: <5911AED4.9030007@hesbynett.no>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>      <590B3039.3060000@youngman.org.uk>      <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>  <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>  <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>  <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>       <87vapb6s9h.fsf@esperi.org.uk>  <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>  <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tm65kyx.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/05/17 13:27, Nix wrote:
> On 9 May 2017, David Brown uttered the following:

> (I'm not suggesting repairing RAID-5 mismatches. That's clearly
> impossible. You can't even tell what disk is affected. But in the RAID-6
> case none of this is impossible, or so it seems to me. You have at least
> three and probably four or more drives with consistent syndromes, and
> one that is out of whack. You know which one must be wrong -- the
> "minority vote" -- and you know what has to be done to make it
> consistent with the others again. Why not do it? It's no more risky than
> that aspect of a RAID rebuild from a failed disk would be.)
> 
>> RAID will /not/ let you reliably detect or correct other sorts of
>> errors.
> 
> ... only it clearly can. What stops it from handling the RAID-6-and-
> one-disk-is-wrong case where it cannot handle the RAID-6-and-one-disk-
> has-failed case, given that you can unambiguously determine which disk
> is wrong using the data on the surviving drives, with an undetected-
> failure probability of something way below 2^128? (I could work out the
> actual value but I haven't had any coffee yet and it seems pointless
> when it's that low.)
> 
>> What does /not/ work, however, is trying to squeeze magic capabilities
>> out of existing layers in the system, or expecting more out of them that
>> they can give.
> 
> I don't see that these capabilities are any more magic than what RAID-6
> does already. It can recover from two failed drives: why can't it
> recover from one wrong one? (Or, rather, from one drive with very
> occasionally wrong sectors on it. Obviously if it was always getting
> things wrong its presence is not a benefit and you have essentially
> fallen back to nothing better than RAID-5, only with worse performance.
> But that's what error thresholds are for, which md already employs in
> similar situations.)
> 

I thought you said that you had read Neil's article.  Please go back and
read it again.  If you don't agree with what is written there, then
there is little more I can say to convince you.

One thing I can try, is to note that you are /not/ the first person to
think "Surely with RAID-6 we can correct mismatches - it should be
easy?".  You are /not/ the first person to think "Correcting RAID-6
mismatches would be a marvellous feature that would make it /far/
better".  Linux md raid does not correct RAID-6 mismatches found on a
scrub.  To my (admittedly limited) knowledge, hardware RAID-6 systems do
not correct mismatches found on a scrub.  If correcting RAID-6
mismatches were as simple, reliably, and useful as you seem to believe,
than I think Linux md raid would already do it - either as part of the
scrub, or as an extra utility to run on mismatched stripes.

