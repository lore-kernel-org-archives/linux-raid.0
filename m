Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A62FD686;
	Fri, 21 Nov 2025 05:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702064; cv=none; b=SFGUQCahng3eFA6+PAFVjRSyRt/H9duWQcOlqyYy0SId9I1jJdMModvpb1dg31XyXrCg7AeOrsWhI3rBmPI0NpAeetBvTFv4ZweW+X4Ct74B+APIGnBNZEMFIJBV9lQT+CPm1xhgSdcX23v0v2tzKqFmd2MILj6HyJrgwbuuXME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702064; c=relaxed/simple;
	bh=BrsbRqsr457CDtLfeJtIVJOrgP/mPdHkCNkWNyPl22Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+dEQBsT/fAngI7nFcfycNPUB0UdbpX1M0394JCXVIE2KJeJ5iXHm4VWBzcIJgU4yG0ZVkM5a5fcNFQQCqg5YSssUNo1BBSJmnNj48UgNDuPDzWgMYYFxix21bqEr+sRP9U9aoCx49UKn/O//CIBy8pRK1VIEGiQjqIIhcSK8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CB5C19421;
	Fri, 21 Nov 2025 05:14:22 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 7/7] md/raid0: align bio to io_opt
Date: Fri, 21 Nov 2025 13:14:06 +0800
Message-ID: <20251121051406.1316884-9-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121051406.1316884-1-yukuai@fnnas.com>
References: <20251121051406.1316884-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The impact is not so significant for raid0 compared to raid5, however
it's still more appropriate to issue IOs evenly to underlying disks.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 47aee1b1d4d1..332f413bcf51 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -388,6 +388,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

