Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836426;
	b=Fpt1U9hQg75Wg5wCnNuYesSGWMj6MKqOEg5wOqY9nzGk47sN0QpJo+tiIpxY88iL6Jhk
	 OPfNdjpzTZ/yPorTzt+dmk9TpBWu/9+Rf/+t/BlycHBySjgE3fwqmEgusjHSp28rdF6uo
	 NwlkXqmxZmN65nh7LL4Lt/gqBGIFkyGm9FMuVzcyGHQsnLRrr33t1xz5wutKWh/bAIQtf
	 g3/eF+AkbSh0ZhCSmjRXmXY7c8xmnCPqb47yUcsUlEPz2IrEVsWpNV7mf2jW1IrPfPrvJ
	 1HhYxUlpE8uoI6HhW+21mnvfex7az1hoZmLmOeyabp7OJg8whpG7BfxkWqDNXzcM+/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836426;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Nbgs+wsdRMc6kX9/pFf9hzcSyrNXKiazeKOtRWb/CGQ=;
	b=OIJ86jwpkRbG5hac/chdRVIxOU9Awlkule03ox/xPYQKN/PP96d8MsHXgok9KswTiR4F
	 9XRA6ek3Qjg93ZHnp6XoaozVJNzucgB++gFVKnf4lrv+IUmlv9jbSn24JUtqxzljteUA+
	 FUKXOakix5IAJz5f5lSU7hatRoBi0X+dNj0BkK/Ha2OOvH1b6AAqCJBY62oa2Srrt2Dn7
	 WkPoZyR8fCZAPywV8l5tW6xIRSgWeD/fOIDRaZqA8X6ey0X70g5oo1VmrYisw71Hu7MMg
	 tobcSpiHxGvUJrGWQC3B7PjFEdRrfKOJ4NoSEGAHwh2X06z+UkVVH6D+7jeP0/SNJvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=KcKgsbjc;
	arc=none smtp.remote-ip=185.70.43.170
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AC3606A323
	for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 13:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20AC3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=KcKgsbjc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794836422; x=1795095622;
	bh=Nbgs+wsdRMc6kX9/pFf9hzcSyrNXKiazeKOtRWb/CGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KcKgsbjc8t5b+yN4YJdHZLvNeAebOZk/FRNfgSCJZocj2yVGL+EfgV+YWSuRi4LZ8
	 CgP8V7+Aq0SVWX3X0uitNTvvKlffVorvdmen3WVYotuHH4ft9nHCV2KqdbNFL9J2+q
	 v+VuVt7fU7i+J3Q5MTouCx/QKL8YQKUXZnyaZ2qV4LfluiYuPBA8J4jrda67uMXorx
	 mtywrMz2pFBYpCmcj3SP7NDnWqjIKE0zVuzI+yFlBqfQbYqzV/IkCoMduD+ko1Ckvo
	 e+PCX2ttAiheshTL++BrL1xmwFWwNuhb6Qej0tZS5mn6jn7vs9Jw88EYfu1SyzAa/g
	 8XFB4x9xxiKKQ==
X-Pm-Submission-Id: 4jSprz6c5xz2ScQ5
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anton Gavriliuk <antosha20xx@gmail.com>
Subject: [PATCH] md/raid5: grow stripe hash table with the size of stripe cache
Date: Mon, 16 Nov 2026 13:39:54 +0000
Message-ID: <20261116133954.5111-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stripe hash table has a fixed size of one page, 512 buckets with
4 KiB pages. With stripe_cache_size at its current maximum (32768), a
bucket contains 64 stripes on average. Every stripe lookup walks one
chain with interrupts off and the hash lock held, and with random I/O
most lookups miss and walk the whole chain. This costs CPU time on
every request and makes the hash locks more contended.

Grow the table when stripe_cache_size is written, to about
STRIPES_PER_HASH_BUCKET (two) stripes per bucket, rounded up to a
power of two. The new table is allocated before any hash lock is taken,
and the stripes are moved to it with all hash locks held. The table
size stays a power of two and a multiple of NR_STRIPE_HASH_LOCKS, so
every stripe keeps its hash lock. If the allocation fails, the old
table stays. Moving about 24k stripes (only stripes that have been
used are in the table) took about 2 ms with interrupts off on the
Xeon machine below. This happens only when stripe_cache_size is set.

The table starts at one page as before. It needs at most 8 bytes per
stripe: 128 KiB at stripe_cache_size=32768, where the stripe pages
alone take 768 MiB on RAID-6 4+2. The table is not shrunk when
stripe_cache_size is lowered.

2x Xeon E5-2699 v3 (one NUMA node used), RAM disks, chunk 512K,
stripe_cache_size=32768, group_thread_cnt=8, io_uring, without -> with
this patch:

  RAID-6 4+2  4k random write, 16 jobs QD64  320k -> 355k IOPS  (+11%)
  RAID-6 6+2  4k random write, 16 jobs QD64  345k -> 381k IOPS  (+10%)
  RAID-5 5+1  4k random write, 16 jobs QD64  437k -> 514k IOPS  (+18%)
  RAID-6 4+2  1M seq write, 4 jobs QD16      4410 -> 4971 MiB/s (+13%)
  RAID-6 4+2  4k random read, degraded       543k -> 705k IOPS  (+30%)

HPE DL345 Gen11, AMD EPYC 9455, 6x PCIe 5.0 NVMe (KIOXIA CM7-V 3.2 TB),
the same md settings and chunk size:

  RAID-6 4+2  4k random write, 16 jobs QD64  501k -> 536k IOPS   (+7%)
  RAID-6 4+2  2M seq write, 1 job QD64      10342 -> 13523 MiB/s (+31%)

