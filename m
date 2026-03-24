Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29983285CBA
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774337118; cv=none; b=rTxJEMyif3+YxykuTelaNNgtg8iV7LdoQKnomtA9OX7iwnYtnvLxwGl1O8gH5yFWo1fFCLHW9lJ1K6ZnhSSK7+JGhmOX7WtaLwVP8pwmbry1dpMOsE55pn6y+YwYxgWmEFlhy5Lkn1HY6kEx0sVmudRC2V1bCluG2Oo4CdvE3CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774337118; c=relaxed/simple;
	bh=WI5ej1r+X23H+2urWE4LFr4sKD3bhY2OfBpTbVYyx2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZ4sx1U/xRCdBYtUn1owLnGXY2DpFpy4icVVak+2xjWPWQtIW1wo+0gzky/fe3ZlehR/hLMpouozCxQmsov0xFkIqOYJEOfOA1fAq5O5wDBkSGIU9pFd+uaQ2SsYdA0T1GmMvYlSPv1qtTO3RL55UZvTKf4XnydFkHQINdyhaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GoDRCMiu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoDRCMiu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774337108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nQ9IzRu9t2YAkXHEdYaVXesJgBdZLFEL/ukSPYjCFRE=;
	b=GoDRCMiu0O/AS6yxyeqKtSi3gPaiNFG4Rko8qNW2i9CGeRWcLw3ZrT0BkWKwLJu2c1w96m
	M2TpKYZRZ4pFOVFOhwL5GLtFmMIlUNwaYzqS3W93qmIbOjKyRqBLEYV/HBcx2CH2gvyCPA
	N2WfwX948P8S9F+keeojpXpemxhQPLw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-oCLOAVmVNayqnRmVxGne-Q-1; Tue,
 24 Mar 2026 03:25:07 -0400
X-MC-Unique: oCLOAVmVNayqnRmVxGne-Q-1
X-Mimecast-MFC-AGG-ID: oCLOAVmVNayqnRmVxGne-Q_1774337106
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0698519560AE;
	Tue, 24 Mar 2026 07:25:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33D8619560AB;
	Tue, 24 Mar 2026 07:25:03 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH v3 1/1] md/raid1: serialize overlap io for writemostly disk
Date: Tue, 24 Mar 2026 15:24:54 +0800
Message-ID: <20260324072501.59865-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Previously, using wait_event() would wake up all waiters simultaneously,
and they would compete for the tree lock. The bio which gets the lock
first will be handled, so the write sequence cannot be guaranteed.

For example:
bio1(100,200)
bio2(150,200)
bio3(150,300)

The write sequence of fast device is bio1,bio2,bio3. But the write sequence
of slow device could be bio1,bio3,bio2 due to lock competition. This causes
data corruption.

Replace waitqueue with a fifo list to guarantee the write sequence. And it
also needs to iterate the list when removing one entry. If not, it may miss
the opportunity to wake up the waiting io.

For example:
bio1(1,3), bio2(2,4)
bio3(5,7), bio4(6,8)
These four bios are in the same bucket. bio1 and bio3 are inserted into
the rbtree. bio2 and bio4 are added to the waiting list and bio2 is the
first one. bio3 returns from slow disk and tries to wake up the waiting
bios. bio2 is removed from the list and will be handled. But bio1 hasn't
finished. So bio2 will be added into waiting list again. Then bio1 returns
from slow disk and wakes up waiting bios. bio4 is removed from the list
and will be handled. Now bio1, bio3 and bio4 all finish and bio2 is left
on the waiting list. So it needs to iterate the waiting list to wake up
the right bio.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: use prepare_to_wait_exclusive
v3: return back to self managed fifo list to find the right waiting node
 drivers/md/md.c    |  1 -
 drivers/md/md.h    |  5 ++++-
 drivers/md/raid1.c | 45 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 521d9b34cd9e..3348224e36f8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
 
 		spin_lock_init(&serial_tmp->serial_lock);
 		serial_tmp->serial_rb = RB_ROOT_CACHED;
