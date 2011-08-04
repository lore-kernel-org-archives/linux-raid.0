From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md/raid5: STRIPE_ACTIVE has lock semantics, add barriers
Date: Wed, 03 Aug 2011 17:31:23 -0700
Message-ID: <20110804003016.30281.26038.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All updates that occur under STRIPE_ACTIVE should be globally visible
when STRIPE_ACTIVE clears.  test_and_set_bit() implies a barrier, but
clear_bit() does not.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

This at least was the guarantee we had with sh->lock...

 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dbae459..bd95123 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3116,7 +3116,7 @@ static void handle_stripe(struct stripe_head *sh)
 	struct r5dev *pdev, *qdev;
 
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
+	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
 		/* already being handled, ensure it gets handled
 		 * again when current action finishes */
 		set_bit(STRIPE_HANDLE, &sh->state);
@@ -3377,7 +3377,7 @@ finish:
 
 	return_io(s.return_bi);
 
-	clear_bit(STRIPE_ACTIVE, &sh->state);
+	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
 
 static void raid5_activate_delayed(raid5_conf_t *conf)

