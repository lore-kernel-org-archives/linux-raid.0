Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB683F074F;
	Fri, 27 Mar 2026 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620461; cv=none; b=mzY4o6McgBgvmRAjurvH+XmwIMoRn6mP3Aok2rczc+03KBWtVw9TCNWh5L39JoeF8XXkwRRWPEiWf8ACIRnd/P4R0GzKFxKOa4gCRh73zQ2pA2OzYfY7kJ+uGmPF8N8LArGLPnPjwuCCwEGe/MVSY06Z5dISQJo6Fd/c/ZZQris=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620461; c=relaxed/simple;
	bh=adyL7f/QLOugkZjfdxLTEKpOJR2Nr7hdyE3uPISW/Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pWLG07ZP+NepzbarP2eCBfdqyZEys69VKNVsm/1A1xvWwfLSBynpq+xLB8jx23LKYcwyZ4NCQKmXdpV4fnlfJw4C1OvkkdVORq763a2BwxA3XNbAv0EVKQpjkQN50II6HTxCJwrkR41DiDvTDLjofU4vauwcHYkQDyB/+zyS/8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1245C19423;
	Fri, 27 Mar 2026 14:07:39 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linan122@huawei.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md: wake raid456 reshape waiters before suspend
Date: Fri, 27 Mar 2026 22:07:29 +0800
Message-ID: <20260327140729.2030564-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During raid456 reshape, direct IO across the reshape position can sleep
in raid5_make_request() waiting for reshape progress while still
holding an active_io reference. If userspace then freezes reshape and
writes md/suspend_lo or md/suspend_hi, mddev_suspend() kills active_io
and waits for all in-flight IO to drain.

This can deadlock: the IO needs reshape progress to continue, but the
reshape thread is already frozen, so the active_io reference is never
dropped and suspend never completes.

raid5_prepare_suspend() already wakes wait_for_reshape for dm-raid. Do
the same for normal md suspend when reshape is already interrupted, so
waiting raid456 IO can abort, drop its reference, and let suspend
finish.

The mdadm test tests/25raid456-reshape-deadlock reproduces the hang.

Fixes: 714d20150ed8 ("md: add new helpers to suspend/resume array")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 65c85973092a..3ae5f36b5baf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -489,6 +489,17 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	}
 
 	percpu_ref_kill(&mddev->active_io);
+
+	/*
+	 * RAID456 IO can sleep in wait_for_reshape while still holding an
+	 * active_io reference. If reshape is already interrupted or frozen,
+	 * wake those waiters so they can abort and drop the reference instead
+	 * of deadlocking suspend.
+	 */
+	if (mddev->pers && mddev->pers->prepare_suspend &&
+	    reshape_interrupted(mddev))
+		mddev->pers->prepare_suspend(mddev);
+
 	if (interruptible)
 		err = wait_event_interruptible(mddev->sb_wait,
 				percpu_ref_is_zero(&mddev->active_io));
-- 
2.51.0

