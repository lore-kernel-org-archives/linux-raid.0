From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Tue, 16 May 2017 11:33:50 +0100
Message-ID: <591AD58E.6090408@youngman.org.uk>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
 <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/05/17 23:31, Phil Turmel wrote:
> On 05/15/2017 09:44 AM, Wols Lists wrote:
>> On 15/05/17 12:11, Nix wrote:
>>> I think the point here is that we'd like some way to recover that lets
>>> us get back to the most-likely-consistent state. However, on going over
>>> the RAID-6 maths again I think I see where I was wrong. In the absence
>>> of P, Q, P *or* Q or one of P and Q and a data stripe, you can
>>> reconstruct the rest, but the only reason you can do that is because
>>> they are either correct or absent: you can trust them if they're there,
>>> and you cannot mistake a missing stripe for one that isn't missing.
>>
>> The point of Peter Anvin's paper, though, was that it IS possible to
>> correct raid-6 if ONE of P, Q, or a data stripe is corrupt.
> 
> If and only if it is known that all but the supposedly corrupt block
> were written together (complete stripe) and no possibility of
> perturbation occurred between the original calculation of P,Q in the CPU
> and original transmission of all of these blocks to the member drives.

NO! This is a "can't see the wood for the trees" situation. If one block
in a raid-6 is corrupt, we can correct it. That's maths, that's what the
maths says, and it is not only possible, but *definite*.

WHAT caused the corruption, and HOW, is irrelevant. The only requirement
is that *just one block is lost*. If that's the case we can recover.
> 
> Since incomplete writes and a whole host of hardware corruptions are
> known to happen, you *don't* have enough information to automatically
> repair.

And I would guess that in most of the cases you are talking about, it's
not just one block that is lost. In that case we don't have enough
information to repair, full stop! And if I feed it into Peter's equation
the result would be nonsense so I wouldn't bother trying. (As in, I
would feed it into Peter's equation, but I'd stop there.)
> 
> The only unambiguous signal MD raid receives that a particular block is
> corrupt is an Unrecoverable Read Error from a drive.  MD fixes these
> from available redundancy.  All other sources of corruption require
> assistance from an upper layer or from administrator input.
> 
> There's no magic wand, Wol.
> 
I know there isn't a magic wand. BUT. What is the chance of a
multi-block corruption looking like a single-block error? Pretty low I
think, and according to Peter Anvin's paper it gives off some pretty
clear signals that "something's not right".

At the end of the day, as I see it, MD raid *can* do data integrity. So
if the user thinks the performance hit is worth it, why not?

MD raid *can* do data recovery. So why not?

And yes, given the opportunity I will write it myself. I just have to be
honest and say my family situation interferes with that desire fairly
drastically (which is why I've put a lot of effort in elsewhere, that
doesn't require long stretches of concentration).

All your scenarios you are throwing at me, can you come up with ANY that
will BOTH corrupt more than one block AND make it look like a single
block error? As I look at it, I will only bother correcting errors that
look correctable. Which means, in probably 99.9% of cases, I get it
right. (And if I don't bother, the data's lost, anyway!)

Looked at from the other side, IFF we have a correctable error, and fix
it by recalculating P & Q, that gives us AT BEST a 50% chance of getting
it right, and it gets worse the more disks we have. Especially if our
problem is that something has accidentally stomped on just one disk. Or
that we've got several dodgy disks that we've had to ddrescue...


Neil mentioned elsewhere that he's not sure about btrfs and zfs. Can
they actually do data recovery, or just data integrity? And I'm on the
opensuse mailing list. I would NOT say btrfs is ready for the
casual/naive user. I suspect most of the smoke on the mailing list is
people who've been burnt in the past, but there still seems to be a
trickle of people reporting "an update ate my root partition". For which
the usual advice seems to be "reformat and reinstall" :-(

Cheers,
Wol
