Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C53238C3A;
	Fri, 23 Jan 2026 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192793; cv=none; b=H1NVKPWNZCOOAWbUQNZXP2sOPvFdoxHxeqzF9nlhNIcv9t6+tET7YO4ps6Q3F1pEuRQ3W/3RDV3oxvEaeSu57PLW+Gd/ideee8l/wXJPKK7m2GXBaeiJymk8+cJ3dRt772mwbYRUnhqKBGFNQUYJWtcdMM8YY5AWEcYavcr4dfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192793; c=relaxed/simple;
	bh=es4XLsBc1CzOFSj8PFbEdPhSa8T6ELUzxMO96G/0Sjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGmHZMzgfST3/X4rn3o1s4LWoSn5B99ku0E2nJxsRZFr18doblgOCW2ZTu0jxhx6YPvAdmu7IcX7F8uGpwOeQaj70g5YcvRHQRgvYzvtOfo9TMvHcQ6BebxhmxdnyU9Ym44fm8JofOuDu1RZaOWTjzowzErzyGi2ES7VELqnzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74E2C19425;
	Fri, 23 Jan 2026 18:26:30 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 2/2] md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout
Date: Sat, 24 Jan 2026 02:26:23 +0800
Message-ID: <20260123182623.3718551-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123182623.3718551-1-yukuai@fnnas.com>
References: <20260123182623.3718551-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When llbitmap_suspend_timeout() times out waiting for percpu_ref to
become zero, it returns -ETIMEDOUT without resurrecting the percpu_ref.
The caller (md_llbitmap_daemon_fn) then continues to the next page
without calling llbitmap_resume(), leaving the percpu_ref in a killed
state permanently.

Fix this by resurrecting the percpu_ref before returning the error,
ensuring the page control structure remains usable for subsequent
operations.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index b482a1db0861..7df15756142d 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -779,8 +779,10 @@ static int llbitmap_suspend_timeout(struct llbitmap *llbitmap, int page_idx)
 	percpu_ref_kill(&pctl->active);
 
 	if (!wait_event_timeout(pctl->wait, percpu_ref_is_zero(&pctl->active),
-			llbitmap->mddev->bitmap_info.daemon_sleep * HZ))
+			llbitmap->mddev->bitmap_info.daemon_sleep * HZ)) {
+		percpu_ref_resurrect(&pctl->active);
 		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.51.0

