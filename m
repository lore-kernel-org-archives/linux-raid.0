From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 27 Dec 2007 14:52:07 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712271451480.4247@p34.internal.lan>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 27 Dec 2007, dean gaudet wrote:

> hey neil -- remember that raid5 hang which me and only one or two others
> ever experienced and which was hard to reproduce?  we were debugging it
> well over a year ago (that box has 400+ day uptime now so at least that
> long ago :)  the workaround was to increase stripe_cache_size... i seem to
> have a way to reproduce something which looks much the same.
>
> setup:
>
> - 2.6.24-rc6
> - system has 8GiB RAM but no swap
> - 8x750GB in a raid5 with one spare, chunksize 1024KiB.
> - mkfs.xfs default options
> - mount -o noatime
> - dd if=/dev/zero of=/mnt/foo bs=4k count=2621440
>
> that sequence hangs for me within 10 seconds... and i can unhang / rehang
> it by toggling between stripe_cache_size 256 and 1024.  i detect the hang
> by watching "iostat -kx /dev/sd? 5".
>
> i've attached the kernel log where i dumped task and timer state while it
> was hung... note that you'll see at some point i did an xfs mount with
> external journal but it happens with internal journal as well.
>
> looks like it's using the raid456 module and async api.
>
> anyhow let me know if you need more info / have any suggestions.
>
> -dean

With that high of a stripe size the stripe_cache_size needs to be greater 
than the default to handle it.

Justin.
