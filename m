From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 53/54] md/raid10: Delete two unwanted spaces behind asterisks
Date: Thu, 6 Oct 2016 11:53:01 +0200
Message-ID: <6fc3525c-ac06-cc07-a322-c8ef84a96882@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 22:02:18 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 554b6d2..09c0e2f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -107,7 +107,7 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
 static void end_reshape_write(struct bio *bio);
 static void end_reshape(struct r10conf *conf);
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
 	int size = offsetof(struct r10bio, devs[conf->copies]);
@@ -137,7 +137,7 @@ static void r10bio_pool_free(void *r10_bio, void *data)
  * one for write (we recover only one drive per r10buf)
  *
  */
-static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
 	struct page *page;
-- 
2.10.1
