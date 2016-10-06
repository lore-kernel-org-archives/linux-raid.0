From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/54] md/raid1: Use kcalloc() in alloc_behind_pages()
Date: Thu, 6 Oct 2016 11:05:07 +0200
Message-ID: <22c0aa38-d45a-0691-a2a0-9c57f5837844@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 15:01:04 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1961d82..d2759f8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -955,8 +955,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 {
 	int i;
 	struct bio_vec *bvec;
-	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
-					GFP_NOIO);
+	struct bio_vec *bvecs = kcalloc(bio->bi_vcnt, sizeof(*bvecs), GFP_NOIO);
 	if (unlikely(!bvecs))
 		return;
 
-- 
2.10.1
