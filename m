Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C612B94;
	Wed,  8 Jan 2025 19:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736364192; cv=none; b=eI6G0bVxUTQS28sBaDvszHKdJ4veAmzUkkznj0eZa2b+pp8oDF0SW+yjDzJK6xCtJnYo0Ay9+rzkIXT3gJ3cFXBr9WR1VBWmsGxm7SA3GHVJ2WQclc3VDEGysBnqc2Ci2OnTdGJ9zo7mvYQR7gQiQQ/Uw4BKdPzIFUiTNVDHvLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736364192; c=relaxed/simple;
	bh=b8+uiyyDPvlx8z1E0aCUVRO3dcFU2f6fw0TozTb95TY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ce3AdO3xv7BKN0h7k9kSnM6i0fD5Shd+s4DsQKBjERHfcu7WkrP+ZmDP4KzttNfNPyNSzEsw26sv2WRCcK8iioJbORyFY6FgcBwr08Z58qXyPkQebMka+3LO0q4eR2kTk8ksvJaMJx54HNgxNTbASPJhi2ZgswbeP7QrlsKqYAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidreaver.com; spf=pass smtp.mailfrom=davidreaver.com; dkim=pass (2048-bit key) header.d=davidreaver.com header.i=@davidreaver.com header.b=DlnyGcdA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f1aAoOiJ; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidreaver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidreaver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidreaver.com header.i=@davidreaver.com header.b="DlnyGcdA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f1aAoOiJ"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E55B11140216;
	Wed,  8 Jan 2025 14:23:08 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 08 Jan 2025 14:23:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=davidreaver.com;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1736364188; x=1736450588; bh=o+nya6VDwH
	qFSi7sd0j61y/ptdNvO2J7O7Drsh2TXZs=; b=DlnyGcdAwlpvy8p4h/mpmjFfE4
	sLhEWDIok3nU+OdIjweEgrgm54K6rxMiFLsnxCJ0jdoaTOkrBpIAj50dfmE0ZGNJ
	m0djteb7h8ZrMLMRW7MlQo7u8m62BLQK4kWOIrLIrAdqXgnMHJddnQkBFK+bqL8j
	K56ZR9OlxIbpLVN2FrW1jW55+Rr2gTpmFxRUIVU+n5yANOXb+Aj506Fy97J44p0r
	4TwQ/qlB0z1xDQKnkpl3tHK9QP72bMO+Q81zbrTtQU/cN+W1aZbv9pmTkOIdUFdn
	kHh5gVAb5vs60MT2fJkpaQFvVXk0Nt+kFyqCTTQQg66vzmocRcCXXbkaeqcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1736364188; x=1736450588; bh=o+nya6VDwHqFSi7sd0j61y/ptdNvO2J7O7D
	rsh2TXZs=; b=f1aAoOiJtN5OfS62Khk6sgvD0tS8hNOywefP7J8+Fq3S38Gi1Ne
	tw0WQ/fNDYTEC+7+W9iRm8CTzC/599qNb42nrAKbTKJP+wAURJsKSzaGRBVgkOxZ
	hpnOzilxAPIxxl/VInclEKURM+AqpF1NV4V+MHE5CwcMRAgDKSp4ux0LCR9q+ngX
	P/1msthLRsWRhASHh62U2z4H7HihjMv/p7xHQSSY4HTgMBcBPbUjzxSbaeCN/yS+
	p5U6y7J30GtK8CwaEwnTgBFlDk/vtuSD+GSaA7LonXrx5ZTywf6ZtimevS2fyp8r
	dnBjOClsP7L3Vxq3CSgH/XbCT1MFcn/wV1g==
X-ME-Sender: <xms:m9B-ZyBeJ6yImOj7bn9OvyI7mhaB-eAu855LdTITyqpPkmBP2jqELQ>
    <xme:m9B-Z8jvyXjgBMd1tQvX71_jWriscc7Y7jg-_t-9SL9NmhFrBPc-TuZ_NzWMUsVeP
    _U8CC3fJpRbZNO9P1w>
