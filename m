Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90F4299927;
	Sun, 19 Apr 2026 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568231; cv=none; b=rMbcQJNtvxQGjOCOhCQ5KVYNeyz4bqyM9Zv5fA5fcfZCvxPrWjYryy20ddaGnMbUwLlhjltlrF/eT86KgmjvefzjMom9+by1L//kABTbxMYEt5d0cia3fx0l8TGIuVunfUUH3ulvrKl1dc3yFKKlT3GabZx3Tn+MH7GDGO46ls0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568231; c=relaxed/simple;
	bh=HsvM4wHnZkbxHsWTkTY3B8xF/xL992G2yXKp74HVTlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LA71rUE6A2QGLzkoiFJW/pImaJXBSg22hJbA6snLfDIjPX1aYLePFLe+aLqdadEEiuRGl3y7xPyKCWOakJj/A7rVZ1mP+zmYpWqh+F/YsKFVDF2b6hy+zFkV4m6W2k8ThK+p/rmNAGoiAbFqr5rxydD8QqhSCqT3e97Q4uhRKXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E711C2BCB0;
	Sun, 19 Apr 2026 03:10:30 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: split reshape bios before bitmap accounting
Date: Sun, 19 Apr 2026 11:09:42 +0800
Message-ID: <20260419030942.824195-20-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID5
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 476f6fc5a97c..7fa74c60c7d8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6134,6 +6134,14 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return true;
 	}
 
+	bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
+					       &conf->bio_split);
+	if (!bi) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
 	bi->bi_next = NULL;
 
-- 
2.51.0

