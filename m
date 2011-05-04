From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Mirrored volume peformance questions
Date: Wed, 4 May 2011 10:13:39 +0200
Message-ID: <20110504081339.GB414@www2.open-std.org>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com> <BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com> <20110503213430.GC24265@www2.open-std.org> <ipqvv6$ru1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ipqvv6$ru1$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 04, 2011 at 09:42:40AM +0200, David Brown wrote:
> raid10,far is better for sequential reads - it gives better-than-raid0 
> performance on average since it will do striped reads from the faster 
> outer tracks.  And for multi-threaded reads, it should also be a little 
> faster than other raid10 layouts (and raid1, which is much the same as 
> raid10,near).  Since it prefers to get the data from the outer half, you 
> get the benefits of short-stroking your disks - faster transfer speeds 
> and less head movement.
> 
> The cost of raid10,far is greater head movement for writes - but that is 
> not the OP's main concern.

yes, in theory this is so. But two reasons almost eliminates this in
practice. First, the processes do not wait for completion of the IO of
writes, the processes only deliver the data to the file buffer cache of
the kernel, which then periodically flushes the data to the disk drives.
Second, the flushing of the data is ordered so that the collected data
buffers are written as much sequentially as possible to the drives.
This goes for all Linux MD RAID1/RAID10 layouts. Given that random
writes are random over the whole set of drives, for any mirrored
raid1/raid10 layout, the flushing of the data is about the same.

best regards
keld
