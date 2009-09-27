From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Sun, 27 Sep 2009 15:44:49 -0500
Message-ID: <20090927204429247.THVL26368@cdptpa-omta03.mail.rr.com>
References: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Not transcoding at the same time, just the standard commercial
> > flagging.  The drive light is constantly on.  CPU is pretty busy
> > (3GHz) reaching 180% when simultaneously flagging 2 videos.
> >
> > The database in in the / partition of the array, and the videos are in
> > the /home partition on it.  No idea why the array is so busy.
> >
> If they're both on the array, then that's the problem.  The partitioning
> doesn't make difference to the issue - the drive heads are having to
> seek frantically between reading the data file and writing the database.

	You are perfectly correct that having the database and the video
files on the same array presents a very significant bottleneck, but I think
something else must be going on, as well.  If the CPU were having to wait
for drive seeks, then the CPU utilization would never be that high.  What's
more, while I am not intimately familiar with MythTV's database structure, I
don't think database writes are done very much.  Typically, in such
applications, one only marks the audio / video transition points, where the
video fades to black and the audio squelches and then again when a black
transitions to live video.  The rest of time should ordinarily be spent
entirely in memory (other than reading the video file, of course), analyzing
the video data to search for such transitions and decide whether the
transition in question is the entry or exit point for a group of
commercials.  I would expect a write to the database would only occur after
examining several minutes worth of video data - probably several seconds
worth of reading video.

	I cannot say for certain, but I suspect he might see significant
performance gains by increasing the size of his memory and perhaps his swap
partition, as well.  He also might do well to adjust the priority of the
threads handling the commercial flagging.  He hasn't mentioned what his
actual drive performance is, but his main complaint seems to me not to be
drive system performance but CPU loading.

