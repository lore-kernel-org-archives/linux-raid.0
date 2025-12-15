Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F5E315D3F;
	Mon, 15 Dec 2025 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768546; cv=none; b=iaOEA4ldVyk3gZTR8lrM427Mf3vjSuEz4pUXrbWpHnFjxsk/tZAfI89pyeUAKK63zSP+01GFMLHpfcGHm5HI7/aQfQ3CXPKh1xyDUgc97JjuBXYZ+VsYCyz207+qfiyksUIFWYWsq4AjzNCy1uRutLu64fCHvUESm5iEH+LGs0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768546; c=relaxed/simple;
	bh=l8psrdmpOOAj9rtpB/hJQUSWa0AnaB2PvXlBsC6U+Yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gGUD4WRjiTlwkoh+SYPGHqvvx8Gbp7lMrVUnHotY4P3MtXDG/wlUPqB7OjEWPVpUNgv5+sq52uDYQC+j0GYH+bxHFBZ7+0fkybhooLOza+h7hEHNiGQ3DUnIwlN8al5V2IzFExXi14x4nb0nP8WrLXBu+FrS8CbK5lv4WGx2sL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dV4tn0s9HzYQtn6;
	Mon, 15 Dec 2025 11:15:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F141C1A084B;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S11;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 07/13] md: update curr_resync_completed even when MD_RECOVERY_INTR is set
Date: Mon, 15 Dec 2025 11:04:38 +0800
Message-Id: <20251215030444.1318434-8-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S11
X-Coremail-Antispam: 1UD129KBjvJXoW7AFy7XryDCr4fWw1UKrWxZwb_yoW8Xr43p3
	97JF9IkrW8ZFWayF4DXF1rZF95Z3y2yFZrAFW3W3yUAan5Aw17JFyFg3WUXFWDAr9Yqayf
	t34rG3y3Z3W8Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

An error sync IO may be done and sub 'recovery_active' while its
error handling work is pending. This work sets 'recovery_disabled'
and MD_RECOVERY_INTR, then later removes the bad disk without Faulty
flag. If 'curr_resync_completed' is updated before the disk is removed,
it could lead to reading from sync-failed regions.

With the previous patch, error IO will set badblocks or mark rdev as
Faulty, sync-failed regions are no longer readable. After waiting for
'recovery_active' to reach 0 (in the previous line), all sync IO has
*completed*, regardless of whether MD_RECOVERY_INTR is set. Thus, the
MD_RECOVERY_INTR check can be removed.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 39cb8430a7b1..cda434d8fe8c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9695,8 +9695,8 @@ void md_do_sync(struct md_thread *thread)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
+		/* All sync IO completes after recovery_active becomes 0 */
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
-- 
2.39.2

