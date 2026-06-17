Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EC4398911;
	Wed, 17 Jun 2026 05:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675067; cv=none; b=bBfuaf1gurLqLtSe+liptdcJ+qo96V6x/1xL0fOHFtDpWvAdM0s6TBDJ4UOnJzBcIFAhGl8dkiswQGXmQ0A11tMB51D4ndE7v/5k9xe6iVGx7/NXhaFVd0slhby5yRwCHgbTYFPON5PikM3Uj3ASAQeCm4cI0fdfcN/ABXAXYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675067; c=relaxed/simple;
	bh=8AWs2zuizxcxnKU7ch/y3c37Kf/VvUd3qW2Nx0+Nq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbPp09H26+7qHBW6UCJkkZGbcXEFrc5qB0pcy83cPRuNNmXQ3xQ8aoK65xbTU5QI1CgV1/nv09/LjMJEwfO4VKkzfU3nns25b0oYpdTHprYx8VG+/6od6NjAIPc8DpQRuBDtUBImLjkXeh367ZJT9Y7WA+/ZvJM06pZvPbozBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eJrjqJg7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eJrjqJg7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ANECqzps4krvoGVdp+RCBWLSIOIJ9Uahk7VSvs815ME=; b=eJrjqJg71figY4pGC7CC7AyeKs
	5I5TSd27Xu5lVepJOWYqHpsSIEOQ1QI4BNrbNdAVrpZsRomJ9HZVnyv6FjEliPVZ+V3E7LbGIirO0
	PQdMjaMkFHrecBLmbPcrkIfMEjqUrDIVeUCbi313oj4+ZDZaHCYOlaOvm0CP1KYtn+irjV6oEgK9P
	hFDnaPFlG+29qiDxBf2y4X82yfvHhZKMbupTTa0Jl7gbFRXZHPs9rJye/W4GZgzpYtcmjWMUGXARW
	h6AqFwfPMgTab/l+ZyeUuiPvIbS2lMeNXMQ9zQdRGoLinTodnAFrn23ESEkZHx3/XZszXhyzguhpJ
	HU6I6Zmw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZj4Z-0000000GfLU-2xqa;
	Wed, 17 Jun 2026 05:44:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/2] xor/kunit: fix a spelling error
Date: Wed, 17 Jun 2026 07:44:03 +0200
Message-ID: <20260617054416.3841334-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617054416.3841334-1-hch@lst.de>
References: <20260617054416.3841334-1-hch@lst.de>
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

