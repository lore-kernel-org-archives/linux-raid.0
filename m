From: thunder7@xs4all.nl
Subject: Re: raid5 performance question
Date: Wed, 8 Mar 2006 07:45:10 +0100
Message-ID: <20060308064510.GA1561@amd64.of.nowhere>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com> <17420.46746.365629.168649@cse.unsw.edu.au>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17420.46746.365629.168649@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Neil Brown <neilb@suse.de>
Date: Tue, Mar 07, 2006 at 09:24:26AM +1100
> You can also try increasing the size of the stripe cache in
>    /sys/block/mdX/md/stripe_cache_size
> 
> The units are in pages (normally 4K) per device.  The default is 256 which fits
> only one stripe with a 1 Meg chunk size.
> 
> Try 1024 ?
> 
Interesting. I noticed I don't have such a file for my raid6 device. Can
you explain why? I thought raid6 and raid5 worked a lot like each other.

Thanks,
Jurriaan
-- 
So I must behave with haste and dishonor to serve the political ambitions
of men that I never vowed, before the Lord, to serve and honor. I must be
pretty and delicate and happy and perfect; I must accord his passing no
mourning, and no loss.
	Michelle West - The Broken Crown
Debian (Unstable) GNU/Linux 2.6.16-rc5-mm2 5503 bogomips load 0.06
