From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [OT] best tape backup system?
Date: Tue, 22 Feb 2005 15:41:28 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502221108550.4157@lion.drogon.net>
References: <20050222102827.GA25255@apartia.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <20050222102827.GA25255@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
