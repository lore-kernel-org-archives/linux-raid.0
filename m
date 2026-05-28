Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0F338936;
	Thu, 28 May 2026 07:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953290; cv=none; b=VMVC6rviPEKL8gWfFRq+iz0nkuqE7Ny3gAe1ZFI6YB6Y51RE5vfXjDqcSm02uWXzEQnCFyk7+Rfnu5H8YRwofKlyx5kzJD12eYGYXenNlSUwWltBbw6nFbTQoYg1W7dzRy5XAPL6eOvpw8GsBfIECbhTaWmJJ75c+TXoCXz4GtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953290; c=relaxed/simple;
	bh=hmQK5CIlFl2AvJIzl6zmbj4LT69qjpHZ564dgQ4OYk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HLio7wcfQG74kG4KkwJrvmtjFP+0enEbmMSLwp333WZbqPYUpp1Ogp/Mg/j1cyWUuQ5ARl0lZXsKDgwSe9ucGI3h8TWtq6zmxhUanBoButamisV/v2N1Lx5BV+tzhMFP+7qxI1Vs/sB+M7qSPtKWckL19m0L/yXKV7xma7imN3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgJkJFPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgJkJFPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B714E1F000E9;
	Thu, 28 May 2026 07:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953289;
	bh=XEeN37H8h/7BFZlOijbo/XwxvG5JbF06mBE8+arc+so=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kgJkJFPYhHjM8mv5iClIhg36up2oojmFtfnY1wVYRTJ7/24fTpLlPxNEvEAw2+Yhd
	 iAe/SQOAecbd6x3iEdLDZvS2Pc4lkTxiGn/D/ZjU5qg28/N02o01ou1wPK2BF2pwBL
	 HsnywiEzFWCAL7TQpPPCyHE5H+ArLHrVXrEd3W7mziDAXwhg+36pdITWg8amMaEpz2
	 kYS/x8midsVs+mPfdFZg/NKhhtUlsTgrL5HtNZC+emHlaWvK8g3ZopY0A3i/ernUkr
	 TvEyA6prgpTW+YFYTApj3ZT43BgMWtJxcmBeczun9u1jEjfTO7rHLM6UvTt+oQamRJ
	 cxGp/OeDwhIvg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 10:27:56 +0300
Subject: [PATCH v3 2/2] raid6: use kmalloc() in raid6_select_algo()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
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

raid6_select_algo() allocates 8 pages for buffer that is used
as a scratch area for selection of the best algorithm.

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
 lib/raid6/algos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..89e627c62e30 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/slab.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #endif
 
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
@@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
 	int i, cycle;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kfree(disk_ptr);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }

-- 
2.53.0

