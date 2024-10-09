Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE23B2C190;
	Wed,  9 Oct 2024 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728438676; cv=none; b=CrIZSBXc1wO/1d8bJwAfcqqTFnQcET9VGZynKtKIzt485OZ70tsyX0uC5B98Mdc3Vx+MN4CrFjsFOhtE7ZjrimmDlXxQTOZkllFilbS4EqSQBaXRosGjvPGc0+30vpXH3/JG1G1A3DuMluSJ9I5CkHEgzr1EGiAQwWWD0x20/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728438676; c=relaxed/simple;
	bh=icir9CpjD0mwSG+HWRzC1ozhoX2Q9hwhWZtaW0WJgAc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F8UWoioS/sBaW1w18+V1lZ0wfZxS+2maJkxqlShpflMd81vwd0Wkbt3uOT7tk4wvXBIU605E1v96gpwBOjjZWUg5QjRfYlyp+5P6PgHGSkaagHjU6TdY+AH6opUm+9cu9f7+eY5vbSIMM6ZjpJW0I3LNBoJ9nxBE6PGsp7WQSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XNbSl00Bkz4f3jHw;
	Wed,  9 Oct 2024 09:50:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D91C1A018D;
	Wed,  9 Oct 2024 09:51:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3KseE4QVnhF1KDg--.60869S4;
	Wed, 09 Oct 2024 09:51:02 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	hch@lst.de
Cc: iam@valdikss.org.ru,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md/raid10: fix null ptr dereference in raid10_size()
Date: Wed,  9 Oct 2024 09:49:14 +0800
Message-Id: <20241009014914.1682037-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3KseE4QVnhF1KDg--.60869S4
X-Coremail-Antispam: 1UD129KBjvJXoWrKry5Cw1UWr1fWF17KF17ZFb_yoW8JrW3p3
	9F9ryYvr10k3y7Ja4DJr1UZa45Ka4UK3y2kryxAw4rZF13XFZrWa1fXrWjgrs7XrWrGa4r
	AF4UKFWDuF1jg3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

In raid10_run() if raid10_set_queue_limits() succeed, the return value
is set to zero, and if following procedures failed raid10_run() will
return zero while mddev->private is still NULL, causing null ptr
dereference in raid10_size().

Fix the problem by only overwrite the return value if
raid10_set_queue_limits() failed.

Fixes: 3d8466ba68d4 ("md/raid10: use the atomic queue limit update APIs")
Reported-and-tested-by: ValdikSS <iam@valdikss.org.ru>
Closes: https://lore.kernel.org/all/0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid10.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..862b1fb71d86 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4061,9 +4061,12 @@ static int raid10_run(struct mddev *mddev)
 	}
 
 	if (!mddev_is_dm(conf->mddev)) {
-		ret = raid10_set_queue_limits(mddev);
-		if (ret)
+		int err = raid10_set_queue_limits(mddev);
+
+		if (err) {
+			ret = err;
 			goto out_free_conf;
+		}
 	}
 
 	/* need to check that every block has at least one working mirror */
-- 
2.39.2

