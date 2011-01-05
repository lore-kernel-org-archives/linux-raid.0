From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is It Hopeless?
Date: Wed, 5 Jan 2011 17:07:00 -0600
Message-ID: <19.8C.19545.699F42D4@cdptpa-omtalb.mail.rr.com>
References: <4D18C0C5.4010606@hardwarefreak.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D18C0C5.4010606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Stan Hoeppner' <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Too many (especially younger) IT people _only_ consider up front
> acquisition cost of systems and not long term support of such systems.

	Perhaps so, but the reality of the situation is any venture is a
risk.  Mitigating any risk costs money, and at some point one simply must
deploy the system and hope the inherent failures not mitigated by DR won't
happen.  Even locating multiple massively redundant DR centers across the
entire globe cannot completely mitigate all possible disasters, but few, if
any, enterprises can afford to launch satellites to put their critical data
in orbit.  Eventually, one must roll the dice.

> Total system cost _must_ include a reliable DRS (Disaster Recover
> System).  If you can't afford the DRS to go with a new system, then you
> can't afford that system, and must downsize it or reduce its costs in
> some way to allow inclusion of DRS.

	Well, not necessarily.  Again, not all data is critical.  Below a
certain level of criticality, any DR at all is a waste of money.  There are
literally millions of people out there whose computing needs don't call for
any great level of DR, and some of them even have RAID systems.

>  There is no free lunch.  Eli nearly lost his job over poor acquisition
> and architecture choices.

	Maybe.  It seems to me a lot of recovery avenues were left
unexplored.

> In that thread he makes the same excuses you
> do regarding his total storage size needs and his "budget for backup".
> There is no such thing as "budget for backup".  DRS _must_ be included
> in all acquisition costs.  If not, someone will pay dear consequences at
> some point in time if the lost data has real value.

	Pay now or pay later.  In some cases, paying later is the only
alternative.  What's more, in some cases the later payment is less
burdensome.  I'm not saying this is always the case, by a long shot, but
blankly assuming one must never take any risks is not the best approach,
either.  Risk is a part of life, sometimes even the risk of death.  One must
approach each endeavor with a risk / benefit analysis.

  In Eli's case the
> lost data was Ph.D. student research data.  If one student lost all his
> data, he may likely have to redo an entire year of school.  Who pays for
> that?  Who pays for his year of lost earnings sine he can't (re)enter
> the workforce at Ph.D. pay scale?  This snafu may cost a single Ph.D.
> student, the university, or both, $200K or more depending on career field.

	I didn't spot where any attempt was made to recover the data off the
failed drives.  If it was that important, then the cost of recovery from
failed drives should have been well worth it.  I'm not saying recovering
data from failed hard drives is a good DR plan, but in the event of such an
unmitigated failure, it becomes a worthwhile solution.  It's certainly not a
six figure proposal.

 
> If they'd had a decent tape silo he'd have lost no data.
> 
> > MTBF of tape is hundreds of times sooner.
> 
> Really?  Eli had those WD20EARS online in his D2D backup system for less
> than 5 months.  LTO tape reliability is less than 5 months?  Show data
> to back that argument up please.

	I've had tapes fail after their first write.  Indeed, I recently had
to recover a system from tape where the last 2 tapes were bad.  The 3rd tape
was off-site, so it took a couple of extra days to get the system back
online.  Of course, it wasn't a critical system, or else we would have had
more immediate recovery alternatives.  See my point above.

> Tape isn't perfect either, but based on my experience and reading that
> of many many others, it's still better than D2D is many cases.  Also
> note that tapes don't wholesale fail as disks do.  Bad spots on tape
> cause some lost files, not _all_ the files, as is the case when a D2D
> system fails during restore.

	Tapes certainly do fail completely.  Both tapes I mention above were
