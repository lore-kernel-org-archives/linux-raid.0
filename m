From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: patch for raid1 to make it choose the fastest device for READ (resend)
Date: Mon, 23 Aug 2004 23:29:39 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408232129.i7NLTde31865@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Aug 13, 2004 10:21:29 am"
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach ptb:"
> Here is a preliminary patch for raid1 (2.4) to make it choose the
> fastest device in the array to read from.

And here is another version in which the periodic retesting for the
latencies is limited to the devices that were not being read from until
now. That might be a little "tidier". It's a minor mod to the original
code.


  mdadm: /dev/md/0 has been started with 2 drives.
  sh-2.03# dd if=/dev/md/0 of=/dev/null
  raid1: disk 0 latency 0 abandoned after 1024 sectors
  raid1: choosing disk 1 latency 0                       <- test
  raid1: disk 1 latency 0 abandoned after 32 sectors      _|
  raid1: choosing disk 1 latency 0                       <- run
  raid1: disk 1 latency 0 abandoned after 1024 sectors    _|
  raid1: choosing disk 0 latency 0
  raid1: disk 0 latency 0 abandoned after 32 sectors
  raid1: choosing disk 1 latency 0
  raid1: disk 1 latency 0 abandoned after 1024 sectors
  raid1: choosing disk 0 latency 0
  raid1: disk 0 latency 0 abandoned after 32 sectors
  raid1: choosing disk 1 latency 0
  raid1: disk 1 latency 0 abandoned after 1024 sectors
  raid1: choosing disk 0 latency 0
  raid1: disk 0 latency 0 abandoned after 32 sectors
  raid1: choosing disk 1 latency 0
  raid1: disk 1 latency 2 abandoned after 1024 sectors
  raid1: choosing disk 0 latency 0
  ...
  
  (running on loopback devices)
  
If I were asked to improve this further, I would choose to retest only
after a disk has been (re)added to the array.  Possibly I might also
want to retest after a period inversely proportional to the observed
variance during normal running.

I might also wish to put the calculated latencies per disk in the
existing per-mirror structures somewhere, instead of in a separate
array.


--- linux-2.4.25/drivers/md/raid1.c.post-fr1-2.14b,pre-read-balance	Tue Aug 10 21:36:51 2004
+++ linux-2.4.25/drivers/md/raid1.c	Mon Aug  9 19:27:32 2004
@@ -46,7 +46,10 @@
 #define MD_DRIVER
 #define MD_PERSONALITY
 
-#define MAX_WORK_PER_DISK 128
+#define MAX_WORK_PER_DISK (128 * 8)
+#define MAX_TEST_PER_DISK 32
+#define LATENCY_OLD_WEIGHT 9
+#define LATENCY_NEW_WEIGHT 1
 
 #define	NR_RESERVED_BUFS	32
 
@@ -434,6 +434,32 @@
                         bitmap->clearbits(bitmap, bh->b_rsector >> 1, bh->b_size >> 10);
                 }
         }
+        /* PTB calculate the latency of the read device and update the record */
+        if (uptodate && (r1_bh->cmd == READ || r1_bh->cmd == READA)) {
+                unsigned long latency = jiffies - r1_bh->start_jiffies;
+                kdev_t dev = (&r1_bh->bh_req)->b_dev;
+                int i;
+
+                /* PTB find the mirror component being read */
+                for (i = 0; i < conf->raid_disks; i++) {
+                    if (conf->mirrors[i].dev == dev)
+                        break;
+                }
+                if (i < conf->raid_disks) {
+                        if (latency < 120 * HZ && latency >= 0) {
+                                conf->latency[i] = LATENCY_OLD_WEIGHT * conf->latency[i]
+                                                 + LATENCY_NEW_WEIGHT * latency;
+                                conf->latency[i] /= LATENCY_OLD_WEIGHT
+						   + LATENCY_NEW_WEIGHT;
+                        } else {
+		               printk(KERN_ERR "raid1: bad latency %lu jiffies\n", 
+			         latency);
+                        }
+                } else {
+		       printk(KERN_ERR "raid1: could not find dev %02x:%02x\n", 
+                               MAJOR(dev), MINOR(dev));
+                }
+        }
         raid1_free_r1bh(r1_bh);
 }
 
@@ -569,7 +594,8 @@
 	 * Don't touch anything for sequential reads.
 	 */
 
