Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194C1EB18D;
	Mon, 12 May 2025 01:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013294; cv=none; b=PVKvmHQQmtTZXP3AwCtfNZpBgKHy/Iy8nbEt+EEZ9KRbPTbz9Xzalg+DsWlqcvp8VV36AyUm/3JbA+0REsYNTP09IVQ6S8RK5yUPZc68fOSPRwz2xB6mzZdtKqWNuOJltkYlmUbvRRosJbREEiJtpJ7m3jR/tDL7ZlCtM0GMpH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013294; c=relaxed/simple;
	bh=ELvkmyOJBVEyNAiLctJDaPZmLafbprHc9jlgLasppsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hYVFkrqCt0tpdX1iUwLxRwa9NepXQN5qONDT8hG4Pyi4EJQNT6jgXtUi1xMFh7osCv/gJg4iTZSj2C247jMnDtNK/tc8BKTGXSgSSSTwHeSTkVGVUKWSWZ4a0bfQC6xrDUhkc+UKNfI3/psUQA/ogg7f6fOzQqwcwYc1doUNs+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhmv3RCCz4f3lVX;
	Mon, 12 May 2025 09:27:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A16FF1A0359;
	Mon, 12 May 2025 09:28:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S17;
	Mon, 12 May 2025 09:28:09 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH RFC md-6.16 v3 13/19] md/md-llbitmap: implement APIs for page level dirty bits synchronization
Date: Mon, 12 May 2025 09:19:21 +0800
Message-Id: <20250512011927.2809400-14-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S17
X-Coremail-Antispam: 1UD129KBjvJXoWxAry8tF1DXF43JF18Cr4DJwb_yoW5XF15pF
	WxXr15Gr45tF1xWw43ArW7AFyrtr4kt39agasak34F9F1jkrZagF4xCFyDZw4UWrn5GFnr
	Aan8Cw1fGw48XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

IO fast path will set bits to dirty, and those dirty bits will be cleared
by daemon after IO is done. llbitmap_barrier is used to synchronize between
IO path and daemon;

IO path:
 1) try to grab a reference, if succeed, set expire time after 5s and
 return;
 2) if failed to grab a reference, wait for daemon to finish clearing dirty
 bits;

Daemon(Daemon will be waken up every daemon_sleep seconds):
For each page:
 1) check if page expired, if not skip this page; for expired page:
 2) suspend the page and wait for inflight write IO to be done;
 3) change dirty page to clean;
 4) resume the page;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 315a4eb7627c..994ca0be3d17 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -435,6 +435,14 @@ static void llbitmap_write_page(struct llbitmap *llbitmap, int idx)
 	}
 }
 
+static void active_release(struct percpu_ref *ref)
+{
+	struct llbitmap_barrier *barrier =
+		container_of(ref, struct llbitmap_barrier, active);
+
+	wake_up(&barrier->wait);
+}
+
 static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 {
 	int nr_pages = (llbitmap->chunks + BITMAP_SB_SIZE + PAGE_SIZE - 1) / PAGE_SIZE;
@@ -562,3 +570,41 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 
 	return state;
 }
+
+static void llbitmap_raise_barrier(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+retry:
+	if (likely(percpu_ref_tryget_live(&barrier->active))) {
+		WRITE_ONCE(barrier->expire, jiffies + BARRIER_IDLE * HZ);
+		return;
+	}
+
+	wait_event(barrier->wait, !percpu_ref_is_dying(&barrier->active));
+	goto retry;
+}
+
+static void llbitmap_release_barrier(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	percpu_ref_put(&barrier->active);
+}
+
+static void llbitmap_suspend(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	percpu_ref_kill(&barrier->active);
+	wait_event(barrier->wait, percpu_ref_is_zero(&barrier->active));
+}
+
+static void llbitmap_resume(struct llbitmap *llbitmap, int page_idx)
+{
+	struct llbitmap_barrier *barrier = &llbitmap->barrier[page_idx];
+
+	barrier->expire = LONG_MAX;
+	percpu_ref_resurrect(&barrier->active);
+	wake_up(&barrier->wait);
+}
-- 
2.39.2

