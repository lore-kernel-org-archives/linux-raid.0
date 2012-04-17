From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md:Fix mem leak about rdev->badblocks.page.
Date: Tue, 17 Apr 2012 11:54:56 +1000
Message-ID: <20120417115456.35840bf5@notabene.brown>
References: <201204111558200780185@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kmbKGKfqT/BP2CB4Nab19Cs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204111558200780185@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kmbKGKfqT/BP2CB4Nab19Cs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 15:58:27 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 7cc5b99748a5505d94d6e67ba4e639e341f0a00a Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 11 Apr 2012 15:44:55 +0800
> Subject: [PATCH] md:Fix mem leak about rdev->badblocks.page. When exec
>  md_import_device(),alloc badblocks.page.But met error when
>  exec bind_rdev_to_array().So exec export_rdev().But
>  export_rdev() did not free badblocks.page.
>=20
> This may occur in those functions:
> 1:add_new_disk()
> 2:new_dev_store()

Thanks for the report.

I have chosen to fix it slightly differently - by doing the 'free' in
free_disk_sb, which I have since renamed to md_rdev_clear.

Here is that patch I have committed.

Thanks,
NeilBrown


=46rom 79a97ee9d3ce9c36a855ac2217ad946856f98d25 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 17 Apr 2012 11:52:56 +1000
Subject: [PATCH] md: move freeing of badblocks.page into md_rdev_clear

This ensures that it is always freed - there were case where
we failed to free the page.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7c3566c..e763fc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -814,6 +814,10 @@ void md_rdev_clear(struct md_rdev *rdev)
 		put_page(rdev->bb_page);
 		rdev->bb_page =3D NULL;
 	}
+	if (rdev->badblocks.page) {
+		kfree(rdev->badblocks.page);
+		rdev->badblocks.page =3D NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(md_rdev_clear);
=20
@@ -2189,9 +2193,7 @@ static void unbind_rdev_from_array(struct md_rdev * r=
dev)
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
 	rdev->sysfs_state =3D NULL;
-	kfree(rdev->badblocks.page);
 	rdev->badblocks.count =3D 0;
-	rdev->badblocks.page =3D NULL;
 	/* We need to delay this, otherwise we can deadlock when
 	 * writing to 'remove' to "dev/state".  We also need
 	 * to delay it due to rcu usage.
@@ -3323,7 +3325,6 @@ abort_free:
 	if (rdev->bdev)
 		unlock_rdev(rdev);
 	md_rdev_clear(rdev);
-	kfree(rdev->badblocks.page);
 	kfree(rdev);
 	return ERR_PTR(err);
 }

--Sig_/kmbKGKfqT/BP2CB4Nab19Cs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zNcDnsnt1WYoG5AQL/Kg//dvgeX03ThfuwK5dh90+9xfUrMYaUyPtw
1U7wkINna1uGb9+IhuX4E/zSpE/+ocB9KYa4FWObh78Ku7AA5z8x+mN9uge4SEpv
lJ/uizixAkWk1OnJBuWdRGZUg7zSR5CuBXHzOQJtonFnLezCO6yemghXUlHaT4RE
ZEZ/6qJom70IwAcMBut6wZDN9KyWyFmdxsWN2EH4cgbQKebI3ZkmnerY10r6FGha
ZbcfTAEO6tLFDRT7K1EERd+0yPeHhPVYDXtvcclKPTdyKdeRNvojb0J9C2/9lx1a
5GN5whfMdFbvE8bqlgohXXb4K3BTQnkyYh7oGkEtoxBqpc0VNI212B4wumKFIhsW
s5pnbcBQHVFWCR+fiKXAF07AZeZNT/qSNLB8Xf1ZCETf3TrUHfF7ZIz1a9uacb/F
Tx0ECkDbdZcd0a4RoS7OgHPucpbcGncFktxv86mXDugt4tFmJTh+RayZ8Pw0fyQA
1VsZ8p+LeHwZOMPbyDbFU3HwETvri8J8idIGRGWWczc1/STFeFt0jE108FSECTGA
ftR3DxLmkLX75i54U0xBh8lDEFrIoN2/tW3XUuT2veaOEIC1338ZFpXX5fOx8Osg
pEI8R9FRbfGiQI20iqEgPdb9biFKXn1MuJhmwpZisoYdRI68sWSJv1nl1tqlze/B
k938PvluutE=
=UtBF
-----END PGP SIGNATURE-----

--Sig_/kmbKGKfqT/BP2CB4Nab19Cs--
