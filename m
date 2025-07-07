Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E522B226D1D
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907216; cv=none; b=hgFLAtxmkxdqw6AbQkxVWa5XeYWzNtN9Pp0eQdmpPqAMnRh/rUu0uJF4RKdcwGsOtx9VPHSl3lUyJCEaR+G97M8sJxNVt4UlKADwemgvBotUDigms5hPnAY39yU4/BLY35KWXfRp4Rd6sE6oDldECIMkptsbf45/MFrQmZ87zU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907216; c=relaxed/simple;
	bh=3LIJKVdjOak4rbq56z+IFJa8AA7k/raqJo82EMjIL1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avqra8bGDjxypgvOBvFsFPLCYtoQImsF+Fs8vC4kYfmXK8hziErBVgG0ZRSIl0PO1ejrq1sEDYVuWXd3SlxL7YLw1RlBJ+oZSc7I9DtYV2nrDJD6hp3gWSz2YjxbcrWWfNXik2Fdr1UvFD4XSldJ12tVkhKWwDir+M+8KC6bmRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jADv34ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jADv34ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5796AC4CEE3;
	Mon,  7 Jul 2025 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907215;
	bh=3LIJKVdjOak4rbq56z+IFJa8AA7k/raqJo82EMjIL1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jADv34ef4E9Eq2j6DSTCkHZNOsxwED4Rhk8tm68eOnvEZxLbkhnSmgMFW63cnWwDg
	 M5NFU9xXpJRbE3PdH28QXVIEMmZOuS7PdaThcIQ+g8w4FvRECBylkRAqWbP0XPhWv+
	 0Jt7+lQ1VafM4wx6Pi9/mAbyuYOdLIeVG82VV98oHxOsBGTs/QigKYp3/CB8NxzEE5
	 m5j53W9mRj/k6Mws20vTo9exz3zUroe6zzDM6jZy9x/ZXpge2YdSG/94SFIS5WfXHO
	 l7c4bdcQdF2UpsWk2KlA5RWsOEdv2KXDI3CnnkjwiqxDW3Dul3zcJtV9lD5uZd1yUi
	 bo7WJPkzwx+Fw==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 10/11] md/md-bitmap: make method bitmap_ops->daemon_work optional
Date: Tue,  8 Jul 2025 00:52:01 +0800
Message-ID: <20250707165202.11073-11-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707165202.11073-1-yukuai@kernel.org>
References: <20250707165202.11073-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

daemon_work() will be called by daemon thread, on the one hand, daemon
thread doesn't have strict wake-up time; on the other hand, too much
work are put to daemon thread, like handle sync IO, handle failed
or specail normal IO, handle recovery, and so on. Hence daemon thread
may be too busy to clear dirty bits in time.

Make bitmap_ops->daemon_work() optional and following patches will use
separate async work to clear dirty bits for the new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 43322d884055..7aa9692ccdd9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9885,7 +9885,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (md_bitmap_enabled(mddev, false))
+	if (md_bitmap_enabled(mddev, false) && mddev->bitmap_ops->daemon_work)
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
-- 
2.43.0

