Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5361B2BEC43;
	Mon, 26 Jan 2026 07:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769411759; cv=none; b=YZ033ApD74SuRKCfBx65GZBoM234/4bTVq6qCYo9QvPW1loKccrlPLJrrZ7uPZ6sIHc4xz7GKD6qSpuvEtqMv4OAaly+G8bQYnQlhckUkJruUuogNVFL1011Dmr3Dm3npE0Y2/6WXrhBWv/nEGBcbRJZZeUmYljdfBeO+027dLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769411759; c=relaxed/simple;
	bh=K3mQHvHvbxDo6ZR6Cy/IgkUkQJl0p1EgEOknrQGVkMY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qOrEM/qRyO3BMMbz7Iuc3m8WppniWInwsx7zP8Yp8FDUpbXZ+TtkkrSj/gdMJG27LpfNhcDxIRyojOLaa8gIH+x9SzKYskdX4s6x3iiP6wVgfQRLihcheumxqnLlnL6Dw3LhcAnid/Omg72lxLPshb2Y71WTA3AIp1mr5MK1kEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=SltQzEj9; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="SltQzEj9"
Received: from LAPTOP-N070L597.localdomain (unknown [81.31.232.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 31f541adc;
	Mon, 26 Jan 2026 15:15:40 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: song@kernel.org
Cc: yukuai@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] md/raid1: fix memory leak in raid1_run()
Date: Mon, 26 Jan 2026 07:15:33 +0000
Message-Id: <20260126071533.606263-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9bf928804b03a1kunm437a0c4c12d9df
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTU0fVhpLHUNMHU8dTUlJGFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlDSlVISlVJSElVQ01ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=SltQzEj9joVXzvLAM4DcCtDd7cYA0CQ2DvnR4YBXXOxiL8askXhez7VPb1tyZBU+SACUC6Qx7dNTd7Aiet/7lyHa0e342kuhgqewvUe9U/oNlmxVTBiZ0EFXZeIo8XNmGSGAvOMX9zuFzC9lE/3p7YNtuz27vaXqcwaNQ8QUZqE=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=FNb78AWYeEhC5H2RaIKxHjQFZUgb3O+y4KkKcIEmdMY=;
	h=date:mime-version:subject:message-id:from;

raid1_run() calls setup_conf() which registers a thread via
md_register_thread(). If raid1_set_limits() fails, the previously
registered thread is not unregistered, resulting in a memory leak
of the md_thread structure and the thread resource itself.

Add md_unregister_thread() to the error path to properly cleanup
the thread, which aligns with the error handling logic of other paths
in this function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 97894f7d3c29 ("md/raid1: use the atomic queue limit update APIs")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57d50465eed1..cc9914bd15c1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3254,6 +3254,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret) {
+			md_unregister_thread(mddev, &conf->thread);
 			if (!mddev->private)
 				raid1_free(mddev, conf);
 			return ret;
-- 
2.34.1

