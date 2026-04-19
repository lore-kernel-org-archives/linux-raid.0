Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112BE299927;
	Sun, 19 Apr 2026 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568228; cv=none; b=bknpMxn1fTMFkPEpjUJYcVYxtPCQu0q4gAHPZm620C0NC5JibcsGJ60OLFLGjZLR4hlRtZLilLy4boLnLVf9zQz/HYKqAdSs0CkqOI6Q7yps82W0yoJzSSSRA/CYEOTm7o2Sj6MlPcLVxwot04ety2XcA6CS/RfI1BjzESFpvn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568228; c=relaxed/simple;
	bh=2YCd3xY7Vg/lMaoFD0l2fjt4Aw90SWYQUMsUn83oL6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awysQAHBJeSqO9+QYbxU3W7GRW3SrtB9aVWfyjHb3l62wdx65oWP/g2F/ag+/D1992eWOo8dR/7Nfkfl7KYsgjneHMO+e2ummdk3He9GbSXlUNXb/g7NcwqKA54Fb95/5RmbwcxcJaWRJxp1/Eo6w3fhR/58zwpeqFD70bp5Ips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BC7C2BCB4;
	Sun, 19 Apr 2026 03:10:26 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: reject llbitmap chunk shrink during reshape
Date: Sun, 19 Apr 2026 11:09:40 +0800
Message-ID: <20260419030942.824195-18-yukuai@fnnas.com>
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
tracked chunk geometry. Reject RAID5 reshape attempts that would shrink
the llbitmap chunk size.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c58c175bad9..178283aa91a4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8459,6 +8459,9 @@ static int check_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
 	    mddev->delta_disks > 0)
 		if (resize_chunks(conf,
-- 
2.51.0

