Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7C30E0DF
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 04:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192176; cv=none; b=nb/4D149FuSiLeKOETQmZDQPYH1ZB34h7iXNPiQ1EuG5Nvzs3kBgkV3IFsxDqZu1W4bZ7FUphO1q8TKMGLBfVIjhDBTf4R8v4uB/RmSrwIkX/PJpA62BMOCZmVZ8zpi6OQguM/UjmDA1sacokRxI6Azoo6cK/11u5QVW5UZ4X8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192176; c=relaxed/simple;
	bh=aedvWl2UHXJ1FS4PqDkEcCNvc4f602nSGiEfpgJaBdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eytLz1wSaVfZFm5689flatHbts2g4srG7bZJ5vb1XeFYRFfHCJzIwo75aBQf25UwlRm1JP90s0ZlDlEm9V5SI6MdaPRZENYH/nGRuDyWtHhYuxN0N5SuCephKUctnlY5eRjrq7FumnfhZeiYe0oQy2UN9EK+43tz7OUIfTX8yYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55438C19423;
	Mon, 12 Jan 2026 04:29:33 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v4 08/11] md/raid5: align bio to io_opt
Date: Mon, 12 Jan 2026 12:28:54 +0800
Message-ID: <20260112042857.2334264-9-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112042857.2334264-1-yukuai@fnnas.com>
References: <20260112042857.2334264-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid5 internal implementaion indicates that if write bio is aligned to
io_opt, then full stripe write will be used, which will be best for
bandwidth because there is no need to read extra data to build new
xor data.

Simple test in my VM, 32 disks raid5 with 64kb chunksize:
dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct

Before this patch:  782 MB/s
With this patch:    1.1 GB/s

BTW, there are still other bottleneck related to stripe handler, and
require further optimization.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid5.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 30a7069cbd0c..0160cbed7389 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -59,8 +59,7 @@
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_FAILFAST_SUPPORTED) |	\
 	 (1L << MD_FAILLAST_DEV) |		\
-	 (1L << MD_SERIALIZE_POLICY) |		\
-	 (1L << MD_BIO_ALIGN))
+	 (1L << MD_SERIALIZE_POLICY))
 
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
@@ -7817,8 +7816,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	 * Limit the max sectors based on this.
 	 */
 	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
-	if ((lim.max_hw_sectors << 9) < lim.io_opt)
-		lim.max_hw_sectors = lim.io_opt >> 9;
+	md_config_align_limits(mddev, &lim);
 
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
-- 
2.51.0