The CPU time per I/O drops by 21-34% on the Xeon, and by 12% (random)
and 49% (sequential) on the EPYC. In the 4k random write tests,
find_get_stripe() drops from 9.2% to 0.6% of all cycles on the Xeon,
and from 3.4% to 0.2% on the EPYC. With md's default stripe_cache_size
nothing changes.

Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid5.c | 60 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid5.h | 14 ++++++++---
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index efb4b0d37cb0..5e28ab750398 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -77,7 +77,7 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce);
 
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
-	int hash = (sect >> RAID5_STRIPE_SHIFT(conf)) & HASH_MASK;
+	int hash = (sect >> RAID5_STRIPE_SHIFT(conf)) & conf->hash_mask;
 	return &conf->stripe_hashtbl[hash];
 }
 
@@ -7061,6 +7061,57 @@ raid5_show_stripe_cache_size(struct mddev *mddev, char *page)
 	return ret;
 }
 
+static unsigned int nr_hash_buckets(int nr_stripes)
+{
+	unsigned int buckets = max(nr_stripes / STRIPES_PER_HASH_BUCKET, 1);
+
+	/*
+	 * The table size must be a multiple of NR_STRIPE_HASH_LOCKS for a
+	 * stripe to keep its lock when the table grows.
+	 */
+	BUILD_BUG_ON(NR_HASH_MIN % NR_STRIPE_HASH_LOCKS);
+	return max_t(unsigned int, roundup_pow_of_two(buckets), NR_HASH_MIN);
+}
+
+/*
+ * Grow the stripe hash table so that there are fewer stripes hashed to
+ * a single bucket when the stripe cache is enlarged.
+ *
+ * This is only an optimization. If the allocation of the new table fails,
+ * the old table stays.
+ */
+static void raid5_grow_stripe_hashtbl(struct r5conf *conf, int nr_stripes)
+{
+	unsigned int new_size = nr_hash_buckets(nr_stripes);
+	unsigned int i, old_size;
+	struct hlist_head *new, *old;
+	struct stripe_head *sh;
+	struct hlist_node *tmp;
+
+	lockdep_assert_held(&conf->cache_size_mutex);
+	old = conf->stripe_hashtbl;
+	old_size = conf->hash_mask + 1;
+	if (new_size <= old_size)
+		return;
+	new = kvzalloc_objs(*new, new_size, GFP_KERNEL | __GFP_NOWARN);
+	if (!new)
+		return;
+
+	lock_all_device_hash_locks_irq(conf);
+	conf->stripe_hashtbl = new;
+	conf->hash_mask = new_size - 1;
+	for (i = 0; i < old_size; i++) {
+		hlist_for_each_entry_safe(sh, tmp, &old[i], hash) {
+			hlist_del(&sh->hash);
+			hlist_add_head(&sh->hash,
+				       stripe_hash(conf, sh->sector));
+		}
+	}
+	unlock_all_device_hash_locks_irq(conf);
+
+	kvfree(old);
+}
+
 int
 raid5_set_cache_size(struct mddev *mddev, int size)
 {
@@ -7086,6 +7137,7 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 			result = -ENOMEM;
 			break;
 		}
+	raid5_grow_stripe_hashtbl(conf, conf->max_nr_stripes);
 	mutex_unlock(&conf->cache_size_mutex);
 
 	return result;
@@ -7589,7 +7641,7 @@ static void free_conf(struct r5conf *conf)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
 	bioset_exit(&conf->bio_split);
-	kfree(conf->stripe_hashtbl);
+	kvfree(conf->stripe_hashtbl);
 	kfree(conf->pending_data);
 
 	mempool_destroy(conf->ctx_pool);
@@ -7785,9 +7837,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 
 	ret = -ENOMEM;
-	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	conf->stripe_hashtbl = kvzalloc_objs(*conf->stripe_hashtbl,
+					     NR_HASH_MIN);
 	if (!conf->stripe_hashtbl)
 		goto abort;
+	conf->hash_mask = NR_HASH_MIN - 1;
 
 	/* We init hash_locks[0] separately to that it can be used
 	 * as the reference lock in the spin_lock_nest_lock() call
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1a61b474fc22..6d1d4aa125f2 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -489,8 +489,12 @@ struct disk_info {
 
 #define	IO_THRESHOLD		1
 #define BYPASS_THRESHOLD	1
-#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
-#define HASH_MASK		(NR_HASH - 1)
+/*
+ * The stripe hash table starts at one page and is enlarged with
+ * stripe_cache_size, to about STRIPES_PER_HASH_BUCKET stripes per bucket.
+ */
+#define NR_HASH_MIN		(PAGE_SIZE / sizeof(struct hlist_head))
+#define STRIPES_PER_HASH_BUCKET	2
 #define MAX_STRIPE_BATCH	8
 
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
@@ -570,7 +574,11 @@ struct raid5_percpu {
 
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
-	/* only protect corresponding hash list and inactive_list */
+	unsigned int		hash_mask; /* stripe_hashtbl size - 1 */
+	/*
+	 * Protect corresponding hash list and inactive_list. All of them are
+	 * held to replace stripe_hashtbl and hash_mask during the table growth.
+	 */
 	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
 	int			chunk_sectors;

base-commit: 47e1b18f38d74015cb9fd30b5ff2a1eb88e77d31
-- 
2.53.0

