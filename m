From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 17:56:03 +0200
Message-ID: <20080702155603.GA11156@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I should have done something else this afternoon, but anyway, I was
inspired to write up this text for the wiki. Comments welcome.

Keld

Bottlenecks

There can be a number of bottlenecks other than the disk subsystem that
hinders you in getting full performance out of your disks.

One is the PCI bus. Older PCI bus has a 33 MHz cycle and a 32 bit width,
giving a maximum bandwidth of about 1 Gbit/s, or 133 MB/s. This will
easily cause trouble with newer SATA disks which easily gives 70-90 MB/s
each. So do not put your SATA controllers on a 33 MHz PCI bus.

The 66 MHz 64-bit PCI bus is capable of handling about 4 Gbit/s, or
about 500 MB/s. This can also be a bottleneck with bigger arrays, eg a 6
drive array will be able to deliver about 500 MB/s, and maybe you want
also to feed a gigabyte ethernet card - 125 MB/s, totalling potentially
625 MB/s on the PCI bus.

The PCI-Express bus v1.1 has a limit of 250 MB/s per lane per dirction,
and that limit can easily be hit eg by a 4-drive array.

Many SATA controllers are on-board and do not use the PCI bus. Anyway
bandwidth is limited, but it is probably different from motherboard to
motherboard. On board disk controllers most likely have a bigger
bandwidth than IO controllers on a 32-bit PCI 33 MHz, 64-bit PCI 66 MHz,
or PCI-E x1 bus.

Having a RAID connected over the LAN can be a bottleneck, if the LAN
speed is only 1 Gbit/s - this limits the speed of the IO system to 125
MB/s by itself.

Classical bottlenecks are PATA drives placed on the same DMA channel, or
the same PATA cable. This will of cause limit performance, but it should
work, given you have no other means of connecting your disks by. Also
placing more than one element of an array on the same disk hurts
performace seriously, and also gives redundancy problems.

A classical problem is also not to have enabled DMA transfer, or having
lost this setting due to some problem, including not well connected
cables, or setting the transfer speed to less than optimal.

RAM sppec may be a bottleneck. Using 32 bit RAM - or using a 32 bit
operating system may double time spent reading and writing RAM.

CPU usage may be a bottleneck, also combined with slow RAM or only using
RAM in 32-bit mode.

BIOS settings may also impede your performance. 
