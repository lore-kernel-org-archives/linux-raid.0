From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Define ->congested_fn for raid1, raid10, and multipath
Date: Tue, 29 Aug 2006 15:39:35 +1000
Message-ID: <1060829053935.6628@suse.de>
References: <20060829153414.6475.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


raid1, raid10 and multipath don't report their 'congested' status
through bdi_*_congested, but should.

This patch adds the appropriate functions which just check the
'congested' status of all active members (with appropriate locking).

raid1 read_balance should be modified to prefer devices where
bdi_read_congested returns false. Then we could use the '&' branch
rather than the '|' branch.  However that should would need 
some benchmarking first to make sure it is actually a good idea.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/multipath.c |   24 ++++++++++++++++++++++++
 ./drivers/md/raid1.c     |   28 ++++++++++++++++++++++++++++
 ./drivers/md/raid10.c    |   22 ++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2006-08-29 14:52:50.000000000 +1000
+++ ./drivers/md/multipath.c	2006-08-29 14:33:34.000000000 +1000
@@ -228,6 +228,28 @@ static int multipath_issue_flush(request
 	rcu_read_unlock();
 	return ret;
 }
+static int multipath_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	multipath_conf_t *conf = mddev_to_conf(mddev);
+	int i, ret = 0;
+
+	rcu_read_lock();
+	for (i = 0; i < mddev->raid_disks ; i++) {
+		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			request_queue_t *q = bdev_get_queue(rdev->bdev);
+
+			ret |= bdi_congested(&q->backing_dev_info, bits);
+			/* Just like multipath_map, we just check the
+			 * first available device
+			 */
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
 
 /*
  * Careful, this can execute in IRQ contexts as well!
@@ -509,6 +531,8 @@ static int multipath_run (mddev_t *mddev
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->issue_flush_fn = multipath_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	return 0;
 

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-08-29 14:52:50.000000000 +1000
+++ ./drivers/md/raid1.c	2006-08-29 14:26:59.000000000 +1000
@@ -601,6 +601,32 @@ static int raid1_issue_flush(request_que
 	return ret;
 }
 
+static int raid1_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	conf_t *conf = mddev_to_conf(mddev);
+	int i, ret = 0;
+
+	rcu_read_lock();
+	for (i = 0; i < mddev->raid_disks; i++) {
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			request_queue_t *q = bdev_get_queue(rdev->bdev);
+
+			/* Note the '|| 1' - when read_balance prefers
+			 * non-congested targets, it can be removed
+			 */
+			if ((bits & (1<<BDI_write_congested)) || 1)
+				ret |= bdi_congested(&q->backing_dev_info, bits);
+			else
+				ret &= bdi_congested(&q->backing_dev_info, bits);
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -1965,6 +1991,8 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->issue_flush_fn = raid1_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	return 0;
 

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2006-08-29 14:50:34.000000000 +1000
+++ ./drivers/md/raid10.c	2006-08-29 14:56:51.000000000 +1000
@@ -648,6 +648,26 @@ static int raid10_issue_flush(request_qu
 	return ret;
 }
 
+static int raid10_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	conf_t *conf = mddev_to_conf(mddev);
+	int i, ret = 0;
+
+	rcu_read_lock();
+	for (i = 0; i < mddev->raid_disks && ret == 0; i++) {
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			request_queue_t *q = bdev_get_queue(rdev->bdev);
+
+			ret |= bdi_congested(&q->backing_dev_info, bits);
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -2094,6 +2114,8 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->issue_flush_fn = raid10_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	/* Calculate max read-ahead size.
 	 * We need to readahead at least twice a whole stripe....
