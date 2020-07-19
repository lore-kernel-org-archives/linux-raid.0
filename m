From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH v4 2/2] md-cluster: fix rmmod issue when md_cluster convert bitmap to none
Date: Mon, 20 Jul 2020 09:26:36 +1000
Message-ID: <87h7u3w0gj.fsf@notabene.neil.brown.name>
References: <1595156920-31427-1-git-send-email-heming.zhao@suse.com> <1595156920-31427-3-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595156920-31427-3-git-send-email-heming.zhao@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 19 2020, Zhao Heming wrote:

> update_array_info misses calling module_put when removing cluster bitmap.
>
> steps to reproduce:
> ```
> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
> /dev/sdb
> mdadm: array /dev/md0 started.
> node1 # lsmod | egrep "dlm|md_|raid1"
> md_cluster             28672  1
> dlm                   212992  14 md_cluster
> configfs               57344  2 dlm
> raid1                  53248  1
> md_mod                176128  2 raid1,md_cluster
> node1 # mdadm -G /dev/md0 -b none
> node1 # lsmod | egrep "dlm|md_|raid1"
> md_cluster             28672  1 <=3D=3D should be zero
> dlm                   212992  9 md_cluster
> configfs               57344  2 dlm
> raid1                  53248  1
> md_mod                176128  2 raid1,md_cluster
> node1 # mdadm -G /dev/md0 -b clustered
> node1 # lsmod | egrep "dlm|md_|raid1"
> md_cluster             28672  2 <=3D=3D increase
> dlm                   212992  14 md_cluster
> configfs               57344  2 dlm
> raid1                  53248  1
> md_mod                176128  2 raid1,md_cluster
> node1 # mdadm -G /dev/md0 -b none
> node1 # mdadm -G /dev/md0 -b clustered
> node1 # lsmod | egrep "dlm|md_|raid1"
> md_cluster             28672  3 <=3D=3D increase
> dlm                   212992  14 md_cluster
> configfs               57344  2 dlm
> raid1                  53248  1
> md_mod                176128  2 raid1,md_cluster
> ```
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e20f1d5a5261..ca791387e54d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7363,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>=20=20
>  				mddev->bitmap_info.nodes =3D 0;
>  				md_cluster_ops->leave(mddev);
> +				module_put(md_cluster_mod);
>  				mddev->safemode_delay =3D DEFAULT_SAFEMODE_DELAY;

I would make this a call to "md_cluster_stop()", and move the reset of
=2D>safemode_delay" in there, but either way this is correct and needed.

  Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


>  			}
>  			mddev_suspend(mddev);
> --=20
> 2.25.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8U1qwACgkQOeye3VZi
gbnuRQ//d5Kmw6dTs43Wrkv8hznXb1CPOtUnWOjEQ99YgLCEJu5sxZQIYKVuqyDg
QTln7AYSUhgqGwllQPQyx7FGllKVHdNIOrJLl9/Jfjf1/3okP20BU9C8HNuBFvfN
DN0KOYkpZsSyXtNvGToRzMLS5rOwrNOZaz4q9NMggppKfdY2/Qya0qYa9mXf+Qlg
gHJx5eCw6yfJExMRKhWdLeYG1h5TOUyHSJ4JhGhYwWg5AcDgOFeCztFGS5XCayZj
loLjUSdj6VHBgW/Q+SO6WB9fj3AvhqAqyVDukaMCgSmNRvBxwM1MZCl6yzcPys9D
1JZUWSlwdUDtNOmpoMW6jEcIkMoGmN5PQRjYvfq44vq8iw+OZcL8Eg1vcLyB+wGB
hoU/Nviez5R48wirQa5AGEHKcbAlaXZyDcKCzCS9zOUFzEwkoI5lEAkyLNX3/smM
/X5QAmki1087yGansDPpCbvtVevmhSW1Lxw7PLCT0ipatA8AyQ6fZ570FUxxjiLV
E6kfo70tMsCmiOwsMzWsQMyk7tryuEKTqdCVe77RNH0zbxNcnQM8UyNl5LwOeV0Z
GWPFQ5lFL+bTxt4zTKSCoI9hCNNKyqYaRWvFLiS1Szsa9xJjdmSVywGC1yN7dkEy
qQXLlJtJvbvB8Y8cWXoBD8Wsjb4rZ3DfJLwAciPZGgwtRaq5rvg=
=WaNu
-----END PGP SIGNATURE-----
--=-=-=--
