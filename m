From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: OK, Now this is really weird
Date: Sun, 27 Feb 2011 01:22:41 -0600
Message-ID: <C3.E3.07087.0CBF96D4@cdptpa-omtalb.mail.rr.com>
References: <20110227083433.69b3d99a@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110227083433.69b3d99a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > >> > =A0 =A0 So what gives? =A0/dev/sdk3 no longer even exists, so =
why hasn't
> it
> > >> > been failed and removed on /dev /md3 like it has on /dev/md1 a=
nd
> > >> /dev/md2?
> > >>
> > >> Is it possible there has been no I/O request for /dev/md3 since
> > >> /dev/sdk failed?
> > >
> > > =A0 =A0 =A0 =A0Well, I thought about that. =A0It's swap space, so=
 I suppose it's
> > > possible. =A0I would have thought, however, that mdadm would fail=
 a
> missing
> > > member whether there is any I/O or not.
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-r=
aid"
> in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
> > >
> >
> > I thought so as well. But how will mdadm know is the device is faul=
ty,
> > unless the device is generating errors? (which usually only happens=
 on
> > read and/or write)
>=20
> With very recent mdadm the command
>=20
>    mdadm -If sdXX
>=20
> will find any md array that has /dev/sdXX as a member and will fail a=
nd
> remove it.

	No, it's version 3.1.4, and that gives me a "Device or Resource
busy" error.  It does report that it set sdk3 faulty, but the hot remov=
e
fails.

	So how can I remove the drive (so I can add it back)?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
