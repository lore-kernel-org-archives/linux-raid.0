From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] md-cluster: __md_error() can be static
Date: Wed, 30 Sep 2015 00:22:26 +0800
Message-ID: <20150929162226.GA35638@xian>
References: <201509300044.grgBYbQp%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443540089-5398-3-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2db697b..294f9e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7028,7 +7028,7 @@ void md_unregister_thread(struct md_thread **threadp)
 }
 EXPORT_SYMBOL(md_unregister_thread);
 
-void __md_error(struct mddev *mddev, struct md_rdev *rdev, bool writeout)
+static void __md_error(struct mddev *mddev, struct md_rdev *rdev, bool writeout)
 {
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
