From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 10:40:06 +0100
Message-ID: <ms4qa2-0qa.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > > > Then the probability of an error occuring UNdetected on a n-disk raid
> > > > array is
> > > > 
> > > >        (n-1)p + np'
> > > >   
> > 
> > > The probability of an event occurring lies between 0 and 1 inclusive.
> > > You have given a formula for a probability which could clearly evaluate
> > > to a number greater than 1.  So it must be wrong.
> > 
> > The hypothesis here is that p is vanishingly small.  I.e. this is a Poisson
> > distribution - the analysis assumes that only one event can occcur per
> > unit time.  Take the unit too be one second if you like.  Does that make
> > it true enough for you?
> 
> Sorry, I didn't see any such hypothesis stated and I don't like to
> assUme.

You don't have to. It is conventional. It doesn't need saying.


> So what you are really saying is that:
>   for sufficiently small p and p' (i.e. p-squared terms can be ignored)
>   the probability of an error occurring undetected approximates
>      (n-1)p + np'
> 
> this may be true, but I'm still having trouble understanding what your
> p and p' really mean.

Examine your conscience. They're dependent on you. All I say is that
they exist. They represent two different classes of error, one
detectible by whatever thing like fsck you run as an "experiment", and
one not.

But you are right in that I have been sloppy about defining what I
mean. For one thing I have mixed probailities "per unit time" and
multiplied them by probabilities associated with a single observation
(your experiment with fsck or whatever) made at a certain moment. I do
that because I know that it would make no difference if I integrated up
the the instantaneous probabilities and then multiplied.

Thus if you want to be more formal, you want to stick some integral
signs in and get (n-1) /p dt  + n /p' dt. Or if you wanted to calculate
in terms of mean times to a detected event, well, you'd modify that
again. But the principle remains the same: the probability of a single
undetectible error rises in proportion to the number of disks n, and the
probability of a detectible error going undetected rises in proportion
to n-1, because your experiment to detect the error will only test one
of the possible disks at the crucial point.


> > I mean an error occurs that can be detected (by the experiment you run,
> > which is prsumably an fsck, but I don't presume to dictate to you).
> > 
> 
> The whole point of RAID is that fsck should NEVER see any error caused
> by drive failure.

Then I guess you have helped clarify to yourself what type of errors
falls in which class! Apparently errors caused by drive failure fall in
the class of "indetectible error" for you!

But in any case, you are wrong, because it is quite possible for an
error to spontaneously arise on a disk which WOULD be detected by fsck.
What does fsck detect normally if it is not that! 


> I think we have a major communication failure here, because I have no
> idea what sort of failure scenario you are imagining.

I am not imagining. It is up to you.


> > Likewise, I don't know. It's whatever error your experiment
> > (presumably an fsck) will miss.
> 
> But 'fsck's primary purpose is not to detect errors on the disk. 

Of course it is (it does not mix and make cakes - it precisely and
exactly detects errors on the disk it is run on, and repairs the
filesystem to either work around those errors, or repairs the errors
themselves).

> It is
> to repair a filesystem after an unclean shutdown.

Those are "errors on the disk". It is of no interest to fsck how they
are caused. Fsck simply has a certain capacity for detecting anomalies
(and fixing them). If you have a better test than fsck, by all means
run it!

> It can help out a
> bit after disk corruption, but usually disk corruption (apart from
> very minimal problems) causes fsck to fail to do anything useful.

I would have naively said you were right simply by the real estate
argument - fsck checks only metadata, and metadata occupies abut 1% of
the disk real estate only.

Nevertheless experience suggests that it is very good at detecting when
strange _physical_ things have happened on the disk - I presume that is
because physical strangenesses affect a block or two at a time, and are
much more likely than a bit error to hit some metadata amongst that.
Certainly single bit errors occur relatively undetected by fsck (in
conformity with the real estate argument), as I know because I check
the md5sums of all files on all machines daily, and they change
spontaneously without human intervention :).  In readonly areas!  (the
rate is probably about 1 bit per disk per three months, on average, but
I'd have to check that to see if my estimate from memory is accurate).

Fsck never finds those. But I do. Shrug - so our definitions of
detectible and undetectible error are different. 

> > They happen all the time - just write a 1 to disk A and a zero to disk
> > B in the middle of the data in some file, and you will have an
> > undetectible error (vis a vis your experimental observation, which is
> > presumably an fsck).
> 
> But this doesn't happen.  You *don't* write 1 to disk A and 0 to disk
> B.

Then write a 1 to disk A and DON'T write a 1 to disk B, but do it over a
patch where there is a 0 already.  There is no need for you to make such
hard going of this! Invent your own examples, please.

> I admit that this can actually happen occasionally (but certainly not

It happens EVERY time I choose to do it. Or a software agent of my
choice decides to do it :). I decide to do it with probability p' (;-).
Call me Murphy. Or Maxwell.

> "all the time"). But when it does, there will be subsequent writes to
> both A and B with new, correct, data.  During the intervening time

