Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35305194A44
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 08:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730967444; cv=none; b=py2ehMd+kUgonFIYdoVISixhKRYbs8H+t6WVqjKdt//SAEEdAyXeLDjzO33kQtXAhWqlzutck7/YOK1ZXD8jNLJxmPf5hvX+2oklTu1DAwYjb1ZN38SIKByOIohQpm5dRiy1/3unhyPoaDY2X3En9dGbTqv9ct8vpxRYkcT1wWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730967444; c=relaxed/simple;
	bh=z369lES9dlJGVMxroWXe6Rl2IoMK5Pj1bkY4Fv0u6KY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ha3skuV74S00pRywt8CmcjUvBHjGqLydbWYDsROQdfyMDDkLx3ltHMB5RNU+pdgxJd7csngeI7ETKE6wCESqugZbFV5hB7tP8m7467L6DRAXiiZKH9l8mxkARN3/jH3M4A8o7bc7nL2kSgoiYJhX7cIaQnfTZw0el9QiK/OZZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XkZg11Qqzz4f3jMt
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38F101A0568
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4eMdyxnL91fBA--.3434S6;
	Thu, 07 Nov 2024 16:17:19 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH mdadm/master v2 2/4] tests/05r1-re-add-nosuper: remove bitmap file test
Date: Thu,  7 Nov 2024 16:13:45 +0800
Message-Id: <20241107081347.1947132-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
References: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4eMdyxnL91fBA--.3434S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyDCw18KF18AF4rZFyxXwb_yoW3JFb_CF
	1fWrWxW3yxu3Z2qr18Ca1UZw4vqw43CF1FvFy5XF1fGF1UXrn3Kas7Cryaqry3urZrCFya
	vrWUXFW3CF18CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUzMKuUUUUU
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

