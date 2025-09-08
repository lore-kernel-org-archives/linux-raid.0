Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF88E2F60A2
	for <linux-raid@vger.kernel.org>; Mon,  8 Sep 2025 08:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757319649; cv=none; b=oiAWS4Fzd1gFS6UEbumRKVFgIg/aa4WIBtIL7/DVhhSaA0Icz81YamYB7cgzsJLHIFuCzOoM9urdHoNZx3uTlscydBWaT2KKo/L2CSP99ClNmC2TPFS+qDEyDBVuZ140ElZKi4C7mnM1NK4FdeZfFnbIheJyTbO9uLs2tOPdRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757319649; c=relaxed/simple;
	bh=DI9nVY5PYg/YLJ4Z85eHY6RREJPEeNkRXHLvCVhBhH0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=shAyU7bmAY/0gzw/uqtH+YCGvbF2tlo61XkpetjgztncGaAVcD2U4PB2wxKT4yjgbNBqlfb7WmrmU6/1vOAeRk36H/fybp2AbHS80s2anQeyzV2M4dQFKCudQhxHzL3loqaVyrzdh7xuOVTpRQIHLeeyfid0dOAdu38V8O4Yy00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cL0CC2vz8zdclR;
	Mon,  8 Sep 2025 16:16:07 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id D77E3180B62;
	Mon,  8 Sep 2025 16:20:38 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 16:20:38 +0800
Message-ID: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
Date: Mon, 8 Sep 2025 16:20:37 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH v2] Factor out code into md_should_do_recovery()
To: "yukuai (C)" <yukuai3@huawei.com>, <song@kernel.org>
CC: <linux-raid@vger.kernel.org>, <yangyun50@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj500016.china.huawei.com (7.202.194.46)

In md_check_recovery(), use new helper to make code cleaner.

v2: split judgment conditions and add comments

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 drivers/md/md.c | 59 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1baaf52c603c..58ce3518f51b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9741,6 +9741,52 @@ static void unregister_sync_thread(struct mddev *mddev)
 	md_reap_sync_thread(mddev);
 }

+static bool md_should_do_recovery(struct mddev *mddev)
+{
+	/*
+	 * As long as one of the following flags is set,
+	 * recovery needs to do or cleanup.
+	 */
+	if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+		return true;
+
+	/*
+	 * If no flags are set and it is in read-only status,
+	 * there is nothing to do.
+	 */
+	if (!md_is_rdwr(mddev))
+		return false;
+
+	/*
+	 * MD_SB_CHANGE_PENDING indicates that the array is switching from clean to
+	 * active, and no action is needed for now.
+	 * All other MD_SB_* flags require to update the superblock.
+	 */
+	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
+		return true;
+
+	/*
+	 * If the array is not using external metadata and there has been no data
+	 * written for some time, then the array's status needs to be set to
+	 * in_sync.
+	 */
+	if (mddev->external == 0 && mddev->safemode == 1)
+		return true;
+
+	/*
+	 * When the system is about to restart or the process receives an signal,
+	 * the array needs to be synchronized as soon as possible.
+	 * Once the data synchronization is completed, need to change the array
+	 * status to in_sync.
+	 */
+	if (mddev->safemode == 2 && !mddev->in_sync &&
+	    mddev->resync_offset == MaxSector)
+		return true;
+
+	return false;
+}
+
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -9777,18 +9823,7 @@ void md_check_recovery(struct mddev *mddev)
 		flush_signals(current);
 	}

-	if (!md_is_rdwr(mddev) &&
-	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
-		return;
-	if ( ! (
-		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
-		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
-		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->external == 0 && mddev->safemode == 1) ||
-		(mddev->safemode == 2
-		 && !mddev->in_sync && mddev->resync_offset == MaxSector)
-		))
+	if (!md_should_do_recovery(mddev))
 		return;

 	if (mddev_trylock(mddev)) {
-- 
2.27.0

