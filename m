From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3ware Auto-Carve Question
Date: Sat, 21 Jul 2007 11:51:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707211151060.32707@p34.internal.lan>
References: <Pine.LNX.4.64.0707211146420.32707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707211146420.32707@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-ide-arrays@lists.math.uh.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 21 Jul 2007, Justin Piszcz wrote:

> Quick question-- under Kernel 2.4 without 2TB support enabled, the only other 
> option is to use auto-carving to get the maximum amount of space easily, 
> however, after doing this (2TB, 2TB, 1.8TB) for a 10 x 750GB array, only the 
> first partition remains afer reboot.
>
> Before reboot:
>
> /dev/sdb1 (2TB)
> /dev/sdc1 (2TB)
> /dev/sdd1 (2TB)
>
> After reboot
>
> /dev/sdb1 (2TB)
> sdc1 <vanished>
> sdd1 <vanished>
>
> I also tried formatting and then labeling /dev/sdc1 and /dev/sdd1 with 
> mkfs.ext3 and then e2label, same thing, sdc/sdd disappear after reboot. Is 
> there some option somewhere to ensure that sdc/sdd 'carved partitions' are 
> not forgotten about?
>
> Thanks,
>
> Justin.
>

Ah this appears to be my issue:

http://www.3ware.com/KB/article.aspx?id=14177

