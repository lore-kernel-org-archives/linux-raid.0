From: Kasper Dupont <kasperd@daimi.au.dk>
Subject: Re: RAID-6 support in kernel?
Date: Wed, 05 Jun 2002 00:27:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <adjf6t$328$2@main.gmane.org>
References: <Pine.LNX.4.33.0206031020290.30424-100000@mail.pronto.tv> <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <20020603113128.C13204@ucw.cz> <20020604154904.J36@toy.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Derek Vadala <derek@cynicism.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

Pavel Machek wrote:
>=20
> Hi!
>=20
> > > > It'll waste 9 drives, giving me a total capacity of 7n instead =
of 14n.
> > > > And, by definition, RAID-6 _can_ withstand _any_ two-drive fail=
ure.
> > >
> > > This is certainly not true.
> > >
> > > Combining N RAID-5 into a stripe wastes on N disks.
> > >
> > > If you combine two it wastes 2 disks, etc.
> > >
> > > That is, for each RAID-5 you waste a single disk worth of storage=
 for
> > > partiy. I don't know what equation you're using where you get 9 d=
rives
> > > from.
> >
> > He was thinking "mirror", not "stripe". Mirror of 2 RAID-5 arrays (=
would
> > be probably called RAID-15 (when there is a RAID-10 for mirrored st=
ripe
> > arrays)), can withstand any two disks failing anytime. Even more fo=
r
>=20
> RAID-1 over two RAID-5s should withstand any three failures, AFAICS.
>=20
> You could do RAID-5 over RAID-5. That should survive any 2 failures a=
nd
> still be reasonably efficient.

It will actually survive any 3 disk failures. It is reasonable
if you have a lot of disks. It requires at least 9 disks and
I would prefere at least 25 disks.

RAID-4 and RAID-5 are very similar. And it happens to be the
case that if you only use two disks RAID-1, RAID-4, and RAID-5
are all identical. And each of them can survive a single disk
failure.

Any two of these RAIDs on top of each other can survive three
disk failures. That is true because it takes four disk failures
to loose data. On the upper most RAID you must loose two of the
lower level RAIDs, each of these two must have lost two disks.

RAID-4 on top of RAID-4 is actually just a two-dimentional
parity. RAID-5 on top of RAID-5 is very similar.=20

--=20
Kasper Dupont -- der bruger for meget tid p=E5 usenet.
=46or sending spam use mailto:razor-report@daimi.au.dk
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
