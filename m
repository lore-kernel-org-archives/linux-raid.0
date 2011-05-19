From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: HBA Adaptor advice
Date: Thu, 19 May 2011 23:12:39 +0200
Message-ID: <1305839559.2718.1.camel@belgarion.office.romunt.nl>
References: <4DD50C89.8060006@wildgooses.com>  <4DD56B08.6020707@nybeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD56B08.6020707@nybeta.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Harold <thomas-lists@nybeta.com>
Cc: Ed W <lists@wildgooses.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2011-05-19 at 15:10 -0400, Thomas Harold wrote:
> On 5/19/2011 8:26 AM, Ed W wrote:
> > Hi, following on from a recent thread, can folks with decent
> > multi-port HBA adaptors please chime in with some model numbers of
> > known decent adaptors please?
> >
> > The required use is to grow from currently 8 ish drives to perhaps
> > 12-24 drives per machine. (It partitions out as: one or more RAID6
> > arrays for data, plus a couple of backup drives)
> >
> > Ideally I would like a controller with writeback cache and BBU sinc=
e
> > whilst this office machine is likely quite underused, for any
> > sensible amount of IO (some of the other machines we might upgrade)
> > this seems to give a 10-100x increase in IOPs? For the moment it's
> > just a nice to have though
> >
> > I only intend to use linux software raid, so any onboard raid
> > functionality is just a liability. Budget is either low =C2=A3100 i=
sh for
> > multi-port HBAs without cache, up to =C2=A31000 ish for 16-24 port =
high
> > performance cache controllers:
>=20
> I've been using a SuperMicro AOC-SASLP-MV8 (which is on your avoid=20
> list), which reports itself as:
>=20
> class: SCSI
> bus: PCI
> detached: 0
> driver: mvsas
> desc: "Marvell Technology Group Ltd. MV64460/64461/64462 System=20
> Controller, Revision B"
> vendorId: 11ab
> deviceId: 6485
> subVendorId: 15d9
> subDeviceId: 0500
>=20
> I've had it about 6 months at this point with SATA drives hooked up t=
o=20
> it.  The issues that I've had with it dropping disks from the 6-disk=20
> RAID-10 array on CentOS 5.5 / 5.6 can probably be traced to:
>=20
> Not using enterprise grade SATA disks (as the consumer brand takes to=
o=20
> long to timeout on a bad seek, and mdadm dropped it from the array).=20
> Possibly combined with using a really inexpensive set of removable dr=
ive=20
> trays.  There were a lot of times after the weekly resync where the=20
> entire array went offline due to multiple drives being dropped.
>=20
> Under normal operation it reads/writes to the disks fine and works fi=
ne=20
> as a controller.  Since this is my own personal server, I have not=20
> tested it with good SAS disks or enterprise SATAs and good drive=20
> enclosures.  I've since switched over to just hooking up a pair of RA=
ID1=20
> arrays to it with a direct connect from the card to the drives (no=20
> removable trays), but I don't have enough time on the new setup to sa=
y=20
> that the problem is permanently fixed yet.
>=20
> The card is inexpensive, which is a plus.  It's a PCIe x4 card.  I do=
n't=20
> know whether it would be better behaved with a better class of disks =
/=20
> enclosures.
Its inexpensive and unfortunately you are describing symptoms that
belong to the chipset.=20


It is remains firmly on my avoidance list, and i have one...=20

Rudy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
