Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6863620B80B;
	Mon, 23 Feb 2026 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771814446; cv=none; b=t+sdLHW/iNKM9zdPEn7xMhsEZedM3V6/Q8Fh+zS+mOTjK46a7xo27nyANqywx234KXZmRIvLwIZeTp107MoS1g9LoFLcwPGu/zFtPPvgTDkohPy6J/yndMlOC+Rw5iXP6B3satjEyp5lQnrGS0WyO2UFp2eB2oP0r4fsgkBw+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771814446; c=relaxed/simple;
	bh=HybwxZPJFePf5IrcSW9RiixkMxuqA8cWUXf7Sk2guos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASnjIXkfyHNEWowh7oxqCd7nUtFlcNRyx/XmeXQeRjbdFyjwzeky7RVIHhMVTUBlH1QtriFm2w527x5YARQoGv30IyZXEcUKEGWfkdnChMhl2eLldn9mH0GsoXFt9qLklDmcVCniCnLVyQE5KN9sDLZHykmKua9M912Hy5D19Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A728C19422;
	Mon, 23 Feb 2026 02:40:44 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] md/md-llbitmap: raise barrier before state machine transition
Date: Mon, 23 Feb 2026 10:40:35 +0800
Message-ID: <20260223024038.3084853-3-yukuai@fnnas.com>
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

