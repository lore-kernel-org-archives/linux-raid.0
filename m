From: NeilBrown <neilb@suse.de>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Tue, 14 Jan 2014 20:16:55 +1100
Message-ID: <20140114201655.61f4e10b@notabene.brown>
References: <52BD8EDD.10809@assyoma.it>
	<20131227151927.GA4003@www5.open-std.org>
	<52BD9B4F.3000509@assyoma.it>
	<20131227154952.GA6539@www5.open-std.org>
	<52CE57D9.1030501@assyoma.it>
	<20140113102021.1ef3e203@notabene.brown>
	<52D3A962.4000308@assyoma.it>
	<20140113204534.737a98f6@notabene.brown>
	<52D3BCB1.1010200@assyoma.it>
	<20140114092751.09464b7b@notabene.brown>
	<52D4FE05.3020709@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ube/mby/NWUTF8AnYw6Red5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D4FE05.3020709@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org, keld@keldix.com
List-Id: linux-raid.ids

--Sig_/Ube/mby/NWUTF8AnYw6Red5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Jan 2014 10:06:13 +0100 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> On 01/13/2014 11:27 PM, NeilBrown wrote:
> >>
> >> Mmm... they seem different to me.
> >>
> >> SeSe FAR Layout:
> >>
> >> sda1 sdb1 sdc1 sde1
> >>     0    1    2    3
> >>     4    5    6    7
> >>     . . .
> >>     3    0    1    2
> >>     7    4    5    6
> >>
> >> Notice how (for example) sdb1 is coupled both to sda1 (0,4) and
> >> sdc1(1,5). If sdb1 fails, any sda1 or sdc1 failure lead to data loss.
> >>
> >> Now, Wikipedia FAR Layout:
> >>
> >> 4 drives (sda1, sdb1, sdc1, sdd1)
> >> --------------------
> >> A1   A2   A3   A4
> >> A5   A6   A7   A8
> >> A9   A10  A11  A12
> >> ..   ..   ..   ..
> >> A2   A1   A4   A3
> >> A6   A5   A8   A7
> >> A10  A9   A12  A11
> >> ..   ..   ..   ..
> >>
> >> Notice now how a single disk (eg: sdb1) is coupled to only another
> >> _single_ disk (eg: sda1). In this case, if sdb1 fails, you had to lose
> >> sda1 to have a data loss. Losing sdc1 or sdd1 will _not_ lead to data =
loss.
> >>
> >
> > Thanks for being explicit - it is much easier to answer explicit questi=
ons :-)
> >
> > Yes, they are different.  So the wikipedia article is wrong, or at least
> > misleading.  That is not what the "f2" layout looks like.
> >
> > The md driver does support that layout.  I don't know yet what mdadm wi=
ll
> > call it, but it won't be called "f2".
> >
> > So this change:
> >
> > http://en.wikipedia.org/w/index.php?title=3DNon-standard_RAID_levels&di=
ff=3D501908270&oldid=3D501604733
> >
> > was wrong.
> >
> > NeilBrown
> >
>=20
> Ok, so let recap:
>=20
> 1) FAR layout is the one depicted by SuSe documentation, while the=20
> Wikipedia entry is wrong

Yes.

>=20
> 2) MD _can_ produce a FAR layout as depicted by Wikipedia, but we don't=20
> know how the user-space mdadm tool call it (maybe it is not implemented=20
> yet?)

Yes.  Not implemented yet.

>=20
> 3) There are any reasons why FAR and OFFSET layout scramble data in this=
=20
> manner, coupling any disk with two more disks? It was done for=20
> simplicity, or I am missing something?

It just seemed the easiest thing to do at the time.

>=20
> 4) you confirm that currently we can _not_ create a FAR layout as the=20
> one depicted by wikipedia by no means? What about OFFSET layout?

You certainly can created the FAR layout depicted on wikipedia, e.g. by
binary-editing the metadata on some devices, or writing some code which does
that for you.  It requires flipping one bit in the metadata and updating the
checksum.  You can probably even to it by writing something appropriate into
some sysfs files.
But mdadm cannot do it yet.
Ditto for the new OFFSET layout.
(The old offset layout can be created with "--layout=3Do2").

NeilBrown

--Sig_/Ube/mby/NWUTF8AnYw6Red5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtUAhznsnt1WYoG5AQJNtg//YUstLBQfGpxmIBgOo0oMx3GeDQn3aFiN
2XiSyiOQv7sdpm+5nMo0wpa3ueNO5saTm85n57ZaXRQ365Mdn3mnewifEAFiLcX3
oBOaErAPiON1iW2+qmVqGOCBJLOsoEjOoN5WNChnM7MG6QRlDTvs6RzJNlJixufK
qS9CssITnBV84L3ddHU7RoGpmVCdff8YFBO5hA806odorrMAHBCW2KZfrog801Z/
x7Ru35qe4zXgVjgHbAV0rNhHTGE0YJFXqW7KP1gFIZo0KsHtt0f0o9wMkur/H3S9
RlR/K/BuaWbvbZC88Tv9bveYeMufdIt8c4xaq7wZRDmtj1uf/E1eFaS1AsJQDnH/
qqI9uI5IxWfnYSIAtSttqPYM8W1LZ27k0JxqWIPReSml2R7+xl6gX9P5jtfofrsk
4mbNrtuZI1BF+aP5G/hzrv7tLECcyu5Q60bwPnx3pqeqP5MzqUSXDgyNB+HgZv+g
CPbogqyIzEStVFGIoZitvvCc1UgE2SMlSBDt6UGtNItmrgzlHoPA50dursXWvcuL
SHpY8bxdYb8AqptrjsREOhpT6XfE1e16jA5hnlSu+i/gitEb3dfrXsAPB6yBXshn
d715deuUkNiEZ3eS+SyT5rH1D5XL5/5WYcIwAXIkqHZ8IzY2CVb/0dijpKYsRW7D
WlhhfEdG3nA=
=iJj3
-----END PGP SIGNATURE-----

--Sig_/Ube/mby/NWUTF8AnYw6Red5--
