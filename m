From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 18:05:10 -0500
Message-ID: <200501032305.j03N5I915825@www.watkins-home.com>
References: <o4moa2-kfv.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <o4moa2-kfv.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter said:
"Except that it is not the case. With a single disk you are CERTAIN to
detect the problem (if it is detectable) when you run the fsck at reboot."

Guy says:
As a guess, fsck checks less than 1% of the disk.  No user data is checked.
So, virtually all errors would go un-detected.  But a RAID system could
detect the errors.  Any yes, RAID6 could correct a single disk error.  Even
multi disk errors, as long as only 1 error per stripe/block.

Your data center has problems well beyond the worse stories I have ever
heard!  My home systems tend to have much better uptime than any of your
systems.

  5:05pm  up 33 days, 16:31,  1 user,  load average: 0.12, 0.03, 0.01
17:05:20  up 28 days, 15:06,  1 user,  load average: 0.03, 0.04, 0.00

Both were re-booted by me, not some strange failures.  When I re-booted the
first one, it had over 7 months of uptime.  At work I had 2 systems with
over 2 years uptime, and one of them made it to 3 years (yoda).  The 3 year
system was connected to the Internet and was used for customer demos.  So,
very low usage, but the 2 year system (lager) was an internal email server,
test server, router, had Informix, ...  I must admit, I rebooted the 2 year
system by accident!  But it was a proper reboot, not a crash.  The Y2K
patches did not require a re-boot.

This is from an email I sent 10/26/2000:
"Subject: Happy birthday Yoda!
  6:13pm  up 730 days, 23:59,  1 user,  load average: 0.10, 0.12, 0.12
  6:14pm  up 731 days,  1 user,  load average: 0.08, 0.12, 0.12"

It was a leap year!  So 1 extra day.

Sent 7/5/2001:
"Kathy,
    Yoda will be 1000 days up Jul 22 @ 18:14, thats a Sunday.

Guy"

We did give yoda a 3 year birthday party.  It was not my idea.  I told my
wife about the party, my wife baked cupcakes.  Again, not my idea!

We moved to a different building, everything had to be shutdown.
I sent this email 6/20/2002:
"The final up-time report!
Yoda wins with 3.64 years!

Yoda will be shut down in a few minutes!


comet
  4:29pm  up 6 days, 49 mins,  15 users,  load average: 1.31, 0.95, 0.53
trex
  4:31pm  up 38 days, 16:34,  13 users,  load average: 0.04, 0.02, 0.02
yoda
  4:31pm  up 1332 days, 22:17,  0 users,  load average: 0.17, 0.13, 0.12
falcon
  4:31pm  up 38 days, 16:29,  14 users,  load average: 0.00, 0.00, 0.01
right
  4:31pm  up 38 days, 15:42,  7 users,  load average: 2.28, 1.86, 1.68
saturn
  4:31pm  up 16 days,  6:14,  1 user,  load average: 0.01, 0.02, 0.02
citi1
  4:31pm  up 63 days, 23:20,  7 users,  load average: 0.27, 0.23, 0.21
lager
  4:46pm  up 606 days,  1:47,  5 users,  load average: 0.00, 0.00, 0.00

Guy"

As you can see, some of us don't have major problem as you describe.

Oh, somewhere you said you have on-line disk backups.  This is very bad.  If
you had a lighting strike, or fire, it could takeout all of your disks at
the same time.  Your backup copies should be off-site, tape or disk, it does
not matter.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Monday, January 03, 2005 3:22 PM
To: linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

maarten <maarten@ultratux.net> wrote:
> The chance of a PSU blowing up or lightning striking is, reasonably, much
less 
> than an isolated disk failure.  If this simple fact is not true for you 

Oh?  We have about 20 a year.  Maybe three of them are planned.  But
those are the worst ones!  - the electrical department's method of
"testing" the lines is to switch off the rails then pulse them up and
down.  Surge tests or something.  When we can we switch everything off
beforehand.  But then we also get to deal with the amateur contributions
from the city power people.

Yes, my PhD is in electrical engineering. Have I sent them sarcastic
letters explaining  how to test lines using a dummy load? Yes. Does the
physics department also want to place them in a vat of slowly reheating
liquid nitrogen? Yes. Does it make any difference? No.

I should have kept the letter I got back when I asked them exactly WHAT
it was they thought they had been doing when they sent round a pompous
letter explaining how they had been up all night "helping" the town
power people to get back on line, after an outage took out the
half-million or so people round here. Waiting for the phonecall saying
"you can turn it back on now", I think.

That letter was a riot.

I plug my stuff into the ordinary mains myself.  It fails less often
than the "secure circuit" plugs we have that are meant to be wired to
their smoking giant UPS that apparently takes half the city output to
power up.

