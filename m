From: NeilBrown <neilb@suse.de>
Subject: Re: Single Drive Pegged during RAID 5 synchronization
Date: Thu, 30 Jun 2011 07:28:20 +1000
Message-ID: <20110630072820.081647d4@notabene.brown>
References: <BANLkTikXNnVyRYjWDCYPq1n8dgGA2zaGog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikXNnVyRYjWDCYPq1n8dgGA2zaGog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 06:23:34 -0700 "fibreraid@gmail.com"
<fibreraid@gmail.com> wrote:

> Hi All,
> 
> I am seeing an intermittent issue where a single HDD is pegged higher
> than the rest during md RAID 5 synchronization. I have swapped the
> drive, and even swapped server hardware (tested on two different
> servers), and seen the same issue, so I am doubtful the issue is
> hardware.
> 
> Linux 2.6.38 kernel
> md 3.2.1
> 24 x 15K HDD's
> LSI SAS HBA for connectivity
> Dual socket 6-cores per socket Westmere CPU's
> 48GB RAM
> 
> 
> For the md0, stripe_cache_size is set to 32768.
> 
> 
> Here is /proc/diskstats. Note that /dev/sdn (and /dev/sdn1, since I
> use partitions in my md arrays) has a Busy state pegged much higher
> than every other drive. Basically, this holds back the performance of
> the syncing substantially. Presently, I see this issue 60% of the time
> when I create this same 24 drive md RAID 5, but not always, even on
> the same hardware and different hardware. It's the luck of the draw,
> it seems, as I am using the same exact md parameters everytime (its a
> script I've written). Any insight would be helpful! I'm happy to share
> any details you need.
> 

>    8     192 sdm 210138 6667816 54996905 6472880 354 1525 15022 330 36
> 174220 6474120
>    8     193 sdm1 210105 6667816 54996641 6472780 352 1525 15022 250
> 36 174040 6473940
>    8     208 sdn 112322 6765562 54967569 10757840 354 1506 14894 520
> 50 198980 10761710
>    8     209 sdn1 112289 6765562 54967305 10757730 352 1506 14894 440
> 50 198790 10761520

It seems that sdn has seen about half as many read requests as sdm (and the
others), to handle the same number of sectors.  That suggests that it is
getting read requests that are twice as big.  That seems to imply a hardware
difference of some sort to me, but I only have a light acquaintance with
these things.

The utilisation - in miliseconds - is substantially larger .... maybe it
takes longer to assemble large requests, or something.

What exactly to you mean by "holds back performance of the syncing"??
What MB/s does /proc/mdstat report? and does this change when you find a
drive with a high utilisation time?

NeilBrown
