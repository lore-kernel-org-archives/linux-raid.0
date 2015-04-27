From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 3/3 v2] md/raid5: per hash value and exclusive wait_for_stripe
Date: Mon, 27 Apr 2015 12:51:03 +0800
Message-ID: <1430110263-23977-3-git-send-email-yuanhan.liu@linux.intel.com>
References: <1430110263-23977-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430110263-23977-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

I noticed heavy spin lock contention at get_active_stripe() with fsmark
multiple thread write workloads.

Here is how this hot contention comes from. We have limited stripes, an=
d
it's a multiple thread write workload. Hence, those stripes will be tak=
en
soon, which puts later processes to sleep for waiting free stripes. Whe=
n
enough stripes(>=3D 1/4 total stripes) are released, all process are wo=
ken,
trying to get the lock. But there is one only being able to get this lo=
ck
for each hash lock, making other processes spinning out there for acqui=
ring
the lock.

Thus, it's effectiveless to wakeup all processes and let them battle fo=
r
a lock that permits one to access only each time. Instead, we could mak=
e
it be a exclusive wake up: wake up one process only. That avoids the he=
avy
spin lock contention naturally.

To do the exclusive wake up, we've to split wait_for_stripe into multip=
le
wait queues, to make it per hash value, just like the hash lock.

Here are some test results I have got with this patch applied(all test =
run
3 times):

`fsmark.files_per_sec'
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

next-20150317                 this patch
-------------------------     -------------------------
metric_value     =C2=B1stddev      metric_value     =C2=B1stddev     ch=
ange      testbox/benchmark/testcase-params
-------------------------     -------------------------   --------     =
------------------------------
      25.600     =C2=B10.0              92.700     =C2=B12.5          2=
62.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-btrfs-4M-30G-fsyncBeforeCl=
ose
      25.600     =C2=B10.0              77.800     =C2=B10.6          2=
03.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-btrfs-4M-30G-fsyncBeforeClo=
se
      32.000     =C2=B10.0              93.800     =C2=B11.7          1=
93.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-ext4-4M-30G-fsyncBeforeClo=
se
      32.000     =C2=B10.0              81.233     =C2=B11.7          1=
53.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-ext4-4M-30G-fsyncBeforeClos=
e
      48.800     =C2=B114.5             99.667     =C2=B12.0          1=
04.2%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-xfs-4M-30G-fsyncBeforeClos=
e
       6.400     =C2=B10.0              12.800     =C2=B10.0          1=
00.0%     ivb44/fsmark/1x-64t-3HDD-RAID5-btrfs-4M-40G-fsyncBeforeClose
      63.133     =C2=B18.2              82.800     =C2=B10.7           =
31.2%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-xfs-4M-30G-fsyncBeforeClose
     245.067     =C2=B10.7             306.567     =C2=B17.9           =
25.1%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-f2fs-4M-30G-fsyncBeforeClo=
se
      17.533     =C2=B10.3              21.000     =C2=B10.8           =
19.8%     ivb44/fsmark/1x-1t-3HDD-RAID5-xfs-4M-40G-fsyncBeforeClose
     188.167     =C2=B11.9             215.033     =C2=B13.1           =
14.3%     ivb44/fsmark/1x-1t-4BRD_12G-RAID5-btrfs-4M-30G-NoSync
     254.500     =C2=B11.8             290.733     =C2=B12.4           =
14.2%     ivb44/fsmark/1x-1t-9BRD_6G-RAID5-btrfs-4M-30G-NoSync

`time.system_time'
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

next-20150317                 this patch
-------------------------    -------------------------
metric_value     =C2=B1stddev     metric_value     =C2=B1stddev     cha=
nge       testbox/benchmark/testcase-params
-------------------------    -------------------------    --------     =
------------------------------
    7235.603     =C2=B11.2             185.163     =C2=B11.9          -=
97.4%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-btrfs-4M-30G-fsyncBeforeCl=
ose
    7666.883     =C2=B12.9             202.750     =C2=B11.0          -=
97.4%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-btrfs-4M-30G-fsyncBeforeClo=
se
   14567.893     =C2=B10.7             421.230     =C2=B10.4          -=
97.1%     ivb44/fsmark/1x-64t-3HDD-RAID5-btrfs-4M-40G-fsyncBeforeClose
    3697.667     =C2=B114.0            148.190     =C2=B11.7          -=
96.0%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-xfs-4M-30G-fsyncBeforeClos=
e
    5572.867     =C2=B13.8             310.717     =C2=B11.4          -=
94.4%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-ext4-4M-30G-fsyncBeforeClos=
e
    5565.050     =C2=B10.5             313.277     =C2=B11.5          -=
94.4%     ivb44/fsmark/1x-64t-4BRD_12G-RAID5-ext4-4M-30G-fsyncBeforeClo=
se
    2420.707     =C2=B117.1            171.043     =C2=B12.7          -=
92.9%     ivb44/fsmark/1x-64t-9BRD_6G-RAID5-xfs-4M-30G-fsyncBeforeClose
    3743.300     =C2=B14.6             379.827     =C2=B13.5          -=
