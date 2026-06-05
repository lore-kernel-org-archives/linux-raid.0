Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A363F8252;
	Fri,  5 Jun 2026 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650957; cv=none; b=SvjIQA5ye06JQWybCvbXyOInbGDpq1nlE8SqTW3d13/WQWjgSR3gpVMUf+oBijCpP2ZY51yyXytZR1CgqD43YCYzcfXurkpU7vcu3f0vbUYcQVCFUxdC5pl29d5yMxJ8+Mo/K37WmKt6cSdShHR4FHTN1WkmzumL4ECl+dSmvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650957; c=relaxed/simple;
	bh=NJxR9SZcDLEhu4CRWxS9lDjThattE+RZYFGfBa02tyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWpfW3bbFFU4Xl6sXqB7FN7mDUni41mK9vnHdiHPSh4z4E/nsFkAc0Y4v3fPwIBBEflCABYbSQn0AHANzDm3Ag/JQZNn6ccDRJ/SslyIoNMAWbYQsiVwI/J/V8ayuX431CKRebAz+mAXn2q5LW8R4bo05GpoWkhatfYxTFsn9z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2hXS8YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2hXS8YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332BF1F00893;
	Fri,  5 Jun 2026 09:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650955;
	bh=r1YacQkNNEo6/tNaaOmbd48k+alP26HH8pc4ByItFDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2hXS8YHY7VbrB7xPkMZxyrA/CRVAzMqo+V49BISeewTzlBMdfY1P2e058EZFYZD4
	 muIh6SeaK3ieJGuFokT9S+XUqeIcHgn78Y/pSLhYsGvhvv4c2keqxuJ9GFsJMD+jwN
	 zdu31zfeJb4B6mxtoHexhK5pLz12puQT1xGcP6YcmE7GahFR6r0BzzkCisU75vp9IX
	 KtR4LA74bvt4uM5gfwS3BaXGtvG4gFKxHKK1QX36OLnSJ63p1B1EXF/h6jwJEcsn5l
	 nY77q7rla1u9sdMfvRhn3s94U2uT2RvROTi2uEJQly8JK3Ohlk2WW3lUfSLerLyAY3
	 1QkMI6GaW8YXQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Fri,  5 Jun 2026 17:15:18 +0800
Message-ID: <20260605091527.2463539-12-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 76621a9fd645..67e63d81a824 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1644,10 +1644,18 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
 
 	if (p >= llbitmap->chunks)
 		return 0;
 	c = llbitmap_read(llbitmap, p);
 
+	/*
+	 * Reshape progress is tracked by array metadata rather than llbitmap.
+	 * Skipping reshape ranges from stale bitmap state can lose data after a
+	 * restart before the corresponding bits are checkpointed to disk.
+	 */
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return 0;
+
 	/* always skip unwritten blocks */
 	if (c == BitUnwritten)
 		return blocks;
 
 	/* Skip CleanUnwritten - no user data, will be reset after recovery */
-- 
2.51.0

