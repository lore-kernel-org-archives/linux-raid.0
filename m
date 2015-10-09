From: Xunlei Pang <xlpang@126.com>
Subject: [PATCH] md: workqueue: Remove WQ_CPU_INTENSIVE from unbound workqueue allocations
Date: Fri,  9 Oct 2015 11:25:35 +0800
Message-ID: <1444361135-22624-1-git-send-email-xlpang@126.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.com>, Tejun Heo <tj@kernel.org>, Xunlei Pang <pang.xunlei@linaro.org>
List-Id: linux-raid.ids

From: Xunlei Pang <pang.xunlei@linaro.org>

WQ_CPU_INTENSIVE is meaningless for the unbound workqueue, so remove it.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/md/dm-crypt.c  | 4 ++--
 drivers/md/dm-verity.c | 3 ++-
 drivers/md/raid5.c     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4b3b6f8..56b2560 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1871,8 +1871,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
 		cc->crypt_queue = alloc_workqueue("kcryptd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
 	else
-		cc->crypt_queue = alloc_workqueue("kcryptd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
-						  num_online_cpus());
+		cc->crypt_queue = alloc_workqueue("kcryptd",
+				WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index edc624b..f2fc693 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -942,7 +942,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->per_bio_data_size = roundup(sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2, __alignof__(struct dm_verity_io));
 
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
+	v->verify_wq = alloc_workqueue("kverityd",
+			WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 49bb8d3..2a25af8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7840,7 +7840,7 @@ static struct md_personality raid4_personality =
 static int __init raid5_init(void)
 {
 	raid5_wq = alloc_workqueue("raid5wq",
-		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
+		WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
 	if (!raid5_wq)
 		return -ENOMEM;
 	register_md_personality(&raid6_personality);
-- 
1.9.1
