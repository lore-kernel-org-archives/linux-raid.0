From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: don't impose the MD_SB_DISKS limit on arrays without metadata.
Date: Wed, 01 Mar 2017 07:31:28 +1100
Message-ID: <87k28aoy5b.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, ian_bruce@mail.ru
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


These arrays, created with "mdadm --build" don't benefit from a limit.
The default will be used, which is '0' and is interpreted as "don't
impose a limit".

Reported-by: ian_bruce@mail.ru
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ba485dcf1064..e0ac7f5a8e68 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6464,9 +6464,8 @@ static int set_array_info(struct mddev *mddev, mdu_ar=
ray_info_t *info)
 	mddev->layout        =3D info->layout;
 	mddev->chunk_sectors =3D info->chunk_size >> 9;
=20
=2D	mddev->max_disks     =3D MD_SB_DISKS;
=2D
 	if (mddev->persistent) {
+		mddev->max_disks     =3D MD_SB_DISKS;
 		mddev->flags         =3D 0;
 		mddev->sb_flags         =3D 0;
 	}
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli13iAACgkQOeye3VZi
gbl69A//SbwV8/5X+u5KeXl3p8k9w9SMt8vfzolgAQXGHSjTh9v3+k8c/blheAUb
MRB4s9KELFeiMfAOdf8StQAqvlf+4r+2zt9I3o/6e1oxvCOp5cPop9B588ojjnm5
gzRBGVZ3yiuxNH/3P+q9d3N2Gw83Dz5YcAPQuNvS5SYi3IRAEv8TfUbDFWI2uyyF
ZgzIFYAegNde/eSQco6mMmheCGSCXavKidKvqsze0pmZ8a/vnLfoackEpSRYf4J8
/fc7NvCDdE0VNBC2oJZlJILiyFPq2z19mR/RZ2/LRwzS4iRbJKkXi6JjhOfdb4qz
VzlfrKGnn8DrvRTg8WZLoU13tPVNIL1ZF8CCJbqp+cIdGXpEolmgjzgfhMGWzwAc
OUezC9CX1hTZzVkxQBb9cFgK3jG3ciK+FTqPuBETK8AuGimsprmvh/6zorRuXDjj
42jfxmJvfhj0oYWEUW5VFygN+jT40ljsN9BhH0FILFRzv1Ri29mFyqw83qrzQ2tS
96FX3o5OGHYAOoZKV/IqSqPrb5gyltZPiUH57VZ5CtJfuVF77npTF+4VOx7A9Mlm
xR0XBzwzZ42TqPZZcmjf9P+GeNXomkaMHHKMj9ZomjRCe84E7Jb1cSJvAjzvLqpb
WB4TH0BQxXwmfzHIL9d8TO9TxI12+Fob4hB30m1qoU0kA/1Bclw=
=XKX5
-----END PGP SIGNATURE-----
--=-=-=--
