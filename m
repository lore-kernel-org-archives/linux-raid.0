From: NeilBrown <neilb@suse.com>
Subject: [PATCH mdadm] ddf: use 64bit 'size', not 32bit 'info->size' for create.
Date: Thu, 10 Mar 2016 18:06:59 +1100
Message-ID: <87a8m6ke0c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: Dan Russell <dpr@aol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The 'size' field of mdu_disk_info_t is 32bit and should not be used
except for legacy ioctls.  super-ddf got this wrong :-(

This change makes it possible to create ddf arrays which used more than
2TB of each device.

Reported-by: Dan Russell <dpr@aol.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 super-ddf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
=2D-=20
2.7.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4R0TAAoJEDnsnt1WYoG5qYgQAJUYSVa98G0Pd4fIkdIgaxsR
t8q7L14RZy8NpH+2QhXv3PPWY5HFIbnCjv91/VSiWlkiI0jkm2U/jsi5RvxhIkZF
IxaSZbW1p9coeEcARZ1cu2pMJw/pNADQmBf9rTosM5TLm4LfEUHm94+M1Mbjfsj4
p4EXvom8yIoSY+gVe+RNLTEupkZDB0cOSlRhWpcNW8vxo5wujzsqmJYaUK2ryjr+
HqUjWEroCKMHNi78a9NHOmmOT7IBkTA5dXt2LyafIQ1lmiSyMybMk4QBaYPcx+uI
2DHIYeSOaeveotE6u3EvtLPouCnZ7PJTOGNhtkCJ2Dqsk1odo/OSpeyF8FOBhGpp
+nGwTmQCySp9lE9H3/L327DTUPczSWYumSOJ5jB4mk0P+X+3oVhV+UDAAJQx2qP5
aGN8cBpi/qSAMB5s6Kc7LssA8/C5xk1wdxGdCE/c/vIq5Ft/jvU3EMNUip5OTOQp
fYTMWmWApZtQdSqif/VQCvC9HqTa+SJTfaGUX/RgH1adPo+3KWnpO5C3VNWg7NUi
ZfE8Cxpq+Pk66/TMpF0XxU3kUiihXq3lcqp3Rq+0aAinvIHPZfhvk2qYYLc7YoOy
ih3p/nOLRIOQ/+heGgpyb6geWccz9skFZgqHYBKVDdc5xEb8FCxDpp5X1ZSpb3Xt
gN/569SladAaBbAPUk6o
=myRh
-----END PGP SIGNATURE-----
--=-=-=--
