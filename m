Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12olkn2055.outbound.protection.outlook.com [40.92.23.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EDF15A484;
	Tue,  2 Apr 2024 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.23.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712077594; cv=fail; b=LEhG8VoGW6sxHdf5i1vDHrgVq1kG2W6Yvu1M9AGJc24OXi8DFBbj2w+PDKpsBm9JMVC+lofNK+IYL15ql1vuuYf7qACEJ2areBjBDQxUlE2xE6b19b19JnTJ6qZodBdp9MTkYgoyB0Y8PM3vom5C9Lao0k2uDrET5TeghVTCUsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712077594; c=relaxed/simple;
	bh=36jTXw7X+H/1TxPx2yO/aUYpGueBr4e/KAOh5k8RRd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hy8oi+ktfTJw1vt3ZosJi5mvTtdjsYmLrDxJLIn51wIhyy3n3NI1bBZ53KylVmpph+nd1kmMMBTGGZw+nQJbfHP3vl/t4mHxsmj6+vf+oXbe03zIXkV132psUWpxAn6dnxmufwWmED8miknQvgysrclG5cE1gvrGhPZNr0Ammas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=HIIKAVYR; arc=fail smtp.client-ip=40.92.23.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="HIIKAVYR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPTbRYgYCFrrvnLxlhdP5TB3/G1hB8kwLdQtjNg8ptxccVLeZ+rjbxpDkas62Q3lhRZdDd9wrMxObCUHwUoqL5Wk+uAT9vMbGZ5GHV6I4lmNzKU+hmK1TioHVNcLA9TgGmiyZszKg97uzwpTt21F5m9Z1uGwogqdBQKgM7b0+3L7tvvOG95U12N2ZHfrFezQloSowmxCP6g0TSKYxqOE6WmXRu8jnsXkyhLFoMyXPJhqsjyXP1LkI2Poptvvztsg7ooPE4LayzQ2hSDt6guNmaOjZv5sdwqshypQKikJyKLd+D8vBAgwLCTed6tvrqJmJ04BNWgc41Y++czxpFvOIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BDUhqZl7qNRLCF5WYgdGQzcLobAqqDUb3c1dTTaKHo=;
 b=UxXBT4rcPaXTIjnbSO6erpd6+oAKDSUbWXiPdGLXa8+racJhArjabA+W9qPf3RgLE4i3bFRCpyVOMfPhmKsSiFlvuJbdLzZeFhtc14+JSG8n0PHuqfVajtyCyFeBPAXVjWEy0P3a6MnDe8hD7D+hGA2h5b1xvJGlw/0OByRhxBVlFCsdVUjlYNLRHQpA2eGy62xkmCYkyLeyegxUsMFvtS+nKmbthzYueBHtebvlvtWTUc+L4+z6n2EdCLDmiQKC+dFp/XlJ6DMRLEHgbAnqX3Mk7w76i9innRUenDOMZNk57017EBoK+nAodGOYvQo+DAoOH4TJB+bO2qvKQAFzTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BDUhqZl7qNRLCF5WYgdGQzcLobAqqDUb3c1dTTaKHo=;
 b=HIIKAVYR2znYKhVIC/HaEwwkp6cyTugroVErYgMwmWJQC5Npw2FkDFh4c+CS5B+I4/MVYOGtJ7G5u3mG1xkbW6SKQlap+AnMuO3UroASMnQPXaOFZkOixSOouI4d0ltJRq5v0nsVVHc8vKh8ZGAVwOGAob1eTzxsrOwxQltcl7jiLosaoo/keFUQ0zZSsrjcQ1aGkF/dD3B7q1di18oG1E1N8IvqkTckrgDP7mqvpGGJbxH+WiS2/t8CHNJFMJWEU/QWQauuqtuoxC0n3AdBcbaEqTbPdHDURmtPGzz63KnCmIyt84Vmb3zfOu8jLmvt0/R1Msxm+XTJUXo4DARpXQ==
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20)
 by CH2PR10MB4149.namprd10.prod.outlook.com (2603:10b6:610:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.42; Tue, 2 Apr
 2024 17:06:29 +0000
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::7ed7:f9b8:da04:31e8]) by SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::7ed7:f9b8:da04:31e8%4]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 17:06:29 +0000
From: Yiming Xu <teddyxym@outlook.com>
To: majordomo@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com,
	firnyee@gmail.com,
	song@kernel.org,
	hch@infradead.org,
	Yiming Xu <teddyxym@outlook.com>