> personally, you really ought to reevaluate the quality of your PSU (et al)

> and / or the buildings' defenses against a lightning strike...

I don't think so. You can argue with the guys with the digger tool and
a weekend free.

> > However, I don't see how you can expect to replace a failed disk
> > without taking down the system. For that reason you are expected to be
> > running "spare disks" that you can virtually insert hot into the array
> > (caveat, it is possible with scsi, but you will need to rescan the bus,
> > which will take it out of commission for some seconds, which may
> > require you to take the bus offline first, and it MAY be possible with
> > recent IDE buses that purport to support hotswap - I don't know).
> 
> I think the point is not what actions one has to take at time T+1 to
replace 
> the disk, but rather whether at time T, when the failure first occurs, the

> system survives the failure or not.
> 
> > (1) how likely is it that a disk will fail without taking down the
system
> > (2) how likely is it that a disk will fail
> > (3) how likely is it that a whole system will fail
> >
> > I would say that (2) is about 10% per year. I would say that (3) is
> > about 1200% per year. It is therefore difficult to calculate (1), which
> > is your protection scenario, since it doesn't show up very often in the
> > stats!
> 
> I don't understand your math.  For one, percentage is measured from 0 to
100, 

No, it's measured from 0 to infinity.  Occasionally from negative
infinity to positive infinity.  Did I mention that I have two degrees in
pure mathematics?  We can discuss nonstandard interpretations of Peano's
axioms then.

> not from 0 to 1200.  What is that, 12 twelve times 'absolute certainty'
that 
> something will occur ?

Yep.  Approximately.  Otherwise known as the expectaion that twelve
events will occur per year.  One a month.  I would have said "one a
month" if I had not been being precise.

> But besides that, I'd wager that from your list number (3) has, by far,
the 
> smallest chance of occurring.

Except of course, that you would lose, since not only did I SAY that it
had the highest chance, but I gave a numerical estimate for it that is
120 times as high as that I gave for (1).

> Choosing between (1) and (2) is more difficult, 

Well, I said it doesn't matter, because everything is swamped by (3).

> my experiences with IDE disks are definitely that it will take the system 
> down, but that is very biased since I always used non-mirrored swap.

It's the same principle.  There exists a common mode for failure.
Bayesian calculations then tell you that there is a strong liklihood of
the whole system coming down in conjunction with the disk coming down.

> I sure can understand a system dying if it loses part of its memory...
> 
> > > ** A disk failing is the most common failure a system can have (IMO).
> 
> I fully agree.
> 
> > Not in my experience. See above. I'd say each disk has about a 10%
> > failure expectation per year. Whereas I can guarantee that an
> > unexpected  system failure will occur about once a month, on every
> > important system.

There you are. I said it again.

> Whoa !  What are you running, windows perhaps ?!? ;-)

No. Ordinary hardware.

> No but seriously, joking aside, you have 12 system failures per year ?

At a very minimum. Almost none of them caused by hardware.

Hey, I even took down my own home server by accident over new year!
Spoiled its 222 day uptime.

> I would not be alone in thinking that figure is VERY high.  My uptimes 

It isn't.  A random look at servers tells me:

   bajo          up   77+00:23,     1 user,   load 0.28, 0.39, 0.48
   balafon       up   25+08:30,     0 users,  load 0.47, 0.14, 0.05
   dino          up   77+01:15,     0 users,  load 0.00, 0.00, 0.00
   guitarra      up   19+02:15,     0 users,  load 0.20, 0.07, 0.04
   itserv        up   77+11:31,     0 users,  load 0.01, 0.02, 0.01
   itserv2       up   20+00:40,     1 user,   load 0.05, 0.13, 0.16
   lmserv        up   77+11:32,     0 users,  load 0.34, 0.13, 0.08
   lmserv2       up   20+00:49,     1 user,   load 0.14, 0.20, 0.23
   nbd           up   24+04:12,     0 users,  load 0.08, 0.08, 0.02
   oboe          up   77+02:39,     3 users,  load 0.00, 0.00, 0.00
   piano         up   77+11:55,     0 users,  load 0.00, 0.00, 0.00
   trombon       up   24+08:14,     2 users,  load 0.00, 0.00, 0.00
   violin        up   77+12:00,     4 users,  load 0.00, 0.00, 0.00
   xilofon       up   73+01:08,     0 users,  load 0.00, 0.00, 0.00
   xml           up   33+02:29,     5 users,  load 0.60, 0.64, 0.67

(one net). Looks like a major power outage 77 days ago, and a smaller
event 24 and 20 days ago. The event at 20 days ago looks like
sysadmins. Both Trombon and Nbd survived it and tey're on separate
(different) UPSs. The servers which are up 77 days are on a huge UPS
that Lmserv2 and Itserv2 should also be on, as far as I know. So
somebody took them off the UPS wihin ten minutes of each other. Looks
like maintenance moving racks.

