Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDB1293B75;
	Sat,  1 Aug 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605224; cv=none; b=kUM63R1jqwMqVxbwgGxf7EoN3NtdwkKLOyakxLX3tZvjwvej85xJ5FUWPFs1wEhdqtCvhdAk2OdYNjaoiMhrJ5701XoVxjrSjDT+me29rYAeNr0Is9jPI22NRMwkCzjbCyoy5Kp42Qlb+ujTs4SjWtGCKYIhl4AQoPEDoH2sKYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605224; c=relaxed/simple;
	bh=sO9EYDUrItlHhOotGDUWGCyNs1Mb1pCqLVgtYIaCn3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqxHkmv2JsYAqfh4qJw7cF+5HKi/aJaC8PyRIbZ7i5HhsIlJWhpSUpNbEndH3Y3i7xn54rPOAJrRgoWhgr1R85wckdPYvBTuVHBtOjMDWyM55Kuv08SWFKHz4JM18i3Wf/JlyxlfC/QOpCH3/iDxbxNhUHiLE9+q96YHb0NFRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHxD/Wuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHxD/Wuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B511F00ACA;
	Sat,  1 Aug 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605222;
	bh=8ssnwNWUL+M+KHIJhOdALPLvpAvLDAqMXaJ+Jj9nOyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHxD/Wucz26nasvUkt9FKVGh/w26OOKMgX7UJ0lqACSl/VHg33Dm53ZXK7cmYALVU
	 XLMNOjEwAnZJnA0zwCotaAPEMQrAHFOaN+QivCK9ZZ24ZtlaIiMcUYyPihPKEbrz8a
	 EUVXkr9S6GPxlm6C69KJvFRP6j7IHfbx/G78iD4rQibP/VMu5nQRd3NtaHLOetJnZ3
	 SyCEbSSVRkvIK/2Qdzxo/qy7YSiHYD/KCQ1cgrc1IUrmnAuCunkqEgGJOYNSycE9vW
	 74TWpi7kaAiCFD7d9FhBRWZbYUOjabPjmdEan+hFwdKHlmvRaaK77UlpQ/+OJOefXW
	 Ztct7R1x1YHqw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 14/25] md/md-llbitmap: refuse reshape while llbitmap still needs sync
Date: Sun,  2 Aug 2026 01:25:08 +0800
Message-ID: <20260801172519.2982121-15-yukuai@kernel.org>
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

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index f41f9ba2063b..3b121b372cd8 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1703,6 +1703,29 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -2025,6 +2048,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
+	.reshape_can_start	= llbitmap_reshape_can_start,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

