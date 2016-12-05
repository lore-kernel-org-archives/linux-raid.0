From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: fix refcount problem on mddev when stopping array.
Date: Mon, 05 Dec 2016 16:40:50 +1100
Message-ID: <87h96j53x9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, Marc Smith <marc.smith@mcc.edu>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


md_open() gets a counted reference on an mddev using mddev_find().
If it ends up returning an error, it must drop this reference.

There are two error paths where the reference is not dropped.
One only happens if the process is signalled and an awkward time,
which is quite unlikely.
The other was introduced recently in commit af8d8e6f0.

Change the code to ensure the drop the reference when returning an error,
and make it harded to re-introduce this sort of bug in the future.

Reported-by: Marc Smith <marc.smith@mcc.edu>
Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Hi Shaohua,
 as this bug was introduced in v4.9-rc1, it would be great if this
 patch could get to Linus before v4.9-final comes out (on Sunday?).

Thanks,
NeilBrown


 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2089d46b0eb8..d1a291ac2a75 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7092,7 +7092,8 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
=20
 	if (test_bit(MD_CLOSING, &mddev->flags)) {
 		mutex_unlock(&mddev->open_mutex);
=2D		return -ENODEV;
+		err =3D -ENODEV;
+		goto out;
 	}
=20
 	err =3D 0;
@@ -7101,6 +7102,8 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
=20
 	check_disk_change(bdev);
  out:
+	if (err)
+		mddev_put(mddev);
 	return err;
 }
=20
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhE/eIACgkQOeye3VZi
gbn8XRAApnBEMyQbnLKVsM+UHF2hBr4rE2hd+7J+iRmowLQKQORBAr8BIMaDmF+6
HRkJ93cRwKSakv17csGVPprVQDs2Ml3twlaDnZaRKcE89dLXnbTif42ysI9wae1W
Jq7RzS7c+vLMjP1zkpSB64DkD51uaMmUuNFQi2zxl0XkngFs8phsqa8dbt4mM+xg
6cyAcTVIxLuPppSZBSCoT4tkd7pGa7xC2CLLAo1oEa/lWymUxMH5EhB/UBN3Z7bR
abKgzreMRq/RZiC2/GoJaPCX5j+4aIFP+y2HCLOkCUU/G/kAxOWSZKkHHYGAxMbj
BduzDtNgM5xSA+BbY6WCdyPcIaBxB92xsz6/QfZrWLgCZcWqDU6qkARpd/SxVTpY
oktnlrv5Ezty6Yq0t2qlS6J41vSi6e6X+K6woGgm0a14FWfxyIosHEn8OuWjeOY6
O3qHtF/CkgD3z5K8BHfXkAxmxn1d2zyb0+S59spxj2Hpw69UiminMjDt9P/xHdlk
JORnU6j618HtPbPWHeZw7q0JJUwu+AtvfMucM6P4vb6t2ubFj76/1e1p9WoY426g
fq48vgT2UrTj+SgS4dhn1e5oUDR2Dd88QrmbO5ULrtI4UGr8StxtG3+7JRqnQXtU
JzGdGpiCWyWLkDsXWeQw4wL8X+WWQJTVRWK2I6+jkhdQhZF7tLs=
=Wmk2
-----END PGP SIGNATURE-----
--=-=-=--
