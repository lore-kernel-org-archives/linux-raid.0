From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is It Hopeless?
Date: Wed, 5 Jan 2011 15:19:47 -0600
Message-ID: <04.97.19545.570E42D4@cdptpa-omtalb.mail.rr.com>
References: <4D237D21.5050509@cfl.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D237D21.5050509@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phillip Susi' <psusi@cfl.rr.com>, 'Stan Hoeppner' <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phillip Susi
> Sent: Tuesday, January 04, 2011 2:04 PM
> To: Stan Hoeppner
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Is It Hopeless?
> 
> On 12/27/2010 11:37 AM, Stan Hoeppner wrote:
> > If they'd had a decent tape silo he'd have lost no data.
> 
> Unless the tape failed, which they often do.
> 
> >> MTBF of tape is hundreds of times sooner.
> >
> > Really?  Eli had those WD20EARS online in his D2D backup system for less
> > than 5 months.  LTO tape reliability is less than 5 months?  Show data
> > to back that argument up please.
> 
> Those particular drives seem to have a rather high infant mortality
> rate.  That does not change the fact that modern drives are rated with
> MTBF of 300,000+ hours, which is a heck of a lot more than a tape.
> 
> > Tape isn't perfect either, but based on my experience and reading that
> > of many many others, it's still better than D2D is many cases.  Also
> > note that tapes don't wholesale fail as disks do.  Bad spots on tape
> > cause some lost files, not _all_ the files, as is the case when a D2D
> > system fails during restore.
> 
> Not necessarily.  Both systems can fail partially or totally, though
> total failure is probably more likely with disks.
> 
> > If a tape drive fails during restore, you don't lose all the backup
> > data.  You simply replace the drive and run the tapes through the new
> > drive.  If you have a multi-drive silo or library, you simply get a log
> 
> It isn't the drive that is the problem; it's the tape.
> 
> > At $99 you'll have $396 of drives in your backup server.  Add the cost
> > of a case ($50), PSU ($30), mobo ($80), CPU ($100), DIMMs ($30), optical
> > drive ($20), did I omit anything?  You're now at around $700.
> 
> Or you can just spend $30 on an esata drive dock instead of building a
> dedicated backup server.  Then you are looking at $430 to back up 4tb of
> data.  An LTO Ultrium 3 tape drive looks like it's nearly two grand, and
> only holds 400gb per tape at $30 a pop, so you're spending nearly $2500
> on the drive and 20 tapes.  It doesn't make sense to spend 5x as much on
> the backup solution as the primary storage solution.
> 
> > You now have a second system requiring "constant tending".  You also
> > have 9 components that could fail during restore.  With a tape drive you
> > have one.  Calculate the total MTBF of those 9 components using the
> > inverse probability rule and compare that to the MTBF of a single HP
> > LTO-2 drive?
> 
> This is a disingenuous argument since only one failure ( the drive )
> results in data loss.  If the power supply fails, you just plug in
> another one.  Also again, it is the tape that matters, not the tape
> drive, so what is the MTBF of those tapes?
> 
> I know it isn't a significant sample size, but in 20 years of computing
> I have only personally ever had one hard drive outright fail on me, and
> that was a WD15EARS ( died in under 24 hours ), but I had tapes fail a
> few times, often within 24 hours of them verifying fine, then you go to
> restore from them and they are unreadable.  That combined with their
> absurd cost is why I don't use tapes any more.

	No backup solution is perfect.  That's why I employ a backup server
PLUS offline storage PLUS multiple backup locations on multiple systems for
my critical data.  My banking data, for example, has full multi-generation
backups on multiple internal drives of different workstations as well as
being on the server, the backup server, and on offline storage.  Tape has
advantages that usually only begin to make sense for large enterprise level
systems which may span many dozens of TB, and for whom acquisition time for
the backup is less important than WORM capability.  For very small,
especially private, systems, tape's advantages are mostly moot, and its
relative cost rises rapidly as the size of the system falls.  Backing up 4TB
of data reliably can easily be done with $400 worth of hard drives.  Backing
up 400TB of data with hard drives is, well, nightmarish.  BTW, for small,
fairly static data repositories, DVDs or Blu-Ray disks can provide a very
economical, if labor intensive, WORM backup solution.  In the case of the
OP, it sounds as if most of his data is a personal system containing mostly
movies whose content will never change.  DVD or Blu-Ray might be a
reasonable backup medium for him.

	One item that is for some reason rarely discussed and yet is the
very most important reason for a backup is human error.  People go on
endlessly about drive failures and tape failures, yet the fact is most data
loss is due to user errors.  A WORM solution can go a long way toward
alleviating such failures, while an online backup solution may inherently
encourage such failures.  At the same time, when a user accidentally
overwrites a file, he usually wants it recovered instantly.  I know I have
been very glad on more than one occasion of having an on-line backup system
from which I could recover a file I had accidentally overwritten.  That's
why I run an rsync every night, and why I don't delete any files during the
rsync that have been removed from the main system.  Of course that means the
backup system has to be larger than the main system, and that I have to go
through and delete old, temporary files on the backup from time to time.

	Another item that is often glossed over is the importance of the
data being targeted.  On many systems, some of the data is not very
important, at all, and a loss of some of that data may be of little
consequence.  It's not a black / white dichotomy between important vs.
unimportant data, either.  Not only does the importance of the data vary
over a significant range, the importance also scales with volume.  My
aforementioned critical banking data, for example, is rather small in
extent, so there's no significant monetary or administrative impact in
storing copies of it all over the galaxy, as it were.  OTOH, like the OP,
the bulk of the data on my home servers is video.  The loss of a single
video, while not wonderful, is hardly a tragedy.  Through one issue or
another I have indeed lost a small handful of videos over time.  The cost of
insuring I never would have lost any of these files would have been
prohibitively high to make that level of backup practical.  The thought,
however, of losing all 11 TB of video data is daunting, to say the least.
That's why I do have an online backup system and offline storage as well for
the bulk of the files on the server.  At work, the systems I administrate
are actually quite small in comparison to my home server, but the data on
some of them is at least as critical as my personal banking data.  Those
systems have multiple backups to multiple tapes, multiple hard drives, and
multiple solid state storage systems spread across the entire nation.

