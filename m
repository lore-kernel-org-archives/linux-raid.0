From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Wed, 27 May 2015 09:34:51 +1000
Message-ID: <20150527093451.0c83be44@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
	<20150522053058.2117.29026.stgit@notabene.brown>
	<20150522234402.GA86128@kernel.org>
	<20150523102640.20be3fca@notabene.brown>
	<20150526181647.GA38853@kernel.org>
	<20150527083532.32486e08@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.IYhZkJZ4CDe8AtIbA7QHIt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527083532.32486e08@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.IYhZkJZ4CDe8AtIbA7QHIt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 08:35:32 +1000 NeilBrown <neilb@suse.de> wrote:

> Could you please review and possibly test the patch below?
>=20

well... that patch had a fairly obvious double-lock bug.
Try this one.
(oh, just saw your email that you spotted the lock bug :-)


NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Wed, 27 May 2015 08:43:45 +1000
Subject: [PATCH] md/raid5: close race between STRIPE_BIT_DELAY and batching.

The first time a write is added to a stripe, we need to set the
bitmap bits (if a bitmap is active).
While doing that the stripe is not locked and other writes could
be added and then the stripe could be added to a batch.
Once it has entered the batch it is too large to set STRIPE_BIT_DELAY
as the batch head has taken over when the stripe will be written.

We cannot hold the spinlock while adding the bitmap bit,
so introduce a new stripe_head flag 'STRIPE_BITMAP_PENDING' which
indicates that adding to the bitmap is pending.  This prevents
the stripe from being added to a batch.

Only the first thread to add a write to a stripe can set this bit,
so it is safe for it to clear it again when it is done.

Reported-by: Shaohua Li <shli@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 73b5376dad3b..dae587ecdf71 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -760,6 +760,7 @@ static void unlock_two_stripes(struct stripe_head *sh1,=
 struct stripe_head *sh2)
 static bool stripe_can_batch(struct stripe_head *sh)
 {
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
+		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
 		is_full_stripe_write(sh);
 }
=20
@@ -3007,14 +3008,27 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx,
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_iter.bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
-	spin_unlock_irq(&sh->stripe_lock);
=20
 	if (conf->mddev->bitmap && firstwrite) {
+		/* Cannot hold spinlock over bitmap_startwrite,
+		 * but must ensure this isn't added to a batch until
+		 * we have added to the bitmap and set bm_seq.
+		 * So set STRIPE_BITMAP_PENDING to prevent
+		 * batching.
+		 * Only the first thread to add a write to a stripe
+		 * can set this bit, so we "own" it.
+		 */
+		WARN_ON(test_bit(STRIPE_BITMAP_PENDING, &sh->state));
+		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
+		spin_unlock_irq(&sh->stripe_lock);
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
+		spin_lock_irq(&sh->stripe_lock);
+		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		sh->bm_seq =3D conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
+	spin_unlock_irq(&sh->stripe_lock);
=20
 	if (stripe_can_batch(sh))
 		stripe_add_to_batch_list(conf, sh);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d7b2bc8b756f..02c3bf8fbfe7 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -337,6 +337,9 @@ enum {
 	STRIPE_ON_RELEASE_LIST,
 	STRIPE_BATCH_READY,
 	STRIPE_BATCH_ERR,
+	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
+				 * to batch yet.
+				 */
 };
=20
 #define STRIPE_EXPAND_SYNC_FLAGS \

--Sig_/.IYhZkJZ4CDe8AtIbA7QHIt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWUDGznsnt1WYoG5AQL9uhAAwCMLJfdMtvPkjTKEbNXGTbg8U6XmwpSP
/QTzy3YIdn7r6RUmDwktvX/czbbnK3q18bUDe0xfi83zrb8c29wmapsZkEjvtsfk
V5RUyYo/eqEcLldc4JhSdSW5eTeB25N+YDfXCvPb8WEtVVSCf7CQZpD9Fq0U18ae
DBiqcgcVH91gnDpbzFOGvzdd59Fa1L166Jv5NKedj0zBAyEY9sZlnUwJzZ889Bor
IJmN1rVVwBGQHFAMrgI6lhTvb2N1CXCbvjflf7LoolrRsJxody6eUbDaXrKKDitZ
lAuj/904P7mVN2SDBHq81a2pKwu/7Yo/Ltrc4A8NGyf8UbQASFoeKFWXrNeczlh0
+DIZQ+FyhQthAZ3LFcJaq1lGtVjS76z893QSB3YrWvtvRQ1vh+NLPey7gMPsnfZf
U8zhrF2PhYR5M/tJMjHLnVdOgFc5m34FSzIr1ZPcQPEPn3JftXW2eLd72lQ6FKPg
uQIGDdt+YTd8sxjXsyt6GpBHAXQg9+pEO8XSCdVrbqw8lXcxJDlD8b0Lxexm75d8
lthVaXvmPDUMsOHufdmK35t1VP+Cklmt5WfrbzPTFNULXRvOKqkE4Cqx2/838+kL
2+pp2UQYolQtTa2EBOOd8Wcs8H4r6rI2rTWgPCj1dl08HL4GRIiHnrWtQLpbjoSz
45l6GZbhLVE=
=Cez+
-----END PGP SIGNATURE-----

--Sig_/.IYhZkJZ4CDe8AtIbA7QHIt--
