From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 01:28:03 +0100
Message-ID: <jh4pa2-pi.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > > No, call it "p". That is the correct name. And I presume you mean "an
> > > error", not "a failure".
> > 
> > I'll do this thoroughly, so you can see how it goes.
> > 
> > Let 
> > 
> >    p = probability of a detectible error occuring on a disk in a unit time
> >    p'= ................ indetectible .....................................
> > 
> > Then the probability of an error occuring UNdetected on a n-disk raid
> > array is
> > 
> >        (n-1)p + np'
> >   
> > and on a 1 disk system (a 1-disk raid array :) it is
> > 
> >        p'
> > 
> > OK? (hey, I'm a mathematician, it's obvious to me).
> 
> It may be obvious, but it is also wrong.

No, it's quite correct.

> But then probability is, I
> think, the branch of mathematics that has the highest ratio of people
> who think that understand it to people to actually do (witness the
> success of lotteries).

Possibly. But not all of them teach probability at university level
(and did so when they were 21, at the University of Cambridge to boot,
and continued teaching pure math there at all subjects and all levels
until the age of twenty-eight - so puhleeeze don't bother!).

> The probability of an event occurring lies between 0 and 1 inclusive.
> You have given a formula for a probability which could clearly evaluate
> to a number greater than 1.  So it must be wrong.

The hypothesis here is that p is vanishingly small.  I.e. this is a Poisson
distribution - the analysis assumes that only one event can occcur per
unit time.  Take the unit too be one second if you like.  Does that make
it true enough for you?

Poisson distros are pre-A level math.

> You have also been very sloppy in your language, or your definitions.
> What do you mean by a "detectable error occurring"? 

I mean an error occurs that can be detected (by the experiment you run,
which is prsumably an fsck, but I don't presume to dictate to you).

> Is it a bit
> getting flipped on the media, or the drive detecting a CRC error
> during read?

I don't know. It's whatever your test can detect. You can tell me!

> And what is your senario for an undetectable error happening?

Likewise, I don't know. It's whatever error your experiment
(presumably an fsck) will miss.

> My
> understanding of drive technology and CRCs suggests that undetectable
> errors don't happen without some sort of very subtle hardware error,

They happen all the time - just write a 1 to disk A and a zero to disk
B in the middle of the data in some file, and you will have an
undetectible error (vis a vis your experimental observation, which is
presumably an fsck).

> or high level software error (i.e. the wrong data was written - and
> that doesn't really count).

It counts just fine, since it's what does happen :- consider a system
crash that happens AFTER one of a pair of writes to the two disk
components has completed, but BEFORE the second has completed.  Then on
reboot your experiment (an fsck) has the task of finding the error
(which exists at least as a discrepency between the two disks), if it
can, and shouting at you about it.

All I am saying is that the error is either detectible by your
experiment (the fsck), or not. If it IS detectible, then there
is a 50% chance that it WON'T be deetcted, even though it COULD be
detected, because the system unfortunately chose to read the wrong
disk at that moment. However, the error is twice as likely as with only
one disk, whatever it is (you can argue aboutthe real multiplier, but
it is about that).

And if it is not detectible, it's still twice as likely as with one
disk, for the same reason - more real estate for it to happen on.

This is just elementary operational research!

Peter

