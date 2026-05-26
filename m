Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D7282F1D;
	Tue, 26 May 2026 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779799851; cv=none; b=SeL0nJXHmANl/VnVkqsKZ7BaS5Ti+l8SWUCWF1NmK0Zi+vQZ7XK4gGzj6BOiD2k5/0AtvosE+/Wz+5ONoxGLh7CBO9QI3sgyqHhcEcZSmtpbySjxpBX1tWWDjKfd0o2LihMWsQnfLdQzWzv6XdKBWJZEWcJEzQoFGIkaeNLgT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779799851; c=relaxed/simple;
	bh=waOpvh1dKixEiq+Rh+Oy1qMbpXxxRNDHAhq17n30t8Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nUA8u9kSN7pmPKk8hG5+CHgDFVlIBs1n6tgWYDcD3l+19lWFXHkhmBTTxUNtp8DgirIJMK8NzXrqxirWEhZoivXc9mj/kioA4vKbls1nPVLu+AzVfICvc+kRV/i7bDwppiXcz4kAp167DJd10geVP3OBuNHpXCjRadqxnxD7Z5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzRvk5e2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzRvk5e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322511F00A3A;
	Tue, 26 May 2026 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799850;
	bh=gG3agpilQ4MpstT87zE1nTk6qyo1jydMxmD6GEu/XHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kzRvk5e2BuxIoYvQBIBHk0zrhimZ69ezYEbWKQnDRvl+hWoHZlCvC1utbNfSVFlDg
	 g+gt5jlLpowccZktUJNPftQgbnlbbYSrRqSxf4BHHILI2oSn5goR7MuohL6wIqpngL
	 /uDAi9axGu4c4o92x8enOa6G028OeH1L8T1pxnWiHD9Yn3lzuKREi/sp1xo2BuSxFL
	 M/UBFB0KeVeioL7xSQeU290fo4vNvp23LGZjEELBmWydJuc+Kn2zwZsaH9UjvVlw6l
	 AiaN5Rpd2gAiV+mGetKbZwGx6Bxi1PNhxwienG7NUc7I+FMAG1ktlZq/qwPMvFiY+g
	 XKIZeEkADdl2w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 26 May 2026 15:50:39 +0300
Subject: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
In-Reply-To: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid6/algos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..1f565c3b63ce 100644
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
+	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kvfree(disk_ptr);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }

-- 
2.53.0

