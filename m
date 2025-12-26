Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282DD25771;
	Fri, 26 Dec 2025 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766717636; cv=none; b=U1ZxJ2BN0L87+7vNAsAM5mb0kbqsw247sNlKTX9rpjVH0rgHFlJsSjxbT7cZ3GRQMQDjrVJE19UEif0jW9knIbXUAYVSz3n66mZC5AU9/www35hRTSGv8pqCuksBozT5bgv8z5cVi6DOdVChq0+2XG4qRlWbdHJXdeA507dgSGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766717636; c=relaxed/simple;
	bh=+YooSBkc2eE12LBm08hh5lu2rcVCS1SEKGKiW6Lk3y8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ycl9ZCbNXTI3KucY6vbLGOcYMj7NvPFfUX1UHWdNze4LsK+WZEzYyvSKfbLPC5pIoU3Eijq6fpcMCPmg3hRPosMP5gUr6Uu0wbpVv/P1EnTbbHQzLzhH6JOCbKmksxOn+oonoOwDNquXkFOKNTpEh/l7rH75KeXN0d0hBiDzclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dcqtF4xMKzYQtHT;
	Fri, 26 Dec 2025 10:53:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 07CC44056B;
	Fri, 26 Dec 2025 10:53:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPi++E1pwoUGBg--.4956S4;
	Fri, 26 Dec 2025 10:53:50 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bugreports61@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 1/2] md: Fix logical_block_size configuration being overwritten
Date: Fri, 26 Dec 2025 10:42:20 +0800
Message-Id: <20251226024221.724201-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPi++E1pwoUGBg--.4956S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1Dtr1rXFyDtF13Cr45ZFb_yoW8Xr43pa
	93Ca4ag3y7XrWUZa1xXrykZas5Xw47GFyktrW29wsIvF9Fyr15uF4Sgas8Aryq9F95AFnF
	vwn8G3y8ua4xWwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdpnQU
	UUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In super_1_validate(), mddev->logical_block_size is directly overwritten
with the value from metadata. This causes the previously configured lbs
to be lost, making the configuration ineffective. Fix it.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
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

