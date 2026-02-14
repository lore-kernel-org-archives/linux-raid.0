Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8342556E;
	Sat, 14 Feb 2026 06:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771049421; cv=none; b=HkOBMqyGgaJM33wwaWIKGQ89P0T7i30EHiAahYxONHRmXzn7YZByBMBpDAImtFXOZwRPsr7Je6VW8fHyGSBMIf63AICQY3jABgkMIlKdw3zAlvog8g9RoPUuYI/u2CEQzg9qX4e4/OTu9HIwk1t8X4dHS7tU69rQpXYvcK9AOXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771049421; c=relaxed/simple;
	bh=HybwxZPJFePf5IrcSW9RiixkMxuqA8cWUXf7Sk2guos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9VsC4kvZQLT9StP+m2DD2s6GOz8eCN1yX9Xk/3Y6uxF7UauMSmzmNWdxjXeuQiw/Motk7lVRrNqAOOFdHUCnWC1q44nkntUNB0fnESlzm5EhgNXmCSPO7NCqfdvW3mSO0O66ZxN2iKnT7UYkuaYXlgGl//mxiYBViFq4cm2Z1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFF4C19421;
	Sat, 14 Feb 2026 06:10:19 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] md/md-llbitmap: raise barrier before state machine transition
Date: Sat, 14 Feb 2026 14:10:10 +0800
Message-ID: <20260214061013.2335604-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214061013.2335604-1-yukuai@fnnas.com>
References: <20260214061013.2335604-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the barrier raise operation before calling llbitmap_state_machine()
in both llbitmap_start_write() and llbitmap_start_discard(). This
ensures the barrier is in place before any state transitions occur,
preventing potential race conditions where the state machine could
complete before the barrier is properly raised.

Cc: stable@vger.kernel.org
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 30d7e36b22c4..5f9e7004e3e3 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1070,12 +1070,12 @@ static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 
-	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
-
 	while (page_start <= page_end) {
 		llbitmap_raise_barrier(llbitmap, page_start);
 		page_start++;
 	}
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
 }
 
 static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
@@ -1102,12 +1102,12 @@ static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 
-	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
-
 	while (page_start <= page_end) {
 		llbitmap_raise_barrier(llbitmap, page_start);
 		page_start++;
 	}
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
 }
 
 static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
-- 
2.51.0

