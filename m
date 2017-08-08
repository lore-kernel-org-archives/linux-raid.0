From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/2] md: always clear ->safemode when md_check_recovery
 gets the mddev lock.
Date: Tue, 08 Aug 2017 16:56:36 +1000
Message-ID: <150217539687.23065.4449077069418495000.stgit@noble>
References: <150217527795.23065.7747775748038187816.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150217527795.23065.7747775748038187816.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, David R <david@unsolicited.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If ->safemode == 1, md_check_recovery() will try to get the mddev lock
and perform various other checks.
If mddev->in_sync is zero, it will call set_in_sync, and clear
->safemode.  However if mddev->in_sync is not zero, ->safemode will not
be cleared.

When md_check_recovery() drops the mddev lock, the thread is woken
up again.  Normally it would just check if there was anything else to
do, find nothing, and go to sleep.  However as ->safemode was not
cleared, it will take the mddev lock again, then wake itself up
when unlocking.

This results in an infinite loop, repeatedly calling
md_check_recovery(), which RCU or the soft-lockup detector
will eventually complain about.

Prior to commit 4ad23a976413 ("MD: use per-cpu counter for
writes_pending"), safemode would only be set to one when the
writes_pending counter reached zero, and would be cleared again
when writes_pending is incremented.  Since that patch, safemode
is set more freely, but is not reliably cleared.

So in md_check_recovery() clear ->safemode before checking ->in_sync.

Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
Cc: stable@vger.kernel.org (4.12+)
Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reported-by: David R <david@unsolicited.net>
Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c99634612fc4..d84aceede1cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8656,6 +8656,9 @@ void md_check_recovery(struct mddev *mddev)
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
 
+		if (mddev->safemode == 1)
+			mddev->safemode = 0;
+
 		if (mddev->ro) {
 			struct md_rdev *rdev;
 			if (!mddev->external && mddev->in_sync)


