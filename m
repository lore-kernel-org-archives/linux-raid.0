From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Thu, 3 Oct 2002 13:05:44 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10210031249210.10557-100000@master.linux-ide.org>
References: <20021003132349.GE7350@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021003132349.GE7350@unthought.net>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


One of the observed issues under raid-tools is not looking at all the
devices' superblocks.  This would allow for out of order initialization=
=2E
Treating the devices as domino chips and stuffing them back in random
order and it working.

If I am wrong here, great.  Somebody please make the correction.

Cheers,

On Thu, 3 Oct 2002, Jakob Oestergaard wrote:

> On Thu, Oct 03, 2002 at 03:13:28PM +0200, Roy Sigurd Karlsbakk wrote:
> > > > I have used presistent superblocks, but md0,1,2,3 will be diffe=
rently
> > > > ordered if I change the disk order... At least I think so. It s=
urely
> > > > didn't work.
> > >
> > > No. md0 would stay md0.  This is another effect of using superblo=
cks,
> > > and in fact this is also (ironically) more or less the only argum=
ent
> > > *against* using them   :)
> > >
> > > (Imagine inserting a disk which knows that it is disk 0 of md0 in=
to some
> > > machine that already has a perfectly fine md0 running)
> >=20
> > ok. so. theoretically - as long as the system finds all 16 drives, =
I should be=20
> > able to shuffle them around and attach them to whichever controller=
 there is?=20
> > right?
>=20
> It will not reattach your disks (you need to move cables to do that),
> but it will know "First disk of md0" from "Second disk of md0"
> regardless of whether those disks are /dev/hda or /dev/sdg.
>=20
> You can shuffle your disks around as much as you please.  When the RA=
ID
> code looks at your disks, it will read their superblocks and correctl=
y
> make the first disk of md0 the first disk of md0, and so forth,
> regardless of the actual device name of the disk.
>=20
> >=20
> > ok.
> >=20
> > now, I've replaced the faulty controller, and booting up. the new c=
ontroller=20
> > is also (like the old one) a CMD649...
> >=20
>=20
> RAID doesn't care about controllers.
>=20
> RAID without persistent superblocks cares about disk device names.
>=20
> RAID with persistent superblocks don't care about disk device names.
>=20
> > h=E6?
>=20
> =D8h?
>=20
> >=20
> > it works. but it surely didn't work last time...
> >=20
>=20
> Good for you  :)
>=20
> > thanks
> >=20
> > > > But ... with persistent superblock - is it possible to fsckup t=
he raid?
> > >
> > > You're root, it is indeed possible  :)
> >=20
> > er - yes. I more meant like 'automagically'
>=20
> It will only automagically screw up your arrays if you shuffle disks
> between machines (mix several RAID arrays from other systems in one
> system)  (you can of course move all your disks to one new machine, i=
f
> it has none of it's original RAIDed disks left).
>=20
> Just don't mix disks with persistent superblocks from multiple machin=
es
> into one single machine.  Unless you know exactly what you're doing.
>=20
> --=20
> ................................................................
> :   jakob@unthought.net   : And I see the elder races,         :
> :.........................: putrid forms of man                :
> :   Jakob =D8stergaard      : See him rise and claim the earth,  :
> :        OZ9ABN           : his downfall is at hand.           :
> :.........................:............{Konkhra}...............:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

Andre Hedrick
LAD Storage Consulting Group

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
