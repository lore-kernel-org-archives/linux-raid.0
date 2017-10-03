From: Colin King <colin.king@canonical.com>
Subject: [PATCH] md-cluster: make function cluster_check_sync_size static
Date: Tue,  3 Oct 2017 10:51:17 +0100
Message-ID: <20171003095117.25539-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

The function cluster_check_sync_size is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'cluster_check_sync_size' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 03082e17c65c..bf41492a2cb0 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1094,7 +1094,7 @@ static void metadata_update_cancel(struct mddev *mddev)
 /*
  * return 0 if all the bitmaps have the same sync_size
  */
-int cluster_check_sync_size(struct mddev *mddev)
+static int cluster_check_sync_size(struct mddev *mddev)
 {
 	int i, rv;
 	bitmap_super_t *sb;
-- 
2.14.1
