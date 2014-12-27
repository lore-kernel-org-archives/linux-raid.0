From: =?UTF-8?B?6JGj5p2o?= <donglife1208@gmail.com>
Subject: [PATCH][MD] raid : fix raid recoverying all data corruption, when
 j=0(sectors) interrupted by "echo idle > /sys/block/md0/md/sync_action"
Date: Sat, 27 Dec 2014 16:20:29 +0800
Message-ID: <CAEqx_ugz0a0+E1PqmLDS=gJPyDOcg0J1hptnxQGwFF0ua9+O-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Neil

I find a problem unintentionally: Raid5 is recovering, interrupted by
"echo idle  > /sys/block/md0/md/sync_action", at this point,
j=0(sector), after a while,  recovery thread is wake up, now j = 3
because when j=0, mddev->curr_resync = 3 by kernel code, so recovery
thread will start on the basic of j=3, which will lead all data
corruption. To avoid the problem,can we amend variable j by 8 sectors
alignment? as shown below:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 709755f..fe4a5f9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7400,7 +7400,7 @@ void md_do_sync(struct md_thread *thread)
        if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
            break;

-       sectors = mddev->pers->sync_request(mddev, j, &skipped,
+       sectors = mddev->pers->sync_request(mddev, (j &
~((sector_t)STRIPE_SECTORS-1)), &skipped,
                          currspeed < speed_min(mddev));
        if (sectors == 0) {
            set_bit(MD_RECOVERY_INTR, &mddev->recovery);
