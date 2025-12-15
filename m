Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848323D7C4;
	Mon, 15 Dec 2025 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765803309; cv=none; b=KE/OnzF+gNdIZKbK4MgkaoCxA1recGu46JmcaWqARUdX1OA33D5ftbNwGCS8WZslbQ1LZtrUZn+WrL8KKrtZaYSCUhshupzNEq9Iyv9jJH4hiRzWAHkrHc0TnN7273u/GQZgNpAD/PIDDPAN4172kb2mqxk5p7MN3yVx8iZEm0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765803309; c=relaxed/simple;
	bh=RniX6SLyIul+Q1QlywH6Y2WfC4bxEvifBBxNAxb23Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BPvlk9yggjni5TR7k9DgMu3MyK8UOdeM0xpJHa2JoMtb/G6F5CDvVT/hYrimqxTdkTJ+je+4Zflo81bFrvWbVQyC8TJCHJiSIBkxi8acsCF2VFJ6Wcsu4Si0+/lHTRjNX7bKr3v1ATBoqMwqLme1aeMEW2779Am8rTwRGJOJ9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVKlM1JKdzYQtpF;
	Mon, 15 Dec 2025 20:54:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B049B1A1117;
	Mon, 15 Dec 2025 20:55:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPklBUBphjceAQ--.1094S4;
	Mon, 15 Dec 2025 20:55:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	hare@suse.de
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH] md: Fix static checker warning in analyze_sbs
Date: Mon, 15 Dec 2025 20:44:12 +0800
Message-Id: <20251215124412.4015572-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPklBUBphjceAQ--.1094S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWxJFyDZr4UCFWrZr13Arb_yoW8Gryfpa
	yxuFyFgr45Aw1fJw4UXrykuFyaqrsrt3yqgFW7Aw43XFyfAr1DW3WFgFy2qryDXas5AFn0
	v3yUAw4Du3W8K37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14
	v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbhL05UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The following warn is reported:

 drivers/md/md.c:3912 analyze_sbs()
 warn: iterator 'i' not incremented

Fixes: d8730f0cf4ef ("md: Remove deprecated CONFIG_MD_MULTIPATH")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-raid/7e2e95ce-3740-09d8-a561-af6bfb767f18@huaweicloud.com/T/#t
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 648fbf1b1fe7..dac03b831efa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3907,7 +3907,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 static int analyze_sbs(struct mddev *mddev)
 {
-	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
 
 	freshest = NULL;
@@ -3934,11 +3933,9 @@ static int analyze_sbs(struct mddev *mddev)
 	super_types[mddev->major_version].
 		validate_super(mddev, NULL/*freshest*/, freshest);
 
-	i = 0;
 	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (mddev->max_disks &&
-		    (rdev->desc_nr >= mddev->max_disks ||
-		     i > mddev->max_disks)) {
+		    rdev->desc_nr >= mddev->max_disks) {
 			pr_warn("md: %s: %pg: only %d devices permitted\n",
 				mdname(mddev), rdev->bdev,
 				mddev->max_disks);
-- 
2.39.2

