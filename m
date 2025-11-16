Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A23221F12
	for <linux-raid@vger.kernel.org>; Sun, 16 Nov 2025 02:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763259526; cv=none; b=AcLEcnoV5eWBZUW+qj1wG1UIW+74XnN0xGnQw/FW4/iA3v5viCZk1BXDFJ3YDyGXU4dVnOpIgVXk0+JPF9SJZ9GII8xp72QEHYiwhCY7TE1a9Kke9QE/cg0Uk5/SAYjICF+qyuN2fgK4RTjU1X4isSWyU2EoM6K3+Yzezb2uRTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763259526; c=relaxed/simple;
	bh=TMdF1kgJKOUz9nskYdzF12bvhn21NT6x2xJt4n+ismY=;
	h=Cc:Date:Subject:Message-Id:Mime-Version:To:From:Content-Type; b=XEu7R0dFzbEIu5AawmFJGmiv6qFcfp+V9vy5cNh3ogDAkYEOZjQ846ciMlTfsSE7/9rOxVePwr3wNDjTOYLFhOZ/XQELLl0bALxb5KO863+5jWck183Pm8Y4DvFcsAGD3T1VqxCxLf6lW2b/N9Fr4+j81Um7BHE3qHzSFjgdj2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=PXgq2VGh; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="PXgq2VGh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763259511;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6WsD9BJQtsRR+smlKiizWPS+F1NxeC+sTyBGvFqHxec=;
 b=PXgq2VGhrJrMBJnZh8i2DjW4xx7wMmbB2A1fK8LEK8nVicYj0o7e26Jh76jnyQ9SSss/Tu
 usa1trle9PjOI9HlBNM/3/nW8Jrupczv4SRk0xw0h7Z2SUp/WIgDfwGsNLLNO/KLDIoVNh
 Qxdj8sisLdPvS0XmWZ/bsTCmrDJuo6Rt6la8A4Rxs980z8JI272yUWJwzX05ddJjj0pqPo
 /PIdI+P5Wru6EYQafhcgpF5QokqSjDAB/79zJszf9bbcMFZyQ4hCgl9sPIuLKVh32T1pQK
 qrqXH0aZI9TopeLlM9sX7myEu8MKZWsvBbAB6nP6qJwjXZxTvY3v0My0wGwJXg==
Cc: <yukuai@fnnas.com>, <linan122@huawei.com>, <xni@redhat.com>, 
	<czhong@redhat.com>
Date: Sun, 16 Nov 2025 10:18:16 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from localhost.localdomain ([39.182.0.135]) by smtp.feishu.cn with ESMTPS; Sun, 16 Nov 2025 10:18:29 +0800
X-Lms-Return-Path: <lba+269193475+ab8bc9+vger.kernel.org+yukuai@fnnas.com>
Subject: [PATCH] md/raid0: fix NULL pointer dereference in create_strip_zones() for dm-raid
Message-Id: <20251116021816.107648-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

Commit 2107457e31fa ("md/raid0: Move queue limit setup before r0conf
initialization") dereference mddev->gendisk unconditionally, which is
NULL for dm-raid.

Fix this problem by reverting to old codes for dm-raid.

Fixes: 2107457e31fa ("md/raid0: Move queue limit setup before r0conf initialization")
Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
Closes: https://lore.kernel.org/all/CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-iQ-_9rVfyumoKA@mail.gmail.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid0.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 47aee1b1d4d1..985c377356eb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct strip_zone *zone;
 	int cnt;
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
+	unsigned int blksize = 512;
+
+	if (!mddev_is_dm(mddev))
+		blksize = queue_logical_block_size(mddev->gendisk->queue);
 
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
@@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		sector_div(sectors, mddev->chunk_sectors);
 		rdev1->sectors = sectors * mddev->chunk_sectors;
 
+		if (mddev_is_dm(mddev))
+			blksize = max(blksize, queue_logical_block_size(
+				      rdev1->bdev->bd_disk->queue));
+
 		rdev_for_each(rdev2, mddev) {
 			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
 				 " with %pg(%llu)\n",
-- 
2.51.0
