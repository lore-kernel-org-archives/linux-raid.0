From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 22:40:36 +0100
Message-ID: <47683E54.5020403@ph.tum.de>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>	 <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan>	 <476820B0.9010200@ph.tum.de>	 <Pine.LNX.4.64.0712181523250.7823@p34.internal.lan>	 <476837F6.7050404@ph.tum.de> <cccedfc60712181320v5ec446abq37e45e5d905866cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712181320v5ec446abq37e45e5d905866cb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>         16k read        64k write
>> chunk
>> size    RAID 5  RAID 6  RAID 5  RAID 6
>> 128k    492     497     268     270
>> 256k    615     530     288     270
>> 512k    625     607     230     174
>> 1024k   650     620     170     75
> 
> It strikes me that these numbers are meaningless without knowing if
> that is actual data-to-disk or data-to-memcache-and-some-to-disk-too.
> Later versions of 'dd' offer 'conv=fdatasync' which is really handy
> (call fdatasync on the output file, syncing JUST the one file, right
> before close). Otherwise, oflags=direct will (try) to bypass the
> page/block cache.
> 
> I can get really impressive numbers, too (over 200MB/s on a single
> disk capable of 70MB/s) when I (mis)use dd without fdatasync, et al.
> 
> The variation in reported performance can be really huge without
> understanding that you aren't actually testing the DISK I/O but *some*
> disk I/O and *some* memory caching.

I did these benchmarks with 32GB of data on a machine with 1GB of RAM, 
therefore the memory cache contribution should be small.

Kind regards,

Thiemo
