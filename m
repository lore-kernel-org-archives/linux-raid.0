From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 01:08:08 +0100
Message-ID: <200501040108.08341.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <o4moa2-kfv.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <o4moa2-kfv.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 03 January 2005 21:22, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > The chance of a PSU blowing up or lightning striking is, reasonably, much
> > less than an isolated disk failure.  If this simple fact is not true for
> > you
>
> Oh?  We have about 20 a year.  Maybe three of them are planned.  But
> those are the worst ones!  - the electrical department's method of
> "testing" the lines is to switch off the rails then pulse them up and
> down.  Surge tests or something.  When we can we switch everything off
> beforehand.  But then we also get to deal with the amateur contributions
> from the city power people.

It goes on and on below, but this your first paragraph is already striking(!)
You actually say that the planned outages are worse than the others!
OMG.  Who taught you how to plan ?  Isn't planning the act of anticipating 
things, and acting accordingly so as to minimize the impact ?
So your planning is so bad that the planned maintenance is actually worse than 
the impromptu outages.   I...  I am speechless.  Really. You take the cake.

But from the rest of your post it also seems you define a "total system 
failure" as something entirely different as the rest of us (presumably).
You count either planned or unplanned outages as failures, whereas most of us 
would call that downtime, not system failure, let alone "total".
If you have a problematic UPS system, or mentally challenged UPS engineers, 
that does not constitute a failure IN YOUR server.  Same for a broken 
network.  Total system failures is where the single computer system we're 
focussing on goes down or is unresponsive. You can't say "your server" is 
down when all that is happening is someone pulled the UTP from your remote 
console...! 

> Yes, my PhD is in electrical engineering. Have I sent them sarcastic
> letters explaining  how to test lines using a dummy load? Yes. Does the
> physics department also want to place them in a vat of slowly reheating
> liquid nitrogen? Yes. Does it make any difference? No.

I don't know what you're on about, nor do I really care.  I repeat: your UPS 
or powercompany failing does not constitute a _server_ failure.  
It is downtime.
Downtime != system failure, (although the reverse obviously is).

We shall forthwith define a system failure as a state where there are 
_repairs_ neccessary to the server, for it to start working again. 
Not just the reconnection of mains plugs. Okay with that ?

> > I don't understand your math.  For one, percentage is measured from 0 to
> > 100,
>
> No, it's measured from 0 to infinity.  Occasionally from negative
> infinity to positive infinity.  Did I mention that I have two degrees in
> pure mathematics?  We can discuss nonstandard interpretations of Peano's
> axioms then.

