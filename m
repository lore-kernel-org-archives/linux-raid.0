From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 15:35:32 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402151523000.11668-100000@coffee.psychology.mcmaster.ca>
References: <20040215120525.GA19434@rap.rap.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040215120525.GA19434@rap.rap.dk>
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > The you don't get as good performance because hdc1 is slow enough to
> > really drag it down.

right.

> I would have thought the disks would have worked towards gaining
> performance enhancements in some cumulative way, is that not so, in theory?

raid0 stripes IO across devices, so more devices help, in general.
but suppose your config stores 1k per disk.  a 3k write would 
touch all three disks.  when would that write complete?  according
to your numbers, hdc1 takes much longer than the other two.
that means that a large upper-level IO request (all three disks)
will complete at about 3x16 MB/s (ignoring overhead, etc).

> So why is 3 disks slower than 2?

because two of the disks are sometimes idle while the slow one completes.
since striping is always parallel across all disks, the system can't 
somehow find other IO to do on the fast disks while waiting for the slow one.

> > You probably can't get 100mb/s with the two because that would be pretty
> > efficient, and there's probably more overhead than that.

100 MB/s is a pretty agressive goal for a duron: the speed of the CPU and
memory bandwidth *DO* have a significant effect on how well raid0 scales,
and where it tops out.  hdparm -t is also quite cpu-inefficient, as
benchmarks go.

> > Shouldn't the 80gb drive be going faster than 16mb/s though?  Have you
> > checked hdparm to make sure dma and all the goodies are turned on for
> > it?

16 MB/s is a clear config or measurement mistake.  16 MB/s is the speed of
disks from 5+ years ago, and >= 80G didn't exist back then.

regards, mark hahn.


