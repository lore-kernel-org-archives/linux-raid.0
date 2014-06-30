From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 (re)-add recovery data corruption
Date: Mon, 30 Jun 2014 13:23:35 +1000
Message-ID: <20140630132335.4361445e@notabene.brown>
References: <53A518BB.60709@sbcglobal.net>
	<20140623113641.79965998@notabene.brown>
	<53AF5304.7020401@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_B3.2i7xKvA=W59lBrEX+6k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53AF5304.7020401@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bill <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_B3.2i7xKvA=W59lBrEX+6k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2014 18:43:00 -0500 Bill <billstuff2001@sbcglobal.net> wrote:

> On 06/22/2014 08:36 PM, NeilBrown wrote:
> > On Sat, 21 Jun 2014 00:31:39 -0500 Bill<billstuff2001@sbcglobal.net>  w=
rote:
> >
> >> Hi Neil,
> >>
> >> I'm running a test on 3.14.8 and seeing data corruption after a recove=
ry.
> >> I have this array:
> >>
> >>       md5 : active raid5 sdc1[2] sdb1[1] sda1[0] sde1[4] sdd1[3]
> >>             16777216 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUU=
UU]
> >>             bitmap: 0/1 pages [0KB], 2048KB chunk
> >>
> >> with an xfs filesystem on it:
> >>       /dev/md5 on /hdtv/data5 type xfs
> >> (rw,noatime,barrier,swalloc,allocsize=3D256m,logbsize=3D256k,largeio)
> >>
> >> and I do this in a loop:
> >>
> >> 1. start writing 1/4 GB files to the filesystem
> >> 2. fail a disk. wait a bit
> >> 3. remove it. wait a bit
> >> 4. add the disk back into the array
> >> 5. wait for the array to sync and the file writes to finish
> >> 6. checksum the files.
> >> 7. wait a bit and do it all again
> >>
> >> The checksum QC will eventually fail, usually after a few hours.
> >>
> >> My last test failed after 4 hours:
> >>
> >>       18:51:48 - mdadm /dev/md5 -f /dev/sdc1
> >>       18:51:58 - mdadm /dev/md5 -r /dev/sdc1
> >>       18:52:06 - start writing 3 files
> >>       18:52:08 - mdadm /dev/md5 -a /dev/sdc1
> >>       18:52:18 - array recovery done
> >>       18:52:23 - writes finished. QC failed for one of three files.
> >>
> >> dmesg shows no errors and the disks are operating normally.
> >>
> >> If I "check" /dev/md5 it shows mismatch_cnt =3D 896
> >> If I dump the raw data on sd[abcde]1 underneath the bad file, it shows
> >> sd[abde]1 are correct, and sdc1 has some chunks of old data from a
> >> previous file.
> >>
> >> If I fail sdc1, --zero-superblock it, and add it, it then syncs and the
> >> QC is correct.
> >>
> >> So somehow is seems like md is loosing track of some changes which need
> >> to be
> >> written to sdc1 in the recovery. But rarely - in this case it failed
> >> after 175 cycles.
> >>
> >> Do you have any idea what could be happening here?
> > No.  As you say, it looks like md is not setting a bit in the bitmap
> > correctly, or ignoring one that is set, or maybe clearing one that shou=
ldn't
> > be cleared.
> > The last is most likely I would guess.
>=20
> Neil,
>=20
> I'm still digging through this but I found something that might help=20
> narrow it
> down - the bitmap stays dirty after the re-add and recovery is complete:
>=20
>          Filename : /dev/sde1
>             Magic : 6d746962
>           Version : 4
>              UUID : 609846f8:ad08275f:824b3cb4:2e180e57
>            Events : 5259
>    Events Cleared : 5259
>             State : OK
>         Chunksize : 2 MB
>            Daemon : 5s flush period
>        Write Mode : Normal
>         Sync Size : 4194304 (4.00 GiB 4.29 GB)
>            Bitmap : 2048 bits (chunks), 2 dirty (0.1%)
>                                         ^^^^^^^^^^^^^^
>=20
> This is after 1/2 hour idle. sde1 was the one removed / re-added, but
> all five disks show the same bitmap info, and the event count matches=20
> that of
> the array (5259). At this point the QC check fails.
>=20
> Then I manually failed, removed and re-added /dev/sde1, and shortly the=20
> array
> synced the dirty chunks:
>=20
>          Filename : /dev/sde1
>             Magic : 6d746962
>           Version : 4
>              UUID : 609846f8:ad08275f:824b3cb4:2e180e57
>            Events : 5275
>    Events Cleared : 5259
>             State : OK
>         Chunksize : 2 MB
>            Daemon : 5s flush period
>        Write Mode : Normal
>         Sync Size : 4194304 (4.00 GiB 4.29 GB)
>            Bitmap : 2048 bits (chunks), 0 dirty (0.0%)
>                                         ^^^^^^^^^^^^^^
>=20
> Now the QC check succeeds and an array "check" shows no mismatches.
>=20
> So it seems like md is ignoring a set bit in the bitmap, which then gets=
=20
> noticed
> with the fail / remove / re-add sequence.

