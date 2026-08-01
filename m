Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35573B6BF9;
	Sat,  1 Aug 2026 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605241; cv=none; b=Cfr2pqwDdyLAPU1OYBLC3qT+gE8g2i37IOSkmLRD5IL8g7vbTN3kCSr7AiBiD9HP79a/mXfyXaajw8eBpjDB55PMwi9KtfiH5+0/snRqpyBAbXptMBhqbvX+ObB0nZzcLewn8F1wwVZ2e3EXC4odbk+84G0FOk9HOlAuopRAvBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605241; c=relaxed/simple;
	bh=7FTKGZTRyOZwKq/qPfzjV/ahAF95exR/B+f+biBkaSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eexoCsVrtn9c5Ca2TOxzCUSZe24CZXGH6gBzceb8G0GekjZoMdf9AQp8JpUWRzCrgxXY4Y6AzG+Vq8kASGzXJTaMi58O4oHli2hZY+tcO3oJtPRA7O489vhTn19n3P+043kytwaweWbtyr7wQQfl6u1kYwwTG2K4OPNcRLhcEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCKZJjvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCKZJjvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115271F00ACA;
	Sat,  1 Aug 2026 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605240;
	bh=83L+HPs490fFhgkwH8pp6yRZPknCWQXSXuf2hUFRwEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCKZJjvR420hJyXlHU7YnN3lBJwOju1I4WpSHLwlLv/1XtGk8WEKeP7ijQMwzm3U4
	 yEUELsXzRxb4VLM0GpH94+677rlaU+GFJwskWneLuD69lT2Rj3F0FgTkoNVuM1RkCK
	 +FWNfM8vXqOHU9UgbMfyZL9q62bLUywM5tTtUdfpgNlnLGRFQbPBXPNf91YXMffRNn
	 GwBBSgDIlQnP1L3DTsMlF14UvODhx8BGn56vKXWMrSWEibuiK3W2HK8WVqRc9Tgg5D
	 TnJkVzOwoAowJ1fiNKTFAqtsQorbSL6GlIIlgKW1Awks5qkd3shH7fBzxCxIMmY3ht
	 NO8zPk2COXbHQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 18/25] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Sun,  2 Aug 2026 01:25:12 +0800
Message-ID: <20260801172519.2982121-19-yukuai@kernel.org>
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

llbitmap_state_machine() can be called with an end bit beyond
llbitmap->chunks. In particular, llbitmap_cond_end_sync() passes
sector >> chunkshift, and sector can reach the tracked boundary
exactly.

Clamp the state-machine range to llbitmap->chunks so it cannot walk
past the tracked bitmap.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index c3f6e807f739..27418bc001c1 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1012,7 +1012,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
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

