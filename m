From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 (re)-add recovery data corruption
Date: Mon, 30 Jun 2014 13:40:45 +1000
Message-ID: <20140630134045.601cd33d@notabene.brown>
References: <53A518BB.60709@sbcglobal.net>
	<20140623113641.79965998@notabene.brown>
	<53AF5304.7020401@sbcglobal.net>
	<20140630132335.4361445e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kgKA=1fxk.pGq1m2w.BIXe1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140630132335.4361445e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Bill <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kgKA=1fxk.pGq1m2w.BIXe1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2014 13:23:35 +1000 NeilBrown <neilb@suse.de> wrote:

> On Sat, 28 Jun 2014 18:43:00 -0500 Bill <billstuff2001@sbcglobal.net> wro=
te:
>=20
> > On 06/22/2014 08:36 PM, NeilBrown wrote:
> > > On Sat, 21 Jun 2014 00:31:39 -0500 Bill<billstuff2001@sbcglobal.net> =
 wrote:
> > >
> > >> Hi Neil,
> > >>
> > >> I'm running a test on 3.14.8 and seeing data corruption after a reco=
very.
> > >> I have this array:
> > >>
> > >>       md5 : active raid5 sdc1[2] sdb1[1] sda1[0] sde1[4] sdd1[3]
> > >>             16777216 blocks level 5, 64k chunk, algorithm 2 [5/5] [U=
UUUU]
> > >>             bitmap: 0/1 pages [0KB], 2048KB chunk
> > >>
> > >> with an xfs filesystem on it:
> > >>       /dev/md5 on /hdtv/data5 type xfs
> > >> (rw,noatime,barrier,swalloc,allocsize=3D256m,logbsize=3D256k,largeio)
> > >>
> > >> and I do this in a loop:
> > >>
> > >> 1. start writing 1/4 GB files to the filesystem
> > >> 2. fail a disk. wait a bit
> > >> 3. remove it. wait a bit
> > >> 4. add the disk back into the array
> > >> 5. wait for the array to sync and the file writes to finish
> > >> 6. checksum the files.
> > >> 7. wait a bit and do it all again
> > >>
> > >> The checksum QC will eventually fail, usually after a few hours.
> > >>
> > >> My last test failed after 4 hours:
> > >>
> > >>       18:51:48 - mdadm /dev/md5 -f /dev/sdc1
> > >>       18:51:58 - mdadm /dev/md5 -r /dev/sdc1
> > >>       18:52:06 - start writing 3 files
> > >>       18:52:08 - mdadm /dev/md5 -a /dev/sdc1
> > >>       18:52:18 - array recovery done
> > >>       18:52:23 - writes finished. QC failed for one of three files.
> > >>
> > >> dmesg shows no errors and the disks are operating normally.
> > >>
> > >> If I "check" /dev/md5 it shows mismatch_cnt =3D 896
> > >> If I dump the raw data on sd[abcde]1 underneath the bad file, it sho=
ws
> > >> sd[abde]1 are correct, and sdc1 has some chunks of old data from a
> > >> previous file.
> > >>
> > >> If I fail sdc1, --zero-superblock it, and add it, it then syncs and =
the
> > >> QC is correct.
> > >>
> > >> So somehow is seems like md is loosing track of some changes which n=
eed
> > >> to be
> > >> written to sdc1 in the recovery. But rarely - in this case it failed
> > >> after 175 cycles.
> > >>
> > >> Do you have any idea what could be happening here?
> > > No.  As you say, it looks like md is not setting a bit in the bitmap
> > > correctly, or ignoring one that is set, or maybe clearing one that sh=
ouldn't
> > > be cleared.
> > > The last is most likely I would guess.
> >=20
> > Neil,
> >=20
> > I'm still digging through this but I found something that might help=20
> > narrow it
> > down - the bitmap stays dirty after the re-add and recovery is complete:
> >=20
> >          Filename : /dev/sde1
> >             Magic : 6d746962
> >           Version : 4
> >              UUID : 609846f8:ad08275f:824b3cb4:2e180e57
> >            Events : 5259
> >    Events Cleared : 5259
> >             State : OK
> >         Chunksize : 2 MB
> >            Daemon : 5s flush period
> >        Write Mode : Normal
> >         Sync Size : 4194304 (4.00 GiB 4.29 GB)
> >            Bitmap : 2048 bits (chunks), 2 dirty (0.1%)
> >                                         ^^^^^^^^^^^^^^
> >=20
> > This is after 1/2 hour idle. sde1 was the one removed / re-added, but
> > all five disks show the same bitmap info, and the event count matches=20
> > that of
> > the array (5259). At this point the QC check fails.
> >=20
> > Then I manually failed, removed and re-added /dev/sde1, and shortly the=
=20
> > array
> > synced the dirty chunks:
> >=20
> >          Filename : /dev/sde1
> >             Magic : 6d746962
> >           Version : 4
> >              UUID : 609846f8:ad08275f:824b3cb4:2e180e57
> >            Events : 5275
> >    Events Cleared : 5259
> >             State : OK
> >         Chunksize : 2 MB
> >            Daemon : 5s flush period
> >        Write Mode : Normal
> >         Sync Size : 4194304 (4.00 GiB 4.29 GB)
> >            Bitmap : 2048 bits (chunks), 0 dirty (0.0%)
> >                                         ^^^^^^^^^^^^^^
> >=20
> > Now the QC check succeeds and an array "check" shows no mismatches.
> >=20
> > So it seems like md is ignoring a set bit in the bitmap, which then get=
s=20
> > noticed
> > with the fail / remove / re-add sequence.
>=20
> Thanks, that helps a lot ... maybe.
>=20
> I have a theory.  This patch explains it and should fix it.
> I'm not sure this is the patch I will go with if it works, but it will he=
lp
> confirm my theory.
> Can you test it?
>=20
> thanks,
> NeilBrown
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 34846856dbc6..27387a3740c8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7906,6 +7906,15 @@ void md_check_recovery(struct mddev *mddev)
>  			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>  			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>  			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +			/* If there is a bitmap, we need to make sure
> +			 * all writes that started before we added a spare
> +			 * complete before we start doing a recovery.
> +			 * Otherwise the write might complete and set
> +			 * a bit in the bitmap after the recovery has
> +			 * checked that bit and skipped that region.
> +			 */
> +			mddev->pers->quiesce(mddev, 1);
> +			mddev->pers->quiesce(mddev, 0);
>  		} else if (mddev->recovery_cp < MaxSector) {
>  			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>=20

Don't even bother trying that - it will definitely deadlock.

Please try this instead.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 34846856dbc6..f8cd0bd83402 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7501,6 +7501,16 @@ void md_do_sync(struct md_thread *thread)
 			    rdev->recovery_offset < j)
 				j =3D rdev->recovery_offset;
 		rcu_read_unlock();
