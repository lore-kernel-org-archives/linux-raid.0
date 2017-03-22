From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 08:55:46 +1100
Message-ID: <87zigdt1r1.fsf@notabene.neil.brown.name>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 22 2017, Zhilong Liu wrote:

> Hi, Neil;
>
>    Excuse me, according to read 'mdadm/tests/ToTest', I'm a little=20
> confused about "readonly"
> and "readwrite" feature, and I've no idea how to fix it. Thus I report=20
> this question and I'm sorry
> for this long description email.
>
> relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd5217491
>
>    My question: If the array has been set the MD_CLOSING flag, although=20
> hasn't removed the sysfs
> folder because sysfs_remove_group() wasn't invoked, and now, how should=20
> mdadm continue to
> control this 'readonly' array?

MD_CLOSING should only be set for a short period or time to avoid
certain races.  After the operation that set it completes, it should be
cleared.
It looks like this is a bug that was introduced in
Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
when MD_STILL_CLOSED was renamed to MD_CLOSING.

If we already had the tests for readonly/readwrite that you are working
on, we might have caught the bug earlier - so I'm glad you are working
on these tests..

Thanks,
NeilBrown


>    Of course, once we cannot operate the array, the 'readwrite' feature=20
> would be never worked.
>
> Test step:
> # ./mdadm -CR /dev/md0 -b internal -l1 -n2 /dev/loop[0-1] --assume-clean
> # ./mdadm -o /dev/mdX
>
> # in md.h
> enum mddev_flags {
>          MD_ARRAY_FIRST_USE,     /* First use of array, needs=20
> initialization */
>          MD_CLOSING,             /* If set, we are closing the array, do=
=20
> not open it then */
>
> 1. In mdadm tool:
>    the func: Manage_ro(dv->devname, mdfd, -1) would be never invoked=20
> once the array has been
> set 'readonly' before. the open_mddev() cannot get a valid file=20
> descriptor any more. Most of mdadm
> commands would be failure, I have to execute the "echo clear >=20
> /sys/block/mdX/md/array_state".
>
> # refer to mdadm.c
> ... ...
> static int misc_list(struct mddev_dev *devlist,
>                       struct mddev_ident *ident,
>                       char *dump_directory,
>                       struct supertype *ss, struct context *c)
> {
> ... ...
>                  switch(dv->devname[0] =3D=3D '/') {
>                          case 0:
>                                  mdfd =3D open_dev(dv->devname);
>                                  if (mdfd >=3D 0) break;
>                          case 1:
>                                  mdfd =3D open_mddev(dv->devname, 1);
>                  }
>                  if (mdfd>=3D0) {
>                          switch(dv->disposition) {
>                          case 'R':
>                                  c->runstop =3D 1;
>                                  rv |=3D Manage_run(dv->devname, mdfd, c)=
;=20
> break;
>                          case 'S':
>                                  rv |=3D Manage_stop(dv->devname, mdfd,=20
> c->verbose, 0); break;
>                          case 'o':
>                                  rv |=3D Manage_ro(dv->devname, mdfd, 1);=
=20
> break;
>                          case 'w':
>                                  rv |=3D Manage_ro(dv->devname, mdfd, -1)=
;=20
> break;
>                          }
> 2. in md driver:
> For readonly, the code path is:
> ioctl(fd, STOP_ARRAY_RO, NULL)  - - > set_bit(MD_CLOSING, &mddev->flags)=
=20
> - - > md_set_readonly()
>
> cut a piece of code: - -> md_set_readonly() of md.c:
> ... ...
>          if (mddev->pers) {
>                  __md_stop_writes(mddev);
>
>                  err  =3D -ENXIO;
>                  if (mddev->ro=3D=3D1)
>                          goto out;
>                  mddev->ro =3D 1;
>                  set_disk_ro(mddev->gendisk, 1);
>                  clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>                  set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);   - - >=20
> I think it did nothing once readonly has been set.
>                  md_wakeup_thread(mddev->thread);
>                  sysfs_notify_dirent_safe(mddev->sysfs_state);
>                  err =3D 0;
> ... ...
>
> Thanks for your patience,
> -Zhilong

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljS8uIACgkQOeye3VZi
gbmV1Q//b/9JLRuW2hvimbkuX+M/LQfwZQ+SZIveM3nn9OPSF5FPJDcqEih+hmkL
TT4ecr+0jMkDejX32pe8hK9cfBufEPZh3vkknHapD+yQ0bqH78dATascfBVFFwwj
yBs3dBW/rNmYu9jWzMqqVEt3VIv4fFz5mpMDaVc0T79qdH/iDq5vdrefjvZ1ERTh
fWD5r8tuecIl9v8B0q4UgWewJoJ55QNK1kLUMVavnaUjnLvvoIKdn/hz64OI+Fhv
WhYk7xg/11gTGNDpXqcI8OykXbvWKBCztSMY7v9du0zM91Y/5v07ixuvsD2+3psv
jFbL96jkBJTEbOudKtA191BY/xwck5FcFxq56tG5aL6m37Y+gPaSgizlK/CXObjx
WwSr7v+wa/SThrHFHFDm1lKp/UkREn4w1KeY/5Nj8r4ma9P5OaVTRrnAXuMUUqXo
wNzUMEntZO09BRKwEiLKbP4Pr/dv01/W1LYYnTeq3eIiqqvsfW3O609fWv7v0MHN
290u/EN4Jxj0UlUGh7zqnDwpMDIpU7+p8aRGavl0xBKDYpqqU3FM1K4WR+WmxXF0
5diUmCDYsaUrZzFzaR1sGAs9anVe6gId3qPGqbtyZAw8xpjsUlEmdbRkkz/8FsFf
rlxMKYti6WgKzIFe4DHO/vf4sHmtDePhOSCQzVd1QcheaFLPH3A=
=N6s3
-----END PGP SIGNATURE-----
--=-=-=--
