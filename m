Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E580EEB3
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 03:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772594098; cv=none; b=OYmiCGgRBNlp5tcGwq6aJL7lad1rAuZiP6NZs6UPl5VtXKQQw8d5Mzl5G3jPWJ0bUqoNKugDXHd3HKkzkT0KnB61jlF075+HP94jrw13AnBlj+MknvRJwhXd15D2DdRKzyuJwTc8hdjpqgKK6jeH4C+6CKD62pnts5GjAedRsAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772594098; c=relaxed/simple;
	bh=WBP3+epv2O9UuyONpdPTXnXPz0WOzaTZdJwVRDSbKa0=;
	h=Content-Type:Cc:Date:Message-Id:Mime-Version:To:From:Subject; b=k7MmzVbyq6hBwKO8kilC9qmYyOFGg4lnokSHc+u704tIOBNxp4I/GBnFqkCwKiEWlzeFny477tbkR18/Q1JIW0ensB/lJMXDDrfLjUCxKDsbM/oy92nTVqquAD6NzNmadYqtmNbTAhrDVmcZLEbI5uXKre1tnSexXB5vVDYwqyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=kSm6qv2B; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="kSm6qv2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772594084;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9uSUQOzX2/wQG1mb/CP9wL/Tw1uFzV2kpmm8IoPJscM=;
 b=kSm6qv2Bv04jBJXbw+tSM03G/C3RDssnL8ftxkTHK7uHDZSYVcoy5I+Cdu3IGUiqIkwEHl
 C/1YH0u6Yh2ojEWs7lOTalJZm7ogSvjXIehVHa85WPmDa5sLVZBVnroxjvv/a/CTWv93VR
 lpg5lVlaLZIiD7tcCKDiVAhukT5URCuhs02Q8sEIM59rQ9adg9RoEFCFxexe/JtpfZvbNL
 qgpxZGa3ZCfo2IwkiiNdLHL+IkhWIfLKwz0+3/GoxX5oynvdwvmyHPv8Wy3v2IDgzRy4Kt
 nI1EmgOOGzRk2c+wgLeVlYnzYuRPbX+v3yoxFpdDyF98W9dJ8Ivs+c79JM7Gyw==
X-Mailer: git-send-email 2.51.0
Content-Type: text/plain; charset=UTF-8
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	"Chen Cheng" <chencheng@fnnas.com>
Date: Wed,  4 Mar 2026 19:10:01 +0800
Message-Id: <20260304111001.15767-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from c ([113.111.140.155]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 11:14:41 +0800
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+269a7a3a2+28c5ed+vger.kernel.org+chencheng@fnnas.com>
Subject: [PATCH 2/2] md/raid5: move handle_stripe() comment to correct location
Content-Transfer-Encoding: 7bit

Move the handle_stripe() documentation comment from above
analyse_stripe() to directly above handle_stripe() where it belongs.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..48504b0e496b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4594,20 +4594,6 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	async_tx_quiesce(&tx);
 }
 
-/*
- * handle_stripe - do things to a stripe.
- *
- * We lock the stripe by setting STRIPE_ACTIVE and then examine the
- * state of various bits to see what needs to be done.
- * Possible results:
- *    return some read requests which now have data
- *    return some write requests which are safely on storage
- *    schedule a read on some buffers
- *    schedule a write of some buffers
- *    return confirmation of parity correctness
- *
- */
-
 static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	struct r5conf *conf = sh->raid_conf;
@@ -4901,6 +4887,18 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
+/*
+ * handle_stripe - do things to a stripe.
+ *
+ * We lock the stripe by setting STRIPE_ACTIVE and then examine the
+ * state of various bits to see what needs to be done.
+ * Possible results:
+ *    return some read requests which now have data
+ *    return some write requests which are safely on storage
+ *    schedule a read on some buffers
+ *    schedule a write of some buffers
+ *    return confirmation of parity correctness
+ */
 static void handle_stripe(struct stripe_head *sh)
 {
 	struct stripe_head_state s;
-- 
2.51.0
