From: Steven Dake <sdake@mvista.com>
Subject: Re: Linux drivers for ICH5R (RAID1) and Promise PDC20378,
	Performance
Date: Mon, 13 Oct 2003 15:15:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1066083358.4761.254.camel@persist.az.mvista.com>
References: <200310140008.43189.dusty@strike.wu-wien.ac.at>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140008.43189.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2003-10-13 at 15:08, Hermann Himmelbauer wrote:
> Hi,
> I am considering buying a new Intel based Motherboard (875P chipset) with 2 
> RAID-Controller on Board: ICH5R and Promise PDC20378.
> 
> I want to know if the RAID1 functionality of Intel's 875P Southbridge (ICH5R) 
> is fully supported by Linux. I read that at the launch of the ICH5R only 
> RAID0 was supported but by a BIOS update, RAID1 is now also available. Is the 
> driver (if there is any) pre-alpha or has it somehow proved to be stable?
> 
> Moreover I want to know if there are drivers for the Promise PDC20378.
> 
> But here's another question: Let's assume those 2 RAID chips are perfectly 
> supported by Linux and you would want to set up a fast RAID1 solution with 
> e.g. 2* WD-Raptor SATA disks. There are 3 ways to do this:
> 
> 1) Software RAID: Easy, no driver support needed, but would this be very CPU 
> intensive? Moreover is grub already capable to load the kernel from a RAID1 
> device? Another disadvantage would be that during write operations the 
> traffic between the CPU and the disk subsystem is doubled compared to a 
> HW-RAID solution.
> 
> 2) HW RAID with ICH5R: This variant has the advantage that the SATA-channels 
> are directly connected to the Chipset and do not stress the PCI-bus.
> 
> 3) HW RAID with Promise
> 
> Theoretically the read speed of a RAID1 device should be double of a single 
> disk. Anyway it seems that currently available HW-RAID1 solutions are even 
> slower than a single disk. What would this be like with Linux SW-RAID? Would 
> SW-RAID double the read-speed?
> 
> What would you prefer?
> 
> Moreover I would like to know which filesystem would suit best. For the 
> HW-RAID solutions this should not make any difference but I heard that e.g. 
> ReiserFS + Linux SW-RAID is quite slow.
> 
I use ext3 + raid1 with two western digital 8MB cache disks.  I get
about 65mb/sec sustained read performance.  With one disk, I get about
40mb/sec sustained read performance.  The linux raid code read balances
across disks, but doesn't write balance.

The performance of the ataraid code is worse.  I think it doesn't read
balance, but I'm not sure.  I do know that you probably want to stick
with linux raid, or a real hardware raid controller that doesn't rely on
drivers to concatenate/mirror the devices.

Thanks
-steve
> 		Best Regards,
> 		Hermann

