Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C9389E1A;
	Wed, 24 Jun 2026 06:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283372; cv=none; b=nzxqg8SimGeZEpYBjesJbY3Q10P8MSUYYutRoG6lvOcEyAepiqGUd+AyaswlH54Pp8TfTgv/Np+8hMGrW5ovB+UGwJ6cEoub/xPKzTA9xPOD7qrsKLe0cxZyQEJg8DHirQzOsZ3AGaG0E5AOvFzR4KdcrJWIoJH1pEBglWbLL8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283372; c=relaxed/simple;
	bh=KTcDD2w/+9USPA0TpFGTfKSZQrzapS5XtOjhNUTfWlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsU5xlwk2WKEYyGkkIqPzOUkHdPJfaNzX/21bA2gdVlvTUq4pFChqN9b9JoNqeDM7YOeLM2YYdCpnCnYrS2KLlW1csNKWjh68etrOxhp6opyFBuPZG45ZBeNemJnVDRynv4Bm4FVjFpF2/8UReYhx8h/AZ0HpTPq2LFNSsgMdCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUEk+zw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUEk+zw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC901F00A3E;
	Wed, 24 Jun 2026 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283371;
	bh=jUbnG8FMyXdH1HbC/6QuNI7FxrnTdk1Yh6Il6GBr9Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUEk+zw5sqPIGHVgh4FZI5ZXXFxl2C8DE6NT5BrU2H2tI0NZYI0Lw3YbgaFsdND9A
	 RIPiZy/ZPyO7KUT4SJPvTbC07PbaJTP5soznVFJwPnpOEasrGbgfxgFkqwVOKfCWtb
	 ZkGyZwz+JQPZu+r5If1lCcAaPs8lSdXoFB8CmupwI2BQQgOCRYSCB0TLqWk/9JUkGL
	 xCAcy69/PXa1NGcAt79xR/8zvhh+wgtq6Tsbyot8gwGazf6uSi9sDFqVRp2VFYow1w
	 Y3jC1fIvaEd/kvKXw5CQDzU21Gm49O5PzuxtORiP7ALNkcwoAQbEtvFchbp1tLQ8hR
	 Pa9F4KJEyX7OA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/20] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Wed, 24 Jun 2026 14:42:08 +0800
Message-ID: <11d028037df1acf02db6d67a362ab02e96a7dd57.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
index d27993cfb13d..c62397743d9a 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1647,6 +1647,14 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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