OK, not once every month, more like between onece every 20 days and
once every 77 days, say once every 45 days.


> generally are in the three-digit range, and most *certainly* not in the
low 
> 2-digit range. 

Well, they have no chance to be here. There are several planned power
outs a year for the electrical department to do their silly tricks
with. When that happens they take the weekend over it.

> > If you think about it that is quite likely, since a system is by
> > definition a complicated thing. And then it is subject to all kinds of
> > horrible outside influences, like people rewiring the server room in
> > order to reroute cables under the floor instead of through he ceiling,
> > and the maintenance people spraying the building with insecticide,
> > everywhere, or just "turning off the electricity in order to test it"
> > (that happens about four times a year here - hey, I remember when they
> > tested the giant UPS by turning off the electricity! Wrong switch.
> > Bummer).
> 
> If you have building maintenance people and other random staff that can
access 
> your server room unattended and unmonitored, you have far worse problems
than 
> making decicions about raid lavels.  IMNSHO.   

Oh, they most certainly can't access the server rooms. The techs would
have done that on their own, but they would (obviously) have needed to
move the machines for that, and turn them off. Ah . But yes, the guy
with the insecticide has the key to everywhere, and is probably a
gardener. I've seen him at it. He sprays all the corners of the
corridors, along the edge of the wall and floor, then does the same
inside the rooms.

The point is that most foul-ups are created by the humans, whether
technoid or gardenoid, or hole-diggeroid.

> By your description you could almost be the guy the joke with the
recurring 7 
> o'clock system crash is about (where the cleaning lady unplugs the server 
> every morning in order to plug in her vacuum cleaner) ;-) 

Oh, the cleaning ladies do their share of damage. They are required BY
LAW to clean the keyboards. They do so by picking them up in their left
hand at the lower left corner, and rubbing a rag over them.

Their left hand is where the ctl and alt keys are.

Solution is not to leave keyboard in the room. Use a whaddyamacallit
switch and attach one keyboard to that whenever one needs to access
anything.. Also use thwapping great power cables one inch thck that
they cannot move.

And I won't mention the learning episodes with the linux debugger monitor
activated by pressing "pause".

Once I watched the lady cleaning my office. She SPRAYED the back of the
monitor! I YELPED! I tried to explain to her about voltages, and said
that she would't clean her tv at home that way - oh yes she did!

> > Yes, you can try and keep these systems out of harms way on a
> > colocation site, or something, but by then you are at professional
> > level paranoia. For "home systems", whole system failures are far more
> > common than disk failures.
> 
> Don't agree. 

You may not agree, but you would be rather wrong in persisting in that
idea in face of evidence that you can easily accumulate yourself, like
the figures I randomly checked above.

> Not only do disk failures occur more often than full system 
> failures,

No they don't - by about 12 to 1.

> disk failures are also much more time-consuming to recover from. 

No they aren't - we just put in another one, and copy the standard
image over it (or in the case of a server, copy its twin, but then
servers don't blow disks all that often, but when they do they blow 
ALL of them as well, as whatever blew one will blow the others in due
course - likely heat).

> Compare changing a system board or PSU with changing a drive and finding, 
> copying and verifying a backup (if you even have one that's 100% up to
date)

We have. For one thing we have identical pairs of servers, abslutely
equal, md5summed and checked. The idenity-dependent scripts on them
check who they are on and do the approprate thing depending on who they
find they are on.

And all the clients are the same, as clients. Checked daily.

> > > ** In a computer room with about 20 Unix systems, in 1 year I have
seen
> > > 10 or so disk failures and no other failures.
> >
> > Well, let's see. If each system has 2 disks, then that would be 25% per
> > disk per year, which I would say indicates low quality IDE disks, but
> > is about the level I would agree with as experiential.
> 
> The point here was, disk failures being more common than other failures...

But they aren't. If you have only 25% chance of failure per disk per
year, then that makes system outages much more likely, since they
happen at about one per month (here!).

If it isn't faulty scsi cables, it will be overheating cpus. Dust in
the very dry air here kills all fan bearings within 6 months to one
year. 

My defense against that is to heavily underclock all machines.


> 
> > No way! I hate tapes. I backup to other disks.
> 
> Then for your sake, I hope they're kept offline, in a safe.

No, they're kept online. Why? What would be the point of having them in
a safe? Then they'd be unavailable!

The general scheme is that sites cross-backup each other.

>
> > > ** My computer room is for development and testing, no customer
access.
> >
> > Unfortunately, the admins do most of the sabotage.
> 
> Change admins.  

Can't. They're as good as they get. Hey, *I* even do the sabotage
sometimes. I'm probably only abut 99% accurate, and I can certainly
write a hundred commands in a day.


