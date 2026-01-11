Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3251334F462
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768156039; cv=none; b=CYG/USdUrJLhDa2KrKb0B6U7doGWLtMGqENB2Kw2ZCH6I2OSxV6TDOmxfsSVvzWyYzQqwrEvTMm7K5h7Uc66f3SfFC/a1RW2g39XszEhkVDSt8D7p+3LIBhbPcCn1R/qAgHaajuuWAOXpmHBcYJts2kmxVZSkSLBDv9IEvVkP1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768156039; c=relaxed/simple;
	bh=aedvWl2UHXJ1FS4PqDkEcCNvc4f602nSGiEfpgJaBdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqQn9jjhPEJGKyD36eR90Ud3aOAjJoKm1lvMCGHjtYmlFovNeJX0tqy00qOCxNN/VAsZgIXws3WQPIKRrczqk422diPByBqBiTUNruK4fLums/QtOeXIMy53R667UFtUbPnkghPUCdwd2zjoX3LtLxXyb9YvG2zCLRhbyPf5GR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9BAC4CEF7;
	Sun, 11 Jan 2026 18:27:16 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v3 08/11] md/raid5: align bio to io_opt
Date: Mon, 12 Jan 2026 02:26:48 +0800
Message-ID: <20260111182651.2097070-9-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111182651.2097070-1-yukuai@fnnas.com>
References: <20260111182651.2097070-1-yukuai@fnnas.com>
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

