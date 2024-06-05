Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02olkn2108.outbound.protection.outlook.com [40.92.43.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD81CD25
	for <linux-raid@vger.kernel.org>; Wed,  5 Jun 2024 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.43.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717606501; cv=fail; b=D5XuKUQxwyLt9wXfoJB7haDoYjyFUqgRwtSY0XPUSJrfJ55576vtc9aK7+4cuD+BN5XB18yr79SMVowG7Le+Z0VyhMQLtczBUcWU64mFApguE0Gdki5UTTPcFR74Jrr4IM1VYqjdjC4fsxqUllPQO0Dmdajg7V9IPIRnuLFlZMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717606501; c=relaxed/simple;
	bh=thiVe8Qss7qDUaUlqc7xK14lHs+1l00/l6RBL00NDrM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=M/Tdw2O4rUBsE1k4j95cRMxXuoBSGNQgExc6JH9Eafxmj6ohHoT9fjhv9QHanE4C4SwFFtVqsTTQCxm7ticbpA8niqFx7g42+uGhda40SveRuJ0/fNrvDlDbQNDrZXkKgmlcKkMlXJJU6kG4u8ZehC9yhYOIbPXuQWGkrm8uGnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=KpzNjR6j; arc=fail smtp.client-ip=40.92.43.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="KpzNjR6j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOh3zIvJ3HwNrqz5iA6iwSSL0hvcaDQ31DHMhYfDd3eJJ5ri+UoVplnJ8974k5n7S7cC7RfmHWX1mNhNL4Pr7eILD0iN5pWOXfB4pkrJChbWgh3XttpV7DbtZzI8SiCvJJXnfvsrZG2PlF4i4X6h0yrfy7B9SxG8xWKMXy/VeWmhcabx2kUjayGgaoExOaxuUlqGTE+gAGxQlBoTn0kz133cQIgLRr3bWKotNN073VTDN+S5q+ImStTR0/Ro3S6nLWW5Ndk/r9MY4bwQYRzxRuL6UrF+4j6kSG5JHbclNxKxpbpZBZs6w64whVix8hoiudNa+PjbOzgrS9O8eiy2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PfLIHG5n0vsNybvk1Y4nxE0MBWEiF6YeSttEfp+Ys4=;
 b=n7uxzsFz2MXEtlZzZjHHbc0h0f9WfdD+m2J3JIsgLYoHGvcsUcJYmpDBeym++ThOI8tIRA1dvDwksqTFySm/hMixiWjSeyMDYgn9wT2LRbrT2EBpcc1JNT8ktmNxHF3+B7dcN4JzzgNiPxdahW6RYDHSWcS4t8G3iAiq3sd5yBfpGqi5HL+A5qYWjQplfd5rBICt5kVF9UDxpWQIU1l47RmelC2zfTRIc/JV2QryA87dgLkrFv6aWZBxEbScduUx5Nei07QyazzUxZP+NWbVIqJ4gBUpyrTAUDfgsz86aT/CzWJaZHyH6Yyvx+qvVG9g/X8RPYlfo+9tBykEpaPavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PfLIHG5n0vsNybvk1Y4nxE0MBWEiF6YeSttEfp+Ys4=;
 b=KpzNjR6jetdERJPYDcWNJA58zV3NZMkWTbN5pt5CeanXhljiUscn8lY2F70lKoSOQUZgbXDVcY2QyIGu2ygbKTETbKb7hl+d00U2OOgMVGfPTFDmZvVdVPER04wqQMCBgnfoI936mzJ3ZWJvK/5F3fvBY7C5P1iVUzllRct/hLVjl1eFXAz0xGtWdfRpYJQr909CR4L4aM0plowOLkHJ9UdWg0ApbXWFqkXz9pivk8gInNkNRh54f5a88x22mbK954LLNrgLOmMKkz2cKZSS/jgYwbqvRmd5fInrTdY+/OMRnp+pFAKqaFxByK+w46A9Z71RRfnw9a3H8gAK6aVMMw==
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20)
 by CH0PR10MB4843.namprd10.prod.outlook.com (2603:10b6:610:cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Wed, 5 Jun
 2024 16:54:56 +0000
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1]) by SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1%5]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 16:54:56 +0000
From: Shushu Yi <teddyxym@outlook.com>
To: linux-raid@vger.kernel.org
Cc: Shushu Yi <firnyee@gmail.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	hch@infradead.org,
	Paul Luse <paul.e.luse@intel.com>,
	Yiming Xu <teddyxym@outlook.com>
