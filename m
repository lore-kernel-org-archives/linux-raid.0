From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/2] md: fix test in md_write_start()
Date: Tue, 08 Aug 2017 16:56:36 +1000
Message-ID: <150217539692.23065.18394409211906101884.stgit@noble>
References: <150217527795.23065.7747775748038187816.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150217527795.23065.7747775748038187816.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md_write_start() needs to clear the in_sync flag is it is set, or if
there might be a race with set_in_sync() such that the later will
set it very soon.  In the later case it is sufficient to take the
spinlock to synchronize with set_in_sync(), and then set the flag
if needed.

The current test is incorrect.
It should be:
  if "flag is set" or "race is possible"

"flag is set" is trivially "mddev->in_sync".
"race is possible" should be tested by "mddev->sync_checkers".

If sync_checkers is 0, then there can be no race.  set_in_sync() will
wait in percpu_ref_switch_to_atomic_sync() for an RCU grace period,
and as md_write_start() holds the rcu_read_lock(), set_in_sync() will
be sure ot see the update to writes_pending.

If sync_checkers is > 0, there could be race.  If md_write_start()
happened entirely between
		if (!mddev->in_sync &&
		    percpu_ref_is_zero(&mddev->writes_pending)) {
and
			mddev->in_sync = 1;
in set_in_sync(), then it would not see that is_sync had been set,
and set_in_sync() would not see that writes_pending had been
incremented.

This bug means that in_sync is sometimes not set when it should be.
Consequently there is a small chance that the array will be marked as
"clean" when in fact it is inconsistent.

Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
cc: stable@vger.kernel.org (v4.12+)
Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d84aceede1cb..e4ba95f6cd59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7996,7 +7996,7 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
 	/* sync_checkers is always 0 when writes_pending is in per-cpu mode */
-	if (mddev->in_sync || !mddev->sync_checkers) {
+	if (mddev->in_sync || mddev->sync_checkers) {
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;


