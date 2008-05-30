From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Fri, 30 May 2008 16:23:46 +0200
Message-ID: <20080530142346.GA17831@rap.rap.dk>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de> <alpine.DEB.1.10.0805291302190.23633@p34.internal.lan> <483FF92F.6060309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <483FF92F.6060309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Fri, May 30, 2008 at 08:55:11AM -0400, Bill Davidsen wrote:
> Justin Piszcz wrote:
> >
> >
> >On Thu, 29 May 2008, Holger Kiehl wrote:
> >
> >>On Wed, 28 May 2008, Justin Piszcz wrote:
> >>
> >>>Hardware:
> >>>
> >>>1. Utilized (6) 400 gigabyte sata hard drives.
> >>>2. Everything is on PCI-e (965 chipset & a 2port sata card)
> >>>
> >>>Used the following 'optimizations' for all tests.
> >>>
> >>># Set read-ahead.
> >>>echo "Setting read-ahead to 64 MiB for /dev/md3"
> >>>blockdev --setra 65536 /dev/md3
> >>>
> >>># Set stripe-cache_size for RAID5.
> >>>echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> >>>echo 16384 > /sys/block/md3/md/stripe_cache_size
> >>>
> >>># Disable NCQ on all disks.
> >>>echo "Disabling NCQ on all disks..."
> >>>for i in $DISKS
> >>>do
> >>> echo "Disabling NCQ on $i"
> >>> echo 1 > /sys/block/"$i"/device/queue_depth
> >>>done
> >>>
> >>>Software:
> >>>
> >>>Kernel: 2.6.23.1 x86_64
> >>>Filesystem: XFS
> >>>Mount options: defaults,noatime
> >>>
> >>>Results:
> >>>
> >>>http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> >>>http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
> >>>
> >>Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
> >>86797? I would have thought that raid6 was always a bit slower in 
> >>writting
> >>due to having to write double amount of parity data.
> >>
> >>Holger
> >>
> >
> >RAID5 (2nd test of 3 averaged runs) & Single disk added:
> >http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html 
> 
> Other than repeating my (possibly lost) comment that this would be 
> vastly easier to read if the number were aligned and all had the same 
> number of decimal places in a single column, good stuff. For sequential 
> i/o the winners and losers are clear, and you can set cost and 
> performance to pick the winners. Seems obvious that raid-1 is the loser 
> for single threaded load, I suspect that it would be poor against other 
> levels in multithread loads, but not so much for read.

On my wishlist to Justin is also what is the performance of the raid10's
in degraded mode.

And then I note that raid1 performs well on random seeks 702/s
while the raid10,f2 (my pet) only performs 520/s - but this is on a
2.6.23 kernel without the seek performance patch for raid10,f2.

I wonder if the random seeks are related to random read (and write) - it
probably is, but there seems to be a difference between the results
found with bonnie++ and my tests as reported on the
http://linux-raid.osdl.org/index.php/Performance page.

Best regards
keld
