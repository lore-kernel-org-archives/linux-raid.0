From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Thoughts on big SSD arrays?
Date: Mon, 03 Aug 2015 21:38:56 +1000
Message-ID: <55BF52D0.304@websitemanagers.com.au>
References: <CAJvUf-AW08pcRkADn4Fgh46_vVAxgofiuB93+pzQYk99hx1nbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-AW08pcRkADn4Fgh46_vVAxgofiuB93+pzQYk99hx1nbw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 1/08/2015 01:23, Matt Garman wrote:
> I continue to be inspired by the "Dirt Cheap Data Warehouse (DCDW)"
> [3].  SSD are getting bigger and prices are dropping rapidly (2 TB
> SSDs available now for $800).  With our WORM-like workload, I believe
> we can safely get away with consumer drives, as durability shouldn't
> be an issue.
>
> So at this point I'm just putting out a feeler---has anyone out there
> actually built a massive SSD array, using either Linux software raid
> or hardware raid (technically off-topic for this list, though I hope
> the discussion is interesting enough to let it slide).  If so, how big
> of an array (i.e. drives/capacity)?  What was the target versus actual
> performance?  Any particularly challenging issues that came up?
I have been using a 8x 480GB RAID5 linux md array for a iSCSI SAN for a 
number of years, and it worked well after some careful tuning, and 
careful (lucky) hardware selection (ie, motherboard was lucky to have 
the right bandwidth memory/PCI bus/etc).

The main challenge I had was actually with DRBD on top of the array, 
once I disabled the forced writes, then it all worked really well. The 
forced writes were forcing a consistent on disk status for every write 
since the SSD's I use did not have any ability to save the data during a 
power outage.
> FWIW, I'm thinking of something along the lines of a 24-disk chassis,
> with 2 disks for OS (raid1), 2 disks as hot spares, and the remaining
> 20 in raid-6.  The 22 data disks (raid + hot spares) would be 2 TB
> SSDs.
I'm not sure that sounds like a good idea. Personally, I'd probably 
prefer to use 2 x RAID6 arrays at least, but then that is just what 
advice I hear on the list. Using two arrays will also get you more 
parallel processing (use more cpu cores), as I think you are limited to 
one cpu per array.
> The "problem" with SSDs is that they're just so seductive:
> back-of-the-envelope numbers are wonderful, so it's easy to get
> overly-optimistic about builds that use them.  But as with most
> things, the devil's in the details.
I was able to get 2.5GB/s read and 1.5GB/s write with (I think) only 6 
SSD's in RAID5. However, eventually, when I did the correct test to 
match my actual load, that dropped to abysmal values (well under 
100MB/s). The reason is that my live load uses very small read/write 
block size, so there were a massive number of small random read/writes, 
leading to high IOPS. Using large block sizes can deliver massive 
throughput, with very small number of IOPS,

> Off the top of my head, potential issues I can think of:
>
>      - Subtle PCIe latency/timing issues of the motherboard
 From memory, this can include the amount of bandwidth between 
memory/CPU/PCI bus/SATA bus/etc... Including the speed of the RAM as 
just one of the factors. I don't know all the tricky details, but I do 
recall that while the bandwdith looks plenty fast enough at first, the 
data moves over a number of bridges, and sometimes the same bridge more 
than once (eg, the disk interface and network interface might be on the 
same bridge).
>      - High variation in SSD latency
>      - Software stacks still making assumptions based on spinning
> drives (i.e. not adequately tuned for SSDs)
>      - Non-parallel RAID implementation (i.e. single CPU bottleneck potential)
>      - Potential bandwidth bottlenecks at various stages: SATA/SAS
> interface, SAS expander/backplane, SATA/SAS controller (or HBA), PCIe
> bus, CPU memory bus, network card, etc
>      - I forget the exact number, but the DCDW guy told me with Linux
> he was only able to get about 30% of the predicted throughput in his
> SSD array
I got close to the theoretical maximum (from memory), but it depended on 
the actual real life workload. Those theoretical performance values are 
only achieved in "optimal" conditions, real life is often a lot more messy.
>      - Wacky TRIM related issues (seem to be drive dependent)
If you are mostly read then TRIM shouldn't be much of an issue for you.
> Not asking any particular question here, just hoping to start an
> open-ended discussion.  Of course I'd love to hear from anyone with
> actual SSD RAID experience!
>

My experience has been positive. BTW, I'm using the Intel 480GB SSD 
(basically consumer grade 520/530 series). If you want any extra 
information/details, let me know.

Regards,
Adam

