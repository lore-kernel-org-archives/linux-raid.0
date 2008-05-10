From: "David Lethe" <david@santools.com>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date: Sat, 10 May 2008 9:47:00 -0500
Message-ID: <181c01c8b2ac$d9180269$5209f40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

even that depends on numerous variables.  Read vs write percent, are you measuring speed by IOPS or throughput? does your mobo have multiple bus controller chips ( you can saturate the bus depending on what slot/slots you use. Even your ethernet on mobo will compete with disk IO.  multiple cards, across multiple independent pcie busses would be best in high throughput if that is what you need ... But is less important as percnt of random IO increases.  Get specs on mobo & read them carefully.  Also pcie has separate paths for read vs write, so if you balance both you are better off

-----Original Message-----

From:  "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subj:  Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date:  Sat May 10, 2008 9:15 am
Size:  783 bytes
To:  "David Lethe" <david@santools.com>
cc:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

 
 
On Sat, 10 May 2008, David Lethe wrote: 
 
> You can't generalize whether HW RAID is faster or slower than SW RAID. 
> I/O mix, CPU speed, bus type, RAM, file system type/config, queue depth, specific RAID card, drivers, firmware all have significant impact. Even with info you supply, one can easily model config where either RAID architecture will outperform the other. 
> 
> if performance is vital for you on a certain pc config, then tune everything for HW RAID, test, rebuild for SW RAID, and compare.  Don't forget to yank power to a disk while testing both to see how each work under stress, as well as when consistency checks run. 
 
.. What I meant was is JBOD using a single card with 16 ports faster than 
using JBOD with multiple PCI-e SATA cards? 
 
Justin. 
 
 
 