Sigh.  Look up what "per cent" means (it's Latin).
Also, since you seem to pride yourself on your leet math skills, remember that 
your professor said that chance can be between 0 (false) and 1 (true).
Two or 12 cannot be an outcome of any probability calculation.  

> > But besides that, I'd wager that from your list number (3) has, by far,
> > the smallest chance of occurring.
>
> Except of course, that you would lose, since not only did I SAY that it
> had the highest chance, but I gave a numerical estimate for it that is
> 120 times as high as that I gave for (1).

Then your data center cannot seriously call itself that. Or your staff cannot 
call themselves capable.  Choose whatever suits you. 12 outages a year...
Bwaaah.
Even a random home windows box has less outages than that(!).

> > Choosing between (1) and (2) is more difficult,
>
> Well, I said it doesn't matter, because everything is swamped by (3).

Which I disagreed with. I stated (3) is normally the _least_ likely.

> > my experiences with IDE disks are definitely that it will take the system
> > down, but that is very biased since I always used non-mirrored swap.
>
> It's the same principle.  There exists a common mode for failure.
> Bayesian calculations then tell you that there is a strong liklihood of
> the whole system coming down in conjunction with the disk coming down.

Nope, there isn't.  Bayesian or not, hotswap drives on hardware raid cards 
prove you wrong, day in day out.  So either you're talking about linux with 
md specifically, or you should wake up and smell the coffee.

> > > Not in my experience. See above. I'd say each disk has about a 10%
> > > failure expectation per year. Whereas I can guarantee that an
> > > unexpected  system failure will occur about once a month, on every
> > > important system.
>
> There you are. I said it again.

You quote yourself and you agree with that. Now why doesn't that surprise me ?

> Hey, I even took down my own home server by accident over new year!
> Spoiled its 222 day uptime.

Your user error hardly counts as total system failure, don't you think ? 

> > I would not be alone in thinking that figure is VERY high.  My uptimes
>
> It isn't.  A random look at servers tells me:
>
>    bajo          up   77+00:23,     1 user,   load 0.28, 0.39, 0.48
>    balafon       up   25+08:30,     0 users,  load 0.47, 0.14, 0.05
>    dino          up   77+01:15,     0 users,  load 0.00, 0.00, 0.00
>    guitarra      up   19+02:15,     0 users,  load 0.20, 0.07, 0.04
>    itserv        up   77+11:31,     0 users,  load 0.01, 0.02, 0.01
>    itserv2       up   20+00:40,     1 user,   load 0.05, 0.13, 0.16
>    lmserv        up   77+11:32,     0 users,  load 0.34, 0.13, 0.08
>    lmserv2       up   20+00:49,     1 user,   load 0.14, 0.20, 0.23
>    nbd           up   24+04:12,     0 users,  load 0.08, 0.08, 0.02
>    oboe          up   77+02:39,     3 users,  load 0.00, 0.00, 0.00
>    piano         up   77+11:55,     0 users,  load 0.00, 0.00, 0.00
>    trombon       up   24+08:14,     2 users,  load 0.00, 0.00, 0.00
>    violin        up   77+12:00,     4 users,  load 0.00, 0.00, 0.00
>    xilofon       up   73+01:08,     0 users,  load 0.00, 0.00, 0.00
>    xml           up   33+02:29,     5 users,  load 0.60, 0.64, 0.67
>
> (one net). Looks like a major power outage 77 days ago, and a smaller
> event 24 and 20 days ago. The event at 20 days ago looks like
> sysadmins. Both Trombon and Nbd survived it and tey're on separate
> (different) UPSs. The servers which are up 77 days are on a huge UPS
> that Lmserv2 and Itserv2 should also be on, as far as I know. So
> somebody took them off the UPS wihin ten minutes of each other. Looks
> like maintenance moving racks.

Okay, once again: your loss of power has nothing to do with a server failure.
You can't say that your engine died and needs repair just because you forgot 
to fill the gas tank.  You just add gas and away you go.  No repair. No 
damage. Just downtime. Inconvenient as it may be, but that is not relevant.

> Well, they have no chance to be here. There are several planned power
> outs a year for the electrical department to do their silly tricks
> with. When that happens they take the weekend over it.

First off, since that is planned, it is _your_ job to be there beforehand and 
properly shutdown all those systems proir to losing the power. Secondly, 
reevaluate your UPS setup...!!!  How is it even possible we're discussing 
such obvious measures.  UPS'es are there for a reason.  If your upstream UPS 
systems are unreliable, then add your own UPSes, one per server if need be.
It really isn't rocket science...

> > If you have building maintenance people and other random staff that can
> > access your server room unattended and unmonitored, you have far worse
> > problems than making decicions about raid lavels.  IMNSHO.
>
> Oh, they most certainly can't access the server rooms. The techs would
> have done that on their own, but they would (obviously) have needed to
> move the machines for that, and turn them off. Ah . But yes, the guy
> with the insecticide has the key to everywhere, and is probably a
> gardener. I've seen him at it. He sprays all the corners of the
> corridors, along the edge of the wall and floor, then does the same
> inside the rooms.

Oh really.  Nice.  Do you even realize that since your gardener or whatever 
can access everything, and will spray stuff around indiscriminately, he could 
very well incinerate your server room (or the whole building for that matter) 

It's really very simple.  You tell him that he has two options:
A) He agrees to only enter the server rooms in case of immediate emergency and 
will refrain from entering the room without your supervision in all other 
cases. You let him sign a paper stating as much.  
or 
B) You will change the lock on the server room thus disallowing all access.
You agree you will personally carry out all 'maintenance' in that room.

> The point is that most foul-ups are created by the humans, whether
> technoid or gardenoid, or hole-diggeroid.

And that is exactly why you should make sure their access is limited !

> > By your description you could almost be the guy the joke with the
> > recurring 7 o'clock system crash is about (where the cleaning lady
> > unplugs the server every morning in order to plug in her vacuum cleaner)
> > ;-)
>
> Oh, the cleaning ladies do their share of damage. They are required BY
> LAW to clean the keyboards. They do so by picking them up in their left
> hand at the lower left corner, and rubbing a rag over them.

