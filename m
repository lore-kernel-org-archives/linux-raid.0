From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 17:27:34 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se>
References: <200408011601.46636.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408011601.46636.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, Mark Watts wrote:

> RAID Configuration:
> 4-disk RAID-5 with 64K block size.
> 
> /dev/sda1 = / = 20GB
> /dev/sda2 = swap = 2048MB
> /dev/sda5 = /home = 100GB
> 
> All partitions (except swap) formatted as ext3.

It would be interesting to see difference if you put the system and swap 
on another drive that is not part of the RAID5.
 
> Kernel - 2.6.8rc1, SMP for x86_64

I use v2.4, haven't used 2.6 with 3ware and SMP at all, so the problem 
might be there. Did you try the smp_affinity thing I emailed about 1-2 
days ago?

> Slow write speeds is one thing, practically locking the system up while the 
> write occurs is another, unless I'm missing something obvious.

Well, if the system needs to page-in and this page-in takes seconds to 
fulfil because the raid5 is full at work and has a large latency queue, 
that might explain it. Does the system do anything else when you're 
copying?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se


