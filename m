From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] md: add mddev->pers to avoid potential NULL pointer dereference
Date: Wed, 03 Apr 2019 08:11:45 +1100
Message-ID: <87lg0s159q.fsf@notabene.neil.brown.name>
References: <20190402062214.136669-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190402062214.136669-1-yuyufen@huawei.com>
Sender: stable-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, axboe@kernel.dk, songliubraving@fb.com
Cc: xni@redhat.com, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02 2019, Yufen Yu wrote:

> When doing re-add, we need to ensure rdev->mddev->pers is not NULL,
> which can avoid potential NULL pointer derefence in fallowing
> add_bound_rdev().
>
> Fixes: a6da4ef85cef ("md: re-add a failed disk")
> Cc: Xiao Ni <xni@redhat.com>
> Cc: NeilBrown <neilb@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

> ---
>  drivers/md/md.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 875b29ba5926..66b6bdf9f364 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2859,8 +2859,10 @@ state_store(struct md_rdev *rdev, const char *buf,=
 size_t len)
>  			err =3D 0;
>  		}
>  	} else if (cmd_match(buf, "re-add")) {
> -		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk =3D=3D -1) &&
> -			rdev->saved_raid_disk >=3D 0) {
> +		if (!rdev->mddev->pers)
> +			err =3D -EINVAL;
> +		else if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk =3D=3D -1)=
 &&
> +				rdev->saved_raid_disk >=3D 0) {
>  			/* clear_bit is performed _after_ all the devices
>  			 * have their local Faulty bit cleared. If any writes
>  			 * happen in the meantime in the local node, they
> --=20
> 2.16.2.dirty

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlyj0BEACgkQOeye3VZi
gbnQ1A/9HQNw48wGxwOcbv8n1ovTx8ma2Ew0n1fyu2Zms7RdpMjlpR6GxDnB9LTN
Hc+k4k88ctn2oCVPztbipXtSoVk8/5RaAOK8ZvLlOf2dzhO3sZZuYTjqw8JDVDGp
vk2dQRe2ZKhpIzNifUuZ2ypbaPG7QvBVIRdI+zE1BXDrA8SUfW8ubLMz04m0f/0s
JBMDzBBLkpO202P9nYzy2nCeiQ4nkoQCyEN7A7LADr20hMMS18C/ERNNoU0Gcm3M
a2KT26RN7AH9xRHcV2zOvJgc+lh+yU4UKIHaG31itYmhMz8qeD1+bn+fMnQcxWPi
2K9tADwM1GtGUzgT3EE7Fc0L6TRgMzG3FpFUX4XK+lAZ1BIWcFhj65cRerieNamb
qa+LpHAkCDGvKL8Qwl5F1xamhpJbzq2lqE4/GByDQS73YtTzY8ecugMsLiCUWw1I
pNLL4+slZ9zbAuHtiS+OrFjZNo1FiMEt6II4DHETxByQAFTLQvtTp/FenDe5pLtg
dXVUp7SxCDtTswhfxiWMQLVSKLOvuOIA6WnTvJL0AE3JKOR6RWdkbwQbFJlr3emN
6gzW/8YsIsQnxbKojFk34TBgQIXvLBF7wJTwB2hj3Cik5SaEKoHB/+w/G4NkblPZ
KpB/+IGvO/cTsKxVpkWOa89S71baLL8a/kIWnQdbXt/7S4hx4L4=
=yq5Z
-----END PGP SIGNATURE-----
--=-=-=--