Whoa, what special country are you at ?  In my neck of the woods, I can 
disallow any and all cleaning if I deem it is hazardous to the cleaner and / 
or the equipment.  Next, you'll start telling me that they clean your backup 
tapes and/or enclosures with a rag and soap and that you are required by law 
to grant them that right...?
Do you think they have cleaning crews in nuclear facilities ?  If so, do you 
think they are allowed (by law, no less) to go even near the control panels 
that regulate the reactor process ?  (nope, I didn't think you did) 

> Their left hand is where the ctl and alt keys are.
>
> Solution is not to leave keyboard in the room. Use a whaddyamacallit
> switch and attach one keyboard to that whenever one needs to access
> anything.. Also use thwapping great power cables one inch thck that
> they cannot move.

Oh my. Oh my. Oh my.  I cannot believe you.  Have you ever heard of locking 
the console, perhaps ?!?  You know, the state where nothing else than typing 
your password will do anything ?  You can do that _most_certainly_ with KVM 
switches, in case your OS is too stubborn to disregard the various three 
finger combinations we all know.

> And I won't mention the learning episodes with the linux debugger monitor
> activated by pressing "pause".

man xlock.  man vlock.   djeez...  is this newbie time now ?

> Once I watched the lady cleaning my office. She SPRAYED the back of the
> monitor! I YELPED! I tried to explain to her about voltages, and said
> that she would't clean her tv at home that way - oh yes she did!

Exactly my point.  My suggestion to you (if simply explaining doesn't help): 
Call the cleaner over to an old unused 14" CRT. Spray a lot of water-based, 
or better, flammable stuff into and onto the back of it.  Wait for the smoke 
or the sparks to come flying...!    stand back and enjoy. ;-)


> You may not agree, but you would be rather wrong in persisting in that
> idea in face of evidence that you can easily accumulate yourself, like
> the figures I randomly checked above.

Nope.  However, I will admit that -in light of everything you said- your 
environment is very unsafe, very unreliable and frankly just unfit to house a 
data center worth its name.  I'm sure others will agree with me.

You can't just go around saying that 12 power outages per year are _normal_ 
and expected. You can't pretend something very very wrong is going on at your 
site.  I've experienced 1 (count 'em: one) power outage in our last colo in 
over four years, and boy did my management give them (the colo facility) hell 
over it !   

> > Not only do disk failures occur more often than full system
> > failures,
>
> No they don't - by about 12 to 1.

Only in your world, yes.

> > disk failures are also much more time-consuming to recover from.
>
> No they aren't - we just put in another one, and copy the standard
> image over it (or in the case of a server, copy its twin, but then
> servers don't blow disks all that often, but when they do they blow
> ALL of them as well, as whatever blew one will blow the others in due
> course - likely heat).

If you had used a colo, you wouldn't have dust lead to a premature fan failure 
(in my experience). There is no smoking in colo facilities expressly for that 
reason (and the fire hazard, obviously).  But even then, you could remotely 
monitor the fan health, and /or the temperature. 

I still stand by my statement: disks are more time consuming than other 
failures to repair.  Motherboards don't need data being restored to them.
Much less finding out how complete the data backup was, and verifying that all 
works again as expected.

> > Compare changing a system board or PSU with changing a drive and finding,
> > copying and verifying a backup (if you even have one that's 100% up to
> > date)
>
> We have. For one thing we have identical pairs of servers, abslutely
> equal, md5summed and checked. The idenity-dependent scripts on them
> check who they are on and do the approprate thing depending on who they
> find they are on.

Good for you. Well planned.  It just amazes me now more than ever that the 
rest of the setup seems so broken / unstable.  On the other hand, with 12 
power outages yearly, you most definitely need two redundant servers.

> > The point here was, disk failures being more common than other
> > failures...
>
> But they aren't. If you have only 25% chance of failure per disk per
> year, then that makes system outages much more likely, since they
> happen at about one per month (here!).

With the emphasis on your word "(here!)", yes.

> If it isn't faulty scsi cables, it will be overheating cpus. Dust in
> the very dry air here kills all fan bearings within 6 months to one
> year.

Colo facilities have a strict no smoking rule, and air filters to clean what 
enters.  I can guarantee you that a good fan in a good colo will live 4++ 
years.  Excuse me but dry air, my ***.  Clean air is not dependent on 
dryness.  It is dependent on cleanness.

> My defense against that is to heavily underclock all machines.

Um, yeah.  Great thinking.  Do you underclock the PSU also, and the disks ?
Maybe you could run a scsi 15000 rpm drive at 10000, see what that gives ?
Sorry for getting overly sarcastic here, but there really is no end to the 
stupidities, is there ?

> > > No way! I hate tapes. I backup to other disks.
> >
> > Then for your sake, I hope they're kept offline, in a safe.
>
> No, they're kept online. Why? What would be the point of having them in
> a safe? Then they'd be unavailable!

I'll give you a few pointers then:
If your disks are online instead of in a safe, they are vulnerable to:

* Intrusions / viruses
* User / admin error (you yourself stated how often this happens!)
* Fire
* Lightning strike
* Theft 

