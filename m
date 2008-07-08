From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs, disk scheduler, maximizing IO
Date: Tue, 8 Jul 2008 16:37:20 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807081635180.26531@p34.internal.lan>
References: <1962CBB4977DB94C99D86C524BDD40D107918B0A@CTMAIL2.calltower.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1962CBB4977DB94C99D86C524BDD40D107918B0A@CTMAIL2.calltower.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com, tom@bvcapital.com
List-Id: linux-raid.ids



On Tue, 8 Jul 2008, tom@bvcapital.com wrote:

>
> Could i pick your brain on XFS and Disk Scheduler for 20 minutes,
> please?  We are building a Media Downloading service and are to optimize
> the I/O on the hardware (24 Barracuda ES .5TB drives)
>
>
>
> For now we have only been able to get about 25MB/s out of one drive
> through the southbridge, into memory, back down the southbridge and out
> the Ethernet using lighttpd.
>
>
>
> Using XFS, Anticipatory Scheduler.
>
> -Can't get the -o filestreams setting to work.
>
> -Not sure how to optimize the "wait" time of the Anticipatory Scheduler
> or whether we might be better off with CFQ or Deadline.  Latency is not
> an issue at all (up to a second i guess), throughput is.
>
> -Does XFS automatically cache the entire directory structure, metadata,
> etc. in memory or is there a setting I can use to force that?   Want to
> remove those seeks.
>
>
>
> [cfq]: 21968.59 Kbytes/s
> [anticipatory]: 25044.67 Kbytes/s
> [noop]: 24737.24 Kbytes/s
> [deadline]: 24921.77 Kbytes/s
>
> Physical filesize on average is 1GB, which we are making available in
> 100MB downloads each.
>
> Using lighttpd as the front end and want it to fetch from disk in 1MB
> increments.
>


Can anyone answer Tom's questions regarding the filestreams option?

Also, you need to state the chipset/etc you are using.

Not sure what kind of raid controller you are using or motherboard or chipset, those are the most important components before one could even begin to look at your problem.

What do you get with ext3? Also 25MiB/s? Sounds like a possible IRQ/conflict/issue or some raid cards need 'noapic' enabled on as a kernel argument that fixes the problems in some cases. Also what type of drives? What type of interconnect are you using? SATAI? SATAII? SAS? Fiber channel?

XFS is one of the best and fastest Linux filesystems out there (well, ext4 is on its way to beat it) but for now XFS is king, if you are getting 25MiB/s to one drive it sounds like you need to look for other bottlenecks in your configuration.

hdparm -tT /dev/sda
hdparm -tT /dev/sdb

750GiB disk:
/dev/sda:
Timing cached reads: 5274 MB in 2.00 seconds = 2639.40 MB/sec
Timing buffered disk reads: 264 MB in 3.00 seconds = 87.95 MB/sec * real disk speed

veliciraptor:
/dev/sda:
Timing cached reads: 6240 MB in 2.00 seconds = 3121.89 MB/sec
Timing buffered disk reads: 352 MB in 3.01 seconds = 116.81 MB/sec * real disk speed


Read: 3ware performance problems
http://forums.storagereview.net/index.php?showtopic=25923

If using a 3ware card, expect to get poor performance.

# xfs_info /dev/md3
meta-data=/dev/md3 isize=256 agcount=32, agsize=20603904 blks
= sectsz=4096 attr=2
data = bsize=4096 blocks=659324160, imaxpct=5
= sunit=256 swidth=2304 blks
naming =version 2 bsize=4096
log =internal bsize=4096 blocks=32768, version=2
= sectsz=4096 sunit=1 blks, lazy-count=0
realtime =none extsz=9437184 blocks=0, rtextents=0

The important units here are sunit and swidth, I suggest reading up on them, if they are both set to 0 that means the striping at the FS level is not distributing the data efficiently across all disks.

Regarding XFS caching, it depends on the mount options as to how much is 'cached':

I use the following options: (maximum # of logbufs and highest buffer size available)
/dev/md3 /r1 xfs defaults,noatime,nodiratime,logbufs=8,logbsize=262144 0 1

man mount for more options

As CFQ is now the default I switched over to it, before the proper optimizations, its about the same speed as everything else:
http://home.comcast.net/~jpiszcz/20080625/scheduler_comparison.html

To speed it up:
# Fix slice_idle.
# See http://www.nextre.it/oracledocs/ioscheduler_03.html
echo "Fixing slice_idle to 0..."
for i in $DISKS
do
echo "Changing slice_idle to 0 on $i"
echo 0 > /sys/block/"$i"/queue/iosched/slice_idle
done

Including xfs@oss.sgi.com & linux-raid@vger.kernel.org.

Justin.

