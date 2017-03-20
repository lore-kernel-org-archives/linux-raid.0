From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: stripe_cache_size, some info
Date: Mon, 20 Mar 2017 15:59:03 +0000
Message-ID: <58CFFC47.3000306@youngman.org.uk>
References: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/03/17 18:35, Gandalf Corvotempesta wrote:
> As I would like to replace most of our HW raid controller with mdadm,
> any suggestion on how to improve RAID-6 speed ?

Burst speed, or sustained speed? Big difference ...
> 
> Modern CPU aren't an issue, I don't think that double-parity
> calculation could create any bottleneck on a modern CPU.

Using a journal on an SSD will offload stuff and give you a decent burst
speed, I suspect. You'll need to get benchmarks, but that should mean
you don't notice a slow background write speed.

> The real advantages of a raid controller are mostly 2:
> 
> 1) the writeback cache (1GB or 2GB)
> 2) the ability to automatically replace a disk by hotswapping it.
> 
> Any solution to this ? For the "2", i've tried by configuring the
> POLICY in mdadm.conf but new disk is never reconized and I always have
> to manually add the new disk to the array.

I think you have to manually add the disk to the array (group) as a
spare first.

And I would avoid that entirely if I can - put the new disk in, do a
--replace, and then remove the old one. Doing a hotswap like that will
increase the stress on the array, and increased stress means another
disk is more likely to fail.

Cheers,
Wol
