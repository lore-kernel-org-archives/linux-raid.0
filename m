From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 15:33:30 -0500
Message-ID: <20090405203331.FWRT1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <F2C688D6A021E34CB81C0E631EF4C093017FF4E0@34093-C4-EVS1.exchange.rackspace.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C093017FF4E0@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Lethe' <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Leslie:
> Respectfully, your statement, "SMART is supposed to report this" shows
> you have no understanding of exactly what S.M.A.R.T. is and is not
> supposed to report, nor do you know enough about hardware to make an
> educated decision about what can and can not be contributing factors.
> As such, you are not qualified to dismiss the necessity to run hardware
> diagnostics.

I am not dismissing anything.  From the very first post I have been asking
for methods of running diagnostics, including hardware diagnostics.  The
evidence so far does not strongly suggest a hardware issue, at least not a
drive issue, but this in no way conclusively eliminates the possibility.  I
never said it did.

> A few other things - many SATA controller cards use poorly architected
> bridge chips that spoof some of the ATA commands, so even if you *think*
> you are kicking off one of the SMART subcommands, like the
> SMART_IMMEDIATE_OFFLINE (op code d4h with the extended self test,
> subcommand 2h), then it is possible, perhaps probable, they are never
> getting run. -- yes, I am giving you the raw opcodes so you can look
> them up and learn what they do.

I know what they do.  Whether those codes are properly implemented by either
the OS or the SATA controller I have no way of knowing offhand.  All I can
tell you is what I have observed: the drive system previously reported tons
of sector remaps when the drives were in a different, clearly broken,
enclosure, and they continue to do so on the 320G drive with known issues.

> You want to know how it is possible that frequency or size of reads can
> be a factor?
> Do the math:
>  * Look at the # of ECC bits you have on the disks (read the specs), and
> compare that with the trillions of bytes you have.  How frequently can
> you expect to have an unrecoverable ECC error based on that.

Exceedingly rarely for file creations and very commonly for gigabit long
reads if the drive is bad.  So why does it happen sometimes 100% of the time
when creating files, but never at all when reading them?  I ma noty talking
about reads on static files which presumably may have encountered a bad
sector and had it remapped.  I am talking about massive volumes of brand new
data being written, read, erased, written, and read over and over.

>  * What percentage of your farm are you actually testing with the tests
> you have run so far? Is it even close to being statistically
> significant?

Yes, they are.  More than statistically significant, they cover a data space
larger than the entire free space region many times over.  It's not an
overly high probability even a single block has been missed.

>  * Do you know what physical blocks on each disk are being read/written
> with the tests you mention?

No, of course not.  Are you seriously suggesting I should investigate the
sector numbers of each and every one of the billions of reads going on?
They far exceed in number the total number of free blocks, which is more
than sufficient evidence.

> If you do not know, then how do you know
> that the short tests are doing I/O on blocks that need to be repaired,
> and subsequent tests run OK because those blocks were just repaired?

'Because there is no statistical or logical differentiation between a write
/ read pair on a file creation and billions of write / read pairs spooling
out on a new multi-gigabit file.  If there were halts during the reads of
the files after they were written, then I would agree, but each large file
is written, read, copied, read, written, read, and then read again at least
once.  Every 3G - 35G file has its bytes written to at least three different
locations (with modifications each time) on the array, and is read at least
four times, sometimes five or six times, along the way.  Once in its final
state, the file just sits there in perpetuity, only being read.  At this
point, the active sections of the array are only 610 Gigs in extent, and
that much data gets written, read, written over, and read in a matter of a
few days.  Yet for many months, not a single halt has been observed during
any of the trillions of blocks read, except when creating a file.  It's
moderately unlikely there is even a single block on the drive that has not
been written and subsequently read.

>  * Did you look into firmware? Are the drives and/or firmware revisions
> qualified by your controller vendor?

Yes.  I did that before purchasing the controller.  No, I did not look into
the drives.  The controller vendor does not qualify drives.  Controllers
don't get any more generic than the one I purchased (I don't recall the
brand at this time - it's based on the Silicon Image SiI3124 controller
chip).  More importantly, the fact the system ran for months without the
problem, and the problem only occurred after changing the array chassis and
the file system strongly suggests this is not the root of the issue.
 
> I've been in the storage business for over 10 years, writing everything
> from RAID firmware, configurators, disk diagnostics, test bench suites.

'And I started designing computer hardware more than 30 years ago, before
the IMB PC existed.  Neither your qualifications nor mine are of any
relevance.

> doubt that you will find any experienced storage professional that
> wouldn't tell you to break it all down and run a full block-level DVT
> before going further.

I am not a fool.  I have asked you more than once for the details of a
utility to handle a DVT.  I can't run an application I do not have in my
possession.  If it is part of the Linux distro, then I need to know what it
is.

> It could have all been done over the week-end if
> you had the right setup, and then you would know a lot more than what
> you know now.
 
> AT this point all you have done is tell people who suggest hardware is
> the cause that they are wrong and then tell us why you think we are
> wrong.

No, in addition to applying proper deductive reasoning to the data I do have
and concluding your hypotheses are unlikely, I have repeatedly asked for the
details behind such a setup.

> Frankly, be lazy and don't run diagnostics, you had just better
> not be a government employee, or in charge of a database that contains
> financial, medical, or other such information, and you have better be
> running hot backups.

My employment is not relevant, and only an idiot doesn't back up data.
Critical data gets backed up on multiple sites via multiple vectors.  None
of which has any relevance to my problem at hand or how to further diagnose
it.  My backup systems aren't having the problem.

> If you still refuse to run full block-level hardware test, then ask

Where do you get this?  I have never once refused to do anything.  Read my
lips: "HOW DO I RUN A FULL BLOCK-LEVEL HARDWARE TEST?"  Point me to a
website, a MAN page, or a phone number where I can obtain the utilities to
perform the tests.  I am a hardware expert, but a Linux neophyte.  I do not
run Linux on any of my professional systems, only my personal ones, and my
professional systems are not PCs.

> yourself how much longer will you allow this to go on before you run
> such a test, or are you just going to continue down this path waiting
> for somebody to give you a magic command to type in that will fix
> everything.
> 
> I am not the one who is putting my job on the line at best, and at
> worst, is looking at a criminal violation for not taking appropriate
> actions to protect certain data. I make no apology for beating you up on
> this.  You need to hear it.

Oh, brother.  Since I personally own outright every last nut, bolt, and
transistor in these systems, and since the data belongs entirely and
exclusively to me (with the exception of some copyright restrictions), for
use by me, exactly who is going to fire me or prosecute me?  Enough.  Please
cease the ad hominem attacks, and point me towards the utilities which will
allow me to further diagnose the issue.