There may or there may not - but if I wish it there will not. I don't
see why you have such trouble!

> that block will not be read from A or B.

You are imagining some particular mechanism that I, and I presume the
rest of us, are not.  I think you are thinking of raid and how it works.
Please clean your thoughts of it ..  this part of the argument has
nothing particularly to do with raid or any implementation of it.  It is
more generic than that.  It is simply the probability of something going
"wrong" on n disks and the question of whether you can detect that
wrongness with some particular test of yours (and HERE is where raid is
slightly involved) that only reads from one of the n disks for each
block that it does read.

> If there is a system crash before correct, consistent data is written,

Exactly.

> then on restart, disk B will not be read at all until disk A as been

Why do you think so? I know of no mechanism in RAID that records to
which of the two disks paired data has been written and to which it has
not!

Please clarify - this is important. If you are thinking of the "event
count" that is stamped on the superblocks, that is only updated from
time to time as far as I know! Can you please specify (for my
curiousity) exactly when it is updated? That would be useful to know.

> completely copied on it.
> 
> So again, I fail to see your failure scenario.

Try harder! Neil, there is no need for you to make such hard going of
it! If you like, pay a co-worker to put a 1 on one disk and a 0 on
another, and see if you can detect it! Errors arise spontaneously on
disks, and and then there are errors caused by being written by
overheated cpus which write a 1 where they meant a 0, just before dying,
and then there are errors caused by stuck bits in RAM, and so on.  And
THEN there are errors caused by wrting ONE of a pair of paired writes to
a mirror pair, just before the system crashes.

It is not hard to think of such things.



> > > or high level software error (i.e. the wrong data was written - and
> > > that doesn't really count).
> > 
> > It counts just fine, since it's what does happen :- consider a system
> > crash that happens AFTER one of a pair of writes to the two disk
> > components has completed, but BEFORE the second has completed.  Then on
> > reboot your experiment (an fsck) has the task of finding the error
> > (which exists at least as a discrepency between the two disks), if it
> > can, and shouting at you about it.
> 
> No.  RAID will not let you see that discrepancy

Of course it won't - that's the point. Raid won't even know it's there!

> and will not let the
> discrepancy last any longer that it takes to read on drive and write
> the other.

WHICH drive does it read and which does it write? It ha no way of
knowing which, does it?

> Maybe I'm beginning to understand your failure scenario.
> It involves different data being written to the drives. Correct?

That is one possible way, sure. But the error on the drive can also
change spontaneously! Look, here are some outputs from the daily md5sum
run on a group of identical machines:


/etc/X11/fvwm2/menudefs.hook: (7) b4262c2eea5fa82d4092f63d6163ead5
   : lm003 lm005 lm006 lm007 lm008 lm009 lm010
/etc/X11/fvwm2/menudefs.hook: (1) 36e47f9e6cde8bc120136a06177c2923
   : lm011
  
That file on one of them mutated overnight.

> That only happens if:
>   1/ there is a software error
>   2/ there is an admin error

And if there is a hardware error. Hardware can do what it likes.
Anyway, I don't care HOW.

> You seem to be saying that if this happens, then raid is less reliable
> than non-raid.

No, I am saying nothing of the kind. I am simply pointing at the
probabilities.

> There may be some truth in this, but it is irrelevant.
> The likelyhood of such a software error or admin error happening on a
> well-managed machine is substantially less than the likelyhood of a
> drive media error, and raid will protect from drive media errors.

No it won't! I don't know why you say this either - oh, your definition
of "error" must be "when the drive returns a failure for a sector or
block  read". Sorry, I don't mean anything so specific. I mean anything
at all that might be considered an error, such as the mutating bits in
the daily check shown above. 

> So using raid might reduce reliability in a tiny number of cases, but
> will increase it substantially in a vastly greater number of cases.

Look at the probabilities, nothing else.

Peter

