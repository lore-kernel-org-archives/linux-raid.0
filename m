Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623C030DEDD
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 04:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192177; cv=none; b=euM51jCsH4dy54NxX4FDta08FS2x3poguB1YsrXO7QtNu+/WqqJsh7IOSxClNbyGUNB4ez/90J/bxrpHC1Al9NHZ4I6QNbCXbfWv6N3jxQqF03/2jJq9Fzn4Y8waPIi0vUL9uiSwu7WDHuc6sOTWzkGZcdDtC6rtuBIk9KiyLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192177; c=relaxed/simple;
	bh=VcvRT2kU2+Gnxw5qLlh6oIKyHJ18/RTCihIZilmokSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLTJUdxxfjFTfWqtyFbg+Rg4JisAhy4HslPcogPSQu70E2LnuZYCBSbuzzpX1oNZKiRA4ihqIEi7girXu2Fe4pTurGN7dJNnbft9LmeGvQWv3QGU4IBfFijHWbiankXMhJmKE9llI7yXbsClSZrrpAMdoQq6ItWai74zfBEJ8No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A905C116D0;
	Mon, 12 Jan 2026 04:29:34 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v4 09/11] md/raid10: align bio to io_opt
Date: Mon, 12 Jan 2026 12:28:55 +0800
Message-ID: <20260112042857.2334264-10-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112042857.2334264-1-yukuai@fnnas.com>
References: <20260112042857.2334264-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The impact is not so significant for raid10 compared to raid5, however
it's still more appropriate to issue IOs evenly to underlying disks.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 09328e032f14..2c6b65b83724 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4008,6 +4008,8 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

