Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF7A4071CE;
	Wed,  8 Jul 2026 09:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501597; cv=none; b=X6rUvomEvRCeph7hT52dN9klQ8rL9P1jbKkPhGCenUrxPtpmIh4d1sdESIB/OJ9zynmKe90usH1tAP4popNJNOJ4xEr1P/JNTmT/yJDowhR/ns4AOngYFBOZswrdV/cTcpTItkbXCj0FxiBrjIge09dFFVXjeeDOgUZTKhPldmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501597; c=relaxed/simple;
	bh=wzE+FAp3BrCgISI4I3CymC5NlO9a8yymBFM8U6HIjZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/8Oz8rnWOLrJYq2i+lbM8LhATHdiAVPsDWS/Ilj/oq3V4fVHt7lQDdnTAhjF8tM0IIo6VDgmaTw7cqnadDUO8IzjZmFHsVdi9l+Zw8o6YTClMTutpWxgaAEif9Vh7M/ckrECtat0i6fT2iYI/gp40YFyME6gp3Z/7V2HSttbys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PFzsP+v3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PFzsP+v3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SPIDK1lNPJ3L8M+w5BYkGiyKSopV1niKiKKXPQ4evtc=; b=PFzsP+v36nZZZfWVa3fy/lckls
	yer4x83yQ8Gw4Ty6cIU/UpfHeMCCt/16djv2Rjwx+oaH0UlYpHshnKS33jUZ0XgseA8jYtWoZO71G
	UsyAgwIhciCZHxRWEuIAmGPcQH1IdIZpH+nWwJ5yLn+4zrAE3CFpfGNV8tVQY6YUmGxV0A3dKzgcB
	fDIqDNKZAhQC69MzTic+2ub2K/3ig7c4ixlvG98zLpzZtWjRkaV0xFmOTgjadJ5hNsrNLOu+d+z48
	MZ+29+EbaPQbgwO1SDofwDRtcvrZRLL1jVbegVAhFHkWBJ8yd3stqPs0KBYzUVPHyBmso4mfpW7be
	4DqNkf3A==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOEj-0000000GhtG-0TaA;
	Wed, 08 Jul 2026 09:06:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] xor: enable lock context analysis
Date: Wed,  8 Jul 2026 11:05:15 +0200
Message-ID: <20260708090614.1431014-2-hch@lst.de>
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

