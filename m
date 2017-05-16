From: Phil Turmel <philip@turmel.org>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Tue, 16 May 2017 10:17:54 -0400
Message-ID: <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
 <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
 <591AD58E.6090408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <591AD58E.6090408@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/16/2017 06:33 AM, Wols Lists wrote:
> On 15/05/17 23:31, Phil Turmel wrote:

>> If and only if it is known that all but the supposedly corrupt block
>> were written together (complete stripe) and no possibility of
>> perturbation occurred between the original calculation of P,Q in the CPU
>> and original transmission of all of these blocks to the member drives.
> 
> NO! This is a "can't see the wood for the trees" situation.

You can shout NO all you want, and make inapplicable metaphors, but you
are still wrong.

> If one block
> in a raid-6 is corrupt, we can correct it. That's maths, that's what the
> maths says, and it is not only possible, but *definite*.

The math has preconditions.  If the preconditions are unmet, or unknown,
you cannot use the math.

> WHAT caused the corruption, and HOW, is irrelevant. The only requirement
> is that *just one block is lost*. If that's the case we can recover.

WHAT and HOW are the preconditions to the math.  The algorithm you seek
exists as a userspace utility that an administrator can use after
suitable analysis of the situation.  Feel free to script a call to that
utility on *your* system whenever your check scrub signals a mismatch.

> At the end of the day, as I see it, MD raid *can* do data integrity. So
> if the user thinks the performance hit is worth it, why not?

You are seeing a mirage due to a naive application of the math.

> MD raid *can* do data recovery. So why not?

It *cannot* do it for reasons many of us have tried to explain.  Sorry.

> And yes, given the opportunity I will write it myself. I just have to be
> honest and say my family situation interferes with that desire fairly
> drastically (which is why I've put a lot of effort in elsewhere, that
> doesn't require long stretches of concentration).

As I said to Nix, no system administrator who cares about their data
will touch a kernel that includes such a patch.

Phil
