Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFE331F98D;
	Wed,  8 Jul 2026 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501690; cv=none; b=jw1SfYcyfTtCfoDB5c6JwALz12YevexOODcWsM/hgkJ+VZZO6igpPKjP5iv/3hXBW4dZFO3IYLOswJiNb5niMORcGcxaVBj0DWBoj8PUVXGAla+Svw447Y59GxVf7xwRIaWYWF3Zqi3F0vZUMSFDSLa/SHFQ+vZvk5msM8pJllc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501690; c=relaxed/simple;
	bh=EwLk75BmYbYOqUvvR7QXsDRSBUfC8DKIfHZfhHYN+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrFao/VNIrI9xSr2f1eBu81u1m8Cy/v0WaeO8tE8d+k8nPH+Ggi6E42lk36NtnnEUd2yK9+xstXufKQjbf2i2chdrsE8c0tQwsg+Hl5FnwboRRqbAYvLeSIxg9jlv5mOVZumBqqOEywjR2xrWLGe1fYgOrsGbvrf7kdnQ51O4Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V2+uxk98; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V2+uxk98"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c0Almg3B1vcRAPM/occ6NILXdmIPcSVkOclM2ajVpCY=; b=V2+uxk98PhgQMr1pmSVqNqBtbS
	SWug5uQRYDB2Uq2QVMX4HsL7TgX43ERkvFjNRsAEXeYmrV1ovS10pyzSyx7FKVphHBV97rVPGnEe4
	AVrWAnb1Ef+kfPSwEMmjrxOFCnwFWtFEKh/qkBLZqDe/mvB7RFBFaM17ccmhYQC/Pbe5cR7xAFtOz
	O10zwXjfaDDLWNWD5yEzySjq+4v5io7/FqJAOPMxC41a5vdapapqGGkzTZe4xLcpPjhgyy8cJKJam
	BPjHp6WmzH2wWZOcJ3xI0Vf369mMh+dOh922Qh0LOn7G05qLounfhf8+J7meym77Hn3xNcWi1V6wo
	LeBwFzJg==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOGG-0000000Gi9V-07ra;
	Wed, 08 Jul 2026 09:08:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] raid6: enable lock context analysis
Date: Wed,  8 Jul 2026 11:07:34 +0200
Message-ID: <20260708090740.1433685-6-hch@lst.de>
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

