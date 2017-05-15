From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Mon, 15 May 2017 14:44:12 +0100
Message-ID: <5919B0AC.30705@youngman.org.uk>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vap2tlvq.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/05/17 12:11, Nix wrote:
> I think the point here is that we'd like some way to recover that lets
> us get back to the most-likely-consistent state. However, on going over
> the RAID-6 maths again I think I see where I was wrong. In the absence
> of P, Q, P *or* Q or one of P and Q and a data stripe, you can
> reconstruct the rest, but the only reason you can do that is because
> they are either correct or absent: you can trust them if they're there,
> and you cannot mistake a missing stripe for one that isn't missing.

The point of Peter Anvin's paper, though, was that it IS possible to
correct raid-6 if ONE of P, Q, or a data stripe is corrupt.

Elementary algebra. Given n unknowns, and n+1 independent facts about
them, we can solve for all unknowns.

With raid-5, we have P and the equation used to construct it, which
means we can solve for one *missing* block.

With raid-6, we have P, Q, and the equation, which means we can solve
for either *two* missing blocks, or *one* corrupt block and "which block
is corrupt?".

Cheers,
Wol
