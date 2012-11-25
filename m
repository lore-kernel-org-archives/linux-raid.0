From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 15:51:40 +0100
Message-ID: <20121125145140.GA3955@lazy.lzy>
References: <50B1BCBD.70306@zytor.com>
 <20121125101306.GA2373@lazy.lzy>
 <1759500.SiuUO4mi0r@workstation-home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1759500.SiuUO4mi0r@workstation-home>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 25, 2012 at 01:31:06PM +0100, Tommy Apel Hansen wrote:
> On Sunday 25 November 2012 11:13:06 Piergiorgio Sartor wrote:
> > On Sat, Nov 24, 2012 at 10:37:49PM -0800, H. Peter Anvin wrote:
> > > I was looking at the hot-replace (want_replacement) feature, and I
> > > had a thought: it would be nice to have this in a form which
> > > *didn't* fail the incumbent drive after the operation is over, and
> > > instead turned it into a spare.  This would make it much easier and
> > > safer to periodically rotate and test any hot spares in the system.
> > > The main problem with hot spares is that you don't actually know if
> > > they work properly until there is a failover...
> > 
> > I go for this one.
> > 
> > Actually, this was also my original thinking for
> > the "proactive replacement".
> > 
> > The only thing that, in addition, should be done,
> > is to keep the spare in sleep mode until needed
> > (either for hot replacement or for real replacement).
> > 
> > bye,
> 
> Hello, personally I would vote for an option to rotate spares into and array 
> like Peter suggests, keeping a drive idle doesn't guarrantee that it's 
> actually operational.

The point is that the "Power_On_Hours" parameter of SMART
is quite a good hint on the driver expected lifetime.

Or, better, that parameter can be used to decide when to
change a disk, independently from anything else.

In other words, it would be possible to decide to change
a disk (change, not rotate with the spare) each 10000 hrs.

If the spare are not idle, than this SMART parameter will
not be reliable anymore.

This means that the ideal operation would be to rotate
the spare so that, for example, each disk has 1000 hours
lifetime difference from all the others.
Let's say a 4+1 HDD RAID-5 should result in disks having
"Power_On_Hours" of 1000, 2000, 3000, 4000 and 5000. 
As soon as the oldest disk is X hours older than the spare,
it will be rotated (X could be 1000, in this case).

When a disk reaches 10000 (for example), it is eliminated
from the array and a new spare is required.

Again, this is possible only if the running time of each
disk is tracked properly, which means spares must be idling.

bye,

-- 

piergiorgio
