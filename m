Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587F30E844
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455189; cv=none; b=i1AP23Uqzosn8gj/OWbCb1pqDq6uOo0a7SYmWn22PWohkGIQM0eO725vpfTlDaOAMWyK2GkHcYmWGm+/x6PEwE6DlLA7geXortOZJrXDxU+B2d1LiXNFeXlx0BnqbRxPV0H+rwl/wh9MK/uMwsOzWBM2LUDrZFZO5QWUeN/dq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455189; c=relaxed/simple;
	bh=LsqOYb9AV3vgbSJbmShqUrqoDT3WYSvBiDrW2kIIeiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npZDWY7VuJqXFXYArzDpSJQtbNq9TNOXnD3hn5d5vkfUjnOjvsc7n6S5m/swXCUdz9n42HD2mt8lP4sED6o51rnvqhcKdUS/+rhxHQAzoB05qtS2kY05+Qai/L2DMT222k05zRMNqiIPD+ty3ORN4GKLf7dmANtMK8MduKX/pgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B507C116C6;
	Sat,  3 Jan 2026 15:46:23 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 08/11] md/raid5: align bio to io_opt
Date: Sat,  3 Jan 2026 23:45:40 +0800
Message-ID: <20260103154543.832844-9-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
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
---
 drivers/md/raid5.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 005a2404de27..69a5eb02b891 100644
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
@@ -7818,8 +7817,7 @@ static int raid5_set_limits(struct mddev *mddev)
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

