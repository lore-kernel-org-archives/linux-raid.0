Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98462A1A6
	for <linux-raid@vger.kernel.org>; Thu,  9 May 2024 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715217673; cv=none; b=p5axNFnlIxQILfA7GA7MZHWP3SJ0idbjJmLlCDkJBEQTZW9cHeL4i18cKAbwbzWYhbNKxKZdIqST+85yre1xYGDDtKEglK6QJR1H6B3s9HbjCvKWNr7f9NPL56paVgbIhxBsE/vvtYztC/pTtAQDPK25l079GFiUc7t6rMTs+h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715217673; c=relaxed/simple;
	bh=OMjAblWQzE6vdvkUaVYR4D85cB75mGBdssDTF22RKSs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gAVwMlvk1xiIJmFgc+OyDv2U/qMX3iypQPpeDQ+M92r9jAtRsqG0YNsP6Z/i/jfXWEgBkNUF45HIjrWawR/1p51BZ4/dtR6dRv5w3m7My4jyN1sdz7MtOFPWXNwxKm7zJvNiux6rz04INqaEr1V4cOZLQ+tUxNyQ8qPfygP6AE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VZZ2z6cZzz4f3jXg
	for <linux-raid@vger.kernel.org>; Thu,  9 May 2024 09:20:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 421351A016E
	for <linux-raid@vger.kernel.org>; Thu,  9 May 2024 09:21:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBH+JDxmiE6XMA--.1900S4;
	Thu, 09 May 2024 09:21:03 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: linux-raid@vger.kernel.org,
	jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Cc: song@kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yangerkun@huawei.com
Subject: [PATCH] tests/23rdev-lifetime: fix a typo
Date: Thu,  9 May 2024 09:10:59 +0800
Message-Id: <20240509011059.2685095-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBH+JDxmiE6XMA--.1900S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5_7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

"pill" was wrong, while it should be "kill", test will still pass while
test thread will not be cleaned up.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/23rdev-lifetime | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/23rdev-lifetime b/tests/23rdev-lifetime
index 1750b0db..03b61de4 100644
--- a/tests/23rdev-lifetime
+++ b/tests/23rdev-lifetime
@@ -4,7 +4,7 @@ pid=""
 runtime=2
 
 clean_up_test() {
-	pill -9 $pid
+	kill -9 $pid
 	echo clear > /sys/block/md0/md/array_state
 }
 
-- 
2.39.2

