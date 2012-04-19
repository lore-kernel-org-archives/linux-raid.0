From: NeilBrown <neilb@suse.de>
Subject: Re: migrating from metadata 0.9 to 1.0 before growing?
Date: Fri, 20 Apr 2012 07:25:33 +1000
Message-ID: <20120420072533.3d86d288@notabene.brown>
References: <20120224113821.c2b14f48bcf7e6809b2cd3a6@bbaw.de>
	<20120229122906.76d08488@notabene.brown>
	<20120419162043.84e7d3f4ae3ba003bd42e430@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.i213ZT=RrOOlxmzv78tHsK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419162043.84e7d3f4ae3ba003bd42e430@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.i213ZT=RrOOlxmzv78tHsK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 16:20:43 +0200 Lars T=C3=A4uber <taeuber@bbaw.de> wrote:

> Hi Neil,
>=20
> Am Wed, 29 Feb 2012 12:29:06 +1100
> NeilBrown <neilb@suse.de> schrieb:
> > On Fri, 24 Feb 2012 11:38:21 +0100 Lars T=C3=83=E2=82=ACuber <taeuber@b=
baw.de> wrote:
> >=20
> > > Hi there.
> > >=20
> > > I have a RAID6 using disks in an external SATA enclosure.
> > > Now I started to exchange the disks with others twice as big as the o=
nes
> > > the RAID was originally created with.
> > > The RAID uses metadata version 0.9.
> > >=20
> > > Now I'm thinking about switching to format 1.0 this way:
> > >=20
> > > * exchange all disks with the bigger ones piece by piece
> > >   (-f old -r old -a new)
> > > * wait for rebuild of last disk
> > > * recreate RAID with --assume-clean and --metadata 1.0 and the same d=
isks
> > > in the correct order
> > >=20
> > > The --grow shouldn't be necessary this way.
> > > Then I grow the filesystem.
> > >=20
> > > Is this precedure possible without data loss?
> > > Or is there a way a metadata version migration could be done more eas=
ily?
> >=20
> > Yes, this should work.  There is no better way.
>=20
> is it possible to change the chunk size while recreating the array to the=
 new
> default or do I have to stay with the 64kiB chunk size?

You can only change the chunk size by rearranging all the data on the devic=
es.
So you canno simply change if when re-creating.

>=20
> Because changing the chunk size afterwards might not be possible due to t=
he
> new chunk size not fitting in the used device size.
>=20

You might have to reduce the size of the array (and the filesystem on the
array) first, but you should then be able to change the chunksize.

NeilBrown


--Sig_/.i213ZT=RrOOlxmzv78tHsK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5CCzTnsnt1WYoG5AQIkLg//X7y1q66/RU3YEvf9Ri1fZ9JOAt/suzcV
+L2RsHiL28MKxs8dJHxN2iT5llE+9j646Ie64/2eRmsB7+jjqzfxSE2CSwqo0Mvm
PRpTArE9kVTZu5D1GPAj27I4x9+EBvqa40leydQH5GfqAZ/413cDhhLxMpPrunjG
FG48V16co2S6vXT/kuakNfDkgvl0PDmFBaszFvNkN2YgOxlJwVNWne5eUdGRjYCb
/C2Fw1h6DUVTdRT07BvxkvJfkqkWQKcQ2uu8VpxSooylLrAcKkvUjVdPyN9XCOJS
MsTXgJHCosuztBVInQGLKRRdeX3xcBWSHWFcjE0Q8bWrvKiubMdoF/rZ5NQCEo9K
bPMuYwIk5HoWEf9EVBlTAFSKsGxez9ZCJJTgLzu0FTSEjSKKiwz4mVUscBSIzODm
B77LfAYMXoS72Dc33XFSUrB2/uFA7CVpVCqjXra23DTkjJHUchteWHfFvnO8k3TV
2bdQf6ZxdOCr+8xlAjPlkut18DSlhZIGe0eBUCthdkR+8GDc8iv8ZzgTUL+yj3E3
EHlSocwnu82XvUZlZpmS/fbBbYpt8pi79yA4tAvQdETxkZX8PQZZUUgPS6DYPVog
+i9uN/hTipUXysvdpGbOSGCtqxW/pIrpAUkZ5yUjQrh7SOlAMlgmQg35LfsMotZj
dNfx4s3pL/M=
=snL7
-----END PGP SIGNATURE-----

--Sig_/.i213ZT=RrOOlxmzv78tHsK--
