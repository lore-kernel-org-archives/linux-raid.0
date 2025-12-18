Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C5125A354;
	Thu, 18 Dec 2025 09:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766048857; cv=none; b=lpJErwZnQQbzdEHKPfPRswTS07TYwErbwpO3gcWM5YjQyb75BhynFVjzecvCFlxYOe+/SW06AHn8c6/Qa+CUCr+/ggeIJzePNCj8uEeeatU4G62DwMXVcwcpIr/1xdFt7tARW8Chy27XGbLdq6qNtAhDW2GNFjUBMpeyjENG8fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766048857; c=relaxed/simple;
	bh=X1b2mAE4WTceDFBpcxrmuliicbFana9TW6rSBC9uYzc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dEAvuL1NGZjevwNyZ3cmVur/1dLn/5T5t7Bqu43DGop9BKH+I5S/MwuKX1HHz/bjJeTx6nl59Vc20wMkiN9nclu9wMfhx8i1/JIE3z7JFXH38UH0LOwXTI716aqcS8WPo6b5sxiNEY6icKZVFaazU90f3/8w0Rh8eXqESW7lCH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=iSWc9Q6C; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="iSWc9Q6C"
Received: from localhost.localdomain (unknown [10.17.211.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4dX4Yq2ByCzFVwQWm;
	Thu, 18 Dec 2025 17:07:27 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1766048847; bh=X1b2mAE4WTceDFBpcxrmuliicbFana9TW6rSBC9uYzc=;
	h=From:To:Cc:Subject:Date;
	b=iSWc9Q6CptR/QiOvQPUl62hTzJCjgIQUZu2zn7+n50JFMtXzwv95QYMBiH+uq2WWO
	 Y31KoyWN0ROvQpFKeLvzKwvJFtIG8myOrLHVo/RgPNZ2bvpf/3QhAvb8K6iDrd1ztz
	 RP5DjzfIYU3a+86lCHje+ikTnCjIAXTOHHC/13ns=
From: dannyshih <dannyshih@synology.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dannyshih@synology.com
Subject: [PATCH] md: suspend array while updating raid1 raid_disks via sysfs
Date: Thu, 18 Dec 2025 17:06:56 +0800
Message-Id: <20251218090656.10278-1-dannyshih@synology.com>
X-Mailer: git-send-email 2.17.1
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

From: FengWei Shih <dannyshih@synology.com>

When an I/O error occurs, the corresponding r1bio might be queued during
raid1_reshape() and not released. Leads to r1bio release with wrong
raid_disks.

* raid1_reshape() calls freeze_array(), which only waits for r1bios be
  queued or released.

Since only normal I/O might be queued while an I/O error occurs, suspending
the array avoids this issue.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
---
 drivers/md/md.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e5922a682953..6424652bce6e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4402,12 +4402,13 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned int n;
 	int err;
+	bool need_suspend = (mddev->pers && mddev->level == 1);
 
 	err = kstrtouint(buf, 10, &n);
 	if (err < 0)
 		return err;
 
-	err = mddev_lock(mddev);
+	err = need_suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers)
@@ -4432,7 +4433,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock(mddev);
+	need_suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
-- 
2.17.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
