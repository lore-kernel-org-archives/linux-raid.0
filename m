From: NeilBrown <neilb@suse.de>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 08:51:48 +1000
Message-ID: <20110420085148.12ac0002@notabene.brown>
References: <1303215166.2809.8.camel@valio>
	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
	<4DADB24F.2030300@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DADB24F.2030300@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Apr 2011 12:03:27 -0400 Iordan Iordanov <iordan@cdf.toronto.=
edu>
wrote:

> Hey guys,
>=20
> On 04/19/11 08:25, Mathias Bur=E9n wrote:
> > http://www.debian-administration.org/articles/238
> >
> > Plenty of articles on the net on how to do that.
>=20
> There is a lot of information, but also, I suspect there is a lot of=20
> disagreement. One thing that I could not find a definitive answer on =
was=20
> the question of whether or not to mirror swap.
>=20
> There are articles that propose mirroring partitions independently=20
> (rather than the entire disk), and not mirroring swap, but adding two=
=20
> swap partitions with equal priority. On the other hand, there are peo=
ple=20
> who point out that in the event where one of the disks in the mirror=20
> dies, the machine may cease to function, because a part of its "memor=
y"=20
> will have disappeared. However, making swap part of the mirror opens =
a=20
> whole new can of worms. For instance, could there be a deadlock=20
> possibility (for example after a suspend/resume cycle) where mdadm is=
=20
> waiting for something which is swapped out onto swap which is mirrore=
d?

If there was such a deadlock, it would be a serious bug.   I don't beli=
eve
such a bug exists (but hey - I keep finding bugs in this code, when I'm=
 not
busy writing new bugs, so I guess it could crash you machine and kill y=
our
cat).

>=20
> It would be nice to have a discussion among people who have experienc=
e=20
> with all of this.

Definitely put swap on RAID1 if you have RAID1 at all.

My personal preference with RAID1 to to have a single RAID1 (probably
--metadata=3D1.0) across the whole devices, and partition that for root=
, swap,
home.

Others prefer to partition the devices and run RAID1 across the partiti=
ons
independently.  While that is not my preference I known nothing against=
 it.
This is the price of freedom - you have to make choices

If I had a few identical drives, I would partition them each into a
small /boot, a small swap and the rest.  I would then RAID1 all the /bo=
ots
together, RAID10 all the swaps, and RAID5 or RAID6 all the rest.

The most important thing though it to create an configuration that you
understand and are comfortable with, because you are the one who will h=
ave to
manage it.

NeilBrown


>=20
> Cheers,
> Iordan
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
