Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E897730EF6A
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455190; cv=none; b=QOvUx5OTYS6e/DyEF7dnXNI0PoZ3VtzwgT5RbRQ8s2oh2+AcEe92KpaIILbR9DDUjTDSFHsUzaBz2hSanpOu5kILWzZu+lJgZgPCFgId+yOjxrr044oSheNfgl6eXaTgy5H5yKY3RuPq3aUudJPioyxEfkHQ33V0c9XRdR2+mDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455190; c=relaxed/simple;
	bh=WAc2Acq73SBDFe9cL4p3D9sMxC+yEhbbN+qNSuKZSjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXL+jfOcNYTy/qDzijRN7bxhbaz8MpxPkHyOUOXhR7BghkeZPkqUFEQUQyEJVew0HSApP8ceIWbrHr4iZvtH1KNBmmS8kkmq4E5r4a0Y8MJLrpg5HLdqpBNeqnyaH0AzRjTyrA5pYvoe6Gbmujo9G0/1YKIrSmDJGa8gKBbgT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C850C113D0;
	Sat,  3 Jan 2026 15:46:27 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 09/11] md/raid10: align bio to io_opt
Date: Sat,  3 Jan 2026 23:45:41 +0800
Message-ID: <20260103154543.832844-10-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The impact is not so significant for raid10 compared to raid5, however
it's still more appropriate to issue IOs evenly to underlying disks.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 09328e032f14..2c6b65b83724 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4008,6 +4008,8 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