Subject: [RFC V5] md/raid5: optimize Scattered Address Space and Thread-Level Parallelism to improve RAID5 performance
Date: Thu,  6 Jun 2024 00:53:42 +0800
Message-ID:
 <SJ0PR10MB574112619D4A62D4EBC891E9D8F92@SJ0PR10MB5741.namprd10.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [6Cl9znePIkqXIAU7fGHSCXq/hI+0xOua]
X-ClientProxiedBy: PS2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:300:56::20) To SJ0PR10MB5741.namprd10.prod.outlook.com
 (2603:10b6:a03:3ec::20)
X-Microsoft-Original-Message-ID:
 <20240605165349.1088873-1-teddyxym@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5741:EE_|CH0PR10MB4843:EE_
X-MS-Office365-Filtering-Correlation-Id: 812e2944-5d6c-4325-f855-08dc85803a76
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|440099019|3412199016|56899024|1710799017;
X-Microsoft-Antispam-Message-Info:
	FYGQ4Yznf80tk86pJTnmzmdOq7iebT/EQ1VTCJ+WWf2UYhGvvbwvD5JkqRMvRD+cn955D7gY4v+6WoH4P8Nsl09vsZlQUntwNyDsXZ4883cXoixGlBxQUBa+RsefLOrTcSC9bGVsV/RfDGx85+J4JHPyeW6Pt/JeqiFbk3DXVsuYWvzhxERy/agfPxRIVvGGrL/DxhXr2oWrJ2oJagaWgXOPTaOhAAilPINIyh8fyIndr72GbPjj0ANqF21GJ7dTjfX5IehkgkGU6/S3jA+n1JS8m/lZyQxw+j7huRn/ZSEU0sjMN0B2iYE1I9Y7xk9EfQoVQcFeO7EaargmQQNRzFe5oNDSUlUMioPkwJuF5XHxAEbbk9FT0nTMViYGcKnuQvI6QHL5TIpgUHFb7Z6MQIrDnMMaHQL8Jj52DTpZQp89O/cUBzEMgxy2DMsvvapJb19hCjdCGRknOd+n0uqE2+M+anZKofUJoBWuJuQvxsdXnedR2Q1IJXg6UjSLj+KxZtwGihBEStgVz9tQC7ybL4dbbCeCJQwxqCOHyxkC7hTVMq/z2RqvuF+4LO4sKyxPOPU5Xfb4U0lrhHzeTJQ5ogRzlk8CKy3fqd47TjCCpqw1XOS0TfQdBURA+y03Q4xWdrzuH/1Ysuh5DxYnQ9z9l5kH5W8jYf6lHIQlAYuhUr8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y3pNcZaqXhzyliXGgxKaE0N3O7hdZlZZ1PlBz2DPu5I+HBMvLvl5Z0OFGsZI?=
 =?us-ascii?Q?XzgNWbvI5GhIh0muux70eNRIEd+tzZrPx5GtiWJRsjT7u/NSrdW5D0WPIPwN?=
 =?us-ascii?Q?50nvNbY34PlGfHtU+LYkwID1YWb5AAMA1s/iQOrAM41HCkqwfboDVa457ARg?=
 =?us-ascii?Q?p8d99A29mIOEVAqvmAHXPqwaB+KtUBXTL7YKEUuSaRlKWwf7KjhiWwXcpxa9?=
 =?us-ascii?Q?oylzU40McM8niT++WEX9kqbsgbm70mLHrzV69klPTWaWxe7G7+0G9MffehrF?=
 =?us-ascii?Q?3lIO8RpqzQzmTJAuHALgL25leJCqSm3xF9Uck9fDpwWOwHzgtFESOpnB441p?=
 =?us-ascii?Q?5tXHdJw2+3R3sigVlx5rmFYzyqQoofS7j90rFmWRXfFp/fwO8wNupvpF5q2U?=
 =?us-ascii?Q?/y4G/M+7cAS1aJxijzdmWmG7hzMvRBX3w4MTQBHDtdCES9YB3EYwZPycFGjX?=
 =?us-ascii?Q?Js5fSL7XXmuzS/TBAN5XsMUnXWf3LitwNK+7YeFY67TLW5xb9MUrWtLhBt+9?=
 =?us-ascii?Q?YdTxezMkIUI/RR6yG4pw5zy9tT5qjqQcPud82VVGDUx6DHf4j8CmkypvC06R?=
 =?us-ascii?Q?6VNZEDYgiCR4ell88GZZwDnfrRraOcYUURIUuoNBKBNMQgTjqmixdbdto3/9?=
 =?us-ascii?Q?jdTur3kCmfcLZ6uX4yoK6QMvrEKVtuaQbJImB42DXb4a6imzMCknQZr2RBR3?=
 =?us-ascii?Q?xcWg8TV155vyE5zsRvy1f2Zro2Y2QHg2XC3snjcpIV85wSDuobREFPDj5R/5?=
 =?us-ascii?Q?eY2TE4n/BcLQhXdbwMG26WAmpKA/qBzw6y3X8kFvWAbBdI/9QowALL1zeERh?=
 =?us-ascii?Q?8Hxvf7mjJ//ER0RmlyjBjWIOA3MruTD4ghK5wBvayIFTIJB0xFr0uqpnwjDa?=
 =?us-ascii?Q?hHL5dDHYPbVe5Wu3atINgp6gzlKP95FDWocS1Jz9hA/ZEaBpeCfVHt+uac7p?=
 =?us-ascii?Q?onGSFciG3zQIPOd6X9KJLn/tCJg1KEizJuFltiMrIWRfo1subpYr3DcmRC17?=
 =?us-ascii?Q?E0nJVj/V7u7lh0ntN53M0YvmSa9c8VBhUACRsrafzbFjoGz1jXsg22gNW/oc?=
 =?us-ascii?Q?TgYDjx38uxdYqXZG1AS3r2v1oCU9Nd/fjIsAReYZMHXp7L9zV4G4v/0St6tm?=
 =?us-ascii?Q?cqgpVL31KCeb3GH7+EACoRV7HqmjlJqYqEDHwJWmABxVPIGIXcBRYcnCH8Vo?=
 =?us-ascii?Q?S+YOgGxsH5uFkWTmFdAEwbE6/vymAr31rOKb9I3H76N5RsQ7OeAwdSc0aNY?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812e2944-5d6c-4325-f855-08dc85803a76
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5741.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 16:54:56.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4843