> > Change admins.
>
> Can't. They're as good as they get. Hey, *I* even do the sabotage
> sometimes. I'm probably only abut 99% accurate, and I can certainly
> write a hundred commands in a day.

Every admin makes mistakes.  But most see it before it has dire consequences.

> > I could understand an admin making typing errors and such, but then again
> > that would not usually lead to a total system failure.
>
> Of course it would. You try working remotely to upgrade the sshd and
> finally killing off the old one, only to discover that you kill the
> wrong one and lock yourself out, while the deadman script on the server

Yes, been there done that...

> tries fruitlessly to restart a misconfigured server, and then finally
> decides after an hour to give up and reboot as a last resort, then
> can't bring itself back up because of something else you did that you
> were intending to finish but didn't get the opportunity to.

This will happen only once (if you're good), maybe twice (if you're adequate) 
but if it happens to you three times or more, then you need to find a 
different line of work, or start drinking less and paying more attention at 
your work.  I'm not kidding.  The good admin is not he who never makes 
mistakes, but he who (quickly) learns from it.

> > Some daemon not working,
> > sure.  Good admins review or test their changes,
>
> And sometimes miss the problem.

Yes, but apache not restarting due to a typo hardly constitutes a system 
failure.  Come on now!

> > for one thing, and in most
> > cases any such mistake is rectified much simpler and faster than a failed
> > disk anyway. Except maybe for lilo errors with no boot media available.
> > ;-\
>
> Well, you can go out to the site in the middle of the night to reboot!
> Changes are made out of working hours so as not to disturb the users.

Sometimes, depending on the SLA the client has.  In any case, I do tend to 
schedule complex, error-prone work for when I am at the console.
Look, any way you want to turn it, messing with reconfiguring bootmanagers 
when not at the console is asking for trouble.  If you have no other 
recourse, test it first with a local machine with the exact same setup.

For instance, I learned from my sshd error to always start a second sshd on 
port 2222 prior to killing off the main one.  You could also have a 'screen' 
session running with a sleep 600 followed by some rescue command.  
Be creative.  Be cautious (or paranoid).  Learn.

> > That is not the whole truth.  To be fair, the mechanism works like this:
> > With raid, you have a 50% chance the wrong, corrupted, data is used.
> > Without raid, thus only having a single disk, the chance of using the
> > corrupted data is 100% (obviously, since there is only one source)
>
> That is one particular spin on it.

It is _the_ spin on it.

> > Ergo: the same as with a single disk.  No change.
>
> Except that it is not the case. With a single disk you are CERTAIN to
> detect the problem (if it is detectable) when you run the fsck at
> reboot.  With a RAID1 mirror you are only 50% likely to detect the
> detectable problem, because you may choose to read the "wrong" (correct
> :) disk at the crucial point in the fsck.  Then you have to hope that
> the right disk fails next, when it fails, or else you will be left holding
> the detectably wrong, unchecked data.

First off, fsck doesn't usually run at reboot.  Just the journal is replayed.
Only when severe errors are there, there will be a forced fsck.  You're not 
telling me that you fsck your 600 gigabyte arrays upon each reboot, yes ?
It will give you multiple hours added downtime if you do.

Secondly, if you _are_ that paranoid about it that you indeed do a fsck, what 
is keeping you from breaking the mirror, fsck the underlying physical devices 
and reassemble if all is okay.  Added benefit: if all is not well, you get to 
choose which half of the mirror you decide to keep.  Problem solved.

And third, I am not too convinced the error detection is able to detect all 
errors.  For starters, if a crash occurred while disk one was completely 
written but disk two had not yet begun, both checksums would be correct, so 
no fsck would notice.  Secondly, I doubt that the checksum mechanism is that 
good. It's just a trivial checksum, it's bound to overlook some errors.

And finally: If you would indeed end up with the "detectably wrong, unchecked 
data", you can still run an fsck on it, just as with the single disk. The 
fsck will repair it (or not), just as with the single disk you would've had.

In any case, seen as you do 12 reboots a year :-P the chances a very very slim 
you hit the wrong ("right") half of the disk at all those 12 times, so you'll 
surely notice the corruption at some point.  

Note that despite all this I am all for an enhancement to mdadm providing a 
method to check the parity for correctness.  But this is besides the point. 

> > No, you have a zero chance of detection, since there is nothing to
> > compare TO.
>
> That is not the case. You have every chance in the world of detecting
> it - you know what fsck does.

Well, when have you last fsck'ed a terabyte size array without an immediate 
need for it ?  I know I haven't -> my time is too valueable to wait half a 
day, or more, for that fsck to finish.

Maarten


