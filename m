Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1963F8EC7;
	Mon, 25 May 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729590; cv=none; b=Nrk/ThGZ1BeoTxPXWRqWwjB/uedS4UXJAF+pQL9ne6W/KD5fW1MAvoxzyRd6u0OBbY6k6fbpGSd4gqyegJ51M5OPx//H65mYYKczGk07fZbJpI4mZ4v14dO0Pk5c1geQEgeEsLSouW8taS54NtQHQGaBSg0clG6wD3DeJC/8fkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729590; c=relaxed/simple;
	bh=850MaLvS6lqq/nqImrkb7lCtr8xr/sS+O41HQ2eQI5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQsstmoqrDcS4vqOBom7otenptncp2etGGIPDe+9fFvFxEeyNsLr9vvQj6Tu9sauXtKk+XfiTBhznV5HD75ngqgb262sMMdS/slPCW289VcmwDHvhaIu2lKk4kqgFwjtxgRHo7mMfwFxZksc+0YQDHExdL1GNOLvhYOFXwxZRKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWMPZ/Dh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWMPZ/Dh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=FoJuu0JZoCze6AxjTAKfuI9Ll3XB2e4mHDDyVDRKF44=; b=mWMPZ/DhNtbY7gq0ybCXzi5QBT
	zfXRpbRXzdLULBtlyE9kU1TZvRMojp9jeIQxvie0BEgPLTzS4U1l5oXKlM+8VVyebRgsLIoMbDwJI
	YNKJN9AYvD977Z0un6e6s37czm3njUGBxZZdfVyDAxEUtZRW3V/YwHt0jC2z9OaPV/kFXr01evffd
	/tvAa/ei7UNEJaMQo6yeE3AEaqMdDk36Sp19ZDKJMPD0+iJQKoQbcvD9C3pDnFYzMuRRlQjMiCGdV
	0hORi34IT6Fm9p3SwPTFjb9lQn0WCO8VdsXIM5EBpxyLGaKzYzcEjK6H4O0SK3LEduaH5/XoNy1aK
	zUCwRjkg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxt-0000000HODJ-2nTa;
	Mon, 25 May 2026 17:19:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 30/34] md-bitmap: Convert read_file_page and write_file_page to bh_submit()
Date: Mon, 25 May 2026 18:19:23 +0100
Message-ID: <20260525171931.4144395-31-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/md-bitmap.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52..c0a4559186e2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -502,6 +502,18 @@ static void write_sb_page(struct bitmap *bitmap, unsigned long pg_index,
 static void md_bitmap_file_kick(struct bitmap *bitmap);
 
 #ifdef CONFIG_MD_BITMAP_FILE
+static void end_bitmap_write(struct bio *bio)
+{
+	bool uptodate = bio->bi_status == BLK_STS_OK;
+	struct buffer_head *bh = bio_endio_bh(bio);
+	struct bitmap *bitmap = bh->b_private;
+
+	if (!uptodate)
+		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
+	if (atomic_dec_and_test(&bitmap->pending_writes))
+		wake_up(&bitmap->write_wait);
+}
+
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	struct buffer_head *bh = page_buffers(page);
@@ -510,7 +522,7 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 		atomic_inc(&bitmap->pending_writes);
 		set_buffer_locked(bh);
 		set_buffer_mapped(bh);
-		submit_bh(REQ_OP_WRITE | REQ_SYNC, bh);
+		bh_submit(bh, REQ_OP_WRITE | REQ_SYNC, end_bitmap_write);
 		bh = bh->b_this_page;
 	}
 
@@ -519,16 +531,6 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 			   atomic_read(&bitmap->pending_writes) == 0);
 }
 
-static void end_bitmap_write(struct buffer_head *bh, int uptodate)
-{
-	struct bitmap *bitmap = bh->b_private;
-
-	if (!uptodate)
-		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
-	if (atomic_dec_and_test(&bitmap->pending_writes))
-		wake_up(&bitmap->write_wait);
-}
-
 static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
@@ -592,12 +594,11 @@ static int read_file_page(struct file *file, unsigned long index,
 			else
 				count -= blocksize;
 
-			bh->b_end_io = end_bitmap_write;
 			bh->b_private = bitmap;
 			atomic_inc(&bitmap->pending_writes);
 			set_buffer_locked(bh);
 			set_buffer_mapped(bh);
-			submit_bh(REQ_OP_READ, bh);
+			bh_submit(bh, REQ_OP_READ, end_bitmap_write);
 		}
 		blk_cur++;
 		bh = bh->b_this_page;
-- 
2.47.3

