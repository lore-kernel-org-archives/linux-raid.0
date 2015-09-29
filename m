From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] md-cluster: does_sb_need_changing() can be static
Date: Wed, 30 Sep 2015 00:30:45 +0800
Message-ID: <20150929163044.GA12725@xian>
References: <201509300042.jyUpX6z2%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443540089-5398-4-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 09d1384..ae90e3c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2196,7 +2196,7 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 	}
 }
 
-bool does_sb_need_changing(struct mddev *mddev)
+static bool does_sb_need_changing(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	struct mdp_superblock_1 *sb;
