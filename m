From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH 03/23] init: remove the bstat helper
Date: Thu, 16 Jul 2020 09:14:28 +1000
Message-ID: <87h7u8xtez.fsf@notabene.neil.brown.name>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-4-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14 2020, Christoph Hellwig wrote:

> The only caller of the bstat function becomes cleaner and simpler when
> open coding the function.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Song Liu <song@kernel.org>

Reviewed-by: NeilBrown <neilb@suse.de>

Nice!

NeilBrown

> ---
>  init/do_mounts.h    | 10 ----------
>  init/do_mounts_md.c |  8 ++++----
>  2 files changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/init/do_mounts.h b/init/do_mounts.h
> index 0bb0806de4ce2c..7513d1c14d13fe 100644
> --- a/init/do_mounts.h
> +++ b/init/do_mounts.h
> @@ -20,16 +20,6 @@ static inline int create_dev(char *name, dev_t dev)
>  	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
>  }
>=20=20
> -static inline u32 bstat(char *name)
> -{
> -	struct kstat stat;
> -	if (vfs_stat(name, &stat) !=3D 0)
> -		return 0;
> -	if (!S_ISBLK(stat.mode))
> -		return 0;
> -	return stat.rdev;
> -}
> -
>  #ifdef CONFIG_BLK_DEV_RAM
>=20=20
>  int __init rd_load_disk(int n);
> diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
> index b84031528dd446..359363e85ccd0b 100644
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -138,9 +138,9 @@ static void __init md_setup_drive(void)
>  			dev =3D MKDEV(MD_MAJOR, minor);
>  		create_dev(name, dev);
>  		for (i =3D 0; i < MD_SB_DISKS && devname !=3D NULL; i++) {
> +			struct kstat stat;
>  			char *p;
>  			char comp_name[64];
> -			u32 rdev;
>=20=20
>  			p =3D strchr(devname, ',');
>  			if (p)
> @@ -150,9 +150,9 @@ static void __init md_setup_drive(void)
>  			if (strncmp(devname, "/dev/", 5) =3D=3D 0)
>  				devname +=3D 5;
>  			snprintf(comp_name, 63, "/dev/%s", devname);
> -			rdev =3D bstat(comp_name);
> -			if (rdev)
> -				dev =3D new_decode_dev(rdev);
> +			if (vfs_stat(comp_name, &stat) =3D=3D 0 &&
> +			    S_ISBLK(stat.mode))
> +				dev =3D new_decode_dev(stat.rdev);
>  			if (!dev) {
>  				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
>  				break;
> --=20
> 2.27.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8PjdQACgkQOeye3VZi
gbnOgBAAg5tYGuw1TVkG+Rso30FARvah0yhwFOfZKWKl4XLVRV9xmx+b6bklDYL9
WqtyGlYlvwkyoIhMw+SPMwaswAXHj+g/IB657EdpcZrWsHJ2M0pPwpLgFLmScPL5
XCx93C0ZEVbbL+TvBh/SVssGpvbo6XCH2YdYNqP46AwSf8iEBDK/6zKW8yXVynzO
F7C2DmXOchXEhitgHtx15XZPJ1M1rgAasTBgbZGIz0HmFRDjR3M8Q/uMELNBpQlp
nl/rcoaZPUmubi1n9yDHyyNE5RaV9v1o/u0JuIt6gU6N64Nd1LyVJWMQVueItRDN
t9zjq2UNqC7vvclHvmTAZPzIXZnqANV2Dniiz5d+iEhFnlnlMI8Oy+3y2vJiMRzL
y1AHv53G3UgA1SLLQtGZYNynCRtg3QAG3z6ljNFiNgq/VcJou4dJFjyO8TB6RqWo
FGvGU1UxmR5N5S92vj/ZPq09iC97OAQoarS6/zbwW2PY+xDYc9OyWSS8C2Twoaqa
vjnUZS9Qk9mTARyX/69Qhn8QGiGyHd04BYSsLZNJ71ayAgIocC7vJNMR0NrKtYFf
JgCRbAvOzDGOFkdcRhJXaJv0PTvJBW278LS4E4Ithim9aFrXh1Az4zxN/S4OP+Ch
zXqUPaG3yN2pHC+5hnFB3bxWYqRkkolTXIPwHe7W9JpHrpcR4ik=
=EyQS
-----END PGP SIGNATURE-----
--=-=-=--
