From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Wed, 30 Sep 2009 10:36:17 -0500
Message-ID: <20090930153618488.QQIE19321@cdptpa-omta04.mail.rr.com>
References: <382957.85230.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <382957.85230.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> --- On Sun, 9/27/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >     You might be a little more quantitative
> > about "writing like hell".
> > How many MBps?  See my last message.
> 
> I just started a mythcommflag on a video, and it is not behaving the same.
> It's acting more like ppl here would expect with ~3.7MB/s read and 3.5KB/s
> write.  I'll have to wait for a normal automatic job and do these checks.

	Hmm.  It's odd the process would provide different performance when
automated.  It's possible there's a problem at the application layer.

 
> >     Unless perhaps your swap is on the
> > array, as well, that doesn't
> > really suggest a drive system bottleneck.  What size
> > is your swap, your main
> > memory, and how much memory and swap do you show being
> > utilized during
> > flagging?  For any system doing any sort of video
> > analysis, I suggest at
> > least 2G of memory.  You say this is a 3GHz CPU, but
> > how many cores and what
> > width?  I recommend at least a dual core and a 64 bit,
> > unless you have a
> > RISC based system.
> 
> Yes swap is on the same array, different part.  4G of memory and an E8400
> Intel CPU (2 cores).  Debian 64bit OS, and self-compiles MythTV-fixes
> 0.21.  For the array 2 each WD Green 2TB drives.

	Do you have a GUI installed on the box?  Gnome has a sort of nifty
resource monitor which shows swap and memory usage in real time.  If not,
you can use watch along with vmstat and free to see what's happening with
your memory usage.  If you are writing to the swap file and the database and
both are on your array, it could definitely affect performance, especially
since it is possible almost as much data is being written to the swap file
as is being read from the video files.  I believe there are also free tools
out there which monitor I/O and memory usage for specific applications and /
or threads.  A Google search may be in order if the less specific tools
point in that direction.

	It's possible 4G of memory is insufficient, although I would not
expect so for this application.  If the swap file is quiescent, then memory
size is not the issue, but if the system is swapping a great deal, then a
memory upgrade is definitely indicated, and indeed is a very inexpensive
fix.

