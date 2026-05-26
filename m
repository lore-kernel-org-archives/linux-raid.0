Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1364B413245;
	Tue, 26 May 2026 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779816867; cv=none; b=rVCTQFsf8w6nYaL8mECo/2qZYOpds50aaEpqudY9h4MQweiTkBxmqXPztZgNPJgXLWYv2XyTqwHBZQ+PM/cZ/AUcbCT86cRER6Z7v++a/4LVBRqHZXnqW1i+SZapFke/w9TrRdeQ7qSFvBoxcJ4//xV2m2fu1LSExeSZO5PaNxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779816867; c=relaxed/simple;
	bh=+kVEEPad4p9E6wfWh3wuCSowb33rj8HAypBNzhGd1EI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=E25Hm0c0YdB5skwiznN8ddMCWV+geBZmmoRq20tq1J7VMuFdnES62k50myX4NezmYRMmFDPdfzNlTeKDDqRRRLZubmG3SIUahhJ3pZMe3zloYliigDnqw4bYXk0c4IPTyVhCzdcREgRadLdxrTeMN2IRj2ty0sKC1moy6P+eFqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KzZJJvMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzZJJvMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6661F000E9;
	Tue, 26 May 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779816865;
	bh=Vqxs1I5bdTAYH0V+dlG6/NnYH/vhR2cqVACl9PGhZ/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KzZJJvMWPr5/qGRanYp6AyRxaSY6hs+mRVemb7s5u6BuaI84G91vRRoUA50a+ohct
	 a2aHo91a7jMToNT7aeZL0kWz3x78nIZxrSs2EQhHai4fDdaZ6Qy7WEedc6yy8gy6ch
	 tzohsl5Uqxi9Qq9Uc8dwprEFu19U0WtcsjZH1yag=
Date: Tue, 26 May 2026 10:34:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>, David Laight
 <david.laight.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org, Christoph Hellwig
 <hch@lst.de>
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-Id: <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
In-Reply-To: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
	<20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 May 2026 15:50:39 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> as a scratch area for selection of the best algorithm.
> 
> This buffer does not need to be physically contiguous and can be
> allocated with kvmalloc().
> 
> Replace __get_free_pages() call with kvmalloc().

This one needed some massaging due to hch's "cleanup the RAID6 P/Q
library" in mm-nonmm-unstable
(https://lore.kernel.org/20260518051804.462141-1-hch@lst.de)


From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/raid6: use kvmalloc() in raid6_select_algo()
Date: Tue, 26 May 2026 15:50:39 +0300

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/20260526-lib-v2-2-ca3f0fc24b14@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/raid/raid6/algos.c~lib-raid6-use-kvmalloc-in-raid6_select_algo
+++ a/lib/raid/raid6/algos.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/pq.h>
 #include <linux/static_call.h>
 #include <kunit/visibility.h>
@@ -153,7 +154,6 @@ EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
 #define RAID6_TIME_JIFFIES_LG2	4
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
 		const int disks)
@@ -247,7 +247,7 @@ static int __init raid6_select_algo(void
 	}
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -269,7 +269,7 @@ static int __init raid6_select_algo(void
 	/* select raid gen_syndrome function */
 	error = raid6_choose_gen(&dptrs, disks);
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kvfree(disk_ptr);
 
 	return error;
 }
_

