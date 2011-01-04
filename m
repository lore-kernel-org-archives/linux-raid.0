From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Is It Hopeless?
Date: Tue, 04 Jan 2011 15:03:45 -0500
Message-ID: <4D237D21.5050509@cfl.rr.com>
References: <201012261019.56481.CACook@quantum-sci.com> <201012261606.29281.CACook@quantum-sci.com> <4D182587.4040801@turmel.org> <201012270510.51520.CACook@quantum-sci.com> <4D18C0C5.4010606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D18C0C5.4010606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/27/2010 11:37 AM, Stan Hoeppner wrote:
> If they'd had a decent tape silo he'd have lost no data.

Unless the tape failed, which they often do.

>> MTBF of tape is hundreds of times sooner.  
> 
> Really?  Eli had those WD20EARS online in his D2D backup system for less
> than 5 months.  LTO tape reliability is less than 5 months?  Show data
> to back that argument up please.

Those particular drives seem to have a rather high infant mortality
rate.  That does not change the fact that modern drives are rated with
MTBF of 300,000+ hours, which is a heck of a lot more than a tape.

> Tape isn't perfect either, but based on my experience and reading that
> of many many others, it's still better than D2D is many cases.  Also
> note that tapes don't wholesale fail as disks do.  Bad spots on tape
> cause some lost files, not _all_ the files, as is the case when a D2D
> system fails during restore.

Not necessarily.  Both systems can fail partially or totally, though
total failure is probably more likely with disks.

> If a tape drive fails during restore, you don't lose all the backup
> data.  You simply replace the drive and run the tapes through the new
> drive.  If you have a multi-drive silo or library, you simply get a log

It isn't the drive that is the problem; it's the tape.

> At $99 you'll have $396 of drives in your backup server.  Add the cost
> of a case ($50), PSU ($30), mobo ($80), CPU ($100), DIMMs ($30), optical
> drive ($20), did I omit anything?  You're now at around $700.

Or you can just spend $30 on an esata drive dock instead of building a
dedicated backup server.  Then you are looking at $430 to back up 4tb of
data.  An LTO Ultrium 3 tape drive looks like it's nearly two grand, and
only holds 400gb per tape at $30 a pop, so you're spending nearly $2500
on the drive and 20 tapes.  It doesn't make sense to spend 5x as much on
the backup solution as the primary storage solution.

> You now have a second system requiring "constant tending".  You also
> have 9 components that could fail during restore.  With a tape drive you
> have one.  Calculate the total MTBF of those 9 components using the
> inverse probability rule and compare that to the MTBF of a single HP
> LTO-2 drive?

This is a disingenuous argument since only one failure ( the drive )
results in data loss.  If the power supply fails, you just plug in
another one.  Also again, it is the tape that matters, not the tape
drive, so what is the MTBF of those tapes?

I know it isn't a significant sample size, but in 20 years of computing
I have only personally ever had one hard drive outright fail on me, and
that was a WD15EARS ( died in under 24 hours ), but I had tapes fail a
few times, often within 24 hours of them verifying fine, then you go to
restore from them and they are unreadable.  That combined with their
absurd cost is why I don't use tapes any more.