Subject: [RFC V2 2/2] md/raid5: optimize RAID5 performance.
Date: Wed,  3 Apr 2024 01:05:47 +0800
Message-ID:
 <SJ0PR10MB57410151E68680D90A97993ED83E2@SJ0PR10MB5741.namprd10.prod.outlook.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240402170547.19353-1-teddyxym@outlook.com>
References: <20240402170547.19353-1-teddyxym@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [IGtahSsR5xmGhBDU6RSs6d75X7zWGvmZ]
X-ClientProxiedBy: KL1PR01CA0069.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::33) To SJ0PR10MB5741.namprd10.prod.outlook.com
 (2603:10b6:a03:3ec::20)
X-Microsoft-Original-Message-ID: <20240402170547.19353-2-teddyxym@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5741:EE_|CH2PR10MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: edc511c8-c03c-4cda-533c-08dc53373d34
X-MS-Exchange-SLBlob-MailProps:
	laRBL560oLTY7XkYJebgTxfeg6KXFLBaDAZcSnsSu5twrf+nT9T50CsstM4TF03dLNYMI1AwvFyYTJQwKgAToMJ9r0sNWx2/JCMGfVFli0ZhpLPKFfmGpR1andfqMGyvYDuEds3sLFjJtHkfOiCnsx4nc+wVKI2XsSxbemw5R+j/W8MAmKr4xrZp3BHQHVTGoqHG1bEtxGVsGrKTVbGMDwW67v4EQSSyolpqHCX2Rnof5TEiQtc9bGDySnNMAsL6bxD/HCjwQRuu29AA9NbTg350r7Y+7e721uZsTBCSxjPndZHZuqe7HVmrXYrQIX57EYCXd0+ugDW6/r7wgsOOlDk5yenyF1vhlBwoWpvqOKzZmN8O4hxtKp7OSLeLLTAAdV8602S/fLtzfyGw43c6xMC2z4qGspyBxKhkSP/ZV1lk8YqmhQLZTG0P7SXhH0KfuTg+tNxcVoxdVZ7pDrZAPowhDJrR2VqPkbcMAXm9wlMhI8ADRhGOb7cssyUsgI9GE35/VmET+AJDy2yI0JpySoVO8xy3sjRuE3b0BgR73Lqc1RLFlALf+PwzAEYaIf1tGWwUAfrpyyJ3pIgA4+FuD9g8M4EUq32Ct0jeGrix7tMw8OywpzOXKPn+/mSYNRcow0dN+FVpW4zCUdAHMJda0BWVkam5IYaIL1OWes9S79PKX2YzbwS8R5M97k1owYEnluQiOKyQDzTChVrKSWajRpPMmSEOVpDbpT4RTJmyAIHxKAmaEedyCR5IYKijFTjBmOrUBXNftsFkr3WwmKfWJXmhOIocWpUA
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kpR3hLpnP0KQGM8KNJygXde8skHt1nF31vCAW3zhUHYTF0uv/G//8GtQF5PLelVNcw9QsrNzmxygwi0r++3PP5rH0VsCTG79DQJHXU9w7WqcPR0GWtNo9VBFSRU/4bdzNHkdmvfu0THljHMkABjjhZCoWPclvkqyDKYUJ1aQSHtyZMnEHNX+53XbjzKxpM9dwuJGHQr3EnA/fowp78aLBq3egBWbgG6bSDo2bx/rKkeiUrNrMqhlUFYvyK9GjlZZS6FLVnnjBYuJ7/tPvJWPu8c3GNRryz0l1iJcAyW/HTTP0NOUgpFJib1QXTOb9eZufcyVSDOMxkUW+4VK/ACJ3UgeXc274SseebbM+Cp0LG4mXi+Uw7XzQLJ2dfcbr98/Gi3OmTBKabqXwyKA0V6U+5lSi1MiiTvxuzJmqQekPJ7fbV1RFHFY3sARK8zwIbn/CGZyV8BfpZfhrOjKJf51GczqaTPMwBAxJ65trK9VfuTfwLCgeuL88gM3Eek88oqAgKOhh8yM3w97UXNSWkyq533nQUBRuSHFgwemHWJTsKIrRrldRR7GiHK/CORu79eTARKrsgn8hwG9IdRTheyCFIsWEGIIuHW9qba7Z13xPBuP3X4ttDfv9QOUyprl2rtqSWj4bChj2g8cijd6Ctj0qwUu/G9ooqpolnqSyLLkMOc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aJHlleg75FzFdzVnwawFfe6sFLaOduzuBxPxo6LLmBY4cubxEvjEcyiSPWAY?=
 =?us-ascii?Q?GsvnaIlCeAcDXdWEgNfJdRSwYoC5fvs9sd5AkyUhmpFqS7HW9k03BK+auT5T?=
 =?us-ascii?Q?RVcWo09AWyv4BDw9CacyqM+X9GOKXXBQrNPpQToB6xZKw98Z3nXw/oKJwtsi?=
 =?us-ascii?Q?sis81MhrF9456NCfq5xjTx8Vyx2zV3BxFf7/fiJVh54DeWlaI9IOsA/W6COG?=
 =?us-ascii?Q?/DtAyTwVgo8jU1K/zuY1sWuQWhbSSvhEA7sUtUzyKuHxHcj+t3AutksOGxIG?=
 =?us-ascii?Q?LgHhgGs000a+9yBXE4t3x9YXUtu928cTcf/yGDKQYtdSDnygil+u2UasvL/t?=
 =?us-ascii?Q?/JTl3f8bwO5CA7YwDhZyIFGUjhsdft/5ogq2GywNKiACiQlN60WdQ4d7qhpT?=
 =?us-ascii?Q?ZkffZzvJN4ZKScTvsLJqq8u4MutNYGpTiblz0Ig7QcfR7rNxyUFsQGNxjrXC?=
 =?us-ascii?Q?l7QFeNPO6/abfk97H3nMdnl6g5UFVL/Vj2ZKVgH93X71PWDbnA7MxfBvW5JY?=
 =?us-ascii?Q?zcksQ9JNgeDTqUuZHiLmbbLinXAy53fMyTFfIyvAL8snxHEt/C652IczBA0/?=
 =?us-ascii?Q?HkigOVzsU25zbe8A/no+LD+5lLECGLqR7zrMcBe0cWLQ/qKZHFQ2wSK4WpoI?=
 =?us-ascii?Q?a769VTLwoEjgo0g2bByKKPnPAdCWwDyC+mHaGImx7116lZg2qOPQEkguZ9Mn?=
 =?us-ascii?Q?8Wvt56fSLo2CE5MswjcCOyYqbAjALXwABFaB4WVBJcRfQMakR738UMURyM35?=
 =?us-ascii?Q?dTI+36cYlt1Ed58piNL4s1rbWaLEGY3c8xHJMx4AAoh3lW+0zRxTo92rpkzX?=
 =?us-ascii?Q?2434Zwp6LR4AWeC6/X6IxHk/18v70Qzg+yT++DSoqlI7qET5+zNd6aH3B/Z2?=
 =?us-ascii?Q?EIB2rsIFXn8fhrzJRdnph8VxhFdMYSp54R2+Q3hDK+XiDKlKPvSD9XBUkpwP?=
 =?us-ascii?Q?vbEiIndoCp5eMfXYm7VO2Cujh5pEP3cilK5PDLG/xRl90BmnU+hEKCSydsbA?=
 =?us-ascii?Q?Rwpmq9V/i0mPb7IoVPEG2nFxEAj0Z1m7b1//WxF8gZLN8UlmvaupzJtpa47P?=
 =?us-ascii?Q?z/2TR8s8RNxr8nnqF5OmGF0xN4S7YS5r8vEM5KUR6nPx91saeryjALftckzT?=
 =?us-ascii?Q?IskkOdbrRxeGDTbpEFbM+OXsYn57iE00EPk0w2QLAaDgf/R0vWLIt1nJKkdB?=
 =?us-ascii?Q?C3dQAYm4tvHw7mYx1KzQugtKhhCcLdtE6x/JJX8u5aUctQrxOC380tRztno?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc511c8-c03c-4cda-533c-08dc53373d34
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5741.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 17:06:29.8348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4149

From: Shushu Yi <firnyee@gmail.com>

<changelog>

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
(https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
hotstorage22-5.pdf)

Co-developed-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Yiming Xu <teddyxym@outlook.com>
Signed-off-by: Shushu Yi <firnyee@gmail.com>
Tested-by: Paul Luse <paul.e.luse@intel.com>
---
V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
and ScalaRAID corresponding to the paper mentioned above). This part is
ScalaRAID, which equipped every counter with a counter lock and employ
our D-Block.

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

