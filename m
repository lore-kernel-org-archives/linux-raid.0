From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1
 error handler to avoid potential data corruption
Date: Tue, 29 Jul 2014 12:44:15 +1000
Message-ID: <20140729124415.60ecdf3d@notabene.brown>
References: <1406534973.21454.3.camel@fedws>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/S5=BN9FqQBlIfn_Y.7b6a12"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1406534973.21454.3.camel@fedws>
Sender: linux-raid-owner@vger.kernel.org
To: jiao hui <jiaohui@bwstor.com.cn>
Cc: linux-raid@vger.kernel.org, guomingyang@nrchpc.ac.cn, zhaomeng@bwstor.com.cn
List-Id: linux-raid.ids

--Sig_/S5=BN9FqQBlIfn_Y.7b6a12
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jul 2014 16:09:33 +0800 jiao hui <jiaohui@bwstor.com.cn> wrote:

> >From 1fdbfb8552c00af55d11d7a63cdafbdf1749ff63 Mon Sep 17 00:00:00 2001
> From: Jiao Hui <simonjiaoh@gmail.com>
> Date: Mon, 28 Jul 2014 11:57:20 +0800
> Subject: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1 erro=
r handler to avoid potential data corruption
>=20
>     In the recovery of raid1 with bitmap, if a bitmap bit has a NEEDED or=
 RESYNC flag,
>     actual resync io will happen. The sync_thread check each rdev, if any=
 rdev is missing
>     or has a FAULTY flag, the array is still_degraded, then the bitmap bi=
t NEEDED flag
>     not cleared. Otherwise, we cleared NEEDED flag and set RESYNC flag. T=
he RESYNC flag cleared
>     in bitmap_cond_end_sync or bitmap_close_sync.
>=20
>     If the only disk which is being recovered fails again when raid1 reco=
very is in progress.
>     The resync_thread can't find a non-In_sync disk to write, then the re=
maining recovery skipped.
>     RAID1 error handler only set MD_RECOVERY_INTR flag when a In_sync dis=
k fails. But the disk
>     being reocvered is non-In_sync, then md_do_sync can't got the INTR si=
ngal to break, and the
>     mddev->curr_resync is uptodated to max_sectors (mddev->dev_sectors). =
When raid1 personality
>     tries to finish resync process, no bitmap bit with RESYNC flag can se=
t back to NEEDED flag,
>     and bitmap_close_sync clear the RESYNC flag. When the disk is added b=
ack, the area from
>     the offset of last recovery to the end of bitmap-chunk is skipped by =
resync_thread forever.
>    =20
>     Signed-off-by: JiaoHui <jiaohui@bwstor.com.cn>
>=20
> ---
>  drivers/md/raid1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index aacf6bf..51d06eb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1391,16 +1391,16 @@ static void error(struct mddev *mddev, struct md_=
rdev *rdev)
>  		return;
>  	}
>  	set_bit(Blocked, &rdev->flags);
> +	/*
> +	 * if recovery is running, make sure it aborts.
> +	 */
> +	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  	if (test_and_clear_bit(In_sync, &rdev->flags)) {
>  		unsigned long flags;
>  		spin_lock_irqsave(&conf->device_lock, flags);
>  		mddev->degraded++;
>  		set_bit(Faulty, &rdev->flags);
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		/*
> -		 * if recovery is running, make sure it aborts.
> -		 */
> -		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  	} else
>  		set_bit(Faulty, &rdev->flags);
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);


Hi,
 thanks for the report and the patch.

If the recovery process gets a write error it will abort the current bitmap
region by calling bitmap_end_sync() in end_sync_write().
However you are talking about a different situation where a normal IO write
gets and error and fails a drive.  Then the recovery aborts without aborting
the current bitmap region.

I think I would rather fix the bug by calling end_sync_write() at the place
where the recovery decides to abort, as in the following patch.
Would you be able to test it please and confirm that it works?

A similar fix will probably be needed for raid10.

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 56e24c072b62..4f007a410f4b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2668,9 +2668,11 @@ static sector_t sync_request(struct mddev *mddev, se=
ctor_t sector_nr, int *skipp
=20
 	if (write_targets =3D=3D 0 || read_targets =3D=3D 0) {
 		/* There is nowhere to write, so all non-sync
-		 * drives must be failed - so we are finished
+		 * drives must be failed - so we are finished.
+		 * But abort the current bitmap region though.
 		 */
 		sector_t rv;
+		bitmap_end_sync(mddev->bitmap, sector_nr, &sync_blocks, 1);
 		if (min_bad > 0)
 			max_sector =3D sector_nr + min_bad;
 		rv =3D max_sector - sector_nr;

--Sig_/S5=BN9FqQBlIfn_Y.7b6a12
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9cKfznsnt1WYoG5AQJKkw/9EFUD0dZDmj/42nFmeJGhD9Qai1EqNV7m
DmHyZXkQZBZXwp1AY3+kOmlpvZz3B5c9PfvwZ+14iPB0EXLKBW4Qm1dDBmm5PwCk
fU/rEhO3OQAEUUfatwuDt4ncpUJNinVEbGuDigNyTNc1UgKUmUJ+tPYAi/S/PFeP
riRUktOaGYZH7EpzdMoMGnmy3qtaH/XraeEgZ1hWgeQ03f6PNZY7AGFT1Uik0qO2
RhuLwMkB1p+QGoIdTNSmbQG477eo4V+e31kGbJVBxMn/6wawE94BZFxJRW4N8JCw
pEyJ0baUQ8BenOPcSi55sszJGufe2I76z0hY5jGclSyoyzHBlK1ToxJCHFKE9bvg
16IrCY3wt9RptOdINWI7tATL6jVb2u/+Vg4oHiS0Jx+UvUZIXcCSQM73jBdYpvw4
XpBISPzMLTaI7HN9SYMs2f8iIiKpVXt4py5SO5rTuMXJitB0PR6UHbp4eD62LQoQ
S6cYcq/WvU5dk8HOgu+F3MCHD0U5f2dgsBfUvjgRGVwrrP6RKQhND1A/yCDJxvUX
HYFcASOWBTZOz1L1AR5NVmp5rKL7bFrDEqlHwUCSFWp/gsHEwsMlZICSeP/7mEWZ
+eqbjFg+LMZjmMA7t5PbpKhGm3uZIXDlh+E+zKWRrJeb7CA9XdaBV2f9gwOuMckW
pr0/6hvRMfg=
=KsPs
-----END PGP SIGNATURE-----

--Sig_/S5=BN9FqQBlIfn_Y.7b6a12--
