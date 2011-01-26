From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 26 Jan 2011 04:38:54 -0500
Message-ID: <20110126093854.GA17538@infradead.org>
References: <20110118210112.D13A236C@gemini.denx.de>
 <20110125171017.GA24921@infradead.org>
 <20110125184115.1119FB187@gemini.denx.de>
 <20110125213523.GA14375@infradead.org>
 <20110126071616.824BEBB0B9@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110126071616.824BEBB0B9@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 26, 2011 at 08:16:16AM +0100, Wolfgang Denk wrote:
> I will not have a single file system, but several, so I'd probably go
> with LVM. But - when I then create a LV, eventually smaller than any
> of the disks, will the data (and thus the traffic) be really distri-
> buted over all drives, or will I not basicly see the same results as
> when using a single drive?

Think about it:  if you're doing small IOPs, they usually are smaller
than the stripe size and you will hit only one disk anyway.  But with
a raid0 which disk you hit is relatively unpredictable.  With a
concatentation aligned to the AGs XFS will distribute processes writing
data to the different AGs and thus the different disks, and you can
reliably get performance out of them.

If you have multiple filesystems the setup depends a lot on the
workloads you plan to put on the filesystems.  If all of the filesystems
on it are busy at the same time just assigning disks to filesystems 
probably gives you the best performace.  If they are busy at different
times, or some are not busy at all you first want to partition the disk
into areas for each filesystem and then concatenate them into volumes
for each filesystem.


> [[Note: Block write: drop to 60%, Block read drops to <50%]]

How is the cpu load?  delaylog trades I/O operations for cpu
utilization.  Together with a raid6, which apparently is the system you
use here i might overload your system.

And btw, in future please state you have numbers for a totally different
setup then the one you're asking questions for.  Comparing a raid6 setup
to striping/concatenation is completely irrelevant.

> 
> [[Add nobarriers]]
> 
> # mount -o remount,nobarriers /mnt/tmp
> # mount | grep /mnt/tmp
> /dev/mapper/castor0-test on /mnt/tmp type xfs (rw,noatime,delaylog,logbsize=262144,nobarriers)

 a) the option is called nobarrier
 b) it looks like your mount implementation is really buggy as it shows
    random options that weren't actually parsed and accepted by the
    filesystem.

> [[Again, degradation of about 10% for block read; with only minod
> advantages for seq. delete and random create]]

I really don't trust the numbers.  nobarrier sends down less I/O
requests, and avoids all kinds of queue stalls.  How repetable are these
benchmarks?  Do you also see it using a less hacky benchmark than
bonnier++?

