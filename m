From: Coly Li <colyli@suse.de>
Subject: [PATCH v2] RAID1: Avoid unnecessary loop to decrease conf->nr_queued in raid1d()
Date: Wed, 16 Nov 2016 22:19:28 +0800
Message-ID: <1479305968-18473-1-git-send-email-colyli@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

commit ccfc7bf1f0 points out bios from conf->bio_end_io_list also
contribute to conf->nr_queued counter, that's right. But the fix
could be improved. The original fix replaces list_add() by a while()
loop to iterate every bio on conf->bio_end_io_list, and decrease
conf->nr_queued. If we look at the code several lines after, we may
find there is another while() loop to iterate every node from tmp
list which contains the original content of conf->bio_end_io_list.
Yes, we can decrease conf->nr_queued here, then we can avoid the
previous extra while() loop, which consumes more CPU cycles and hold
a spin lock longer time when conf->bio_end_io_list is not tiny. 

This patch changes to decrease conf->nr_queued in loop of
while(!list_empty(&tmp)){}, it avoids an extra loop execution, and
avoids holding conf->device_lock for too long time.

By suggestion from Neil, in this version of the patch, I use
list_splice_init() interface to operate conf->bio_end_io_list. 

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Shaohua Li <shli@fb.com>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/raid1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-raid1/drivers/md/raid1.c
===================================================================
--- linux-raid1.orig/drivers/md/raid1.c
+++ linux-raid1/drivers/md/raid1.c
@@ -2387,17 +2387,17 @@ static void raid1d(struct md_thread *thr
 	    !test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
 		LIST_HEAD(tmp);
 		spin_lock_irqsave(&conf->device_lock, flags);
-		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
-			while (!list_empty(&conf->bio_end_io_list)) {
-				list_move(conf->bio_end_io_list.prev, &tmp);
-				conf->nr_queued--;
-			}
-		}
+		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags))
+			list_splice_init(&conf->bio_end_io_list, &tmp);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+	
 		while (!list_empty(&tmp)) {
 			r1_bio = list_first_entry(&tmp, struct r1bio,
 						  retry_list);
 			list_del(&r1_bio->retry_list);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			conf->nr_queued--;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
 			if (mddev->degraded)
 				set_bit(R1BIO_Degraded, &r1_bio->state);
 			if (test_bit(R1BIO_WriteError, &r1_bio->state))
