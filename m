From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Thu, 3 Oct 2002 15:23:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021003132349.GE7350@unthought.net>
References: <200210021516.46668.roy@karlsbakk.net> <200210031225.11283.roy@karlsbakk.net> <20021003114020.GD7350@unthought.net> <200210031513.28459.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210031513.28459.roy@karlsbakk.net>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 03, 2002 at 03:13:28PM +0200, Roy Sigurd Karlsbakk wrote:
> > > I have used presistent superblocks, but md0,1,2,3 will be differe=
ntly
> > > ordered if I change the disk order... At least I think so. It sur=
ely
> > > didn't work.
> >
> > No. md0 would stay md0.  This is another effect of using superblock=
s,
> > and in fact this is also (ironically) more or less the only argumen=
t
> > *against* using them   :)
> >
> > (Imagine inserting a disk which knows that it is disk 0 of md0 into=
 some
> > machine that already has a perfectly fine md0 running)
>=20
> ok. so. theoretically - as long as the system finds all 16 drives, I =
should be=20
> able to shuffle them around and attach them to whichever controller t=
here is?=20
> right?

It will not reattach your disks (you need to move cables to do that),
but it will know "First disk of md0" from "Second disk of md0"
regardless of whether those disks are /dev/hda or /dev/sdg.

You can shuffle your disks around as much as you please.  When the RAID
code looks at your disks, it will read their superblocks and correctly
make the first disk of md0 the first disk of md0, and so forth,
regardless of the actual device name of the disk.

>=20
> ok.
>=20
> now, I've replaced the faulty controller, and booting up. the new con=
troller=20
> is also (like the old one) a CMD649...
>=20

RAID doesn't care about controllers.

RAID without persistent superblocks cares about disk device names.

RAID with persistent superblocks don't care about disk device names.

> h=E6?

=D8h?

>=20
> it works. but it surely didn't work last time...
>=20

Good for you  :)

> thanks
>=20
> > > But ... with persistent superblock - is it possible to fsckup the=
 raid?
> >
> > You're root, it is indeed possible  :)
>=20
> er - yes. I more meant like 'automagically'

It will only automagically screw up your arrays if you shuffle disks
between machines (mix several RAID arrays from other systems in one
system)  (you can of course move all your disks to one new machine, if
it has none of it's original RAIDed disks left).

Just don't mix disks with persistent superblocks from multiple machines
into one single machine.  Unless you know exactly what you're doing.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
