From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 On 3 Drives
Date: Sun, 14 Mar 2010 08:45:22 +1100
Message-ID: <20100314084522.477c9894@notabene.brown>
References: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
	<70ed7c3e1003131321t48686cb5l33a10b8708b27dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003131321t48686cb5l33a10b8708b27dd7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 14 Mar 2010 00:21:06 +0300
"Majed B." <majedb@gmail.com> wrote:

> RAID is called mirror: You need 2 drives: The original and the mirror=
=2E
>=20
> You can make a RAID1 array of 2 disks + 1 spare if you wish.

On what do you base this (false) assertion?   If there is something
in the md documentation that suggests this I would like to get
it fixed.

NeilBrown

>=20
> On Sun, Mar 14, 2010 at 12:06 AM, Carlos Mennens <carloswill@gmail.co=
m> wrote:
> > I was told by my distributions Wiki page that Grub doesn't support
> > RAID 5 or RAID 6 so I would need to create a volume with three disk=
s
> > and set the level to RAID 1:
> >
> > # mdadm --create /dev/md1 --level=3D1 --raid-devices=3D3 /dev/sda1
> > /dev/sdb1 /dev/sdc1 --spare-devices=3D1 /dev/sdd1
> >
> > Is this possible to mirror three identical drive partitions? I was
> > talking to some co-workers and was told that I could only pair two
> > drives on RAID 1.
> >
> > Can anyone please help me understand this?
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
