From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH md] recover_bitmaps() can be static
Date: Sat, 28 Feb 2015 07:04:37 +0800
Message-ID: <20150227230437.GA47128@snb>
References: <201502280727.kOhvF4kI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502280727.kOhvF4kI%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: kbuild-all@01.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

drivers/md/md-cluster.c:190:6: sparse: symbol 'recover_bitmaps' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 md-cluster.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1f82d0d..c71217a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -187,7 +187,7 @@ out:
 	return s;
 }
 
-void recover_bitmaps(struct md_thread *thread)
+static void recover_bitmaps(struct md_thread *thread)
 {
 	struct mddev *mddev = thread->mddev;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
