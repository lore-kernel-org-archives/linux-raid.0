Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC3733263F;
	Thu, 28 May 2026 07:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953287; cv=none; b=ORJC7J7PYTPuMgs+UXUlhuATjGGDoDOwQjhppfvDlmjQeuxkd17AHNdh5tcI+TWnB6pUX7rofhSQcJkeMJR3U/fG1TI3VvXipsJTTDcHfpCDbI2sMtfhT9f+drFDW2IJND67/gLG3fgB69PTsWi9UBDteSqf9PXHdndYN6MN3sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953287; c=relaxed/simple;
	bh=slLGSrh1ppM0MXR+lg2It408Rmx9smVRMw0zj6DPg9E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jzLWhxu2PtCHoSVEvIYGRz6dCRIxPJdjVWUNUFdYx0/907L8QNUmMRcZ3kDQ/rNFpIxONmzI0OOR+yE3qF+y2krPDZYGcQxz6nuwiyvI7IZzIQCJOYRbjSbh/FI2a12/bKbMAB7zyJnob/Ad0yK99ydDzKlEVV9W9tJrdsfrJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mC/kwi6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mC/kwi6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F8A1F00A3C;
	Thu, 28 May 2026 07:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953286;
	bh=vK6XINV85j2s6TrgSUq08NPf3qvCIuW4cqZINOK3rPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mC/kwi6Us+Mzhj4xAvTHS5kxwU9UeMAmB0sQKTZCMBfY25IK4gsFMM3ydQLs1zjzq
	 zJekufNp37Cz6cKdT9UztYZUKsRww4WsfKBw4h3xo8ZG9gFuWzpg5puC3sTdlgk4Br
	 FxqTwbyYJUT7ixVWza5yfEiprUHPJTwzSogSa6V7YeaLjby7sYaFvF2gnliBJVg01f
	 rAkfgW5IbBuqvoYQLndkKHFegPRiE7Gz85i+375gEkLBD+dwrVn7SnWX6DfLCtZhue
	 250wtDJ4rL78Mo+9dW2Pd8GoYM3SX/kMXec6t+Cr/RDpQ5XyoYkVwCyfGHk9fjbMBw
	 74AdQFn3iQ37Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 10:27:55 +0300
Subject: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
In-Reply-To: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2

The xor benchmark allocates 4 pages for a scratch buffer that is used
purely as a CPU-only XOR working area.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..7f6436774644 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kvfree(b1);
 	return 0;
 }
 

-- 
2.53.0

