From: linux@horizon.com
Subject: Re: Interesting RAID checking observations
Date: 28 Aug 2006 09:00:39 -0400
Message-ID: <20060828130039.31909.qmail@science.horizon.com>
References: <Pine.LNX.4.64.0608270716410.3175@p34.internal.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608270716410.3175@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: jpiszcz@lucidpixels.com, linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The PCI bus is only capable of 133MB/s max.  Unless you have dedicated 
> SATA ports, each on its own PCI-e bus, you will not get speeds in excess 
> of 133MB/s, 200MB/s+ I have read reports of someone using 4-5 SATA 
> controllers (SiI 3112 cards on PCI-e x1 ports) and they got around 200MB/s 
> or so on a RAID5, I assume that was read performance.

Um, I *do* have dedicated SATA ports, each pair on its own PCIe bus.
You might recall I wrote:

>> This is 6 ST3400832AS 400 GB SATA drives, each capable of 60 MB/s
>> sustained, on Sil3132 PCIe controllers with NCQ enabled.  I measured
>> > 300 MB/sec sustained aggregate off a temporary RAID-0 device during
>> installation.

I also included examples of reading 60 MB/s off 6 drives in parallel
(360 MB/s aggregate), and reading off RAID-5 at 277 MB/s.

To be specific, the narrowest bottleneck between drive and RAM is the
250 MB/s PCIe link shared by each pair of drives.  To quote approximate
one-way bandwidths:

    1.5 Gb/s SATA         2.5 Gb/s PCIe
Drive <--------> Sil3132
Drive <--------> Dual SATA <--------\
                                     \ 
Drive <--------> Sil3132              \  16x HyperTransport     2x DDR
Drive <--------> Dual SATA <-------> nForce4 <-----> CPU <-----> RAM
                                      /     4000 MB/s    6400 MB/s
Drive <--------> Sil3132             /
Drive <--------> Dual SATA <--------/
    150 MB/s each         250 MB/s each
