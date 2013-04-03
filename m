From: Peter Landmann <sfrazt@googlemail.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 21:19:52 +0000 (UTC)
Message-ID: <loom.20130403T231317-873@post.gmane.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <515C73B3.5060704@arcor.de> <loom.20130403T223431-541@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 
> I'm very sorry but now i can't confirm anymore that stripe_cache_size 
helps.
> 
> My test was to short. With every minute the IOPS decrease. So 
> stripe_cache_size does only help for very short tests. 
> 
> I will provide details in another post.
> 


Now i wish i could delete the post. As the SSD performance decrease with 
running time (within minutes) i'm not sure if the better performance with 
higher stripe_cache_size would be constant over time or is more a effect 
from a fresh empty cache that ceases with time (in my scenario with writing 
many small random blocks)

Short tests results:

Raid 5, 3 SSD
stripe_cache_size 	noop	deadline (tuned)
256	                18914	18730
16384	                18161	19766

Raid 5, 4 SSD
stripe_cache_size 	noop	deadline (tuned)
256	                11863	13716
16384	                13186	14688



Peter

