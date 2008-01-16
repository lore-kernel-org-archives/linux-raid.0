From: Al Boldi <a1426z@gawab.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
Date: Wed, 16 Jan 2008 20:27:00 +0300
Message-ID: <200801162027.00791.a1426z@gawab.com>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
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

Can you retest with different max_sectors_kb on both md and sd?

Also, can you retest using dd with different block-sizes?


Thanks!

--
Al

