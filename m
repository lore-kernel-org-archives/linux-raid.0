Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48DD34F489
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768156043; cv=none; b=Yja832DpJYe88VhovIg++77fETbC6CE8Ik2hKIJda2D1IpdbCiN/dW8zE7YaG3M6Yqixwj9uGzLhhny5q6Poo9xY1Ou38M2fyqHWGhC366MJjqZBSJEVk34lLQp7BigLMCkOg2djWmIT8uhovq65nUrUoautJmqJoCSLCiEE5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768156043; c=relaxed/simple;
	bh=FvDJ3PXx7WTjXPV2mZAIdQFFtOA5IdOuT//UUvQxIX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX+5zyJUMg0fpXqBU8MgCPlkj0aEwJxA5VxL2+yXXDk3xtQePIJsPx7PCx2TQhxMQRFFWmDLVLi4KvZGEm/PmW9d42Kzoalpef7bpdXd3D1UvHk6xMgfJ6aOb9QFizy2clfQnqEYRFYygA+cYw2Cap+JYjUGdzm/7OpyqK0qs9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A575C19423;
	Sun, 11 Jan 2026 18:27:20 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v3 10/11] md/raid0: align bio to io_opt
Date: Mon, 12 Jan 2026 02:26:50 +0800
Message-ID: <20260111182651.2097070-11-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111182651.2097070-1-yukuai@fnnas.com>
References: <20260111182651.2097070-1-yukuai@fnnas.com>
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
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid0.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f3814a69cd13..0ae44e3bfff2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -29,8 +29,7 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
 	 (1L << MD_FAILLAST_DEV) |	\
-	 (1L << MD_SERIALIZE_POLICY) |	\
-	 (1L << MD_BIO_ALIGN))
+	 (1L << MD_SERIALIZE_POLICY))
 
 /*
  * inform the user of the raid configuration
@@ -398,6 +397,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

