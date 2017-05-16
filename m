From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Tue, 16 May 2017 15:53:14 +0100
Message-ID: <591B125A.1000307@youngman.org.uk>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
 <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
 <591AD58E.6090408@youngman.org.uk>
 <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/05/17 15:17, Phil Turmel wrote:
> On 05/16/2017 06:33 AM, Wols Lists wrote:
>> On 15/05/17 23:31, Phil Turmel wrote:
> 
>>> If and only if it is known that all but the supposedly corrupt block
>>> were written together (complete stripe) and no possibility of
>>> perturbation occurred between the original calculation of P,Q in the CPU
>>> and original transmission of all of these blocks to the member drives.
>>
>> NO! This is a "can't see the wood for the trees" situation.
> 
> You can shout NO all you want, and make inapplicable metaphors, but you
> are still wrong.
> 
>> If one block
>> in a raid-6 is corrupt, we can correct it. That's maths, that's what the
>> maths says, and it is not only possible, but *definite*.
> 
> The math has preconditions.  If the preconditions are unmet, or unknown,
> you cannot use the math.
> 
>> WHAT caused the corruption, and HOW, is irrelevant. The only requirement
>> is that *just one block is lost*. If that's the case we can recover.
> 
> WHAT and HOW are the preconditions to the math.  The algorithm you seek
> exists as a userspace utility that an administrator can use after
> suitable analysis of the situation.  Feel free to script a call to that
> utility on *your* system whenever your check scrub signals a mismatch.

Which is where you can't see the wood from the trees. WHAT and HOW are
*physical* things, therefore they CAN'T have anything to do with pure maths.

The precondition is that we are dealing with only one bad block. That
*IS* the mathematical equivalent of what you are saying. We have two
unknowns - which block is corrupt, and what its original value was. You
can handwave all you like, but at the moment all you're saying is that
Peter doesn't know his maths.

PLEASE *either* treat it as a *maths* problem - in which case you can't
appeal to hardware, *or* treat it as a *physical* problem, in which case
we are arguing at cross purposes.
> 
>> At the end of the day, as I see it, MD raid *can* do data integrity. So
>> if the user thinks the performance hit is worth it, why not?
> 
> You are seeing a mirage due to a naive application of the math.

No. *Maths* and *reality* are NOT the same thing.
> 
>> MD raid *can* do data recovery. So why not?
> 
> It *cannot* do it for reasons many of us have tried to explain.  Sorry.
> 
>> And yes, given the opportunity I will write it myself. I just have to be
>> honest and say my family situation interferes with that desire fairly
>> drastically (which is why I've put a lot of effort in elsewhere, that
>> doesn't require long stretches of concentration).
> 
> As I said to Nix, no system administrator who cares about their data
> will touch a kernel that includes such a patch.
> 
I'll give a car example. I'm talking about a car in a ditch. You're
talking about a motorway pile-up AND YOU'RE ASSUMING I CAN'T TELL THE
DIFFERENCE. That's why I'm getting so frustrated!

Please LOOK AT THE MATHS of my scenario.

First thing we do is read the entire stripe.

IF the integrity check passes, we return the data. If it fails and our
raid can't reconstruct (two-disk mirror, raid-4, raid-5) we return an error.

Second - we now have a stripe that fails integrity, so we pass it
through Peter's equation. If it returns "one block is corrupt and here's
the correct version" we return the correct version. If it returns "can't
solve the equation - too many unknowns" we return a read error.

We *have* to assume that if the stripe passes the integrity check that
it's correct - but we could have had an error that fools the integrity
check! We just assume it's highly unlikely.

What is the probability that Peter's equation screws up? We *KNOW* that
if only one block is corrupt, that it will ALWAYS SUCCESSFULLY correct
it. And from reading the paper, it seems to me that if *more than one*
block is corrupt, it will detect it with over 99.9% accuracy.

So the *ONLY* way my algorithm can screw up, is if Peter's algorithm
wrongly thinks a multiple-block is a single-block corruption, which by
my simple maths has a probability of about 0.025% !!!

Please can you present me with a PLAUSIBLE scenario where Peter's
algorithm will screw up. And mere handwaving won't do it, because I CAN,
and ALMOST CERTAINLY WILL, detect the motorway pile-up scenario you're
going on about, and I will treat it exactly the way you do - punt it up
to manual intervention.

Cheers,
Wol
