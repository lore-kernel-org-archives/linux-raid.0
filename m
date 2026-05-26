Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1123E320;
	Tue, 26 May 2026 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779799849; cv=none; b=POE3VBcwSiuPV/D18G0KGeCVoDd4WIv/xINDOCzY2h4GrJ4UVFR2lJq2kyWyDrbUC8CUm0PncCzspUHch+dejGz3NoliQklpDo7tyEojfUgfcTj7Qxdqo/5UFYrtMNikL4/CZz6W1nIwqHln6hn1u89mhvMkuWmSljpj45dnvmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779799849; c=relaxed/simple;
	bh=EqdsgzZUQfKmB18TqBHXZJ9Y28iWnSY2mbUxQq90Egg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QkIcx9K0uLZVDbf2rJbsjkHQ1MJ/y+4y6TcJRGa+6oVk/nYCouoZJ+uyACSE/wqMbdCux7212H0x/VFZHbGdICdKKLkL8AQz7xTeBWSSSHpBxyrq3uEye1/5lDZlyOfIdneCOIz0c0Se+AzhFE0ZheZa/S6j8i8BNlLC0NJmTdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQ1b9wxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQ1b9wxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A701F000E9;
	Tue, 26 May 2026 12:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799847;
	bh=QS3zRW8grvktqu3cBj8ik+A7ULBupIIqXCgnBPaCvWo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IQ1b9wxiRyLWKHqw+KxnzMq43qjljDVqd/WO/+7KPyig4hWPh1VKmjmKKkWy8lH5Y
	 dqKRK+jjsUHHhYgbLrv68HFDOiXsmfAYvck2KGHGI+hVLxDrgYgsQ8VKFM8cxqR+0F
	 agAQkMh9sr4/WIiGPgSSFwO6QqjX+DTIE0L/eoYfp2Bs5w423vU6Rr3jNWjheX+Mf9
	 EE6vu3kBG+pApECzc+82V1HH2lH0QMY3JsLrv9lhQfNNUFSgShmWLiIZFgr9hvumIL
	 hUX++I+joboSxouM4uH4nkcJxIThVoLfkamIptxo3bwdgLdx7cH0DYcviSVYt8pht6
	 UGhc+KlmTbMlw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 26 May 2026 15:50:38 +0300
Subject: [PATCH v2 1/2] lib/raid: use kvmalloc() in calibrate_xor_blocks()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
In-Reply-To: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2

The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
used purely as a CPU-only XOR working area.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..9f90620617cd 100644
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
+	b1 = kvmalloc(PAGE_SIZE * 4, GFP_KERNEL);
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

