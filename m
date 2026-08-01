Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1242338595;
	Sat,  1 Aug 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605153; cv=none; b=Rj0LNgc4pYWXgPcYRZrjttA7tpqaDIAxLtL9FQ+NL/BZ40v2rHN7qOFgOe9yq5i1je1/8mi5deNVN93WNDtSzRkxFyD0zJF86Dbg0aupHuPRTz1CFZknRLiWNndp6Bgrwn2acovV4q8bvy+fGD+gvC/AggElQvbvlfabFJ8jzEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605153; c=relaxed/simple;
	bh=JBy2hAxptUhfnmGWm89fEXpot33TfN5mNSxd3wLMA8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMHjntz4zfVoO3yure/MGCrkhPatcj8Qs7J0UJJ+c6y9KL/vE9qEcDwAAdAUsb3tHmY11NAUPaAepgDNCm1k1xdRUF8dHHQfK/h+NwGniX0aaCHeHVdVU1naMPIKaIzXGl24t1mAXu9oBhe7JdYGTisEJeXUyNivepHN8V1Spkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6xRD9LM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6xRD9LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383AB1F00AC4;
	Sat,  1 Aug 2026 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605152;
	bh=z+ZkBmM/2h0cWvxullEWJCwx7jlcxedVIL2neZI+hsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6xRD9LM/jQpTux3Ip1Svf+ZBqpPCeSRje0j2rGSkvDgkcdOcalsyBiwfG/VzlyMH
	 ln69txqL8c5iDChoW8h0h7BMxBqLqpj4zxqhMmmsfHYwqc5NAY6UZPzGXzJnT1IWA3
	 e5kke9ZCl2GIfo8KPjAGLcfJOUIl+Xf8JO9q6tMYjWvjnX21MI2xA8IJ4p1l/05zL3
	 qUHVGVTCyw3WWeew9kz28L7zhMBqbh82PapIbrulqIVmECCxpXuBCAbsBfrIa4mZei
	 +/uQnGKxfSaOwj6mBWRHiTc+R4LqF549S149215oiUpxPEAci1SAESa3roWf7Pozkd
	 dFUT9Y4GBYK6A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/25] md/md-llbitmap: use GFP_NOIO for cache allocations
Date: Sun,  2 Aug 2026 01:24:56 +0800
Message-ID: <20260801172519.2982121-3-yukuai@kernel.org>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 131582724e7e..6ab2188bba27 100644
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

