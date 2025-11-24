Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670672E093B;
	Mon, 24 Nov 2025 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965946; cv=none; b=TSw0qM7a+uMckZz86JHOE8NTYIB6qktLWtFC9j3gy+KRn2VD+gocnANVSxf+mjDoO92+zX0NklutjUyrhwfO9f4tesW62/TlE8JXs7kdedBNVm8vShZ62r5eZjq+VwD2PW17a6H/uhd7piYxmqPGGM0R8GmGbF0tOH0FWfqPHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965946; c=relaxed/simple;
	bh=WAc2Acq73SBDFe9cL4p3D9sMxC+yEhbbN+qNSuKZSjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMequpk8fLsRFP1MWMpgR+vYiBACXLWvsRfK5PUPjDpkKTCLWdNjav0iB9oRvnauMUsvTwLmi9PRLYutLrd0cRM6ttlrpJgii1tW6bWyTwCdWe3mkqCsB46hu7Q8XHWCNzCWBU0aPyC7m4P19NMr0U9LgWzOjOlunh9l8lBnzHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EC4C16AAE;
	Mon, 24 Nov 2025 06:32:24 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 09/11] md/raid10: align bio to io_opt
Date: Mon, 24 Nov 2025 14:32:01 +0800
Message-ID: <20251124063203.1692144-10-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
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

