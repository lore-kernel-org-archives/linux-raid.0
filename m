Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F63B634E
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678567; cv=none; b=JNg5KsC87SYQ1Ddi7AdOEBjEs3vskQXB/SRXngQJVO3WtnPPLp+s29u1D2rrLUW+zbjEGSjsP02w9loklwwg4EtUSm1tugkkJqrERF1xoyyMpkF3h299Lk6THnAWL1zlkSkgg6QpEZeqVkDzKyrmbynzBVLaQbvqI6Di0pPGmrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678567; c=relaxed/simple;
	bh=qSkQjXB7pdgaBV3uxRi/wPJF9W177xpnB5jhtdcPuAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSKgyKD4q/uwVxbEicYIbtXRZvmIIhVl4hvIrIKckS+gnLMSpmhYVvnKQoksTLFjI1InaK3aZeSQ2Bsby7kvDES9SzAk93R6leXDAHaZBZdNB0eTBkquEE8ZkpFbWAgG979/gsrspWC35KBMGzD3OImcXN1RRrmUP8tcoE/pKhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvvzi28c; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvvzi28c"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so3742255e9.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 03:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783678564; x=1784283364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oT3DtNxFURc+4K/kdjvPhLm+M8EJZnQsiPmbC3co1xc=;
        b=bvvzi28cadI+8GWehTKPHP34WRORRFZG+pVbTqkZyNPP4823Cd6Xspv+bDt+lF3nE8
         /wxYkLRYPZwz4nEyLF+HOR8oVT0JQSeztsHGuLsc5QhJzmme1H6Pj/Db8PpEDtbrOWLb
         1szDsxpsLtIcY5uoo/noEgAo1yyTJrEnLsZz3OaLcDtedd0B2mRwIHlwRoouNfHhpveT
         j/JC1xa8IMlhvc9CfChNrjlS7cA9wW8mwgzpythXfbUt+p9qzvgd3mkOlQFCwoDugej7
         vVEqissf800pn5SKPizox7mI6W4Z5rhn+51UBCv7VPVM4yj2xktukf6YwI/NXm/d4BWE
         BDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783678564; x=1784283364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oT3DtNxFURc+4K/kdjvPhLm+M8EJZnQsiPmbC3co1xc=;
        b=iKOVTU2zLOyMlP6vVTSOoU0nfM7Q8rbUfL7ajfNA0in7QDc48TkVF5NddcnzwEyJcW
         IEr3eUvcxVyPBmqUVYP2//x21UFKUbUJ26KUez3ENNztZ/HDe35dEyaEkTM1Rdrv3U9N
         osBQd3FWd2/CG4ArtA+PgEUQB53S/SIU/4Ebttzvb/5pEk27BJVtmNDXv7vhBqAFC9ER
         JfImMZdxJYq6czzCN0C1PRHwuDf5gGfdJhBKsujdFlcDzSHx4ZE44qPpA95dLuUCV5K0
         jzvB8brnxpmrnGa14iA08E2Llf3CjFNxNlOgArPrBQRyAlP1MH6G5W8oiZrV+bzHMfMr
         haTw==
X-Gm-Message-State: AOJu0YxS9FM00UzeTCDaPHNwNy3uwxmWSVyf4sjxgoHDiYD/juC4K3Cq
	4bnKTgJMJ7xzIuHdnrJEGXLFiPj4WhDNOQaaQPtMirkPeoOzZFrO3BKv
X-Gm-Gg: AfdE7cm3Xvh8tlEwbPT1468rwWr5NG+/PgK8wdmdp9UL98wWVVE1Qu31i8md9W3VEM5
	JcNWYPyaQxLD+6VhvjJXev/pWh+jQeUPc7Svq41HeuIHt6GriN7uaF8XnfonyQ/uMulMqK16Yln
	kERkIdNe0ylv73s18NKNmTvs/6hYAJ9xKY2xZHZjJWOcLaGGA3zaH+p/4A+PcL9I+6KvJyYf2Xh
	VakTe1VVF4D9ax4TcPwUPMIKtV/6L75QAu1j0dNogsUWNOPJxMCbWbcjQYHdRoirKpArRZADAuj
	cOwmlOGgpCTN1/Y3lETXauIQuP9W4mbRDM+pN9/xCceE6l5qzAnVMgbB/wAVBewYpdN4f3kyRC+
	BlbM0eZrA0hwLpx87Z6q0HRUrSxAqiEX23N0GXTVP/13s0uC3qwEzOkKvhsGo/JJkffB3PtFmFB
	2LR5MKDj8CeiOutaYelTfo9+iBMuBdTtd1pGwJALa/VtUQ0hrBfSCs5gyfqyQm3c3J
X-Received: by 2002:a05:600d:8496:20b0:493:f251:3e84 with SMTP id 5b1f17b1804b1-493f2513eccmr24899145e9.15.1783678563823;
        Fri, 10 Jul 2026 03:16:03 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-199-185.176.7.pool.telefonica.de. [176.7.199.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm123554875e9.0.2026.07.10.03.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 03:16:03 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v4 1/7] md/raid10: fix r10bio leak in raid10_write_request() error paths
Date: Fri, 10 Jul 2026 10:15:15 +0000
Message-ID: <20260710101521.1714-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710101521.1714-1-abd.masalkhi@gmail.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp.kernel.org/
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v4:
 - No changes.
 - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-2-abd.masalkhi@gmail.com/

Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-2-abd.masalkhi@gmail.com/

Changes in v2:
 - No changes.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-2-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..bd322eccdc3f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1365,6 +1365,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		for (;;) {
@@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
-- 
2.43.0

