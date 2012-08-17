From: NeilBrown <neilb@suse.de>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Fri, 17 Aug 2012 10:39:26 +1000
Message-ID: <20120817103926.78a37994@notabene.brown>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
	<CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com>
	<20120507105458.6411b0cf@notabene.brown>
	<201208161728.13814.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eiBpChiri6MJ7MYvrOUhZam"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208161728.13814.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eiBpChiri6MJ7MYvrOUhZam
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Aug 2012 17:28:13 -0600 Thomas Fjellstrom <thomas@fjellstrom.ca>
wrote:

> On Sun May 6, 2012, NeilBrown wrote:
> > On Mon, 7 May 2012 00:32:35 +0000 Gar=F0ar Arnarsson <gardar@giraffi.ne=
t>=20
> wrote:
> >=20
> > > That's an excellent idea, I was going to add another disk for extra s=
pace
> > > right after migrating to raid6.
> > >=20
> > > Just to be clear, I'll be running the normalize attribute just once to
> > > straighten the array out right? Or will I have to do it for every ext=
ra
> > > drive I add in the future?
> >=20
> > Just once.
> >=20
> > >=20
> > > And what are the N+1 you mention in --raid-devices=3DN+1
> >=20
> > By "N+1" I just meant "1 more than the number of devices currently in t=
he
> > array".
> >=20
> > If you have both new devices ready to go, you just do a single reshape
> > operation that converts to RAID6 and adds more space.  This does not ne=
ed a
> > backup file and is probably the best approach.
> >=20
> > If you currently have a 10-drive RAID5 and want a 12-drive RAID6, then
> >=20
> >  mdadm --grow /dev/md0 --raid-devices=3D12 --level=3D6
> >=20
> > is what you want.
>=20
> I apologize for bringing back a long dead thread, but I've been wondering=
 if=20
> mdadm does the grow op in this case, in one step? Or does it internally d=
o=20
> each step separately, doing a reshape with each one?
>=20
> I've currently got a 7x1TB disk raid5, and have a couple more disks to ad=
d and=20
> I was planning on moving to raid6. I'm hoping to reduce the amount of tim=
e the=20
> array is "reshaping" because I'm a bit paranoid that my bad luck with har=
d=20
> drives will decide to hit right then and there.
>=20

If you change the level and the number of devices in the one command, and
there are already enough spares present to satisfy the requirements of the
new size, then it will only perform a single reshape operation which will u=
se
the minimal amount of time.

NeilBrown


--Sig_/eiBpChiri6MJ7MYvrOUhZam
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC2Svjnsnt1WYoG5AQIezw//XBTqbCuHKOw+g51e1++DbU3u1qrayLzO
rbwwkcw5dj5M3Rkeb08RJs8GLDRBPGhdRdnY9EN49EdCz2Y/q1iIvSSap8EI5LRu
ftLNfTiy26yP799opy2lw30Wzjfi9mpL6Rc+8/SXoVDT1M4CbjuHzuaW7sH+V8xF
0w3+t0bcbIRpvcGxn+Xra+ijjPIKXGL5A0vavkZk3sKKf/e2KTdh+P1grAYeVmNr
n/wXEKuUW16nlbJpdsHBCSgSLeIXLa7bjN1NS9umn/60DMQ8J7SwvuU97Vqj7HAn
8k/u2J23S/+4eTifwvnP272V2Cp+0wS71MlW/0eU2T9CAVVUnRvYf2tKCzdUWEik
a+NPAomLdZjCCCGZD6dGfa4vM3C+ehu9/D4Wfupov3/GbNleZIs71xRoKxSbikWd
vTG6v8ODqBXuUfn9qiNDhjEvdTWEWseFSJ0+tp/T4Srw1U1ncbu8vvL+NnpmI6xM
5RVe+ZTtKzEj0fI9XAIYHEfzNY/VFpgD6t8ck6hhs8Q3Zw4/5uNE72+2BMXoBG3V
O4QEx7NJUzDUhQA8IcsIJ2dYsmmFNJ9Zte9gKfPb0jcgMIL7/TogsUQ2QO5VyxGn
uLY1lfQFXXExqGArpbgf99oHvagO+J47zp/dDY50d7p2FaZJcAOTatnJgXkqKHpG
2htKGrqFx7k=
=w/hV
-----END PGP SIGNATURE-----

--Sig_/eiBpChiri6MJ7MYvrOUhZam--
