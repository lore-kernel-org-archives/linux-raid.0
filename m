Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2041.outbound.protection.outlook.com [40.92.18.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9238468
	for <linux-raid@vger.kernel.org>; Tue, 16 Apr 2024 05:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.18.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245001; cv=fail; b=m9/UY0ravE8OEgWqVKHF0Lr2X4zqOwC6QBAA8CjJE/0cagD4j6kD1CApOwbsEP00BJl8vorKRVXCWTXRZNSONtFPl5vzU+VCmimQOXvJXv9jslHQbzNK3ry9S8oiZ/2xFgqbg/gYAMzvRe93ejrp/OR2mXrHK6YegDqQg1OyveQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245001; c=relaxed/simple;
	bh=vG6+tOcc9TFl86859nLsJnZYragyVMQ9A2+dBMj+200=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oIK3n8/RnO3noUhkjd2Yv4ko4GkAt0Crnu9AK1zSF4Lh6Bh5YM5qdXPFGUDEGRE89Exnl59ByAb8lvYQFgifhoh/FlJJn2XNZ1nYHCeW2sHynUp8W43vig1KutnaWuVYhCTI7chVCBeT1hHzfQNAgh6mNg7Pz1uo9BYliGKL0cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=rnY94zlr; arc=fail smtp.client-ip=40.92.18.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rnY94zlr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc0o9iZk+fAyT2gVjqxC3AkaokY7zoV3gN6gkIYOYbk4odK14SNXi8QUw9trXW7C3YRlUDphQT/DAM7A8qeNLgkRRH4QwpldqVMi5M8uPtOy69VMcjPi2zYe+OVKsTyRaaISv//08EVGD1/2rxpBFuNsvJowH8yVFgzYadp9UN6DYmGwf1iNtTKO271Q44ucqaXsWgKhV5TDNFENeD7dZAUGYh/omf7HSdG+JtYk0X1kTt0eCo1X4eii7c5EzAzELT+HgfbM5Nmx2GnT1Uib0U8JpdWNJrqRxfub5BI9udSOUDkD6N5ccJ1n3/Y3fviFW23YyI1CUH5VzrJTeRzrYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMpPhdXiU/V8zXh9tcr9vrBi9VurNA56ZJshNY8VSKU=;
 b=MLCX30ssQNNKWgbywJxYCDIRwhIxFWK37CyFPnxa4hJeeCVDEaI2YdJbvUUANnFbcCdMgzSpQmmSPxkd+eYV7GWGi9TWwp3HOTVM/wrwHKiLmGy1G034QbTCHcZINbKZPgSC7VonCLhVPnJ/mYcZeN+Be7M/AYNn12iCDYhv4r/xzoxTgPrrH2ianduXIps3AegemEP3da3qDDuG79rfN2hnsUP5f0Spqu/dfBRZGHuzJK7++VbUSZr9HgnHAydwM/dDRT0eYQEAj/NLqQfkBjYEFyQ+Pic03TS+ol6MX3SL5YTo+Z1G6XvwCf+AQ8oCwcoyDqo0r/10LRAkbFtagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMpPhdXiU/V8zXh9tcr9vrBi9VurNA56ZJshNY8VSKU=;
 b=rnY94zlrBudEIGY9Q9IKP8anRXxW3N+9wcn4JIwxASUsvFrCSVPYS1BYTHQzqJTTe+yk2XXmbJQDkAyjGBuZlOfYkj2mjldPQCyC5LdXZTB65QyU0TytJsv7c0jp6xaHTxGcerQ/HI5e7Ub5gTKV5yrFuEWi0T6suKXHNjPF9S2JoMvHZwhaVLqQn0R4YbD6kkle1Ie532ztn8kxKeA3hQaIfJ4KHJ0VuH/KYn2X3DwaCJmkvO9cx8O5J09c5X3g7i9TvJ828izc5rdKbjCCqlNOHERUeqWsOy+oaCxH3+hVCQZfENJHqTk1/bcwYNyobioHzjf2Sgr5a0W7dX36Cw==
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20)
 by PH0PR10MB7026.namprd10.prod.outlook.com (2603:10b6:510:289::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 05:23:16 +0000
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1]) by SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1%4]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 05:23:16 +0000
From: Shushu Yi <teddyxym@outlook.com>
To: linux-raid@vger.kernel.org
Cc: firnyee@gmail.com,
	song@kernel.org,
	hch@infradead.org,
	paul.e.luse@intel.com,
	Yiming Xu <teddyxym@outlook.com>
