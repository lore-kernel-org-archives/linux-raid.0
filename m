From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1
 error handler to avoid potential data corruption
Date: Wed, 30 Jul 2014 13:39:29 +1000
Message-ID: <20140730133929.7798e250@notabene.brown>
References: <1406534973.21454.3.camel@fedws>
	<20140729124415.60ecdf3d@notabene.brown>
	<CAEuG+XJhbjGDWhFTdX0h+be-TNVUQUfgWPZVcaxwT4wvzoPbLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sCQ1CQdrz_8_G6mn4q_3Ucu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEuG+XJhbjGDWhFTdX0h+be-TNVUQUfgWPZVcaxwT4wvzoPbLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jiao hui <jiaohui@bwstor.com.cn>
Cc: linux-raid <linux-raid@vger.kernel.org>, guomingyang <guomingyang@nrchpc.ac.cn>, zhaomeng <zhaomeng@bwstor.com.cn>
List-Id: linux-raid.ids

--Sig_/sCQ1CQdrz_8_G6mn4q_3Ucu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Jul 2014 14:50:04 +0800 jiao hui <jiaohui@bwstor.com.cn> wrote:

> Hi neil,
>=20
> The patch works. I test it on Centos 7.0 for fifty rounds=EF=BC=8C no
> consistency issue found=E3=80=82
>=20
> Best Regards.
> jiaohui
>=20

Thanks for testing.

I looked again and compared with raid10 and decided that your fix actually
was better.  If you are recovering two drives at once and only one fails, y=
ou
patch will do the right thing, but mine won't.

I'll be submitting the following.

Thanks,
NeilBrown

=46rom b628438e59827e710df20c27fea680cbe1870272 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 30 Jul 2014 13:24:50 +1000
Subject: [PATCH] md/raid1,raid10: always abort recover on write error.

Currently we don't abort recovery on a write error if the write error
to the recovering device was triggerd by normal IO (as opposed to
recovery IO).

This means that for one bitmap region, the recovery might write to the
recovering device for a few sectors, then not bother for subsequent
sectors (as it never writes to failed devices).  In this case
the bitmap bit will be cleared, but it really shouldn't.

The result is that if the recovering device fails and is then re-added
(after fixing whatever hardware problem triggerred the failure),
the second recovery won't redo the region it was in the middle of,
so some of the device will not be recovered properly.

If we abort the recovery, the region being processes will be cancelled
(bit not cleared) and the whole region will be retried.

As the bug can result in data corruption the patch is suitable for
-stable.  For kernels prior to 3.11 there is a conflict in raid10.c
which will require care.

Original-from: jiao hui <jiaohui@bwstor.com.cn>
Reported-and-tested-by: jiao hui <jiaohui@bwstor.com.cn>
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 56e24c072b62..d7690f86fdb9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1501,12 +1501,12 @@ static void error(struct mddev *mddev, struct md_rd=
ev *rdev)
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
+	/*
+	 * if recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
 	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cb882aae9e20..b08c18871323 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1684,13 +1684,12 @@ static void error(struct mddev *mddev, struct md_rd=
ev *rdev)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		return;
 	}
-	if (test_and_clear_bit(In_sync, &rdev->flags)) {
+	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
-			/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	}
+	/*
+	 * If recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);

--Sig_/sCQ1CQdrz_8_G6mn4q_3Ucu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9ho8Tnsnt1WYoG5AQImfQ//d7feaFdYlj/1ZJiZW/iQ6PMOCeWA2gEf
s3SIykVz+jbXamdQ/OY7uXTfoj7DdwWxJDrt98yWCgK80Fq605FQf9mKbtkKnT7+
rMPEEXNpv8zkb8pL6cIwBPv/a06UxaIy84ZahzvxCELYbT9qtH81r3k139kmqJRI
jPUFnOdM0fTz0NsCvfBdIdnIpzZ55qjHfSPYXFkqHYtv6m9skEqUv/bBThfa0hcl
7/DHmRG5F4m/iEaNd0H9d020YjWv86n5kUheF8jRmsngXadvKHsXJHhmK5b78xV3
X17St1UZKdf+avQnVNrbElnuHoFZQRwsxtrHIakh72u/xgy+WB4eXFe2kpuCu3O1
qf0hL1TB0nC1ujawjHoSZ48RglXxh4Sr1g5cDuoG8S9GiBJWvu0/YCxoG7rX+VfD
hKlevFH2wJG6N3oiC/6Md0JNB14Cx3HIbtGkwiYl7sxGPtPrGrIeVsqYjTsbAbl9
Keawc9qWgF26d3DMx6ztfOkGxhiVeL5xYEPGqOSxfRA6hMWmS/1Kvvl7dpMvd0IZ
g3e9LHNTBhEsOBm6DFBnormkJLvf02Bt1QCE/b2ZkwRIxQ+SKxG96MaiJ0PiGG8K
tDWzKdBykgtbkH3XgQHmXEMgq8g/bME/y5CsVkJJgQ72FF5b27DoinbaPI/LZdok
CM2R6RZLxv4=
=uZ2X
-----END PGP SIGNATURE-----

--Sig_/sCQ1CQdrz_8_G6mn4q_3Ucu--
