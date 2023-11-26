Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rMtUXlay"
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2040.outbound.protection.outlook.com [40.92.42.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55220B5
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 00:11:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQuEEl/273q6lyruR9ob4Q123IgKmXu3/55Cg3VnuYU76FzzylKvl+3x0aYPnWEeE/Ok5HrdHzpx4Y65qqLrq3Ausqjntxu0x3K+MzbKwefZoDyEXQfSR22M+gv6w5R1SpbV1/CcdinwXSC0Zq5jJaTM9DLv2O0kEMEJhXl9lPWQFe5XWjhiW59nIrZWWLToKY+5nKQ90O8VA/e1Sr+/HyLM8Azpd/wC+O7NyOzz7caloaWhY1lniDho8pK1s2NJmbeAiPj1M3z1PIhyWGhqbqpcfS1Heyf7zT6yoFoB1AWbECxdVciUKUV818fAcsq+swIOllvps2j7lmlBDKg+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPDrJGKCRDDTPP76R3601Pgry36vx/TYPLhqiA2vshk=;
 b=Ga9Nzy7b/ALaIVrrd/cfwcoYkD8+yV26KPG3uzblgMJVp824e7smuyKvXFgmAjY9zLRRKJo9XbADNWZ9I9cCgasweLQ53rWukoMHq8so9hoUIZOfGDsRxf7KPKozqjevekeWBvTMo4O8aU4EjhtgoRFiMC4dwXtRC6AlhEZAzS9Vu3S9skPZydIKmqJtDuH7cf15cgmEzLJfABqhf6SiZIZc3b07N4GyxD9/rYJZ/4gKKO4LipDntKzHqlvzi1jIcUwBoU92sP1K+0aEXLoWnYVgtI7hXNy/gAQx9zbeC7ImJ8Ja3AAzTvRhJhs1W+FBD0B7J3MPwCYg04JwbcE3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPDrJGKCRDDTPP76R3601Pgry36vx/TYPLhqiA2vshk=;
 b=rMtUXlaylWq5jsDdDgqhX5ufeRKTo+2BeJyAQL9WkdEu3EJPe/GoR7YAf1uxuT+++tISHq9d8kl6eMxI3UzGyUc7ObcHP+KrMf/aQee5aa1IQzKCcjBZXV2BDeyR06gJ6ZXOrqDP1tOCBTmtr5pg6Mx59VH/BIccQD7clno8WuAK8jePjpskc298zb5aCO6pfZ5mW4ouVdO5XK6V/xH5EBqSdNV++JzE3ypGfr7bYo0edynAi/pZ0yRhyCx0IYNaUDH8vdtBtXHNgLlKwtVeMOR5ixXiZJNnyH9SSvI9DxJhjXW0P71CVZVHEAvsSGBIsaqLn7MtbVYnYoSI6oT4dw==
Received: from SJ2PR11MB7574.namprd11.prod.outlook.com (2603:10b6:a03:4ca::17)
 by MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Sun, 26 Nov
 2023 08:11:13 +0000
Received: from SJ2PR11MB7574.namprd11.prod.outlook.com
 ([fe80::de5a:4d13:2fbc:63f8]) by SJ2PR11MB7574.namprd11.prod.outlook.com
 ([fe80::de5a:4d13:2fbc:63f8%7]) with mapi id 15.20.7025.022; Sun, 26 Nov 2023
 08:11:13 +0000
From: Yiming Xu <teddyxym@outlook.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com,
	firnyee@gmail.com,
	Yiming Xu <teddyxym@outlook.com>
Subject: [RFC] md/raid5: optimize RAID5 performance.
Date: Sun, 26 Nov 2023 16:09:45 +0800
Message-ID:
 <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [XUpgs2VjtRiUGCD2/LIHLHAIeQobZXyd]
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To SJ2PR11MB7574.namprd11.prod.outlook.com
 (2603:10b6:a03:4ca::17)
X-Microsoft-Original-Message-ID: <20231126080945.14510-1-teddyxym@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7574:EE_|MW4PR11MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e90fed-5362-4ced-412c-08dbee5740ff
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nTs9W5Pzc9UsEE6nJerHzq/FHbzLB99PhBDZhpYYJzzfZYB+6UqH7mcI9rLQSgnUlYOriZg5BtoTy2h7Ap94U3qIczrC2pcwB3ZbAnAuVyqs5IDjCQdf4npSVa1vUWECgzDGN0iJIqfivkMLUrJ8rNxWD7cdcD6MLwRba4CSfCq10I0h1fjdoPwQNMP6BVmx5dd5BcKnJnEA0+u9HwBeZGO/ohl8fIPgCa9NcdLFFfz25G18zsQhmkwdsZusojTX8DRO/yo0gSQOQtIpRwMyNSa9t+XHQ6tUMqJrpRJtA1FhApwCNmeDVL0ekK0KMLmvUqDzRWZIRzf+WtooilFHBmmdWEFTVjUmK6pPy+iXYFtsNGWDJR+UgIHSev1XyrFHeCz59BU/WInojGqVwHzC8RbGR0ncWvj/aJ/Z0t3rh9RRl8Qdnk7uj7uiaKf4enAUGUZdUKIaw9UtGqrKiRPxVIUxTMUyFyjoBJNV4DKHj+7t0NBLvCcgqpXgIVT6X97WiezA4EWaR7M4pfRzqIfQBCvFt5z3YN8cEXAFpmJrfno//PrzKAa7v9d4S8Su4itrWa/RlApbATPvNa55SN+pnxDCqkIbCzldWS5t4XsSzY0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wQlbYD7A0SheteqsmWWgQsG5z049olsn05gMfHxDNSBokKXKf0BZRyAY5rEz?=
 =?us-ascii?Q?iRiCCTqtxuVqAcJVRhtQ0wE647sFQigHH/O9Egz+Uc7j8fZp1/BvxbLfWcHx?=
 =?us-ascii?Q?1m/rLYqqYJD/U8lnttw0ODUgxdHakcsJ1nHiPbxC8cM9o0pWfMh/sSwVQ6G4?=
 =?us-ascii?Q?fBtLc3fgdFv9BfBqHVMM51woJ6Mm1nMnqoaNsj80Bs+F2TiqbfrNDOtSqQDY?=
 =?us-ascii?Q?/MZXWMgX7f8WlsHYOqR7hBeEyTZUchp9c4Yk3/+plEtAiwTTR0P/htqqNUbP?=
 =?us-ascii?Q?dhPUUsdkYsY1OsDtCH79JLN582T2fqaiNQ2D3WSWJwobraJquT9+aciuOqjr?=
 =?us-ascii?Q?aNPSOkFB0QfyxvgheZeGb8wJ9e9z8Fiyd7iyThBR/xE+VsptVpLtOSr2ijsm?=
 =?us-ascii?Q?gLN/FyivCDpZ9AUpHY0nro0T64fGvdceqLi1LlZocfVPzSeoBBdQe0UxHp28?=
 =?us-ascii?Q?vD4PlHqaiw9oRLlZoEHDIp0yxPgJRRNlbrCdo8iCxlUnrrZvoFZUgP9pgLo5?=
 =?us-ascii?Q?9DTojbjuKBxLnG8uH4aXf7/igIci4dPNmr7syRQ49TbzfbrBSJG5P+ShU+gs?=
 =?us-ascii?Q?+C28ZRTTmxNc3wo1ZUAMrl00ef0keucXYMDLJ0ti8rEn3TcyaBDGqsS4lfQV?=
 =?us-ascii?Q?Rq++QjIeiChFY61C2VT9udkBmHa2d+E5W4dbMOCpfFVtG6yRniJMXPC4m8+J?=
 =?us-ascii?Q?pVA43ALBMqiQgeH/LAZ3QoulRW0n6W8DBJBWD5f3Ax5Ad42OV9K8wzpHrPG9?=
 =?us-ascii?Q?KaLUuJnbId4jTDMqp4HF6wnSxDIeSMqpRSW9sYO0XikPCOUVxjmGfnjyWTdP?=
 =?us-ascii?Q?z0CFu84/S+8CUvKN6UVfkOjQLIHn8IUmGf76txIIxO9JUXeod+pHOS/bD24l?=
 =?us-ascii?Q?bXStbA7nn3JVSjpIUNiL4YI5bJp1dkqNhfgeqJRRc6QX6A0wV4o7Ka1Coxi1?=
 =?us-ascii?Q?SU2/StnRb9dFjFSLZVQfIRrhJ9Cg9Doq9yqT2vFhV6x5ApmRapuNZ2SmzhLo?=
 =?us-ascii?Q?1DX9LRXueOhy2O0nh6oorpLvt6pJrxiRx8FBDz5jIPcm/o2l0MUKVAdAJQBd?=
 =?us-ascii?Q?/A3xCnkZUEdOwjHeW1a+NVa7UM+wEpnDO9n8ABhEsq9smutQrKBbSI5wPn0V?=
 =?us-ascii?Q?aZbABNTkdJkjtXewBk+CS8HUTCjpQKYT70GCUhNhmyPw5fEsKG1pbmE6gzWI?=
 =?us-ascii?Q?kzrYgIDWiiXhBLhS9f3TFeocLZPontUihsi2Rw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e90fed-5362-4ced-412c-08dbee5740ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7574.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2023 08:11:12.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5933

From: Shushu Yi <firnyee@gmail.com>

Optimized by using fine-grained locks, customized data structures, and
scattered address space. Achieves significant improvements in both
throughput and latency.

This patch attempts to maximize thread-level parallelism and reduce
CPU suspension time caused by lock contention. On a system with four
PCIe 4.0 SSDs, we achieved increased overall storage throughput by
89.4% and decreases the 99.99th percentile I/O latency by 85.4%.

Seeking feedback on the approach and any addition information regarding
Required performance testing before submitting a formal patch.

Note: this work has been published as a paper, and the URL is
https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/hotstorage22-5.pdf

Co-developed-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Shushu Yi <firnyee@gmail.com>
---
diff -uprN origlinux-6.6.1/drivers/md/md-bitmap.c linux-6.6.1/drivers/md/md-bitmap.c
--- origlinux-6.6.1/drivers/md/md-bitmap.c	2023-11-13 20:48:43.410856322 +0800
+++ linux-6.6.1/drivers/md/md-bitmap.c	2023-11-13 23:24:24.360653915 +0800
@@ -48,9 +48,11 @@ static inline char *bmname(struct bitmap
  * allocated while we're using it
  */
 static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
-			       unsigned long page, int create, int no_hijack)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+			       unsigned long page, int create, int no_hijack, spinlock_t *bmclock, int locktype)
+__releases(bmclock)
+__acquires(bmclock)
+__releases(bitmap->mlock)
+__acquires(bitmap->mlock)
 {
 	unsigned char *mappage;

@@ -65,8 +67,10 @@ __acquires(bitmap->lock)
 		return -ENOENT;

 	/* this page has not been allocated yet */
-
-	spin_unlock_irq(&bitmap->lock);
+	if (locktype)
+		spin_unlock_irq(bmclock);
+	else
+		write_unlock_irq(&bitmap->mlock);
 	/* It is possible that this is being called inside a
 	 * prepare_to_wait/finish_wait loop from raid5c:make_request().
 	 * In general it is not permitted to sleep in that context as it
@@ -81,7 +85,11 @@ __acquires(bitmap->lock)
 	 */
 	sched_annotate_sleep();
 	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
-	spin_lock_irq(&bitmap->lock);
+
+	if (locktype)
+		spin_lock_irq(bmclock);
+	else
+		write_lock_irq(&bitmap->mlock);

 	if (mappage == NULL) {
 		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
@@ -398,7 +406,7 @@ static int read_file_page(struct file *f
 	}

 	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)==0);
