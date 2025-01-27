Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BC2148314;
	Mon, 27 Jan 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968470; cv=none; b=q8ihj/jowDUZru4akCX40c8rOLlg7xntELoMd7m+poowsMHpxTbH/Zxhw9tHsBmyIRDylBuYqF8IJUWUPylMdxUczkl9bK2op8qEyLToEXt6sBPmXQI9rwIkSCYcQkXzCnPMUx8q6cb0WeQP/OYLAXIjr8hRtYd1e+pkJ+q0Gdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968470; c=relaxed/simple;
	bh=kXsIDNmi+1w2a+5LXRagZrOvqMUdcLB5f1uqv25gK8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJ59sny77D82vmcyLlJ9JzqqBtGHM3/YMPW2TFb9W+EJ4emcvU4m7x/8FMWhz55Wppna3sFacZdEXtksOrCxcVtPpjPjKm5Tg3Nm5bdSma9taU2Rg5Li1ZYZE3Y338Bry9YgDOGnLbR23m2E5GLN7sQQvK0Mxutf/eEDLNxP14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=LdoT+9Fg; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="LdoT+9Fg"
From: Doug V Johnson <dougvj@dougvj.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1737968466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pI939d920iRKvpdF/K/DtdiYq+phwGR6GSUtAVoQFV0=;
	b=LdoT+9FgBk6/RQDm7PgkZ/IfC13xTgntJwVJuI8CnkdO/MWjV50Jko7HvbmeKNRsank2zE
	BaxspLFZgziF5JLjMgVBLdKsXslR9Kmt7Jh/ID4JSyvE6cxqfahOADknHMwODmZF+MQ9j7
	zS/xv4P6GJS0Epb1qOKcZjQWF5TWpOs=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
To: 
Cc: Doug Johnson <dougvj@gmail.com>,
	Doug V Johnson <dougvj@dougvj.net>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] md/raid5: freeze reshape when encountering a bad read
Date: Mon, 27 Jan 2025 02:00:41 -0700
Message-ID: <20250127090049.7952-1-dougvj@dougvj.net>
In-Reply-To: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
References: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -

While adding an additional drive to a raid6 array, the reshape stalled
at about 13% complete and any I/O operations on the array hung,
creating an effective soft lock. The kernel reported a hung task in
mdXX_reshape thread and I had to use magic sysrq to recover as systemd
hung as well.

I first suspected an issue with one of the underlying block devices and
as precaution I recovered the data in read only mode to a new array, but
it turned out to be in the RAID layer as I was able to recreate the
issue from a superblock dump in sparse files.

After poking around some I discovered that I had somehow propagated the
bad block list to several devices in the array such that a few blocks
were unreable. The bad read reported correctly in userspace during
recovery, but it wasn't obvious that it was from a bad block list
metadata at the time and instead confirmed my bias suspecting hardware
issues

I was able to reproduce the issue with a minimal test case using small
loopback devices. I put a script for this in a github repository:

https://github.com/dougvj/md_badblock_reshape_stall_test

This patch handles bad reads during a reshape by introducing a
handle_failed_reshape function in a similar manner to
handle_failed_resync. The function aborts the current stripe by
unmarking STRIPE_EXPANDING and STRIP_EXPAND_READY, sets the
MD_RECOVERY_FROZEN bit, reverts the head of the reshape to the safe
position, and reports the situation in dmesg.

Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
---
 drivers/md/raid5.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..bc0b0c2540f0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3738,6 +3738,27 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), !abort);
 }
 
+static void
+handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh,
+		      struct stripe_head_state *s)
+{
+	// Abort the current stripe
+	clear_bit(STRIPE_EXPANDING, &sh->state);
+	clear_bit(STRIPE_EXPAND_READY, &sh->state);
+	pr_warn_ratelimited("md/raid:%s: read error during reshape at %lu, cannot progress",
+			    mdname(conf->mddev),
+			    (unsigned long)sh->sector);
+	// Freeze the reshape
+	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);
+	// Revert progress to safe position
+	spin_lock_irq(&conf->device_lock);
+	conf->reshape_progress = conf->reshape_safe;
+	spin_unlock_irq(&conf->device_lock);
+	// report failed md sync
+	md_done_sync(conf->mddev, 0, 0);
+	wake_up(&conf->wait_for_reshape);
+}
+
 static int want_replace(struct stripe_head *sh, int disk_idx)
 {
 	struct md_rdev *rdev;
@@ -4987,6 +5008,8 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
+		if (test_bit(STRIPE_EXPANDING, &sh->state))
+			handle_failed_reshape(conf, sh, &s);
 	}
 
 	/* Now we check to see if any write operations have recently
-- 
2.48.1

