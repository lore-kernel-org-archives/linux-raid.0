From: Gordon Henderson <gordon@drogon.net>
Subject: RE: [OT] best tape backup system?
Date: Tue, 22 Feb 2005 17:40:10 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502221703210.4157@lion.drogon.net>
References: <200502221651.j1MGp1922341@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <200502221651.j1MGp1922341@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2005, Guy wrote:

> I have NOT been able to share a SCSI cable/card with disks and a tape
> drive. Tried for days.  I would get disk errors, or timeouts.  I
> corrected the problem by putting the tape drive on a dedicated SCSI
> bus/card.  I don't recall the details of the failures, since it has been
> well over a year now. But I do know I only had problems while using the
> tape drive and the disks at the same time.  Like, during a backup.  The
> disks were happy while the tape drive was idle.  I also swapped parts,
> it had no effect.  I assumed Linux does not like to share SCSI.

Linux is fine with multiple devices on SCSI - scanners, drives, tapes. I
haven't had problems with these combinations. The "usual culprit" is
termination. Either not enough or too much! You need termination at both
ends of the bus - one end is usually (but not always) the SCSI card, and
all cards I've used in the past few years have had the ability to turn
termination on or off (You turn it off if the card is not at one end of
the bus) Some tape drives I've used also have the ability to turn
termination on, or not - sometimes you set the drive number to one range
for termination, another range for not (eg. 0-7 no termination, 8-15
active termination). It's a real PITA to get right at times.

> I have not had problems with 2 or more tape drives on the same SCSI
> bus/card.  I think I had 3 at one time.
>
> Amanda...  The last time I checked, incremental backups require a different
> tape each time.  You will need a lot of tapes.  If a full backup fits on a
> single tape, just do a full backup each night.  I need many tapes to do a
> full backup, but a single tape can hold many daily incremental backups.  I
> deemed Amanda to wasteful for me.  I use home made scripts and cpio and do a
> full backup about once per month, and do nightly incremental backups to 1
> tape.  Once the daily tape is full I do another full backup.  Works very
> well for me.  But, restoring is a pain, but that is very rare for me, only
> once in 1+ years, so far.  My scripts seek the tape as required, so I can
> eject the tape if needed, as long as I put it back in time for the nightly
> backup.

Yup. One tape per backup run with Amanda. Way back when tape capacity
exceeded disk capacity, I used Amanda to backup many machines to one tape
every night - that was its original strength, the ability to backup many
machines over the LAN to one tape drive. These days with disk capacities
generally exceeding tapes, it's not like that anymore (although I still
have some smaller servers backed up to a non-local tape drive for reasons
of economy)

> If anyone gets 1.3 to 1 compression, that is real good!!!!  IMO.  The
> last time I checked, I got about 1.1 to 1.  What a marketing scam!!!!

Compression is always a weirdism - I'm guessing your data is music, video
or pictures - stuff thats already compressed which won't compress twice.
Typical "officy" type data would be stuff that generally compresses well -
text documents, spreadsheets, program source code (& compiled binaries)
etc. Amanda can compress data and in some cases better than the tape
drives (using gzip, etc), but it's slow and makes restoring more
interesting...

I think Sony are claiming 2.3:1 with their new tapes - well, they'll get
that with text-files, but nothing near that with anything else!

Gordon
