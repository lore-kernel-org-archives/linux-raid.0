From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 006 of 8] Allow hot-adding devices to arrays with non-persistant superblocks.
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001IO-Q1@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It is possibly (and occasionally useful) to have a raid1 without
persistent superblocks.  The code in add_new_disk for adding a 
device to such an array always tries to read a superblock.  
This will obviously fail.
So do the appropriate test and call md_import_device with
appropriate args.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-22 11:48:37.000000000 +1000
+++ ./drivers/md/md.c	2005-08-22 11:49:47.000000000 +1000
@@ -2225,8 +2225,11 @@ static int add_new_disk(mddev_t * mddev,
 			       mdname(mddev));
 			return -EINVAL;
 		}
-		rdev = md_import_device(dev, mddev->major_version,
-					mddev->minor_version);
+		if (mddev->persistent)
+			rdev = md_import_device(dev, mddev->major_version,
+						mddev->minor_version);
+		else
+			rdev = md_import_device(dev, -1, -1);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING 
 				"md: md_import_device returned %ld\n",
