From: Phil Turmel <philip@turmel.org>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Tue, 16 May 2017 11:31:16 -0400
Message-ID: <1bccccd1-1ff8-1cb3-492e-42468a3c8a8f@turmel.org>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
 <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
 <591AD58E.6090408@youngman.org.uk>
 <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
 <591B125A.1000307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <591B125A.1000307@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/16/2017 10:53 AM, Wols Lists wrote:

> I'll give a car example. I'm talking about a car in a ditch. You're
> talking about a motorway pile-up AND YOU'RE ASSUMING I CAN'T TELL THE
> DIFFERENCE. That's why I'm getting so frustrated!

You clearly cannot.

> Please LOOK AT THE MATHS of my scenario.

It's not a math problem.  I'm quite familiar with the math, as a matter
of fact.  Galois fields are exceedingly cool for a math geek like me.

> First thing we do is read the entire stripe.

A substantial performance degradation, right out of the gate...

> IF the integrity check passes, we return the data. If it fails and our
> raid can't reconstruct (two-disk mirror, raid-4, raid-5) we return an error.

Where we currently return the data and let the upper layer decide its
value.  An error here is a regression in my book.

> Second - we now have a stripe that fails integrity, so we pass it
> through Peter's equation. If it returns "one block is corrupt and here's
> the correct version" we return the correct version. If it returns "can't
> solve the equation - too many unknowns" we return a read error.

Changing the data returned from what was written is another regression
in my book. Since the drive not returning a read error is far more
significant indication that the data is correct than a mismatch saying
its wrong.

> We *have* to assume that if the stripe passes the integrity check that
> it's correct - but we could have had an error that fools the integrity
> check! We just assume it's highly unlikely.

If the data blocks are successfully read from there drives, we *have* to
assume they're correct.  There are so many zeroes between the decimal
point and the first significant digit of that error probability that a
physical explanation elsewhere is a virtual certainty.

> What is the probability that Peter's equation screws up? We *KNOW* that
> if only one block is corrupt, that it will ALWAYS SUCCESSFULLY correct
> it. And from reading the paper, it seems to me that if *more than one*
> block is corrupt, it will detect it with over 99.9% accuracy.

No.  We don't.  We have a highly reliable drive saying the data is
correct versus a *system* of reads and writes spread over multiple
physical systems and spread over time that has a constellation of
failure modes, any one of which could have created the situation at hand.

Software flaws galore, particularly incomplete stripe writes.  Power
problems truncating stripe writes.  System memory bit flips.  PCIe
uncaught transmission errors.  Controller buffer memory bit flips.  SATA
or SAS transmission errors.

All of the above are rare.  But not anywhere near as rare as an
undetected sector read error.  MD cannot safely fix this automatically,
and shouldn't.  And with the performance hit, it is actively stupid.

And I'm done arguing.

Phil
