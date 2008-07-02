From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: new bottleneck section in wiki
Date: Wed, 02 Jul 2008 16:45:38 -0500
Message-ID: <486BF702.9070105@gmail.com>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Wednesday, July 02, 2008 10:56 AM
> To: linux-raid@vger.kernel.org
> Subject: new bottleneck section in wiki
>=20
> I should have done something else this afternoon, but anyway, I was
> inspired to write up this text for the wiki. Comments welcome.
>=20
> Keld
>=20
> Bottlenecks
>=20
> There can be a number of bottlenecks other than the disk subsystem th=
at
> hinders you in getting full performance out of your disks.
>=20
> One is the PCI bus. Older PCI bus has a 33 MHz cycle and a 32 bit wid=
th,
> giving a maximum bandwidth of about 1 Gbit/s, or 133 MB/s. This will
> easily cause trouble with newer SATA disks which easily gives 70-90 M=
B/s
> each. So do not put your SATA controllers on a 33 MHz PCI bus.
>=20
> The 66 MHz 64-bit PCI bus is capable of handling about 4 Gbit/s, or
> about 500 MB/s. This can also be a bottleneck with bigger arrays, eg =
a 6
> drive array will be able to deliver about 500 MB/s, and maybe you wan=
t
> also to feed a gigabyte ethernet card - 125 MB/s, totalling potential=
ly
> 625 MB/s on the PCI bus.
>=20
> The PCI-Express bus v1.1 has a limit of 250 MB/s per lane per dirctio=
n,
> and that limit can easily be hit eg by a 4-drive array.
>=20
> Many SATA controllers are on-board and do not use the PCI bus. Anyway
> bandwidth is limited, but it is probably different from motherboard t=
o
> motherboard. On board disk controllers most likely have a bigger
> bandwidth than IO controllers on a 32-bit PCI 33 MHz, 64-bit PCI 66 M=
Hz,
> or PCI-E x1 bus.
>=20
> Having a RAID connected over the LAN can be a bottleneck, if the LAN
> speed is only 1 Gbit/s - this limits the speed of the IO system to 12=
5
> MB/s by itself.
>=20
> Classical bottlenecks are PATA drives placed on the same DMA channel,=
 or
> the same PATA cable. This will of cause limit performance, but it sho=
uld
> work, given you have no other means of connecting your disks by. Also
> placing more than one element of an array on the same disk hurts
> performace seriously, and also gives redundancy problems.
>=20
> A classical problem is also not to have enabled DMA transfer, or havi=
ng
> lost this setting due to some problem, including not well connected
> cables, or setting the transfer speed to less than optimal.
>=20
> RAM sppec may be a bottleneck. Using 32 bit RAM - or using a 32 bit
> operating system may double time spent reading and writing RAM.
>=20
> CPU usage may be a bottleneck, also combined with slow RAM or only us=
ing
> RAM in 32-bit mode.
>=20
> BIOS settings may also impede your performance.=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I would add -
> The PCI (and PCI-X) bus is shared bandwidth, and operates at=20
 > lowest common denominator.  Put a 33Mhz card in the PCI bus,
> and not only does everything operate at 33Mhz, but all of=20
 > the cards compete.  Grossly simplified, if you have a 133Mhz
 > card and a 33Mhz card in the same PCI bus, then that card
 > will operate at 16Mhz. Your motherboard's embedded Ethernet
 > chip and disk controllers are "on" the PCI bus, so even if
 > you have a single PCI controller card, and a multiple-bus
 > motherboard, then it does make a difference what slot
 > you put the controller in.

Add in on the higher end MB's (with PCI-X, and PCIe, and
stuff on the built-in to the motherboard) there is often a nice
block diagram  that indicates which resources are sharing bandwidth,
and often how much bandwidth they are sharing, so if one is
careful one can carefully put different things on unshared parts,
and take careful note of what other MB things they are being
shared with.  With desktop motherboards this does not generally
matter at all as there is typically only one PCI (32bit) bus and it
is all shared.   And often the stuff on the MB is only connected
slightly better that a 32-bit/33mhz PCI bus, so one has to be
careful and take note of the reality of their MB.

>=20
> If this isn't bad enough, then consider the consequences of
 > arbitration.  All of the PCI devices have to constantly
> negotiate between themselves to get a chance to compete=20
> against all of the other devices attached to other PCI=20
> busses to get a chance to talk to the CPU and RAM.  As=20
> such, every packet your Ethernet card picks up could=20
> temporarily suspend disk I/O if you don't configure things wisely.

And note that in my experience if you are going to find a "bug" in the =
MB design=20
this sharing/arbitration under high loads is where you will find it, an=
d it can=20
result in everything from silent corruption to the entire machine crash=
ing when
put under heavy load.

                              Roger
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