> I could understand an admin making typing errors and such, but then again
that 
> would not usually lead to a total system failure.

Of course it would. You try working remotely to upgrade the sshd and
finally killing off the old one, only to discover that you kill the
wrong one and lock yourself out, while the deadman script on the server
tries fruitlessly to restart a misconfigured server, and then finally
decides after an hour to give up and reboot as a last resort, then
can't bring itself back up because of something else you did that you
were intending to finish but didn't get the opportunity to.

> Some daemon not working, 
> sure.  Good admins review or test their changes,

And sometimes miss the problem.

> for one thing, and in most 
> cases any such mistake is rectified much simpler and faster than a failed 
> disk anyway. Except maybe for lilo errors with no boot media available.
;-\ 

Well, you can go out to the site in the middle of the night to reboot!
Changes are made out of working hours so as not to disturb the users.

> > Yes you did. You can see from the quoting that you did.
> 
> Or the quoting got messed up.  That is known to happen in threads.

Shrug.

> > > but it may be more current than 1 or
> > > more of the other disks.  But this would be similar to what would
happen
> > > to a non-RAID disk (some data not written).
> >
> > No, it would not be similar. You don't seem to understand the
> > mechanism. The mechanism for corruption is that there are two different
> > versions of the data available when the system comes back up, and you
> > and the raid system don't know which is more correct. Or even what it
> > means to be "correct". Maybe the earlier written data is "correct"!
> 
> That is not the whole truth.  To be fair, the mechanism works like this:
> With raid, you have a 50% chance the wrong, corrupted, data is used.
> Without raid, thus only having a single disk, the chance of using the 
> corrupted data is 100% (obviously, since there is only one source)

That is one particular spin on it. 

> Or, much more elaborate:
> 
> Let's assume the chance of a disk corruption occurring is 50%, ie. 0.5

There's no need to. Call it "p".

> With raid, you always have a 50% chance of reading faultty data IF one of
the 
> drives holds faulty data. 

That is, the probability of corruption occuring and it THEN being
detected is 0.5 .  However, the probabilty that it occurred is 2p, not
p, since there are two disks (forget the tiny p^2 possibility). So
we have

  p = probability of corruption occuring AND it being detected.

> For the drives itself, the chance of both disks 
> being wrong is 0.5x0.5=0.25(scenario A).  Similarly, 25 % chance both
disks 
> are good (scenario B). The chance of one of the disks being wrong is 50% 
> (scenarios C & D together).  In scenarios A & B the outcome is certain. In

> scenarios C & D the chance of the raid choosing the false mirror is 50%.
> Accumulating those chances one can say that the chance of reading false
data 
> is:
> in scenario A: 100%

              p^2

> in scenario B: 0%
              0
> scenario C: 50%
              0.5p
> scenario D: 50%
              0.5p

> Doing the math, the outcome is still (200% divided by four)= 50%.

Well, it's p + p^2. But I said to neglect the square term.

> Ergo: the same as with a single disk.  No change.

Except that it is not the case. With a single disk you are CERTAIN to
detect the problem (if it is detectable) when you run the fsck at
reboot.  With a RAID1 mirror you are only 50% likely to detect the
detectable problem, because you may choose to read the "wrong" (correct
:) disk at the crucial point in the fsck.  Then you have to hope that
the right disk fails next, when it fails, or else you will be left holding
the detectably wrong, unchecked data.

So in the scenario of a single detectable corruption:

A: probability of a detectable error occuring and NOT being detected on
   a single disk system is

       zero
       
B: probability of a detectable error occuring and NOT being detected on
    a two disk system is

        p

Cute, no? You could have deduced that from your figures too, but you
were all fired up about the question of a detectable error occurring
AND being detected to think about it occuring AND NOT being detected.

Even though that is what interests us! "silent corruption".

> > > In contrast, on a single disk they have a 100% chance of detection (if
> > > you look!) and a 100% chance of occuring, wrt normal rate.
> > > ** Are you talking about the disk drive detecting the error?
> 
> No, you have a zero chance of detection, since there is nothing to compare
TO.

That is not the case. You have every chance in the world of detecting
it - you know what fsck does.

If you like we can consider detectable and indetectable errors
separtely.


> Raid-1 at least gives you a 50/50 chance to choose the right data.  With a

> single disk, the chance of reusing the corrupted data is 100% and there is
no 
> mechanism to detect the odd 'tumbled bit' at all.

False.


> > You wouldn't necesarily know  which of the two data sources was
> > "correct".
> 
> No, but you have a theoretical choice, and a 50% chance of being right.
> Not so without raid, where you get no choice, and a 100% chance of getting
the 
> wrong data, in the case of a corruption.

Review the calculation.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

