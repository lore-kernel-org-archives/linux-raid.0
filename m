From: Seunguk Shin <seunguk.shin@samsung.com>
Subject: RE: [PATCH] raid0: data corruption when using trim
Date: Tue, 21 Jul 2015 13:18:52 +0900
Message-ID: <005601d0c36c$59d28ec0$0d77ac40$@samsung.com>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
 <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <yq1y4ibknz4.fsf@sermon.lab.mkp.net>
Content-language: ko
Sender: linux-raid-owner@vger.kernel.org
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin,

Thank you for new patch.

The function bio_split says "The newly allocated bio will point to @bio's
bi_io_vec; it is the caller's responsibility to ensure that @bio is not
freed before the split." in its comments. I'm not sure whether some caller
uses this limitation or not, so I modifid the raid function. If you want to
modify bio_split function, you have to modify the comment also.

The patch you shared has no problem, I think. I'll test it and share the
result.

I used the script from the algolia blog to reproduce the symptoms. They
share it on Github. (https://github.com/algolia/trimtester)

Thank you.
Seunguk Shin

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Martin K. Petersen
Sent: Monday, July 20, 2015 9:34 PM
To: Seunguk Shin
Cc: neilb@suse.de; linux-raid@vger.kernel.org
Subject: Re: [PATCH] raid0: data corruption when using trim

>>>>> "Seunguk" == Seunguk Shin <seunguk.shin@samsung.com> writes:

Seunguk,

Thanks for tracking this down. Instead of explicitly coding around the issue
in raid0/raid10/linear I would prefer to fix bio_split(). It seems like a
deficiency in the interface that it does not handle this transparently.

Do you have a reproducible test case? If so it would be great if you could
try the following patch and let us know the results.

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
 
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

