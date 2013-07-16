From: NeilBrown <neilb@suse.de>
Subject: Re: Scrubbing "check" not working for RAID10 in 3.10-rc1+
Date: Tue, 16 Jul 2013 17:01:30 +1000
Message-ID: <20130716170130.44a0db05@notabene.brown>
References: <1372141160.2016.0.camel@f16>
	<20130625163221.6f25f83d@notabene.brown>
	<3D105022-CB87-4BA7-9ACB-A31A2B25694D@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PGe.r2st6=ambrpNWVAGQFU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D105022-CB87-4BA7-9ACB-A31A2B25694D@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PGe.r2st6=ambrpNWVAGQFU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jul 2013 10:35:07 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jun 25, 2013, at 1:32 AM, NeilBrown wrote:
>=20
> > On Tue, 25 Jun 2013 01:19:20 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> Neil,
> >>=20
> >> I've noticed that the "check" operation no longer works for RAID10.  It
> >> works just fine for the other RAIDs.  The ("data-check") sync_thread
> >> kicks off just fine, sync_request_write() is called, but it never gets
> >> past:
> >>        if (i =3D=3D conf->copies)
> >>                goto done;
> >> The test I am performing creates a RAID array, waits for it to sync,
> >> shuts it down, writes random data to one of the devices, assembles the
> >> array, and then runs a "check" - there should be descrepancies.  The
> >> descrepancies are found and recorded in resync_mismatches for all RAIDs
> >> <=3D 3.9 and only for non-RAID10 3.10-rc1+.
> >=20
> > I just tried on 3.10-rc5+ and it works as expected.
> > If you can provide a test script that fails, I'll look into it.
>=20
> Just tried 3.10 - it fails for me there too.  I'll send you the script I =
use shortly.
>=20
> thanks,
>  brassow
>=20
> (vacation ends soon.)
:-)

Thanks.  This patch seems to fix it.

NeilBrown

=46rom b0b0ac3ecf1e54dd6a429294082c47f1e52db41d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 16 Jul 2013 16:50:47 +1000
Subject: [PATCH] md/raid10: fix two problems with RAID10 resync.

1/ When an different between blocks is found, data is copied from
   one bio to the other.  However bv_len is used as the length to
   copy and this could be zero.  So use r10_bio->sectors to calculate
   length instead.
   Using bv_len was probably always a bit dubious, but the introduction
   of bio_advance made it much more likely to be a problem.

2/ When preparing some blocks for sync, we don't set BIO_UPTODATE
   except on bios that we schedule for a read.  This ensures that
   missing/failed devices don't confuse the loop at the top of
   sync_request write.
   Commit 8be185f2c9d54d6 "raid10: Use bio_reset()"
   removed a loop which set BIO_UPTDATE on all appropriate bios.
   So we need to re-add that flag.

Reported-by: Brassow Jonathan <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cd066b6..957a719 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2097,11 +2097,17 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
 			 * both 'first' and 'i', so we just compare them.
 			 * All vec entries are PAGE_SIZE;
 			 */
-			for (j =3D 0; j < vcnt; j++)
+			int sectors =3D r10_bio->sectors;
+			for (j =3D 0; j < vcnt; j++) {
+				int len =3D PAGE_SIZE;
+				if (sectors < (len / 512))
+					len =3D sectors * 512;
 				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
 					   page_address(tbio->bi_io_vec[j].bv_page),
-					   fbio->bi_io_vec[j].bv_len))
+					   len))
 					break;
+				sectors -=3D len/512;
+			}
 			if (j =3D=3D vcnt)
 				continue;
 			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
@@ -3407,6 +3413,7 @@ static sector_t sync_request(struct mddev *mddev, sec=
tor_t sector_nr,
=20
 		if (bio->bi_end_io =3D=3D end_sync_read) {
 			md_sync_acct(bio->bi_bdev, nr_sectors);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
 			generic_make_request(bio);
 		}
 	}

--Sig_/PGe.r2st6=ambrpNWVAGQFU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeTvyjnsnt1WYoG5AQJDZQ/9Flq3Rs2DO/RZ72uzChvLPZ7h+ROniM9d
HzgaFV0Ifj7l8zSPoybx/YSpnz/dj/mmmm9BfzWwK5t5/pHGGRu91V4tvpzA91F4
cYTx30wfGq5vF7qxB35jAMZh18WBkHdCaP4xlT0M81hpmJGimxQDASSWZz1njOzW
NV5dD+2rK8SccoR+JKBIucaTabwIFd5aftIHjUREslqbdR9khLfQ62U8feFmhmwi
pyNuQwgBeZE9ZJ1dMtIiHx6iDVOnGv+4o81YVI5NYuvY8ghVY20wnMVTcuuqGipY
WipugxgKT/Ff4ZyPbc1XIKBIM9BBIKSJOJ4gjCLKHGUsPxa3PSjhwy3LNCQ9j07j
m8fDf/N1nA0icfeVzB4I97A7xAiO6P4z5b/CdzaNusowe7N+4QrWDkGNC501749S
LRzvyELr24ZpmRLpdBmZX8pa8NJhVMAhRYRpkDr+i6po6ar7Lo8+jca/owmSFWip
oYYVdmWIvvAQ6/svBiuO26ksPHrABr7DhrRUr3J7RiRP5dR/g5lX9KiAZRHrns2f
6pAIWLOD6eAhyjcEWPNCTGupGwOoujvJsFrHVaYLF7hTGPQrqtoF+6cZD1Ljp1Gg
ydtS1EUHfiqnlNXa1tR6q3pP8g19q45MZdXrfPMMk6gPLZ0n2e2LrJQxzfnNUxp0
BDY9U0I03cY=
=7mSJ
-----END PGP SIGNATURE-----

--Sig_/PGe.r2st6=ambrpNWVAGQFU--
