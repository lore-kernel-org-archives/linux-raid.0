Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8653F823C;
	Wed,  8 Jul 2026 09:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501606; cv=none; b=P4AlFJDDWYz6Ho1YkmexKe4wtkKiEClW/eshwD869DOwm1oOjBi+bZJ1KAklhGhJXJ3b/oNplhNnEMDVpQ31KZ8TZ0jyITFhI8ZTaLZcyCH/5Uml+o6e/WqFInqqJLzCEvj87d0BL4CHH2jUONm49vIqFHuOkQS+LAnKzWTU+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501606; c=relaxed/simple;
	bh=8AWs2zuizxcxnKU7ch/y3c37Kf/VvUd3qW2Nx0+Nq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJjewFxtsd8CJiQLosAUntkNK9VNFUM5fsIbN3GsZnvFUoFvxERPalAzurc050uJnCCJuYDCNweDyrmXJUyzRDA1eZPTYvtFuHZxJ+hL0814FnhfHZ54L8HcRjBjMua9m3bCFjIDWNIXq5S0Cc7LDvq/BT45P6XHlhpJcxqZBBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ryVFwU1H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ryVFwU1H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ANECqzps4krvoGVdp+RCBWLSIOIJ9Uahk7VSvs815ME=; b=ryVFwU1H5g/WIhr2RKHRPtSOBi
	u6Qp+6apXxMowESk+HvJHJSk3v/5wS7Vpr7mvqQRj7ho7mcjgfjWh/Yrv5jdBMZJvIEUTsvTgwhKk
	TeA8MUY75la0pelkUbvwEQMTNZtS/3abdYqv+KXgDxZH7pzNQXyuREd7+cqpwejCaf9uo8aiTHztp
	puS7aIFLUw5GFm2st1IY3yRPLUgEDrhqZpDsWpco1838QHRe5XoRLfhIjrCDwk7h4cXKU5nl8vNyY
	SdG6Kon9SXRIVPOdK3KMqijxikh61fyo2eM2G14wsL9JhVMPbkpG/PEB085zXcN978u571lduk9mK
	OJxwZ3Ig==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOEu-0000000Ghyi-1j4c;
	Wed, 08 Jul 2026 09:06:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] xor/kunit: fix a spelling error
Date: Wed,  8 Jul 2026 11:05:17 +0200
Message-ID: <20260708090614.1431014-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708090614.1431014-1-hch@lst.de>
References: <20260708090614.1431014-1-hch@lst.de>
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

