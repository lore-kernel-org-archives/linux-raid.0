Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C13CCFC6
	for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 07:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867954; cv=none; b=q60fuSXEe+xShWd2SHFyMqdp/sujq50Drhmzf94WVi7RrkoK63+9aUPobbCLVAnNiEYgTMm/p0RwOA1OX7z+YjuDHIY0qmFDmZ8KUfS/tuSqFYF3GUVbrsP+upgvXXMkvXLOkKXItn2CDYtbqTZkHYpmHCwdaGuZGrqcW4FEA8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867954; c=relaxed/simple;
	bh=Z0p5EFXV/2js66B2F5glt4aywJe8ErZsRwe9JvpaBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jejzbzxy5jzT9G8dgyigftJBB3vmLfSj3XzIIxiT1a7ubwvGRD1Fipxg4kIhGu+ZfZ/mwtW+K3tOMPRSuOfr2Ps8OjL/rJeaR/0zBop/A6PmbbzHbijWD27Bg7i5RMJfq1azJL8reaSZoco3Uf9mXKf+RIoc3bGekybdz+pfqfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vYNSfk0E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vYNSfk0E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T+GrMVsBwGnk+6sCao+WS+ODaIfX4dc+yz5QEhiemPk=; b=vYNSfk0Erkw+qR/H6sbiDiA7M5
	AIJOsJNLKmxYvTSXgrbF37dERWRuSJ/u2b7OzT+0IMIiM6hBMUPwds8udNMCnQQ23pBef3N8NrIig
	Ie+rPCCm36PaNdakN9+a2bV/yb1JSsSN+qG7Tzk0zGUmiDNgDp7tTa8KjtMdTXSMRty5GBHlEKrrN
	Z9RPUbmSUAUJoM37ptoZ6408pLkMTDevrhZ7efKZDHZ8nipjS/DnKGwTDbozEb2AAMyNKJMIzKiKz
	xeqqSy6i63ZvDXRfe7GCR8Z4q7RmN5MGJ8A45krwU9dtseKpxk1+Ets9UJu0GM5ciincgNONKBx4m
	csya1nxw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8xa-00000003ULi-28HF;
	Wed, 27 May 2026 07:45:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] raid6/x86: register avx512 after avx2
Date: Wed, 27 May 2026 09:45:26 +0200
Message-ID: <20260527074539.2292913-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527074539.2292913-1-hch@lst.de>
References: <20260527074539.2292913-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This way non-benchmarks configs still get avx512 if supported.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/x86/pq_arch.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
index 28e395eb04d1..02f8843b0537 100644
--- a/lib/raid/raid6/x86/pq_arch.h
+++ b/lib/raid/raid6/x86/pq_arch.h
@@ -60,16 +60,16 @@ static inline bool raid6_has_sse1_or_mmxext(void)
 static __always_inline void __init arch_raid6_init(void)
 {
 	if (raid6_has_avx2()) {
+		raid6_algo_add(&raid6_avx2x1);
+		raid6_algo_add(&raid6_avx2x2);
+		if (IS_ENABLED(CONFIG_X86_64))
+			raid6_algo_add(&raid6_avx2x4);
 		if (raid6_has_avx512()) {
 			raid6_algo_add(&raid6_avx512x1);
 			raid6_algo_add(&raid6_avx512x2);
 			if (IS_ENABLED(CONFIG_X86_64))
 				raid6_algo_add(&raid6_avx512x4);
 		}
-		raid6_algo_add(&raid6_avx2x1);
-		raid6_algo_add(&raid6_avx2x2);
-		if (IS_ENABLED(CONFIG_X86_64))
-			raid6_algo_add(&raid6_avx2x4);
 	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
 		/* x86_64 can assume SSE2 as baseline */
 		raid6_algo_add(&raid6_sse2x1);
-- 
2.53.0

