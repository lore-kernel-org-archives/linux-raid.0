From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 15:24:15 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0512221518320.787@shaka.acc.umu.se>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
 <43A1D642.2010301@wasp.net.au> <43AAB626.3060708@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43AAB626.3060708@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Brad Campbell <brad@wasp.net.au>, "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Dec 2005, Bill Davidsen wrote:

> If you are seeing dual drive failures, I suspect your hardware has problems. 
> We run multiple 3 and 6 TB databases, and over a dozen 1 TB data caching 
> servers, all using a lot of small fast disk, and I haven't seen a real dual 
> drive failure in  about 8 years.
>
> We did see some cases which looked like dual failures, it turned out to be a 
> firmware limitation, controller not waiting for the bus to settle after a 
> real failure, and thinking the next i/o had failed (or similar, in any case a 
> false fail on the transaction after the real fail). If you run two PATA 
> drives on the same cable in master/slave, it's at least possible that this 
> could happen with consumer grade hardware as well. Just a thought, dual 
> failures are VERY unlikely unless one triggers the other in some way, like 
> failing the bus or cabinet power supply.

Not really, it depends on how lucky you are with your disks. We've had 
real dual-drive failures in a system with hot spares, where the second 
drive failed during resync.

Now, we have gotten the manufacturer to replace those with another model, 
but some of these problems don't occur until a year of two into production 
use (I haven't seen quite this bad, but a high replacement rate ramping up 
after a while).

Choosing high-end disks usually helps, but raid6 is really great in that 
you always have redundancy, even when replacing a failed or failing drive. 
If you have a large raidset with a fairly heavy load the resync time can 
easily extend into days, if not weeks. With raid5, during that entire 
period, if one more drive fails you're screwed.

Btw, in our practical usage, we haven't seen that big a difference 
between raid5 and rad6, but I guess that depends on your usage pattern.

/Mattias Wadenstein
