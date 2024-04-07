Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7C044373
	for <linux-raid@vger.kernel.org>; Sun,  7 Apr 2024 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712496029; cv=none; b=rEHX+pUyP40LMKw9+gfwB3i9QnzlBJLqVpNES5rck/cT2clpYeO5kjK3E2hKeFObIGHgJUNTdFE6AaErLUQ0Ukh3X8CzId2dIR+y8pj5EX4jqsEzLp2jaxzK8b9a7X56hoe3IXKOeZvvRs2vRl2RMmw12sO0j3y6KczltEq4p/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712496029; c=relaxed/simple;
	bh=gAcqnn8q6dh2LPD9m+lIEzWsxpYhy/78/JsRLW2fyJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=czVGW6Cs2wZc4Jtc/JmuExdY9nASBO7qW3M3FUwodLcg3wBwo9cq3VR3e/j4mKCa9+pBwpNTFqxk8eei8NA1ne2eQnhmR6+6ed1CNHiVbH89z98fqzvfZIPDmnzUzBdJOFN0e5ldRYN3I6T4W4PpvvLAcs90l9iaIrHBFI5jp9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=auix/Hqg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auix/Hqg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712496026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KUBepHOmYlRsdpOU9NeSucoinqPuYLesTRviUQJH+40=;
	b=auix/HqgM6BBk9oyZM9ZdGR7WCJzNLP1opg2pVGUQ5AecpI9CZ2eTKekwE81XjhycNnPcC
	UR86L4I59BzEobv14HvhlBjFn/4iWraoDdeezPibCgWKtAf+67toj95IBPLHMF1kNbEVJK
	8ykNWlvawAXRgh/P2VAt5FJJdSGirV0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-5RjkPi5TOsaXlYwBl-sOHQ-1; Sun, 07 Apr 2024 09:20:21 -0400
X-MC-Unique: 5RjkPi5TOsaXlYwBl-sOHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0843927A63;
	Sun,  7 Apr 2024 13:20:20 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B82D489;
	Sun,  7 Apr 2024 13:20:19 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	janpieter.sollie@edpnet.be,
	Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH] block: allow device to have both virt_boundary_mask and max segment size
Date: Sun,  7 Apr 2024 21:19:31 +0800
Message-ID: <20240407131931.4055231-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

When one stacking device is over one device with virt_boundary_mask and
another one with max segment size, the stacking device have both limits
set. This way is allowed before d690cb8ae14b ("block: add an API to
atomically update queue limits").

Relax the limit so that we won't break such kind of stacking setting.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218687
Reported-by: janpieter.sollie@edpnet.be
Fixes: d690cb8ae14b ("block: add an API to atomically update queue limits")
Link: https://lore.kernel.org/linux-block/ZfGl8HzUpiOxCLm3@fedora/
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-settings.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cdbaef159c4b..d2731843f2fc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -182,17 +182,13 @@ static int blk_validate_limits(struct queue_limits *lim)
 		return -EINVAL;
 
 	/*
-	 * Devices that require a virtual boundary do not support scatter/gather
-	 * I/O natively, but instead require a descriptor list entry for each
-	 * page (which might not be identical to the Linux PAGE_SIZE).  Because
-	 * of that they are not limited by our notion of "segment size".
+	 * Stacking device may have both virtual boundary and max segment
+	 * size limit, so allow this setting now, and long-term the two
+	 * might need to move out of stacking limits since we have immutable
+	 * bvec and lower layer bio splitting is supposed to handle the two
+	 * correctly.
 	 */
-	if (lim->virt_boundary_mask) {
-		if (WARN_ON_ONCE(lim->max_segment_size &&
-				 lim->max_segment_size != UINT_MAX))
-			return -EINVAL;
-		lim->max_segment_size = UINT_MAX;
-	} else {
+	if (!lim->virt_boundary_mask) {
 		/*
 		 * The maximum segment size has an odd historic 64k default that
 		 * drivers probably should override.  Just like the I/O size we
-- 
2.41.0