+
+		/* If there is a bitmap, we need to make sure
+		 * all writes that started before we added a spare
+		 * complete before we start doing a recovery.
+		 * Otherwise the write might complete and set
+		 * a bit in the bitmap after the recovery has
+		 * checked that bit and skipped that region.
+		 */
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
 	}
=20
 	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));

--Sig_/kgKA=1fxk.pGq1m2w.BIXe1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7DcPTnsnt1WYoG5AQJAhhAApeWtYXPm8XEWb6fEvojCMg49vfd3CrpT
9/Swba00Ao55nEwVmuPB4InHKDkYq3VFwDZt9a0djpd1/cHrXx7WX0r3rPDKSDwS
VXn6jsPdw1cveEkKCbcr/6TeNYDYSm5VTM54LHWYRpR3SdiT5DuF5ClyOLeEqt12
wFvKv/JDWNcdulUD4Lg8gR+J1z4p2cq6Ichchaejl775oQ+szSwmcC+KtiyQOz2d
sMIycONG4Z7jUb1/HCWC2518F38WUb3BIgL/s9ix1Q3fyq9WwePo4IIHB1i2yY6I
qsYJZ1MQJIYqyDm8Py7gt/4OUL5XnThVClVZ0KC174i+l92ojw+Z1Zn4yb5s4Ydb
AM16glVCyUoL5SsuP9Hxx9cq0ArPHXiOtLpCktM61oKxTy9frR0uhB8hA+SyGZQD
de54D+IpATmHvJelcTW9rjA4zhAMH4QB85qe2mzoIoDyTx6565Dy8NjLh2lxbc+n
doCNktK8j/vHI59khKZZVsYTvzUjcPTRlDl8LxoMqL6gxeqG7dSjcUU70WfiDC+2
pbMf478GX2gmNfCsn2UNfUwdVLN/z0qJvxhrO7PTZDXFxM3aglYLL9DHS6FrufBT
WaPZFN+9mfzsVF4L+RI5MJmbjvklEjCGAIVnX40joip/2r3qfYwfexgeOLp3+/av
3uze0Rmbn8s=
=jFXC
-----END PGP SIGNATURE-----

--Sig_/kgKA=1fxk.pGq1m2w.BIXe1--
