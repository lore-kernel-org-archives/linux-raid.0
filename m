From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Fri, 15 Aug 2008 15:35:42 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0808151528090.25378@p34.internal.lan>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 15 Aug 2008, Jan Wagner wrote:

> Hi,
>
> at work we have been experimenting with SATA-II port multipliers and SATA 
> controllers (FIS-based). For some reason the RAID-0 performance is relatively 
> awful.
>
> We have one 4xeSATA controller card ADSA3GPX8-4E, twelve SpinPoint F1 disks 
> that handle ~110MB/sec, and four port Addonics port multiplier boxes. Ubuntu, 
> kernel 2.6.24-19-generic x86_64, 2 x AMD2212 Opteron on an Asus L1N64-SLI WS.
>
> We did two sequential writing tests. One test with all 12 disks behind the 
> controller placed into one mdadm RAID-0, 512k..2048k chunksize. We get ~475 
> MB/s.
>
> The second test used four "mdadm --create"'s to reassign the 12 drives into 
> four RAID-0 with 3 disks in each. All four raids were simultaneously written 
> to. We get ~250 MB/s/raid and 1000 MB/s aggregate.
>
> So the controller can handle at least 1000 MB/s.
>
> My question is why is the single RAID setup more than half slower? Any ideas?
Because you are using port-multipliers, they do not allocate full 
bandwidth to each HDD simultaneously.  You will get a maximum of 3gbps per 
each port, but if you are reading from 12 ports into a single 3gbps port?

1-
2--
3---
4-----
5-------
6------------->
7------------->
8-------
9-----
10---
11--
12-

Fewer drives means less requests to handle:

1--->
2--->--> port1 
3--->

With that you should be able to max out the sata link without a problem 
and at the same time, not bombard the link with too many requests.

From: http://www.serialata.org/portmultiplier.asp

Here is the answer to your question:
While it is possible to connect up to 15 drives to each SATA PM port via a 
port multiplier, drive connectivity is practically limited to the maximum 
available bandwidth on the 3Gb/s link. Sustained I/O rates from the drives 
are kept to within the 3Gb/s host port connection limit for maximum 
efficiency and performance.

> Is there some kernel per-device bandwidth throttling?
Answer is, if you want speed, don't use port multipliers.

On my old P965 board I have optimized where to put the drives and the 
speeds I get with Linux SW RAID5 with 10 velociraptors are as folows:

About the same for write:
$ dd if=/dev/zero of=bigfile.1 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 20.4056 s, 526 MB/s

$ dd if=bigfile.1 of=/dev/null bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 10.2841 s, 1.0 GB/s

Justin.

