From: NeilBrown <neilb@suse.de>
Subject: Re: task mdadm blocked when stopping array, 3.15rc3
Date: Mon, 5 May 2014 13:40:56 +1000
Message-ID: <20140505134056.3705a703@notabene.brown>
References: <D2C55A8C-95E1-4DC0-8DC1-3D640C2CF5A8@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w2HsCO=aUwdD3OuNIZh6Mkk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D2C55A8C-95E1-4DC0-8DC1-3D640C2CF5A8@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-raid.ids

--Sig_/w2HsCO=aUwdD3OuNIZh6Mkk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 3 May 2014 17:16:18 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

> When I issue mdadm -S /dev/md0, I get a hang which does not recover after=
 30+ minutes. This is what appears in dmesg (partial), but I also have issu=
ed sysrq-w and included a followup dmesg and journalctl both of which are a=
ttached to this kernel bug because it's so wide it just looks ugly in email:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D75451

Thanks for the report.
Patch below should  fix it.  I'll send it upstream shortly.

I don't think the systemd-udevd messages are relevant.... I wonder what they
mean though.

NeilBrown

=46rom bbba3bc5932a56fdaeecfda87597c1cac5d84803 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 5 May 2014 13:34:37 +1000
Subject: [PATCH] md/raid10: call wait_barrier() for each request submitted.

wait_barrier() includes a counter, so we must call it precisely once
(unless balanced by allow_barrier()) for each request submitted.

Since
commit 20d0189b1012a37d2533a87fb451f7852f2418d1
    block: Introduce new bio_split()
in 3.14-rc1, we don't call it for the extra requests generated when
we need to split a bio.

When this happens the counter goes negative, any resync/recovery will
never start, and  "mdadm --stop" will hang.

Reported-by: Chris Murphy <lists@colorremedies.com>
Fixes: 20d0189b1012a37d2533a87fb451f7852f2418d1
Cc: stable@vger.kernel.org (3.14+)
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 33fc408e5eac..cb882aae9e20 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1172,6 +1172,13 @@ static void __make_request(struct mddev *mddev, stru=
ct bio *bio)
 	int max_sectors;
 	int sectors;
=20
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
+	wait_barrier(conf);
+
 	sectors =3D bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
@@ -1552,12 +1559,6 @@ static void make_request(struct mddev *mddev, struct=
 bio *bio)
=20
 	md_write_start(mddev, bio);
=20
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-	wait_barrier(conf);
=20
 	do {
=20

--Sig_/w2HsCO=aUwdD3OuNIZh6Mkk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU2cISDnsnt1WYoG5AQIuGw//QFoYAycYVgE9Kll58bzcZ0dVpq3FSYCb
mHaI2IlaTNen7hlDI7hoN3n9r/C4PYLj9MFlAs0iSFMFH8/0MGhwAa0Xm8d0DtEC
6LKwyxa3ucyNGOXwjG0S5S4LakVHOzIB+JsPm4+XZwa7WI0k38jITunQstAvSGKL
FgO0xxat/9ZGLF0bv0MzvgfvS2QxMqmx4tm4PUdKCn1jk1tyTk+Ko2QaNUt2SVSx
qJxcDK68uKHwPhD2CZPCF/85pNlQ3XicE/AQKIhesfbpz7bn3Mpd6QjK+9pfaN3s
00qfqVJKpnDM/76ptaaXOtS52iZigkoqyXlD/dVWkwBmRXdk4OqKPYj7kBT+5hrn
RHFKs7Y1erlDqCBO35+lWPmlkoo42FYH8JZsju6rpokKkmWDMUOC00rXQUBBGr+9
fAGAOmPH4Z3Uo+QnRjYOQ6B0j6hvKFuke98gMj/ybjkEVUj9V2RxvuRoqYJtcty3
TXxeEuMvkeNCt+u9Cqa1iYZ7aBmqwpd504fZW860hynS+xJE/0r3HTKuzIBa0OPT
d8MuVBEQ+bfNylPh0TWWFKbj0Dh+7Cibs/g6T6vpOM1okj4Xb3BkY0sSctktvaLb
S+UNbhBnzUyHLLsduuOzAiunzPplTUUAvBQklrOObcpODnWHQxYEnLGa5igAEYh0
7sUw5wVOpiE=
=P6VC
-----END PGP SIGNATURE-----

--Sig_/w2HsCO=aUwdD3OuNIZh6Mkk--
