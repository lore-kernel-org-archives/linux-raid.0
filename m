Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCFFB665;
	Fri, 26 Dec 2025 10:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766744810; cv=none; b=RLL8y8ret6qx4XLl6bg/TmUW3A7g3vyLqTVCbbz96k+6c+xfFgBevwkxKyTfVsxLjd9T1seg7NCKtwx5DyQYDuxidJ1chanolEC4hU2KA4pohDAidd0RQSSRYds7/oi4XcB2L5txWmefH3vAuKveqT43mVs5pzArwUtEY33oLHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766744810; c=relaxed/simple;
	bh=l8vSpn4jzRyAja859K7cLedoGBO+iyBTZcXuX3xBrio=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UpsPXH8Y6t/zQEaCZGEAJ3csUh2WFY5hldKDgF+X3irLI/u6rVtHoSxBWlkkK28acsODmWAyTpLthAxFD+aNvXSn9TRNs6MSxNePVFldu2xTgmMCrKdHW+jzL5F3zgwx82ULYVYbn4Sb4T9QL6sLMAU76Nnm4kZmI7jvoKe3qI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=XZvydCfg; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="XZvydCfg"
Received: from localhost.localdomain (unknown [10.17.211.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4dd1xd18VLzFcy30Q;
	Fri, 26 Dec 2025 18:26:45 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1766744805; bh=l8vSpn4jzRyAja859K7cLedoGBO+iyBTZcXuX3xBrio=;
	h=From:To:Cc:Subject:Date;
	b=XZvydCfgl/P1BbXi24uSolM7f35+AI5BAsr4djkMiY/BDp9ccJi0CXah+JCdXg5rG
	 lZzTBIoqQajD2ejB+TKtR3cLKKh6F/yjAfb8yHTXf62IRviosM38ypfEecppnFSMr1
	 Ee1bbU4t+Y8fe6q+gMSmFJQcsyiRmurKkOUo0sHQ=
From: dannyshih <dannyshih@synology.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dannyshih@synology.com
Subject: [PATCH v2] md: suspend array while updating raid_disks via sysfs
Date: Fri, 26 Dec 2025 18:18:16 +0800
Message-Id: <20251226101816.4506-1-dannyshih@synology.com>
X-Mailer: git-send-email 2.17.1
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

From: FengWei Shih <dannyshih@synology.com>

In raid1_reshape(), freeze_array() is called before modifying the r1bio
memory pool (conf->r1bio_pool) and conf->raid_disks, and
unfreeze_array() is called after the update is completed.

However, freeze_array() only waits until nr_sync_pending and
(nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
occurs, nr_queued is increased and the corresponding r1bio is queued to
either retry_list or bio_end_io_list. As a result, freeze_array() may
unblock before these r1bios are released.

This can lead to a situation where conf->raid_disks and the mempool have
already been updated while queued r1bios, allocated with the old
raid_disks value, are later released. Consequently, free_r1bio() may
access memory out of bounds in put_all_bios() and release r1bios of the
wrong size to the new mempool, potentially causing issues with the
mempool as well.

Since only normal I/O might increase nr_queued while an I/O error occurs,
suspending the array avoids this issue.

Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
the array. Therefore, we suspend the array when updating raid_disks
via sysfs to avoid this issue too.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
---
v2:
  * Suspend array unconditionally when updating raid_disks
  * Refine commit message to describe the issue more concretely
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e5922a682953..6bcbe1c7483c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4407,7 +4407,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err < 0)
 		return err;
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers)
@@ -4432,7 +4432,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
-- 
2.17.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