completely unreadable.  Note neither hard drives nor tape media usually in
fact fail completely.  Had it been necessary, we could have had the tapes
scanned and recovered much of the data.  The same, however, is true of a
hard drive.  There are data recovery services available for both types of
failed media.  They aren't cheap, but if the lost data is truly valuable...

	Frankly, many people, including IT people who should know better,
panic whenever data is thought to be lost, and wind up making things worse.
A few years ago, an acquaintance of mine - a real bubble-head - related a
story to me.  She was given the chore of backing up one of the systems in
her office to tape.  When the tape utility reached the end of the tape, of
course, it prompted her for additional tapes.  Why this puzzled her, I have
no idea, but it did, so she asked the IT guy who had tasked her with the
backups what she should do.  Believe it or not, he told her to ignore the
prompt and just quit the backup app.  Apparently he is an even bigger
bubble-head than she is.  Some months down the road, of course, the system
failed and they were stuck with a partial backup.  (Yeah, I know, but it
gets worse.)  So what was the failure?  Someone accidentally re-formatted
the hard drive.  When it was discovered the tape backup was incomplete, they
had my acquaintance completely re-install the OS, and manually re-create the
data, which took weeks.  I couldn't believe it.  It's very likely nearly all
the data could have been recovered from the re-formatted hard drive with far
less trouble and cost.  Note also the (at the time) very expensive tape
drive was rendered virtually useless by incompetent individuals.  Indeed,
the entire failure was due to incompetence.

	My brother designed and built a boat, and during this exercise he
read books published by a number of marine engineers.  One of them had a
favorite saying - "Don't do just something, stand there!".  A lot of people,
including IT people, need to take that to heart.  In a failure scenario,
don't do anything unless you have thoroughly thought it through and are
quite certain it won't make things worse.

> If a tape drive fails during restore, you don't lose all the backup
> data.  You simply replace the drive and run the tapes through the new
> drive.  If you have a multi-drive silo or library, you simply get a log
> message of the drive failure, and your restore may simply be slower.
> This depends on how you've setup parallelism in your silo.  Outside of
> the supercomputing centers where large files are backed up in parallel
> streams to multiple tapes/drives simultaneously ("tape RAID" or tape
> striping) most organizations don't stripe this way.  They simply
> schedule simultaneous backups of various servers each hitting a
> different drive in the silo.  In this case if all other silo drives are
> busy, then your restore will have to wait.  But, you'll get your system
> restored.

	None of that is relevant to a guy with a couple of TB of videos in
his home system, though.

> > Not to mention that tape would take forever, and require constant
> tending.
> 
> Eli made similar statements as well, and they're bogus.  Modern high cap
> drives/tapes are quite speedy, especially if striped using the proper
> library/silo management software and planning/architecure.

	Yes, but Eli was tending a much larger system than the OP, and for a
well endowed public system, not a $700 home computer.

> can absorb streaming backups at rates much higher than midrange SAN
> arrays, in the multiple GB/s range.  They're not cheap, but then, good
> DRS solutions aren't. :)

	A "good" DRS solution is only good if it is not so expensive as to
make the enterprise unprofitable.  It doesn't help for a company's data to
be safe if the company can't make money and goes bankrupt.

> The D2D vendors use this scare tactic often also.  Would you care to
> explain this "constant tending"?

	In a small system, the tapes will have to be swapped frequently.
The same is true of DVD or Blu-Ray backups.  An online backup can handle its
own management.

> > My storage is 2TB now, but my library is growing all the time.  Backing
> to off-line disk storage is the only practical way now, given the
> extremely low cost and high capacity and speed.  Each WD 2TB drive is $99
> from Newegg!  Astounding.  Thanks for the input though.
> 
> No, it's not the only practical methodology.  Are you not familiar with
> "differential copying"?  It's the feature that makes rsync so useful, as
> well as tape.  Once you have your first complete backup of that 2TB of
> media files, you're only writing to tape anything that's changed.

	And hoping the original backup set doesn't fail.  Again, every
