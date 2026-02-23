Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FB220B80B;
	Mon, 23 Feb 2026 02:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771814444; cv=none; b=IkzElkvXYM+Vzu6v2F/4kEH1kiRSaI7uwdLcdBe9i1Z41ZrGX1fAI7pTDlZ+7TxoVb45XMJIOUXi3rvd5P1+VaWHNLAC2srrW+o1e4O8421oLbw1kAiF6gi+9oXq50aOtwKvMKUq+I/ontUMVGQ4huFvcb/2KjIioi2g4xdPXjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771814444; c=relaxed/simple;
	bh=7Tm19XjqDZryvGVvRo6y2vQQHtmWELjPcCgnqGUNitc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxw96kV66CTEQOajYjjG9fZugfstH1uSNzL/MqU70JhtKYqiU5RkcmVXf84+pPlw3+O7GGCuLcV4eAklx5C8ph1AOXuL/t/UN4uZ3u8KNU8ZPOsI/97ti1teDQGz1p1vGLhKkYYJW6p5eVK/WZyzX19r2tgFpdM/SdCs48ZeW3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885C1C19425;
	Mon, 23 Feb 2026 02:40:42 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] md/md-llbitmap: skip reading rdevs that are not in_sync
Date: Mon, 23 Feb 2026 10:40:34 +0800
Message-ID: <20260223024038.3084853-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223024038.3084853-1-yukuai@fnnas.com>
References: <20260223024038.3084853-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reading bitmap pages from member disks, the code iterates through
all rdevs and attempts to read from the first available one. However,
it only checks for raid_disk assignment and Faulty flag, missing the
In_sync flag check.

This can cause bitmap data to be read from spare disks that are still
being rebuilt and don't have valid bitmap information yet. Reading
stale or uninitialized bitmap data from such disks can lead to
incorrect dirty bit tracking, potentially causing data corruption
during recovery or normal operation.

Add the In_sync flag check to ensure bitmap pages are only read from
fully synchronized member disks that have valid bitmap data.

Cc: stable@vger.kernel.org
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cd713a7dc270..30d7e36b22c4 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -459,7 +459,8 @@ static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
 	rdev_for_each(rdev, mddev) {
 		sector_t sector;
 
-		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags) ||
+		    !test_bit(In_sync, &rdev->flags))
 			continue;
 
 		sector = mddev->bitmap_info.offset +
-- 
2.51.0

