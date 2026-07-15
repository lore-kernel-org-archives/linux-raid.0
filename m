Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D67395DAA;
	Wed, 15 Jul 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126924; cv=none; b=eSMuiZDyTWmR66/XmXoqQk9k8Z3n09QjmKUCDDNtR8v59rBauY/GUM3nRAAlO1aqKaATDMZppAQjQ31qcxWa1QABdjPw43QqtmrCtJJz8G2Q3JQ9faPylypdOnOfAeJtq9dPDYCTxSH2RcIWXtS6TLvSCL5+66u0ih/QCMNa0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126924; c=relaxed/simple;
	bh=8AWs2zuizxcxnKU7ch/y3c37Kf/VvUd3qW2Nx0+Nq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGWWBNK16b/5OpVvkenzUpVzx65rLpqJOtXgXcytPpyp2HcIFuBzycNy7v+yzOhEA8fxjdn9HZy+iWnp4dIG95wLxAe0pPMP/Nlc71RhK+0zFQ6yqG4rX9X3LF/pWXuMFhYajnfJxBVioFIFHoASchorUyIBJzvDjYKh1nDvM68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OlIZ6pHY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OlIZ6pHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ANECqzps4krvoGVdp+RCBWLSIOIJ9Uahk7VSvs815ME=; b=OlIZ6pHYy4C4F/Zh62EgSiA1OT
	nYJ4dhoknvPO9CCdp6Cok146Yf84cQ5BsB2fKzPHCw0zN/mg9M5sTg+kCTwpz37UTn0JBhfQ0IEIb
	aooz4HEqWzwssEtOQhSx7SVrAEkYGwsAzA/GFZABYytZUP1O5meYd2xV++JD1nwnPv9S0zaJHYn5J
	QpNzNst1+JgMf/SSKocGoz7wUT84fHaWIBljij9Gcgn730FqPvX+gTKvNoIl6iDVcQDXuLssiyetr
	9cjLtR+2LI0jhaR/agg1SI5gOFNo96LZrZPTsoisxjk0XIuvIMQsjYF6REzuEF7OH5FUJOQ4k6fA+
	q/P41IUA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0ud-0000000FDAY-2OOb;
	Wed, 15 Jul 2026 14:48:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] xor/kunit: fix a spelling error
Date: Wed, 15 Jul 2026 16:47:34 +0200
Message-ID: <20260715144825.95432-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144825.95432-1-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
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

