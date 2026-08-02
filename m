Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850E30FC1D;
	Sun,  2 Aug 2026 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700254; cv=none; b=ceVV3wL4GIbIgcdn8uDM0eVYAQXJBErd2np60G4DfINydcKCsf1XbH+yFBG2z6QOw4p+Nc3iBirZvHySt7dYGpfkA752bJuTHyCTg5kWYnpc7/PPBsb3diVJgJFC6wKVYbIt4okWOG9aTNjfReLTJm/07eSSj08DP67R+pDutCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700254; c=relaxed/simple;
	bh=SrShhO8INsztxN7vjuAEUFnP+ZrFXn1nQ1h3HBereC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEMeOspD9Y+QcdgxPZ1rP+oBEi0sIMtrZvhg914vYjXwHZM4S11U+giLAw74ZMACvfXwY2gZDTBctSR9YtB/ff99WiSCsvzUCu/WhscJ0AIe/1FvvLqz1P5UqFgiO4nChDGS0Kt7sevyqHY23drz0WctRn9wk6DC3iLx7N3RJvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1bU1/PH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1bU1/PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB2E1F00A3D;
	Sun,  2 Aug 2026 19:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700253;
	bh=iko4rhiQxzapxJGjwNL1TsJTPSuLholuXSDe7HLrqz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1bU1/PHGdQ0bwVsc3z969iyZPj7mF62/vw26z/nAO8yf8/mTONNREJmS4mplnSnY
	 EnwZEXmi1FMd8x0wrBFbScOiblWIyj3eq2rOvE0m2/uiAMU+8VuYG3A/RKmnjj/SDt
	 GAaGdcZnVG1nIFDMMd9XLdOP+BocNB/6XhCdOqbJdxWeiBSgstNwzQDcxvpqxB98pD
	 olqiZu0KCQy02nuYc2lNNFk+h8XE0Fz9pRXUaDp+ckrnVrTp7/1XZiaVF61+4j5F/M
	 JiSaa+aPturAiqUU3j3ckhRrN+m10HSrbh5lxSuLyuQZab0of7Jp9mOJpuUL/JgCUf
	 ea8445NtI2gpg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 02/29] md/md-llbitmap: use GFP_NOIO for cache allocations
Date: Mon,  3 Aug 2026 03:50:11 +0800
Message-ID: <20260802195038.164272-3-yukuai@kernel.org>
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

llbitmap allocates its in-memory page cache and page-control structures from
paths that can already be holding MD reconfiguration or bitmap state locks.
For example, component_size_store() takes mddev_lock(), update_size() calls
the personality resize method, and llbitmap_resize() can grow the page cache
through llbitmap_prepare_resize().

Using GFP_KERNEL in those paths allows direct reclaim to enter filesystem or
block I/O while MD resize state is locked. That can recurse back into the
same array and wait on state that cannot make progress until the resize path
finishes.

Use GFP_NOIO for the llbitmap object, cached bitmap pages, page controls,
page-control arrays, and percpu_ref initialization. Leave the explicit
metadata zeroout path unchanged because it is intentional bitmap I/O rather
than reclaim-driven allocation.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 71e9a21b98b2..3cd8373bc9b2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -521,7 +521,7 @@ static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
 	if (page)
 		return page;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_NOIO | __GFP_ZERO);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -616,12 +616,12 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 	int i;
 
 	llbitmap->pctl = kmalloc_array(nr_pages, sizeof(void *),
-				       GFP_KERNEL | __GFP_ZERO);
+				       GFP_NOIO | __GFP_ZERO);
 	if (!llbitmap->pctl)
 		return -ENOMEM;
 
 	size = round_up(size, cache_line_size());
-	pctl = kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
+	pctl = kmalloc_array(nr_pages, size, GFP_NOIO | __GFP_ZERO);
 	if (!pctl) {
 		kfree(llbitmap->pctl);
 		return -ENOMEM;
@@ -640,7 +640,7 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 		}
 
 		if (percpu_ref_init(&pctl->active, active_release,
-				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+				    PERCPU_REF_ALLOW_REINIT, GFP_NOIO)) {
 			__free_page(page);
 			llbitmap_free_pages(llbitmap);
 			return -ENOMEM;
@@ -1110,7 +1110,7 @@ static int llbitmap_create(struct mddev *mddev)
 	if (ret)
 		return ret;
 
-	llbitmap = kzalloc_obj(*llbitmap);
+	llbitmap = kzalloc_obj(*llbitmap, GFP_NOIO);
 	if (!llbitmap)
 		return -ENOMEM;
 
-- 
2.51.0

