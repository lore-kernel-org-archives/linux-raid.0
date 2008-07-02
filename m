From: "David Lethe" <david@santools.com>
Subject: RE: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 13:08:04 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20080702175117.GC12081@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----
=46rom: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]=20
Sent: Wednesday, July 02, 2008 12:51 PM
To: David Lethe
Cc: linux-raid@vger.kernel.org
Subject: Re: new bottleneck section in wiki

On Wed, Jul 02, 2008 at 12:04:11PM -0500, David Lethe wrote:
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Wednesday, July 02, 2008 10:56 AM
> To: linux-raid@vger.kernel.org
> Subject: new bottleneck section in wiki
>=20
> I should have done something else this afternoon, but anyway, I was
> inspired to write up this text for the wiki. Comments welcome.
 ....

>=20
> I would add -
> The PCI (and PCI-X) bus is shared bandwidth, and operates at lowest c=
ommon denominator.  Put a 33Mhz card in the PCI bus, and not only does =
everything operate at 33Mhz, but all of the cards compete.  Grossly sim=
plified, if you have a 133Mhz card and a 33Mhz card in the same PCI bus=
, then that card will operate at 16Mhz. Your motherboard's embedded Eth=
ernet chip and disk controllers are "on" the PCI bus, so even if you ha=
ve a single PCI controller card, and a multiple-bus motherboard, then i=
t does make a difference what slot you put the controller in.
>=20
> If this isn't bad enough, then consider the consequences of arbitrati=
on.  All of the PCI devices have to constantly negotiate between themse=
lves to get a chance to compete against all of the other devices attach=
ed to other PCI busses to get a chance to talk to the CPU and RAM.  As =
such, every packet your Ethernet card picks up could temporarily suspen=
d disk I/O if you don't configure things wisely.

Thanks, I added this text, modifed a little. And also I would like to
note that I was inspired by some emailing with you, when writing the
text.

Current motherboards with onboard disk controlles normally do not have
the disk IO connected via the PCI or PCI-E busses, but rather directly =
via the
southbridge. What are typical transfer rates between the southbridge
and the northbridge? Could this potentionally be a bottleneck?

And also the disk controllers, could these be bottlenecks? They typical=
ly
operate at 300 MB/s nominally, per disk channel, and presumably they
then have a connection to the southbridge that is capable of handling
this speed. So for a 4-disk SATA-II controller this would be at least
1200 MB/s or about 10 gigabit.=20

best regards
keld
-------------------
It is much more complicated than just saying what the transfer rates ar=
e, especially in the world of blocking, arbitration, and unbalanced I/O=
=2E =20

Everything is a potential bottleneck.  As I am under NDA with most of t=
he controller vendors, then I can not provide specifics, but suffice to=
 say that certain cards with certain chipsets will max out at well unde=
r published speeds.  Heck, you could attach solid-state disks with rand=
om I/O access time in the nanosecond range and still only get 150MB/sec=
 out of certain controllers, even on a PCIe X 16 bus.=20

BTW, there isn't a SATA-II controller in the planet that will deliver 1=
200 MB/sec with 4 disk drives.=20

David



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
