From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 performance question
Date: Wed, 22 Mar 2006 08:22:26 -0500
Message-ID: <44214F92.5020002@tmr.com>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>	<17420.46746.365629.168649@cse.unsw.edu.au>	<5d96567b0603070040t114334cbm858147afe551f719@mail.gmail.com> <17422.4406.887200.421869@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17422.4406.887200.421869@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday March 7, raziebe@gmail.com wrote:
>  
>
>>Neil.
>>what is the stripe_cache exacly ?
>>    
>>
>
>In order to ensure correctness of data, all IO operations on a raid5
>pass through the 'stripe cache'  This is a cache of stripes where each
>stripe is one page wide across all devices.
>
>e.g. to write a block, we allocate one stripe in the cache to cover
>that block, pre-read anything that might be needed, copy in the new
>data and update parity, and write out anything that has changed.
>  
>
I can see that you would have to read the old data and parity blocks for 
RAID-5, I assume that's what you mean by "might be needed" and not a 
read of every drive to get the data to rebuild the parity from scratch. 
That would be not only slower, but require complex error recovery on an 
error reading unneeded data.

>Similarly to read, we allocate a stripe to cover the block, read in
>the requires parts, and copy out of the stripe cache into the
>destination.
>
>Requiring all reads to pass through the stripe cache is not strictly
>necessary, but it keeps the code a lot easier to manage (fewer special
>cases).   Bypassing the cache for simple read requests when the array
>is non-degraded is on my list....
>
It sounds as if you do a memory copy with each read, even if a read to 
user buffer would be possible. Hopefully I'm reading that wrong.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

