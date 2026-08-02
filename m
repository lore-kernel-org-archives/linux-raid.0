Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B92C3268;
	Sun,  2 Aug 2026 19:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700279; cv=none; b=onZuMR24UGZ3jfEg0y1ZeU25J1SjIdOHFQkasH9w6SSYobe0nuaqNG9UxCtcw64hYthnNY3fpkA8FhWCeExkuXLoI2tHa8gX7y1QwOHK5LRKJ5eYx56gs2oSyhDernqV5clDXKCQ3UbmWCMJicU/It3oZrT3en6T1zBrkSpZG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700279; c=relaxed/simple;
	bh=j+Bx6hcAl8Jh46CtaKGJbg+bQLl23CqsGe+1aHLbspk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ3H+YGdp6UanLfE0IUu/aHck3d79pGWA6DqG2Ds8muXsTZ3iuFNWKS/ZnJ2wwZQKWCeE7UKQNyPqeVV/Ukrj9ZMeNHpiNwTGAVczyyqK1AAUd9pIIHKyk2bJHvxwBYkIHvezbwVsIjTelGvgalopUWsMm97vxn1Q0CVu1VUDE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwhxCDsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwhxCDsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6E71F000E9;
	Sun,  2 Aug 2026 19:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700278;
	bh=b88ojlcMxi5aXfQhkor5RNl8RmZyAxl1XkqT0+eJGYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwhxCDspJQOE4jfCZmWFZgObuEi5amSdtFK/7xMOvxgndgzlT4uRWvT3C3O6ZjDoe
	 yj8F34fqQj1r7X1SPVMSgzbc7t+MXO7ZhBY5aTcJQ56HHJKzUoH4qGnl5XOq2wELEL
	 kLg4bjgbJUjIOPA+bcteQR+t+C4a4FDei0cuY0tJnkXKphwFvUDIa8KH70ufIkvbQE
	 NdvvKELJ7goUx80xRX9vsuf8G1wN63DTSvkLy1LXdNsIW1s+f0uA/LzH6DwJLOrUnd
	 uV+j2Bk6+kpLxw1+Ma1y2ub2yKZzcgac7GK4vFrV/fnvi8CrRWU5Gn3EXa+7feG59z
	 E3u9Z0lottz8w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 09/29] md/md-llbitmap: stop daemon timer rearm on destroy
Date: Mon,  3 Aug 2026 03:50:18 +0800
Message-ID: <20260802195038.164272-10-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap_destroy() deletes pending_timer before flushing
md_llbitmap_io_wq. However, daemon_work can still be queued or running
after the timer has been deleted, and the daemon path can arm
pending_timer again when it finds dirty chunks that are not ready to
flush yet.

If that happens during teardown, pending_timer can remain armed after
llbitmap is freed and later dereference freed memory.

Add a BITMAP_SHUTDOWN bit to llbitmap->flags, set it before deleting
the timer, and make the timer and daemon paths stop queueing or rearming
work once teardown starts. Cancel daemon_work before flushing the shared
workqueue so no already queued daemon instance can race with the free.

BITMAP_SHUTDOWN is a runtime-only state. Mask it out when reading and
updating the llbitmap superblock so the shutdown state is never loaded
from disk or persisted to disk.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-bitmap.h   |  1 +
 drivers/md/md-llbitmap.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 214f623c7e79..890276d9c66e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -29,6 +29,7 @@ enum bitmap_state {
 	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
 	BITMAP_CLEAN       = 4, /* llbitmap is created with assume_clean */
 	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */
+	BITMAP_SHUTDOWN    = 6, /* llbitmap is being destroyed */
 	BITMAP_HOSTENDIAN  =15,
 };
 
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index af80a630bd21..3ec5b5985d48 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -789,6 +789,7 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		if (state == BitNeedSync || state == BitNeedSyncUnwritten)
 			need_resync = !mddev->degraded;
 		else if (state == BitDirty &&
+			 !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags) &&
 			 !timer_pending(&llbitmap->pending_timer))
 			mod_timer(&llbitmap->pending_timer,
 				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
@@ -981,7 +982,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		else
 			mddev->bitmap_info.space = mddev->bitmap_info.default_space;
 	}
-	llbitmap->flags = le32_to_cpu(sb->state);
+	llbitmap->flags = le32_to_cpu(sb->state) & ~BIT(BITMAP_SHUTDOWN);
 	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
 		ret = llbitmap_init(llbitmap);
 		goto out_put_page;
@@ -1037,6 +1038,9 @@ static void llbitmap_pending_timer_fn(struct timer_list *pending_timer)
 	struct llbitmap *llbitmap =
 		container_of(pending_timer, struct llbitmap, pending_timer);
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (work_busy(&llbitmap->daemon_work)) {
 		pr_warn("md/llbitmap: %s daemon_work not finished in %lu seconds\n",
 			mdname(llbitmap->mddev),
@@ -1057,6 +1061,9 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 	bool restart;
 	int idx;
 
+	if (test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
+		return;
+
 	if (llbitmap->mddev->degraded)
 		return;
 retry:
@@ -1096,7 +1103,7 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 		goto retry;
 
 	/* If some page is dirty but not expired, setup timer again */
-	if (restart)
+	if (restart && !test_bit(BITMAP_SHUTDOWN, &llbitmap->flags))
 		mod_timer(&llbitmap->pending_timer,
 			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
 }
@@ -1179,7 +1186,9 @@ static void llbitmap_destroy(struct mddev *mddev)
 
 	mutex_lock(&mddev->bitmap_info.mutex);
 
+	set_bit(BITMAP_SHUTDOWN, &llbitmap->flags);
 	timer_delete_sync(&llbitmap->pending_timer);
+	cancel_work_sync(&llbitmap->daemon_work);
 	flush_workqueue(md_llbitmap_io_wq);
 	flush_workqueue(md_llbitmap_unplug_wq);
 
@@ -1523,7 +1532,7 @@ static void llbitmap_update_sb(void *data)
 
 	sb = kmap_local_page(sb_page);
 	sb->events = cpu_to_le64(mddev->events);
-	sb->state = cpu_to_le32(llbitmap->flags);
+	sb->state = cpu_to_le32(llbitmap->flags & ~BIT(BITMAP_SHUTDOWN));
 	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
 	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
 	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
-- 
2.51.0

