From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 1/1] md: fix hot add for non-persistent superblock arrays
Date: Thu, 19 May 2005 20:44:00 -0400
Message-ID: <428D32D0.1030104@steeleye.com>
References: <20050513144946.4066.patches@notabene> <E1DWS99-00014N-En@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002060703000205020508"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1DWS99-00014N-En@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030002060703000205020508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

hot add is not working for non-persistent superblock arrays (md is 
trying, and failing, to read a superblock from the new disk)...

attached patch fixes it...

Thanks,
Paul

--------------030002060703000205020508
Content-Type: text/plain;
 name="md_non_persistent_hot_add.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_non_persistent_hot_add.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.12-rc1-mm2-PRISTINE/drivers/md/md.c linux-2.6.12-rc1-mm2/drivers/md/md.c
--- linux-2.6.12-rc1-mm2-PRISTINE/drivers/md/md.c	Fri Mar 25 14:33:36 2005
+++ linux-2.6.12-rc1-mm2/drivers/md/md.c	Thu May 19 16:29:44 2005
@@ -2218,7 +2218,8 @@ static int add_new_disk(mddev_t * mddev,
 			       mdname(mddev));
 			return -EINVAL;
 		}
-		rdev = md_import_device(dev, mddev->major_version,
+		rdev = md_import_device(dev, mddev->persistent ?
+					mddev->major_version : -1,
 					mddev->minor_version);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING 

--------------030002060703000205020508--
