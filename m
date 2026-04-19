Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948592C21FE;
	Sun, 19 Apr 2026 03:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568214; cv=none; b=hMLj6SXrGlKGUkiCf5Di8d5Te4lpCTQiVRrLQJ3lmemASVAWXxZZMal+Q0xzYHOlwJz8djYAkjpfBC5r1LolDu8R/sIT8lekp9692NVB4bXHidEzjNoBVBRu8TeSmab2KCsuCg01STaT4JD+OzVPuBhPNo+iYeZvPXduBbDrrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568214; c=relaxed/simple;
	bh=bhC04SyevyT5Umo0GfjPIHicO+I4dVpCqkban9ir8zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3BxPe/YMVNRNTOTMhiCDHOIYocGm50mCS+dHFJ8bre5oDKc8AwZCKTLEKY5bGq8LwfPFVRRTtN1fsxocG1AqvL1Sx1cMqv4raGNJ696girobRG6g3IsN/iruoS11wj34c9VYgy03aOkU/RSLuEch1GHeTugvge97H2wpyqJxh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7903C2BCB0;
	Sun, 19 Apr 2026 03:10:12 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Sun, 19 Apr 2026 11:09:33 +0800
Message-ID: <20260419030942.824195-11-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index fd1dc86afc69..ad1b7a85914b 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1519,6 +1519,14 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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
-- 
2.51.0

