Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F024640801B;
	Wed,  8 Jul 2026 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501617; cv=none; b=GEW/1u8ExUDMrqx7+brblkzYFp3fp/y89TOootZAatxTuVzz0xPObIhMHvq0GcZw6LbFkGYrt1bExH+0aw3VA/s5RArCMZT+swfrA38ySjB7DmfZlbv0TiXbUWMtd/NlUDbBy2itb1aZPjWuEx4PFviY9WYwegMsXwIwO/sZPf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501617; c=relaxed/simple;
	bh=EwLk75BmYbYOqUvvR7QXsDRSBUfC8DKIfHZfhHYN+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H28ZzCou3sUehQoS9WuDGZzOkIGRZB6ak0GMKhYiwiVTJi7/bbe4GiS8ae7oUlq2tPUdI4j4CxCLpIjmlmYkzcTEZG8qFos7z4+APLxbmHpOIJPcEmZKt4NAwvvoDgEUnEdC32dIt218FZMPl53wESxbiyK0gnmzFWc9BFJ0mUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=23pXkXDn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="23pXkXDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c0Almg3B1vcRAPM/occ6NILXdmIPcSVkOclM2ajVpCY=; b=23pXkXDnUTmlP4RVw44VvsGfe6
	6dYOHZTPPN7zZVZzU+zCI5uGBmQCJPBuBbHDe3eN+K5YAYAP7Sx+2VggYlwvZvLl87lQij+w0PWRS
	q5NpCEii84US7imd6Hs54/ufPtl/47ReriyOzEAGEJEWXiSKWInt1FD5b21GtPU23AbbRcrVXnXeS
	GNI+mcHNJ+G11i1L5xXK7XecXc/0NvNZBHEU1cRLOoes+kI4hEgj3WRwi5wbEc0JC5SpvrS2HmPRW
	EOxEyp6MX0yS7jDIofgenwBvU14rDeDlJJFuzdHpsVBWV63yd1bEUL7necktbLU0wJYZFQCZE/hid
	8QVvB0Qg==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOF4-0000000Gi1Z-0CCD;
	Wed, 08 Jul 2026 09:06:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] raid6: enable lock context analysis
Date: Wed,  8 Jul 2026 11:05:19 +0200
Message-ID: <20260708090614.1431014-6-hch@lst.de>
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
 lib/raid/raid6/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index 038d6c74d1ba..5cdb7223de2a 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
-- 
2.53.0

