From: NeilBrown <nfbrown@novell.com>
Subject: Re: Import/recover RAID6 created with SAS2108?
Date: Thu, 10 Mar 2016 18:02:26 +1100
Message-ID: <87d1r2ke7x.fsf@notabene.neil.brown.name>
References: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com> <20160307215026.GA8042@EIS> <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Russell <dpr@aol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 09 2016, Dan Russell wrote:

> # mdadm --create /dev/md1 --assume-clean --level=3D6 --raid-devices=3D24
     --chunk=3D64 --size=3D2929686528

22 * 2929686528 =3D=3D 0xF01B45000
> # cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md1 : active (auto-read-only) raid6 dm-24[23] dm-23[22].....
>       17208463360 blocks super external:/md127/0 level 6, 64k chunk,....

17208463360 =3D=3D 0x401B45000

So the size hasn't just be truncated to to some number of bits, but the
5th byte has changed from 0xF to 0x4.

That is very odd....

Ahhh.. I tried it myself, and used "mdadm -D" to look at the RAID6
array.

  Used Dev Size : 782202880 (745.97 GiB 800.98 GB)

The requested per-device size was
   2929686528 =3D 0xAE9F7800
the size given was
   782202880  =3D 0x2E9F7800

so we lost the msbit there...  Ahhhh.

diff --git a/super-ddf.c b/super-ddf.c
index faaf0a7ca9e0..0e00d17dd169 100644
=2D-- a/super-ddf.c
+++ b/super-ddf.c
@@ -2688,10 +2688,10 @@ static int init_super_ddf_bvd(struct supertype *st,
 		free(vcl);
 		return 0;
 	}
=2D	vc->blocks =3D cpu_to_be64(info->size * 2);
+	vc->blocks =3D cpu_to_be64(size * 2);
 	vc->array_blocks =3D cpu_to_be64(
 		calc_array_size(info->level, info->raid_disks, info->layout,
=2D				info->chunk_size, info->size*2));
+				info->chunk_size, size*2));
 	memset(vc->pad1, 0xff, 8);
 	vc->spare_refs[0] =3D cpu_to_be32(0xffffffff);
 	vc->spare_refs[1] =3D cpu_to_be32(0xffffffff);


That was careless.  "info" is a legacy structure which has a 32bit size
field. So a 64bit size if passed as a separate arg, but this function
used the wrong one :-(

I'll send off a patch.

Thanks for the report - and glad you could get at your data :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4RwCAAoJEDnsnt1WYoG5D3AP/iBEN4Zjrg8LvReg0X71hre9
repPjh3aavGlOG/tZp9tVETXPNa2r7dvoPQhD41FiDPPhHH2BpvVRWmq9xV5gIas
EbnYPZBzploQRjEtERsf5/5ve9GPPiHbIcBa4fZKvuTL+h5wUPNQw/OfgqMHNCsk
LwVtG1Lyg60GXd6aMw+oGVzPcB+Wp/sLDcmEGC6yVdBuwlg1IxlYZvaTb/VW8A5f
g5DHJVtn64M78VcEDfk6L8Sfuq6fUax6FZ8a3yve45N/KLOgVqe8gIupES6c8a5u
n+uFj7DvZEO//Nt+jWDBJnjMNb/YkrKt8kn7rsc4usSFuWyRetjGSTKT+KkffAp6
4HxEkjdAMnuZq44AcTwrf5Z4WLFANPV97QTkvLVB5gSjFZXBTVJZY6WxtB9kTYnH
eD8KV7jiKDHPdU5iedeLiMFfx2myJAR6T4ghXsKCQ01QsPiNbrL/0t/bZkEOshS3
SpDIebSBZAd8Zi0ZqcEnSFYTOV3ZcVXUccKLB1guab1DAOASw+17tCu0bvw+usls
swt6MINFScmji7Nm0hETaaQ99PoR+ETmcie4perKEEU5ncNrDQn7/efkY1UicYoT
WdJN1R53VadOA3hg2YmV6YjTUaZaAtTj8wMKG/HukhrlOmdwoLl9bqzSXt2KgQbD
bHQKy7plPS1uzzjJwaEy
=T+jZ
-----END PGP SIGNATURE-----
--=-=-=--
