Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E312D7C0BA
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708690297; cv=none; b=R0HR7f/mT7uifYkgWmXtbqD9jN3ZwuESyccbKOySVXqLj42vhlDNGkcvUQwO+7he6/E98uCmUCVtKfqA4iYCN8A15fWqHXhzC7jfd9ENU8vLWc9GEsms0AeX5ifMQPoA5tFYwI2PFvi8CLy+GRuR4xX4U/GV+6O0Bjw4KLFstZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708690297; c=relaxed/simple;
	bh=vJ1na4VMkRu2qJBkpZBoyzFuf9socXJiNWKJei8J5FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SL3mWJLqelqJyCKgOY1czIeZUowjkQQH0Wld+RBXLebTrG5yV9dCCnmh4xn3ThQWlNR5s8aOedTi8WW77PbV5vThNqKrxGQFJpRR9Ebwa8AejbrDvcU1DY1qd9Rt/ZRVzUefP9Fq/0LvkzJgemu4Ifx1iiSFjRu7A8Ipsc/hZ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=W5F2Sr6l; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eHkxmqsS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="W5F2Sr6l";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eHkxmqsS"
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::10f6])
	by smtp-out1.suse.de (Postfix) with ESMTP id D48B321E9E;
	Fri, 23 Feb 2024 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1708690294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rwQmIXOlzU6DtEJaJKPoWBahJpt8uufnR9ot37G0m6c=;
	b=W5F2Sr6lkqStDo28it6p7mFSDCc0BRzAJLr5O4b9Y6TaPU2ovE96nYxzgcWPJNiglx6Sj7
	VhWUzqhFTWpqaf2szmrE2mHyawpTHYAwtbl+25Oh67KHxfjQYeZLSaeNHFwZHsLcpv9Mou
	3VAMREhTHx0C9fdPYHiozjPb1LJMbaE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1708690293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rwQmIXOlzU6DtEJaJKPoWBahJpt8uufnR9ot37G0m6c=;
	b=eHkxmqsSd2fijDxaIz/WZp8Qd1CH/Db0YyZPBPkeVZ6tTLDwINmN3ikxnK3bxsBjJY14c8
	ZL1KUEEY+qPiV7orHTROC2b3amAcgveJymacd8DLFm1R0WcDs9bDn5uzhXdTirEx8gkZXG
	G76aiM/BEemtlpa6mzkuZ6vUucNusF4=
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	guoqing.jiang@linux.dev,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-raid@vger.kernel.org,
	colyli@suse.de,
	hare@suse.de
Subject: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
Date: Fri, 23 Feb 2024 20:11:28 +0800
Message-Id: <20240223121128.28985-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eHkxmqsS
X-Spamd-Result: default: False [24.79 / 50.00];
	 RDNS_NONE(1.00)[];
	 BAYES_SPAM(5.10)[100.00%];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 HFILTER_HELO_IP_A(1.00)[localhost.localdomain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 HFILTER_HELO_NORES_A_OR_MX(0.30)[localhost.localdomain];
	 DKIM_TRACE(0.00)[suse.com:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 DIRECT_TO_MX(0.00)[git-send-email 2.35.3];
	 ONCE_RECEIVED(1.20)[];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	 SPAM_FLAG(5.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 ONCE_RECEIVED_STRICT(4.00)[];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	 GREYLIST(0.00)[pass,body]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: 24.79
X-Rspamd-Queue-Id: D48B321E9E
X-Spam-Level: ************************
X-Spam-Flag: YES
X-Spamd-Bar: ++++++++++++++++++++++++
X-Spam: Yes

Commit d7038f951828 ("md-bitmap: don't use ->index for pages backing the
bitmap file") removed page->index from bitmap code, but left wrong code
logic for clustered-md. current code never set slot offset for cluster
nodes, will sometimes cause crash in clustered env.

Call trace (partly):
 md_bitmap_file_set_bit+0x110/0x1d8 [md_mod]
 md_bitmap_startwrite+0x13c/0x240 [md_mod]
 raid1_make_request+0x6b0/0x1c08 [raid1]
 md_handle_request+0x1dc/0x368 [md_mod]
 md_submit_bio+0x80/0xf8 [md_mod]
 __submit_bio+0x178/0x300
 submit_bio_noacct_nocheck+0x11c/0x338
 submit_bio_noacct+0x134/0x614
 submit_bio+0x28/0xdc
 submit_bh_wbc+0x130/0x1cc
 submit_bh+0x1c/0x28

Fixes: d7038f951828 ("md-bitmap: don't use ->index for pages backing the bitmap file")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9672f75c3050..a4976ceae868 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -234,7 +234,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	sector_t doff;
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
-	if (pg_index == store->file_pages - 1) {
+	/* we compare length (page numbers), not page offset. */
+	if ((pg_index - store->sb_index) == store->file_pages - 1) {
 		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)
@@ -438,8 +439,8 @@ static void filemap_write_page(struct bitmap *bitmap, unsigned long pg_index,
 	struct page *page = store->filemap[pg_index];
 
 	if (mddev_is_clustered(bitmap->mddev)) {
-		pg_index += bitmap->cluster_slot *
-			DIV_ROUND_UP(store->bytes, PAGE_SIZE);
+		/* go to node bitmap area starting point */
+		pg_index += store->sb_index;
 	}
 
 	if (store->file)
@@ -952,6 +953,7 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long index = file_page_index(store, chunk);
 	unsigned long node_offset = 0;
 
+	index += store->sb_index;
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
 
@@ -982,6 +984,7 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long index = file_page_index(store, chunk);
 	unsigned long node_offset = 0;
 
+	index += store->sb_index;
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
 
-- 
2.35.3

