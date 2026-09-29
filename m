Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F383A475349;
	Tue, 29 Sep 2026 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671193; cv=none; b=aAFB4iLOs770SYY3xbdThRppvFOOCJSM/e74cfPJFLTIAdilzGXRPfTjvRxCbBQYTjvVQC1bqnteJFbnTiiX9fTbN1swOr0dv3jVl1a5BJ/w7V0qhtDDWlyli64KwNRMVveRB2AGfQpWJplyzlbn4MVHIC6jPHKj3utDTJrzm9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671193; c=relaxed/simple;
	bh=vpl+VUHYaJNcK1QjcHHdO0TiTTQA9wqQvBnXz6YuTd0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=enPxECa623dWQapxsoiUfQAX3yT3BB1JtMM0VGyS0YvrnDFfPS+1U3SdkuxKmRWFwpa+fek1+EzymvlWWLJBk6AO8HvoKeRnMMQnjwCl05fP4+Br03i9aKWlya01Wgg5JjzdL3qg6qp7qqtE0F8GKjA34dHrUdBCrmoCNlnpKok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EK+JHp3w; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EK+JHp3w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Yj
	KmTOdxVq+cIObedi7BAumVejSPYpqJT+x3sWET98A=; b=EK+JHp3wwsfHmQAAYe
	YoeSuOo5HrDxgv09WwS9sQQr3lG6jfI4AYPyxXv3Ghhrqfav8N0OEOeul3mnYaHP
	UfuzrHhJ03Y6Jl97z1jcNWM2C5VeiGTOUfI1AkDnqG8yaw0aIqzAacn92yyXIbHI
	MYCynI81K02rmW6aa+0aD8ghU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3nzk1ebtqw+XkBQ--.34250S2;
	Tue, 29 Sep 2026 16:39:18 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com
Subject: [PATCH] md/raid5: drain released_stripes before destroying the cache
Date: Tue, 29 Sep 2026 16:39:16 +0800
Message-Id: <20260929083916.50620-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3nzk1ebtqw+XkBQ--.34250S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZrykZF13Cr15tw48Zr47urg_yoW5JryUp3
	ZYv3yYqr48Xrn3t39xZF1UWryrWayfur47J3yxKw18ZasayrWfZ3yxG3y5Jr1Dtr4SqFW2
	qF4Y93s8Gr4qgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5R6wUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3Rf0o2q7eTdYrwAA31

From: Li Youhong <liyouhong@kylinos.cn>

grow_one_stripe() calls raid5_release_stripe() for each new stripe.
When mddev->thread is already set, that queues the stripe on
conf->released_stripes and wakes the thread. Only raid5d moves that
list onto inactive_list.

Takeover calls setup_conf() while mddev->thread still belongs to the
previous personality, so those stripes stay on released_stripes. If
setup_conf() then fails, shrink_stripes() only frees inactive_list and
kmem_cache_destroy() warns that objects remain.

Move stripes still queued on released_stripes onto inactive_list
before shrink_stripes() frees them.

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Reported-by: syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-raid/6ab6b743.7eec07f4.c25c.0006.GAE@google.com/T/#t
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/raid5.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..8f375a596312 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2712,6 +2712,37 @@ static int drop_one_stripe(struct r5conf *conf)
 
 static void shrink_stripes(struct r5conf *conf)
 {
+	struct list_head temp[NR_STRIPE_HASH_LOCKS];
+	int i;
+
+	/*
+	 * grow_one_stripe() parks new stripes on released_stripes when
+	 * mddev->thread is already set. Takeover leaves the previous
+	 * personality's thread there, so raid5d never moves them to
+	 * inactive_list. Drain them before the cache is destroyed.
+	 * slab_cache is assigned only after device_lock and the hash
+	 * lists exist; earlier abort paths have nothing to drain.
+	 */
+	if (conf->slab_cache) {
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			INIT_LIST_HEAD(&temp[i]);
+
+		spin_lock_irq(&conf->device_lock);
+		release_stripe_list(conf, temp);
+		spin_unlock_irq(&conf->device_lock);
+
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++) {
+			if (list_empty(&temp[i]))
+				continue;
+			spin_lock_irq(conf->hash_locks + i);
+			if (list_empty(conf->inactive_list + i))
+				atomic_dec(&conf->empty_inactive_list_nr);
+			list_splice_tail_init(&temp[i],
+					      conf->inactive_list + i);
+			spin_unlock_irq(conf->hash_locks + i);
+		}
+	}
+
 	while (conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
 		;
-- 
2.43.0

