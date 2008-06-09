From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Mon, 9 Jun 2008 16:27:18 +0200
Message-ID: <20080609142717.GB24950@rap.rap.dk>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan> <e9c3a7c20806071846w60b74aeegdf3e39afb36b5d9a@mail.gmail.com> <8CA981CB5C2B4D6-E68-18E2@MBLK-M14.sysops.aol.com> <A20315AE59B5C34585629E258D76A97CA535E9@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97CA535E9@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: thomas62186218@aol.com, dan.j.williams@gmail.com, jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, ap@solarrain.com
List-Id: linux-raid.ids

On Mon, Jun 09, 2008 at 08:41:18AM -0500, David Lethe wrote:
> For faster random I/O:
>  * Decrease chunk size
>  * Migrate files that have higher random I/O to a RAID1 set, using disks
> with the lowest access time/latency
>  * If possible, use the /dev/shm file system 
>  * Determine I/O size of apps that produce most of the random I/O, and
> make sure that md+filesystem matches. If most random I/O is 32KB, then
> don't waste bandwidth by making md read 256KB at a time, or making it
> read 2x16KB I/Os. Also don't build md sets like 4-drive RAID5, (Do a
> 5-drive RAID5 set), because non-parity data isn't a multiple of 2. A
> 10-drive RAID5 set with heavy random I/O is also profoundly wrong
> because you are just removing the opportunity to have all of those heads
> processing random I/O. 
>  * If you only have one partition on a md set, then partition it into a
> few file systems. This may provide greater opportunity for caching I/Os.
>  * Experiment with different file systems, and optimize accordingly.  
>  * Turn of journaling, or at least move journals to RAID1 devices.
>  * Add RAM and try to increase buffer cache in attempt to improve cache
> hit percentage (this works up to a point)
>  * Buy a small SSD and migrate files that get pounded with random I/O to
> that device. (Make sure you don't get a flash SSD, but a DRAM based SSD
> that satisfies random I/O in nanoseconds instead of millisecs). They are
> expensive, but the appropriate device.  This is how companies such as
> Google & Ebay manage to get things done. 
> The biggest thing to remember about random I/O, is that they are
> expensive, so just step back and think about ways to minimize the I/O
> requests to disk in the first place, and/or to spread the I/O across
> multiple raidsets that can work independently to satisfy your load.  All
> suggestions above will not work for everybody. You must understand the
> nature of the bottleneck. 


For faster random IO I would suggest to use raid10,f2 for the random
reading, it performs like raid0, something like more than double the
speed of a normal single-drive file system. For random writes raid10,f2
performs like most other mirrorred raids, given that data needs to be
written twice.

Try and see if you can gat any HW raids to match that performance.

best regards
keld

> David
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of
> thomas62186218@aol.com
> Sent: Monday, June 09, 2008 2:51 AM
> To: dan.j.williams@gmail.com; jpiszcz@lucidpixels.com
> Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org;
> xfs@oss.sgi.com; ap@solarrain.com
> Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte
> Veliciraptors
> 
> Thank you for sharing these results. One issue that I consistently see 
> with these results is miserable random IO performance. Looking at these 
> numbers, even a low-end RAID controller with 128MB of cache will outrun 
> md-based RAIDs in random IO benchmarks. In today's world of virtual 
> machines, etc, random IO is far more common than sequential IO. What 
> can be done with md (or something else) to alleviate this problem?
> 
> -Thomas
> 
> 
> -----Original Message-----
> From: Dan Williams <dan.j.williams@gmail.com>
> To: Justin Piszcz <jpiszcz@lucidpixels.com>
> Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org; 
> xfs@oss.sgi.com; Alan Piszcz <ap@solarrain.com>
> Sent: Sat, 7 Jun 2008 6:46 pm
> Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte 
> Veliciraptors
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> On Sat, Jun 7, 2008 at 7:22 AM, Justin Piszcz <jpiszcz@lucidpixels.com> 
> wrote:
> > First, the original benchmarks with 6-SATA drives with fixed 
> formatting,
> > using
> > right justification and the same decimal point precision throughout:
> > 
> http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-an
> d-right-justified/disks.html
> >
> > Now for for veliciraptors!  Ever wonder what kind of speed is 
> possible with
> > 3 disk, 4,5,6,7,8,9,10-disk RAID5s?  I ran a loop to find out, each 
> run is
> > executed three times and the average is taken of all three runs per 
> each
> > RAID5 disk set.
> >
> > In short? The 965 no longer does justice with faster drives, a new 
> chipset
> > and motherboard are needed.  After reading or writing to 4-5 
> veliciraptors
> > it saturates the bus/965 chipset.
> >
> > Here is a picture of the 12 veliciraptors I tested with:
> > 
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
> aptors/raptors.jpg
> >
> > Here are the bonnie++ results:
> > 
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
> aptors/veliciraptor-raid.html
> >
> > For those who want the results in text:
> > 
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
> aptors/veliciraptor-raid.txt
> >
> > System used, same/similar as before:
> > Motherboard: Intel DG965WH
> > Memory: 8GiB
> > Kernel: 2.6.25.4
> > Distribution: Debian Testing x86_64
> > Filesystem: XFS with default mkfs.xfs parameters [auto-optimized for 
> SW
> > RAID]
> > Mount options: defaults,noatime,nodiratime,logbufs=8,logbsize=262144 
> 0 1
> > Chunk size: 1024KiB
> > RAID5 Layout: Default (left-symmetric)
> > Mdadm Superblock used: 0.90
> >
> > Optimizations used (last one is for the CFQ scheduler), it improves
> > performance by a modest 5-10MiB/s:
> > http://home.comcast.net/~jpiszcz/raid/20080601/raid5.html
> >
> > # Tell user what's going on.
> > echo "Optimizing RAID Arrays..."
> >
> > # Define DISKS.
> > cd /sys/block
> > DISKS=$(/bin/ls -1d sd[a-z])
> >
> > # Set read-ahead.
> > # > That's actually 65k x 512byte blocks so 32MiB
> > echo "Setting read-ahead to 32 MiB for /dev/md3"
> > blockdev --setra 65536 /dev/md3
> >
> > # Set stripe-cache_size for RAID5.
> > echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> 
> Sorry to sound like a broken record,  16MiB is not correct.
> 
> size=$((num_disks * 4 * 16384 / 1024))
> echo "Setting stripe_cache_size to $size MiB for /dev/md3"
> 
> ...and commit 8b3e6cdc should improve the performance / 
> stripe_cache_size ratio.
> 
> > echo 16384 > /sys/block/md3/md/stripe_cache_size
> >
> > # Disable NCQ on all disks.
> > echo "Disabling NCQ on all disks..."
> > for i in $DISKS
> > do
> >  echo "Disabling NCQ on $i"
> >  echo 1 > /sys/block/"$i"/device/queue_depth
> > done
> >
> > # Fix slice_idle.
> > # See http://www.nextre.it/oracledocs/ioscheduler_03.html
> > echo "Fixing slice_idle to 0..."
> > for i in $DISKS
> > do
> >  echo "Changing slice_idle to 0 on $i"
> >  echo 0 > /sys/block/"$i"/queue/iosched/slice_idle
> > done
> >
> 
> Thanks for putting this data together.
> 
> Regards,
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
