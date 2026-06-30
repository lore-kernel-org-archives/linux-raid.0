Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192303E2AD6
	for <linux-raid@vger.kernel.org>; Tue, 30 Jun 2026 07:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782806207; cv=none; b=jspuwCwZUNBvuMxHcHEZRMGegMjPJ28iyUzp4MRDeT4evmlNpU6w5UfReJYRFKiHRjEDHEO3EP8i7PWJ03JAFG3FI2KK0Nknx4RDd8FXiMcjGX+enn0zX8S2cujpGhJ8qc5l3qUMTgBTHCdVs/YPLZGBXa9N28d06ZVloX/5aMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782806207; c=relaxed/simple;
	bh=NHGKYlW1z3Y4nDfaNAt30+5QScVY78fwL1TAANr1d2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M1dnhY88KQgwQzyWHLxwHqXBR7WMLO1Hf2pSWn9RGk+W987d86kUnsa5jMX0m4tJjdecR22YtAtJq3CzCbdE35Fhs1c4bDFJQ57ql+5LlraS6GWX8Dk5ILxqYfr8r/6FElS7OBCCkhxv4JH+QUIxIovsZsMdAKlmd5+OgEt72AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjVkCSRO; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjVkCSRO"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493a97fad2fso20434535e9.0
        for <linux-raid@vger.kernel.org>; Tue, 30 Jun 2026 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782806204; x=1783411004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JcwI3L3/IZnl5azQAjtJ+Tb8ZlC5ITA8N1948cj+0U0=;
        b=OjVkCSROtmbjQTC/1c1fJcS62QBy7AVHDVhiclByqF+xqHE12XxvhqnTcX42CPlure
         53tFlEwVd3zkAiM+Bo/XPei7ctZKOFdphw656km0+uwx1uTJOnTq2K7Nalub5oPqzVS6
         5MXAyLF29NMhHKf94Pxs9V3JKNO1nPGzyXQ1NeZS5oERsx7DkggUI/eCaqPkYW0RFxr7
         TxkPooWFkJWYHTnciEPDZqxsqC2YTuaMLqc8SU2HUhLx7S4TOuyvkQj1RpxveJjH6zcW
         T8xnWeT34Td+1UA0+uOGJMdJv5COCaMudEy/qTRUqWM/2ai9OFZjmRDK5xWIiBYB8PKE
         xFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782806204; x=1783411004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcwI3L3/IZnl5azQAjtJ+Tb8ZlC5ITA8N1948cj+0U0=;
        b=TgKfe2OvgPTlQSLjbEYOLFGnrI+cZUuc+rpmT7j1ML9375J5JBmy0kbv2K2ifmwUzN
         cUbTTBi7aE5hIioXr2KqW3GzHf9cW3/kQgeD4+pvdfQrQ1ESmsROShsmjao5R+FBC7CV
         KGoljpCtD6kH/mmS7eUqiB9dMgROITfoTgYAeVfYoYhs2Rlkk7dVubI3WInI/vXfSVKy
         5MIe9HJypaj8nJXH2AceMZL4IMyKP9JRhCIrKOcWlPdMSeJgUewpPYOlbaYj8/BHf4bW
         u1b8GmqOpfccUDbeWFI/EyeWlslvs7+9v7Kl4mrbLLbqNVEZwlRnmnzdzfxt0uTp0suM
         1PCg==
X-Gm-Message-State: AOJu0YzRuzfvH3DJqm6wkKgtG0p/bXqQHME06rEKb9IpkYkQIjR1NxTW
	6HR8WamcljLi3gCNmWHdDzMN8w18aTZ72dUPPouFMVvaJn6zhWXZFVw4
