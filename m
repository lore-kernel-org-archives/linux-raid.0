From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Wed, 11 Jun 2008 16:27:54 -0400
Message-ID: <4850354A.8090503@tmr.com>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> First, the original benchmarks with 6-SATA drives with fixed 
> formatting, using
> right justification and the same decimal point precision throughout:
> http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-and-right-justified/disks.html 
>
>
> Now for for veliciraptors! Ever wonder what kind of speed is possible 
> with
> 3 disk, 4,5,6,7,8,9,10-disk RAID5s? I ran a loop to find out, each run is
> executed three times and the average is taken of all three runs per 
> each RAID5 disk set.
>
> In short? The 965 no longer does justice with faster drives, a new 
> chipset
> and motherboard are needed. After reading or writing to 4-5 veliciraptors
> it saturates the bus/965 chipset.

This is very interesting, but a 16GB chunk size bears no relationship to 
anything I would run in the real world, and I suspect most people are in 
the same category.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


