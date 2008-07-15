From: Michal Soltys <soltys@ziu.info>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 17:46:40 +0200
Message-ID: <487CC660.9030004@ziu.info>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent article
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
> 
> http://www.linux.com/feature/140734
> 

Very interesting. Btw - did you use stripe-width on ext3s as well, or 
only stride ?

Also looking back at other benchmarks, stripe_cache_size can have pretty 
tremendous effect on md raid performance. There're other settings that 
could matter as well (read ahead, queue depths). It would be interesting 
to see e.g. raid5 256k chunk comparison, done with those altered ( 
_especially_ md's stripe_cache_size with some high value like 16384 or 
32768), and with stripe-width used in ext3 case (if it wasn't used already).

