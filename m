From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 crashed for unknown reason on old 2.6.16 kernel
Date: Tue, 29 Jun 2010 16:50:31 +1000
Message-ID: <20100629165031.6c96a635@notabene.brown>
References: <AANLkTimTAvYM7p4sk8S5He4WOWT3FW6IRPQ0AfpFnIVR@mail.gmail.com>
	<AANLkTik3OIS0AKHZaBHEuqi9NNFKYQ7sWh_iZecirJgS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik3OIS0AKHZaBHEuqi9NNFKYQ7sWh_iZecirJgS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hennig <mhennig@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Jun 2010 17:29:37 +0200
Markus Hennig <mhennig@gmail.com> wrote:

> Hi all,
>=20
> for the (unlikely) case somebody is interested in a last update:
>=20
> I learned in the meantime that the UUID as well as the mdadm version
> is part of the checksum. And that that checksum is calculated on the
> first 1kb of the 4kb ver0.0 superblock.
> (https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_v=
ersion-0.90_Superblock_Format)
>=20
> Via hexedit I set the UUID on HHD2 back to the correct value and also
> changed the version information from 0.91.00 (0x5B) to 90 (0x5A).
> Done that the checksum was correct and equal the expect one.
>=20
> mdadm --assemble worked than like a charm and my RAID5 is back.

Thanks for letting us know the resolution.
I cannot imagine how all those '1's got into the metadata where they
shouldn't be.

Based on the update times and event counter, the HDD2 was slightly 'old=
er'
than the other devices.  Hopefully nothing had changed on the array in =
the
intervening time.

You should have been able to assemble the array with just the 3 sane de=
vices
and had a degraded RAID5.  Then add the fourth device and let it recove=
r.

However what you did seems to have worked, so if your data looks OK, yo=
u
should be safe.

NeilBrown


>=20
> That's it,
> Markus
>=20
>=20
> On Sat, Jun 26, 2010 at 11:22 PM, Markus Hennig <mhennig@gmail.com> w=
rote:
> > Hi all,
> >
> > my RAID5 with 4 disks crashed on a Buffalo "NAS" box (big-endian!) =
-
> > no logs of course...
> > I made immediately images of all disks and try to now gather my ver=
y
> > valuable content on a Linux box running GRML 4/10 (little-endian!)
> > with 2.6.33 and mdadm - v3.1.1.
> > Some blocks were not readable from HDD2, maybe that's the reason wh=
y
> > the Buffalo box shut down.
> >
> >
> > What I know already:
> >
> > - the RAID5 was created with a very old set of software:
> > linux-2.6.16-tshtgl.tgz =C2=A0 mdadm-2.5.2.tgz =C2=A0 xfsprogs-2.5.=
6_arm.tgz
> > - the Buffalo box blinked red on HDD2
> > - the box run a rebuild on HDD4, I don't know if that was already f=
inished
> > - all disks are identically, 250GB
> >
>=20
> > Open questions for which I wasn't able to find a answer myself :
> >
> > What triggers the event count? And why is the event counter on HDD2
> > just 129, on all other 131?
> > Can that cause problems while rescue my data and how can I work aro=
und it?
> >
> >
> > What is that "UUID : ffffffff:ffffffff:ffffffff:ffffffff" on HDD2?
> > What does it mean?
> >
> > Its really in the superblock on the hard disk:
> > =C2=A0hexdump -s 488006273b -C hdd2_ddrescue
> > =C2=A03a2cc50200 =C2=A0a9 2b 4e fc 00 00 00 00 =C2=A000 00 00 5b 00=
 00 00 00
> > |.+N........[....|
> > =C2=A03a2cc50210 =C2=A000 00 00 00 ff ff ff ff =C2=A041 a0 de f0 00=
 00 00 05
> > |........A.......|
> > =C2=A03a2cc50220 =C2=A00e 83 39 c0 00 00 00 04 =C2=A000 00 00 04 00=
 00 00 01
> > |..9.............|
> > =C2=A03a2cc50230 =C2=A000 00 00 00 ff ff ff ff =C2=A0ff ff ff ff ff=
 ff ff ff
> > |................|
> > =C2=A03a2cc50240 =C2=A000 00 00 00 00 00 00 00 =C2=A000 00 00 00 00=
 00 00 00
> > |................|
> > Would it help to rewrite the UUID via hexedit to the correct one?
> >
> >
> > Can somebody explain the meaning of:
> > =C2=A0Reshape pos'n : 0
> > =C2=A0 =C2=A0 =C2=A0New Level : raid0
> > =C2=A0 =C2=A0 New Layout : left-asymmetric
> > =C2=A0New Chunksize : 0
> > on HDD2 ?
> >
> >
> > What parameters are included in the checksum?
> > And how critical in on HHD2 that "Checksum : b8d2c453 - expected 45=
703820"?
> >
> >
> > I have no explanation why "Version :" is on HDD2 on 0.91.00"...
> > I see 0x5B in the partition 3 superblock on HDD2 (and on all other
> > 0x5A), so its really on the disk... =C2=A0Weird...
> > Somebody any idea on that?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