89.9%     ivb44/fsmark/1x-64t-3HDD-RAID5-ext4-4M-40G-fsyncBeforeClose
    3308.687     =C2=B16.3             363.050     =C2=B12.0          -=
89.0%     ivb44/fsmark/1x-64t-3HDD-RAID5-xfs-4M-40G-fsyncBeforeClose

Where,

     1x: where 'x' means iterations or loop, corresponding to the 'L' o=
ption of fsmark

     1t, 64t: where 't' means thread

     4M: means the single file size, corresponding to the '-s' option o=
f fsmark
     40G, 30G, 120G: means the total test size

     4BRD_12G: BRD is the ramdisk, where '4' means 4 ramdisk, and where=
 '12G' means
               the size of one ramdisk. So, it would be 48G in total. A=
nd we made a
               raid on those ramdisk

As you can see, though there are no much performance gain for hard disk
workload, the system time is dropped heavily, up to 97%. And as expecte=
d,
the performance increased a lot, up to 260%, for fast device(ram disk).

v2: use bits instead of array to note down wait queue need to wake up.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 27 +++++++++++++++++++--------
 drivers/md/raid5.h |  2 +-
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 64d5bea..1b11bbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -344,7 +344,8 @@ static void release_inactive_stripe_list(struct r5c=
onf *conf,
 					 int hash)
 {
 	int size;
-	bool do_wakeup =3D false;
+	unsigned long do_wakeup =3D 0;
+	int i =3D 0;
 	unsigned long flags;
=20
 	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
@@ -365,15 +366,19 @@ static void release_inactive_stripe_list(struct r=
5conf *conf,
 			    !list_empty(list))
 				atomic_dec(&conf->empty_inactive_list_nr);
 			list_splice_tail_init(list, conf->inactive_list + hash);
-			do_wakeup =3D true;
+			do_wakeup |=3D 1 << (size - 1);
 			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
 		}
 		size--;
 		hash--;
 	}
=20
+	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
+		if (do_wakeup & (1 << i))
+			wake_up(&conf->wait_for_stripe[i]);
+	}
+
 	if (do_wakeup) {
-		wake_up(&conf->wait_for_stripe);
 		if (atomic_read(&conf->active_stripes) =3D=3D 0)
 			wake_up(&conf->wait_for_quiescent);
 		if (conf->retry_read_aligned)
@@ -686,14 +691,15 @@ get_active_stripe(struct r5conf *conf, sector_t s=
ector,
 			if (!sh) {
 				set_bit(R5_INACTIVE_BLOCKED,
 					&conf->cache_state);
-				wait_event_lock_irq(
-					conf->wait_for_stripe,
+				wait_event_cmd_exclusive(
+					conf->wait_for_stripe[hash],
 					!list_empty(conf->inactive_list + hash) &&
 					(atomic_read(&conf->active_stripes)
 					 < (conf->max_nr_stripes * 3 / 4)
 					 || !test_bit(R5_INACTIVE_BLOCKED,
 						      &conf->cache_state)),
-					*(conf->hash_locks + hash));
+					spin_unlock_irq(conf->hash_locks + hash),
+					spin_lock_irq(conf->hash_locks + hash));
 				clear_bit(R5_INACTIVE_BLOCKED,
 					  &conf->cache_state);
 			} else {
@@ -718,6 +724,9 @@ get_active_stripe(struct r5conf *conf, sector_t sec=
tor,
 		}
 	} while (sh =3D=3D NULL);
=20
+	if (!list_empty(conf->inactive_list + hash))
+		wake_up(&conf->wait_for_stripe[hash]);
+
 	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }
@@ -2138,7 +2147,7 @@ static int resize_stripes(struct r5conf *conf, in=
t newsize)
 	cnt =3D 0;
 	list_for_each_entry(nsh, &newstripes, lru) {
 		lock_device_hash_lock(conf, hash);
-		wait_event_cmd(conf->wait_for_stripe,
+		wait_event_cmd_exclusive(conf->wait_for_stripe[hash],
 				    !list_empty(conf->inactive_list + hash),
 				    unlock_device_hash_lock(conf, hash),
 				    lock_device_hash_lock(conf, hash));
@@ -6402,7 +6411,9 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
 	spin_lock_init(&conf->device_lock);
 	seqcount_init(&conf->gen_lock);
 	init_waitqueue_head(&conf->wait_for_quiescent);
-	init_waitqueue_head(&conf->wait_for_stripe);
+	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
+		init_waitqueue_head(&conf->wait_for_stripe[i]);
+	}
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->hold_list);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4cc05ec..6307b90 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -509,7 +509,7 @@ struct r5conf {
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_quiescent;
-	wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_stripe[NR_STRIPE_HASH_LOCKS];
 	wait_queue_head_t	wait_for_overlap;
 	unsigned long		cache_state;
 #define R5_INACTIVE_BLOCKED	1	/* release of inactive stripes blocked,
--=20
1.9.0
