From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 5] drivers/md/raid1.c: make a function static
Date: Fri, 02 Sep 2005 16:12:53 +1000
Message-ID: <E1EB4nF-0008N5-0s@notabene.cse.unsw.edu.au>
References: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This patch makes a needlessly global function static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-09-02 15:59:28.000000000 +1000
+++ ./drivers/md/raid1.c	2005-09-02 15:59:34.000000000 +1000
@@ -1703,7 +1703,7 @@ static int raid1_reshape(mddev_t *mddev,
 	return 0;
 }
 
-void raid1_quiesce(mddev_t *mddev, int state)
+static void raid1_quiesce(mddev_t *mddev, int state)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 
