From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Fix user-after-free bug in multipath
Date: Tue, 18 May 2004 11:15:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BPtC8-0002PS-WE@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If mddev->thread is non-null later, it gets used.

 ----------- Diffstat output ------------
 ./drivers/md/multipath.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-05-18 11:09:16.000000000 +1000
+++ ./drivers/md/multipath.c	2004-05-18 11:12:01.000000000 +1000
@@ -531,6 +531,7 @@ static int multipath_stop (mddev_t *mdde
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 
 	md_unregister_thread(mddev->thread);
+	mddev->thread = NULL;
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
