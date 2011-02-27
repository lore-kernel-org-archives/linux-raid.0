From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: OK, Now this is really weird
Date: Sun, 27 Feb 2011 01:15:41 -0600
Message-ID: <64.30.07087.C1AF96D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTim_cF9nnXMz2pJfewFqW68p1b0gKoKbtjRa6wqE@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_cF9nnXMz2pJfewFqW68p1b0gKoKbtjRa6wqE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Mathias_Bur=E9n'?= <mathias.buren@gmail.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> >> > =A0 =A0 So what gives? =A0/dev/sdk3 no longer even exists, so wh=
y hasn't it
> >> > been failed and removed on /dev /md3 like it has on /dev/md1 and
> >> /dev/md2?
> >>
> >> Is it possible there has been no I/O request for /dev/md3 since
> >> /dev/sdk failed?
> >
> > =A0 =A0 =A0 =A0Well, I thought about that. =A0It's swap space, so I=
 suppose it's
> > possible. =A0I would have thought, however, that mdadm would fail a
> missing
> > member whether there is any I/O or not.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> I thought so as well. But how will mdadm know is the device is faulty=
,
> unless the device is generating errors? (which usually only happens o=
n
> read and/or write)

Well, reading here, I believe I have seen posts talking about mdadm wak=
ing
up sleeping spindles periodically, thereby killing part of the power sa=
ving
functions of "green" drives.  Have those posts been in error?  It's bee=
n
days since the drive "failed".

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
