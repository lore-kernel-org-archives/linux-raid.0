Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E97377016;
	Tue, 28 Jul 2026 08:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228614; cv=none; b=VknELUv4To8dDicPAVxmN6/vucLeGcuAuxHKGxOheMrBrA91Oza8LgSJ01w2/YETUHdGjD9YFQlPQYiDMCPGxn6AYHbm3dKXLe5pMGhPkaiGPzXjjapPeXZvqJeBHSshH6ME2LJR/ge5uLWmOTs5+4rADn2/Z94oQ0GtVuxI6hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228614; c=relaxed/simple;
	bh=filB/C3ZzbSop+rYl+4GCdH59K5Kp+kH4tuyQvKBpWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJz7Rn/7JB5UkOXU+x+onuHQ7sHPN/ViJeD3VMmXym0HShGZCvotYl+qijENM/GpwUXExwKJopdMl0BN5SjdWWlnCRYPq6IzfNEBzWqhAhPzGAlKHQDHtXrnj8I5MFiAtuoWdhEOsukYKf2QeBErHCLNFIwxSERs8aHz3JmRvtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULrrqxpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULrrqxpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184C71F00A3D;
	Tue, 28 Jul 2026 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228612;
	bh=W+NCiShdC2NNq6UxdarZzTmFcxaR2trlYvajIoxgCzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULrrqxpya4IAElTe7RzHYloNziraDpJAC157NwaLDboPzzt0Ps63cgPUIhi6/ko/J
	 Qg126hRZkSUHGyDB53kRnA2pk0J4YBjjS7fzG8Y6sxT1+XTlPWwa/V//bhVXEvskfB
	 Y08jO5gEb/qNYIzBXuFBfpo3KPDXj7Yz9n7Wl4iBpH4uLvy8om7d9I6XhBqDQckDM4
	 jgM1JmEhXrLGXDeRgOyNP2PhT5qaVaaRxPxLwWT/RjW8abVUdDlnKPUu9vKfqbv6Jo
	 GFXsXFdHzF0SGJYECs3tgz9p9emTrLElmGId239Xom1Es7VsnFslIMAT1UmSYmJmiT
	 zb3s3o6smO1qw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/21] md/md-llbitmap: finish reshape geometry
Date: Tue, 28 Jul 2026 16:49:09 +0800
Message-ID: <ed61e406f8b6b60193c647ab83dd8fb5df0391d0.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
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
index cdced2126e97..55ab2a8a11e5 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1349,11 +1349,20 @@ static int llbitmap_load(struct mddev *mddev)
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
 
@@ -1680,6 +1689,30 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -1977,6 +2010,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

