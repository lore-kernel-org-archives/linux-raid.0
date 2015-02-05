From: NeilBrown <neilb@suse.de>
Subject: Re: md: 'array_size' sysfs attribute
Date: Fri, 6 Feb 2015 09:34:53 +1100
Message-ID: <20150206093453.5caa1782@notabene.brown>
References: <20150205110237.GA7933@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wm6p4vWrI3tRzcTnqARHMSx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150205110237.GA7933@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wm6p4vWrI3tRzcTnqARHMSx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Feb 2015 14:02:37 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> Hello Dan Williams,
>=20
> The patch b522adcde9c4: "md: 'array_size' sysfs attribute" from Mar
> 31, 2009, leads to the following static checker warning:
>=20
> 	drivers/md/md.c:5069 md_run()
> 	error: we previously assumed 'mddev->pers' could be null (see line 4936)
>=20
> This code is really old.  I don't know why my stupid scripts are marking
> it as a new warning.=20

Probably because it really is a new warning.  The problem is that your
"stupid scripts" (and we need more like them!!) are identifying the wrong
commit.

commit 516253a32c7abf3bc5754b1210106173ed191f7c
Author: NeilBrown <neilb@suse.de>
Date:   Mon Dec 15 12:56:58 2014 +1100

    md: protect ->pers changes with mddev->lock

is the guilty party (only in -next at present).  It delays the setting of
mddev->pers, but doesn't change all intermediate uses for mddev->pers into
pers.

I've just merged:
-		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
+		       (unsigned long long)pers->size(mddev, 0, 0) / 2);

into that patch.


>                       We don't set "mddev->pers" to non-NULL until the
> end of the function so it looks like a real bug and that "pers->size"
> was intended.  When I fix that bug then it un-silences this warning:
>=20
> 	drivers/md/md.c:5080 md_run()
> 	error: we previously assumed 'mddev->pers' could be null (see line 4936)
>=20
> And that also is a real bug, but I'm not sure the right fix for that.
>=20
> Basically, it's bugs all the way down from the code, to the fix, to the
> static checker.  *sigh*.
>=20
> drivers/md/md.c
>   5060          err =3D pers->run(mddev);
>   5061          if (err)
>   5062                  printk(KERN_ERR "md: pers->run() failed ...\n");
>   5063          else if (pers->size(mddev, 0, 0) < mddev->array_sectors) {
>   5064                  WARN_ONCE(!mddev->external_size, "%s: default siz=
e too small,"
>   5065                            " but 'external_size' not in effect?\n"=
, __func__);
>   5066                  printk(KERN_ERR
>   5067                         "md: invalid array_size %llu > default siz=
e %llu\n",
>   5068                         (unsigned long long)mddev->array_sectors /=
 2,
>   5069                         (unsigned long long)mddev->pers->size(mdde=
v, 0, 0) / 2);
>                                                    ^^^^^^^^^^^^^^^^^^
> This should be "pers->size()".
>=20
>   5070                  err =3D -EINVAL;
>   5071          }
>   5072          if (err =3D=3D 0 && pers->sync_request &&
>   5073              (mddev->bitmap_info.file || mddev->bitmap_info.offset=
)) {
>   5074                  err =3D bitmap_create(mddev);
>   5075                  if (err)
>   5076                          printk(KERN_ERR "%s: failed to create bit=
map (%d)\n",
>   5077                                 mdname(mddev), err);
>   5078          }
>   5079          if (err) {
>   5080                  mddev_detach(mddev);
>                         ^^^^^^^^^^^^^^^^^^^
> mddev_detach() will oops if mddev->pers() is not set.  We could set
> mdev->pers earlier, I suppose.

mddev_detach doesn't really need ->pers in this case.  I've merged:

@@ -5134,7 +5134,7 @@ static void mddev_detach(struct mddev *mddev)
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) =3D=3D 0);
 	}
-	if (mddev->pers->quiesce) {
+	if (mddev->pers && mddev->pers->quiesce) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}


Thanks a lot to you and your static checker!!

NeilBrown

>=20
>   5081                  pers->free(mddev, mddev->private);
>   5082                  module_put(pers->owner);
>   5083                  bitmap_destroy(mddev);
>   5084                  return err;
>   5085          }
>   5086          if (mddev->queue) {
>   5087                  mddev->queue->backing_dev_info.congested_data =3D=
 mddev;
>   5088                  mddev->queue->backing_dev_info.congested_fn =3D m=
d_congested;
>   5089                  blk_queue_merge_bvec(mddev->queue, md_mergeable_b=
vec);
>   5090          }
>=20
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/wm6p4vWrI3tRzcTnqARHMSx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNPwDTnsnt1WYoG5AQLHNxAAj8l6Lu25OxF8JwEV9HZrRuUR4OUC1M/R
KWpwsefM8Pkx0CbgW97EkPQEaYwCVMOZOlYdBeur3Ra/TWOFrNtNchloFeS+xu2J
1GEj5rpeKemhR1Hk4MHM8YhjZCeYbiOa0WSPpiRRNuysxMQfwn1zg9vB4kFHNSMc
PemJckG1hyxq66E+dEULduEwVrePdgFLf0SPIC59QXymUV4tjhcjCo2ppZOyltvW
Q4eGx6V4kRdmYPQOFwMv0DHs62cI7ww7oLq6c4bpOUXDX96DjZw/ar1p9BA5OSLe
LzdCSFtkjde78gxljfBFEL+U6O8OhH/xOz3g+2CeO14pXeXGB7C0e49nD+6bD8xv
mzSuQGoJ7tzH53AFLNNCzaRPgc/j33Lj4RWOtKRcdjns/MXv32Fw6RJIuTe66tTf
vy1ant38qKSiQd846/MDT2eMhW8ZlLzLoxyu1lHqWj+jhGxwj/i7e7RkNvIeBsoD
L4Qr2QMOZ+NqYRHzgrfpKNxECPbc1xMgGZegHAEPI7aE40p+PS4AiNRRFLd2U/Xy
6tCwuphJpVftjdtygecVbfhNCygYapJPu5mRYugay4bdCkiSGl3w7cPgPvpl0jBm
/r4UTj2MCjmzcKawjHkrUYmpfAG/gOXsfKGkPobxbZRbOvuDEx6WwxVRwj78zZju
y9NhwjWDOnA=
=Wu5+
-----END PGP SIGNATURE-----

--Sig_/wm6p4vWrI3tRzcTnqARHMSx--
