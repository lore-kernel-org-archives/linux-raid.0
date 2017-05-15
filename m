From: Phil Turmel <philip@turmel.org>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Mon, 15 May 2017 18:31:55 -0400
Message-ID: <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5919B0AC.30705@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/15/2017 09:44 AM, Wols Lists wrote:
> On 15/05/17 12:11, Nix wrote:
>> I think the point here is that we'd like some way to recover that lets
>> us get back to the most-likely-consistent state. However, on going over
>> the RAID-6 maths again I think I see where I was wrong. In the absence
>> of P, Q, P *or* Q or one of P and Q and a data stripe, you can
>> reconstruct the rest, but the only reason you can do that is because
>> they are either correct or absent: you can trust them if they're there,
>> and you cannot mistake a missing stripe for one that isn't missing.
> 
> The point of Peter Anvin's paper, though, was that it IS possible to
> correct raid-6 if ONE of P, Q, or a data stripe is corrupt.

If and only if it is known that all but the supposedly corrupt block
were written together (complete stripe) and no possibility of
perturbation occurred between the original calculation of P,Q in the CPU
and original transmission of all of these blocks to the member drives.

Since incomplete writes and a whole host of hardware corruptions are
known to happen, you *don't* have enough information to automatically
repair.

The only unambiguous signal MD raid receives that a particular block is
corrupt is an Unrecoverable Read Error from a drive.  MD fixes these
from available redundancy.  All other sources of corruption require
assistance from an upper layer or from administrator input.

There's no magic wand, Wol.
