From: AndyLiebman@aol.com
Subject: Re: I'm Astounded by How Good Linux Software RAID IS!
Date: Mon, 24 Nov 2003 08:47:40 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <172.22899f68.2cf365fc@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: dusty@strike.wu-wien.ac.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your comments. 

> I want to congratulate a lot of Linux Software Raid folks. Really. I just
> set up a RAID 5 array on my Linux Machine (P4-3.06 Ghz -- Mandrake 9.2)
> using 5 External Firewire Drives.
>
> The performance is SO GOOD that I am able to write uncompressed 8-bit video
> files to my array through a Copper Gigabit network! That's a sustained 18
> MB/sec -- going for 20 minutes straight.
>
> The first one was set up with 6 Firewire Drives that are bigger (200 GB
> versus 120 GB) and that have larger onboard cache (8 MB versus 2 MB). I set
> up those 6 drives as a RAID 10 array -- 3 mirrored pairs with a RAID 0
> stripe on top of that. The performance I was able to achieve with the RAID
> 10 array was actually NO BETTER than what I am getting with RAID 5. Does
> that make sense?

Hmmm, here are some of my thoughts, maybe some of my assumptions are wrong as 
I am no RAID expert. If so, please correct me!

- Maximum FW-Speed = 400Mbit/s, that's with the protocol overhead ~ 35Mb/s
- Theoretical PCI-Bandwidth: 133 MB/s



Do you think this 35 MB/sec applies, even though I am using 5 separate 
Firewire PCI cards? That's 5 separate channels, each of which has a 400 Mbit/sec 
speed. Keep in mind that EACH drive on the RAID 5 is on it's own separate PCI 
card. 


O.k., let's calculate a little bit, but only for large file disk writes, 
reads 
are probably not that easy to calculate:
1) RAID5: When writing a block, the actual data written is data*(5/4), but 
the 
data is spreaded over all 5 disks, therefore it should theoretically perform 
like a 4-disk RAID0. Practically there is probably a performance degration.
2) RAID10: When writing a block, the actual data written is data*2 as every 
data chunk is mirrored. The performance gain is like a 3-disk RAID0.

So, theoretically the RAID5 should be faster but has a worse data reliability 
which could be improved by a hot spare.

Anyway, due to the limitation of the FW, you will never gain a higher 
throughput than the ~ 35Mb/s, moreover keep in mind that the transfer speed 
between the HD-interface (cache) and the CPU can also never exceed this limit 
which degrades your performance, probably especially the read performance.

When it comes to the PCI-bus, the load is higher with the RAID-10 solution, 
as 
the data that should be written is doubled. But it does not seem that the 
PCI-bus is a bottleneck in this system.

Another thought to Gigabit Ethernet: 32-bit PCI Ethernet NIC's are known to 
be 
quite slow, often they provide not much more than 20-30Mb/s. Morover if you 
(mis)use your 32-bit PCI-bus for Gigabit Ethernet you will probably degrade 
your RAID performance as the PCI bus gets saturated. For Gigabit Ethernet you 
better use this Intel CSA-solution like found in the 875 chipsets or you have 
a motherboard with a 64-bit PCI or PCI-X bus (which is expensive). *Maybe* 
Nvidia also has an CSA-equivalent solution in its nForce3 Chipset, but I 
could not find any specs about this.

I understand that a 64 bit PCI bus and card would be better. But there's no 
point at the moment unless I increase the read and write speed to the RAID 
array. 

There are other variables too. When I tested the RAID 10 array, I got much 
better performance with xfs filesystem compared to ext3.  With xfs, it didn't 
seem to make any difference whether I had an external or internal log file.  
However, I have read that with RAID 5 an external log is a big advantage. I'm 
going to try that. 

But I also read in SGI's xfs documentation that external logs don't work 
unless your volumes are created using some kind of logical volume manager -- and 
not with partitions. But maybe that rule only applies to xfs on UNIX and not to 
xfs on LINUX.  There is no mention of LINUX in the SGI documentation. 


Moreover I would also check the CPU-load which can also degrade performance 
as 

CPU load is all over the map. I am using hyperthreading support (I have a 
P4-3.06 Ghz) -- but load on CPU 1 ranges up and down from 20 to 100 percent, 
mostly staying around 40 to 60 percent. CPU 2 is down at 2 to 5 percent. I have 
tried disabling hyperthreading in the BIOS and I get the same performance. 
Hyperthreading just seems to allow me to do other things at the same time. 

RAID5 needs CPU-speed and Gigabit-Ethernet (protocol etc.) can also use a lot 
of CPU.

        Best Regards,
        Hermann
