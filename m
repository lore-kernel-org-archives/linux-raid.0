From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 17:18:29 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050103170449.22620A-100000@Maggie.Linux-Consulting.com>
References: <jh4pa2-pi.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jh4pa2-pi.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 4 Jan 2005, Peter T. Breuer wrote:

> Neil Brown <neilb@cse.unsw.edu.au> wrote:

> > > Let 
> > > 
> > >    p = probability of a detectible error occuring on a disk in a unit time
> > >    p'= ................ indetectible .....................................
> > > 

i think the definitions and modes of failures is what each reader is
interpretting from their perspective ??

> > think, the branch of mathematics that has the highest ratio of people
> > who think that understand it to people to actually do (witness the
> > success of lotteries).

ahh ... but the stock market is the worlds largest casino
 
> Possibly. But not all of them teach probability at university level
> (and did so when they were 21, at the University of Cambridge to boot,
> and continued teaching pure math there at all subjects and all levels
> until the age of twenty-eight - so puhleeeze don't bother!).

:-)
  
> I mean an error occurs that can be detected (by the experiment you run,
> which is prsumably an fsck, but I don't presume to dictate to you).

or more simply, the disk doesnt work .. what you write is not what you get
back ??
	- below that level, there'd be crc errors, some fixable
	some not
	- below that, there'd be disk controller problems with
	bad block mapping and temperature sensitive failures
	- below that ... flaky heads and platters and oxide ..

> > Is it a bit
> > getting flipped on the media, or the drive detecting a CRC error
> > during read?

different error conditions ...
	- bit flipping is trivially fixed ...
	and the user probasbly doesnt know about it

	- crc error of 1 bit error or 2 bit error or burst errors 
	( all are different crc errors and ecc problems )
 
> I don't know. It's whatever your test can detect. You can tell me!

i think most people only care about ... can we read the "right data"
back some time later after we had previously written it
"supposedly correctly"

> > And what is your senario for an undetectable error happening?

there's lots of undetectable errors ...

there's lots of detectable errors that was fixed, so that the user
doesnt know abut the underlying errors

> Likewise, I don't know. It's whatever error your experiment
> (presumably an fsck) will miss.

fsck is too high a level to be worried about errors...
	- it assume the disk is workiing fine
	and fsck fixes the filesystem inodes and doesnt worry
	about "disk errors"
 
> > My
> > understanding of drive technology and CRCs suggests that undetectable
> > errors don't happen without some sort of very subtle hardware error,

some crc ( ecc ) will fix it ... some errors are Not fixable

"crc" is not used too much ... ecc is used ...

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

a common problem ... that data is partially written during a crash

very hard to fix .. without knowing what the data should have been
 
> All I am saying is that the error is either detectible by your
> experiment (the fsck), or not.

or detectable/undetectable/fixable by other "methods"

 If it IS detectible, then there
> is a 50% chance that it WON'T be deetcted,

that'd depend on what the failure mode was ..

> even though it COULD be
> detected, because the system unfortunately chose to read the wrong
> disk at that moment.

the assumption is that if one writes data ... that the crc/ecc is
written somewhere else that is correct or vice versa, but both
could be written wrong

> And if it is not detectible, it's still twice as likely as with one
> disk, for the same reason - more real estate for it to happen on.

more "(disk) real estate" increases the places where errors can 
occur ... 

but todays, disk drives is lots lots better than the old days

and todays dd copying of disk might work, but doing dd on
old disks w/ bad oxides will create lots of problems ...

==
== fun stuff ... how do you make your data more secure ...
== and reliable
==

c ya
alvin


