Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F83AA187;
	Wed, 20 May 2026 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779265099; cv=none; b=MIqdSnzALtY836u8/esTSZH0FFmHJdbVHPFcGoMbkQqARG3NcMYQFQm3ln80J6NHRnWXLWakJ8+pt1/gMB0AUSuTbsGxUKRAhIoN/0rDGbZYuVF8yI4PnhQeliPd8F2uIJO5RxgrNU5Ux6+iKv6i+VLNHXt9SWTpPLRnc/NOOaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779265099; c=relaxed/simple;
	bh=KJAXU5mOv5CPom1VzUfgV8OYGplwFlepp+4o2eZA+P4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jZQX8U3PBMV/+5hUkmL+Um7kA9YivEOFwDXZNieeOGuhDlL5DITuzjtlC18hFZWu7rH5GyU1Maliq+hV8CIEBUqI6hfo1FoY1yCz0jYQoyZvaK1ULgMCI/2Bt80F6FMmYgEW1IwUX5A99xz3J7OHLwku0yHOyOB7KCv1pmbvdgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRc9V5gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRc9V5gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED581F00893;
	Wed, 20 May 2026 08:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265094;
	bh=KVhmFVQ+VeHD9Mhthtt+R9jKuKGcX+eKn8UdrkQekrc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KRc9V5gz/4zLGhneV/L9/0Nr5pQftNbWvQkuDBDfuA2LLPSvFpQw4iWEtoztFwy1d
	 2sKHRVQac9oRTWv4nvlW04KT+PZfiRPOV5P9oM6Gr8H2X1p5lkeIk3bTIFy/RVsiIe
	 G3ri27Up+eJss9Amuy1kxaYpQgSV79+o+cTEvcjA//XjBkhAGb+aWjGUiqdHRHorc9
	 t0K9NG6z8R9K2ul2z3FffIdW9pc+6W5v5zp15X+vP9A2BSMbbIR3oS6mJFDJuJJxF7
	 4eEWge2JAk0jW5paGlKp1P6agXlyt0LTgy0zh1eBcSRHB3R4sSRqjn+wWzCOPDImb3
	 fx/igN9m/KCLg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:17:51 +0300
Subject: [PATCH 1/2] lib/raid: use kmalloc() in calibrate_xor_blocks()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-lib-v1-1-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
In-Reply-To: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1498; i=rppt@kernel.org;
 h=from:subject:message-id; bh=KJAXU5mOv5CPom1VzUfgV8OYGplwFlepp+4o2eZA+P4=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW47MV87uO+B/bp1693WxM1CGNkAUmHMa1i6U
 EEL3lQU9t6JATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uOwAKCRA5A4Ymyw79
 kV24B/45axPy5o8zh7l/vNdFFfw5H/PrwPWpHsCU1CwDC9J5wgW0dExMMpkXTernBctaYWzIR8n
 ViLBNu7MFva22LD+WDscfKxRRpUOpZiNUq6nMzK6RW3B4DbKzGIu2ZlMuqkuxp7IJ8eNMwn17gg
 dwoU8ebvXNZhdhCDEb1lGyWp/YvU3lJo+9kVmas87pTKolroWdfgozYDW9tyRIJTrQGSl4ouF4x
 YVGh0856B/QvqdSaQf6r02QbZUBpoBBlcyJ4G2AgpUMOWQ2zCa3sibeUynR9cO7sQVrsbIlQyV6
 +tCVUS0Id5dZuZAIeSL8KxEn4suDWkpfobOs8kIaX59lb543
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9

The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
used purely as a CPU-only XOR working area.

For such large allocations kmalloc() would fall back to alloc_pages() but
still kmalloc() is a better API as it does not require unnecessary
castings and may provide more debugging possibilities.

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

