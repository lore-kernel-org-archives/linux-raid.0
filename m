Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F840DFDB;
	Thu,  9 Apr 2026 05:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775712159; cv=none; b=LwSF+AppnJ4fDfQyU/MJjjf39yfRkTYitELcOIGs8wCNLI9X+tWPUy6vP7E2/GPd2Fo+evmA7sW5QfU/JfNDcen1qS8oy0F3o6zUpF4u9dfT3LHjK9gdllF45cpn9UevI22RwI7mfb43wghzv9waDAnCz7g7WaCOs/+dqKGTfww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775712159; c=relaxed/simple;
	bh=FIPJ0NEyBEc26V5aLXrqhdsiTTV4Z0yy5R0CZ1LAy2o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=tw7Qss5RwPPC6UmxYYdGqfJUj1gJ3fN/3GZyPKAfyBcRZlLpvZLbNpwaoF/QFd6EfdYEvtgnWEeB3YWz25AtvTrkvc76ZXzZYA1Ek9SQcPckYFeTOZyiPFcfdxTE++NXAz1F1AKALwLC4FFMJXKtoejnCcqD4AHDvs9iB/XJvK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=DPfx7pZa; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="DPfx7pZa"
Received: from localhost.localdomain (unknown [10.17.211.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4frpGZ0qJRzHqtbtR;
	Thu,  9 Apr 2026 13:22:30 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1775712150; bh=FIPJ0NEyBEc26V5aLXrqhdsiTTV4Z0yy5R0CZ1LAy2o=;
	h=From:To:Cc:Subject:Date;
	b=DPfx7pZaKHKJF4NeVyWx2wFthtLQXaool6A787Cpge/gUJDAWx8YKY8qq7qBQSfas
	 +GcpVd9Z5SYqKkJjgQoz/gvJAEUmEXsioWiRm+xSPHczDcm8RR4P205Xi0keZKxxqk
	 I8x+8F5lfIwhf7K+mImr9ufc5iR+cPtOR0kXcQbM=
From: FengWei Shih <dannyshih@synology.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linan122@huawei.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	FengWei Shih <dannyshih@synology.com>
Subject: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
Date: Thu,  9 Apr 2026 13:17:22 +0800
Message-Id: <20260409051722.2865321-1-dannyshih@synology.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

raid5_make_request() checks mddev->reshape_position to decide whether
to allow chunk-aligned reads. However in raid5_start_reshape(), the
layout configuration (raid_disks, algorithm, etc.) is updated before
mddev->reshape_position is set:

  reshape (raid5_start_reshape)        read (raid5_make_request)
  ==============================       ===========================
  write_seqcount_begin
  update raid_disks, algorithm...
  set conf->reshape_progress
  write_seqcount_end
                                        check mddev->reshape_position
                                          * still MaxSector, allow
                                        raid5_read_one_chunk()
                                          * use new layout
  raid5_quiesce()
  set mddev->reshape_position

Since reshape_position is not yet updated, raid5_make_request()
considers no reshape is in progress and proceeds with the
chunk-aligned path, but the layout has already changed, causing
raid5_compute_sector() to return an incorrect physical address.

Fix this by reading conf->reshape_progress under gen_lock in
raid5_read_one_chunk() and falling back to the stripe path if a
reshape is in progress.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..bded2b86f0ef 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	sector_t sector, end_sector;
 	int dd_idx;
 	bool did_inc;
+	int seq;
+
+	seq = read_seqcount_begin(&conf->gen_lock);
+	if (unlikely(conf->reshape_progress != MaxSector))
+		return 0;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
 		pr_debug("%s: non aligned\n", __func__);
@@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 				      &dd_idx, NULL);
 	end_sector = sector + bio_sectors(raid_bio);
 
+	if (read_seqcount_retry(&conf->gen_lock, seq))
+		return 0;
+
 	if (r5c_big_stripe_cached(conf, sector))
 		return 0;
 
-- 
2.25.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
