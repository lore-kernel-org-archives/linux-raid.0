From: Thomas Harold <thomas-lists@nybeta.com>
Subject: Re: HBA Adaptor advice
Date: Thu, 19 May 2011 15:10:00 -0400
Message-ID: <4DD56B08.6020707@nybeta.com>
References: <4DD50C89.8060006@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD50C89.8060006@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/19/2011 8:26 AM, Ed W wrote:
> Hi, following on from a recent thread, can folks with decent
> multi-port HBA adaptors please chime in with some model numbers of
> known decent adaptors please?
>
> The required use is to grow from currently 8 ish drives to perhaps
> 12-24 drives per machine. (It partitions out as: one or more RAID6
> arrays for data, plus a couple of backup drives)
>
> Ideally I would like a controller with writeback cache and BBU since
> whilst this office machine is likely quite underused, for any
> sensible amount of IO (some of the other machines we might upgrade)
> this seems to give a 10-100x increase in IOPs? For the moment it's
> just a nice to have though
>
> I only intend to use linux software raid, so any onboard raid
> functionality is just a liability. Budget is either low =A3100 ish fo=
r
> multi-port HBAs without cache, up to =A31000 ish for 16-24 port high
> performance cache controllers:

I've been using a SuperMicro AOC-SASLP-MV8 (which is on your avoid=20
list), which reports itself as:

class: SCSI
bus: PCI
detached: 0
driver: mvsas
desc: "Marvell Technology Group Ltd. MV64460/64461/64462 System=20
Controller, Revision B"
vendorId: 11ab
deviceId: 6485
subVendorId: 15d9
subDeviceId: 0500

I've had it about 6 months at this point with SATA drives hooked up to=20
it.  The issues that I've had with it dropping disks from the 6-disk=20
RAID-10 array on CentOS 5.5 / 5.6 can probably be traced to:

Not using enterprise grade SATA disks (as the consumer brand takes too=20
long to timeout on a bad seek, and mdadm dropped it from the array).=20
Possibly combined with using a really inexpensive set of removable driv=
e=20
trays.  There were a lot of times after the weekly resync where the=20
entire array went offline due to multiple drives being dropped.

Under normal operation it reads/writes to the disks fine and works fine=
=20
as a controller.  Since this is my own personal server, I have not=20
tested it with good SAS disks or enterprise SATAs and good drive=20
enclosures.  I've since switched over to just hooking up a pair of RAID=
1=20
arrays to it with a direct connect from the card to the drives (no=20
removable trays), but I don't have enough time on the new setup to say=20
that the problem is permanently fixed yet.

The card is inexpensive, which is a plus.  It's a PCIe x4 card.  I don'=
t=20
know whether it would be better behaved with a better class of disks /=20
enclosures.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
