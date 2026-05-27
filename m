Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6893E3CCFB2
	for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 07:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867949; cv=none; b=BfuId6+002HbASc7WIHiWV5ou3bl+rpIB/m2I59yIZm+FTVpbxkFuthoqAg3FgIt8eX3QhGfaEtor+JalDr36l7cKGR++92OHvzToTRLjpN3k1AIlaBSL7HpFMuJrDS8Qp/rQAv2x0xSBj3eCb71wyU+3Mu5AAOmISdg3sM/uXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867949; c=relaxed/simple;
	bh=6oVbglKwRZ9eFK6YsV7ImiHnyNQX0Z4xgkfhCSjk9v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQoq5mdF6GXYBIHmkl+9vC5N7Bm5hyK91zRTvwuGuJXkljwmUUNP4IcyQ6HRVIbUr905wtrgxaWQqCmVepb/svKxUfKRpQXGS9YnQqbxk+qEf8pcOKHsdZyTW81n/FPURej4qsRN4zgK5wihCbQx8GNwPAQ5Ash8WYtClCRcQZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=afBEhvoD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="afBEhvoD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xzJX3L5AqwqjTheC2uG+aqd/PjiGMTPaV9a9vt2VDdU=; b=afBEhvoDj73vb+YdeTGqSAjVud
	x9KitYLtgFJ6A7MLYgEvu93T8FL89fmzFr+rhsvUJ87/BeagGj5WTtUcOxUPQvJ2OnqpjCVeQIc7D
	JOUfkPI1bsoSxMesQocl820dWi20YcLEE8S3A3u544PYP4/EasVNLYZ2fLwk5jp9Hp3G0tEDIiGni
	R86PgUnZKxv2eyC0dP5mMMlXlXAHdrq3l4VpD8geO9OgQCLO7GCYARG2vlX+YDCn2gG0h14QnKUS5
	hbT3Qb5SvOvQ3zG68LNZuEcQfp/GSYtlIopnuWa14eRp5j594FdiMZW4WsSXMyUOILWVTvo9dCw8F
	AK+xesWw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8xX-00000003ULV-0uDq;
	Wed, 27 May 2026 07:45:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/2] raid6: remove duplicate ccflags-y line
Date: Wed, 27 May 2026 09:45:25 +0200
Message-ID: <20260527074539.2292913-2-hch@lst.de>
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

This was added by a mismerge when rebasing, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index 1d79b76b320e..038d6c74d1ba 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -2,8 +2,6 @@
 
 ccflags-y			+= -I $(src)
 
-ccflags-y			+= -I $(src)
-
 ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
 CFLAGS_algos.o			+= -I$(src)/$(SRCARCH)
 endif
-- 
2.53.0

