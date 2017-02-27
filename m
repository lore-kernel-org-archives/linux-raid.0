From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component devices
Date: Mon, 27 Feb 2017 16:55:56 +1100
Message-ID: <87y3wsp47n.fsf@notabene.neil.brown.name>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170224040816.41f2f372.ian_bruce@mail.ru>
Sender: linux-raid-owner@vger.kernel.org
To: ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24 2017, ian_bruce@mail.ru wrote:

> When assembling non-metadata arrays ("mdadm --build"), the in-kernel
> superblock apparently defaults to the MD-RAID v0.90 type. This imposes a
> maximum of 27 component block devices, presumably as well as limits on
> device size.
>
> mdadm does not allow you to override this default, by specifying the
> v1.2 superblock. It is not clear whether mdadm tells the kernel to use
> the v0.90 superblock, or the kernel assumes this by itself. One or other
> of them should be fixed; there does not appear to be any reason why the
> v1.2 superblock should not be the default in this case.

Can you see if this change improves the behavior for you?

NeilBrown


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


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlizv2wACgkQOeye3VZi
gbkuVw/7BujPVlaJSLiJnPA6HTlCr6qPOK3j+FH22MJHhygF116HUyObh37bWKuM
NBGjgza22XEialxu+mqL2iEKPStAIavc2aUbCapfskQAQTi9netCORk3uc70gosu
RUTuqi79F03WPOgFjvJK8q38RHd6NNcXpUeFenO4Q/wZ0y3YmDGgkOcDGe/15jVB
Zd9GHQ7790pvJGqEWwcBc/Hfk0LptjlbG04CaC1iVp94Vokc6CH5BfPAakQyJMPz
fwVlxXVCwn8Eqs7S5KlfwkN3KkyyKzL0VJPHVrmUegR1fN9jG/OSL9bfLAi0//UI
54E8gdol0VUSMT/x/mLPNTK57WSnHHH5PM3pP40Bd8CrqJtvblFiIPmUqpvGBBLF
A6We2L+KWbSJkbhULIKNKQ+pQo5tNyXc0cYFNUcBtFdYL4GXD3qs8wnqEupwqGpj
IHI3lTFdEVbXUXvmTtdODtCZFpq59fr1xsScTkBcUqdv9M2hISlaqwEY0PzA6jZp
Mtnc5jaWe4h+gqx8zde2K/DAm7uwJ3XYqp6a1sZWDbkO+srWmPlJ1IV/iOPrl666
oFPlKqUzsPulBaQuI8BmG5kjuxo8zrDgPVogkJkNLMKLa2OW5shdZ0vdGUZHlA9u
HRV0N/Tj2ox1QtZhXZ9nYgvLC7nyoY1Oo5oyUB50c4Y6ISdmKkw=
=yINy
-----END PGP SIGNATURE-----
--=-=-=--