X-ME-Received: <xmr:m9B-Z1kgKU-QXCx-FtJ52lbYPTl8wHXDC5eCzGjNcG-Q0VhsmegqNxzdbMbm8uIDkV1VzXJXtDC000SApsvyzatEWzOjPG64Stbk3UkKlM51whY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeggedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecu
    hfhrohhmpeffrghvihguucftvggrvhgvrhcuoehmvgesuggrvhhiughrvggrvhgvrhdrtg
    homheqnecuggftrfgrthhtvghrnhepveejgfeufffgledviefgfefgvdethfduvdehfeef
    gefgjeetlefhgeevvdfhfeelnecuffhomhgrihhnpehlfihnrdhnvghtpdhkvghrnhgvlh
    drohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehmvgesuggrvhhiughrvggrvhgvrhdrtghomhdpnhgspghrtghpthhtohepkedpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopeihuhhkuhgrihefsehhuhgrfigvihdrtghomhdprhgtphhtthhopehmvgesug
    grvhhiughrvggrvhgvrhdrtghomhdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkjhhlgiesthgvmhhplhgvohhf
    shhtuhhpihgurdgtohhmpdhrtghpthhtohepihhrrgdrfigvihhnhiesihhnthgvlhdrtg
    homhdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:nNB-ZwwoguxNNyxoNkxxYd5R4tqU3ZKa5k2SmvgC_OjJbz09Ojhpgw>
    <xmx:nNB-Z3SZuTKlEmqzPm23eAs22IR-SKb7is-qHRAIC1Zc5TcO02xPaA>
    <xmx:nNB-Z7Yqu-jY2a2q3uY08kJkTF_AHTAOc2_j33KNqppTv4q4Ytwn5g>
    <xmx:nNB-ZwRFdubxBvIZPZhl2LYWZr1PEpTA-KNQqaKyinLf3BNqOVLhIg>
    <xmx:nNB-ZyHRtKvv9YdCC3HT6N2EXzVo-1W_A9vttVX1nMzyalqi6yyCYfS4>
Feedback-ID: i67e946c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jan 2025 14:23:06 -0500 (EST)
From: David Reaver <me@davidreaver.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: David Reaver <me@davidreaver.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Krister Johansen <kjlx@templeofstupid.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] md: Replace deprecated kmap_atomic() with kmap_local_page()
Date: Wed,  8 Jan 2025 11:21:30 -0800
Message-ID: <20250108192131.46843-1-me@davidreaver.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmap_atomic() is deprecated and should be replaced with kmap_local_page()
[1][2]. kmap_local_page() is faster in kernels with HIGHMEM enabled, can
take page faults, and allows preemption.

According to [2], this is safe as long as the code between kmap_atomic()
and kunmap_atomic() does not implicitly depend on disabling page faults or
preemption. It appears to me that none of the call sites in this patch
depend on disabling page faults or preemption; they are all mapping a page
to simply extract some information from it or print some debug info.

[1] https://lwn.net/Articles/836144/
[2] https://docs.kernel.org/mm/highmem.html#temporary-virtual-mappings

Signed-off-by: David Reaver <me@davidreaver.com>
---
 drivers/md/md-bitmap.c   | 42 ++++++++++++++++++++--------------------
 drivers/md/raid5-cache.c | 16 +++++++--------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 29da10e6f703..1f8772b3b66c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -682,7 +682,7 @@ static void bitmap_update_sb(void *data)
 		return;
 	if (!bitmap->storage.sb_page) /* no superblock */
 		return;
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
@@ -702,7 +702,7 @@ static void bitmap_update_sb(void *data)
 	sb->nodes = cpu_to_le32(bitmap->mddev->bitmap_info.nodes);
 	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->
 					   bitmap_info.space);
-	kunmap_atomic(sb);
+	kunmap_local(sb);

 	if (bitmap->storage.file)
 		write_file_page(bitmap, bitmap->storage.sb_page, 1);
@@ -717,7 +717,7 @@ static void bitmap_print_sb(struct bitmap *bitmap)

 	if (!bitmap || !bitmap->storage.sb_page)
 		return;
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
 	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
@@ -736,7 +736,7 @@ static void bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 }

 /*
@@ -760,7 +760,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 		return -ENOMEM;
 	bitmap->storage.sb_index = 0;

-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);

 	sb->magic = cpu_to_le32(BITMAP_MAGIC);
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
@@ -768,7 +768,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	chunksize = bitmap->mddev->bitmap_info.chunksize;
 	BUG_ON(!chunksize);
 	if (!is_power_of_2(chunksize)) {
-		kunmap_atomic(sb);
+		kunmap_local(sb);
 		pr_warn("bitmap chunksize not a power of 2\n");
 		return -EINVAL;
 	}
@@ -803,7 +803,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	bitmap->mddev->bitmap_info.nodes = 0;

-	kunmap_atomic(sb);
+	kunmap_local(sb);

 	return 0;
 }
@@ -865,7 +865,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		return err;

 	err = -EINVAL;
-	sb = kmap_atomic(sb_page);
+	sb = kmap_local_page(sb_page);

 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -932,7 +932,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	err = 0;

 out:
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
 		/* Assigning chunksize is required for "re_read" */
 		bitmap->mddev->bitmap_info.chunksize = chunksize;
