From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 08:34:47 +1200
Message-ID: <487D09E7.1010805@sauce.co.nz>
References: <1216130769.5633.318.camel@sam.localdomain> <487CC660.9030004@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487CC660.9030004@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys wrote:

> Also looking back at other benchmarks, stripe_cache_size can have pretty 
> tremendous effect on md raid performance. There're other settings that 
> could matter as well (read ahead, queue depths). It would be interesting 
> to see e.g. raid5 256k chunk comparison, done with those altered ( 
> _especially_ md's stripe_cache_size with some high value like 16384 or 
> 32768), and with stripe-width used in ext3 case (if it wasn't used 
> already).

Agreed. On a 16 SATA drive SAS attached md RAID6, large streaming write 
performance goes from around 110MB/s with the default stripe_cache_size, 
to 600MB/s using 16384.

There are major read performance too, setting readahead on the md device 
to 65536.

Regards,

Richard
