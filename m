From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 19:54:16 -0500
Message-ID: <20091025005419510.XTVS12118@cdptpa-omta02.mail.rr.com>
References: <516041.14853.qm@web38805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516041.14853.qm@web38805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> When I was trying to find man for mkfs.jfs I discovered that jfsutils was
> suddenly not installed.  I installed it and then could man mkfs.jfs .
> 
> I rebooted so I could plug in the second drive, and then md0 was getting
> mounted on /home as it should.  Indeed I have all my data again.  I don't
> understand what happened.

	Something erased or overwrote the data.  This is always a
possibility whenever the system files are maintained on a read-write file
system.  High reliability system place all their binaries and configuration
files on read-only mounts.  The Tivo, for example, does this.  Everything
(that is mounted) except /var is mounted read-only.  In order to make
changes to any of the OS or application code, / has to be re-mounted as
read-write.  It's a simple and elegant way of helping to prevent system
corruption.  It does mean ordinary users cannot load software, and it means
the sysadmin must remount the file system before attempting updates, but the
former may be a good thing, and the latter is no big deal.

> --- On Thu, 10/22/09, Majed B. <majedb@gmail.com> wrote:
> 
> > From: Majed B. <majedb@gmail.com>
> > Subject: Re: Is My Data DESTROYED?!
> > To: "adfas asd" <chimera_god@yahoo.com>
> > Cc: linux-raid@vger.kernel.org
> > Date: Thursday, October 22, 2009, 7:43 PM
> > I don't know exactly what went wrong
> > with your setup, so I can't tell
> > why it's not mounting.
> >
> > Did you check the output of dmesg | tail after a failed
> > mount?
> >
> > I'd suggest that you don't touch the disks, cables, nor the
> > array.
> >
> > Try running sudo fsck /dev/md0
> >
> > On Fri, Oct 23, 2009 at 5:18 AM, adfas asd <chimera_god@yahoo.com>
> > wrote:
> > >
> > > I don't understand exactly what it is to be done.  If
> > I can mount using a different superblock, do I then remove
> > one of the drives from the array so I can put that drive
> > away with my data until I can buy another drive to back up
> > the data to?  If so, how?

	You are confusing a failed file system with a failed drive.  One
only replaces a drive if it has failed (or seems about to fail).  A
corrupted file system (or other corrupted data) has nothing to do with RAID,
unless of course a RAID failure causes the data corruption.  In this event,
one must analyze the system very carefully to determine the cause of the
corruption and devise a good means of recovering the array and as much data
as can be recovered, not necessarily in that order.

> > > How is it that the superblock on -both- drives got
> > destroyed?  Isn't RAID10 supposed to be mirrored?

	You need to go back and read my earlier messages on the subject.
Mirroring a drive will *NOT* prevent data corruption, no matter how it is
mirrored.  Any data corruption will automatcialy be written to both drives,
unless the failure is due to a bad sector on one of the drives.

	Of course, as we now know, the file system "corruption" in your case
was due to a loss of the JFS utilities.

> > > > How could this possibly have
> > > > happened?  The whole idea of RAID is so
> > something like this
> > > > won't happen.

	No, it isn't.  The whole idea of RAID is to increase storage
capacity or to limit the impact to the system of a lost drive, or both.

> > > > I've lost confidence now in mdadm.  I have too
> > much
> > > > data to back up practically, and am now at a
> > loss.

	You keep saying that, but it is fundamentally untrue.  If you have
enough drives to implement a mirrored solution, then you also have enough
for a backup solution.  Again and again I have advised you to abandon this
strategy of a remote mirror and instead implement a main system and a backup
system.  If you choose, you can make them a pair of high availability
systems, although in your case (and mine) I think you would be better served
by a simple backup system maintained using rsync.  You could purchase one
extra drive to make the main system a RAID5 array.  That, or you could do
what I did and purchase three extra drives to make the main array RAID6 and
the backup array RAID5.  I'm a belt, suspenders, and both-hands-on-my-pants
kind of guy.

	At the very least, completely independent systems would have saved
you the major coronary you had when you discovered the file system could not
be mounted.

