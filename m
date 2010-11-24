From: Neil Brown <neilb@suse.de>
Subject: Re: raid related kernel hang in 2.6.36
Date: Thu, 25 Nov 2010 07:01:55 +1100
Message-ID: <20101125070155.277a0d62@notabene.brown>
References: <4CED17A4.7050604@perabytes.com>
	<AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
	<4CED226D.6090602@perabytes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CED226D.6090602@perabytes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Du Jun <dujun@perabytes.com>
Cc: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Nov 2010 22:34:21 +0800 Du Jun <dujun@perabytes.com> wrote:

> Their's no dmesg information at all before the hang. The system just=20
> hangs suddenly without any kernel printk or oops.
>=20
> mdadm version is debian lenny version 2.6.7.2-3
>=20
> I will get mdadm -E & mdadm -D informations tomorrow but I doubt they=
=20
> are useful.

Probably not, but they wouldn't hurt either.

What would really help is if you could capture the result of
    sysrq-T

which I accept might be a challenge depending on how hard the machine r=
eally
has frozen.

Also, make sure the LOCKUP_DETECTOR config options are set, and wait a =
few
minutes after the hand to see if something pops up.

I'll try to see if I can reproduce, but I don't have 16 disks so it may=
 not
work.

NeilBrown


>=20
> Johnson
> on 2010/11/24 22:19, Mathias Bur=E9n  wrote:
> > Hi,
> >
> > I suppose a few logs would be interesting. (dmesg, mdadm -E (hdds),
> > mdadm -D md10, zcat /proc/config.gz, mdadm version)
> >
> > Regards,
> > // Mathias
> >
> > 2010/11/24 Du Jun<dujun@perabytes.com>:
> >   =20
> >> Hi,
> >> We just quick tested the raid stability under the vanilla 2.6.36 k=
ernel
> >> and got an unstable result.
> >>
> >> first, we create a raid5 array using 16 sata disks:
> >>
> >> mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]
> >>
> >> then use dd to stress the io:
> >>
> >> dd if=3D/dev/zero of=3D/dev/md10 bs=3D1M
> >>
> >> After a while, usually several minutes, the system hangs. It looks=
 like
> >> some kind of kernel deadlock. ping to this machine could get timel=
y
> >> response, however, any other process just hangs.
> >>
> >> It is easily reproducible and everytime the test result is a syste=
m hang.
> >>
> >> Johnson
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>     =20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >   =20
>=20
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
