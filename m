From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 13:13:25 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503081133140.4055@lion.drogon.net>
References: <422D327D.11718.F8DB3@localhost>  <200503080414.j284EG510309@www.watkins-home.com>
  <16941.11443.107607.735855@cse.unsw.edu.au>  <62b0912f0503072120776e0b56@mail.gmail.com>
  <16941.14813.465306.72004@cse.unsw.edu.au>  <62b0912f05030721465e84e4da@mail.gmail.com>
  <16941.16439.595486.231598@cse.unsw.edu.au>  <62b0912f050307222494fe17f@mail.gmail.com>
  <422D625C.5020803@medien.uni-weimar.de> <62b0912f0503080057488f13ad@mail.gmail.com>
 <422D83B1.5060709@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <422D83B1.5060709@medien.uni-weimar.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 Mar 2005, Tobias Hofmann wrote:

> > I stuffed a bunch of cheap SATA disks and crappy controllers in an old
> > system. (And replaced the power supply with one that has enough power
> > on the 12V rail.)
> >
> > It's running 2.4, and since it's IDE disks, I just call 'hdparm
> > -S<whatever>' in rc.local,
> > which instructs the disks to go on standby whenever they've been idle
> > for 10 minutes.
>
> I had found postings on the net claiming that doing so without
> unmounting the fs on the raid, this would lead to bad things happening -
>   but your report seems to prove them wrong...

I've been using something called noflushd on a couple of small "home
servers" for a couple of years now to spin the disks down. I made a
posting about it here some time back and the consensus seemed to be (at
the time) that it all should "just work"... And indeed it has been just
working.

They are only running RAID-1 though, 2.4 and ext2. I understand the ext3
would force spin-up every 5 seconds which would sort of defeat it. There
are other things to be aware of to (things that will defeat using hdparm)
- making sure every entry in syslog.conf is -/var/log/whatever (ie. with
the hyphen prepended) to stop if doing the fsync on every write which will
spin up the disks. They are on UPSs, but they have been known to run-out
in the past )-: so a long fsck and some data loss is to be expected.

Essentially noflushd blocks the kernel from writing to disk until memory
fills up.. So most of the time the box sits with the disks spun down, and
only spins up when we do some file reading/saving to them.

Noflushd is at http://noflushd.sourceforge.net/ and claims to work with
2.6, but says it will never work with journaling FSs like ext3 and XFS.
(which is understandable)

It's a bit weird at times, but very predictable. It takes 8 seconds to
spin the disks up, and sometimes I login to it, suffer the delay, then get
a 2nd (frustrating :) delay as it spins up the other disk in a RAID-1 set
to read some more.

Here are some recent entries from the log-file: (hda & c are part of a
raid-1 set)

Mar  7 06:55:34 watertower noflushd[376]: Spinning down /dev/hda.
Mar  7 06:55:35 watertower noflushd[376]: Spinning down /dev/hdc.
Mar  7 14:10:06 watertower noflushd[376]: Spinning up /dev/hdc after 434 minutes.
Mar  7 14:40:13 watertower noflushd[376]: Spinning down /dev/hdc.
Mar  8 06:25:13 watertower noflushd[376]: Spinning up /dev/hda after 1409 minutes.
Mar  8 06:25:13 watertower noflushd[376]: Spinning up /dev/hdc after 944 minutes.
Mar  8 06:55:14 watertower noflushd[376]: Spinning down /dev/hda.
Mar  8 06:55:25 watertower noflushd[376]: Spinning down /dev/hdc.
Mar  8 13:01:02 watertower noflushd[376]: Spinning up /dev/hdc after 365 minutes.
Mar  8 13:01:12 watertower noflushd[376]: Spinning up /dev/hda after 365 minutes.

Thats under 2.4.20 (gosh, is it that old? Uptime is 216 days!) That
machine is my firewall and a small server, so it's not used that often
interactively. I have the timeout for spinning the disks down set to 30
minutes, as I found then when ser to 5-10 minutes, it was sometimes
spinning them down when I was doing some work on it which was a bit
frustrating and probably not that good for the disks themselves.

I'm in the middle of building up a new home server - looking at RAID-5 or
6 and 2.6.x, so maybe it's time to look at all this again, but it sounds
like the auto superblock update might thwart it all now...

Gordon
