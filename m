Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523433C988D
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 10:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781172837; cv=none; b=cxjwxUxfbq1DQ8wAvEeNQ/Ng0ypu+w3lzA0C0Y5G2Q1mYajIdUvPmmSvK+5nGNKPexV1tideapMoB7HkASmiu5SS159RMWoFKQWhBo6Rgq2LFMpr/g2t3aH99ewPeTgmkCFiZb6vYTU//PV3pvPElmajgkfhWmdnefIMUMJqz6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781172837; c=relaxed/simple;
	bh=nWlD6unX7CQuBpK2gLba1Sq1vxcxdKgic8dWnc7P7Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VCErWEY+NGPcRwy0m6wSV7ibeTBTBYblJJZOGJgfHtxz8Lb6GqxaIcowBdBTAG8nigIM9Mei8gdmpvIMvub+VOValB3fiXL6AYWZKApmGJg7qnKdvcuew2xB90bD78Pr6WEWw8SBjYNTOQGL77ROUpE2vZCNZPyUiC+H2Bz5ots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=da8SOkAh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="da8SOkAh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b613a17bso75736005e9.3
        for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781172835; x=1781777635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K1GCPiDTEOa/3iXDBBPW6IUh34Ye7rH3H2iNl34Y6O0=;
        b=da8SOkAhhGjU0HllGOr10Zw9pkhOrNKgyREq3hqq1iFfZD96V+KixQWoqc94W6/i2O
         7Ezk9t/k5+a2s8A6mNXQl6f6pVHIEEU3SoXEABYeVYehDGHdSPBFkMddekCoR5kjWg9J
         ZJThQAjMQqLl4N+IskwNmOtch5/CqR5Qju50NP3Y7g2seofFXLnFszfZvmBanUOjGHSr
         cLBdu/2S9Xg6QxvoW7Nl6HJWTH0lzJ+4vE6kZIvYL87sDtplGfxcrGQf9nCP/MDJL5PZ
         fXSqp9OBJp6iaillWIITbXQBOz2jNZAqcxc8XreM6m44FK1edxZWlq3NuTxbdm3gFcI3
         A4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781172835; x=1781777635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1GCPiDTEOa/3iXDBBPW6IUh34Ye7rH3H2iNl34Y6O0=;
        b=V2dhS/j/hNcw/zKeIfir2qXCY/M69FlbZT6kZuadohdRICj6pjH7L4QSFXiKIPwX/A
         pQcCIVptL9FC6Jkra9veplemVO/VlgXcEDkiMne+l72rXmFNtmE2eVC7PtQFe895nEPu
         na1j7B4xpQkc4nTwVxtFvmSD20sOO6Dtuo4cg66H4MIfeCQxP02La9gtOSH7P26oD3WE
         +6I12mbA+UwQq8Dje4R/0/856piml3Rd0yDgX2xjIyLozwMe/4X90WR+10QVUaP27Pzz
         BCFtMayFZ5MPn4R7vvl61Qm2wOmUe1ZzPHc4EUoPThsDc2K0qO32UKs5qJgDqlV2HEC5
         /A7g==
X-Gm-Message-State: AOJu0YweUhUKKMr8tZ1sQf8ybELkpCAnNZbdvgRu2y9FWh2feSinMFKv
	rgsAqwpnZumaZrfXHllI4x/gING+h8dzfED0TwxNzFrzfnopYXvRicIY
X-Gm-Gg: Acq92OFfF0jKt8wgRI8+teNK4EvrY60yYK8jtDzVyVRuT16vzDAPZnnyeEeSmE/ufZv
	m/omyP1wNohDi1bpzny5WLUqdjxGcpNHak6SVGtFJWZD+kXM5Z/jLW7mIOWyxVDqmv71aRFevaN
	YaHqqh8rl/vaVe7FQ7cViEVKfmuBAG2DyoNIszgZqsv+sfRGaFuucs4a1Mc5W6Uipe7KjrSe+6b
	hD3MDGoFs4Mij+BdOrC1+H5woZUBZW/n+dRGznhXEAQJylpJVW2zy+4GbrPCBsWUBFcGg1CX9RD
	FvVAx6tAwxzhL225BwL817VUFTaqsNT0A2hDoM3XjOwzquN9TG7zKYI2sJGAwWZ/8oV65WS+ZTY
	Gj8OYalZT6PiJuuBWqCZg6viTr2wk5rtQ1JRVj9EUcwKNho9DL3pPS6esQJ2v0DUbv9Xp21i9am
	rfAI3weVxzJjDP6uduDNSbnRxwWgdc1XpQ3wUttM/hCNtpgIATd0sZOg==
X-Received: by 2002:a05:600d:6401:20b0:490:c2a2:e91f with SMTP id 5b1f17b1804b1-490e562792emr17115175e9.35.1781172834431;
        Thu, 11 Jun 2026 03:13:54 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e52acb98sm39821735e9.5.2026.06.11.03.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 03:13:53 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	vverma@digitalocean.com,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Date: Thu, 11 Jun 2026 10:13:50 +0000
Message-ID: <20260611101350.759154-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a read is retried, raid1_read_request() may be called with a
pre-allocated r1_bio. If wait_read_barrier() fails for a REQ_NOWAIT
read, the bio is completed and the function returns immediately. In this
case the existing r1_bio is leaked.

This fixes a leak of pre-allocated r1_bio structures for retried reads.

Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi@gmail.com?part=1
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b2d7c13b64bd..6263a1d45f86 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1363,6 +1363,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
 		bio_wouldblock_error(bio);
+
+		if (r1bio_existed) {
+			set_bit(R1BIO_Returned, &r1_bio->state);
+			raid_end_bio_io(r1_bio);
+		}
+
 		return;
 	}
 
-- 
2.43.0

