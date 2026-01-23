Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A4523E350;
	Fri, 23 Jan 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192790; cv=none; b=k8aQJHDt3gfha0xsUTaL+RX2qwOzWy6EotWXArRZj28GLh1rjG60g9GuqiujFOTDDA86QOiehRShhQKfclA59b243/QBXqUpJTK80uIn1Intce0WbfoLGGhxkH7jXaxPse/dctgQBofSdMBp+Pc7sk4hjboa4obwkUK+taug41g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192790; c=relaxed/simple;
	bh=CRDxlBhjhYbWJmkkpVifsndCgbeVBtCB6SFLy2iU2fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvAHbJCpHBS7syKZTGEl9A38qdwQBtz3suZHRqsAzFcLE2XpNjfSZzIIc2S8q/7rdfCdOgUnvi/el+sVUYnVgvDrx7GndOMp0o9oKLau9/9ySuAWuu6sqtagTXyNN9kJEscoHM+F5m69vDhxBfWO2HZA70MJSepkuG8hOPSyHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDABC19423;
	Fri, 23 Jan 2026 18:26:28 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 1/2] md/raid5: fix IO hang with degraded array with llbitmap
Date: Sat, 24 Jan 2026 02:26:22 +0800
Message-ID: <20260123182623.3718551-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123182623.3718551-1-yukuai@fnnas.com>
References: <20260123182623.3718551-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When llbitmap bit state is still unwritten, any new write should force
rcw, as bitmap_ops->blocks_synced() is checked in handle_stripe_dirting().
However, later the same check is missing in need_this_block(), causing
stripe to deadloop during handling because handle_stripe() will decide
to go to handle_stripe_fill(), meanwhile need_this_block() always return
0 and nothing is handled.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8dc98f545969..93e672b3432b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3751,9 +3751,14 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
+	struct mddev *mddev = sh->raid_conf->mddev;
+	bool force_rcw = false;
 	int i;
-	bool force_rcw = (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW);
 
+	if (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW ||
+	    (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
+	     !mddev->bitmap_ops->blocks_synced(mddev, sh->sector)))
+		force_rcw = true;
 
 	if (test_bit(R5_LOCKED, &dev->flags) ||
 	    test_bit(R5_UPTODATE, &dev->flags))
-- 
2.51.0

