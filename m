From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 21:49:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040215204957.GA21117@rap.rap.dk>
References: <20040215120525.GA19434@rap.rap.dk> <Pine.LNX.4.44.0402151523000.11668-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402151523000.11668-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 15, 2004 at 03:35:32PM -0500, Mark Hahn wrote:
> > > The you don't get as good performance because hdc1 is slow enough to
> > > really drag it down.
> 
> right.
> 
> > I would have thought the disks would have worked towards gaining
> > performance enhancements in some cumulative way, is that not so, in theory?
> 
> raid0 stripes IO across devices, so more devices help, in general.
> but suppose your config stores 1k per disk.  a 3k write would 
> touch all three disks.  when would that write complete?  according
> to your numbers, hdc1 takes much longer than the other two.
> that means that a large upper-level IO request (all three disks)
> will complete at about 3x16 MB/s (ignoring overhead, etc).

So max thruput in sequential read would never be faster than the slowest
disk times the total number of drives. Sounds right there, then
3 * 16 is 48, close to the observed value of 45.

> > > You probably can't get 100mb/s with the two because that would be pretty
> > > efficient, and there's probably more overhead than that.
> 
> 100 MB/s is a pretty agressive goal for a duron: the speed of the CPU and
> memory bandwidth *DO* have a significant effect on how well raid0 scales,
> and where it tops out.  hdparm -t is also quite cpu-inefficient, as
> benchmarks go.

Why should the duron CPU speed be a problem? Or the RAM?

> > > Shouldn't the 80gb drive be going faster than 16mb/s though?  Have you
> > > checked hdparm to make sure dma and all the goodies are turned on for
> > > it?
> 
> 16 MB/s is a clear config or measurement mistake.  16 MB/s is the speed of
> disks from 5+ years ago, and >= 80G didn't exist back then.

yeah, something is wrong there. I observed a going of about 40 MB/s
a couple of days ago on the same disk.

keld
