Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4939448F;
	Wed, 15 Jul 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126917; cv=none; b=l5EM8fP1dp1grxL1iCzbH5s42Oo18ynnZ3YUC8ZlhiVzP1PA4gcd1NYudFlcHe9EsL5d8n5LlYuU5CRlhqDIBO8x4Pih44/66+3ndwPPIuBpDvNtI3dNrb1HHlYC1Rd9qji3lcgEEyO0C8xwHBA5XV8H+Oc4TUtaggzLu/dRRpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126917; c=relaxed/simple;
	bh=wzE+FAp3BrCgISI4I3CymC5NlO9a8yymBFM8U6HIjZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppB1L2MO7TDxd55YhyYAEVfiZflVX+xZLHjU0y8qe6VlHTeq4vSeu9hrVBWydx/E9UGo4ogHr3ntghXhoUH0Fse4HmzoJcZl/0wWtlO0hoOwEAU+ioW9+Oj5cwryxIuGTCaR7QJKr/e/yIrDlm8J1hHw54LT7LWjyZb62QkTyvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mVWKzEYD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mVWKzEYD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SPIDK1lNPJ3L8M+w5BYkGiyKSopV1niKiKKXPQ4evtc=; b=mVWKzEYD/xzkvqbj39GahXgE3S
	jEW3UXG1oCotXs1V7qigoXiA6AAUppwqFuQJ4qpluFB8kzkJiCs4ps4oq4vDU75WECk6xGpAjyPkM
	jTRBFVDPS49UIL2KfB/P6kWmKj4ONet5ibSidxDsLroVHxCsWGASpfKymBsjaUQ4j9Uf0FGgVsmg8
	WRt04TBNTFj7xamRMi89skMlGT4MyOyB3LXidVInKtI1k0WcGThC7BFP7vyh8L3fP68HtGuFh2Q5P
	jVr2L0vVD/5lQzyX0SFf6gL2hppQ8+CpnqWzJf5BhmnhEBReHMZaKN/kBvHCf84uVI+2c7YTpyIf7
	IVPlVQ4g==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0uW-0000000FD9s-3TnJ;
	Wed, 15 Jul 2026 14:48:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] xor: enable lock context analysis
Date: Wed, 15 Jul 2026 16:47:32 +0200
Message-ID: <20260715144825.95432-2-hch@lst.de>
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

The code doesn't have any locking, so this is trivial.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/xor/Makefile       | 2 ++
 lib/raid/xor/tests/Makefile | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index e8ecec3c09f9..9b0fad459cdb 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
diff --git a/lib/raid/xor/tests/Makefile b/lib/raid/xor/tests/Makefile
index 661e8f6ffd1f..1cce833cd7fd 100644
--- a/lib/raid/xor/tests/Makefile
+++ b/lib/raid/xor/tests/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_XOR_KUNIT_TEST) += xor_kunit.o
-- 
2.53.0

