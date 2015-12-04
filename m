From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Fri, 4 Dec 2015 10:08:06 -0600
Message-ID: <CAE9DZUTF3KBGoKVOX4u3+mii5imaVUfEj8kbNjfYMP=8=pHLQA@mail.gmail.com>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
	<20151202010745.GC9812@www5.open-std.org>
	<F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
	<565F03F2.3070803@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
	<565F1035.10800@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
	<565F136F.2090709@turmel.org>
	<CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
	<F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
	<566059E8.60804@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 4, 2015 at 7:40 AM, Robert Kierski <rkierski@cray.com> wrote:
> It turns out the problem I'm experiencing is related to thread count.  When I run XDD with a reasonable queuedepth parameter (32), I get horrible performance.  When I run it with a small queuedepth (1-4), I get expected performance.
>
> Here are the command lines:
>
> Horrible Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 32  -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>
> GOOD Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 1 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>
> BEST Performance:
> xdd -id commandline -dio -maxall -targets 1 /dev/md0 -queuedepth 3 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>
> BAD Performance
> xdd -id commandline -dio -maxall -targets 1 /dev/md1 -queuedepth 5 -blocksize 1048576 -timelimit 10 -reqsize 1 -mbytes 5000 -passes 20 -verbose -op write -seek sequential
>
> Bob Kierski
> Senior Storage Performance Engineer
> Cray Inc.
> 380 Jackson Street
> Suite 210
> St. Paul, MN 55101
> Tele: 651-967-9590
> Fax:  651-605-9001
> Cell: 651-890-7461
>

Robert, is this with a RAID 6 array?  Also, what are the actual
throughput numbers you are getting?  Would it be possible for you to
capture the iostat -xm output and report the individual disk wMB/s and
also the disk utilization for RAID 6?
