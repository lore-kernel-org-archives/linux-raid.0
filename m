Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F51377547;
	Tue,  3 Feb 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099769; cv=none; b=hcZEx0Paklph2TVUVmKJt3mx2E4VsTA3rtirYyq9NSBxMzUkBEByuCj4qUAWPuvoiG5IA3SbvWySOBhLMEBCZ0oDvbWZOoTr1dD9Q1LaVphYINufKg4Loh8z3kgg0w5uIDg2MbNAoYXM0/QTPjkylz+MkRIRkewSSCuF7wzg3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099769; c=relaxed/simple;
	bh=N8cMkYEkZql+f7mnQFaQl25S9gxCUSplDyNWjboiG7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=riNKxGK/wtR3j79s7YHeU/kyTPoA+MigFj6+OIWGhwZ/uD6vvIfsplMObS5rEZcvodfXzlvPRGNXRsO/32mEyWWD5OScxYvIZnyqPJZhCaq7yXveSmF+gQwGbi8gGnM/A25jJCg97SA6dCccCivECJLT/+oOs4i5WfxOepuybnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f4tg755FSzYQtxT;
	Tue,  3 Feb 2026 14:21:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A377640574;
	Tue,  3 Feb 2026 14:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_cilIFpIQhbGA--.27054S6;
	Tue, 03 Feb 2026 14:22:42 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [RFC v2 2/5] md: serialize requested sync actions and clear stale request state
Date: Tue,  3 Feb 2026 14:12:56 +0800
Message-Id: <20260203061259.609206-3-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_cilIFpIQhbGA--.27054S6
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48uFW5Wr13WFy5KF4kWFg_yoW8ArW3pa
	yxJFn0krWrJFWfX348ta4DZ34rXw1j9rZrtrW7uas3JF98Ka1kAFs0gasrXrWkJayrZa1Y
	vw45GFsrZFy0kw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j0
	UDXUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

In handle_requested_sync_action(), return -EBUSY when
MD_RECOVERY_REQUESTED is already set. This serializes requested sync
actions (such as check or repair) and avoids a race window where a
second sync request can be issued before MD_RECOVERY_RUNNING is set,
resulting in the later request being neither rejected nor executed.

Additionally, in md_check_recovery(), clear requested-sync related
state bits when no recovery operation is running. This prevents stale
request state from persisting in cases where a sync action is queued
and 'frozen' is written before MD_RECOVERY_RUNNING is set, which would
cause subsequent sync requests to spuriously fail with -EBUSY.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84af578876e2..7fe02ee21d3e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -668,6 +668,9 @@ void mddev_put(struct mddev *mddev)
 static int handle_requested_sync_action(struct mddev *mddev,
 					enum sync_action action)
 {
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		return -EBUSY;
+
 	switch (action) {
 	case ACTION_CHECK:
 		set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -10318,6 +10321,9 @@ void md_check_recovery(struct mddev *mddev)
 			queue_work(md_misc_wq, &mddev->sync_work);
 		} else {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 			wake_up(&resync_wait);
 		}
 
-- 
2.39.2

