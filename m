From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 - RMW logic
Date: Tue, 12 Aug 2014 17:14:09 +1000
Message-ID: <20140812171409.5d625740@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
	<20140731073007.3fe4817a@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358639D05@EXCHANGE.collogia.de>
	<20140804112228.6ef95b10@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735863C68A@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/vlOr1UcFQkF3ymfu1D8Oy_y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863C68A@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/vlOr1UcFQkF3ymfu1D8Oy_y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2014 17:49:58 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> > Von: NeilBrown [neilb@suse.de]
> > Gesendet: Montag, 4. August 2014 03:22
> > An: Markus Stockhausen
> > Cc: linux-raid@vger.kernel.org
> > Betreff: Re: RAID6 - RMW logic
> >=20
> > > On Thu, 31 Jul 2014 06:43:52 +0000 Markus Stockhausen
> > > <stockhausen@collogia.de> wrote:
> > >=20
> > > Hi,
> > >
> > > thanks for the link. Crawling through the modifcation I isolated two =
steps
> > > that we must achieve in first place to get it on track. I'm far away =
from
> > > implementing a full patch so I focus on what I understand.
> > >
> > > 1) Implement a generic switch so we can configure rmw/rcw handling
> > > on the fly. Without any RAID6 rmw patches yet it will simply focus on=
 the
> > > current RAID5 implementation. Later on RAID6 can use it too and we
> > > are able to  compare rmw versus rcw performance in all cases.
> > > I would name the parameter enable_rmw and default it to 1. In RAID6 c=
ase
> > > it will be ignored.
> > >
> > > -> Ok with that?
> >=20
> > No, sorry.  Or not very.
> >=20
> > In that email thread I pointed you to I wrote:
> >=20
> > - Can you  explain *why* rcw is sometimes better than rmw even on large
> >   arrays? Even a fairly hand-wavy arguement would help.  And it would g=
o in
> >   the comment at the top of the patch that adds enable_rmw.
> >=20
> >=20
> > I see you've posted a patch, but there is no "why".
> > I don't like adding configuration options.  If there is some clear and =
easy
> > to understand benefit, like "this trades throughput against latency", t=
hen I
> > might be able to live with one, because it would be easy to tell people=
 how
> > to tune it.
> >=20
> > Why would I ever disable rmw?  Don't say "choose the option that perfor=
ms best
> > for your workload", because that is nearly meaningless: workloads chang=
e from
> > moment to moment.  If rwm is good in some cases and bad in others, then=
 we
> > should at least make sure we understand why, and then hopefully get the=
 md
> > driver  to auto-detect the different cases.
> >=20
> > There might be a case for allowing an option like that to support a
> > "developer only preview" of the code.  i.e.  Add the rmw-for-RAID6 code=
, find
> > that is slows down some workloads, get confused about why, ask for help,
> > people are only happy to  test if it is in mainline, so use a developer=
-only
> > config option.
> > Then at least I could tell people when to turn it on: only if you are a
> > developer.
>=20
> As you might have seen I posted a complete rmw patch to the mailing list.
> It is the first test version with the "developer switch". Sorry for being=
 very
> defensive in that way. Working only one week with the md raid code I
> wanted to ensure that nothing gets broken. Especially I had hard times to
> figure out the logic of the async layer. Therefore I'm very unsure if a s=
ystem=20
> with hardware assisted P/Q calculation will benefit straight forward from=
=20
> my patches.=20
>=20
> Additionaly I thought about some corner cases that might work better with
> one special switch option. To detect them automatically in md might be be=
yond
> the scope of this patch.
>=20
> Hopefully you can allay my concerns. If you like I can simply drop that s=
witch
> in the next version.=20

Thanks for the patches.  I'll try to have a proper look sometime soon, but =
it
might not be until next week.

NeilBrown

--Sig_/vlOr1UcFQkF3ymfu1D8Oy_y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+m+wTnsnt1WYoG5AQJY6xAAtF5Pyv0WYT3fQmQNidstH96OZQvqoBRl
oMOGH9dW8TqPx0nVc/ReMuEQnh5GRPNnN0VbrXlZ6FpjhUhouhQOPwwtnkZPOVng
wHHBqsNEcgL/59EGXsXGTWjQejWLUIjRKCaqZalclfMdHiJPM/S3opBo5B1XAyrP
cjjhEQlXTPwO8VPzZNiAI+lMM81ZjLzQ7QZBT0wU3UPR5jYxA6eACDqpkwjnEscJ
Shfcmoq5Ta5kH7JN1t/qOLpSeipBtctFghZemNldAwYJgRVCxB6RXhfp7HAtxoED
oTstos9cjLGtlnA/HpcY1XtQK2/2pCu0gUxpjXHg6SY70YaNddTU44VzZgCMDYV1
bFx4FCkL9jmxQ1VEm+flBdaNSOYoWczTDWa8vHEHIlcsYhyhMsVvd1HfsFa8v8np
U7euZ2Cwx1Q78Ex7ZKnxVk93ggmFqpkLmtfvNx2ttRCXZCbeYCzyR6QT7Nbu5fYT
rMHOlA16aqinPz69Ho96OO0z1Xh78RQuyfMS5zkWc5y/PoCPoYgEmca7JRgYzjyX
3SyQAB889QZA0N6jTNnZur4nhK50y+w27nMBuqecslvp12P6TB7XkjjZx0HrUHE/
RHqqSz0sJRelBXodMj1WZOT/KdBXvDFKRxFC3t4Yo5ipdo2Dygi79SC470WXn/V7
AVMY/5OH2Fo=
=LZOv
-----END PGP SIGNATURE-----

--Sig_/vlOr1UcFQkF3ymfu1D8Oy_y--
