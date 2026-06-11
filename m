Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB8382397;
	Thu, 11 Jun 2026 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167249; cv=none; b=RuBzTyT9VqbQyMPFifG8Vr8kPNBUMOnMRSapVxqZHxI8zeus6yV3tYu9YQDRGlI/UZCyBxHjWsTjse+iY4DihJTqJNPitqlIwM53OrAh1i1gqWLVmMBU5fc5R2JUPN9sJHX7NUArGkPNj6Dz16pci5ETMOozzhoFz8UI4AjEzSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167249; c=relaxed/simple;
	bh=Oq/qsLERGYGTAiuBjiTmMimRuC88Hzes81qAw/2nNH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r8ZF70BpkgLmpPVvtOJdSbEZ2AtQdPPSOA7yxnmt7VrL+1OtbgdMfoiRoY5bJFfKEH/7r8QbWp5SWww14PrY0wBpfjaYTQrJ0JlK6RhMmspsis+SYYtjemvrk5DOlcHx7QZ9NellaDeY0X6l4aK10uaHVnMXRhIXq/NVZwfxS9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=AP7iUm++; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="AP7iUm++"
Received: from PC-202605011814.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 41fb6eb7d;
	Thu, 11 Jun 2026 16:35:23 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Cc: lilingfeng3@huawei.com,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	runyu.xiao@seu.edu.cn
Subject: [PATCH] md: use READ_ONCE() for rdev_attr_show() mddev check
Date: Thu, 11 Jun 2026 16:35:10 +0800
Message-Id: <20260611083510.476945-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eb5d25a7203a1kunma35ec82815a966
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQxlKVkJMSx5IGksdGRgZT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=AP7iUm++6as5L0EKSxW/vdS7oxWaVWFMDrJOUb2o8JrI6U/ibEutdh9xPgPPhtKXoLZmxeRTt5bnzi5Ods9PxkczA+cmTZsFGl4qhb6U2r9FTVHac+8oiRamVAWbtTD4VTBFSlcA5LupjbwYQPzMwVNQaUiXIjA1t9Zaktb7COg=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=4zWuxUGkhojOWNfupZXmOzKeTJEEueS0vLRS0sVjEXg=;
	h=date:mime-version:subject:message-id:from;

md_kick_rdev_from_array() clears rdev->mddev with
WRITE_ONCE(rdev->mddev, NULL), and rdev_attr_store() already snapshots
that same shared pointer with READ_ONCE(rdev->mddev). rdev_attr_show()
still tests the pointer with a plain lockless `if (!rdev->mddev)` before
calling entry->show().

A running system can reach this by reading rdev sysfs attributes while a
device removal path is tearing the same md_rdev down. In that window,
rdev_attr_show() can pass a stale plain guard while sibling
rdev_attr_store() already observes NULL and returns -ENODEV, leaving the
show path to operate after the shared mddev pointer has been revoked.

Use READ_ONCE() in rdev_attr_show() so this sysfs read side matches the
existing visibility contract on rdev->mddev.

Fixes: 9cfcf99e7ed6 ("md: get rdev->mddev with READ_ONCE()")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 92ec4be20db8..a021cf4a798d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3704,7 +3704,7 @@ rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 
 	if (!entry->show)
 		return -EIO;
-	if (!rdev->mddev)
+	if (!READ_ONCE(rdev->mddev))
 		return -ENODEV;
 	return entry->show(rdev, page);
 }
-- 
2.34.1
