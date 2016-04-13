From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] md/raid0: check for create_strip_zones() errors
Date: Wed, 13 Apr 2016 09:46:45 +0300
Message-ID: <20160413064645.GH8092@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

My static checker complains that if create_strip_zones() fails then we
use "priv_conf" without initializing it.  Fix this by checking for
failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2ea12c6..1d80e3c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -507,6 +507,7 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	struct r0conf *priv_conf;
+	int ret;
 
 	if (mddev->degraded != 1) {
 		printk(KERN_ERR "md/raid0:%s: raid5 must be degraded! Degraded disks: %d\n",
@@ -534,13 +535,16 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 
-	create_strip_zones(mddev, &priv_conf);
+	ret = create_strip_zones(mddev, &priv_conf);
+	if (ret)
+		return ERR_PTR(ret);
 	return priv_conf;
 }
 
 static void *raid0_takeover_raid10(struct mddev *mddev)
 {
 	struct r0conf *priv_conf;
+	int ret;
 
 	/* Check layout:
 	 *  - far_copies must be 1
@@ -575,7 +579,9 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 
-	create_strip_zones(mddev, &priv_conf);
+	ret = create_strip_zones(mddev, &priv_conf);
+	if (ret)
+		return ERR_PTR(ret);
 	return priv_conf;
 }
 
@@ -583,6 +589,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 {
 	struct r0conf *priv_conf;
 	int chunksect;
+	int ret;
 
 	/* Check layout:
 	 *  - (N - 1) mirror drives must be already faulty
@@ -617,7 +624,9 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 
-	create_strip_zones(mddev, &priv_conf);
+	ret = create_strip_zones(mddev, &priv_conf);
+	if (ret)
+		return ERR_PTR(ret);
 	return priv_conf;
 }
 
