From: NeilBrown <neilb@suse.de>
Subject: Re: how to handle bad sectors in md control areas?
Date: Mon, 3 Mar 2014 08:42:45 +1100
Message-ID: <20140303084245.5b329a9a@notabene.brown>
References: <530DA2DE.9030705@eyal.emu.id.au>
	<530FE7D2.30809@eyal.emu.id.au>
	<20140228105356.GA2003@lazy.lzy>
	<53108DEF.7030904@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u_Tz0FxZNh9qgfCcq1IafTA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53108DEF.7030904@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/u_Tz0FxZNh9qgfCcq1IafTA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 01 Mar 2014 00:23:59 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
wrote:

> Thanks Piergiorgio,
>=20
> I did search before, unsuccessfully. I repeated now with different keywor=
ds and found
> this entry in the kernel wiki
> 	https://raid.wiki.kernel.org/index.php/RAID_superblock_formats
>=20
> It documents the initial fixed fields of the superblock. I still do not k=
now how
> the intent bitmap is laid out. I can see that it starts 4KB into the supe=
rblock:
> 	Internal Bitmap : 8 sectors from superblock
> but did not yet find its size (which I expect depends on the array size).
>=20
> I guess I can calculate it from the sys/block/md127/md items
> 	component_size * 1024 / 'bitmap/chunksize' / 8
> which comes up to 7452 bytes which is still a small fraction of the 128MB=
 header size.
>=20
> What else is there? bad blocks list? Reading an old blog (from Neil) sugg=
ests that it
> is not larger than 32KB (but is only 4KB now), so still "small" in this c=
ontext.
> Don't know where it resides though.
>=20
> I need to understand the full layout of the header and so far I do not se=
e anything that
> says what the area past the initial 16KB is used (is always zero when I i=
nspect it).
> I started a heavy file copy on the raid and watched the header and never =
saw any change.
> I expected to see at least some activity in the bitmap but none encounter=
ed.
>=20
> My simple question is: is it the case that the reserved header space afte=
r 16KB is
> actually still unused in header version 1.2? My bad sector is practically=
 at the end
> of this 128MB area. A trivial question to answer for someone with expert =
knowledge
> of md.
>=20
> Anyone?

The location of the superblock is reported by "mdadm --exmamine".
The size is 4K (Though most of that is unsed).
The location of the bitmap (if present) is reported by "mdadm --examine"
as an offset from the superblock.  It size can be deduced from the output
of "mdadm --examine-bitmap".  Take the number of bits, divide by 8, add 256
and round up to a multiple of 512.  This number is bytes.
The location of the bad-block-log (if present) is reported by "mdadm
--examine" as an offset from the superblocks.  It's size if 4K.
Any other space outside of the data region is currently unused by md.

NeilBrown


--Sig_/u_Tz0FxZNh9qgfCcq1IafTA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUxOl1Tnsnt1WYoG5AQJu7w/+KSy6VwOl7ipsg6mHh8IUZXyjJQwgPqCO
MfI6T2ORryaeunuU+1h09wZmZODu3Jm6UBXcLHUgYThCD3MBLeOktHp/eIuM/yAQ
gSP4XIxSZ4VmevS/+L/JaCS1iTSSLYO07gj+ZTFMbbIKnhvc0EJOJT9CEoUIktSU
kDcPbZGcDRwO97GXmuIKkWnl7z0HLS82wu7JZ6R7W8aRzvKbvQ/wyfUZZNVn8vu0
MjQVYCAsvsTpVLMx6hEBdP3/EoJ/iicnic2qX6TyCT29S3+LQJtCz1eKsqC4Wprz
OHyY4e8Khe0ORjbGDidtjmrBlIlT3S0RNwYrjFVcMRcY69ksIF2A4L2iR/PVRY3K
wI77Ks11cBGUN5u8lrP5Z0bMP/emJXG4c9gd0AhwVyuNfHjoBRPtBnxtldq725EA
ZtSYI/s/XxNqiRKCHW/u/c7aVFUVk445JVfWCwSc4z+NTNN8Vd0GvEhFHCWJfhRJ
Nv042aYvOCuD6fYbWB71PPS5GMiw80K0Q51AjbAgvWzSqPDiaAyv/XIngR+lC2NB
/4/oCp7pMi9mb9gxftcppl434f6I53J+/GleMmjD/ofF456NobVwnlawLrnyiM3z
LXmMZPF8SwtrnMUH24Y1YHeA4+RKxod48tIe4XMLffoa0oaVoSMlU/6Wavmxj/3L
oht+Np64k4U=
=UZJM
-----END PGP SIGNATURE-----

--Sig_/u_Tz0FxZNh9qgfCcq1IafTA--
