From: "Diamon" <diamon@io.com>
Subject: Re: md: badblocks(pid 1216) used obsolete MD ioctl
Date: Tue, 2 Jul 2002 16:29:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003501c2220f$8749a6c0$9255e0ce@cust.io.com>
References: <NDBBIAKEEKGGEIKCBKNAGEBHDBAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: kc130iseo@coastalnet.com
List-Id: linux-raid.ids




    <-- Snip snip -->
> [snip]
> > These commands are SCSI command set mode commands, and after the drive
> > receives the instruction it performs the format itself.
> > mke2fs and so on only do high level filesystem formats.

    Exactly.

> Of course, most storage people know that the "CHS" value vendors assign to
a
> drive almost never represent the physical geometry. The drive and/or
> controller must be capable of translating to "physical" locations for
> read/write operations. I assume that the "low-level" format you refer to
> operates at this level.

    SCSI doesn't really have a CHS, and never has.  It pretends to, but a
SCSI device as I recall is actually (at least internally) addressed by
sectors, regardless of where on the disk the sectors are actually located.

> A crude overview (my understanding): During a "low-level" format the
> controller, activating machine instructions stored on the drive, will scan
> for defects then re-write BOT (Beginning Of Track) markers and sector
> addresses on the media, skipping the bad spots it found and storing them
for
> future reference in some non-volatile medium (often it will do more).
> "fdisk" and the tools in the e2fsprogs package merely overlay partition,
> sector, and block data atop this low-level framework to create and manage
> the filesystems.

    Actually, the controller usually should do nothing.  There is a command
to pass to the drive to tell it to format itself, and off it goes.  Most if
not all drives do no error-checking during the format operation, trusting to
their 'Media Verify" to be done later.  SCSI drives don't skip bad sectors.
If the drive really knows it's bad and has been allowed to, it will
reallocate the sector, but oddly most drives are set to NOT reallocate on
Read Errors.  Not sure why.

> > > > It does no harm to enable it on the drives as well, and makes sure
the
> > > > attenuation is not a problem.
> [snip]
> > >in an already warm environment. I've never found this (current
> > >drain) to be a factor with cable lengths under 8-feet, even
> > >with single-ended segments. As I'm sure you are aware,
> > >differential SCSI has substantially extended the range of SCSI
> > >signals on longer cables.
> >
> > True. Still, I have seen many cases where this helped.
>
> Thanks, I'll keep that in mind. I know from my own experience that there
are
> times when a certain action fixes a problem even though it doesn't seem to
> make sense at the time.

    Arrgh, how true that is...

> Often it is more expedient to just try something that might work, rather
> than to enter an in-depth analysis. I cannot let things like this go
> indefinitely, though. I've got to know "why". When encountering these
> situations, I usually make time later to conduct a forensic analysis. Over
> the years I've found that there is usually a contributing factor, often
> related to the "interim fix" I was forced to employ.
>
> > >Okay, I've got to ask now. What benefit could I expect from
> > pulling a drive
> > >from my array and plugging it into a PC? What could I do on the PC that
I
> > >could not do with one of the utilities mentioned above?
> >
> > Low level SCSI format command.
> > This marks bad all defective sectors ON THE DRIVE.
> > SCSI drives have factory and "grown" defect tables in their firmware,
and
> > this is more effective and reliable than filesystem tools ability to
mark
> > bad sectors.

    Yes, the drive usually knows best if it has a problem...  I think the
glist (grown defect list, as opposed to the plist, or primary list) is
stored on disk in a reserved sector, and woe betide THAT sector going bad.
:P  I think sformat can scrup the glist as well.  Again I can't swear to
that, it's been years since I used sformat.

> Okay, I've used low-level SCSI format for that purpose many times on
> "Windoze" PC's. In fact, I've searched in vain for utilities that do this
on
> a Sparc Linux machine. Admittedly, having the bad sectors stored on the
> drive itself prevents losing track of them, making it more reliable.
> However, I still don't see how it is more effective than Linux e2fsprogs
at
> detecting and marking them.

    E2fsprogs only look at the high-level, not the disk itself.  If your
disk has reallocate on error disabled, all the formatting in the world
(except low-level formats) will do nothing.

> I suppose that, if there were many of these bad spots to manage, there may
> be some performance gain by relieving the filesystem/kernel drivers of the
> burden. I don't see how physically re-mapping a few bad areas is
> significantly more efficient that simply allowing the filesystem to avoid
> them. To low-level format drives on my Sparc Linux machines I would have
to
> disconnect and remove the chassis from the 19-inch rack, extract the
drive,
> open SCSI capable PC and install the drive, power it up and run the
format,
> then re-install everything. This is way too much trouble for the expected
> benefit, at least for my situation.

    Again, check into sformat.  I can't get a good URL currently, but I
think the current version is 3.5 from what I see, and it's from that fellow
Joerg Schilling who does cdrecord.  A good program, but you need generic
scsi devices to work it, as sofrmat bypasses the scsi driver to operate.

> --Cal Webster
>
> P.S. Why don't you post to the list?

    I did this time, forgot on the first message.  :)

        Diamon



