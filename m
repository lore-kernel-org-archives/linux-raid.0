From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: southbridge/sata controller performance?
Date: Mon, 5 Jan 2009 01:27:09 +0100
Message-ID: <20090105002709.GA24980@rap.rap.dk>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake> <alpine.DEB.1.10.0901041630000.20628@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901041630000.20628@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 04, 2009 at 04:32:27PM -0500, Justin Piszcz wrote:
> 
> 
> On Sun, 4 Jan 2009, Matt Garman wrote:
> 
> >On Sun, Jan 04, 2009 at 04:55:18AM -0500, Justin Piszcz wrote:
> >
> >>What are you trying to accomplish?
> >
> >Trying to determine what motherboard would be ideal for a home NAS
> >box AND have the lowest power consumption... the AMD solutions seem
> >to win on the power consumption front, but I'm not sure about the
> >performance.

> How fast do you need? Gigabit is only ~100MiB/s.  Are you buying a 10Gbps
> card?

My impression is that using on-mobo sata controllers gives you adequate
bandwidth. SATA-controllers with 20 Gbit/s - or 2,5 GB/s bidirectional
speeds are more than adequate for say 4 disks of 80 - 120 MB/s speed.
And anyway, if you run in a multiprocess environment the random access
read or write speed per disk is normally only about half of the
sequential speed.

I have a mobo with 2 SATA controllers with 4 ports each, with my GB
disks, it can generate max 700 MB/s which is much less than the 2,5 GB/s
that the southbridge can deliver.

Using 1 Gbit/s ethernet connections may easily become a bottleneck. 

We do have a bottleneck section on our wiki:
http://linux-raid.osdl.org/index.php/Performance#Bottlenecks

> >>As Roger pointed out, doing a dd is a good way to test, from each
> >>disk, simultaneously, on an old Intel P965 board I was able to
> >>achieve 1.0-1.1Gbyte/sec doing that with 12 Velociraptors and
> >>1.0Gbyte/sec reads on the XFS filesystem when dd (reading) large
> >>data on the volume.  Approx 500-600MiB/s from the southbridge, the
> >>other 400MiB/s from the northbridge.
> >
> >Is the "parallel dd test" valid if I do a raw read off the device,
> >e.g. "dd if=/dev/sda of=/dev/null"?  All my drives are already in an
> >md array, so I can't access them individually at the filesystem
> >level.
> Yes.  You do not need to access them at the filesystem level.  Both RAW
> and on the filesystem, my benchmarks were the same when reading from 10 
> disks
> raw or reading in a large file with dd using XFS as the filesystem.

My impression is different, it does matter for certain raid types in a parallel dd test
whether you run it off the raw devices or off a file system. At least if you dd
different files in parallel off the same device.

best regards
keld
