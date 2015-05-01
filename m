From: NeilBrown <neilb@suse.de>
Subject: Re: Help needed recovering from raid failure
Date: Fri, 1 May 2015 12:31:14 +1000
Message-ID: <20150501123114.390234c8@notabene.brown>
References: <C17D8E8D-492C-4BDD-904C-75CCA70B2CD9@gmail.com>
	<20150430092741.0dc24c39@notabene.brown>
	<75230D05-6BFF-4906-921A-15175D6567EB@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UkhBG+a3YduO+AAqI8rHA=Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <75230D05-6BFF-4906-921A-15175D6567EB@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter van Es <vanes.peter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/UkhBG+a3YduO+AAqI8rHA=Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 21:25:04 +0200 Peter van Es <vanes.peter@gmail.com> wro=
te:

> Neil,
>=20
> thanks. I followed your instructions (slightly modified as my version of =
mdadm did not support the --data-offset stanza). /dev/sdd was the 3rd drive=
 and I had physically removed the 4th drive from my server.
>=20
> I managed to restart the array. Then I replaced the failing drive, create=
d partitions the same as on /dev/sda and added it to the two arrays.
>=20
> It is now rebuilding for the data array, and will be done in 440 minutes.=
... It appears that I've lost nothing important...

Excellent.

>=20
> One question: I did spot that the Array UUID has changed on the Create co=
mmand. Is there any way of getting it back to the old value ?

Why would you want to?

But I think you can.  Firstly stop the array (so you need to be booted from=
 a
USB or similar) and then

 mdadm --assemble /dev/mdWHATEVER --update=3Duuid --uuid=3Dyour:favo:rite:n=
ums ..list.of.devices..

NeilBrown

>=20
> Peter
>=20
>=20
> >=20
> > Before doing this, double check that the names have changed, so check t=
hat
> >  mdadm --examine /dev/sda2
> > shows
> >>     Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
> >>   Device Role : Active device 0
> >=20
> > (among other info) and  that=20
> >  mdadm --exmaine /dev/sdb2
> > show the same Array UUID and
> >>   Device Role : Active device 1
> >=20
> >=20
> > Then run
> >=20
> > mdadm -C /dev/md1 -l5 -n4 --data-offset=3D262144s --metadata=3D1.2 --as=
sume-clean \
> >  /dev/sda2 /dev/sdb2 missing /dev/sde2
>=20


--Sig_/UkhBG+a3YduO+AAqI8rHA=Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVULlcjnsnt1WYoG5AQIayg//b3mrnr9vdoWZXAOPkcd8HyGMJVLGKW/D
XeDbiqRJbl4avh0JVOt29zDQKFT38ElAvxtEUutr5kvK6Oe2rD4CdiG6NkNs6Kg8
oDCAyRhOLok5b8nknjCy9m/ZBbwTvADsaCIOZ8rCTQ+3HcO1OAygaw01omZRdCnb
ZrGilzulgaW3fpen4SxbJvlF/ESYwlAw8jfIghxb59lPsBYme8XoVfIxBtfYxZI9
qaNpUuToajCrlEvuDqONbxZqnP1XrPtgYLJWX5uV28NJrV7pSZ73JNWxKfzdk+Xw
2sY+jgJrkJ/kABTpzZNdPcGjC1QH/1mkk/AyiAiICkkX99DBeLExWvFc/ZOx9cUi
PSaeKDzjiMx6iNGJBLIQwxfl5mSzdBewimXit28cAnYLSNjIixk07fQ03xkr1iz1
ijYV8emLGU6xfnDM74dPNCKpWSVxAKOPdTsY5qixa1visrplkuAWSmj3RI6Dp82l
Y3dTKYOS1DbutnJ35vHNWIxCnnn2XnPo9PVFedTU23LGV79k6hqtqdmPazk93B4o
1UhPU1R/OzQ8NBRrBO8AHO3la6LiyZUqHi5lF/zWxlkjWwKnsHEkN3irtL/cLvHQ
4zgzqw8VOybbAnLekB9PhGGFdQwlVM4u6VAu6hpUEo9r5+siwz0Vvfs+eGEYO/fR
DXr1UzMnL6s=
=Q5K2
-----END PGP SIGNATURE-----

--Sig_/UkhBG+a3YduO+AAqI8rHA=Y--
