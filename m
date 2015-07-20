From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Mon, 20 Jul 2015 08:33:35 -0400
Message-ID: <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com> (Seunguk Shin's
	message of "Sun, 19 Jul 2015 12:28:16 +0900")
Sender: linux-raid-owner@vger.kernel.org
To: Seunguk Shin <seunguk.shin@samsung.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Seunguk" == Seunguk Shin <seunguk.shin@samsung.com> writes:

Seunguk,

Thanks for tracking this down. Instead of explicitly coding around the
issue in raid0/raid10/linear I would prefer to fix bio_split(). It seems
like a deficiency in the interface that it does not handle this
transparently.

Do you have a reproducible test case? If so it would be great if you
could try the following patch and let us know the results.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

commit 779e6b55da74108460baa8194d82806c4d7db523
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Mon Jul 20 08:05:30 2015 -0400

    block: Do a full clone when splitting discard bios
    
    Commit 20d0189b1012 "block: Introduce new bio_split()" permits sharing
    the bio_vec between the two resulting bios. That's fine for read/write
    requests where the bio_vec is immutable. For discards, however, we need
    to be able to attach a payload and update the bio_vec so the page can
    get mapped to a scatterlist entry. Therefore the bio_vec can not be
    shared when splitting discards and we must do a full clone.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Reported-by: Seunguk Shin <seunguk.shin@samsung.com>
    Cc: Jens Axboe <axboe@fb.com>
    Cc: Kent Overstreet <kent.overstreet@gmail.com>
    Cc: <stable@vger.kernel.org> # v3.14+

diff --git a/block/bio.c b/block/bio.c
index 2a00d349cd68..616b0e6f910a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1842,7 +1842,15 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	BUG_ON(sectors <= 0);
 	BUG_ON(sectors >= bio_sectors(bio));
 
-	split = bio_clone_fast(bio, gfp, bs);
+	/*
+	 * Discards need a mutable bio_vec to accommodate the payload
+	 * required by the DSM TRIM and UNMAP commands.
+	 */
+	if (bio->bi_rw & REQ_DISCARD)
+		split = bio_clone_bioset(bio, gfp, bs);
+	else
+		split = bio_clone_fast(bio, gfp, bs);
+
 	if (!split)
 		return NULL;
 