Subject: [RFC V4] md/raid5: optimize Scattered Address Space and Thread-Level Parallelism to improve RAID5 performance
Date: Tue, 16 Apr 2024 13:22:53 +0800
Message-ID:
 <SJ0PR10MB5741964ECA25920AD608FEADD8082@SJ0PR10MB5741.namprd10.prod.outlook.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [Lwwa8DlEMtXSaezY7OU80yxsx4HwReuo]
X-ClientProxiedBy: KL1PR01CA0095.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::35) To SJ0PR10MB5741.namprd10.prod.outlook.com
 (2603:10b6:a03:3ec::20)
X-Microsoft-Original-Message-ID:
 <20240416052253.219993-1-teddyxym@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5741:EE_|PH0PR10MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: b6c28a03-e8d9-43cf-ec3b-08dc5dd551a1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CwIfkoU6LH0+h9dKOvtfpmXnIuRvI9p77mlzMFzM+f0m+Rgp4AG9nxpaLYKbTzoF3zQg1AzesFUlTV+uI1sQq9zGfMWLS1zJXQbZYw9c+sjUx74N4rCX8FiMgs+GMive5w7fCRUpCXK7EcL9GijKCV0/pNzPjI7Cw/VVR16NiWPInuE6i06vci5GFcf7XGyXpa4IBuw6Xd8I0AHDx9OABmD6qi6l+xNrbaZ6Pqbaoh7T/DzA3OAgXwkIXrZE2/tNW05p5AtUN7n1F+QCsS7rFlF+L+OfHYH+a7Bb36BwoHLkbKkJxoR8zazH6Z5FexL9HBA62nFr+mp6yDj5R+SasnBUcyhyMTavapzSIYLGyswj5dZOqJ5t/6qYaJqPJ0gMNBj+HV2XlT1zNXFapdo6P7gZ5IV+2GFipDh+fhmqB6IlhCu9TfFqcd8EpjDivKXEUmsWIygyZ8dIbpmd/XcYFoADmnsSFijTMVwo1jNCJxfCJ1LyXCAWj840dh06fT1anvKJy02R7o3+9ZXBIEBIigun8y6rABRHqGtf+JcmeGU9KElWoBfd8Gi0nuP9x0YqXPghdxrBdFZqdWwZ/ypGTta2zz9y0R4OqgEqOHIDT4Imdkzkc0rM08t7pGH5poJ0NVC8YpMfmYWnLj72LMV60Y1vvyquBkQ4l2A3AWP9PfE=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EwSu12Rn3d4LKH/VowoEUnbFwyWhO1R0r2l2WM7Co/9YmyYbB8xUxSZ6FjlG?=
 =?us-ascii?Q?QUza63yTkZI9KCYvNlLZsBqNQrMyFMKQe+2G3LTVbKR/BYR1aYdj05INQrUD?=
 =?us-ascii?Q?ZQ2HLEthxqIQnTM0E3wCMqJaKB6Brjh65ywTOPqZQg0GBK6IGMxFrOxM8YM7?=
 =?us-ascii?Q?XBOJj65LWrfpUb8lWScbRYvwGC+ZggltbtexkJz6qAIZ3kLwKqk4rS52cCeM?=
 =?us-ascii?Q?pCTmU0Uns+zMD0m1k6sVLGFrVxkrAwoQpkB9rXce9COon/nisJD71ioNuL/j?=
 =?us-ascii?Q?6cX5sANZ+yk5MyK+BSbSCCfwKFfraAM0+bo8XvYl85ekYi9p4hBKj3ubMisG?=
 =?us-ascii?Q?mVZ70qginK8ztbaVDa+0ZGVjx+o5KKmSfMwCRp6KcErzv9OIqq49CmnPZJre?=
 =?us-ascii?Q?AcqGSCaFFN7Msc3OqrP/zGBV+iKzO301mijnncAntp9evuzKnuAVZOQV5Uf0?=
 =?us-ascii?Q?TD9qM2Q4k33M3kIfbtwbFixHT+IZ3Tv0Ee7Lu0Qtug8UnNO0QJYpJbabcQ0i?=
 =?us-ascii?Q?5Irn9te7vHYea8ysm1KOP9PgujmgMgm7Iasf1E+wA63ac2qJHX58ZZcHsTnG?=
 =?us-ascii?Q?+D9xfqfAZqwzZ7BrcZFjIaaJUqz10bXwd3goXehEsVcOQVU7iTwR8pdpgGFM?=
 =?us-ascii?Q?BpVPvUIC4dXWPKPLpZ4RlUQq2R9GgK/AM7DBRVFDJ+pOeNSksViucb2/4dJ+?=
 =?us-ascii?Q?3j8PoQEhmdLc6V26mHjdMC4ZXIoAwxwv3ZAL3auCT9aAezZKJiG0FJiapup9?=
 =?us-ascii?Q?yJSMKMt+QlxYdppBY47BCcmXDQinoHUz6x1WFJosB/rvpfgt8ZYVOmrAS/7k?=
 =?us-ascii?Q?61KvvJhzegiyQ/yU61hQqBshYAlHSJh5m0eK073Z2vFc9HwXxyPgYD72twa8?=
 =?us-ascii?Q?BiDxi+00Pos+G1ZYBXEDOOWRt4BCG25vD7PHBBtKNZWpdljG+uQ5hxFyZXe4?=
 =?us-ascii?Q?R32sdXaKykw1ejbQJak+8TwSkCzVCKxc6hefKjTlUEg3PFOqj+KK14UGXok5?=
 =?us-ascii?Q?EjFbcJcbiDfY1QiHDPRxGdCcteGHocuJMqCV5sF9xBa2dgu3sL31pOAcZabm?=
 =?us-ascii?Q?SRdudN8dGGJpAeeDf4/OkxiZbYrLCxI+cqwHFE66aromIYo4pp0EICbAq5w4?=
 =?us-ascii?Q?4Zb6tmrLsfETgPSntQXnhRMjYuT/newb1zqawA8vWot1f3EphTvDe8CPH/3w?=
 =?us-ascii?Q?WcM0vwJxCXE8xvz/66bI00ukLTVzONYImyqY/Cwv+th8eHPv1cgYGRbmkEA?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c28a03-e8d9-43cf-ec3b-08dc5dd551a1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5741.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 05:23:16.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7026

