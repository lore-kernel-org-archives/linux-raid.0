From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 13:07:18 +1100
Message-ID: <16857.64086.362458.177296@cse.unsw.edu.au>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es>
	<l1nna2-e9i.ln1@news.it.uc3m.es>
	<200501031846.42950.maarten@ultratux.net>
	<200501032052.21459.maarten@ultratux.net>
	<a9noa2-o12.ln1@news.it.uc3m.es>
	<fh0pa2-kvp.ln1@news.it.uc3m.es>
	<16857.55609.534526.297577@cse.unsw.edu.au>
	<jh4pa2-pi.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday January 4
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > > Then the probability of an error occuring UNdetected on a n-disk raid
> > > array is
> > > 
> > >        (n-1)p + np'
> > >   
> 
> > The probability of an event occurring lies between 0 and 1 inclusive.
> > You have given a formula for a probability which could clearly evaluate
> > to a number greater than 1.  So it must be wrong.
> 
> The hypothesis here is that p is vanishingly small.  I.e. this is a Poisson
> distribution - the analysis assumes that only one event can occcur per
> unit time.  Take the unit too be one second if you like.  Does that make
> it true enough for you?

Sorry, I didn't see any such hypothesis stated and I don't like to
assUme.

So what you are really saying is that:
  for sufficiently small p and p' (i.e. p-squared terms can be ignored)
  the probability of an error occurring undetected approximates
     (n-1)p + np'

this may be true, but I'm still having trouble understanding what your
p and p' really mean.

> > You have also been very sloppy in your language, or your definitions.
> > What do you mean by a "detectable error occurring"? 
> 
> I mean an error occurs that can be detected (by the experiment you run,
> which is prsumably an fsck, but I don't presume to dictate to you).
> 

The whole point of RAID is that fsck should NEVER see any error caused
by drive failure.
I think we have a major communication failure here, because I have no
idea what sort of failure scenario you are imagining.


> > Is it a bit
> > getting flipped on the media, or the drive detecting a CRC error
> > during read?
> 
> I don't know. It's whatever your test can detect. You can tell me!
> 
> > And what is your senario for an undetectable error happening?
> 
> Likewise, I don't know. It's whatever error your experiment
> (presumably an fsck) will miss.

But 'fsck's primary purpose is not to detect errors on the disk.  It is
to repair a filesystem after an unclean shutdown.  It can help out a
bit after disk corruption, but usually disk corruption (apart from
very minimal problems) causes fsck to fail to do anything useful.


> 
> > My
> > understanding of drive technology and CRCs suggests that undetectable
> > errors don't happen without some sort of very subtle hardware error,
> 
> They happen all the time - just write a 1 to disk A and a zero to disk
> B in the middle of the data in some file, and you will have an
> undetectible error (vis a vis your experimental observation, which is
> presumably an fsck).

But this doesn't happen.  You *don't* write 1 to disk A and 0 to disk
B.

I admit that this can actually happen occasionally (but certainly not
"all the time"). But when it does, there will be subsequent writes to
both A and B with new, correct, data.  During the intervening time
that block will not be read from A or B.
If there is a system crash before correct, consistent data is written,
then on restart, disk B will not be read at all until disk A as been
completely copied on it.

So again, I fail to see your failure scenario.


> 
> > or high level software error (i.e. the wrong data was written - and
> > that doesn't really count).
> 
> It counts just fine, since it's what does happen :- consider a system
> crash that happens AFTER one of a pair of writes to the two disk
> components has completed, but BEFORE the second has completed.  Then on
> reboot your experiment (an fsck) has the task of finding the error
> (which exists at least as a discrepency between the two disks), if it
> can, and shouting at you about it.

No.  RAID will not let you see that discrepancy, and will not let the
discrepancy last any longer that it takes to read on drive and write
the other.

> 
> All I am saying is that the error is either detectible by your
> experiment (the fsck), or not. If it IS detectible, then there
> is a 50% chance that it WON'T be deetcted, even though it COULD be
> detected, because the system unfortunately chose to read the wrong
> disk at that moment. However, the error is twice as likely as with only
> one disk, whatever it is (you can argue aboutthe real multiplier, but
> it is about that).
> 
> And if it is not detectible, it's still twice as likely as with one
> disk, for the same reason - more real estate for it to happen on.

Maybe I'm beginning to understand your failure scenario.
It involves different data being written to the drives. Correct?

That only happens if:
  1/ there is a software error
  2/ there is an admin error

You seem to be saying that if this happens, then raid is less reliable
than non-raid.
There may be some truth in this, but it is irrelevant.
The likelyhood of such a software error or admin error happening on a
well-managed machine is substantially less than the likelyhood of a
drive media error, and raid will protect from drive media errors.
So using raid might reduce reliability in a tiny number of cases, but
will increase it substantially in a vastly greater number of cases.

NeilBrown
