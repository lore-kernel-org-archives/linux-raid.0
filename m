Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1B32ED4E;
	Sun,  2 Aug 2026 19:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700276; cv=none; b=R5trnle5MoejFvw5ACDrW1j1e/Yn1bvt5dDKkKT9WyQxyAz4BBuOnG2VSAyLrisV4JH0fI4gfzB+aCciDhcmlSpggVK2eXO2eFOCZQUp2IeDDfjB8tGhdE6eYH55lB1zLTL46oxHBUPmSPQEFWTsOt+nHzq3mE/EUYRIBgHa2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700276; c=relaxed/simple;
	bh=zHjud01RmE5/01zjpU7ubwPhSXmrMv6FIQHfJg4x2QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOC2ASqQ2YQPKNNaB22jCKXHHa+r77mN3wMklJqqDiGDCd4LHxJIezrZch3Xh6XxuuaiTr/GxGwgDWAbjUR8drZULom2tA2Ncph/Ialr9Iz3PoCrdJzn/+DYOwtTc3JyEXVUe9WbCAWYk3iMfuhLfc0rUdau2/QdGsVWt0la4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bj1dDfZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bj1dDfZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9FF1F00A3A;
	Sun,  2 Aug 2026 19:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700275;
	bh=0Y2NONpX13C3hOlDmvNXngKpBN72tSpW1BA7NqTzK00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj1dDfZZ20ZRxkFebDQXa9DKphUFt2/gnAuXoijZgoYMfqAiGkYptqjgfWeQl3B0Z
	 47uZ8EsaZHSMYvIqpwrmYsUPuVFpJsWd+MCU7kSDWUKYTegI0Zi5SOQ/K3hJMJqRvs
	 EdJMe2KknlxbtMnn3k7ZBFg4vFINvNUM0owdXUNzIZQmsj8GhZ0ejLDH2o7rBYQR72
	 fmP+D2vfIM6DCvJ/IYhvnVgDs4Vq0bSlcB9Fsih45a0RXtvICtr1e93FQCEEX3Vtbs
	 5EvAGrovf3meJyj7fqC1BUFvOj5cbyq8f1BGjPSYSUUFTzF/XRDzre5giLkGyFxbj1
	 pK5rUFo+ZMiOw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 08/29] md/md-llbitmap: prevent create failure bitmap UAF
Date: Mon,  3 Aug 2026 03:50:17 +0800
Message-ID: <20260802195038.164272-9-yukuai@kernel.org>
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

llbitmap_create() publishes mddev->bitmap before reading the bitmap
superblock. This is needed because llbitmap_read_sb() can initialize a
new bitmap and flush it through helpers that use mddev->bitmap.

If llbitmap_read_sb() fails, the old cleanup dropped bitmap_info.mutex
and freed llbitmap before clearing mddev->bitmap. Readers such as
/proc/mdstat rely on bitmap_info.mutex to keep the bitmap pointer stable
while collecting bitmap stats, so they could observe the stale pointer
after the failed create path released the mutex.

Clear mddev->bitmap while still holding bitmap_info.mutex, then free the
failed llbitmap after dropping the mutex. This makes mutex-protected
readers see either a live bitmap or no bitmap.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 948bf64c5ad2..af80a630bd21 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1126,10 +1126,11 @@ static int llbitmap_create(struct mddev *mddev)
 	mutex_lock(&mddev->bitmap_info.mutex);
 	mddev->bitmap = llbitmap;
 	ret = llbitmap_read_sb(llbitmap);
+	if (ret)
+		mddev->bitmap = NULL;
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	if (ret) {
 		kfree(llbitmap);
-		mddev->bitmap = NULL;
 	}
 
 	return ret;
-- 
2.51.0