Optimize scattered address space. Achieves significant improvements in
both throughput and latency.

Maximize thread-level parallelism and reduce CPU suspension time caused
by lock contention. Achieve increased overall storage throughput by
89.4% and decrease the 99.99th percentile I/O latency by 85.4% on a
system with four PCIe 4.0 SSDs.

Note: Publish this work as a paper and provide the URL
(https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
hotstorage22-5.pdf).

Co-developed-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Shushu Yi <firnyee@gmail.com>
Tested-by: Paul Luse <paul.e.luse@intel.com>
---
V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
and ScalaRAID corresponding to the paper mentioned above). ScalaRAID
equipped every counter with a counter lock and employ our D-Block.
HemiRAID increased the number of stripe locks to 128
V2 -> V3: Adjusted the language used in the subject and changelog.
Since patch 1/2 in V2 cannot be used independently and does not
encompass all of our work, it has been merged into a single patch.
V3 -> V4: Fixed incorrect sending address and changelog format.

 drivers/md/md-bitmap.c | 197 ++++++++++++++++++++++++++++++-----------
 drivers/md/md-bitmap.h |  12 ++-
 2 files changed, 154 insertions(+), 55 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 059afc24c08b..5ed5fe810b2f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap *bitmap)
  * if we find our page, we increment the page's refcount so that it stays
  * allocated while we're using it
  */
