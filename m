Received: from msa.smtpout.orange.fr (msa-217.smtpout.orange.fr [193.252.23.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF5C2942A;
	Sun, 23 Jun 2024 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.23.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719173887; cv=none; b=tn4wedXl3H1Zxk537XqiLUaLFSoc07H9KsS/W2u5JGL6rqg/wP9VPBDt1ehsFXXUCyj2+ILw7AJcX8BsI5u8n2tOaTaxJYUz524hhx7AyRt583Bp/pbX8FIAh0SnvD/cSTCTew70e42zPH57Tun8LYGn5VSAgu7YJAz+2z+8p/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719173887; c=relaxed/simple;
	bh=koTW1bjA1a9oAxMZpxUhrR3inpN0GPQlJzFSBe7Xi0w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F12ii5h/kJimL3WmB71Tck69pcyEMtVXdFW7bTqAJIaoqrteNqOq3uUyJfRk+4l/90nVFRS2JrkuHGtSa01LHJzohUN/Gaio/gd3txRzkot4JbJ0L1Zdu6zkQsZhleRvQu+TBmG3H6+2OFl7HtGgAg3KbZ/hHLl8FnGB9eXc6Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=R1nSITcS; arc=none smtp.client-ip=193.252.23.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="R1nSITcS"
Received: from fedora.home ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id LTewsvUU7pvrRLTewsHEGZ; Sun, 23 Jun 2024 22:18:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1719173882;
	bh=vjKEKLJ4aTNVXrDQtXkP8NbnrYFTSZ12qcOr1kgquxA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=R1nSITcSwGpOJgtYU32P2hM5+8aV+JwIBCxmZkdhCwCK7CcguvpEZc/jS8K1MqOzq
	 fhY17kvECGOPwInMkbLceSBrMcVsFQRos/SQOz92QMko63KQMgQjNdsg1P93lj+mWk
	 ZVK2KU7Zo2Su/Lj3Vk4j5xOZcQW4lEWdKDOaBGz4+kpdgiT8aHYjc+DhsSuTkhGzXC
	 B8cbNJx0Knh4d0HHVkT4Aie8HKC0KGOjPOVZOnzTyHy2OwShXjLOz0gWayjltEgB9v
	 wOMRyR6CuRjHRgrPzC60GmwffMikN0k9oP2XoUjHNs37W1BMIaoy8g1Dwkdptqgf4P
	 CT8XJlo+Pw/Hw==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Jun 2024 22:18:02 +0200
X-ME-IP: 86.243.222.230
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-raid@vger.kernel.org
Subject: [PATCH] md-cluster: Constify struct md_cluster_operations
Date: Sun, 23 Jun 2024 22:17:54 +0200
Message-ID: <3727f3ce9693cae4e62ae6778ea13971df805479.1719173852.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct md_cluster_operations' is not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  51941	   1442	     80	  53463	   d0d7	drivers/md/md-cluster.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  52133	   1246	     80	  53459	   d0d3	drivers/md/md-cluster.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only
---
 drivers/md/md-cluster.c | 2 +-
 drivers/md/md.c         | 4 ++--
 drivers/md/md.h         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index eb9bbf12c8d8..c1ea214bfc91 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1570,7 +1570,7 @@ static int gather_bitmaps(struct md_rdev *rdev)
 	return err;
 }
 
-static struct md_cluster_operations cluster_ops = {
+static const struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69ea54aedd99..8221c9b641ab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -85,7 +85,7 @@ static DEFINE_SPINLOCK(pers_lock);
 
 static const struct kobj_type md_ktype;
 
-struct md_cluster_operations *md_cluster_ops;
+const struct md_cluster_operations *md_cluster_ops;
 EXPORT_SYMBOL(md_cluster_ops);
 static struct module *md_cluster_mod;
 
@@ -8539,7 +8539,7 @@ int unregister_md_personality(struct md_personality *p)
 }
 EXPORT_SYMBOL(unregister_md_personality);
 
-int register_md_cluster_operations(struct md_cluster_operations *ops,
+int register_md_cluster_operations(const struct md_cluster_operations *ops,
 				   struct module *module)
 {
 	int ret = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c4d7ebf9587d..e394e5bd39fc 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -849,7 +849,7 @@ static inline void safe_put_page(struct page *p)
 
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
-extern int register_md_cluster_operations(struct md_cluster_operations *ops,
+extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
 		struct module *module);
 extern int unregister_md_cluster_operations(void);
 extern int md_setup_cluster(struct mddev *mddev, int nodes);
@@ -931,7 +931,7 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 	}
 }
 
-extern struct md_cluster_operations *md_cluster_ops;
+extern const struct md_cluster_operations *md_cluster_ops;
 static inline int mddev_is_clustered(struct mddev *mddev)
 {
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
-- 
2.45.2

