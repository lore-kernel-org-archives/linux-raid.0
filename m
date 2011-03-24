From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 00:52:00 -0500
Message-ID: <4D8ADC00.5010709@hardwarefreak.com>
References: <4D837DAF.6060107@hardwarefreak.com>	<20110319090101.1786cc2a@notabene.brown>	<4D8559A2.6080209@hardwarefreak.com>	<20110320144147.29141f04@notabene.brown>	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>	<4D868C36.5050304@hardwarefreak.com>	<20110321024452.GA23100@www2.open-std.org>	<4D875E51.50807@hardwarefreak.com>	<20110321221304.GA900@www2.open-std.org>	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>	<20110322101403.GA9329@www2.open-std.org>	<4D89B519.3020907@hardwarefreak.com> <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Roberto Spadim put forth on 3/23/2011 10:57 AM:
> it's something like 'partitioning'? i don't know xfs very well, but ...
> if you use 99% ag16 and 1% ag1-15
> you should use a raid0 with stripe (for better write/read rate),
> linear wouldn't help like stripe, i'm right?

You should really read up on XFS internals to understand exactly how
allocation groups work.

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

I've explained the basics.  What I didn't mention is that an individual
file can be written concurrently to more than one allocation group,
yielding some of the benefit of striping but without the baggage of
RAID0 over 16 RAID10 or a wide stripe RAID10.  However, I've not been
able to find documentation stating exactly how this is done and under
what circumstances, and I would really like to know.  XFS has some good
documentation, but none of it goes into this kind of low level detail
with lay person digestible descriptions.  I'm not a dev so I'm unable to
understand how this works by reading the codde.

Note that once such a large file is written, reading that file later
puts multiple AGs into play so you have read parallelism approaching the
performance of straight disk striping.

The problems with nested RAID0 over RAID10, or simply a very wide array
(384 disks in this case) are two fold:

1.  Lower performance with files smaller than the stripe width
2.  Poor space utilization for the same reason

Let's analyze the wide RAID10 case.  With 384 disks you get a stripe
width of 192 spindles.  A common stripe block size is 64KB, or 16
filesystem blocks, 128 disk sectors.  Taking that 64KB and multiplying
by 192 stripe spindles we get a stripe size of exactly 12MB.

If you write a file much smaller than the stripe size, say a 1MB file,
to the filesystem atop this wide RAID10, the file will only be striped
across 16 of the 192 spindles, with 64KB going to each stripe member, 16
filesystem blocks, 128 sectors.  I don't know about mdraid, but with
many hardware RAID striping implementations the remaining 176 disks in
the stripe will have zeros or nulls written for their portion of the
stripe for this file that is a tiny fraction of the stripe size.  Also,
all modern disk drives are much more efficient when doing larger
multi-sector transfers of anywhere from 512KB to 1MB or more than with
small transfers of 64KB.

By using XFS allocation groups for parallelism instead of a wide stripe
array, you don't suffer from this massive waste of disk space, and,
since each file is striped across fewer disks (12 in the case of my
example system), we end up with slightly better throughput as each
transfer is larger, 170 sectors in this case.  The extremely wide array,
or nested stripe over striped array setup, is only useful in situations
where all files being written are close to or larger than the stripe
size.  There are many application areas where this is not only plausible
but preferred.  Most HPC applications work with data sets far larger
than the 12MB in this example, usually hundreds of megs if not multiple
gigs.  In this case extremely wide arrays are the way to go, whether
using a single large file store, a cluster of fileservers, or a cluster
filesystem on SAN storage such as CXFS.

Most other environments are going to have a mix of small and large
files, and all sizes in between.  This is the case where leveraging XFS
allocation group parallelism makes far more sense than a very wide
array, and why I chose this configuration for my example system.

Do note that XFS will also outperform any other filesytem when used
directly atop this same 192 spindle wide RAID10 array.  You'll still
have 16 allocation groups, but the performance characteristics of the
AGs change when the underlying storage is a wide stripe.  In this case
the AGs become cylinder groups from the outer to inner edge of the
disks, instead of each AG occupying an entire 12 spindle disk array.

In this case the AGs do more to prevent fragmentation than increase
parallel throughput at the hardware level.  AGs do always allow more
filesystem concurrency though, regardless of the underlying hardware
storage structure, because inodes can be allocated or read in parallel.
 This is sue to the fact each XFS AG has its own set of B+ trees and
inodes.  Each AG is a "filesystem within a filesystem".

If we pretend for a moment that an EXT4 filesystem can be larger than
16TB, in this case 28TB, and we tested this 192 spindle RAID10 array
with a high parallel workload with both EXT4 and XFS, you'd find that
EXT4 throughput is a small fraction of XFS due to the fact that so much
of EXT4 IO is serialized, precisely because it lacks XFS' allocation
group architecture.

> a question... this example was with directories, how files (metadata)
> are saved? and how file content are saved? and jornaling?

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

> speed of write and read will be a function of how you designed it to
> use device layer (it's something like a virtual memory utilization, a
> big memory, and many programs trying to use small parts and when need
> use a big part)

Not only that, but how efficiently you can walk the directory tree to
locate inodes.  XFS can walk many directory trees in parallel, partly
due to allocation groups.  This is one huge advantage it has over
EXT2/3/4, ReiserFS, JFS, etc.

-- 
Stan
