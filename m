From: bingjingc <bingjingc@synology.com>
Subject: [PATCH] md/md: replace confusing resync progress 99.9% with new
 wording
Date: Wed, 27 Dec 2017 13:50:42 +0800
Message-ID: <e70cb5ce6103a49b765fb1f93a197342@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids


When any sync action is finishing or interrupted, the progress will
show 99.9% before the sync thread is reaped. Many reporters has asked
what happened to the last blocks. It might be a confusing meaning for
users because the progress will be backward after the interrupted task
is restarted.

Take a raid5 reshape for example:
mdadm -C --assume-clean /dev/md0 -l5 -n3 /dev/loop[012]
echo 2000 > /proc/sys/dev/raid/speed_limit_max
echo 1000 > /proc/sys/dev/raid/speed_limit_min # slow down the speed
mdadm /dev/md0 -a /dev/loop3
mdadm /dev/md0 --grow -n4
while true
do
	mdadm -S /dev/md0
	sleep 3
	mdadm -A /dev/md0 /dev/loop[0123]
done

And you can see the fake 99.9% progress by the following command:
> while true; do cat /proc/mdstat | grep reshape; done

This confusing state can be fixed by exposing the real state to users.
And I also correct the sync action type for display.

Reported-by: Edwin Lin <edwinlin@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
---
  drivers/md/md.c | 25 +++++++++++++++----------
  1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e4dee0..74106c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7593,6 +7593,14 @@ static int status_resync(struct seq_file *seq, 
struct mddev *mddev)
  	sector_t rt;
  	int scale;
  	unsigned int per_milli;
+	char *sync_action;
+
+	sync_action = (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
+		"reshape" :
+		(test_bit(MD_RECOVERY_CHECK, &mddev->recovery) ?
+		"check" :
+		(test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
+		"resync" : "recovery")));

  	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
  	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
@@ -7602,9 +7610,11 @@ static int status_resync(struct seq_file *seq, 
struct mddev *mddev)

  	resync = mddev->curr_resync;
  	if (resync <= 3) {
-		if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
  			/* Still cleaning up */
-			resync = max_sectors;
+			seq_printf(seq, "\t%s=CLEANING UP", sync_action);
+			return 1;
+		}
  	} else if (resync > max_sectors)
  		resync = max_sectors;
  	else
@@ -7612,13 +7622,13 @@ static int status_resync(struct seq_file *seq, 
struct mddev *mddev)

  	if (resync == 0) {
  		if (mddev->recovery_cp < MaxSector) {
-			seq_printf(seq, "\tresync=PENDING");
+			seq_printf(seq, "\t%s=PENDING", sync_action);
  			return 1;
  		}
  		return 0;
  	}
  	if (resync < 3) {
-		seq_printf(seq, "\tresync=DELAYED");
+		seq_printf(seq, "\t%s=DELAYED", sync_action);
  		return 1;
  	}

@@ -7648,12 +7658,7 @@ static int status_resync(struct seq_file *seq, 
struct mddev *mddev)
  		seq_printf(seq, "] ");
  	}
  	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
-		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
-		    "reshape" :
-		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
-		     "check" :
-		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
-		      "resync" : "recovery"))),
+		   sync_action,
  		   per_milli/10, per_milli % 10,
  		   (unsigned long long) resync/2,
  		   (unsigned long long) max_sectors/2);
-- 
2.7.4

