Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619BA3AB285;
	Wed, 20 May 2026 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779265100; cv=none; b=F8oMAkt6a83PaNkhgHrs1/deMyBF+1rw00icYIpTD8VXfV3/yqsOE6iikthDnN2L4SwjXXxNzc2nQS6gYez8SgNsGZb66ph8wSt8kQiJ2oWEC7dXlXM2HNwSlNFut2ZUZiQ+ghnkx+sZK2gngvOkD8+inMA6d16+wqO31Z5XnyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779265100; c=relaxed/simple;
	bh=q9Gsdt0cXBz4PyQ4PCQeUMUOuQYy3gXLLlq8Jj37C5g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W3wTLg0Bzabum+sSXHttBrcl1JIhsz1EYUedIqu4ormr/r8LR+q61fgHv7asRo0Kg6b8aTmile0xy4BosrYSQH3MYS2U1bJQMrDdfsLYw0MWwjZAAKL0tfuenAzvjtAG7Qw11M+j1CZBcqJlYI4FvjpfVlLf1jr0NymOU0bQ02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/ZKTOjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/ZKTOjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B08A1F00894;
	Wed, 20 May 2026 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265096;
	bh=k2FbEmgfTakOPvDjfl+izIomr2gAyw86w9Zoc4wPOn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=f/ZKTOjMOgD3U2blzJ+h4ceZoCdNJlYopEa96R62r7OrB2/5n0GIowc9MAhVcmVXa
	 QOhmvK8upbuSMzUYRoT0c2kfgSngby3OYzgwKasMzNuMGyFdU3FT+C+0BCliMI5MSS
	 DEJZ8UhcmL1501bV8/DNkWaqMEYQxaE+P22jFVS/tq6mnL5RPQ0DsYDI8za/gGUK5g
	 yF2xuMC93sLZOZY0x9NU3EQNF2PwmksmsaIN3LpsqFpcuIXEuQYf1wODlv5rnGufjh
	 XzT8eA26NZuMOcKtkWJE+c/7FVhkWSFlRcfjjjvJ95lF36C92HZH8u+yFEWpnYV/Hj
	 793Pwm5P/L7Xw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:17:52 +0300
Subject: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
In-Reply-To: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1808; i=rppt@kernel.org;
 h=from:subject:message-id; bh=q9Gsdt0cXBz4PyQ4PCQeUMUOuQYy3gXLLlq8Jj37C5g=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW4+DEs07xMRx4x2hkERcYEvsIS/qdfSMecZv
 0s8qlVLLwWJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uPgAKCRA5A4Ymyw79
 kRJiB/oDj/xpRQnkLam4xzCl9AtztZS6hemp7DIu91gmzKLPDj6LDSAceHF9JjUmkqfSz0aCfoL
 pvyG7vr258saAw8BWz/pnezoqmbpMTARF9EgyzxV49VoqUMqp3IVe0N9X8t1/I+8A8XnzvDv3mC
 ccddKyQyH75lES/d5DvYnTUDgFtixBNMd+4V/QmLL4gpIEz8LcwHool9RmeVjqUSXNwxb8BRGC/
 VTI2QeahG84neO2ur22DCpYvJ/xxm2wELXNfOpopz8LwOJjc1IAeOHKPK6XJT56WboJaqw9x41c
 FS5cOao/APBRaiSu9DucsEkyzoP2oPTJbzumOiQziwW1hZkJ
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

For such large allocations kmalloc() would fall back to alloc_pages() but
still kmalloc() is a better API as it does not require unnecessary
castings and may provide more debugging possibilities.

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

