From: "David Lethe" <david@santools.com>
Subject: RE: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 12:04:11 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
References: <20080702155603.GA11156@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20080702155603.GA11156@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Keld J=F8rn Simonsen
Sent: Wednesday, July 02, 2008 10:56 AM
To: linux-raid@vger.kernel.org
Subject: new bottleneck section in wiki

I should have done something else this afternoon, but anyway, I was
inspired to write up this text for the wiki. Comments welcome.

Keld

Bottlenecks

There can be a number of bottlenecks other than the disk subsystem that
hinders you in getting full performance out of your disks.

One is the PCI bus. Older PCI bus has a 33 MHz cycle and a 32 bit width=
,
giving a maximum bandwidth of about 1 Gbit/s, or 133 MB/s. This will
easily cause trouble with newer SATA disks which easily gives 70-90 MB/=
s
each. So do not put your SATA controllers on a 33 MHz PCI bus.

The 66 MHz 64-bit PCI bus is capable of handling about 4 Gbit/s, or
about 500 MB/s. This can also be a bottleneck with bigger arrays, eg a =
6
drive array will be able to deliver about 500 MB/s, and maybe you want
also to feed a gigabyte ethernet card - 125 MB/s, totalling potentially
625 MB/s on the PCI bus.

The PCI-Express bus v1.1 has a limit of 250 MB/s per lane per dirction,
and that limit can easily be hit eg by a 4-drive array.

Many SATA controllers are on-board and do not use the PCI bus. Anyway
bandwidth is limited, but it is probably different from motherboard to
motherboard. On board disk controllers most likely have a bigger
bandwidth than IO controllers on a 32-bit PCI 33 MHz, 64-bit PCI 66 MHz=
,
or PCI-E x1 bus.

Having a RAID connected over the LAN can be a bottleneck, if the LAN
speed is only 1 Gbit/s - this limits the speed of the IO system to 125
MB/s by itself.

Classical bottlenecks are PATA drives placed on the same DMA channel, o=
r
the same PATA cable. This will of cause limit performance, but it shoul=
d
work, given you have no other means of connecting your disks by. Also
placing more than one element of an array on the same disk hurts
performace seriously, and also gives redundancy problems.

A classical problem is also not to have enabled DMA transfer, or having
lost this setting due to some problem, including not well connected
cables, or setting the transfer speed to less than optimal.

RAM sppec may be a bottleneck. Using 32 bit RAM - or using a 32 bit
operating system may double time spent reading and writing RAM.

CPU usage may be a bottleneck, also combined with slow RAM or only usin=
g
RAM in 32-bit mode.

BIOS settings may also impede your performance.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I would add -
The PCI (and PCI-X) bus is shared bandwidth, and operates at lowest com=
mon denominator.  Put a 33Mhz card in the PCI bus, and not only does ev=
erything operate at 33Mhz, but all of the cards compete.  Grossly simpl=
ified, if you have a 133Mhz card and a 33Mhz card in the same PCI bus, =
then that card will operate at 16Mhz. Your motherboard's embedded Ether=
net chip and disk controllers are "on" the PCI bus, so even if you have=
 a single PCI controller card, and a multiple-bus motherboard, then it =
does make a difference what slot you put the controller in.

If this isn't bad enough, then consider the consequences of arbitration=
=2E  All of the PCI devices have to constantly negotiate between themse=
lves to get a chance to compete against all of the other devices attach=
ed to other PCI busses to get a chance to talk to the CPU and RAM.  As =
such, every packet your Ethernet card picks up could temporarily suspen=
d disk I/O if you don't configure things wisely.

- David Lethe






--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
