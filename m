From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [OT] best tape backup system?
Date: Tue, 22 Feb 2005 11:50:55 -0500
Message-ID: <200502221651.j1MGp1922341@www.watkins-home.com>
References: <Pine.LNX.4.56.0502221108550.4157@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502221108550.4157@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gordon Henderson' <gordon@drogon.net>, 'Louis-David Mitterrand' <vindex@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have NOT been able to share a SCSI cable/card with disks and a tape drive.
Tried for days.  I would get disk errors, or timeouts.  I corrected the
problem by putting the tape drive on a dedicated SCSI bus/card.  I don't
recall the details of the failures, since it has been well over a year now.
But I do know I only had problems while using the tape drive and the disks
at the same time.  Like, during a backup.  The disks were happy while the
tape drive was idle.  I also swapped parts, it had no effect.  I assumed
Linux does not like to share SCSI.

I have not had problems with 2 or more tape drives on the same SCSI
bus/card.  I think I had 3 at one time.

Amanda...  The last time I checked, incremental backups require a different
tape each time.  You will need a lot of tapes.  If a full backup fits on a
single tape, just do a full backup each night.  I need many tapes to do a
full backup, but a single tape can hold many daily incremental backups.  I
deemed Amanda to wasteful for me.  I use home made scripts and cpio and do a
full backup about once per month, and do nightly incremental backups to 1
tape.  Once the daily tape is full I do another full backup.  Works very
well for me.  But, restoring is a pain, but that is very rare for me, only
once in 1+ years, so far.  My scripts seek the tape as required, so I can
eject the tape if needed, as long as I put it back in time for the nightly
backup.

If anyone gets 1.3 to 1 compression, that is real good!!!!  IMO.  The last
time I checked, I got about 1.1 to 1.  What a marketing scam!!!!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
Sent: Tuesday, February 22, 2005 10:41 AM
To: Louis-David Mitterrand
Cc: linux-raid@vger.kernel.org
Subject: Re: [OT] best tape backup system?

On Tue, 22 Feb 2005, Louis-David Mitterrand wrote:

> I am considering getting a Sony SAIT 3 with 500G/1TB tapes, which seems
> like a nice solution for backuping a whole server on a single tape.

I've been using DLT tapes for many years now, prior to that DAT tapes and
Exabytes before that... Capacity is the one thing that you struggle with
on tapes, and most of the servers I've built recently have had their disk
partition sizes matched to the best DLT tape drive we could afford at the
time. Your Sony tapes of 500GB (native, I presume and up to 1TB
compressed) look quite attractive though, but I've no experience of how
reliable they might be...

Beware of the compression though - it all depends on what your data-set is
- I can rarely get much beyond 1.3 times the native/raw capacity, but if
all you are storing is text files you may well achieve close to 2x raw
capacity.

One thing I'd recomend is getting a seprate SCSI card just for the tape
drive if possible, rather than daisy-chain it to the end of an existing
SCSI bus with drives. You'll improve performance, and you'll also be able
to hot remove/add the tape drive should you need to (assuming external
drives) without the wory of upsetting a bus with disks passing live data.
I'm moving towards external drives now to make it easier to replace the
drive should it ever fail while maintaining server avalability.

> Has anyone used that hardware and can comment on its performance,
> linux-compatibility or otherwise?
>
> Is there a better solution out there?

Things that I was looking for was long-term viability - (eg) what does the
road-map look like for the Sony drives. Availability (and price!) of
media, and so on, as well as things like being able to read older tapes on
newer drives, should you get a bigger drive in the future.

> Is it worth waiting a short while for some new upcoming technology?

Personally, no. Strike while the iron is hot, Carpe Jugulum, and stuff
like that! Get the best you can afford today, otherwise you'll always be
chasing that next best thing thats just round the corner without actually
implementing a solution.

Other things to consider is the software you use to do the backup - I've
been using Amanda for many (>12 ish) years with good results. It uses
standard dump/xfsdump or tar as the underlying tape storage format, so
even if you lose the Amanda database, you can still restore from the
tapes, however, I have to admit that Amanda might not be the easiest thing
to install for the first time and I've not actually looked for an
alternative recently, so don't really have a handle on what else is out
there, but you want something that will email you with the right 'next'
tape to put in and email you the results, as well as something that will
tell you what tape holds the latest versions of what files (especially if
you ever get into the dreaded situation where you have to do incremental
dumps) Amanda also checks that you have the right tape in before it
overwrites it (it keeps a seaprate file at the start of the tape with the
tape name) This is useful when faced with a dozen tape drives and you are
in a hurry...

Tar (or star) might seem like a good way to dump a filesystem, but it's
harder to extract a single file or directory off the tape unless you have
a good index of everything thats on the tape. Restore has an interactive
mode which lets you browse the index of the tape and add files and folders
as needed before hitting the extract button and going away for several
cups of coffee while it does its thing.

There are potential problems with dump - there is a small but finite
chance of data corruption when you dump (or even tar) a live filesystem,
so I've been building servers with 2x the disk capacity and I rsync the
live partition to the 'yesterday' partition, then remount that read-only
and dump from that.  So-far so good, and the punters get a instant restore
if they accidentally delete a file. (Accidental file deletion is a PITA,
taking sometimes many hours to restore from tape)

Ah, found something relevant:

  http://dump.sourceforge.net/isdumpdeprecated.html

That article is well-worth a read.

Do check your restore mechanism, whatever method you use! Do deliberately
remove (rename!) a file or directory and try to get it back from tape, so
you are familiar with the mechanisms should you be called to do so for
real. Restoring a entire partition is usually a lot easier than just a
single file though, and don't forget to archive your root partition (if
it's separate, so you can get back all your changes to the init files,
etc. if you ever have to restore from scratch.

Good luck,

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

