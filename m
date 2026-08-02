Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D741330FC1D;
	Sun,  2 Aug 2026 19:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700314; cv=none; b=I9qSgIwozwxms/6SzhigrNPDToQTv6nbv2hZekhFsiTabbJ4IVxOPqP0coan4IbkyUkE941merP2pWdKFZKI+3ceJLOmbpcaFNRWU36rpZZ7ED0pHePv26iuJCTcLca0vbH5J/ague4d2dVNv5wq7hF7/5/1hQPoBDrcq9O4/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700314; c=relaxed/simple;
	bh=b2d86Chp3gAVBmArBUqqdOV49pAbqhBxNkr3qbqdk6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwaChmsmLRVTX2yFMDLsU6E2XoBjuXqRYQrg2nivPLrVPeRM6mHGOwjvbQDuVu+sYuDZ6dwHqmJE1CSgHmV3M2YC84GElM1DgIsch/D0xcRPld6m5EhVyrdahXBpXnDolPepKc8mRzou7cy81Qa5E5D8U2z6bjDhNAI/jLFdk0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWr3PSYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWr3PSYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5342F1F000E9;
	Sun,  2 Aug 2026 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700312;
	bh=eUGBX7KepT7gu4vu5Z67JYUXykTW239FwnZo+emIELs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWr3PSYddZ1Td5JXfPBay4cvEHmtYDLBWz1J+RF2aryhsdYfwE1/qSs2dqzLaU+pB
	 JeUzTzGc0hDMx7F3wsxerUBS2sGsshaBzUvGzK7CqMUbkEu7jFff1GiZ1rIPnbp5XT
	 twwsPc8ZgkqPPReHiQHOmeF63LNxjLcGuqE0MPuZNjlTL+iYEHuw5oBzGfuAAl5+fZ
	 i+hH3HnP/e33gdtjHJaDqb+hayccDfQW+lEbZDTFLwo/ysPL9LAwAAztcyp2uFgE8n
	 L148ivK3MTBx2wympI6GoLGXse9iTOLu0VeFf0ZnpjN4DdjYOA4VIgmJ8crwaaIOW0
	 NYxAmMoRjZkUg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 18/29] md/md-llbitmap: refuse reshape while llbitmap still needs sync
Date: Mon,  3 Aug 2026 03:50:27 +0800
Message-ID: <20260802195038.164272-19-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index a7c229db3058..f8a1b0f79be6 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1718,6 +1718,29 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
 }
 
+static int llbitmap_reshape_can_start(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long chunk;
+	int ret = 0;
+
+	if (!llbitmap)
+		return 0;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	for (chunk = 0; chunk < llbitmap->chunks; chunk++) {
+		enum llbitmap_state state = llbitmap_read(llbitmap, chunk);
+
+		if (state == BitNeedSync || state == BitSyncing) {
+			ret = -EBUSY;
+			break;
+		}
+	}
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	return ret;
+}
+
 static void llbitmap_reshape_finish(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
@@ -2034,6 +2057,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
+	.reshape_can_start	= llbitmap_reshape_can_start,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

