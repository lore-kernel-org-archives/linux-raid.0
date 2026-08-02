Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1683368A2;
	Sun,  2 Aug 2026 19:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700310; cv=none; b=Xge+/NJu8OdXT4R8D8X9Jt5W8qcDG2ni/zVZDQNjpMvU9pxl2v9hMiJlkw9uRt7vafEu1DUuLQ11oCtEK4oYsKCU6tN/9/cMzO2iJj+KUP+Ut53Ze10gC1ACWjt1QKlBSRX5OQR8pjCnSzEi50i9vgH1l243jLvhMVTqJa+1xO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700310; c=relaxed/simple;
	bh=DJ6EU+fzv8iOEUsBftq9+B6ZNyeKCzhFbRnYctpHLt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnKAGMN8vVcYvTgPGH/M5FxXDsFXNogiN3UUKb0i9kYLpSiobTgaOYJAsFXnSGWtB3K4oE50roxDlQSoDc47DBsl6fRQheiY5j4vdpNxq5yxJk2TikF8HcViQO1ruHse2/0+zNKinJy1ss7DiYXwc6XKW7VYzy3l6r1/I4gby2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoD+aKrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoD+aKrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A51F00A3A;
	Sun,  2 Aug 2026 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700308;
	bh=kbUdOuogwlmBTpohYQNpHXGAq9yvsml8HoNAsDi+sfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BoD+aKrtv5sfcEF7Iy/ZKZr/BLsv+T7G/ocgVBqTsBi/MKTScQr4m4qGiovpF28u9
	 gOSaD+EPtZRB4kAAcK0mXI47FLpcAgZ+CwC5VwiE+at1YRBYHlc5F89NGq2Gzsc7Xd
	 BSrrt4c5Y3Vyo6z0qVJ1XcrD9gv3V94OZ7Q/2dsgo+RTFnteSQ7C/ne39wnDq9OCAj
	 QjLUzXGFIIDpF64H7LDNRcxnztfn+ji/WCHXZvsb96IyWh+K+Z/Ud8skh0bVNOyc1t
	 BPf4Nu9l1rjj3Ttmukw6UZC3XdOGYH4ufbqaBSHmb55bx1/XITj89rDL45eAUCm9gN
	 1BhkBbT+RIwvg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 17/29] md/md-llbitmap: finish reshape geometry
Date: Mon,  3 Aug 2026 03:50:26 +0800
Message-ID: <20260802195038.164272-18-yukuai@kernel.org>
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
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 71a490390142..a7c229db3058 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1371,11 +1371,20 @@ static int llbitmap_load(struct mddev *mddev)
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
 
@@ -1709,6 +1718,30 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -2000,6 +2033,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