solution is a a compromise, and when it comes to backups, speed and
efficiency are always balanced against cost and with robustness.
Multi-generation full backups take much longer and are more expensive, but
they don't rely on a single set of backup data that could turn out to be bad
when it is needed.  I'm not saying one should not take advantage of
differential or incremental backups, merely that they represent a compromise
whose implications must be considered.

> At $99 you'll have $396 of drives in your backup server.  Add the cost
> of a case ($50), PSU ($30), mobo ($80), CPU ($100), DIMMs ($30), optical
> drive ($20), did I omit anything?  You're now at around $700.
> 
> You now have a second system requiring "constant tending".  You also
> have 9 components that could fail during restore.

	Yes, but the failure of any one of those components won't destroy
the backup.  Indeed, the failure of any of the common components will stop
the restore, but won't impact the data system, at all.  With RAID10, RAID4,
RAID5, or RAID6, the failure of a drive during restore should not even stop
the restore.

> With a tape drive you have one.

	No, at a minimum, three.  The drive, the tape, and the controller.
Similarly to the backup system, failure of either of the two common systems
will stop the restore.  Failure of the tape will fail the restore.  What's
more, replacing a failed tape drive costs one hell of a lot more than
replacing a PSU or a single hard drive.  I recently had four simultaneous
drive failures in my backup system (with no loss of data, BTW), but
replacing all four was still a lot cheaper than replacing a tape drive.
Indeed, I would not have been able to afford a replacement tape drive, at
all, so had I chosen a tape drive as my sole means of backup, its failure
would have left me without a backup solution.

> Calculate the total MTBF of those 9 components using the
> inverse probability rule and compare that to the MTBF of a single HP
> LTO-2 drive?

	For a large data center or a company with many locations and
systems, such a computation is straightforward.  For a single system, it is
virtually meaningless.  One cannot apply statistics to a singular entity.
(The fact the average person lives to be about 80 doesn't mean my
grandmother did not live to be 102, or that her husband did not die when he
was 45.)

> Again, you're like a deer in the headlights mesmerized by initial
> acquisition cost.  The tape solution I mentioned has a ~$200 greater
> acquisition cost

	You did not include the cost of tapes, especially if he employs a
WORM strategy.  Failing to do so turns the tape solution into a single point
of failure for the backup strategy.  In a RAID backup system, the loss of a
single drive does not compromise the backup data.  With a single
differential or incremental tape strategy, the loss of a tape or any part of
one may compromise the backup set.

> yet its reliability is greater

	Not really.  Again, one cannot rely upon statistical analysis to
determine the relative reliability of the two strategies.  One must instead
analyze the single points of failure and their impact on the backup
strategy, and then determine how much one may afford.

> and it is purpose
> built for the task at hand.   Your DIY D2D server is not.

	How is that relevant?

> Please keep in mind Carl I'm not necessarily speaking directly to you,
> or singling you out on this issue.  This list has a wider audience.
> Many sites archive this list, and those Googling the subject need good
> information on this subject.  The prevailing wind is D2D, but that
> doesn't make it God's gift to DRS.

	True.  The fact is, if the data is truly important, then not only is
a single backup system - no matter how expensive - insufficient, but even a
single backup strategy is not sufficient.

> D2D and tape both have their place, and both can do some jobs equally
> well at the same or varying costs.  D2D is better for some scenarios in
> some environments.

	While for others, the advantages of one solution over the other make
more sense in the situation at hand.

>  Tape is the _ONLY_ solution for others, and
> especially do for some government and business scenarios that require
> WORM capability for legal compliance.  There are few, if any, disk based
> solutions that can guarantee WORM archiving.

	Yet a set of solutions that employ both tape and disk will meet
almost any demand - at a very increased cost.  If the applicatin calls for
instant, random access to backup data along with the ability to recover data
from the distant past, then only a combination of tape and online disk
backups may suffice.

