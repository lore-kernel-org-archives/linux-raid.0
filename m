From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 16:04:43 +1000
Message-ID: <20140829160443.3893adaa@notabene.brown>
References: <20140824130939.461501b4@notabene.brown>
	<20140824143944.GC19874@bitfolk.com>
	<20140825103234.GH11855@bitfolk.com>
	<20140825212614.5be558c9@notabene.brown>
	<20140825113402.GF19874@bitfolk.com>
	<20140829135312.5a6e78bc@notabene.brown>
	<20140829040231.GP19874@bitfolk.com>
	<20140829141812.17c35df7@notabene.brown>
	<20140829042618.GQ19874@bitfolk.com>
	<20140829143528.588cf640@notabene.brown>
	<20140829044226.GR19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5b31J=3NHVZHK.IXOPkKf26"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140829044226.GR19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5b31J=3NHVZHK.IXOPkKf26
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Aug 2014 04:42:26 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi Neil,
>=20
> On Fri, Aug 29, 2014 at 02:35:28PM +1000, NeilBrown wrote:
> > On Fri, 29 Aug 2014 04:26:18 +0000 Andy Smith <andy@strugglers.net> wro=
te:
> > > Sorry, still no joy:
> > >=20
> > > # echo 309363696 > /sys/block/md2/md/dev-sda3/size
> > > # cat /sys/block/md2/md/dev-sda3/size
> > > 309363264
> >=20
> > Try use "/bin/echo" so you get an error message.
> > Also try smaller numbers.  Can you write anything larger than what is a=
lready
> > there?  Increasing by 64 (match the 128 sectors that mdadm wants for
> > new_offset) should  be enough.
>=20
> I can't even increase it by 64 from what it is now:
>=20
> # /bin/echo 309363328 > /sys/block/md2/md/dev-sda3/size
> # cat /sys/block/md2/md/dev-sda3/size
> 309363264
>=20
> In fact I can't increase it by 1, and /bin/echo doesn't say why.
>=20

Hmm.... I've obviously been assuming something that was wrong.

So I did some experiments myself....

If you apply the following patch to mdadm, stop the array, and then assemble
with --update=3Ddevicesize, you should then be able to reshape the array to
fewer devices.

This isn't a final solution, I need to think about the whole thing more
carefully.  But it will work for you.

Thanks for your patience.

NeilBrown

diff --git a/super1.c b/super1.c
index 727a08a110e0..efa1042ab47a 100644
--- a/super1.c
+++ b/super1.c
@@ -1251,6 +1251,17 @@ static int update_super1(struct supertype *st, struc=
t mdinfo *info,
 			misc->device_size - __le64_to_cpu(sb->data_offset));
 		printf("Size is %llu\n", (unsigned long long)
 		       __le64_to_cpu(sb->data_size));
+	} else if (strcmp(update, "devicesize") =3D=3D 0 &&
+		   !(__le32_to_cpu(sb->feature_map)&MD_FEATURE_BITMAP_OFFSET) &&
+		   __le64_to_cpu(sb->super_offset) >
+		   __le64_to_cpu(sb->data_offset)) {
+		/* set data_size to device size less data_offset */
+		printf("Size was %llu\n", (unsigned long long)
+		       __le64_to_cpu(sb->data_size));
+		sb->data_size =3D __cpu_to_le64(
+			__le64_to_cpu(sb->super_offset) - __le64_to_cpu(sb->data_offset));
+		printf("Size is %llu\n", (unsigned long long)
+		       __le64_to_cpu(sb->data_size));
 	} else if (strcmp(update, "revert-reshape") =3D=3D 0) {
 		rv =3D -2;
 		if (!(sb->feature_map & __cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE)))

--Sig_/5b31J=3NHVZHK.IXOPkKf26
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAAX+znsnt1WYoG5AQIOqRAAlh2AxWqrPdj74iTHNfD3Vx+KEFtrRWxp
lkZ9uQXcJnZj3IC7mSU0ftEpHUsnFk1tBE4gXDLMaFu91GNytoECCJCO669FemYz
HuOQ1X2NmGlVYI9xt2VSlGBkoCG97G2MyILnj97HKAjqP1EXS/WOugGtLx8vstw7
54RP6F9DkcT5GSbVXt3uUuCKB+7HxAXd+buGLfn6GsN0As3zulmHyUCgF2LRVDQv
hAeLv5c+CSFP0XRDPZtZQKL3mLGd3c+33CaaRACPcEnsuPERaxKMDkdJ7qUMSIER
eKIggj+e3YDalsb7AQcEzI5cmJ0VHHT+bI0LsdwtrzQWtuBAqJAeS+Rv5CNRPsx9
VKpElRWX/NrvP8TP+1R3OpFaslpTqqrQUw/fwgz0rCgc4Pbq1bFlT2sNMvTg3XC9
lOE9iZZXVHqb6JZiQArX+leylQ2NJTVNlr0/PT0aqIniiXF0BeqqEPhWNW9ntPL9
UGe541V0nXwTmCyiDWof3aFlLv4lBK6N4k73v8udkNrvD0fuwYdNV6YvkAxRTUOr
wRRxTRvsGiQAtpLIEJ8pTJAg2KnEfKBzag+Vfyu57MU3idaZ5K1/k7+/mZd4Ho+o
S0I+YFnYeA4Y/+S+g+6H2YJse8CtSaYzg5qdMmZ3/jVjldOyXvy+BHcfLmrAurS9
r2UVEGwu4jM=
=etvo
-----END PGP SIGNATURE-----

--Sig_/5b31J=3NHVZHK.IXOPkKf26--
