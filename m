Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0262433BAD
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 11:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783509609; cv=none; b=cDynH0fgXv0cffBYI9pVWPavOeOShLkzozelhEKvWVO1xzqTQgo6mb4ibt4ykogsRm9GawRLexPsqnQZY/24/Qgm52QRAa7iyi7O77hJPAjsyaTWOs/vhEBEdixNBHqgB6DrJOrDWZ6XQI+QzGGJKZYdVPNRahs34tC7tUTWnjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783509609; c=relaxed/simple;
	bh=bqhLKV8TaF8sIEYquwfcoMsv7h6XYjCNsLWUlgU1o5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L9F9ihuS6EJZCndUf949TCYTOrIZ0LwE6A6qW/OAQj1zbqhQ0fZItUU025ygKkVbM/+XFA4b4o/CChC03Rdwrm8UsxgcMlJjSK2RdBb4emKBv+4YDfiaR8mYWyUwNaIdMTDtZ6QHxN3sMSXknEyEoOFt3IT7SBO0rz8GrxcC1Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2bahzs9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2bahzs9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b1710405so3447155e9.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 04:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783509606; x=1784114406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G9J5WGXQ0B5xy1UOyRRsYaQ1BOiw7DtBGjUcuUf7auA=;
        b=L2bahzs9I0872zGg7mFrzgM3XgMF4nXeXjBX/sHm5y895A4TSbK+QiO/oWIoPzAFGm
         Nwj2/yXtFegzCDGZy98XDK7ZAp9cyl1bD0CRcXRqRs41WmR1SLBwr+9J/HLY5xSvLoaW
         th6hdCq0XhvKoP9P8o5KXjIH/rG6t34OArDd/iCMo5CkOXlY+jvDK8ETmZxieY8idWy8
         9fBVe0iEvGB6CEStjKpUT0UNwPUqirRDm3UH4sXVa+bySTlBlTnJdWgoDezsWZYXYkaE
         NTS4+NiRF6jmJlz1SLCba1A8OxPmVaIzkwVPSl3mZ+H53hVeuQziR2D1zfZlXpjN42cM
         Zeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783509606; x=1784114406;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9J5WGXQ0B5xy1UOyRRsYaQ1BOiw7DtBGjUcuUf7auA=;
        b=rn6LY8qSvgsNozLzKCSa7wniFITe/jvA0fl3na1ab6yh35s8H/C2emr3NSBpWtSinR
         jbvWSNj1A8HO/+hno+X/6LiwfLsPPdgeOPBGzHLutse4jCFtq4yuoD0TzFpK2QtgYzwO
         iQEcNLtuq2A6IEUijEQeG2qrBocAWpiiNSICBVVpQZM98ZAwzlqHlJdQ39E/Q0iHpozF
         jniKq2yruhJG56DOfzMdVOg8xZ8DYvcRg2cVlkJIWH25Fq1QhFvh4+EpP3PaYYbaIQ0m
         gRHCXRGhfGDtUdsm7qxww/JwTL2sOeEKfXJB+wQPb/sIHDbTxVCAo0UO8SUbu0emNtaj
         T46g==
X-Gm-Message-State: AOJu0Yw1DesThJlDaxROoB1KwA9p3OmYMn427ZJoAsfYMY3XwQS3MRWv
	m4hlbI0oObX6h9l+zqG2mn4LP+fiwrdUx1s+SyoGccPmsfJd91azvbCvRKv/2Q==
X-Gm-Gg: AfdE7cmCV3p9HsQ6rLHmIntteWh49j5NfWjRC3jJxmQG/Dd9P/S9Fknv9i0RZObsMDS
	8640Qi3u11bsp/P0uJQ8EuIm08x+pyLlRfNRZBqzDKpG9pNiIMu9RKrHOiU8kt67xG2U02X+o36
	GZ+eYGQciinBGM17jZ1N5p69DT4WgeVuE0kbqeXDUEBSX9/SG2f2TlTE9BJ0DaSfs3lWgXg+HbF
	WHzCXyP35MuTVtOG5zJBAjy4J0nTQJD1ocGpcJQbYguGbgSb9hqe0Wj2VvCnZcPnrnWozX3xR3E
	MO3/YkpUlve+eSLzeuso/II4RYfDVBKBWxXUyvmsNsXy5L8CYVzfNfkZHk75L0LyyID6rmFX79B
	gFoujLc2VzEWsPxqX+HdC1gEWzn4LvbXVHHq/evJduWUd2ZxABTmCFEPDcfDLgh3qwzDweVvPnH
	H/hiamx7nu2m7eYz+knWI=
X-Received: by 2002:a05:600c:8486:b0:493:e365:7630 with SMTP id 5b1f17b1804b1-493e6844d66mr26650565e9.14.1783509606066;
        Wed, 08 Jul 2026 04:20:06 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039afacsm39988604f8f.19.2026.07.08.04.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:20:05 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	abd.masalkhi@gatech.edu
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v2] md: recheck spare changes before starting sync
Date: Wed,  8 Jul 2026 11:20:03 +0000
Message-ID: <20260708112003.474537-1-abd.masalkhi@gmail.com>
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

md_start_sync() checks whether spare configuration changes are needed
before taking reconfig_mutex. However, the rdev state can change before
the mutex is acquired, so the initial check can become stale. In that
case, md_choose_sync_action() may remove or replace rdevs while normal
I/O is still accessing them.

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

Fix this by suspending the array when spare configuration changes are
needed, including for non-read-write arrays, and checking again after
taking reconfig_mutex. If the array was not already suspended and a
change is now needed, release the mutex, suspend the array, and
reacquire the mutex before continuing.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalkhi@gmail.com?part=3
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Recheck whether spare configuration changes are needed after taking
   reconfig_mutex, and suspend the array before continuing if necessary.
 - Account for read only arrays, where reshape_position may not be
   MaxSector even though md_start_sync() can still modify the spare
   configuration.
 - Link to v1: https://lore.kernel.org/linux-raid/20260630075640.1081634-1-abd.masalkhi@gmail.com/
---
 drivers/md/md.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 66a41d482e59..c3fc47a82415 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10174,13 +10174,25 @@ static void md_start_sync(struct work_struct *ws)
 	 * If reshape is still in progress, spares won't be added or removed
 	 * from conf until reshape is done.
 	 */
-	if (mddev->reshape_position == MaxSector &&
+	if ((mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
 		suspend = true;
 		mddev_suspend(mddev, false);
 	}
 
 	mddev_lock_nointr(mddev);
+
+	/*
+	 * The spare configuration can change before reconfig_mutex is acquired.
+	 * Recheck while holding the lock and suspend if needed.
+	 */
+	if (!suspend && (mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
+	    md_spares_need_change(mddev)) {
+		mddev_unlock(mddev);
+		mddev_suspend_and_lock_nointr(mddev);
+		suspend = true;
+	}
+
 	if (!md_is_rdwr(mddev)) {
 		/*
 		 * On a read-only array we can:
-- 
2.43.0

