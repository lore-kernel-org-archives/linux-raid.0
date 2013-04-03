From: Peter Landmann <sfrazt@googlemail.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 20:36:49 +0000 (UTC)
Message-ID: <loom.20130403T223431-541@post.gmane.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <515C73B3.5060704@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> On 04/03/2013 03:18 PM, Stan Hoeppner wrote:
> 
> > You didn't mention your stripe_cache_size value.  It'll make a lot of
> > difference.  Make sure it's at least 4096.  The default is 256.
> 
> I'm not getting it - why would stripe cache size matter in a random
> read/write test? If the disks are large enough and the pattern is really
> random, the cache should hardly ever be hit (s_c_z = 4096 =^ 16MB cache
> per disk, that's 0.01% of disk size for a 160GB SSD).
> 
> I read that Peter confirmed the influence of stripe_cache_size, but I'd
> like to understand why it matters in this case.
> 
> Martin


I'm very sorry but now i can't confirm anymore that stripe_cache_size helps.

My test was to short. With every minute the IOPS decrease. So 
stripe_cache_size does only help for very short tests. 

I will provide details in another post.

Peter


