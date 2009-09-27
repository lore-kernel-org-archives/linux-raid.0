From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Sun, 27 Sep 2009 17:00:11 -0500
Message-ID: <20090927215951634.XTHZ19321@cdptpa-omta04.mail.rr.com>
References: <9510.91067.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9510.91067.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'adfas asd' <chimera_god@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > Commercial flagging is writing like hell to the array,
> > according to
> > > iotop.

	You might be a little more quantitative about "writing like hell".
How many MBps?  See my last message.

> > I don't know how else to assess what's
> > going on.  The drives

	You might look at the output of `watch iotstat -m 1 2`, as well.
Iotop breaks down disk usage by application.  Iostat shows the total
utilization of each disk element by all processes.

> > > are constantly hammering, and my Myth menu moves get
> > very slow during
> > > flagging, even with the latest 2TB disk drives and
> > RAID10.

	Unless perhaps your swap is on the array, as well, that doesn't
really suggest a drive system bottleneck.  What size is your swap, your main
memory, and how much memory and swap do you show being utilized during
flagging?  For any system doing any sort of video analysis, I suggest at
least 2G of memory.  You say this is a 3GHz CPU, but how many cores and what
width?  I recommend at least a dual core and a 64 bit, unless you have a
RISC based system.

	I have a very different setup than you, and I don't have any Linux
based commercial scan tools handy at the moment, but I have Video Redo on a
Windows XP 64 Pro machine with a dual core 3.2GHz CPU and 8G of RAM.  When I
run a commercial scan on a single video, the system slams both CPUs to more
than 50% and gulps more than 2G of real memory.  Meanwhile, the system is
reading steadily off the video array, but only at around 8MBps.  Even 20
MBps would not be tasking for the most inefficient of array topologies, and
I expect not even with a moderate amount of database activity, constant
seeking notwithstanding.

	Even so, having a completely separate cache group for the database
not touched by any reads or writes of the video files definitely can't hurt.
If you separate the database onto an independant high performance drive then
its entire 32MB is dedicated to caching the database.  If you employ a
striped array, then the database cache is N x 32MB, where N is the number of
drives.  This cannot hurt menu responsiveness of the MythTV menu.  (I use
Series III TiVos fed by the video server, so menu operations are on a
separate machine from file manipulations, including commercial elimination.)
I definitely suggest having plenty of memory to prevent any significant
amount of swapping, and having the swap, the database, and the video files
on three separate drive subsystems.

> Not transcoding at the same time, just the standard commercial flagging.
> The drive light is constantly on.

	That's to be expected.  After all, it should only take a few
microseconds to inspect a pair of successive frames for a black transition
before the system reads the next frame.  Even allowing for caching, the
system should be reading the array pretty much continuously in human terms.

> CPU is pretty busy (3GHz) reaching 180%
> when simultaneously flagging 2 videos.

	Again, see my last message.  It doesn't sound to me like you are
having a particularly large drive througput problem.  Of course, it can't
hurt to optimize the drive subsystem, but I am skeptical it will do much to
address your issue.