-static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
-			       unsigned long page, int create, int no_hijack)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned long page,
+			       int create, int no_hijack, spinlock_t *bmclock, int locktype)
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
@@ -399,7 +407,7 @@ static int read_file_page(struct file *file, unsigned long index,
 	}
 
 	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)==0);
+		   atomic_read(&bitmap->pending_writes) == 0);
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		ret = -EIO;
 out:
@@ -458,7 +466,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
 {
 	if (bitmap->storage.file)
 		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
+			   atomic_read(&bitmap->pending_writes) == 0);
 	else
 		/* Note that we ignore the return value.  The writes
 		 * might have failed, but that would just mean that
@@ -1248,16 +1256,28 @@ void md_bitmap_write_all(struct bitmap *bitmap)
 static void md_bitmap_count_page(struct bitmap_counts *bitmap,
 				 sector_t offset, int inc)
 {
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
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
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
 	struct bitmap_page *bp = &bitmap->bp[page];
 
 	if (!bp->pending)
@@ -1266,7 +1286,7 @@ static void md_bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
 
 static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 					       sector_t offset, sector_t *blocks,
-					       int create);
+					       int create, spinlock_t *bmclock, int locktype);
 
 static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
 			      bool force)
@@ -1349,7 +1369,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 	 * decrement and handle accordingly.
 	 */
 	counts = &bitmap->counts;
-	spin_lock_irq(&counts->lock);
+	write_lock_irq(&counts->mlock);
 	nextpage = 0;
 	for (j = 0; j < counts->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1364,7 +1384,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 			counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
 		}
 
-		bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
+		bmc = md_bitmap_get_counter(counts, block, &blocks, 0, 0, 0);
 		if (!bmc) {
 			j |= PAGE_COUNTER_MASK;
 			continue;
@@ -1380,7 +1400,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 			bitmap->allclean = 0;
 		}
 	}
-	spin_unlock_irq(&counts->lock);
+	write_unlock_irq(&counts->mlock);
 
 	md_bitmap_wait_writes(bitmap);
 	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
@@ -1413,17 +1433,25 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 
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
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
+
 	sector_t csize;
 	int err;
 
@@ -1435,7 +1463,7 @@ __acquires(bitmap->lock)
 		 */
 		return NULL;
 	}
-	err = md_bitmap_checkpage(bitmap, page, create, 0);
+	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock, 1);
 
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
@@ -1461,6 +1489,28 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
+/* set-association */
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset);
+
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset)
+{
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX << (bitscnt -
+					(bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & maskcnt;
+
+	unsigned long totcnts = bitmap->chunks;
+	unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
+	unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX <<
+					(bitslock - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
+	unsigned long lockid = cntid & masklock;
+
+	spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
+	return bmclock;
+}
+
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
 {
 	if (!bitmap)
@@ -1480,11 +1530,15 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
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
 
@@ -1496,7 +1550,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 			 */
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->counts.lock);
+			spin_unlock_irq(bmclock);
+			read_unlock(&bitmap->counts.mlock);
 			schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
@@ -1513,7 +1568,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 
 		(*bmc)++;
 
-		spin_unlock_irq(&bitmap->counts.lock);
+		spin_unlock_irq(bmclock);
+		read_unlock(&bitmap->counts.mlock);
 
 		offset += blocks;
 		if (sectors > blocks)
@@ -1542,11 +1598,15 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
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
 
@@ -1568,7 +1628,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			md_bitmap_set_pending(&bitmap->counts, offset);
 			bitmap->allclean = 0;
 		}
-		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+		spin_unlock_irqrestore(bmclock, flags);
+		read_unlock(&bitmap->counts.mlock);
 		offset += blocks;
 		if (sectors > blocks)
 			sectors -= blocks;
@@ -1582,13 +1643,16 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
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
@@ -1602,7 +1666,8 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 			}
 		}
 	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
 	return rv;
 }
 
