From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 7] Rationalise unplug functions in md
Date: Wed, 08 Sep 2004 12:48:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVF-0005dl-VO@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There are currently subtle differences in the different personalities
concerning when subdevices are unplugged (faulty? nr_pending?).
This patch makes them sll uniform.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/multipath.c |    2 +-
 ./drivers/md/raid1.c     |    2 +-
 ./drivers/md/raid10.c    |    2 +-
 ./drivers/md/raid5.c     |    4 ++--
 ./drivers/md/raid6main.c |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-08 11:56:55.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-08 11:57:14.000000000 +1000
@@ -159,7 +159,7 @@ static void unplug_slaves(mddev_t *mddev
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
-		if (rdev && !rdev->faulty) {
+		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-08 11:57:08.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-08 11:57:14.000000000 +1000
@@ -430,7 +430,7 @@ static void unplug_slaves(mddev_t *mddev
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
-		if (rdev && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-09-08 11:56:55.000000000 +1000
+++ ./drivers/md/raid10.c	2004-09-08 11:57:14.000000000 +1000
@@ -584,7 +584,7 @@ static void unplug_slaves(mddev_t *mddev
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
-		if (rdev && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-09-08 11:56:55.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-08 11:57:14.000000000 +1000
@@ -1307,13 +1307,13 @@ static void unplug_slaves(mddev_t *mddev
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
-		if (rdev && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 
-			if (r_queue && r_queue->unplug_fn)
+			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-09-08 11:56:55.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-08 11:57:14.000000000 +1000
@@ -1469,13 +1469,13 @@ static void unplug_slaves(mddev_t *mddev
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
-		if (rdev && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 
-			if (r_queue && r_queue->unplug_fn)
+			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
