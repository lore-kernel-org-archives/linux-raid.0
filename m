Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CCD3FF1B1;
	Thu, 28 May 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989524; cv=none; b=VM8PL4Br5l6ee4k+3zxTS3ueg7DmvXcjYZ8zIediqehtpsm2lwvQ0VDX3QBJGLcFyRFTDghCT7sFOihs0MV+/4ZiJtH67ZajDyDz9cYpF2M1soxfmN9+zGHlGfyquY1LrUHJEfWYeh88wT5U90RYpZiCXRE9JY7GVcuy75CFA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989524; c=relaxed/simple;
	bh=SzMS9LEpdkQ6cMGj8G9iDkS0Ty05ZWFqs322J8ebLbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyq8aKy3w+5lSZQmlV6QT7efpzEg2g8bkCYeROs5FYA3hzkQId0HiUFahF7oQ6Ua+eaizonAmeFN4N4nv8H0HoHnwRJpASw60bMTkD7jcoZA8tPjzLe7UyFstnmIAILMJL9lVZW8B25RLPj3/sS0u3jCpFfpO/bdZAsoM16gap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SW5PdkDr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SW5PdkDr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Xw4oW2uGNm8P/cZNk+OjpJqdmTXKB0NFPSKrisQo1d8=; b=SW5PdkDrV2q7jt29dd2bFVqAjR
	eSNxo2c787FJs49sIbGx4gNOqGEI99nZMj2rwClL1r/HoIRj7rZA+tchbnoztb/At+s6lgxFOga8Y
	AlsQkaxDjAD4vjeg9+VwIkGaL876FnrzViDQW5/PQmTOvJxcmkKVGO2W2rKxyR4jofZntEtxeC3ZA
	5hZJP8ALYtWowsqHUC4hglmOzMvShf4khdDMHrugicgj7hTGvGTL3f9DQAmhFXyW2WjONw6K2LHaT
	AqVlt2HncrvNy9Wot0aUqkN/1Yl+qphalr5X95jo5GudxMMaIek3D/r6ThX+lUro/vD1BCuR65wWi
	btSe8VWw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaM-00000004abO-0olV;
	Thu, 28 May 2026 17:31:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH v2 30/34] md-bitmap: Convert read_file_page and write_file_page to bh_submit()
Date: Thu, 28 May 2026 18:31:43 +0100
Message-ID: <20260528173150.1093780-31-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
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
index 028b9ca8ce52..7d778fe1c47c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -502,6 +502,18 @@ static void write_sb_page(struct bitmap *bitmap, unsigned long pg_index,
 static void md_bitmap_file_kick(struct bitmap *bitmap);
 
 #ifdef CONFIG_MD_BITMAP_FILE
+static void end_bitmap_write(struct bio *bio)
+{
+	struct buffer_head *bh;
+	bool uptodate = bio_endio_bh(bio, &bh);
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

