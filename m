From: Shaohua Li <shli@kernel.org>
Subject: Re: RAID journal, requirements?
Date: Wed, 3 Feb 2016 17:25:05 -0800
Message-ID: <20160204012505.GB29132@kernel.org>
References: <20160127001520.GH3039@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160127001520.GH3039@otheros>
Sender: linux-raid-owner@vger.kernel.org
To: Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2016 at 01:15:20AM +0100, Linus L=FCssing wrote:
> Hi,
>=20
> I am very excited about the new journaling feature for RAID in md
> and want to try it out soon.
>=20
> Neil's article on LWN already gave a great overview and some hints
> about it, but I am still a little unsure about the technical
> requirements for the journal device. E.g. speed, reliability and
> size-wise. And what the implications of failing them means.
>=20
> I want to setup a small home NAS. My personal priorities are:
> Firstly, low power-per-GB as it will be solar powered and battery
> backed. Second priority is reliability. Performance is not that
> important to me.
>=20
> My current plan: Tiny ARM-based computer (Odroid C1+: 4x USB (2.0,
> unfortunately) ports), 4x 2TB SATA HDDs (@0.7W idle, 1.7W max. each)
> + SATA-to-USB -> RAID5, microSD for OS + applications, an eMMC for
> a RAID journal. (later, once they hopefully get available in April,
> switch to the Turris Omnia which is ARM-based again but has
> mini-PCIe, too, where I would attach mini-PCIe-to-SATA adapters)
>=20
> Is it a stupid idea to use an eMMC for the journal in the first
> place? I am unsure how quickly it would wear out. And seems like I
> do not have SMART for it either... So it would probably fail badly
> at some point. Is that an issue, can I simply replace the eMMC
> then without any data loss? Will the current code at least try a
> write-through directly to the HDDs once a journal disk throws
> errors?
>=20
> Does MD assume that an underlying device performs some sort of wear
> leveling if necessary like SSDs do for instance - or does MD
> itself distribute writes evenly over the journaling disk?
> (Does anyone know whether eMMCs usually do some kind of wear leveling=
?)
>=20
>=20
> Thanks for all your work on this awesome new feature! (and special
> thanks to Neil for all the years of maintenance - it is a pitty you
> have to step down :( )

The only requirement of journal is it has a block interface. But all wr=
ite IO
write to journal first, so there could be a lot of write to journal dep=
ending
on your workload. I don't know about eMMC much, but suppose it doesn't =
have
good wear leveling support.

If journal is broken, your data isn't lost, as data is still stored in =
raid
disks. Our current policy is the array becomes read-only if journal is =
borken,
this might be changed if necessary though.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
