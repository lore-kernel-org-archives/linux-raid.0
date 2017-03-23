From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 14:42:38 +1100
Message-ID: <871stobqvl.fsf@notabene.neil.brown.name>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com> <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D32AE2.1030303@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Zhilong Liu <zlliu@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23 2017, Guoqing Jiang wrote:

> On 03/23/2017 05:55 AM, NeilBrown wrote:
>> On Wed, Mar 22 2017, Zhilong Liu wrote:
>>
>>> Hi, Neil;
>>>
>>>     Excuse me, according to read 'mdadm/tests/ToTest', I'm a little
>>> confused about "readonly"
>>> and "readwrite" feature, and I've no idea how to fix it. Thus I report
>>> this question and I'm sorry
>>> for this long description email.
>>>
>>> relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd52174=
91
>>>
>>>     My question: If the array has been set the MD_CLOSING flag, although
>>> hasn't removed the sysfs
>>> folder because sysfs_remove_group() wasn't invoked, and now, how should
>>> mdadm continue to
>>> control this 'readonly' array?
>> MD_CLOSING should only be set for a short period or time to avoid
>> certain races.  After the operation that set it completes, it should be
>> cleared.
>> It looks like this is a bug that was introduced in
>> Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>> when MD_STILL_CLOSED was renamed to MD_CLOSING.
>
> I guess it is because we set MD_CLOSING for STOP_ARRAY_RO cmd, then commit
> af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag") did below changes:
>
> @@ -7075,9 +7073,13 @@ static int md_open(struct block_device *bdev,=20
> fmode_t mode)
>          if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
>                  goto out;
>
> +       if (test_bit(MD_CLOSING, &mddev->flags)) {
> +               mutex_unlock(&mddev->open_mutex);
> +               return -ENODEV;
> +       }
>
> Maybe we need to differentiate "STOP_ARRAY" and "STOP_ARRAY_RO", or=20
> revert above
> changes.
>

No, your missing the point.
What you describe above would change the effect of what MD_CLOSING does.
We don't want to change it.  It is good.
The problem is that when it has finished doing what it needs to do,
we aren't clearing it. That is simply a bug.

So something like this is needed.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7e168ff1ae90..567aba246497 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6934,6 +6934,7 @@ static int md_ioctl(struct block_device *bdev, fmode_=
t mode,
 	void __user *argp =3D (void __user *)arg;
 	struct mddev *mddev =3D NULL;
 	int ro;
+	bool did_set_md_closing =3D false;
=20
 	if (!md_ioctl_valid(cmd))
 		return -ENOTTY;
@@ -7023,7 +7024,9 @@ static int md_ioctl(struct block_device *bdev, fmode_=
t mode,
 			err =3D -EBUSY;
 			goto out;
 		}
+		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
 		set_bit(MD_CLOSING, &mddev->flags);
+		did_set_md_closing =3D true;
 		mutex_unlock(&mddev->open_mutex);
 		sync_blockdev(bdev);
 	}
@@ -7216,6 +7219,8 @@ static int md_ioctl(struct block_device *bdev, fmode_=
t mode,
 		mddev->hold_active =3D 0;
 	mddev_unlock(mddev);
 out:
+	if (did_set_md_closing)
+		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
 #ifdef CONFIG_COMPAT

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljTRC8ACgkQOeye3VZi
gblRPA//V6Ao8wmB1VRbUvULk3469xhtqQljJlg86mK0mQkeR6hLTbOJUEIsNX9B
ROue0Rbj06iaqSjFa+ZgaQ5/zftx+N68MBTA2xAVg2IxrWU3xGe/n6mij1TmaNLJ
OL/IwcDI7X/5A/61qHR4CUWOdTaUKWZcK/P3d5VxR2MFAIQA9WPL/nI8W25mpcpi
eh0XB4aa/fvCrp0X+OCaXmr4c95kMtf+hQ+zNejKqxB3aAUXaWa6wTA2BhRfx7Mo
ihMesqGZamNDRnoDxySFlwp2ZRrTEfH1y/0f2PV+m8vjL7SKi/FnO8CZvRa7Xw7d
GxzRy109ZMHEHJUDxITibzpDgkVJxhDfTxJUgk6YI3HqvQS14KHDuW0c9BKRZuiO
uP22doPqb4QcXmfvr0Atx1JBkE0z+p7b5FfeNuLMkZCEfPuAhRgSc1Z20G0GTedT
TrGLTAcMfEC6o0CfHSH+8k71dQZ0eq+8pokRxo7/aq6FATMwV6XNLGwlKm2Cdgpo
5T3LzsUZmnuKrvUB/nWba5F5AjgKHUrnyXVbSP1FZrAJcEiY/+bF7nbK+TPvawvY
8ElGH13srygZGiWJIjD9fnCYPIwMm6Q+Bd7AUjq+PxitMgmBN+G//g+B6sIDwF0G
kUHg4ZqnjYw+vTT8herI9nUvZW5xB5xmyUfeCqugXKocc07QcOw=
=BV54
-----END PGP SIGNATURE-----
--=-=-=--