@@ -1634,13 +1699,16 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
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
@@ -1657,7 +1725,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
 		}
 	}
  unlock:
-	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+	spin_unlock_irqrestore(bmclock, flags);
+	read_unlock(&bitmap->counts.mlock);
 }
 EXPORT_SYMBOL(md_bitmap_end_sync);
 
@@ -1738,10 +1807,15 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
 
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
@@ -1752,7 +1826,8 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
 	}
 	if (needed)
 		*bmc |= NEEDED_MASK;
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
@@ -1806,6 +1881,7 @@ void md_bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
+	spinlock_t *bmclocks;
 
 	if (!bitmap) /* there was no bitmap */
 		return;
@@ -1826,6 +1902,7 @@ void md_bitmap_free(struct bitmap *bitmap)
 
 	bp = bitmap->counts.bp;
 	pages = bitmap->counts.pages;
+	bmclocks = bitmap->counts.bmclocks;
 
 	/* free all allocated memory */
 
@@ -1834,6 +1911,7 @@ void md_bitmap_free(struct bitmap *bitmap)
 			if (bp[k].map && !bp[k].hijacked)
 				kfree(bp[k].map);
 	kfree(bp);
+	kfree(bmclocks);
 	kfree(bitmap);
 }
 EXPORT_SYMBOL(md_bitmap_free);
@@ -1900,7 +1978,9 @@ struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
 	if (!bitmap)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_init(&bitmap->counts.lock);
+	/* initialize metadata lock */
+	rwlock_init(&bitmap->counts.mlock);
+
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
 	init_waitqueue_head(&bitmap->overflow_wait);
@@ -2143,6 +2223,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	int ret = 0;
 	long pages;
 	struct bitmap_page *new_bp;
+	spinlock_t *new_bmclocks;
+	int num_bmclocks, i;
 
 	if (bitmap->storage.file && !init) {
 		pr_info("md: cannot resize file-based bitmap\n");
@@ -2211,7 +2293,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
-	spin_lock_irq(&bitmap->counts.lock);
+	write_lock_irq(&bitmap->counts.mlock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
 
@@ -2227,18 +2309,28 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
 		     chunks << chunkshift);
 
+	/* initialize bmc locks */
+	num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
+
+	new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks), GFP_KERNEL);
+	bitmap->counts.bmclocks = new_bmclocks;
+	for (i = 0; i < num_bmclocks; ++i) {
+		spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
+
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
@@ -2261,11 +2353,12 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		bitmap_counter_t *bmc_old, *bmc_new;
 		int set;
 
-		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0);
+		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0, 0, 0);
 		set = bmc_old && NEEDED(*bmc_old);
 
 		if (set) {
-			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,
+										1, 0, 0);
 			if (bmc_new) {
 				if (*bmc_new == 0) {
 					/* need to set on-disk bits too. */
@@ -2301,7 +2394,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		int i;
 		while (block < (chunks << chunkshift)) {
 			bitmap_counter_t *bmc;
-			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, 0, 0);
 			if (bmc) {
 				/* new space.  It needs to be resynced, so
 				 * we set NEEDED_MASK.
@@ -2317,7 +2410,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	write_unlock_irq(&bitmap->counts.mlock);
 
 	if (!init) {
 		md_bitmap_unplug(bitmap);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index bb9eb418780a..1b9c36bb73ed 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
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
+/* how many counters share the same bmclock? */
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
-- 
2.34.1

