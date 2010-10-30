From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: argh!
Date: Sat, 30 Oct 2010 18:57:41 -0500
Message-ID: <C4.61.07087.9F0BCCC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >> > a new HDD has failed on me during a scrub.... i tried to remove/=
fail
> it
> >> but
> >> > it kept saying the device was busy. so i forced a reboot.

	BTW, it's better, if you can, to free up the device, rather than
reboot.  Now that you have rebooted, that's no longer possible.

> >> > I have physically disconnected the drive..
> >> >
> >> > can anyone take alook at the examine below and tell me if it is
> should
> >> > assemble ok?
> >> >
> >> > I tried
> >> >
> >> > mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sde=
1
> >> /dev/sdf1
> >> > /dev/sdg1
> >>
> >> I'd try:
> >>
> >> mdadm --assemble /dev/md4 /dev/sd{g,a,e}1 missing /dev/sd{d,b,f}1
> >
> >
> > =A0 =A0 =A0 =A0Yeah, I would, too. =A0Also, what are the contents o=
f
> > /etc/mdadm/mdadm.conf? =A0If it is correct, then `mdadm --assemble =
--scan`
> > should work.
> >
> >
>=20
> Hey, yeah I am confused as drives have failed before and it has still
> assembled. I think it is because it is unclean....
>=20
> Can I ask how did you arrive at the command list?

	Look at the results of --examine.  Every one shows the list of
drives and their order.

> what is wrong with dbf?

	'No idea.  SMART might give you an idea, or the kernel logs.

> also this is my mdadm.conf
>=20
>=20
> DEVICE /dev/sd[abcdefg]1 /dev/hd[ab]1
>=20
> ARRAY /dev/md/4 metadata=3D0.90 UUID=3D7438efd1:9e6ca2b5:d6b88274:700=
3b1d3
> ARRAY /dev/md/3 metadata=3D0.90 UUID=3Da1f24bc9:4e72a820:3a03f7dc:07f=
9ab98
> ARRAY /dev/md/2 metadata=3D0.90 UUID=3D0642323a:938992ef:b750ab21:e5a=
55662
> ARRAY /dev/md/1 metadata=3D0.90 UUID=3Dd4eeec62:148b3425:3f5e931c:bb3=
ef499

	--scan may work.  I suggest updating the file with all the array
members.  Why are all the arrays assembled with 0.90 superblocks?  The =
0.90
superblock has some significant limitations.  They may not be causing y=
ou
grief right now, but they could in the future.  The only arrays I have =
built
with 0.90 superblocks are the /boot targets, because GRUB2 does not sup=
port
1.x superblocks.  I've chosen 1.2 for all the others.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
