Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB52F7AC0;
	Fri, 21 Nov 2025 05:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702058; cv=none; b=P790OFLopvsU/tgi9vffHzkRvs8PZejDcR6vICRL1JY9yTGtLhwSeN9+M0iB9OcgrF1KG7kMj6RLjHAwXbbrtTzCpGzK03gCbZ1Ch3WfutQWZWneszWQc2SVWi6E/nFmp5Ew406kfNRXBXRLmis7gSadg10o1wwvQ4fRarTVeWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702058; c=relaxed/simple;
	bh=JonqufBwustNHiKnuFEj+bemyGyDGnChMvxlDXMgQDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK6SWKYB1a1dPIlTVKXSKJvJNTOoSXtQlUzxiRrjEODE0zgge+CeT+G6BfaAUY3pFplAuel3P6zG+pt/SuiTcfnJur4px9mqhfM37HsHMd5DKepiQXn+doKWRXWuL+hI3kIs5qTO92lTXgfzsqp4fpNXF5jSqlCUTePmH22N7v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2883C116D0;
	Fri, 21 Nov 2025 05:14:16 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 4/7] md: add a helper md_config_align_limits()
Date: Fri, 21 Nov 2025 13:14:03 +0800
Message-ID: <20251121051406.1316884-6-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121051406.1316884-1-yukuai@fnnas.com>
References: <20251121051406.1316884-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This helper will be used by personalities that want to align bio to
io_opt to get best IO bandwidth.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1ed90fd85ac4..c8190cf02701 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1088,6 +1088,17 @@ static inline bool rdev_blocked(struct md_rdev *rdev)
 	return false;
 }
 
+static inline void md_config_align_limits(struct mddev *mddev,
+					  struct queue_limits *lim)
+{
+	if ((lim->max_hw_sectors << 9) < lim->io_opt)
+		lim->max_hw_sectors = lim->io_opt >> 9;
+	else
+		lim->max_hw_sectors = rounddown(lim->max_hw_sectors,
+						lim->io_opt >> 9);
+	mddev->bio_align_to_limits = true;
+}
+
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
 	if (!mddev_is_dm(mddev))					\
-- 
2.51.0

