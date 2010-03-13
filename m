From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 On 3 Drives
Date: Sun, 14 Mar 2010 08:50:56 +1100
Message-ID: <20100314085056.5ea95f95@notabene.brown>
References: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
	<20100314082649.187dae9a@notabene.brown>
	<70ed7c3e1003131331g14e30331k8b97520c906431fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003131331g14e30331k8b97520c906431fd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 14 Mar 2010 00:31:01 +0300
"Majed B." <majedb@gmail.com> wrote:

> Neil,
>=20
> Since when was this possible? I always thought that it had to have an
> even number of disks.

md has never imposed a 2-drive restriction on raid1.  That would be fai=
rly
pointless.

Requiring an even number of devices would also be pointless.

The term "mirror" is possibly a cause of confusion as it suggests an or=
iginal
and a copy.  It also suggests that the copy is reflected in some way.
Neither of these are true.
RAID1 stores multiple copies of the same data.  All copies are equal.  =
You can
have as many or as few of them as you like.  1, 2, 3, 4, ....
NeilBrown


>=20
> On Sun, Mar 14, 2010 at 12:26 AM, Neil Brown <neilb@suse.de> wrote:
> > On Sat, 13 Mar 2010 16:06:38 -0500
> > Carlos Mennens <carloswill@gmail.com> wrote:
> >
> >> I was told by my distributions Wiki page that Grub doesn't support
> >> RAID 5 or RAID 6 so I would need to create a volume with three dis=
ks
> >> and set the level to RAID 1:
> >>
> >> # mdadm --create /dev/md1 --level=3D1 --raid-devices=3D3 /dev/sda1
> >> /dev/sdb1 /dev/sdc1 --spare-devices=3D1 /dev/sdd1
> >>
> >> Is this possible to mirror three identical drive partitions? I was
> >> talking to some co-workers and was told that I could only pair two
> >> drives on RAID 1.
> >
> > Your co-workers are wrong, at least for md raid. =C2=A0With md, a R=
AID1 can have
> > any number of devices from 1 upwards - the limit varies in differen=
t
> > situations but is at least 28.
> >
> > Try it and see.
> >
> > NeilBrown
> >
> >>
> >> Can anyone please help me understand this?
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
