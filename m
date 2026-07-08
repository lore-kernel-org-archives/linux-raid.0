Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AB408039;
	Wed,  8 Jul 2026 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501682; cv=none; b=S64PWZReBSJSNsKIvdY+aHw2j7AG94UAqn8z7C8/vTwnsdl2QMsirDxLOm80QsL5mE+YlqE0jDuH23P8BLbWXh0MwMQNWEMMHAcasddqQRoymXTZRYDzouz6gPxBNuhxC8WqvbQteONAH0+dIWYzDzo8v0RJubEnPx3Xu5dle68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501682; c=relaxed/simple;
	bh=8AWs2zuizxcxnKU7ch/y3c37Kf/VvUd3qW2Nx0+Nq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tReMeAaOLjxbB+GhB3hN810W+jTJlKHyQwt80Ny66zHWCzeMVbxdzVHr2gtPFCHpTRqJMSmuFB8zZAZrnLvGGMkJI0C55IrNsb9ptkI6cEWUG4crCgwu9mPp+tgl/KPkOI4VGBlA1IlGAVkSgjgLKigaiFjmAT8Y5gRPymBzVQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ISBtw05s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ISBtw05s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ANECqzps4krvoGVdp+RCBWLSIOIJ9Uahk7VSvs815ME=; b=ISBtw05sEwXbaUmqAvLhu7Db18
	KM0m4s5RQH7tWlNgQFbCsdPdEqXf2A9CQHdModsmNFkjyfEcZPsb8VKYU1tU/aN7eD4n0Jv/oBgtL
	0u//IDWHsFZHXChXkCy6yNKgS46JYDPHfOcmft0+gU3ogtKVkLUMGnMcXtS7cRpvrozrSawnz6tT5
	SoNTFFR8vT0MlT5jFj4AQicnrwBBAqceo1mASN1Uvy6k4heYVVMtscz1cSjJZstvAa0SGdtWPI5/i
	wDBHdDDQSLlSY1bFfgJxA7xtc3l+OM0Qb5AiqvPIAi1yfXTPW/bB61BMxVGLfLlQNJ2c020eX14v2
	LQPtzWVQ==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOG6-0000000Gi8l-0pBR;
	Wed, 08 Jul 2026 09:07:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] xor/kunit: fix a spelling error
Date: Wed,  8 Jul 2026 11:07:32 +0200
Message-ID: <20260708090740.1433685-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708090740.1433685-1-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/xor/tests/xor_kunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kunit.c
index 0c2a3a420bf9..659ae3edbc25 100644
--- a/lib/raid/xor/tests/xor_kunit.c
+++ b/lib/raid/xor/tests/xor_kunit.c
@@ -85,7 +85,7 @@ static void xor_test(struct kunit *test)
 			xor_generate_random_data();
 
 		/*
-		 * If we're not using the entire buffer size, inject randomize
+		 * If we're not using the entire buffer size, inject randomized
 		 * alignment into the buffer.
 		 */
 		max_alignment = XOR_KUNIT_MAX_BYTES - len;
-- 
2.53.0

