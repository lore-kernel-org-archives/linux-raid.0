From: "David Lethe" <david@santools.com>
Subject: RE: RAID halting
Date: Tue, 7 Apr 2009 13:18:00 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com>
References: <49DA677C.2080009@hp.com> <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Tuesday, April 07, 2009 12:47 PM
> To: 'Linux RAID'
> Subject: RE: RAID halting
> 
> > > could tell without losing any additional files.  I'm not saying
> ext3
> > cause
> > > any of the problems, but it certainly allowed itself to be
> corrupted by
> > > hardware issues.
> >
> > Some observations from a filesystem guy lurking on this list...
> >
> > You won't find a filesystem that can't be corrupted by bad hardware.
> 
> That's absolutely true, but a RAID array is supposed to be fault
> tolerant.
> Now, I am well aware of the vast difference between fault tolerant and
> fault
> proof, and I cannot begin to claim another file system would not have
> suffered problems, but to my admittedly inexperienced (in the realm of
> ext3
> and other Linux file systems) eye, a journal which thinks the device
is
> bigger than it really is after an array expansion causing a loss of
> data
> seems pretty frail.  It's not like there was an actual array failure
or
> any
> number of bad blocks associated with the event.  It also left a  bit
of
> a
> bad taste in my mouth that fsck could not repair the issue until I
> converted
> the system to ext2.
> 
> > Most filesystems update some same set of common blocks to do a
> > create.  This is particularly true of journal filesystems like
> > reiserFS.  If the journal write stalls, everything else can hang
> > on a journaling fs.
> 
> Yes, I would expect that.  Read or write failures from those common
> blocks
> - and nothing else - should not ordinarily be related to the volume of
> data
> being read or written elsewhere on the array, however.  In other
words,
> if
> the common blocks are number 1000 - 2000, then reading and writing to
> blocks
> 10,000 and above should not cause the rate of failure of reads from
> blocks
> 1000 - 2000 to change.  Instead, what we see quite clearly in this
case
> is
> modest to high write and / or read rates in blocks 10,000 and above
> cause
> file creation events on blocks 1000 - 2000 to fail, while low data
> rates do
> not.  I also think it is probably significant that the journal is
> obviously
> written to by both file creations and file writes, yet only creations
> cause
> the failure.  Now if certain sections of the journal blocks are only
> for
> file creation, then why do read-only data rates affect the issue at
> all?
> 
> > While I agree your symptoms sound more like a software problem, my
> > experience with enterprise raid arrays and drives says I would not
> > rule hardware out as the trigger for the problem.
> 
> Nor have I done so.  At this point, I haven't ruled out anything.
It's
> taking better than a day to scan each drive using badblocks, so it's
> going
> to be about 2 weeks before I have scanned all 10 drives.  AFAIK, the
> badblocks routine itself has not triggered any read/write halts.
> 
> > That 20 minute hang sure sounds like an array ignoring the host.
> > With an enterprise array a 20 minute state like that is "normal"
> > and really makes us want to beat the storage guys severely.
> 
> I can't argue against that at this point, for certain.  What puzzles
me
> (among other things) is why do 5 of the drives show zero reads while 5
> of
> them show very low levels of read activity, and always the same 5
> drives?
> The main question, of course, is not so much what is happening, as
why,
> and
> of course how can it be avoided?
> 
> Fortunately the multi-minute hangs only occur once a month, when the
> array
> is resyncing.  Even so, however, the nearly continuous 40 second hangs
> are
> driving me mad.  I have a large number of videos to edit, and
> stretching
> what should be a 7 minute manual process into 20 minutes 4 or 5 times
a
> day
> is getting old fast.
> 
> > As was pointed out, there is a block layer "plug" when a device
> > says "I'm busy".  That requires the FS to issue an "unplug", but
> > if a code path doesn't have it... hang until some other path is
> > taken that does do the unplug.
> >
> > I suggest using blktrace to see what is happening between the
> > filesystem, block layer, and device.
> 
> Thanks!  I'll take a look after all the drives are scanned.
> 
> > But none of them will protect you from bad hardware.
> 
> No, of course not, but I believe I am pretty close to having a stable
> hardware set.  Before that gathers any flames, let me hasten to say
> that in
> no way means I am certain of it, or that I refuse to change out any
> suspect
> hardware.  Changing out non-suspect hardware, however, is just a means
> of
> introducing more possible failures into a system.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Sorry for probably being the one that started the flames .. It was
unprofessional of me, I apologize for getting on my soapbox.  Anyway,
the blkcheck routine isn't really the best way to do this.  There is a
low-level command that can be executed on the drives that runs directly
in the disk firmware, and it will create a list of bad blocks that can
be programmatically read.  The up-side is that this can run in
background of disks, and all can run concurrently with minor performance
hit. (The test can be killed without harming anything if you think
impact is too high). 

There are also some embedded self-test routines that do not do full
media scan, but check things like electronics, cache buffers, random
seek/reads, etc, even destructive write tests.

Big caveat however, the chip that your cheap SATA controller uses
probably blocks all these commands, as most SATA controllers use SAS
bridge chips that make disks appear to BIOS as SCSI devices, and they do
a protocol conversion which does command translation as well.  Vast
majority of bridge chips don't do this correctly.

If the disks are Seagate then the self-tests can be downloaded for free
as part of seatools, just boot the system into windows.   Some SATA
controller BIOSs have embedded self test support, and controllers such
as 3WARE and LSI have various build-in capability depending on firmware
and model number.  hdparm may support the ATA embedded self-tests, I
don't know.  Lots of windows shareware you can find that support
self-tests also.  I expect WD has some stuff on their site as well.
There are commercial products as well, and to be up-front, my company
has some, but if you can get something for free, use them instead.

There is also a SMART error log reporting mechanism.  The disks have
ability to report the last 5 commands that errored on each disk, which
includes timestamp, op code, input parameters and reason for error.
This runs instantly, and it is possible that just having these last 5
errors will tell you exactly what problem is. The errors are also
non-volatile, so you can even move each disk to a PC with a "regular"
ATA/SATA controller so that your bridge chip doesn't block the commands.
 
If you care to contact me offline then I will be happy to point you to
right direction. I owe you that.   

David @ santools. Com




