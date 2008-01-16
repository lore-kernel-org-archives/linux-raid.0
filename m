From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
Date: Wed, 16 Jan 2008 13:09:53 -0500
Message-ID: <29a863790801161009h7bb1f0f7v34bc893fce338567@mail.gmail.com>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

What sort of tools are you using to get these benchmarks, and can I
used them for ext3?

Very interested in running this on my server.


Thanks,
Greg

On Jan 16, 2008 11:13 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> For these benchmarks I timed how long it takes to extract a standard 4.4
> GiB DVD:
>
> Settings: Software RAID 5 with the following settings (until I change
> those too):
>
> Base setup:
> blockdev --setra 65536 /dev/md3
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>    echo "Disabling NCQ on $i"
>    echo 1 > /sys/block/"$i"/device/queue_depth
> done
>
> p34:~# grep : *chunk* |sort -n
> 4-chunk.txt:0:45.31
> 8-chunk.txt:0:44.32
> 16-chunk.txt:0:41.02
> 32-chunk.txt:0:40.50
> 64-chunk.txt:0:40.88
> 128-chunk.txt:0:40.21
> 256-chunk.txt:0:40.14***
> 512-chunk.txt:0:40.35
> 1024-chunk.txt:0:41.11
> 2048-chunk.txt:0:43.89
> 4096-chunk.txt:0:47.34
> 8192-chunk.txt:0:57.86
> 16384-chunk.txt:1:09.39
> 32768-chunk.txt:1:26.61
>
> It would appear a 256 KiB chunk-size is optimal.
>
> So what about NCQ?
>
> 1=ncq_depth.txt:0:40.86***
> 2=ncq_depth.txt:0:40.99
> 4=ncq_depth.txt:0:42.52
> 8=ncq_depth.txt:0:43.57
> 16=ncq_depth.txt:0:42.54
> 31=ncq_depth.txt:0:42.51
>
> Keeping it off seems best.
>
> 1=stripe_and_read_ahead.txt:0:40.86
> 2=stripe_and_read_ahead.txt:0:40.99
> 4=stripe_and_read_ahead.txt:0:42.52
> 8=stripe_and_read_ahead.txt:0:43.57
> 16=stripe_and_read_ahead.txt:0:42.54
> 31=stripe_and_read_ahead.txt:0:42.51
> 256=stripe_and_read_ahead.txt:1:44.16
> 1024=stripe_and_read_ahead.txt:1:07.01
> 2048=stripe_and_read_ahead.txt:0:53.59
> 4096=stripe_and_read_ahead.txt:0:45.66
> 8192=stripe_and_read_ahead.txt:0:40.73
>        16384=stripe_and_read_ahead.txt:0:38.99**
> 16384=stripe_and_65536_read_ahead.txt:0:38.67
> 16384=stripe_and_65536_read_ahead.txt:0:38.69 (again, this is what I use
> from earlier benchmarks)
> 32768=stripe_and_read_ahead.txt:0:38.84
>
> What about logbufs?
>
> 2=logbufs.txt:0:39.21
> 4=logbufs.txt:0:39.24
> 8=logbufs.txt:0:38.71
>
> (again)
>
> 2=logbufs.txt:0:42.16
> 4=logbufs.txt:0:38.79
> 8=logbufs.txt:0:38.71** (yes)
>
> What about logbsize?
>
> 16k=logbsize.txt:1:09.22
> 32k=logbsize.txt:0:38.70
> 64k=logbsize.txt:0:39.04
> 128k=logbsize.txt:0:39.06
> 256k=logbsize.txt:0:38.59** (best)
>
>
> What about allocsize? (default=1024k)
>
> 4k=allocsize.txt:0:39.35
> 8k=allocsize.txt:0:38.95
> 16k=allocsize.txt:0:38.79
> 32k=allocsize.txt:0:39.71
> 64k=allocsize.txt:1:09.67
> 128k=allocsize.txt:0:39.04
> 256k=allocsize.txt:0:39.11
> 512k=allocsize.txt:0:39.01
> 1024k=allocsize.txt:0:38.75** (default)
> 2048k=allocsize.txt:0:39.07
> 4096k=allocsize.txt:0:39.15
> 8192k=allocsize.txt:0:39.40
> 16384k=allocsize.txt:0:39.36
>
> What about the agcount?
>
> 2=agcount.txt:0:37.53
> 4=agcount.txt:0:38.56
> 8=agcount.txt:0:40.86
> 16=agcount.txt:0:39.05
> 32=agcount.txt:0:39.07** (default)
> 64=agcount.txt:0:39.29
> 128=agcount.txt:0:39.42
> 256=agcount.txt:0:38.76
> 512=agcount.txt:0:38.27
> 1024=agcount.txt:0:38.29
> 2048=agcount.txt:1:08.55
> 4096=agcount.txt:0:52.65
> 8192=agcount.txt:1:06.96
> 16384=agcount.txt:1:31.21
> 32768=agcount.txt:1:09.06
> 65536=agcount.txt:1:54.96
>
>
> So far I have:
>
> p34:~# mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 /dev/md3
> meta-data=/dev/md3               isize=256    agcount=32, agsize=10302272
> blks
>           =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=329671296, imaxpct=25
>           =                       sunit=64     swidth=576 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=2359296 blocks=0, rtextents=0
>
> p34:~# grep /dev/md3 /etc/fstab
> /dev/md3        /r1             xfs     noatime,nodiratime,logbufs=8,logbsize=262144 0 1
>
> Notice how mkfs.xfs 'knows' the sunit and swidth, and it is the correct
> units too because it is software raid, and it pulls this information from
> that layer, unlike HW raid which will not have a clue of what is
> underneath and say sunit=0,swidth=0.
>
> However, in earlier testing I actually made them both 0 and it actually
> made performance better:
>
> http://home.comcast.net/~jpiszcz/sunit-swidth/results.html
>
> In any case, I am re-running bonnie++ once more with a 256 KiB chunk and
> will compare to those values in a bit.
>
> Justin.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
