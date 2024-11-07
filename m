Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3882F212EE2
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984790; cv=none; b=I/2Bmlheuv0LnXALtO745x1D8bOEWyXebm/g3RrFOFo3+Iqy6LD2g2A4mnw9aq8vNcy2nz9P0/3I92EPkEGFKm5OpVXDlyxLACQwTXSZ5UMbzAP7W9PwrbqZQ1nebOCwUFq6wHsceTtAh+wTe2NfA+FVg8+txGpqyS+rrxTSvYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984790; c=relaxed/simple;
	bh=z369lES9dlJGVMxroWXe6Rl2IoMK5Pj1bkY4Fv0u6KY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=brj63C1Msd8/6lt/NhNKGEvxkAeMo0gX1P4X/3tcWw3WHD3XNFqONOiZyEMskyOKxGL7l/FGm+uvVz6HTm3dVoylA/FBk7S51ibj3PbtE4wgvuyzxKlNQQ5Hz9uANTXQXzWYLgBX16T5FsoAZdLMoCDnAEq4y7RAjY8NR38rE24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xkj4Z69V7z4f3jXK
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:06:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DCE2C1A018D
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:06:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoJPuyxnnCtzBA--.58960S6;
	Thu, 07 Nov 2024 21:06:24 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 2/3] tests/05r1-re-add-nosuper: remove bitmap file test
Date: Thu,  7 Nov 2024 21:02:52 +0800
Message-Id: <20241107130253.315551-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241107130253.315551-1-yukuai1@huaweicloud.com>
References: <20241107130253.315551-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoJPuyxnnCtzBA--.58960S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyDCw18KF18AF4rZFyxXwb_yoW3JFb_CF
	1fWrWxW3yxu3Z2qr18Ca1UZw4vqw43CF1FvFy5XF1fGF1UXrn3Kas7Cryaqry3urZrCFya
	vrWUXFW3CF18CjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxV
	W8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jjeHgUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to remove bitmap file support.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/05r1-re-add-nosuper | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tests/05r1-re-add-nosuper b/tests/05r1-re-add-nosuper
index 7d41fd7b..a3fa9503 100644
--- a/tests/05r1-re-add-nosuper
+++ b/tests/05r1-re-add-nosuper
@@ -1,12 +1,9 @@
-
 #
 # create a raid1, remove a drive, and readd it.
 # resync should be instant.
 # Then do some IO first.  Resync should still be very fast
 #
-bmf=$targetdir/bitmap2
-rm -f $bmf
-yes | mdadm -B $md0 -l1 -n2 -b$bmf -d1 $dev1 $dev2
+mdadm -B $md0 -l1 -n2 -d1 $dev1 $dev2
 check resync
 check wait
 testdev $md0 1 $size 1
-- 
2.39.2

