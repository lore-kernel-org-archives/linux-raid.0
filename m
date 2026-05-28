Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD413B4EA0;
	Thu, 28 May 2026 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961994; cv=none; b=M3dl/K3IQnQZ4kYKmS29CKS0+hwzrsscCTOI2toVAFOX5I1jBKWUTPk0qqqLxs46FuGNOLBO86avm9UFP9ixXBg75CaJJsBOFjW6xHKwWJKvvLXEvGrdbakXMa7wYYAuGbkDu0VeIWgCVqvZjd3LnhOAUj+oN8GKldOr9NjzNhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961994; c=relaxed/simple;
	bh=WvdyEqmecA0grKVohRIg0XDFkSrkSv+rOqxMzjkqAK8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iumpdDbqR9fa6rtPAth+ZQX9kWUqIvjYXs9XZNtusVmsVtuYe+2YBDRpuGdoeZVZNS2Jz9imQTASDsHOrWHGkD4mxSVQeFraeuJDSLV0J3uu8EoHkTI3lBSYwSnKlHubO/SjPUaDTA4jQ01H0b4NoT/JXkJ6UIAfir0gsJLjFcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WB61z4ru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WB61z4ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACE01F00A3A;
	Thu, 28 May 2026 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961993;
	bh=OGdbcQNrXQCL8Ddddea0/7LpE/hNNIjnFgj+CnQ/xTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WB61z4ruKXd3kXi1juwOnQTES0jP99vbhpjVKBseJzQqU1WvQmmXuMsPpFfXt7Q4+
	 P3kRes5EuGy9jA7anxILQUeKc5/PfdDeoQx2dq6AImVn/4x/shEwx1HK3kHFR2vhjr
	 Vdef5wZzavi7Sa+MPNkPU/J3WHaL98aNiC6ztibn92IHxqb9RTrjkeJyICbIX4oqOf
	 R19dn9KX2Ts4jN9QTCA2rAwnZsLEa8fh++SpO4zDDPdEjJF0kx3SVVRYD7GRy0Wpx6
	 oYnqJNf/i9/8cQWqr2JbcixE/o1a5vnALBxJMzgisHS+mOtLpK57/VvEkU9NkJiaxE
	 LLRCCsjs8RFFQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 12:53:00 +0300
Subject: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
In-Reply-To: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
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
index bd4e6e434418..50931fbf0324 100644
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
+	kfree(b1);
 	return 0;
 }
 

-- 
2.53.0

