From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 21:41:46 +0100
Message-ID: <a9noa2-o12.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> Just for laughs, I calculated this chance also for a three-way raid-1 setup 

There's no need for you to do this - your calculations are
unfortunately not meaningful.

> Let us (randomly) assume there is a 10% chance of a disk failure.

No, call it "p". That is the correct name. And I presume you mean "an
error", not "a failure".

> We therefore have eight possible scenarios:

Oh, puhleeeeze.  Infantile arithmetic instead of elementary probabilistic
algebra is not something I wish to suffer through ...

> A
> disk1 fail
> disk2 good
> disk3 good

 ...

> H
> disk1 good
> disk2 good
> disk3 good

Was that all? 8 was it? 1 all good, 3 with one good, 3 with two good, 1
with all fail? Have we got the binomial theorem now!

> Scenarios A, B and C are similar (one disk failed).

Hoot. 3p.

> Scenario's D, E and F are 
> also similar (two disk failures). 

There is no need for you to consider these scenarios. The probability
is 3p^2, which is tiny. Forget it. (actually 3p^2(1-p), but forget the
cube term).

> Scenarios G and H are special, the chances 
> of that occurring are calculated seperately.

No, they are NOT special. one of them is the chance that everything is
OK, which is (1-p)^3, or approx 1-3p (surprise surprise). The other is
the completely forgetable probaility p^3 that all three are bad at that
spot.


> H: the chance of all good disks is (0.9x0.9x0.9) = 0.729

Surprisingly enough, 1-3p, even though you have such improbably large
probability p as to make the approximation only approximate!  Puhleeze.
This is excruciatingly poor baby math!

> G: the chance of all disks bad is (0.1x0.1x0.1) = 0.001

Surprise. p^3.

> The chance of A, B or C (one bad disk) is (0.9x0.9x0.1) = 0.081
> The chance of D, E or F (two bad disks) is (0.9x0.1x0.1) = 0.009
> 
> The chance of (A, B or C) and (D, E or F) occurring must be multiplied by 
> three as there are three scenarios each. So this becomes: 
> The chance of one bad disk is = 0.243
> The chance of two bad disks is = 0.027

Surprise, surprise. 3p and 3p^2(1-p)  (well, call it 3p^2).

> Now let's see. It is certain that the raid subsystem will read the good data 
> in H. The chance of that in scenario G is zero. The chance in (A, B or C) is 
> two-thirds. And for D, E or F the chance the raid system getting the good 
> data is one-third.
> 
> Let's calculate all this.
> [ABC] x 0.667 = 0.243 x 0.667 = 0.162
> [DEF] x 0.333 = 0.027 x 0.333 = 0.008
> [G] x 0 = 0.0 
> [H] x 1.0 = 0.729
> 
> (total added up is 0.9)

The chance  of reading good data is 1 (1-3p) + 2/3 3p
or

Or approx 1-p.
     
Probably exactly so, were I to do the calculation exactly, which I won't.


> Conversely, the chance of reading the BAD data:
> [ABC] x 0.333 = 0.243 x 0.333 = 0.081
> [DEF] x 0.667 = 0.027 x 0.667 = 0.018
> [G] x 1.0 = 0.001 
> [H] x 0.0 = 0.0
> 
> (total added up is 0.1)

It should  be  p! It is one minus your previous result.

SIgh ...      0 (1-3p) + 1/3 3p  = p


> Which, again, is exactly the same chance a single disk will get corrupted, as 
> we assumed above in line one is 10%.  Ergo, using raid-1 does not make the 
> risks of bad data creeping in any worse.  Nor does it make it better either.

All false. And baby false at that. Annoying! Look, the chance of an
undetected detectable failure occuring is

         0 (1-3p) + 2/3 3p

         = 2p

and it grows with the number n of disks, as you may expect, being
proportional to n-1.

With one disk, it is zero.

Peter

