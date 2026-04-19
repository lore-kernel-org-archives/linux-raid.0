Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4492C0F6C;
	Sun, 19 Apr 2026 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568218; cv=none; b=cn9Wp1JiG5jBmibBl3ak74C9IIFNAR2CprGBZVL7n/aAXAbh3fQHNTRdHl2PvjGf4i2WAPbcFuEJMUmF+IBo3Ei4Cgop5s1p/2Mb1IH7UAiP2+tJffRpW8hYJSuImtUCpdHfcrFjoI83aigOK5NV1PRY92TGbTilvs/m5aHg2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568218; c=relaxed/simple;
	bh=cQRKX7+eKUM0aO8WVFWdsnCPzQFS0ncQ0VV8H35gDbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPiPWzRyGn9GIOUInbv7ggLNSlfELcakT5RTPcJsDdYepepaBRLIGB3WH0TFubV+nVYmuM4TNrUsDBEPfUYgEvX+Ld0nwKdOkU4vt13w/MHCbUf0CK/tqDdHMeeWQP1SASIvnroTh894RYhl237GX3RNtOoWV2hVCuf8U4x+MiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B2AC2BCB0;
	Sun, 19 Apr 2026 03:10:16 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Sun, 19 Apr 2026 11:09:35 +0800
Message-ID: <20260419030942.824195-13-yukuai@fnnas.com>
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

llbitmap_state_machine() can be called with an end bit beyond
llbitmap->chunks. In particular, llbitmap_cond_end_sync() passes
sector >> chunkshift, and sector can reach the tracked boundary
exactly.

Clamp the state-machine range to llbitmap->chunks so it cannot walk
past the tracked bitmap.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index b3ff67779557..6f81ccf3e884 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -853,7 +853,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		llbitmap_init_state(llbitmap);
 		return BitNone;
 	}
-
+	if (start >= llbitmap->chunks)
+		return BitNone;
+	if (end >= llbitmap->chunks)
+		end = llbitmap->chunks - 1;
 	while (start <= end) {
 		enum llbitmap_state c = llbitmap_read(llbitmap, start);
 
-- 
2.51.0

