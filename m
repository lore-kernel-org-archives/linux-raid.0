Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F628F935;
	Sun, 19 Apr 2026 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568220; cv=none; b=nr2LWUSUb5XQQFrHVTlF99WUhYM9T8/1TmInt+1/7YhTWE0XJX+oV+d8WdoQzhcoVG6vOcwpj/QLhoQTPZdupqYX0/Kr+lOZ86+lXbBKFjM11ql0OVm6nHAgMIO/4FeTNhrSQjLPfu+YsrG2JfBXr9QzqoDr801qB+r09LckcUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568220; c=relaxed/simple;
	bh=UO2R+idYWvdfy++CVnG8KPItNQjLoNmlfx1LXf5zPP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkkP3lIbe8yVNq5f9clc2r9HzbZNYVGp0y0LA9dudpZe4lpVnungpJifd+zIItb2Unxs5QYkrQMVWXYze6ZHsgi5e5aAeCsgZKbLd/CBUpOHo2Dc8oA0vXG7JEDThdZzmzv0ZuEpNeGUibwABpcfl1gVdfD17zkPVdby9FD8Wfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688F3C2BCB6;
	Sun, 19 Apr 2026 03:10:18 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid10: reject llbitmap chunk shrink during reshape
Date: Sun, 19 Apr 2026 11:09:36 +0800
Message-ID: <20260419030942.824195-14-yukuai@fnnas.com>
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

llbitmap reshape keeps one live bitmap and only supports growing the
tracked chunk geometry. Reject RAID10 reshape attempts that would shrink
the llbitmap chunk size.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4901ebe45c87..ad19257c79fb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4260,6 +4260,10 @@ static int raid10_check_reshape(struct mddev *mddev)
 
 	if (conf->geo.far_copies != 1 && !conf->geo.far_offset)
 		return -EINVAL;
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
-- 
2.51.0

