Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4576D17BAE;
	Thu, 25 Jan 2024 08:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706170899; cv=none; b=mffqB18+lnfPaFSfcCn/FJFmAKXxWIedAb/b0SZ15sYYtnOOqUASenqqWt7aSHO/5efVkh751to6iqycpPscJWYOXrNRg7rs4/kfn5lW/9C94r9QaWxw5mVGC7g1KQvYLNTNCqbP/Uhsd9P8aOqVAtmhECIAmGWr2/tmHVRoJsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706170899; c=relaxed/simple;
	bh=z8VFyqlLFgh7+Kz4caXML4Z3L3TZRNowmZF25l4/itg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sdUV0HumMmYw1Y0DLnaGaIacg59RXgpoZDe6mp3quoqNL8PV/d0mFRAr3z0xtodlcfQQ18w/CLx4iSKvdg7U5Nq1yZouJCL+xs5cX9cxXm3cuXDEjvjqRX+icm9MwDBOJH3ruT6fkbab4fkizG/CnTyFqTBPnC3zqyXyClGvZkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE/UbpJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE/UbpJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ADEC433C7;
	Thu, 25 Jan 2024 08:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706170898;
	bh=z8VFyqlLFgh7+Kz4caXML4Z3L3TZRNowmZF25l4/itg=;
	h=From:To:Cc:Subject:Date:From;
	b=eE/UbpJ1F7+XYE/v3kny8BDaDe7X+4nVU5BNASzys59AGVWduqh1N6JXo+DwSnnmS
	 yAzMK50ERi9ZcEN7SEnbgzuEkS6Z4y0U5Fh08ekpirVqDpqXUptGGW21/A85oDWSaO
	 EklB7B8m5OcQTT5ViThg0DCp52Y+5vBi8dr89spa7ygazSi3mtt4mNZYOuWN6VHoim
	 9rrfE2AbUqLIktkLGDC8UShfGsoC+XV84lFEEKRfoFrkZH+oUKG5LHx5G2Ikv9+z50
	 VZJIiKB1NLocX8aS9x4tPEJzl7xuJU+9KlWHya7ubNhUwOlet/X0rs9OopqW6fcxaL
	 Z4luGCuML961w==
From: Song Liu <song@kernel.org>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	Song Liu <song@kernel.org>,
	Dan Moulding <dan@danm.net>,
	stable@vger.kernel.org,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d""
Date: Thu, 25 Jan 2024 00:21:31 -0800
Message-Id: <20240125082131.788600-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d.

The original set [1][2] was expected to undo a suboptimal fix in [2], and
replace it with a better fix [1]. However, as reported by Dan Moulding [2]
causes an issue with raid5 with journal device.

Revert [2] for now to close the issue. We will follow up on another issue
reported by Juxiao Bi, as [2] is expected to fix it. We believe this is a
good trade-off, because the latter issue happens less freqently.

In the meanwhile, we will NOT revert [1], as it contains the right logic.

Reported-by: Dan Moulding <dan@danm.net>
Closes: https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
Fixes: bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
Cc: stable@vger.kernel.org # v5.19+
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>

[1] commit d6e035aad6c0 ("md: bypass block throttle for superblock update")
[2] commit bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
---
 drivers/md/raid5.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8497880135ee..2b2f03705990 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6773,7 +6774,18 @@ static void raid5d(struct md_thread *thread)
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
+
+			/*
+			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
+			 * seeing md_check_recovery() is needed to clear
+			 * the flag when using mdmon.
+			 */
+			continue;
 		}
+
+		wait_event_lock_irq(mddev->sb_wait,
+			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
+			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-- 
2.34.1