-	if (this_sector == conf->mirrors[new_disk].head_position)
+	if (0 && /* PTB disable linear read preference for same device */
+	   this_sector == conf->mirrors[new_disk].head_position)
 		goto rb_out;
 	
 	/*
@@ -578,22 +603,66 @@
 	 * This is for kicking those idling disks so that
 	 * they would find work near some hotspot.
 	 */
 	
 	if (conf->sect_count >= conf->mirrors[new_disk].sect_limit) {
+
+		PRINTK(KERN_INFO
+		  "raid1: disk %d latency %d abandoned after %d sectors\n",
+		  new_disk,
+		  conf->latency[new_disk],
+		  conf->sect_count);
 		conf->sect_count = 0;
+
+		if (conf->last_fastest < 0) {
+                    /* PTB find the fastest already known and use that */
+
+			int fastest = -1;
+			unsigned long best_latency = 0x7fffffff;
+			int i;
+
+			for (i = 0; i < conf->raid_disks; i++) {
+	                        if (conf->mirrors[i].write_only
+                                || !conf->mirrors[i].operational)
+                                        continue;
+                                if (conf->latency[i] <= best_latency) {
+                                    best_latency = conf->latency[i];
+                                    fastest = i;
+                                }
+			}
+                        if (fastest >= 0)
+                                new_disk = fastest;
+	                conf->mirrors[new_disk].sect_limit =
+                                                MAX_WORK_PER_DISK;
+                        conf->last_fastest = new_disk;
+                } else {
+                    /* PTB move on to run a short test on the next disk */
 
 #if defined(CONFIG_SPARC64) && (__GNUC__ == 2) && (__GNUC_MINOR__ == 92)
 		/* Work around a compiler bug in egcs-2.92.11 19980921 */
 		new_disk = *(volatile int *)&new_disk;
 #endif
-		do {
-			if (new_disk<=0)
-				new_disk = conf->raid_disks;
-			new_disk--;
-			if (new_disk == disk)
-				break;
-		} while ((conf->mirrors[new_disk].write_only) ||
-			 (!conf->mirrors[new_disk].operational));
+		        do {
+			        if (new_disk<=0)
+				        new_disk = conf->raid_disks;
+			        new_disk--;
+			        if (new_disk == disk)
+				        break; /* nothing else available */
+		        } while ((conf->mirrors[new_disk].write_only) ||
+			         (!conf->mirrors[new_disk].operational));
+                      /* PTB if tested all, will need to choose next time */
+                        if (new_disk == conf->last_fastest) {
+                                conf->last_fastest = -1;
+                                /* PTB don't retest last source at all */
+	                        //conf->mirrors[new_disk].sect_limit = 0;
+                        }
+                        /* PTB only a short test run */
+	                conf->mirrors[new_disk].sect_limit = MAX_TEST_PER_DISK;
+                }
+
+                PRINTK(KERN_INFO
+                  "raid1: choosing disk %d latency %d\n",
+                  new_disk,
+                  conf->latency[new_disk]);
 
 		goto rb_out;
 	}
@@ -680,6 +749,7 @@
 	r1_bh->master_bh = bh;
 	r1_bh->mddev = mddev;
 	r1_bh->cmd = rw;
+	r1_bh->start_jiffies = jiffies; /* PTB record start time */
         async_data = NULL;
 
 	if (rw == READ) {
--- linux-2.4.25/include/linux/raid/raid1.h.post-fr1-2.14b,pre-read-balance	Tue Aug 10 21:48:31 2004
+++ linux-2.4.25/include/linux/raid/raid1.h	Mon Aug  9 18:53:57 2004
@@ -59,6+59,10 @@
 	md_wait_queue_head_t	wait_done;
 	md_wait_queue_head_t	wait_ready;
 	md_spinlock_t		segment_lock;
+
+	int			latency[MD_SB_DISKS];
+	int			last_fastest;        /* PTB disk read from */
+
 };
 
 typedef struct raid1_private_data raid1_conf_t;
@@ -92,6 +96,7 @@
 	struct buffer_head	*mirror_bh_list;
 	struct buffer_head	bh_req;
 	struct raid1_bh		*next_r1;	/* next for retry or in free list */
+	unsigned long		start_jiffies;  /* PTB when i/o started */
 };
 /* bits for raid1_bh.state */
 #define	R1BH_Uptodate	1


Peter