Thanks, that helps a lot ... maybe.

I have a theory.  This patch explains it and should fix it.
I'm not sure this is the patch I will go with if it works, but it will help
confirm my theory.
Can you test it?

thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 34846856dbc6..27387a3740c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7906,6 +7906,15 @@ void md_check_recovery(struct mddev *mddev)
 			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			/* If there is a bitmap, we need to make sure
+			 * all writes that started before we added a spare
+			 * complete before we start doing a recovery.
+			 * Otherwise the write might complete and set
+			 * a bit in the bitmap after the recovery has
+			 * checked that bit and skipped that region.
+			 */
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
 		} else if (mddev->recovery_cp < MaxSector) {
 			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);


--Sig_/_B3.2i7xKvA=W59lBrEX+6k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7DYODnsnt1WYoG5AQJjIxAAvsXyLBztKU5roaCReKcbJW92HPNOs6RF
Adyg9UxhU35WgUcTg/2mzVK4KlWbBGKsmH73npbWVwOa9vNhFuTMTsFGKtbMvw3R
rPzNiUJ1pW2fEB1caRO69hboRD9eU8F+kfaWx5qHv+ioOS5gKz848hU0NQ+V1Sbv
j7Mvr7cIfyJ+8hjB0cqNVDZmJiecPEjdzGHssFezzNf6+a2xvnC4oqzlJH4MA1JJ
iwZ1G1DK20oEB5/t0j/rssh7RXugj7PEUG7surIVpSQqTWyIQtfmoeOP/r26Jrnv
aXQHienU4wiTH9+DdVIZbDdIpDRUDyq84IEvfxcWJ11U7g7y2V/KRzPV0mb/BRWz
CXVemNBHp4BcqxI10Y9/ZpgcAS0Mw+BUt1niOyX/xfiDefqmR5jYqqVu2xSrgIXZ
WDdG9i1VuzMXX5+6m8l254eTu1PcAAD3/xvAljUpb3y3CkC/rsws/qtJfAox3qYx
kbKLUiXPPln2pylzOf57qKDHUSxBO9/x365rw4+VTMFKsBHCM019JfvnusKeB0X5
v8UUVixDJoQfJyk+xjZK8i+clF1dgBy8U0wdwp/vRzG6iYjLhc38xnJdHJGHv49o
bkHa8l27QVAwE4vQkPRvOMfSKu1KBMZDF2OPvUOXAmp44iRqcacuCe2nJbwsci5u
9aI/YAEhV+4=
=AhmH
-----END PGP SIGNATURE-----

--Sig_/_B3.2i7xKvA=W59lBrEX+6k--
