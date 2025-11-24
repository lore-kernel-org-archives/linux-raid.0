Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5522D9492;
	Mon, 24 Nov 2025 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965944; cv=none; b=F4L0m/KVrH7HgtjlIKdlZgLSnWq/oXSfu5pZpnRC3J6+djO5lZpGA6Jq4wJlycFh6sy2+LpHEb3pgCSvk3dwR/hJa2FVC2keNZYvFnG5Ik+uNiHRREN7tNTqq7yr7QRnyM6VEk/W9WA+xEIpSNl3aSShzsa+bEMtMpLqQce4VNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965944; c=relaxed/simple;
	bh=ZW4pAi1LZApvGkKihBfrAqHldizMyv9Uj3UUEC8DFuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCYF8CA0z2kOh9n0xXqZ/kXl1QT67ntGBsIqvnSnHSXByAUSUjbIFG36giHObPYrligPEwqnhTO7p2qVT5kM/Ar1JPWKUJN/OJjr0ISBngMqpdZNu8YjOzwQJAqOij6Dn/GGCwQiqdkeathALfFSFkXIK6GveYbr9TqzXO4Dpfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F5EC116C6;
	Mon, 24 Nov 2025 06:32:22 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 08/11] md/raid5: align bio to io_opt
Date: Mon, 24 Nov 2025 14:32:00 +0800
Message-ID: <20251124063203.1692144-9-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
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
index 0b607aa5963e..bbcb1c06951c 100644
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
@@ -7814,8 +7813,7 @@ static int raid5_set_limits(struct mddev *mddev)
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

