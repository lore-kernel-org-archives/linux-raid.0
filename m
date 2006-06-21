From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: New FAQ entry? (was IBM xSeries stop responding during RAID1
 reconstruction)
Date: Wed, 21 Jun 2006 22:51:07 +0400
Message-ID: <4499951B.8040306@tls.msk.ru>
References: <20060621160907.GA20630@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060621160907.GA20630@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Niccolo Rigacci wrote:
[]
> From the command line you can see which schedulers are supported 
> and change it on the fly (remember to do it for each RAID disk):
> 
>   # cat /sys/block/hda/queue/scheduler
>   noop [anticipatory] deadline cfq
>   # echo cfq > /sys/block/hda/queue/scheduler
> 
> Otherwise you can recompile your kernel and set CFQ as the 
> default I/O scheduler (CONFIG_DEFAULT_CFQ=y in Block layer, IO 
> Schedulers, Default I/O scheduler).

There's much easier/simpler way to set default scheduler.  As
someone suggested, RTFM Documentation/kernel-parameters.txt.
Passing elevator=cfq (or whatever) will do the trick much simpler
than kernel recompile.

/mjt
