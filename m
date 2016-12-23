From: Colin King <colin.king@canonical.com>
Subject: [PATCH] md/r5cache: fix spelling mistake on "recoverying"
Date: Fri, 23 Dec 2016 00:52:30 +0000
Message-ID: <20161223005230.7731-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "recoverying" to "recovering" in
pr_dbg message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index bff1b4a..0e8ed2c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2170,7 +2170,7 @@ static int r5l_recovery_log(struct r5l_log *log)
 		pr_debug("md/raid:%s: starting from clean shutdown\n",
 			 mdname(mddev));
 	else {
-		pr_debug("md/raid:%s: recoverying %d data-only stripes and %d data-parity stripes\n",
+		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
 			 mdname(mddev), ctx.data_only_stripes,
 			 ctx.data_parity_stripes);
 
-- 
2.10.2
