From: Maurice Hilarius <maurice@harddata.com>
Subject: RE: large devices (3ware) - thanx for the info
Date: Wed, 21 Aug 2002 15:30:01 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020821152814.03a98d80@mail.harddata.com>
References: <CDF05CB9FCA0C845B9778F9E463C476101FC69@cinshrexc01.shermfi
 n.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CDF05CB9FCA0C845B9778F9E463C476101FC69@cinshrexc01.shermfi
 n.com>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 03:16 PM 8/21/02, Rechenberg, Andrew. Where 
you stated:

>Just as an FYI on the PCI bus, we found out from some testing that a
>64-bit, 66MHz PCI bus can be the bottleneck while driving two LTO
>Ultrium tape devices, so the PCI bus could definitely be a bottleneck
>for fast hard disks (I don't know about ATA100/133 IDE, but with that
>many disks, probably).
>
>The next step up would be PCI-X which (I believe) is currently running
>at 133MHz and provides burst transfer rates at up to 1GB/s
>(GigaByte/sec) .
>
>Regards,
>Andy.

Problem is we are seeing WORSE figures on so-called fast PCI buses.
Both the Intel 7500 and Serverworks GC-LE actually give us WORSE figures on 
these same cards, which are 64 bit / 33MHz. Both boards have PCI-X slots, 
and we see no better in these slots.

And, from what I am seeing Intel 7500 has similar DMA issues in PCI as the 
old 860 chipset.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

