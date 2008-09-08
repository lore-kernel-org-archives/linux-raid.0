From: AndrewL733 <AndrewL733@aol.com>
Subject: Observation about RAID 0 performance in 2.6.25 kernel
Date: Mon, 08 Sep 2008 09:00:54 -0400
Message-ID: <48C52206.9060101@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm wondering if anybody has observed something similar to what I am 
seeing. For the past year, my production storage systems have primarily 
been using the 2.6.20.15 kernel (that's what we settled on a while back, 
and generally I have been happy with it).

About 3 months ago, I began experimenting with the 2.6.25 kernel, 
because I wanted to use some kernel-specific features that were only 
introduced in 2.6.23, 2.6.24 and 2.6.25.

My production systems typically consist of servers with two 3ware 9650 
12-port RAID cards and 24 SATA drives, 12 drives on each card. For 
maximum performance, we stripe together the two 12-drive "hardware 
RAIDS" using Linux software RAID-0. My other hardware includes a very 
recent motherboard based on the Intel 5400 chipset, with 4 Gen-2 x8 
PCI-e slots and the 5482 Intel 3.2 Ghz Quad Core CPU with 4 GBs of RAM. 
In other words, it's very capable hardware.

When comparing the 2.6.20.15 kernel with the 2.6.25 kernel, I have 
noticed that:

For the underlying 3ware devices, all benchmarks -- dd, bonnie++, and my 
own "torture test" that measures performance doing many random reads 
simultaneously -- show that 2.6.25 kernel is about 10 percent faster 
than the 2.6.20.15 kernel for both reading and writing.

However, when I stripe together those two 3ware devices with Linux 
software RAID 0, with the 2.6.25 kernel I get about a 20 percent BOOST 
in  performance for WRITING compared to the 2.6.20.15 kernel, but I get 
about an 8 percent DROP in READING performance with the 2.6.25 kernel.

My tests have been conducted using the in-kernel 3ware drivers, as well 
as compiling 3ware's latest drivers for each kernel (so, in the latter 
case, I have the same 3ware firmware and driver for either kernel). The 
results are very similar either way.

Does anybody have any insights into what might be going on here? Does 
Linux software RAID need to be configured differently in 2.6.25 to NOT 
lose READ performance? Is there something that most be done to vm tuning 
with 2.6.25? Is there a known issue with 2.6.25 that perhaps has been 
resolved with 2.6.26?

Regards,
Andrew
