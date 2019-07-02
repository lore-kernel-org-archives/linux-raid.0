From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] raid1: use an int as the return value of raise_barrier()
Date: Tue, 2 Jul 2019 22:35:48 +0800
Message-ID: <20190702143548.133020-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, songliubraving@fb.com
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Using a sector_t as the return value is misleading, because
raise_barrier() only return 0 or -EINTR.

Also add comments for the return values of raise_barrier().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index da06bb47195b..c1ea5e0c3cf6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -846,8 +846,10 @@ static void flush_pending_writes(struct r1conf *conf)
  * backgroup IO calls must call raise_barrier.  Once that returns
  *    there is no normal IO happeing.  It must arrange to call
  *    lower_barrier when the particular background IO completes.
+ *
+ * Will return -EINTR if resync/recovery is interrupted, else return 0.
  */
-static sector_t raise_barrier(struct r1conf *conf, sector_t sector_nr)
+static int raise_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	int idx = sector_to_idx(sector_nr);
 
-- 
2.22.0
