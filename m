From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: properly lock and unlock in rdev_attr_store()
Date: Mon, 29 Apr 2019 08:47:02 +1000
Message-ID: <877ebd693t.fsf@notabene.neil.brown.name>
References: <20190428104041.11262-1-lukas.bulwahn@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190428104041.11262-1-lukas.bulwahn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Himanshu Jha <himanshujha199639@gmail.com>
Cc: clang-built-linux@googlegroups.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 28 2019, Lukas Bulwahn wrote:

> rdev_attr_store() should lock and unlock mddev->reconfig_mutex in a
> balanced way with mddev_lock() and mddev_unlock().

It does.

>
> But when rdev->mddev is NULL, rdev_attr_store() would try to unlock
> without locking before. Resolve this locking issue..

This is incorrect.

>
> This locking issue was detected with Clang Thread Safety Analyser:

Either the Clang Thread Safety Analyser is broken, or you used it
incorrectly.

>
> drivers/md/md.c:3393:3: warning: releasing mutex 'mddev->reconfig_mutex' =
that was not held [-Wthread-safety-analysis]
>                 mddev_unlock(mddev);
>                 ^
>
> This warning was reported after annotating mutex functions and
> mddev_lock() and mddev_unlock().
>
> Fixes: 27c529bb8e90 ("md: lock access to rdev attributes properly")
> Link: https://groups.google.com/d/topic/clang-built-linux/CvBiiQLB0H4/dis=
cussion
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Arnd, Neil, here a proposal to fix lock and unlocking asymmetry.
>
> I quite sure that if mddev is NULL, it should just return.

If mddev is NULL, the code does return (with -EBUSY).  All you've done
is change things so it returns from a different part of the code.  You
haven't changed the behaviour at all.

>
> I am still puzzled if the return value from mddev_lock() should be really
> return by rdev_attr_store() when it is not 0. But that was the behaviour
> before, so I will keep it that way.

Certainly it should. mddev_lock() either returns 0 to indicate success
or -EINTR if it received a signal.
If it was interrupted by a signal, then rdev_attr_store() should return
=2DEINTR as well.

As Arnd tried to explain, the only possible problem here is that the C
compiler is allowed to assume that rdev->mddev never changes value, so
in
   rv =3D mddev ? mddev_lock(mddev) : =3DEBUSY

it could load rdev->mddev, test if it is NULL, then load it again and
pass that value to mddev_lock() - the new value might be NULL which
would cause problems.

This could be fixed by changing

	struct mddev *mddev =3D rdev->mddev;
to
	struct mddev *mddev =3D READ_ONCE(rdev->mddev);

That is the only change that might be useful here.

NeilBrown


>
>  drivers/md/md.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 05ffffb8b769..a9735d8f1e70 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3384,7 +3384,9 @@ rdev_attr_store(struct kobject *kobj, struct attrib=
ute *attr,
>  		return -EIO;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> -	rv =3D mddev ? mddev_lock(mddev): -EBUSY;
> +	if (!mddev)
> +		return -EBUSY;
> +	rv =3D mddev_lock(mddev);
>  	if (!rv) {
>  		if (rdev->mddev =3D=3D NULL)
>  			rv =3D -EBUSY;
> --=20
> 2.17.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlzGLWYACgkQOeye3VZi
gbkBWw//VvIj0hYlq+pmpcJXle/rFe9qJHKo9IgWyI3BO8tZ/T4qaUQN3YFBvXtd
OxduNlDF3F+T3o/0GzQXPHCHxq/WHHR9Ju/m9DpZoa7jFAGzdSaZYoJENM4dkZhj
4CBqZ87ZDw3zU2YNrOYSMioU9W1yTKuVO3GNR917sMNDxJZyN/0gRh/as7UckBgz
M/Ki41vyLUDdJKS4wx2nJKl9A1nULqknO4dfQlxIybSj68LtGHeTpJzn6bAKFTWa
YKI9AcsBz0fonw/I6MRunP3yXy4DI7IqW7jY0ZY+5hyETw4knmlQl+vqa6Sh9AIC
UPTkypaeWWTJ1jN/mFPR8gWv78dUUrIpDLGDghYWwLIivHC0Q9qCvk75KqkPF1Ii
fQg/GGNAtdp0cAhWGiPc0o3XC7Q1+gkPsdDdxHKMq2L0HxKLWEKPFwV6D2w8CTTB
HIgXFbfcb7uQGfByjLQfBT/O90D5v7qDrlRlNcw0sF6nFzBaAJJCSX86fWIPrSo2
OQ37gahhy9Af1oC19hXeM37sny7WMRsFTfM4AJ8rNuXQBdjKAcrM9RO0WSFeeheR
ZQoK4SooN6pBits+PxKB1QDc/xCC+AiV64TQ5tqCiKPJ7uw1Uuz8kmpsdPVZ0H0E
G8XdolzszybZ3AoQ6yai0ls0eHeCC/R7rbpfhhg3D/BVJCZaIZU=
=tVLb
-----END PGP SIGNATURE-----
--=-=-=--
