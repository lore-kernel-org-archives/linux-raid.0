Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B01BC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 22:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJMWpG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJMWpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Oct 2022 18:45:04 -0400
Received: from resqmta-c1p-023462.sys.comcast.net (resqmta-c1p-023462.sys.comcast.net [IPv6:2001:558:fd00:56::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47AF5FAED
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 15:44:56 -0700 (PDT)
Received: from resomta-c1p-023267.sys.comcast.net ([96.102.18.232])
        by resqmta-c1p-023462.sys.comcast.net with ESMTP
        id j6WVome6O03bPj6uGoD3ZF; Thu, 13 Oct 2022 22:42:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665700944;
        bh=RmsPdp6XB2/XHXf0fJ7VeuVLgpyyn/dl4lgDaA8Nfi4=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=mVUKol8uWPnTgiQ/sq182Ams7RhUsPj26qYZLFQjkwJKYNAnhYHlqijE6waPcr3pA
         L9HKizm7fwxI9DfwxajiE+ZVny+Zw4tDro+32N7e4cH6FOkzj//r/8W+lnwcUS/5hZ
         6JjyHVZSROlP1yAZykrv31UdF63EY/nqiPokz/SL2QCyXuNOQgumYroYKyeuuMfGNC
         fRpE717lUCZHNVQUzSVpk4RmeC2Wp0gdMhu59nWMqTWd87JiOrouRo0z5IEbYIREJZ
         gq+jXWQ2GJuiEVm7eudx74Ja03tifOT+Izywsvm3hW9EIw7eCWe8BHnGas9SGNG0Cb
         BMhHTZ7DBLBpg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023267.sys.comcast.net with ESMTPA
        id j6toofOVmA6uYj6tuozg6q; Thu, 13 Oct 2022 22:42:02 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekuddgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedtteeljeffgfffveehhfetveefuedvheevffffhedtjeeuvdevgfeftddtheeftdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepjedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghkse
 hsohhlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehmrghrihhushiirdhtkhgrtgiihihksehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghv
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v2 1/3] md/bitmap: Add chunk-threshold unplugging
Date:   Thu, 13 Oct 2022 16:41:49 -0600
Message-Id: <20221013224151.300-2-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221013224151.300-1-jonathan.derrick@linux.dev>
References: <20221013224151.300-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add a mechanism to allow bitmap unplugging and flushing to wait until it
has surpassed a defined threshold of dirty chunks. This allows certain
high I/O write workloads to make good forward progress between bitmap
updates or provide reliable bitmap consistency. The default behavior is
previous behavior of always unplugging when called.

Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 35 +++++++++++++++++++++++++++++++----
 drivers/md/md-bitmap.h |  1 +
 drivers/md/md.h        |  1 +
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..c5c77f8371a8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1004,7 +1004,7 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
-void md_bitmap_unplug(struct bitmap *bitmap)
+static void __md_bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
@@ -1038,6 +1038,33 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		md_bitmap_file_kick(bitmap);
 }
+
+/*
+ * Conditional unplug based on user-defined parameter
+ * Defaults to unconditional behavior
+ */
+void md_bitmap_unplug(struct bitmap *bitmap)
+{
+	unsigned int flush_threshold = bitmap->mddev->bitmap_info.flush_threshold;
+
+	if (!flush_threshold) {
+		__md_bitmap_unplug(bitmap);
+	} else {
+		struct bitmap_page *bp = bitmap->counts.bp;
+		unsigned long pages = bitmap->counts.pages;
+		unsigned long k, count = 0;
+
+		for (k = 0; k < pages; k++)
+			if (bp[k].map && !bp[k].hijacked)
+				count += bp[k].count;
+
+		if (count - bitmap->unplugged_count > flush_threshold) {
+			bitmap->unplugged_count = count;
+			md_bitmap_daemon_work(&bitmap->mddev->daemon_timer);
+			__md_bitmap_unplug(bitmap);
+		}
+	}
+}
 EXPORT_SYMBOL(md_bitmap_unplug);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
@@ -2012,9 +2039,9 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
 				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		md_bitmap_unplug(bitmap);
+		__md_bitmap_unplug(bitmap);
 	}
-	md_bitmap_unplug(mddev->bitmap);
+	__md_bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
 	md_bitmap_free(bitmap);
@@ -2246,7 +2273,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	spin_unlock_irq(&bitmap->counts.lock);
 
 	if (!init) {
-		md_bitmap_unplug(bitmap);
+		__md_bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
 	}
 	ret = 0;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cfd7395de8fd..49a93d8ff307 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -223,6 +223,7 @@ struct bitmap {
 	unsigned long daemon_lastrun; /* jiffies of last run */
 	unsigned long last_end_sync; /* when we lasted called end_sync to
 				      * update bitmap with resync progress */
+	unsigned long unplugged_count; /* last dirty count from md_bitmap_unplug */
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b61..1a558cb18bd4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -501,6 +501,7 @@ struct mddev {
 		int			external;
 		int			nodes; /* Maximum number of nodes in the cluster */
 		char                    cluster_name[64]; /* Name of the cluster */
+		unsigned int		flush_threshold; /* how many dirty chunks between updates */
 	} bitmap_info;
 
 	atomic_t			max_corr_read_errors; /* max read retries */
-- 
2.31.1

