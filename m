Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C941DA61D;
	Sat, 15 Mar 2025 08:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742025995; cv=none; b=VvUrAJHxB4jQFg7h79rhfAoJKgYyXqRS6VSowTKYBxoxDgeNh7fJd7qhSr88PDUCERc8Ogkdcw5kns3ykdLL75eTMhBwxWgollU92ZSgQoQFFYh6UzIfULWjpCbPfxuTdIVqy/rYVHpRWGItrcQshp2MPLZ6K0wbwS0kGUJW5EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742025995; c=relaxed/simple;
	bh=frRL2RC728hrryZnr7gE9zXLqjd3ejjeTLlr1AE9sF0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fSrSaiul431hoHVGhAl52vpHShdyaZBR0kKhaGmwmbGw+rg+wD5aoCf72H4OgE7J8afuqMV43I1B9DPqr05ysSK32+PVkk4Gq6dpdlR11a/h5R+XD4+mzqmvUERsXzp82ATJ47n1AGajwdTrcA/Nk1F2syACjDG2HcJyN2dlq0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=re353uBn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="re353uBn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4+S15xdn2sIBMlFNTDKRwmCQsng7JkFjfLx0QlHmzUc=; b=re353uBnMsmOddNoIVfUBLHXee
	Llu2ynpUY0hP5KcNLMcxV54LGhKrP08gFN/Ztz9ZTI9CDZEJk3oIzbx5yULKLE7DgqCeO1XtukPPY
	8D7zAi3JUr5eM0N4SbY5E6R7Y548gaYpaVkRtLqvVHhZYK+oRuDJuxquQ9OHYD9N7SwEMq+4XUdKN
	lCdy34Ax8s5qO5C0EpPHd4KtxlOgEPvhjMeZSlu6ANC+4SO9TBjUHjaxg16e4HDsV6WK3cxJ+v5+G
	cp3no4SNTUhj6TSNAiFSrAoMvAIyl4/zh0vWsoHcDsjGgO12MzUkjgZRYfPuKNnXTr+TCwUzfAVK+
	NPYQ9Nzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttMXG-006nMw-0p;
	Sat, 15 Mar 2025 16:06:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 16:06:22 +0800
Date: Sat, 15 Mar 2025 16:06:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <Z9U0_uj1E2MlYhGx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use the system-wide zero page instead of a custom zero page.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 98030accf641..1460c15dea63 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -11,8 +11,9 @@
 #ifdef __KERNEL__
 
 #include <linux/blkdev.h>
+#include <linux/mm.h>
 
-extern const char raid6_empty_zero_page[PAGE_SIZE];
+#define raid6_empty_zero_page ((const char *)page_address(ZERO_PAGE(0)))
 
 #else /* ! __KERNEL__ */
 /* Used for testing in user space */
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index cd2e88ee1f14..03f1a8c179f7 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -18,9 +18,6 @@
 #else
 #include <linux/module.h>
 #include <linux/gfp.h>
-/* In .bss so it's zeroed */
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
-EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 
 struct raid6_calls raid6_call;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