-		init_waitqueue_head(&serial_tmp->serial_io_wait);
 	}
 
 	rdev->serial = serial;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..2208da7915e6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -126,7 +126,6 @@ enum sync_action {
 struct serial_in_rdev {
 	struct rb_root_cached serial_rb;
 	spinlock_t serial_lock;
-	wait_queue_head_t serial_io_wait;
 };
 
 /*
@@ -381,7 +380,11 @@ struct serial_info {
 	struct rb_node node;
 	sector_t start;		/* start sector of rb node */
 	sector_t last;		/* end sector of rb node */
+	sector_t wnode_start; /* address of waiting nodes on the same list */
 	sector_t _subtree_last; /* highest sector in subtree of rb node */
+	struct list_head	list_node;
+	struct list_head	waiters;
+	struct completion	ready;
 };
 
 /*
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 16f671ab12c0..1a8f876765c2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -57,21 +57,29 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, sector_t, _subtree_last,
 		     START, LAST, static inline, raid1_rb);
 
 static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
-				struct serial_info *si, int idx)
+				struct serial_info *si)
 {
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
 	sector_t hi = lo + r1_bio->sectors - 1;
+	int idx = sector_to_idx(r1_bio->sector);
 	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial_info *head_si;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	/* collision happened */
-	if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
+	head_si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
+	if (head_si && head_si != si) {
+		si->start = lo;
+		si->last = hi;
+		si->wnode_start = head_si->wnode_start;
+		list_add_tail(&si->list_node, &head_si->waiters);
 		ret = -EBUSY;
-	else {
+	} else if (!head_si) {
 		si->start = lo;
 		si->last = hi;
+		si->wnode_start = si->start;
 		raid1_rb_insert(si, &serial->serial_rb);
 	}
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
@@ -83,19 +91,22 @@ static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *r1_bio)
 {
 	struct mddev *mddev = rdev->mddev;
 	struct serial_info *si;
-	int idx = sector_to_idx(r1_bio->sector);
-	struct serial_in_rdev *serial = &rdev->serial[idx];
 
 	if (WARN_ON(!mddev->serial_info_pool))
 		return;
 	si = mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
-	wait_event(serial->serial_io_wait,
-		   check_and_add_serial(rdev, r1_bio, si, idx) == 0);
+	INIT_LIST_HEAD(&si->waiters);
+	INIT_LIST_HEAD(&si->list_node);
+	init_completion(&si->ready);
+	while (check_and_add_serial(rdev, r1_bio, si)) {
+		wait_for_completion(&si->ready);
+		reinit_completion(&si->ready);
+	}
 }
 
 static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 {
-	struct serial_info *si;
+	struct serial_info *si, *iter_si;
 	unsigned long flags;
 	int found = 0;
 	struct mddev *mddev = rdev->mddev;
@@ -106,16 +117,28 @@ static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 	for (si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
 	     si; si = raid1_rb_iter_next(si, lo, hi)) {
 		if (si->start == lo && si->last == hi) {
-			raid1_rb_remove(si, &serial->serial_rb);
-			mempool_free(si, mddev->serial_info_pool);
 			found = 1;
 			break;
 		}
 	}
 	if (!found)
 		WARN(1, "The write IO is not recorded for serialization\n");
+	else {
+		raid1_rb_remove(si, &serial->serial_rb);
+		if (!list_empty(&si->waiters)) {
+			list_for_each_entry(iter_si, &si->waiters, list_node) {
+				if (iter_si->wnode_start == si->wnode_start) {
+					list_del_init(&iter_si->list_node);
+					list_splice_init(&si->waiters, &iter_si->waiters);
+					raid1_rb_insert(iter_si, &serial->serial_rb);
+					complete(&iter_si->ready);
+					break;
+				}
+			}
+		}
+		mempool_free(si, mddev->serial_info_pool);
+	}
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
-	wake_up(&serial->serial_io_wait);
 }
 
 /*
-- 
2.50.1 (Apple Git-155)

