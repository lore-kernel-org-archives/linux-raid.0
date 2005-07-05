From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: AW: skip raid5 reconstruction
Date: Tue, 05 Jul 2005 15:32:07 -0400
Message-ID: <1120591927.5535.65.camel@localhost.localdomain>
References: <20050705172915.1CB9D2F88D@mail.kip.uni-heidelberg.de>
	 <1120585497.5535.60.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120585497.5535.60.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Lord Hess <Hess@certon.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2005-07-05 at 13:44 -0400, Ming Zhang wrote:
> Thx.
>=20
> So it looks like mkraid might do this.
I tried mkraid and it works.=20

Thanks a lot!

Ming

>=20
> With this hint, I googled the --danferous-no-resync and try to do thi=
s
>=20
> # mdadm --create /dev/md1 --level=3D5 --assume-clean --raid-
> devices=3D4 /dev/sdf /dev/sdg /dev/sdh /dev/sdi
>=20
> But then i ran some io and use iostat to find that only 3 devices has=
 io
> request and the parity disk has no disk activity at all. so this will=
 be
> a skewed data for me.
>=20
> Ming
>=20
>=20
>=20
> On Tue, 2005-07-05 at 19:26 +0200, Lord Hess wrote:
> >  kkraid -R --dangerous-no-resync /dev/md..
> >=20
> > Regards,
> >=20
> > Lord
> >=20
> > Certon systems GmbH
> > Hans-Bunte-Str. 8 - 10
> > 69123 Heidelberg
> > Tel:  +49 6221 549810
> > Fax: +49 6221 549809
> > http://www.certon.de
> > mail to: hess@certon.de
> > -----Urspr=C3=BCngliche Nachricht-----
> > Von: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] Im Auftrag von Ming Zhang
> > Gesendet: Dienstag, 5. Juli 2005 19:23
> > An: Linux RAID
> > Betreff: skip raid5 reconstruction
> >=20
> > Hi folks
> >=20
> > I am testing some HW performance with raid5 with 2.4.x kenrel.
> >=20
> > It is really troublesome every time I create a raid5, wait 4 hours =
for
> > reconstruction, and then test some data and then recreate another o=
ne
> > and wait again. I wonder if there is any hack or option available t=
o
> > create a raid5 without reconstruct the parity disk. I just have int=
erest
> > to test the performance so do not care about data correctness at th=
is
> > stage.
> >=20
> > Thanks!
> >=20
> >=20
> > Ming
> >=20
> >=20
> >=20
> >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
