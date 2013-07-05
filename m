From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Aren't 2TB+ disk sizes supposed to be standardized?
Date: Fri, 5 Jul 2013 09:11:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307050908220.10894@uplift.swm.pp.se>
References: <51D65778.9010502@smartguide.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D65778.9010502@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Tudor Holton <tudor@smartguide.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 5 Jul 2013, Tudor Holton wrote:

> These are from the same manufacturer!  Interestingly, the larger drive is 
> actually the older one!

I checked my drives, and all my 2TB drives are:

User Capacity:    2 000 398 934 016 bytes [2,00 TB]

> Is the "standardization" not a fixed value but a minimum?  If so, what 
> is that actual minimum?  If it's an actual 2 terabyte (2x10^12), then I 
> suppose they're both technically over, but that means that we can't just 
> simply create partitions that fill the space and expect to be able to 
> transfer them later. :-(

Are you sure smartctl actually reads from the drive and doesn't query the 
controller? Only thing I can think of is that sdc sits on a controller 
that puts in a superblock between the OS and the drive, and thus truncates 
the size you can use.

2000397852160-2000398934016
-1081856
1081856/4096
264.125

However, it's a really odd size difference.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
