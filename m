From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Good news / bad news - The joys of RAID
Date: Mon, 22 Nov 2004 23:26:48 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411221754520.4195@lion.drogon.net>
References: <200411221751.iAMHpAN32404@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411221751.iAMHpAN32404@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Nov 2004, Guy wrote:

> Yes, I was going for affordable!  A tape drive with native capacity of 160
> Gig costs over $2600 US (SDLT).  And tapes cost $89 each.  You need to do a
> lot of backups before tapes cost less than an IDE disk.  An IDE disk is so
> much faster too.

True (on the speed side) Although right now it's only just over 2 hours to
dump ~200GB on one of the servers I look after.

I can see a time where the only real solution is a combined disk/tape
system - right now, I'm taking a snapshot overnight off some servers, then
backing up from that - that at least gives the punters a "yesterday"
snapshot which is great for those "accidental" deletions where getting
stuff off tape might take 4-5 hours. Using rsync, or LVM, you can even
make multiple days of snapshots. (Although I'm not sure about LVM even
now, after having some problems with it causing crashes, and very slow
performance after snapshots had been taken, maybe it's time to look at it
again though)

> The best price I could find for a 160Gig ultra 100 was $107 Hitachi
> A Hitachi 160 Gig SATA disk is $113.
>
> SDLT tapes cost $89 each (10 for $890)
>
> I am sure you could get a quantity discount on tapes, but disk drives too.
>
> Now we just need to be able to hot plug ultra 100 disk drives.
> SATA hardware supports hot plug, but I read Linux does not support that yet.

I've had good results with SCSI hot pluggability and with a FireWire drive
where the underlying hardware uses the SCSI stack, also with USB mass
storage devices which look like SCSI drives (eg. my digital camera!)
So-far I've just used a little script to do the echo "scsi-hot-add 0 0 1
0" > /proc/scsi, etc. then mount /dev/sda1 and so on. I'm hoping that SATA
using the SCSI stack will be able to do this too, but I'm hearing
mutterings about problems with the device numbers, but so-far I've not had
any problems myself... So in that respect, going SCSI, or things that look
like SCSI drives might be the way to go...

> I do want to be able to remove my backup and put it in the shelf.  A
> business should have 2 copies where one goes off site.  I did have a power
> supply fail in a way that it fried everything in the box.  I think line
> voltage was send directly to the 12V or 5V line.  DVD drive, disk drive,
> motherboard, RAM, video card, ... all gone.   So if my backups were on-line
> with the same power supply as the main disk(s), all would have been lost.

Ouch. I've not had anythng this bad, (yet?) Different businesses have
different ideas about backup and archive (and there are legal implications
too for some companies)

One of my clients is a small web design house - their in-house server gets
backed up to a firewire drive ("lacie" I think the brand is) once a week,
as well as a daily snapshot on-line, and is remote backed up over the net
to one of my servers, they have 2 other servers for their client web sites
which I manage and I back these up to each other overnight - not perfect,
but usable, and as these are 200 miles away from me, I need these to be as
reliable as possible within the money restaints put upon me by my client
(mutter)

> Some people seem to think tape is better than disk.  Somehow since there is
> no filesystem, so you can't delete a file by mistake.  So, fine, just use
> the disk drive the same way.  Use cpio and output to /dev/hda or similar.

I actually use 'dump' to a file on their removable firewire drive which is
formatted ext2 - they have a 120GB drive and only 20GB of live data, so
plenty of room for multiple backups - all on the same drive... I'm going
to set them up with 'amanda' soon to try to automate it. I've used amanda
for many years no - PITA to setup, but once going, it's very good (with
tapes, anyway - I'm not actually sure I'll be able to get it to backup to
individual files on the single drive)

> The only thing tapes have that is better than disk drives is the eof and eot
> marks.  I can put 10-20 daily backups on the same tape and let the hardware
> track the position of each backup.  With disk, you would need to count the
> blocks used, and track the start and length of each.  Or you could use a
> file system, but like I said, some people seem to think that has too much
> risk.

I haven't found anything that beats tapes for ease of handling (physical
stacking and storage in nice boxes) and archiving. I have DLT tapes that
are 5 years old now that still read - the real problem with archiving is a
good management system, as well as realising the fact that nothing lasts
forever, so at some point you have to take those old tapes, read them back
onto disk and re-write them using the current technology, and hope the
current technology will still be about in 5 years time when you do it
again... (The good side is that densities have improved immensely, so
long-term storage costs ought to decrease...)

Gordon