Optimize scattered address space. Achieves significant improvements in
both throughput and latency.

Maximize thread-level parallelism and reduce CPU suspension time caused
by lock contention. Achieve increased overall storage throughput by
89.4% and decrease the 99.99th percentile I/O latency by 85.4% on a
system with four PCIe 4.0 SSDs. (Set the iodepth to 32 and employ
libaio. Configure the I/O size as 4 KB with sequential write and 16
threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput
went from 5218MB/s to 9884MB/s.)

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
V4 -> V5: Resolved a adress conflict on main (commit
f0e729af2eb6bee9eb58c4df1087f14ebaefe26b (HEAD -> md-6.10, tag:
md-6.10-20240502, origin/md-6.10)).

 drivers/md/md-bitmap.c | 197 ++++++++++++++++++++++++++++++-----------
 drivers/md/md-bitmap.h |  12 ++-
 drivers/md/raid5.h     |   7 +-
 3 files changed, 155 insertions(+), 61 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0a2d37eb38ef..f08d3228b305 100644
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
 	sector_t csize = ((sector_t)1) << bitmap->chunkshift;
 	int err;
 
@@ -1436,7 +1464,7 @@ __acquires(bitmap->lock)
 		*blocks = csize - (offset & (csize - 1));
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
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9b5a7dc3f2a0..818ce86f4b2c 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -496,12 +496,7 @@ struct disk_info {
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
 
-/* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
- * This is because we sometimes take all the spinlocks
- * and creating that much locking depth can cause
- * problems.
- */
-#define NR_STRIPE_HASH_LOCKS 8
+#define NR_STRIPE_HASH_LOCKS 128
 #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
 
 struct r5worker {
-- 
2.43.0

