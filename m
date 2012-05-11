From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 1/7] bcache: compile fix
Date: Fri, 11 May 2012 12:46:16 -0700
Message-ID: <20120511194616.25770.93946.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

dynamic_fault bits have been removed.

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/block/bcache/util.c |    2 --
 drivers/block/bcache/util.h |    3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/block/bcache/util.c b/drivers/block/bcache/util.c
index 200c523..6da7058 100644
--- a/drivers/block/bcache/util.c
+++ b/drivers/block/bcache/util.c
@@ -6,8 +6,6 @@
 #include <linux/seq_file.h>
 #include <linux/types.h>
 
-#include <linux/dynamic_fault.h>
-
 #include "util.h"
 
 #define simple_strtoint(c, end, base)	simple_strtol(c, end, base)
diff --git a/drivers/block/bcache/util.h b/drivers/block/bcache/util.h
index 0c14cd7..6bd5327 100644
--- a/drivers/block/bcache/util.h
+++ b/drivers/block/bcache/util.h
@@ -597,9 +597,6 @@ unsigned __bio_max_sectors(struct bio *bio, struct block_device *bdev,
 
 int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
-#define bio_alloc_pages(...)						\
-	(dynamic_fault() ? -ENOMEM	: bio_alloc_pages(__VA_ARGS__))
-
 static inline unsigned bio_max_sectors(struct bio *bio)
 {
 	return __bio_max_sectors(bio, bio->bi_bdev, bio->bi_sector);
