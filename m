From: NeilBrown <neilb@suse.de>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Mon, 23 Apr 2012 09:48:53 +1000
Message-ID: <20120423094853.15683cd6@notabene.brown>
References: <4F92BC43.3010603@computer.org>
	<20120422070041.7e4b95e7@notabene.brown>
	<4F943E07.8040206@computer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CLm5i85Oo0qCqnrY0XWHG2W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F943E07.8040206@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/CLm5i85Oo0qCqnrY0XWHG2W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 19:21:11 +0200 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> NeilBrown wrote:
> > Looks like:
> >
> >     commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3
> >
> > is at fault.  It causes md to attempt to add spares into the array more=
 often.
> > Would I be right in guessing that you have one spare in this array?
> > If you remove the spare, the messages should stop.
>=20
> Hmmm. The commit message is as follows:
>=20
> commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3
> Author: NeilBrown <neilb@suse.de>
> Date:   Fri Dec 23 10:17:53 2011 +1100
>=20
>      md/raid5: If there is a spare and a want_replacement device, start=20
> replaceme
>=20
>      When attempting to add a spare to a RAID[456] array, also consider
>      adding it as a replacement for a want_replacement device.
>=20
>      This requires that common md code attempt hot_add even when the array
>      is not formally degraded.
>=20
>      Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>      Signed-off-by: NeilBrown <neilb@suse.de>
>=20
>=20
> Does this also apply to RAID1 (which is all I've got on this machine: no=
=20
> RAID456)?

Yes it does apply to RAID1.  Part of the patch was RAID5-specific but part =
of
it was to common code that would affect other levels.  That part was not
meant to be a big change, but it turned out to be a little bigger than I
expected.

The following should fix it.

Thanks again for the report,
NeilBrown


=46rom 321f820a905993f694f7ba4347492e9273831813 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 23 Apr 2012 09:46:28 +1000
Subject: [PATCH] md: don't call ->add_disk unless there is good reason.

Commit 7bfec5f35c68121e7b18

   md/raid5: If there is a spare and a want_replacement device, start repla=
cement.

cause md_check_recovery to call ->add_disk much more often.
Instead of only when the array is degraded, it is now called whenever
md_check_recovery finds anything useful to do, which includes
updating the metadata for clean<->dirty transition.
This causes unnecessary work, and causes info messages from ->add_disk
to be reported much too often.

So refine md_check_recovery to only do any actual recovery checking
(including ->add_disk) if MD_RECOVERY_NEEDED is set.

This fix is suitable for 3.3.y:

Cc: stable@vger.kernel.org
Reported-by: Jan Ceuleers <jan.ceuleers@computer.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9524192..47f1fdb6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7813,14 +7813,14 @@ void md_check_recovery(struct mddev *mddev)
 		 * any transients in the value of "sync_action".
 		 */
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		/* Clear some bits that don't mean anything, but
 		 * might be left set
 		 */
 		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
=20
-		if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 			goto unlock;
 		/* no recovery is running.
 		 * remove any failed drives, then

--Sig_/CLm5i85Oo0qCqnrY0XWHG2W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5SY5Tnsnt1WYoG5AQKPJxAAvLFFakYn0rtRxOrl1jECT1QXPnxl1/PT
oXd2yIJYqa8yPTzlIcQznKZxBDqFojXz3yHZw9z4XU2cqtMEsn7I6Syppw9BRm1z
JQ8VaepfOMav6C+ISNMZHMDynyXttxEH3iwxsPFblI/ws8xzoo77I9KHa8AA1nUV
46u1vIOCbuk8/1zIFe5X8Nj6yyFk+n3IKDoaNG2euDwSLO+9S65e6mdBrMDZtxKW
1PRR/Stc5TGBk4RrH1GrVfdQXqf4B7AFNdJlmKEzTS2S8SNIX/3RaRF4JcJVtjdb
C6GCFLAWpDVPFuCdHIC63ltokD+0F+bS9T/GXhqVOnqTZfPwa+WGL65DnnqN1RZN
olCGCDW/IRkYPJma5W+g4XDzIhxY1iaarvBeK5I2vvHWwHILNvIJPoQKynSSxpo4
G6y1Ekd7a0BFGL+xT6uuwXIVka0ObXTJSyKJvwxyfEXUA/Rg2wfB17+OtW+gtP1j
NWWA895R1Mg6VeEG+bfmWyYOpmUL4tmxkC4fuKXMXYuQDzgtGelMQ/yafiaSOSZQ
Pv1Azc0VQmdhpwHR1x/sTX/yMBoBGcEZDk5mb/7CtsXH+i1H78jpq9PmfZv9MaDS
bBETfWCXos+OA6WzwRb3jc51KhsllNlAqs5zx9nvVj7+vrzRvthzBMD0hmNw0r82
SJ6K66XSm54=
=MQjR
-----END PGP SIGNATURE-----

--Sig_/CLm5i85Oo0qCqnrY0XWHG2W--