+		   atomic_read(&bitmap->pending_writes) == 0);
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		ret = -EIO;
 out:
@@ -457,7 +465,7 @@ static void md_bitmap_wait_writes(struct
 {
 	if (bitmap->storage.file)
 		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
+			   atomic_read(&bitmap->pending_writes) == 0);
 	else
 		/* Note that we ignore the return value.  The writes
 		 * might have failed, but that would just mean that
@@ -1246,16 +1254,32 @@ void md_bitmap_write_all(struct bitmap *
 static void md_bitmap_count_page(struct bitmap_counts *bitmap,
 				 sector_t offset, int inc)
 {
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX << (bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
+	// sector_t chunk = offset >> bitmap->chunkshift;
+	// unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+
 	bitmap->bp[page].count += inc;
 	md_bitmap_checkfree(bitmap, page);
 }

 static void md_bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
 {
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX << (bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
+	// sector_t chunk = offset >> bitmap->chunkshift;
+	// unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+
 	struct bitmap_page *bp = &bitmap->bp[page];

 	if (!bp->pending)
@@ -1264,7 +1288,7 @@ static void md_bitmap_set_pending(struct

 static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 					       sector_t offset, sector_t *blocks,
-					       int create);
+					       int create, spinlock_t *bmclock, int locktype);

 static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
 			      bool force)
@@ -1349,7 +1373,7 @@ void md_bitmap_daemon_work(struct mddev
 	 * decrement and handle accordingly.
 	 */
 	counts = &bitmap->counts;
-	spin_lock_irq(&counts->lock);
+	write_lock_irq(&counts->mlock);
 	nextpage = 0;
 	for (j = 0; j < counts->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1364,7 +1388,7 @@ void md_bitmap_daemon_work(struct mddev
 			counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
 		}

-		bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
+		bmc = md_bitmap_get_counter(counts, block, &blocks, 0, 0, 0);
 		if (!bmc) {
 			j |= PAGE_COUNTER_MASK;
 			continue;
@@ -1380,7 +1404,7 @@ void md_bitmap_daemon_work(struct mddev
 			bitmap->allclean = 0;
 		}
 	}
-	spin_unlock_irq(&counts->lock);
+	write_unlock_irq(&counts->mlock);

 	md_bitmap_wait_writes(bitmap);
 	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
@@ -1413,17 +1437,27 @@ void md_bitmap_daemon_work(struct mddev

 static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 					       sector_t offset, sector_t *blocks,
-					       int create)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+					       int create, spinlock_t *bmclock, int locktype)
+__releases(bmclock)
+__acquires(bmclock)
+__releases(bitmap->mlock)
+__acquires(bitmap->mlock)
 {
 	/* If 'create', we might release the lock and reclaim it.
 	 * The lock must have been taken with interrupts enabled.
 	 * If !create, we don't release the lock.
 	 */
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
-	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX << (bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
+
+	// sector_t chunk = offset >> bitmap->chunkshift;
+	// unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	// unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
 	sector_t csize;
 	int err;

@@ -1435,7 +1469,7 @@ __acquires(bitmap->lock)
 		 */
 		return NULL;
 	}
-	err = md_bitmap_checkpage(bitmap, page, create, 0);
+	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock, 1);

 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
@@ -1461,6 +1495,36 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }

