Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA71293B75;
	Sat,  1 Aug 2026 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605232; cv=none; b=hBUNT3symId2+kfEXCANAVS+SpzjmDURuoM7rAr+DFBnpROGv1E3H6k5jCGwEoGXtD0tUAUPKCD6//LyQQEI+Di28hOF6FbI+l2u4yUVWsdPH/wu6erBaOjWi+zMpaw1CS5hN5886RnXAXqD41pozoTwpROTvaO5C8HCzAIUqAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605232; c=relaxed/simple;
	bh=AGxXCfcDngyf1D9ahtN5F4K28VS7MxneMJ/exnidUwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5y+C17WjuBBQO8RgIg/VPOsZwnbMcCrPOkiAfOwHiVkqH8HOs5NOuI1NS/uoJ+FWlFtYCXWWA5iFORLMPrXrkQBIIhWO6ejhwShoVD39xLoDmjew7+AjojU2K33JC/Lj609wfKVExltawZdRz7ueYzXypRh646Wk1DDyK+TZbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzC1/MYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzC1/MYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB471F00ACA;
	Sat,  1 Aug 2026 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605231;
	bh=xTPhGjYKCzWKWwLWCkcQX9ZclRZsTm5cHvS2aXKeVsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzC1/MYhfDFfEqkZTsfUfRtvhEqI+djvdFjo4QJtSWVOAwQX3MSLQa8tBwtqEMLlB
	 IGuBHKzulGxRpGR5jQmJRp/ELbn3SilR5bRI5xcitf9VuizHb8IPIm3xZN4eU0+m0c
	 xX4PVy7rHyZqGFhRw1UK8Mde9TLdq4AoPEFbp50xiLmbte08qH+4U/JkhKGxTpw4ZU
	 W86TwyBMkFYUcan4NCgmMUAauZeOT83sRZa6hbM+4ryQ9fHryKigYqgdPoyd/gyFWb
	 E2XzpQC1RyxvKeBToL3KDKV37jq3jx0NBQAG3x1eqgL9iTmdMwDsrmVufzk5bPj8wh
	 kPmYjYDvy3qPg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 16/25] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Sun,  2 Aug 2026 01:25:10 +0800
Message-ID: <20260801172519.2982121-17-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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
index eed3e248b730..5597b1afcb58 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1692,6 +1692,14 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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

