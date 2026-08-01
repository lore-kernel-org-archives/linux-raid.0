Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7C293B75;
	Sat,  1 Aug 2026 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605220; cv=none; b=gDPw4LCQE9GQqBboGrpUucTQTR0aDvvTR+UWcJSu5PKLpb5WL0345IA1Dk+mIza87XfF/f3JBiQXpe/iBONZ5POzbqopFQZ+PaOTuaFZYO10favuBQ9BjHLOSDlU3VJ52TZ0Zrb4SifNC53NjORAa8MAoSmeOrqUorJithtJ7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605220; c=relaxed/simple;
	bh=gMAZOUU1RAHcRFS6oit2lQ0Z3i8Lf6X+JxkLbh56zug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5oJCMScQ2Z3EoPyeReGbTJGY6BocD/J6PnzEmrTuH+OZi+qEVVK7yhRjvZw/NsFnMGL8SBvdq994UHW4ArO5iZOM8oT5IZ1XpfIMRk68gFNGsq1wWd82DYH70Bh0t0RNDWfnSq2OYt4UilXledCXuPMkapxbxg9p8k7e/ouBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aavnY4Qp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aavnY4Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBDD1F00AC4;
	Sat,  1 Aug 2026 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605218;
	bh=88/Yg7HG6sR0d7UBoCaiHtmMN56BWEV6IpinjNf43Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aavnY4Qp2ymqiq6ERFp5G3j3uzkXaXOtERW43wwlEUSN4rIlkmBGHm924nG7cAdba
	 t/DrT9aGfq0CgfSi6YBKzXP4jLB+2tVAfAyKZnis+VXkdaeJQkyLrAA0utkU3TYq56
	 BwR1Cu5Un2iIgPauWLz4qBkByWw4ZwjYf6Lp9I1Q5dx80TQsd10Y+l4Z2H3Icr+lkf
	 LCncgwjvtFg9sXiZkNWfKsYz+V3MBqImg9cOmo1ajNbVlPOm4rVV6afa1x8y85e4e7
	 jQOG6GERR/vwzrmTR1iiFKhSCDUEUOTU8mOAKNB8icr0IUer30Ww/JMtHXLqKR78fj
	 LSlC/JO8OuJeg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 13/25] md/md-llbitmap: finish reshape geometry
Date: Sun,  2 Aug 2026 01:25:07 +0800
Message-ID: <20260801172519.2982121-14-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Commit the staged llbitmap geometry when reshape finishes.

When assembling a stopped reshape, md_run() creates the bitmap before
publishing mddev->pers. llbitmap_read_sb() can therefore only initialize
the reshape fields from the old on-disk sync size. Refresh the staged
reshape geometry again from llbitmap_load(), after mddev->pers is
available, and expand the in-memory page controls before replaying bitmap
state.

Reproduce on the old kernel by creating a RAID10 llbitmap with four
active disks and two spares, growing it to six disks, then stopping and
assembling while reshape is still running. The llbitmap chunk count was
32704 before grow, 49056 during reshape, then rolled back to 32704 after
reassemble.

The fixed kernel kept the target geometry across the same stop/reassemble
flow: 65440 chunks before grow, 98160 during reshape, and 98160 after
reassemble.

Reported-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.io/
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 37d1312e3eab..f41f9ba2063b 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1358,11 +1358,20 @@ static int llbitmap_load(struct mddev *mddev)
 {
 	enum llbitmap_action action = BitmapActionReload;
 	struct llbitmap *llbitmap = mddev->bitmap;
+	int ret;
 
 	if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
 		action = BitmapActionStale;
 
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap_refresh_reshape(llbitmap);
+	ret = llbitmap_expand_pages(llbitmap, llbitmap->chunks);
+	if (ret) {
+		mutex_unlock(&mddev->bitmap_info.mutex);
+		return ret;
+	}
 	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action);
+	mutex_unlock(&mddev->bitmap_info.mutex);
 	return 0;
 }
 
@@ -1694,6 +1703,30 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
 }
 
+static void llbitmap_reshape_finish(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 1);
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap_flush(mddev);
+
+	llbitmap->chunksize = llbitmap->reshape_chunksize;
+	llbitmap->chunkshift = ffz(~llbitmap->chunksize);
+	llbitmap->chunks = llbitmap->reshape_chunks;
+	llbitmap->sync_size = llbitmap->reshape_sync_size;
+	llbitmap_refresh_reshape(llbitmap);
+	mddev->bitmap_info.chunksize = llbitmap->chunksize;
+	llbitmap_update_sb(llbitmap);
+	__llbitmap_flush(mddev);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 0);
+}
+
 static void llbitmap_write_sb(struct llbitmap *llbitmap)
 {
 	int nr_blocks = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
@@ -1991,6 +2024,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