@@ -1161,12 +1161,12 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	bit = file_page_offset(&bitmap->storage, chunk);

 	/* set the bit */
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set_bit(bit, kaddr);
 	else
 		set_bit_le(bit, kaddr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, index);
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_DIRTY);
@@ -1190,12 +1190,12 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	if (!page)
 		return;
 	bit = file_page_offset(&bitmap->storage, chunk);
-	paddr = kmap_atomic(page);
+	paddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		clear_bit(bit, paddr);
 	else
 		clear_bit_le(bit, paddr);
-	kunmap_atomic(paddr);
+	kunmap_local(paddr);
 	if (!test_page_attr(bitmap, index - node_offset, BITMAP_PAGE_NEEDWRITE)) {
 		set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
@@ -1214,12 +1214,12 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 	if (!page)
 		return -EINVAL;
 	bit = file_page_offset(&bitmap->storage, chunk);
-	paddr = kmap_atomic(page);
+	paddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set = test_bit(bit, paddr);
 	else
 		set = test_bit_le(bit, paddr);
-	kunmap_atomic(paddr);
+	kunmap_local(paddr);
 	return set;
 }

@@ -1387,9 +1387,9 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			 * If the bitmap is out of date, dirty the whole page
 			 * and write it out
 			 */
-			paddr = kmap_atomic(page);
+			paddr = kmap_local_page(page);
 			memset(paddr + offset, 0xff, PAGE_SIZE - offset);
-			kunmap_atomic(paddr);
+			kunmap_local(paddr);

 			filemap_write_page(bitmap, i, true);
 			if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
@@ -1405,12 +1405,12 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		void *paddr;
 		bool was_set;

-		paddr = kmap_atomic(page);
+		paddr = kmap_local_page(page);
 		if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 			was_set = test_bit(bit, paddr);
 		else
 			was_set = test_bit_le(bit, paddr);
-		kunmap_atomic(paddr);
+		kunmap_local(paddr);

 		if (was_set) {
 			/* if the disk bit is set, set the memory bit */
@@ -1545,10 +1545,10 @@ static void bitmap_daemon_work(struct mddev *mddev)
 		bitmap_super_t *sb;
 		bitmap->need_sync = 0;
 		if (bitmap->storage.filemap) {
-			sb = kmap_atomic(bitmap->storage.sb_page);
+			sb = kmap_local_page(bitmap->storage.sb_page);
 			sb->events_cleared =
 				cpu_to_le64(bitmap->events_cleared);
-			kunmap_atomic(sb);
+			kunmap_local(sb);
 			set_page_attr(bitmap, 0,
 				      BITMAP_PAGE_NEEDWRITE);
 		}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b4f7b79fd187..7a22cb2e5ac3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1023,10 +1023,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 			continue;
-		addr = kmap_atomic(sh->dev[i].page);
+		addr = kmap_local_page(sh->dev[i].page);
 		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
 						    addr, PAGE_SIZE);
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
@@ -1979,9 +1979,9 @@ r5l_recovery_verify_data_checksum(struct r5l_log *log,
 	u32 checksum;

 	r5l_recovery_read_page(log, ctx, page, log_offset);
-	addr = kmap_atomic(page);
+	addr = kmap_local_page(page);
 	checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 	return (le32_to_cpu(log_checksum) == checksum) ? 0 : -EINVAL;
 }

@@ -2381,11 +2381,11 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				payload->size = cpu_to_le32(BLOCK_SECTORS);
 				payload->location = cpu_to_le64(
 					raid5_compute_blocknr(sh, i, 0));
-				addr = kmap_atomic(dev->page);
+				addr = kmap_local_page(dev->page);
 				payload->checksum[0] = cpu_to_le32(
 					crc32c_le(log->uuid_checksum, addr,
 						  PAGE_SIZE));
-				kunmap_atomic(addr);
+				kunmap_local(addr);
 				sync_page_io(log->rdev, write_pos, PAGE_SIZE,
 					     dev->page, REQ_OP_WRITE, false);
 				write_pos = r5l_ring_add(log, write_pos,
@@ -2888,10 +2888,10 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)

 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
-		addr = kmap_atomic(sh->dev[i].page);
+		addr = kmap_local_page(sh->dev[i].page);
 		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
 						    addr, PAGE_SIZE);
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 		pages++;
 	}
 	WARN_ON(pages == 0);
