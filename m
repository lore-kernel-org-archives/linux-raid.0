From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 5 of 7] Make sure md always uses rdev_dec_pending properly
Date: Wed, 08 Sep 2004 12:48:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVG-0005dp-1l@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The ->nr_pending counted should always be decremented with
rdev_dec_pending, as this need to do things when the count hits zero.
There were a few places where it was being decremented directly.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/multipath.c |    2 +-
 ./drivers/md/raid1.c     |    4 ++--
 ./drivers/md/raid10.c    |    4 ++--
 ./drivers/md/raid5.c     |    2 +-
 ./drivers/md/raid6main.c |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-08 11:57:14.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-08 11:57:21.000000000 +1000
@@ -169,7 +169,7 @@ static void unplug_slaves(mddev_t *mddev
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, mddev);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-08 11:57:14.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-08 11:57:21.000000000 +1000
@@ -440,7 +440,7 @@ static void unplug_slaves(mddev_t *mddev
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, mddev);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1086,7 +1086,7 @@ static int sync_request(mddev_t *mddev, 
 		int rv = max_sector - sector_nr;
 		md_done_sync(mddev, rv, 1);
 		put_buf(r1_bio);
-		atomic_dec(&conf->mirrors[disk].rdev->nr_pending);
+		rdev_dec_pending(conf->mirrors[disk].rdev, mddev);
 		return rv;
 	}
 

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-09-08 11:57:14.000000000 +1000
+++ ./drivers/md/raid10.c	2004-09-08 11:57:21.000000000 +1000
@@ -594,7 +594,7 @@ static void unplug_slaves(mddev_t *mddev
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, mddev);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1493,7 +1493,7 @@ static int sync_request(mddev_t *mddev, 
 			for (i=0; i<conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
 				if (r10_bio->devs[i].bio->bi_end_io)
-					atomic_dec(&conf->mirrors[d].rdev->nr_pending);
+					rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 			}
 			put_buf(r10_bio);
 			goto giveup;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-09-08 11:57:14.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-08 11:57:21.000000000 +1000
@@ -1317,7 +1317,7 @@ static void unplug_slaves(mddev_t *mddev
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, mddev);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-09-08 11:57:14.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-08 11:57:21.000000000 +1000
@@ -1479,7 +1479,7 @@ static void unplug_slaves(mddev_t *mddev
 				r_queue->unplug_fn(r_queue);
 
 			spin_lock_irqsave(&conf->device_lock, flags);
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, mddev);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);
