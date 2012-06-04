From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md:Fix name of raid thread when raid takeovered
Date: Mon, 4 Jun 2012 13:48:56 +1000
Message-ID: <20120604134856.00aecfa1@notabene.brown>
References: <201205311541185787676@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7y0T0oOefidVWwS86gI7Hiv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205311541185787676@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/7y0T0oOefidVWwS86gI7Hiv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2012 15:41:22 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> When raid takeovered, it used old personality to set task->comm.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1c2f904..93e20ea 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -32,6 +32,7 @@
>     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
> =20
> +#include <linux/sched.h>
>  #include <linux/kthread.h>
>  #include <linux/blkdev.h>
>  #include <linux/sysctl.h>
> @@ -3513,6 +3514,7 @@ level_store(struct mddev *mddev, const char *buf, s=
ize_t len)
>  	long level;
>  	void *priv;
>  	struct md_rdev *rdev;
> +	char *tmp;
> =20
>  	if (mddev->pers =3D=3D NULL) {
>  		if (len =3D=3D 0)
> @@ -3674,6 +3676,19 @@ level_store(struct mddev *mddev, const char *buf, =
size_t len)
>  		del_timer_sync(&mddev->safemode_timer);
>  	}
>  	pers->run(mddev);
> +	/*
> +	 * when raid takeover using old personality,so mddev->thread->tsk
> +	 * name is wrong.
> +	 * if kzalloc error, only using wrong name.
> +	 */
> +	len =3D strlen(mdname(mddev)) + strlen(mddev->pers->name);
> +	tmp =3D kzalloc(len + 2, GFP_KERNEL);
> +	if (tmp) {
> +		sprintf(tmp, "%s_%s", mdname(mddev), mddev->pers->name);
> +		set_task_comm(mddev->thread->tsk, tmp);
> +		kfree(tmp);
> +	}
> +
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  	mddev_resume(mddev);
>  	sysfs_notify(&mddev->kobj, NULL, "level");

Thanks.  However:

 1/ as a task name is limited to TASK_COMM_LEN, there is little point using
    kzalloc.  Just declare a local variable of that size.
 2/ No all levels have a thread.  You should check that mddev->thread is not
    NULL.

If you resubmit with those fixes I'll apply the patch.

Thanks,
NeilBrown


--Sig_/7y0T0oOefidVWwS86gI7Hiv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8wwKDnsnt1WYoG5AQLUqg/9HErBYo8BP1oBS8HoKpI4bUXhS+G7Ysha
ueJIW4hUdhHutH93CgScGmhv4TyZBs7Dgt37JKUzGm368pYvh2BzzfBg/n1SsHm3
k1U1/ntYHJx2ouQy1TKQLPBHeIMC3zBZPy//h1s59alxi75Uyf8aYgilbvpFZcpE
6YzoAe41D1Yh12K6rqqS0UBszEi2qt/g14XxHxpqWl2hta1lFnDfEMRwIl1Kxuyy
VXLFlPLQNRY3ruKwIg8+pE1doEdZxgFWIXah2pYmQjisA0wQ/QliYyJsZwzmcmuQ
Msou4YvmmGB3GONbB6tW5mJsKki1RZALcUrAZrrRMnT15gaiDj6PNZqSTJ0C0T4X
PZR7fStfYw1cZDWqFrT99yE+AckhGLXgeaNEP0ofWHHnNn6cvOSg0bnVxvdEARV3
SW5an/YbVZlUsYroZNo5WyvoYd5edDYZsYUvE2hUR2agN7oe3kzKAD2ccp0rU5Da
VBHVlhobJ1Ve67v8eJ30YfgFypQ7g9BSW3iRiTOJQ5U8fLJND9fNVssrAUPNmCAK
oS0e9rtX9Xza1nnET7zlqDdkUEkDsWLevR+UPFtE7Sy+AaGqNU15qB+ZuXNaJAcU
4zRShlMPInJNU+CZUnWf9aSEa5BinEXG2Kbx7gT9SXVsbzVHCzVLu0dtDg9gKfcP
sVJJ9TP2nqs=
=biI9
-----END PGP SIGNATURE-----

--Sig_/7y0T0oOefidVWwS86gI7Hiv--
