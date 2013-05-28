From: Kumar Amit Mehta <gmate.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] md: bcache: io.c: fix a potential NULL pointer dereference
Date: Tue, 28 May 2013 00:31:15 -0700
Message-ID: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: neilb-l3A5Bk7waGM@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

bio_alloc_bioset returns NULL on failure. This fix adds a missing check
for potential NULL pointer dereferencing.

Signed-off-by: Kumar Amit Mehta <gmate.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 29f344b..4be2a07 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -98,6 +98,8 @@ struct bio *bch_bio_split(struct bio *bio, int sectors,
 
 	if (bio->bi_rw & REQ_DISCARD) {
 		ret = bio_alloc_bioset(gfp, 1, bs);
+		if (!ret)
+			return NULL;
 		idx = 0;
 		goto out;
 	}
-- 
1.7.10.4
