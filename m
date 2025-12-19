Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F842820AC;
	Fri, 19 Dec 2025 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136756; cv=none; b=N3f9Zi9ZH9B9792FNIlo+j0qVsw+g/sz8QFKd7XEViJICAbHQfajWtRIRztKp54AZX4pR1MfIqMweXL4W3oK4lSfkzXBXJNGNszymMzJgK1cPN0QRe15a0P02BfQcjCXOTJuS364kMiGS0O6BwgcaMnQIx9z/gk6Z5/xduHMPBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136756; c=relaxed/simple;
	bh=6ma5LBsS8Lw62+r1F/cR5p/FFPFp0MlGiuqazUJSf28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c2S4GOe2Q57cqI1C5oTtknARu1QeO4+9M4O1UcyFGKMwfUSOl+OcezNE3yrqdeGMP67FH0oopy5TGopueLRp50mTHuAJIwvM1ZsoDFEPqz2tQarbvuAYOSGm3DhZkQCXE2WF+WHoNZmvr0UyYGDqcfko7tXL9Bdst2PxQ/U9zRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dXj432GsrzKHMTP;
	Fri, 19 Dec 2025 17:32:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4548240576;
	Fri, 19 Dec 2025 17:32:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPmuG0VpE9voAg--.36108S4;
	Fri, 19 Dec 2025 17:32:31 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	bugreports61@gmail.com
Subject: [PATCH 1/2] md: Fix logical_block_size configuration being overwritten
Date: Fri, 19 Dec 2025 17:21:26 +0800
Message-Id: <20251219092127.1815922-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPmuG0VpE9voAg--.36108S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1Dtr1rXFyDtF13Jw1fZwb_yoW8Gw1Upa
	93CF1ag3y7XrWUZa1xZrykZas5XwsrGFyktrZF9wsIvF9Fyr15uF4Sgas8Aryj9F95AFnF
	vwn8G3y8Wa4xWw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUooGQ
	DUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In super_1_validate(), mddev->logical_block_size is directly overwritten
with the value from metadata. This causes the previously configured lbs
to be lost, making the configuration ineffective. Fix it.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e5922a682953..7c0dd94a4d25 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1999,7 +1999,6 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
-		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2015,6 +2014,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 
 		mddev->max_disks =  (4096-256)/2;
 
+		if (!mddev->logical_block_size)
+			mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
+
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
 		    mddev->bitmap_info.file == NULL) {
 			mddev->bitmap_info.offset =
-- 
2.39.2

