From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [-mm PATCH 24/32] drivers/md: fix-up schedule_timeout() usage
Date: Mon, 15 Aug 2005 11:24:36 -0700
Message-ID: <20050815182436.GA2854@us.ibm.com>
References: <20050815180514.GC2854@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050815180514.GC2854@us.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: akpm@osdl.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Description: Use schedule_timeout_interruptible() instead of
set_current_state()/schedule_timeout() to reduce kernel size.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 drivers/md/raid5.c     |    3 +--
 drivers/md/raid6main.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -urpN 2.6.13-rc5-mm1/drivers/md/raid5.c 2.6.13-rc5-mm1-dev/drivers/md/raid5.c
--- 2.6.13-rc5-mm1/drivers/md/raid5.c	2005-08-07 10:05:20.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/md/raid5.c	2005-08-08 15:06:49.000000000 -0700
@@ -1522,8 +1522,7 @@ static sector_t sync_request(mddev_t *md
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access 
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);
diff -urpN 2.6.13-rc5-mm1/drivers/md/raid6main.c 2.6.13-rc5-mm1-dev/drivers/md/raid6main.c
--- 2.6.13-rc5-mm1/drivers/md/raid6main.c	2005-08-07 10:05:20.000000000 -0700
+++ 2.6.13-rc5-mm1-dev/drivers/md/raid6main.c	2005-08-08 15:06:55.000000000 -0700
@@ -1681,8 +1681,7 @@ static sector_t sync_request(mddev_t *md
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