+/* set-association
+ * e.g. if we have 14 counters & BITMAP_COUNTER_LOCK_RATIO_SHIFT is 2 (means every 2^2 counters share the same lock),
+ *      counter 0, 4, 8 and 12 share the same lock. (1, 5, 9, 13 | 2, 6, 10)
+ */
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset);
+
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset)
+{
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX << (bitscnt - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & maskcnt;
+
+	unsigned long totcnts = bitmap->chunks;
+	unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
+	unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX << (bitslock - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
+	unsigned long lockid = cntid & masklock;
+
+	// unsigned long chunks = bitmap->chunks; /* Total number of (bitmap) chunks for the array */
+	// sector_t chunk = offset >> bitmap->chunkshift;
+	// unsigned long bits = chunks ? fls((chunks - 1)) : 0;
+	// unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX << (bits - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
+	// unsigned long lockidx = chunk & mask;
+
+	spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
+	pr_debug("========>>> offset =%lld, blockno = %lld, totblocks = %lld ,totcnts = %ld, cntid = %ld, lockidx = %ld", offset, blockno, totblocks, totcnts, cntid, lockid);
+	return bmclock;
+}
+
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
 {
 	if (!bitmap)
@@ -1480,11 +1544,15 @@ int md_bitmap_startwrite(struct bitmap *
 	while (sectors) {
 		sector_t blocks;
 		bitmap_counter_t *bmc;
+		spinlock_t *bmclock;

-		spin_lock_irq(&bitmap->counts.lock);
-		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
+		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+		read_lock(&bitmap->counts.mlock);
+		spin_lock_irq(bmclock);
+		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1, bmclock, 1);
 		if (!bmc) {
-			spin_unlock_irq(&bitmap->counts.lock);
+			spin_unlock_irq(bmclock);
+			read_unlock(&bitmap->counts.mlock);
 			return 0;
 		}

@@ -1496,7 +1564,8 @@ int md_bitmap_startwrite(struct bitmap *
 			 */
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->counts.lock);
+			spin_unlock_irq(bmclock);
+			read_unlock(&bitmap->counts.mlock);
 			schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
@@ -1513,7 +1582,8 @@ int md_bitmap_startwrite(struct bitmap *

 		(*bmc)++;

-		spin_unlock_irq(&bitmap->counts.lock);
+		spin_unlock_irq(bmclock);
+		read_unlock(&bitmap->counts.mlock);

 		offset += blocks;
 		if (sectors > blocks)
@@ -1542,11 +1612,15 @@ void md_bitmap_endwrite(struct bitmap *b
 		sector_t blocks;
 		unsigned long flags;
 		bitmap_counter_t *bmc;
+		spinlock_t *bmclock;

-		spin_lock_irqsave(&bitmap->counts.lock, flags);
-		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
+		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+		read_lock(&bitmap->counts.mlock);
+		spin_lock_irqsave(bmclock, flags);
+		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0, bmclock, 1);
 		if (!bmc) {
-			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+			spin_unlock_irqrestore(bmclock, flags);
+			read_unlock(&bitmap->counts.mlock);
 			return;
 		}

@@ -1568,7 +1642,8 @@ void md_bitmap_endwrite(struct bitmap *b
 			md_bitmap_set_pending(&bitmap->counts, offset);
 			bitmap->allclean = 0;
 		}
-		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+		spin_unlock_irqrestore(bmclock, flags);
+		read_unlock(&bitmap->counts.mlock);
 		offset += blocks;
 		if (sectors > blocks)
 			sectors -= blocks;
@@ -1582,13 +1657,16 @@ static int __bitmap_start_sync(struct bi
 			       int degraded)
 {
 	bitmap_counter_t *bmc;
+	spinlock_t *bmclock;
 	int rv;
 	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
 		*blocks = 1024;
 		return 1; /* always resync if no bitmap */
 	}
-	spin_lock_irq(&bitmap->counts.lock);
-	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+	read_lock(&bitmap->counts.mlock);
+	spin_lock_irq(bmclock);
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock, 1);
 	rv = 0;
 	if (bmc) {
 		/* locked */
@@ -1602,7 +1680,8 @@ static int __bitmap_start_sync(struct bi
 			}
 		}
 	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
 	return rv;
 }

@@ -1634,13 +1713,16 @@ void md_bitmap_end_sync(struct bitmap *b
 {
 	bitmap_counter_t *bmc;
 	unsigned long flags;
+	spinlock_t *bmclock;

 	if (bitmap == NULL) {
 		*blocks = 1024;
 		return;
 	}
-	spin_lock_irqsave(&bitmap->counts.lock, flags);
-	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+	read_lock(&bitmap->counts.mlock);
+	spin_lock_irqsave(bmclock, flags);
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock, 1);
 	if (bmc == NULL)
 		goto unlock;
 	/* locked */
@@ -1657,7 +1739,8 @@ void md_bitmap_end_sync(struct bitmap *b
 		}
 	}
  unlock:
-	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+	spin_unlock_irqrestore(bmclock, flags);
+	read_unlock(&bitmap->counts.mlock);
 }
 EXPORT_SYMBOL(md_bitmap_end_sync);

@@ -1738,10 +1821,15 @@ static void md_bitmap_set_memory_bits(st

 	sector_t secs;
 	bitmap_counter_t *bmc;
-	spin_lock_irq(&bitmap->counts.lock);
-	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
+	spinlock_t *bmclock;
+
+	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+	read_lock(&bitmap->counts.mlock);
+	spin_lock_irq(bmclock);
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1, bmclock, 1);
 	if (!bmc) {
-		spin_unlock_irq(&bitmap->counts.lock);
+		spin_unlock_irq(bmclock);
+		read_unlock(&bitmap->counts.mlock);
 		return;
 	}
 	if (!*bmc) {
@@ -1752,7 +1840,8 @@ static void md_bitmap_set_memory_bits(st
 	}
 	if (needed)
 		*bmc |= NEEDED_MASK;
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
 }

 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
@@ -1806,6 +1895,7 @@ void md_bitmap_free(struct bitmap *bitma
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
+	spinlock_t *bmclocks;

 	if (!bitmap) /* there was no bitmap */
 		return;
@@ -1826,6 +1916,7 @@ void md_bitmap_free(struct bitmap *bitma

 	bp = bitmap->counts.bp;
 	pages = bitmap->counts.pages;
+	bmclocks = bitmap->counts.bmclocks;

 	/* free all allocated memory */

@@ -1834,6 +1925,7 @@ void md_bitmap_free(struct bitmap *bitma
 			if (bp[k].map && !bp[k].hijacked)
 				kfree(bp[k].map);
 	kfree(bp);
+	kfree(bmclocks);
 	kfree(bitmap);
 }
 EXPORT_SYMBOL(md_bitmap_free);
@@ -1900,7 +1992,9 @@ struct bitmap *md_bitmap_create(struct m
 	if (!bitmap)
 		return ERR_PTR(-ENOMEM);

-	spin_lock_init(&bitmap->counts.lock);
+	/* initialize metadata lock */
+	rwlock_init(&bitmap->counts.mlock);
+
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
 	init_waitqueue_head(&bitmap->overflow_wait);
@@ -2143,6 +2237,8 @@ int md_bitmap_resize(struct bitmap *bitm
 	int ret = 0;
 	long pages;
 	struct bitmap_page *new_bp;
+	spinlock_t *new_bmclocks;
+	int num_bmclocks, i;

 	if (bitmap->storage.file && !init) {
 		pr_info("md: cannot resize file-based bitmap\n");
@@ -2211,7 +2307,7 @@ int md_bitmap_resize(struct bitmap *bitm
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
-	spin_lock_irq(&bitmap->counts.lock);
+	write_lock_irq(&bitmap->counts.mlock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;

@@ -2227,18 +2323,30 @@ int md_bitmap_resize(struct bitmap *bitm
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
 		     chunks << chunkshift);

+	/* initialize bmc locks */
+	num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
+	pr_debug("========>>> num_bmclocks = %d, blocks = %lld\n", num_bmclocks, blocks);
+
+	// new_bmclocks = kcalloc(num_bmclocks, sizeof(*new_bmclocks), GFP_KERNEL);
+	new_bmclocks = kvzalloc(num_bmclocks * sizeof(*new_bmclocks), GFP_KERNEL);
+	bitmap->counts.bmclocks = new_bmclocks;
+	for (i = 0; i < num_bmclocks; ++i) {
+		spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
+		// pr_debug("========>>> &bmclocks[0] = 0x%pK, i = %d, bmclock = 0x%pK\n", &bitmap->counts.bmclocks[0], i, bmclock);
+		spin_lock_init(bmclock);
+	}
+
 	/* For cluster raid, need to pre-allocate bitmap */
 	if (mddev_is_clustered(bitmap->mddev)) {
 		unsigned long page;
 		for (page = 0; page < pages; page++) {
-			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1);
+			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1, 0, 0);
 			if (ret) {
 				unsigned long k;

 				/* deallocate the page memory */
-				for (k = 0; k < page; k++) {
+				for (k = 0; k < page; k++)
 					kfree(new_bp[k].map);
-				}
 				kfree(new_bp);

 				/* restore some fields from old_counts */
@@ -2261,11 +2369,11 @@ int md_bitmap_resize(struct bitmap *bitm
 		bitmap_counter_t *bmc_old, *bmc_new;
 		int set;

-		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0);
+		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0, 0, 0);
 		set = bmc_old && NEEDED(*bmc_old);

 		if (set) {
-			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, 0, 0);
 			if (bmc_new) {
 				if (*bmc_new == 0) {
 					/* need to set on-disk bits too. */
@@ -2301,7 +2409,7 @@ int md_bitmap_resize(struct bitmap *bitm
 		int i;
 		while (block < (chunks << chunkshift)) {
 			bitmap_counter_t *bmc;
-			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, 0, 0);
 			if (bmc) {
 				/* new space.  It needs to be resynced, so
 				 * we set NEEDED_MASK.
@@ -2317,7 +2425,7 @@ int md_bitmap_resize(struct bitmap *bitm
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	write_unlock_irq(&bitmap->counts.mlock);

 	if (!init) {
 		md_bitmap_unplug(bitmap);
diff -uprN origlinux-6.6.1/drivers/md/md-bitmap.h linux-6.6.1/drivers/md/md-bitmap.h
--- origlinux-6.6.1/drivers/md/md-bitmap.h	2023-11-13 20:48:43.410856322 +0800
+++ linux-6.6.1/drivers/md/md-bitmap.h	2023-11-13 22:06:01.020479486 +0800
@@ -2,7 +2,9 @@
 /*
  * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
  *
- * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ * additions:
+ *		Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ *		Copyright (C) 2022-2023, Shushu Yi (firnyee@gmail.com)
  */
 #ifndef BITMAP_H
 #define BITMAP_H 1
@@ -103,6 +105,9 @@ typedef __u16 bitmap_counter_t;
 #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)

 #define BITMAP_BLOCK_SHIFT 9
+/* how many conters share the same bmclock? */
+#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
+#define BITMAP_COUNTER_LOCK_RATIO (1 << BITMAP_COUNTER_LOCK_RATIO_SHIFT)

 #endif

@@ -116,7 +121,7 @@ typedef __u16 bitmap_counter_t;
 enum bitmap_state {
 	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
-	BITMAP_HOSTENDIAN  =15,
+	BITMAP_HOSTENDIAN  = 15,
 };

 /* the superblock at the front of the bitmap file -- little endian */
@@ -180,7 +185,8 @@ struct bitmap_page {
 struct bitmap {

 	struct bitmap_counts {
-		spinlock_t lock;
+		rwlock_t mlock;				/* lock for metadata */
+		spinlock_t *bmclocks;		/* locks for bmc */
 		struct bitmap_page *bp;
 		unsigned long pages;		/* total number of pages
 						 * in the bitmap */
diff -uprN origlinux-6.6.1/drivers/md/raid5.h linux-6.6.1/drivers/md/raid5.h
--- origlinux-6.6.1/drivers/md/raid5.h	2023-11-13 20:48:43.414856314 +0800
+++ linux-6.6.1/drivers/md/raid5.h	2023-11-13 21:03:11.439200413 +0800
@@ -501,7 +501,7 @@ struct disk_info {
  * and creating that much locking depth can cause
  * problems.
  */
-#define NR_STRIPE_HASH_LOCKS 8
+#define NR_STRIPE_HASH_LOCKS 128
 #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)

 struct r5worker {
