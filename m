Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAB222B5AC
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907190; cv=none; b=jX8kS/rgXe8X7AyILF0YYUOnoHNe0vn/REaZpcDm0J1N4hSmBqQJMguiM+/aDE9TUFgS0sXGC3eVFvnCtZO2+13b8NMkPm7x1amNsfCfcDSEA/HWJgSKmMC4hK029whGgraQT+m2PTgpZPw+Mb2vAjK8WsYd94P3WKMI89rrQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907190; c=relaxed/simple;
	bh=GobLgk2lJvzWMELH6FjkNjae7fqaLJovxq1eOi+KAGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrt7NyJG9sB+QKeQ/vG84l9sDY4DtLhQWgTJ1HUiQgkIwgxvSFMEvv6VhgRQ12jVOpN6bPpYI1K6zU70pN1D6gMQFBZoeSuAfKe8YrjB1PY6qiX1g76YbrXPVz5qX0v0XLvAYfm8Dvs+BZyfR0QXX5QPF4I1Rm2JXJ7s0bj1Xyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFmniNrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFmniNrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FE6C4CEE3;
	Mon,  7 Jul 2025 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907190;
	bh=GobLgk2lJvzWMELH6FjkNjae7fqaLJovxq1eOi+KAGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFmniNrMvpcCPDZXRckuCLxP9k7mtEfyJhAjOILuXQwC+KKkzgbV+btuee2BoNUO3
	 5Cg+4RgJDnAoWDz7Jk+XUBToww9ATeZQMUQUl9u9JP9dp15gcGL4+JgYHfmMGRfCwA
	 5KbsP8MnyN+1rndLkhV2EpUw3YfWlwRR9QCxrnE9VZZsN31smxnxoLKjfWaLDT1aRf
	 HLXneuGJUFmNFfpeozAnrRuFzPSyEMpJx2jrSWNLcPx/Dt/wjXxOFYDZLhpbPiJ9L7
	 dxgdGygROjQvwyXoLzSlfCnvgyNoMDdKX7Pg5G5HPnbiUAyNruZ62iN+dgR8wFaRFA
	 Ntt11By9A/arw==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 04/11] md: add a new mddev field 'bitmap_id'
Date: Tue,  8 Jul 2025 00:51:55 +0800
Message-ID: <20250707165202.11073-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707165202.11073-1-yukuai@kernel.org>
References: <20250707165202.11073-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Prepare to store the bitmap id selected by user, also refactor
mddev_set_bitmap_ops a bit in case the value is invalid.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++------
 drivers/md/md.h |  2 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index efb38b9cfbd0..c0499bd8a2aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -669,13 +669,33 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct md_submodule_head *head;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return true;
+
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	head = xa_load(&md_submodule, mddev->bitmap_id);
+
+	if (!head) {
+		pr_warn("md: can't find bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	if (head->type != MD_BITMAP) {
+		pr_warn("md: invalid bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
-	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", id);
+	return true;
+
+err:
+	xa_unlock(&md_submodule);
+	return false;
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
@@ -685,8 +705,13 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
-	/* TODO: support more versions */
-	mddev_set_bitmap_ops(mddev, ID_BITMAP);
+	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+	} else {
+		mddev->bitmap_id = ID_BITMAP;
+		if (!mddev_set_bitmap_ops(mddev))
+			return -EINVAL;
+	}
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8452aaa2295d..ed23215c880a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -40,6 +40,7 @@ enum md_submodule_id {
 	ID_CLUSTER,
 	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
+	ID_BITMAP_NONE,
 };
 
 struct md_submodule_head {
@@ -565,6 +566,7 @@ struct mddev {
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
+	enum md_submodule_id		bitmap_id;
 	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
 	struct {
-- 
2.43.0

