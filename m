From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Thu, 29 May 2008 06:44:13 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, 28 May 2008, Justin Piszcz wrote:

> Hardware:
>
> 1. Utilized (6) 400 gigabyte sata hard drives.
> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>
> Used the following 'optimizations' for all tests.
>
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3
>
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
>
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>  echo "Disabling NCQ on $i"
>  echo 1 > /sys/block/"$i"/device/queue_depth
> done
>
> Software:
>
> Kernel: 2.6.23.1 x86_64
> Filesystem: XFS
> Mount options: defaults,noatime
>
> Results:
>
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>
Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
86797? I would have thought that raid6 was always a bit slower in writting
due to having to write double amount of parity data.

Holger

