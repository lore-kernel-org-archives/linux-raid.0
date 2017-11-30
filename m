From: Nate Dailey <nate.dailey@stratus.com>
Subject: [PATCH] md: limit mdstat resync progress to max_sectors
Date: Thu, 30 Nov 2017 11:33:30 -0500
Message-ID: <20171130163330.26309-1-nate.dailey@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

There is a small window near the end of md_do_sync where mddev->curr_resync
can be equal to MaxSector.

If status_resync is called during this window, the resulting /proc/mdstat
output contains a HUGE number of = signs due to the very large curr_resync:

Personalities : [raid1]
md123 : active raid1 sdd3[2] sdb3[0]
  204736 blocks super 1.0 [2/1] [U_]
  [=====================================================================
   ... (82 MB more) ...
   ================>]  recovery =429496729.3% (9223372036854775807/204736)
   finish=0.2min speed=12796K/sec
  bitmap: 0/1 pages [0KB], 65536KB chunk

Modify status_resync to ensure the resync variable doesn't exceed
the array's max_sectors.

Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c050b59ec4..4e4dee0ec2de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7605,7 +7605,9 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 		if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 			/* Still cleaning up */
 			resync = max_sectors;
-	} else
+	} else if (resync > max_sectors)
+		resync = max_sectors;
+	else
 		resync -= atomic_read(&mddev->recovery_active);
 
 	if (resync == 0) {
-- 
2.14.1

