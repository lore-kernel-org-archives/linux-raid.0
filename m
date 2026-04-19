Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B30E24EAB1;
	Sun, 19 Apr 2026 03:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568224; cv=none; b=SMgVf0LRGPy3Bdxmm1V6GO/UcToiAGdBGhLY6MZSGf8TE6qkpydL/UowErcvkFrlQ2d4Fgnguo0H2NvvvRjeHXRzT5xm+VLwKPoh6gm5br0C8zJYha+p+lH3fQOxcWZH4CgLnMKNPwU9iwq4bG1nsV+mxGlGU6KWNaxwB/PGZ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568224; c=relaxed/simple;
	bh=seWiTqYptwts6KzD/QbUd6SmhTb0ZxT8wZvFq11lhUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YME+VSgYAfw6vu9mxUQvxjJ2CMw2ht5OH6CBW9ffxSNM+T/AWG+tpInnl/FxfYftxUQQnSDKom9n8bIfq0wcM0nNYBCNoRZ0r3M0wSTLEiZOQn/9yQVDn3OZke/M3F9uYdIm3vvQY4PrKD2tstNCCxDWUJVcgYPebQiHnGE0OeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98362C2BCB7;
	Sun, 19 Apr 2026 03:10:22 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid10: split reshape bios before bitmap accounting
Date: Sun, 19 Apr 2026 11:09:38 +0800
Message-ID: <20260419030942.824195-16-yukuai@fnnas.com>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13e31d01ed0f..b54cb1828a48 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1891,6 +1891,12 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
+
+	bio = mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
+						&conf->bio_split);
+	if (!bio)
+		return true;
+
 	__make_request(mddev, bio, sectors);
 
 	/* In case raid10d snuck in to freeze_array */
@@ -4264,7 +4270,6 @@ static int raid10_check_reshape(struct mddev *mddev)
 	    mddev->new_chunk_sectors &&
 	    mddev->new_chunk_sectors < mddev->chunk_sectors)
 		return -EOPNOTSUPP;
-
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
 		return -EINVAL;
-- 
2.51.0