X-Gm-Gg: AfdE7cn1HlkWwedkTBio/RRBW3OFefqADfEW5GYM88RI/pq8LbqWz8bu8UuNDv0I2lr
	OFnq60dqSJ/sNj4N/HMzS4yEhPVQ7ugt8bmq/Ae5Bruk/COTGGrfjdP6OpYQt+HdUin0Fg3jio9
	EQy/8vd1nwsUcI+hI2TBeASkRdiD6yunLz6rjznOZxEh6mnRBuznPthrMEmkLe3DYXhksFDmNgv
	7Mf5yJJKQQ6vi4J6RUM+eW1QLhLhGOyM0QVCUQe7Z0/qrjwN3e7Dp2TK8QfqvtYRrtMIoLjAwGu
	wzgN4lrGMe8/bVAkaNyFMnfE1bmTLiVDaRAlwdPdnlbngOPr2gdd+t538WxpiVvwMTjoOBse/Mh
	EiSc+aVMOXjCZj1h9qP5HABMq1mv0ERahhMhJ3oX9n+RnOLmKcraDFdcbBdsmzGYHZA/9B5FKUb
	iiY/BVRusHjV5aPBxQy4UUZNx/bFMATymJ
X-Received: by 2002:a05:600c:4745:b0:492:3316:4b34 with SMTP id 5b1f17b1804b1-493b827ea26mr36666665e9.2.1782806204318;
        Tue, 30 Jun 2026 00:56:44 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47566743895sm5216233f8f.25.2026.06.30.00.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 00:56:43 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] md: avoid modifying spares while the array is not suspended
Date: Tue, 30 Jun 2026 07:56:40 +0000
Message-ID: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

remove_spares() and remove_and_add_spares() modify the array's rdev
configuration. These operations are only safe after the array has been
suspended.

Today, md_start_sync() can call md_choose_sync_action() even when the
array has not been suspended. As a result, md_choose_sync_action() may
remove or replace rdevs while normal I/O is still accessing them.

The race can occur as follows:

raid10d          Worker                      Normal IO
____________     _______________________     ______________________

                                             raid10_write_request()
                                             wait_blocked_dev()
set Blocked
set Faulty
                                             Skip Faulty rdev
                                             rrdev->nr_pending++
                                             .repl_bio = bio
                 removeable_rdev = false     .
                 array not suspended         .
lock mddev                                   goto err_handle
                 lock mddev (wait)
                 .
update sb        .
clear Blocked    .
                 .
unlock mddev     .
                 lock mddev (acquires)
                 remove_spares()
                 removeable_rdev = true

                 raid10_remove_disk()
                 rdev = replacement
                 replacement = NULL
                                             rdev_dec_pending(NULL)
                 unlock mddev                (NULL)->nr_pending--

In this case, rdev_dec_pending() is called with a NULL pointer,
resulting in a NULL pointer dereference when attempting to decrement
nr_pending.

Fix this by ensuring that remove_spares() and remove_and_add_spares()
are only called after the array has been suspended, preventing
concurrent rdev configuration changes while normal I/O is in progress.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalkhi@gmail.com?part=3
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 66a41d482e59..c85ebb59535b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10116,7 +10116,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 	return spares;
 }
 
-static bool md_choose_sync_action(struct mddev *mddev, int *spares)
+static bool md_choose_sync_action(struct mddev *mddev, int *spares,
+				  bool array_suspended)
 {
 	/* Check if reshape is in progress first. */
 	if (mddev->reshape_position != MaxSector) {
@@ -10132,7 +10133,9 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 	/* Check if resync is in progress. */
 	if (mddev->resync_offset < MaxSector) {
-		remove_spares(mddev, NULL);
+		if (array_suspended)
+			remove_spares(mddev, NULL);
+
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
@@ -10144,7 +10147,11 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * also removed and re-added, to allow the personality to fail the
 	 * re-add.
 	 */
-	*spares = remove_and_add_spares(mddev, NULL);
+	if (array_suspended)
+		*spares = remove_and_add_spares(mddev, NULL);
+	else
+		*spares = 0;
+
 	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -10189,11 +10196,12 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL);
+		if (suspend)
+			remove_and_add_spares(mddev, NULL);
 		goto not_running;
 	}
 
-	if (!md_choose_sync_action(mddev, &spares))
+	if (!md_choose_sync_action(mddev, &spares, suspend))
 		goto not_running;
 
 	if (!mddev->pers->sync_request)
-- 
2.43.0

