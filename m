Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04olkn2023.outbound.protection.outlook.com [40.92.47.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0894C1DED4F;
	Tue,  8 Oct 2024 07:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.47.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728372306; cv=fail; b=RwryTfJDN8UTJ+k/Tzjwb3Gr+ABDIVGge1FrOYVYa5h4FFG9RT6we9nhQdxfqVxbDxjkL1WM3PDdxByeO8o+tHMtKZFoqfAFyjaAB2RVABrT1Th+CDBxIXZPtfNK58Z1DqEBq64sqdvZu1rxEZidEpiSBiiikxHxlyiA53ljiyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728372306; c=relaxed/simple;
	bh=2fLf2xOr5zcS8ZxWziYS5fEFufUhQa7L8AkHlkDywAs=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=O4X4cyfpGgJCMeRQjLUZ7JCbPPWyZbu7WItJvTI8j4GFdZ3Dplj/0ZvBJna0+gf0QR5D1flWCSM0I8Puv6Pcq2FUOuYsB/BtpdUROp4WORmEgIpUwYH9q4BFNAGMfjeOJHJLyQPTtUZ7dHinI5pdBEGinEyTxHFgWVbGUJvPhrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=obnbZP7M; arc=fail smtp.client-ip=40.92.47.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="obnbZP7M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p47m5YTMd3C/8catkMfLCZP7yvjaRzXZbf1GU0RiatxaPk6SbgfvsRdm99MSS0oVVI7sPUioo6SXp2eEWvGosZBVopJLwppj4DXaPbg6QWdVXWGXQ+jb4jTRsl2pBrf+KcIpinMcP9VVpLSTPHInOgycG1YYHIp17qdZazgF//2v9LCvTFE0146eu+6AQVM8mLatKzR302FFJ2/bhmh5JGflqbKwRJI5GZUgvGi42rFXEWESmV8BbBnS7imM/GdlrNC1sq844ol7Pizgk/vOi8jidNLwuBRvvgO4eRwa5Aws+ZSFQMzUvSYiuVfufug88qwUYlm7/PG07LILz1qlTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2MC9+U2KpreO3LW4mBXSGP4MtSljsP+O3MaiY/zphs=;
 b=sScMHi7Es86z/5QrRgTm842/2SU4xa0ALLR2awAUP61DbsAvzQ/SBBpdvpC5PV4m1qvCZQk3u0gOpeYEPwNr1A6nRFXMt4KnApiaY2VlT27xeJp3z4Rc9oQBilYtIar4VvP6ww5z0Oa0LmDEXjtHADuXnIXHcxHUl4naxXYNLSopSSOKDD/QxJw16s7zMVMTMGl6onr0jM3JDKIZD7btjy8rR85Sfa1yQvnJGkLa7On8qzDRUaLJ9YZKjbmWrerHSd7jpY+IlXNjBrxoRN4+x03LnR+XxJO5u+ywa+oHImxH63DK8DrbiDPXcIWZcbJOBYl47wohC6kADnYvafTeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2MC9+U2KpreO3LW4mBXSGP4MtSljsP+O3MaiY/zphs=;
 b=obnbZP7MNuWbCc+sG9ecoONqwh8wmou2siQgUJ/oDBTHteZ59vw+cOG36CULqwCJsG1rNhKsuqb/YLFmHWVo1kcKCugS5Pr9HRP7CbaJMbHRivCzjYBC06k6lIY77QGLyJXlIjWxwMrg1dvQWeFWIoGghlw2bif7Tn5+IqRsgF6KS0np+l7jdWRTOXFL+b8EpnqkT0cIJBjNbWC+vY83yGSts++vYDta1NBvvvzsjyMbUgTt20IVAOlR0D1AdRyNSxEvCf6AA619T7I/NbjwuOHYaZbBuerunC/NkQS5cBAjdbaHIFsDD8XwHG6vfAY3Kyha0svOrExDRHO9LJxThw==
Received: from SJ2PR10MB7082.namprd10.prod.outlook.com (2603:10b6:a03:4ca::6)
 by SA6PR10MB8134.namprd10.prod.outlook.com (2603:10b6:806:443::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 07:25:01 +0000
Received: from SJ2PR10MB7082.namprd10.prod.outlook.com
 ([fe80::2cd7:990f:c932:1bcb]) by SJ2PR10MB7082.namprd10.prod.outlook.com
 ([fe80::2cd7:990f:c932:1bcb%6]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 07:25:01 +0000
Message-ID:
 <SJ2PR10MB7082DDA3ECBDD9A7A649F558D87E2@SJ2PR10MB7082.namprd10.prod.outlook.com>
Date: Tue, 8 Oct 2024 15:24:54 +0800
User-Agent: Mozilla Thunderbird
From: Shushu Yi <teddyxym@outlook.com>
Subject: [RFC V8] md/bitmap: Optimize lock contention.
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org,
 paul.e.luse@intel.com, firnyee@gmail.com, hch@infradead.org,
 Yiming Xu <teddyxym@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0173.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::29) To SJ2PR10MB7082.namprd10.prod.outlook.com
 (2603:10b6:a03:4ca::6)
X-Microsoft-Original-Message-ID:
 <17bcea2b-ae2c-4380-88d2-608cf2e03898@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR10MB7082:EE_|SA6PR10MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e5793d-0f32-4d09-3a34-08dce76a5200
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799006|5062599005|5072599009|8060799006|461199028|19110799003|6090799003|440099028|3412199025|10035399004|1710799026;
X-Microsoft-Antispam-Message-Info:
	QEL+6/YnvAV1Qh4b41QWPKscuyLY+Wd/RNJ7HImkrEnfV/0y7k9MKtkYkMye/ihe8Qu3R0uJO/RsSlwwK4ZVn3B2gFtEY+HCxwQGXJ83slcWPfKAYyOcQQWvO/PYaCgVEqiWA4SyjBs9qyxBLiL0POc+RXHlCU5iSCIFziVwregmK81V+pN8MeNw180HOay4jSr6nXk3bpNChG+K1Sel+jGF+mx7DfcQd5q7wiJdcLiqyWtZt1rOz/MGxNhILaFcTqt+XxNbMdAwS55AT7IZ8eA0EL4or5CAmH/hi7CdDg7wmbgH8WMr3lbv9SherKDpH1W5oCEHTxCbYs9SZm8V0j/j64qqQKn8LSr6vnQrBKuz+qZSALdEHHtOJ+gISGV+bdJdmzsljydWPfM2DQyaXeu5B6S2u4ppuvLxEI3zedRI2CG6yaPnp1BNKOUHpcLc0dhLF8wRuFNxmaPw6i1PmByTIjayFR3zPJHZCwcmffXS0yNsnYtZcDs4+o/kcyE+F1zVaH4pZq/XKRaIFe7/BjXd9GVn+SX6cDLNLjcpsGM/0Dx9H7NYVhMAMoaS+6GqxEnOljkofL36qfgvKq/LI3ZtcWR4PQ999nPBRkzDKn8eMktrXVuypa8dd3hCfSBA60wDwJxwy7PxYkWgwHjy8MT3n8IWaaQTynffUvbWNvAXw1wEuXPOjJsm8l2y+n+OoLQ3KfcgEUtOYLYFKgYqgLS5/ehX8tMCxKjdu5zKG2XqrAywfYuO6Ij8NsWuCjKcGoik3wso49S2pp/pZ4a+HeHvdCGVucc9NtUzqfnCtU3H87K0Bdrp9eF1OPESIGyznrSHTmp6g0GHuC8aL09pJ2Lqdapj6+64CEWLKHil/1Yc389c9o26p0RafdKt6H+2
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2g2Y1BQUno0bk9uTm5YTnNXQkROZWpXNXJvLzRJMHZtc25qSk0vOTVwenh1?=
 =?utf-8?B?SCs2RU5kMWxDTE54dFhRa0RiVDFvNCt4QVV0RzY0cXpYN1l2d2RjL2hucDBz?=
 =?utf-8?B?aUVlYnNYbzFHeVJMMzJlSVhIWGxCdWtReGpFdFUzWHNQbEdmSzI3VVlXbFF1?=
 =?utf-8?B?VU1EQ2s5alo1bnFJMHMrVUtNeXlnenJZWGF5R2xyS1pLbDBjME0yV0ZMem1s?=
 =?utf-8?B?QXJuVEllRWRmMEhNZWpXanFJaEtpUFNZZUlUVnpxMFJpUkp4bVNSc2p4OVBJ?=
 =?utf-8?B?WUlKVklpMWVmTHhITnR6ODZRSWRzRnJmNFkxdFJ4TTRwMDZjalJDcTA0eDBj?=
 =?utf-8?B?WUM3Z1k4eVVEUGJMK1Nla2RXTVNTUVZRK3lxTmRVc01kK2U5cXJudGhvSmR5?=
 =?utf-8?B?YkhuNEZKSjlNZHFib05Fb245UEUwaWtJZE5zbS9LNHZ0NU5oNTNJTmsvR0ov?=
 =?utf-8?B?M21JSmV0OEhocC80a1RKMUpqWGlVQ00rSDIxMHdxd0ZROVdIcmh0S3lVdEdB?=
 =?utf-8?B?WitmaXJIejhyYlJYNGlrbGgxU25SZ2p1eW1WeDNyQ21VdlZNc2s0OVE2RFp1?=
 =?utf-8?B?ZDB0WS9tSTh0U0ZLdURYc0MxUVZtU0d0K2Y2UzlFbE1nNlExNnRoTm5kMGV4?=
 =?utf-8?B?UVVxUmJQWnFmbmhQcXVuQzlCYk9RSmo1ajB6V1lpdGNxK2FwMlVDRi9vbU84?=
 =?utf-8?B?SU9aamhDTjVpa2JvM1pJUEdFR2ZjMnFSQWkwSWFvZ3RBSGpVSk1EMnJPMTNn?=
 =?utf-8?B?by9jYUYycWVna2Fvc0I0QnBaS09pTUk3bmlra0Vpb3hJZjZPWnA5SEQ1amZ0?=
 =?utf-8?B?U2I4Rlk0UENEVVcvVTg4MlhzQWg0K0xWUnlleDh6YWxWaVRHNkJ5c0lTcmhZ?=
 =?utf-8?B?cGxEVXpHb2NhYS8xdlVadUxSa3VTeGI0ZWRYT3Uxc0VIV2YzclpBR1FJUDhU?=
 =?utf-8?B?dU1vNFRpVC9Xdy9CMHFhR2o5dy9EZFh3cmp1RFVrK0FodW9MdGRCazJVNklH?=
 =?utf-8?B?MGpxR04rY0sySnkyMWJTS2QrcmkzeEhQZTdHMzRnRVVGK1lDOE1vT0NybjBt?=
 =?utf-8?B?NkZIMGJYMEJrYkxFOUVHaVhTajJHUDVGYmZ2OXpLMEFNQUN0OHZQdjU1c1No?=
 =?utf-8?B?RG5kdmpXREI3ZGljUGZ3STVxVG1zYTA4b0t1ZFYwK2EzZThxdlhJcHRDdXZx?=
 =?utf-8?B?L0NBTFFnaDR4R0tJY0o0dTZwZnhJc0lJcWFzbTVhVEYycDB4Z21Jb1RWMWxR?=
 =?utf-8?B?NzUxUis2eTlodVVJYlhsa2NPVElYUmo0OUltNkVoZ0thTWU4dU4zd2hNTVRl?=
 =?utf-8?B?OW5JVjZkQmw4c0lJSGRRQSsxd3gyN1F5Rkx3ck11Uy9OK3QzUTE4MTRkdTR1?=
 =?utf-8?B?VE9vWkdIUkhBdE9YSXNHZk5WR2xKaTlySytQTmxQVU0ybHE5V0R0NVR3bGpv?=
 =?utf-8?B?Tm5HVzNMaWt2Z1JUSmVOa0hpTVRBYXNzSXNRcUpGSkV3dXdsdWR2V3hIRXEw?=
 =?utf-8?B?a1Z2THJ0U3drb0ZML0FXcFF0MS9HU3hienVOMi9lRjlkOXBNS0VRb0VrMFJ1?=
 =?utf-8?B?NldrRWp0L0QrLzBvZ0NtU3dINFFhdmE0SFlzcmQ0amZ1KzQ3T1gxSWU2a1Ey?=
 =?utf-8?B?VFg5NHp5VUpHazFuSzFZeHA1TUZZOGtXeVRtSzQwT0RSZHdRN0M0cVNqUXFo?=
 =?utf-8?B?MzVPM1V1TE8wanVZczZsSGFRSDg4cVdnSTVPa0g0Y3kvOHRscUpaaUpRVFRE?=
 =?utf-8?Q?Vmjpn9ZGAOU4dopCS0=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e5793d-0f32-4d09-3a34-08dce76a5200
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7082.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 07:25:01.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8134

Optimize scattered address space. Achieves significant improvements in
both throughput and latency.

Maximize thread-level parallelism and reduce CPU suspension time caused
by lock contention. Achieve increased overall storage throughput by
89.4% on a system with four PCIe 4.0 SSDs. (Set the iodepth to 32 and
employ libaio. Configure the I/O size as 4 KB with sequential write and
16 threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput
went from 5218MB/s to 9884MB/s.)

Specifically:
Customize different types of lock structures (mlock and bmclocks) to
manage data and metadata by their own characteristics. Scatter each
segment across the entire address range in the storage such that CPU
threads can be interleaved to access different segments.
The counter lock is also used to protect the metadata update of the
counter table. Modifying both the counter values and their metadata
simultaneously can result in memory faults. mdraid rarely updates the
metadata of the counter table. Thus, employ a readers-writer lock
mechanism to protect the metadata, which can reap the most benefits
from this condition.
Before updating the metadata, the CPU thread acquires the writer lock.
Otherwise, if the CPU threads need to revise the counter values, they
apply for the reader locks and the counter locks successively.
Sequential stripe heads are spread across different locations in the
SSDs via a configurable hash function rather than mapping to a
continuous SSD space. Thus, sequential stripe heads are dispersed
uniformly across the whole space. Sequential write requests are
shuffled to access scattered space. Can effectively reduce the counter
preemption.

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
V5 -> V6: Restored changes to the number of NR_STRIPE_HASH_LOCKS. Set
the maximum number of bmclocks (65536) to prevent excessive memory
usage. Optimized the number of bmclocks in RAID5 when the capacity of
each SSD is less than or equal to 4TB, and still performs well when
the capacity of each SSD is greater than 4TB.
V6 -> V7: Changed according to Song Liu's comments: redundant
"locktypes" were subtracted, unnecessary fixes were removed, NULL
Pointers were changed from "0" to "NULL", code comments were added, and
commit logs were refined.
V7 -> V8: Rebase onto newest Linux (6.12-rc2).

---
  drivers/md/md-bitmap.c | 211 +++++++++++++++++++++++++++++++----------
  drivers/md/md-bitmap.h |   9 +-
  2 files changed, 170 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 29da10e6f703e..793959a533ae4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -149,7 +149,18 @@ struct bitmap_page {
  struct bitmap {

      struct bitmap_counts {
-        spinlock_t lock;
+        /*
+         * Customize different types of lock structures to manage
+         * data and metadata.
+         * Split the counter table into multiple segments and assigns a
+         * dedicated lock to each segment.  The counters in the counter
+         * table, which map to neighboring stripe blocks, are interleaved
+         * across different segments.
+         * CPU threads that target different segments can acquire the locks
+         * simultaneously, resulting in better thread-level parallelism.
+         */
+        rwlock_t mlock;                /* lock for metadata */
+        spinlock_t *bmclocks;        /* locks for bmc */
          struct bitmap_page *bp;
          /* total number of pages in the bitmap */
          unsigned long pages;
@@ -246,10 +257,12 @@ static bool bitmap_enabled(struct mddev *mddev)
   * if we find our page, we increment the page's refcount so that it stays
   * allocated while we're using it
   */
-static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
-                   unsigned long page, int create, int no_hijack)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned 
long page,
+                   int create, int no_hijack, spinlock_t *bmclock)
+__releases(bmclock)
+__acquires(bmclock)
+__releases(bitmap->mlock)
+__acquires(bitmap->mlock)
  {
      unsigned char *mappage;

@@ -264,8 +277,10 @@ __acquires(bitmap->lock)
          return -ENOENT;

      /* this page has not been allocated yet */
-
-    spin_unlock_irq(&bitmap->lock);
+    if (bmclock)
+        spin_unlock_irq(bmclock); /* lock for bmc */
+    else
+        write_unlock_irq(&bitmap->mlock); /* lock for metadata */
      /* It is possible that this is being called inside a
       * prepare_to_wait/finish_wait loop from raid5c:make_request().
       * In general it is not permitted to sleep in that context as it
@@ -280,7 +295,11 @@ __acquires(bitmap->lock)
       */
      sched_annotate_sleep();
      mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
-    spin_lock_irq(&bitmap->lock);
+
+    if (bmclock)
+        spin_lock_irq(bmclock);  /* lock for bmc */
+    else
+        write_lock_irq(&bitmap->mlock); /* lock for metadata */

      if (mappage == NULL) {
          pr_debug("md/bitmap: map page allocation failed, hijacking\n");
@@ -1456,16 +1475,35 @@ static void bitmap_write_all(struct mddev *mddev)
  static void md_bitmap_count_page(struct bitmap_counts *bitmap,
                   sector_t offset, int inc)
  {
-    sector_t chunk = offset >> bitmap->chunkshift;
-    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+    /*
+     * The stripe heads are spread across different locations in the
+     * SSDs via a configurable hash function rather than mapping to a
+     * continuous SSD space.
+     * Sequential write requests are shuffled to different counter to
+     * reduce the counter preemption.
+     */
+    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
PAGE_SHIFT)));
+    unsigned long cntid = blockno & mask;
+    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
      bitmap->bp[page].count += inc;
      md_bitmap_checkfree(bitmap, page);
  }

  static void md_bitmap_set_pending(struct bitmap_counts *bitmap, 
sector_t offset)
  {
-    sector_t chunk = offset >> bitmap->chunkshift;
-    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
PAGE_SHIFT)));
+    unsigned long cntid = blockno & mask;
+    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
      struct bitmap_page *bp = &bitmap->bp[page];

      if (!bp->pending)
@@ -1474,7 +1512,7 @@ static void md_bitmap_set_pending(struct 
bitmap_counts *bitmap, sector_t offset)

  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
*bitmap,
                             sector_t offset, sector_t *blocks,
-                           int create);
+                           int create, spinlock_t *bmclock);

  static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
                    bool force)
@@ -1557,7 +1595,7 @@ static void bitmap_daemon_work(struct mddev *mddev)
       * decrement and handle accordingly.
       */
      counts = &bitmap->counts;
-    spin_lock_irq(&counts->lock);
+    write_lock_irq(&counts->mlock);
      nextpage = 0;
      for (j = 0; j < counts->chunks; j++) {
          bitmap_counter_t *bmc;
@@ -1572,7 +1610,7 @@ static void bitmap_daemon_work(struct mddev *mddev)
              counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
          }

-        bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
+        bmc = md_bitmap_get_counter(counts, block, &blocks, 0, NULL);
          if (!bmc) {
              j |= PAGE_COUNTER_MASK;
              continue;
@@ -1588,7 +1626,7 @@ static void bitmap_daemon_work(struct mddev *mddev)
              bitmap->allclean = 0;
          }
      }
-    spin_unlock_irq(&counts->lock);
+    write_unlock_irq(&counts->mlock);

      md_bitmap_wait_writes(bitmap);
      /* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
@@ -1621,17 +1659,25 @@ static void bitmap_daemon_work(struct mddev *mddev)

  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
*bitmap,
                             sector_t offset, sector_t *blocks,
-                           int create)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+                           int create, spinlock_t *bmclock)
+__releases(bmclock)
+__acquires(bmclock)
+__releases(bitmap->mlock)
+__acquires(bitmap->mlock)
  {
      /* If 'create', we might release the lock and reclaim it.
       * The lock must have been taken with interrupts enabled.
       * If !create, we don't release the lock.
       */
-    sector_t chunk = offset >> bitmap->chunkshift;
-    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
-    unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << 
COUNTER_BYTE_SHIFT;
+    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
PAGE_SHIFT)));
+    unsigned long cntid = blockno & mask;
+    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+    unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << 
COUNTER_BYTE_SHIFT;
+
      sector_t csize = ((sector_t)1) << bitmap->chunkshift;
      int err;

@@ -1644,7 +1690,7 @@ __acquires(bitmap->lock)
          *blocks = csize - (offset & (csize - 1));
          return NULL;
      }
-    err = md_bitmap_checkpage(bitmap, page, create, 0);
+    err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock);

      if (bitmap->bp[page].hijacked ||
          bitmap->bp[page].map == NULL)
@@ -1669,6 +1715,28 @@ __acquires(bitmap->lock)
              &(bitmap->bp[page].map[pageoff]);
  }

+/* set-association */
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
sector_t offset);
+
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
sector_t offset)
+{
+    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+    unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
+    unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX << 
(bitscnt -
+                    (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+    unsigned long cntid = blockno & maskcnt;
+
+    unsigned long totcnts = bitmap->chunks;
+    unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
+    unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX <<
+                    (bitslock - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
+    unsigned long lockid = cntid & masklock;
+
+    spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
+    return bmclock;
+}
+
  static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
                   unsigned long sectors, bool behind)
  {
@@ -1691,11 +1759,15 @@ static int bitmap_startwrite(struct mddev 
*mddev, sector_t offset,
      while (sectors) {
          sector_t blocks;
          bitmap_counter_t *bmc;
+        spinlock_t *bmclock;

-        spin_lock_irq(&bitmap->counts.lock);
-        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
+        bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+        read_lock(&bitmap->counts.mlock);
+        spin_lock_irq(bmclock);
+        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 
1, bmclock);
          if (!bmc) {
-            spin_unlock_irq(&bitmap->counts.lock);
+            spin_unlock_irq(bmclock);
+            read_unlock(&bitmap->counts.mlock);
              return 0;
          }

@@ -1707,7 +1779,8 @@ static int bitmap_startwrite(struct mddev *mddev, 
sector_t offset,
               */
              prepare_to_wait(&bitmap->overflow_wait, &__wait,
                      TASK_UNINTERRUPTIBLE);
-            spin_unlock_irq(&bitmap->counts.lock);
+            spin_unlock_irq(bmclock);
+            read_unlock(&bitmap->counts.mlock);
              schedule();
              finish_wait(&bitmap->overflow_wait, &__wait);
              continue;
@@ -1724,7 +1797,8 @@ static int bitmap_startwrite(struct mddev *mddev, 
sector_t offset,

          (*bmc)++;

-        spin_unlock_irq(&bitmap->counts.lock);
+        spin_unlock_irq(bmclock);
+        read_unlock(&bitmap->counts.mlock);

          offset += blocks;
          if (sectors > blocks)
@@ -1755,11 +1829,15 @@ static void bitmap_endwrite(struct mddev *mddev, 
sector_t offset,
          sector_t blocks;
          unsigned long flags;
          bitmap_counter_t *bmc;
+        spinlock_t *bmclock;

-        spin_lock_irqsave(&bitmap->counts.lock, flags);
-        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
+        bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+        read_lock(&bitmap->counts.mlock);
+        spin_lock_irqsave(bmclock, flags);
+        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 
0, bmclock);
          if (!bmc) {
-            spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+            spin_unlock_irqrestore(bmclock, flags);
+            read_unlock(&bitmap->counts.mlock);
              return;
          }

@@ -1781,7 +1859,8 @@ static void bitmap_endwrite(struct mddev *mddev, 
sector_t offset,
              md_bitmap_set_pending(&bitmap->counts, offset);
              bitmap->allclean = 0;
          }
-        spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+        spin_unlock_irqrestore(bmclock, flags);
+        read_unlock(&bitmap->counts.mlock);
          offset += blocks;
          if (sectors > blocks)
              sectors -= blocks;
@@ -1794,16 +1873,19 @@ static bool __bitmap_start_sync(struct bitmap 
*bitmap, sector_t offset,
                  sector_t *blocks, bool degraded)
  {
      bitmap_counter_t *bmc;
+    spinlock_t *bmclock;
      bool rv;

      if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
          *blocks = 1024;
          return true; /* always resync if no bitmap */
      }
-    spin_lock_irq(&bitmap->counts.lock);
+    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+    read_lock(&bitmap->counts.mlock);
+    spin_lock_irq(bmclock);

      rv = false;
-    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 
bmclock);
      if (bmc) {
          /* locked */
          if (RESYNC(*bmc)) {
@@ -1816,7 +1898,8 @@ static bool __bitmap_start_sync(struct bitmap 
*bitmap, sector_t offset,
              }
          }
      }
-    spin_unlock_irq(&bitmap->counts.lock);
+    spin_unlock_irq(bmclock);
+    read_unlock(&bitmap->counts.mlock);

      return rv;
  }
@@ -1850,13 +1933,16 @@ static void __bitmap_end_sync(struct bitmap 
*bitmap, sector_t offset,
  {
      bitmap_counter_t *bmc;
      unsigned long flags;
+    spinlock_t *bmclock;

      if (bitmap == NULL) {
          *blocks = 1024;
          return;
      }
-    spin_lock_irqsave(&bitmap->counts.lock, flags);
-    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+    read_lock(&bitmap->counts.mlock);
+    spin_lock_irqsave(bmclock, flags);
+    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 
bmclock);
      if (bmc == NULL)
          goto unlock;
      /* locked */
@@ -1873,7 +1959,8 @@ static void __bitmap_end_sync(struct bitmap 
*bitmap, sector_t offset,
          }
      }
   unlock:
-    spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+    spin_unlock_irqrestore(bmclock, flags);
+    read_unlock(&bitmap->counts.mlock);
  }

  static void bitmap_end_sync(struct mddev *mddev, sector_t offset,
@@ -1961,10 +2048,15 @@ static void md_bitmap_set_memory_bits(struct 
bitmap *bitmap, sector_t offset, in

      sector_t secs;
      bitmap_counter_t *bmc;
-    spin_lock_irq(&bitmap->counts.lock);
-    bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
+    spinlock_t *bmclock;
+
+    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+    read_lock(&bitmap->counts.mlock);
+    spin_lock_irq(bmclock);
+    bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1, 
bmclock);
      if (!bmc) {
-        spin_unlock_irq(&bitmap->counts.lock);
+        spin_unlock_irq(bmclock);
+        read_unlock(&bitmap->counts.mlock);
          return;
      }
      if (!*bmc) {
@@ -1975,7 +2067,8 @@ static void md_bitmap_set_memory_bits(struct 
bitmap *bitmap, sector_t offset, in
      }
      if (needed)
          *bmc |= NEEDED_MASK;
-    spin_unlock_irq(&bitmap->counts.lock);
+    spin_unlock_irq(bmclock);
+    read_unlock(&bitmap->counts.mlock);
  }

  /* dirty the memory and file bits for bitmap chunks "s" to "e" */
@@ -2030,6 +2123,7 @@ static void md_bitmap_free(void *data)
      unsigned long k, pages;
      struct bitmap_page *bp;
      struct bitmap *bitmap = data;
+    spinlock_t *bmclocks;

      if (!bitmap) /* there was no bitmap */
          return;
@@ -2050,6 +2144,7 @@ static void md_bitmap_free(void *data)

      bp = bitmap->counts.bp;
      pages = bitmap->counts.pages;
+    bmclocks = bitmap->counts.bmclocks;

      /* free all allocated memory */

@@ -2058,6 +2153,7 @@ static void md_bitmap_free(void *data)
              if (bp[k].map && !bp[k].hijacked)
                  kfree(bp[k].map);
      kfree(bp);
+    kfree(bmclocks);
      kfree(bitmap);
  }

@@ -2123,7 +2219,9 @@ static struct bitmap *__bitmap_create(struct mddev 
*mddev, int slot)
      if (!bitmap)
          return ERR_PTR(-ENOMEM);

-    spin_lock_init(&bitmap->counts.lock);
+    /* initialize metadata lock */
+    rwlock_init(&bitmap->counts.mlock);
+
      atomic_set(&bitmap->pending_writes, 0);
      init_waitqueue_head(&bitmap->write_wait);
      init_waitqueue_head(&bitmap->overflow_wait);
@@ -2382,6 +2480,8 @@ static int __bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
      int ret = 0;
      long pages;
      struct bitmap_page *new_bp;
+    spinlock_t *new_bmclocks;
+    int num_bmclocks, i;

      if (bitmap->storage.file && !init) {
          pr_info("md: cannot resize file-based bitmap\n");
@@ -2450,7 +2550,7 @@ static int __bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
          memcpy(page_address(store.sb_page),
                 page_address(bitmap->storage.sb_page),
                 sizeof(bitmap_super_t));
-    spin_lock_irq(&bitmap->counts.lock);
+    write_lock_irq(&bitmap->counts.mlock);
      md_bitmap_file_unmap(&bitmap->storage);
      bitmap->storage = store;

@@ -2466,11 +2566,23 @@ static int __bitmap_resize(struct bitmap 
*bitmap, sector_t blocks,
      blocks = min(old_counts.chunks << old_counts.chunkshift,
               chunks << chunkshift);

+    /* initialize bmc locks */
+    num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
+    num_bmclocks = min(num_bmclocks, BITMAP_COUNTER_LOCK_MAX);
+
+    new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks), 
GFP_KERNEL);
+    bitmap->counts.bmclocks = new_bmclocks;
+    for (i = 0; i < num_bmclocks; ++i) {
+        spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
+
+        spin_lock_init(bmclock);
+    }
+
      /* For cluster raid, need to pre-allocate bitmap */
      if (mddev_is_clustered(bitmap->mddev)) {
          unsigned long page;
          for (page = 0; page < pages; page++) {
-            ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1);
+            ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1, NULL);
              if (ret) {
                  unsigned long k;

@@ -2500,11 +2612,12 @@ static int __bitmap_resize(struct bitmap 
*bitmap, sector_t blocks,
          bitmap_counter_t *bmc_old, *bmc_new;
          int set;

-        bmc_old = md_bitmap_get_counter(&old_counts, block, 
&old_blocks, 0);
+        bmc_old = md_bitmap_get_counter(&old_counts, block, 
&old_blocks, 0, NULL);
          set = bmc_old && NEEDED(*bmc_old);

          if (set) {
-            bmc_new = md_bitmap_get_counter(&bitmap->counts, block, 
&new_blocks, 1);
+            bmc_new = md_bitmap_get_counter(&bitmap->counts, block, 
&new_blocks,
+                                        1, NULL);
              if (bmc_new) {
                  if (*bmc_new == 0) {
                      /* need to set on-disk bits too. */
@@ -2540,7 +2653,7 @@ static int __bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
          int i;
          while (block < (chunks << chunkshift)) {
              bitmap_counter_t *bmc;
-            bmc = md_bitmap_get_counter(&bitmap->counts, block, 
&new_blocks, 1);
+            bmc = md_bitmap_get_counter(&bitmap->counts, block, 
&new_blocks, 1, NULL);
              if (bmc) {
                  /* new space.  It needs to be resynced, so
                   * we set NEEDED_MASK.
@@ -2556,7 +2669,7 @@ static int __bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
          for (i = 0; i < bitmap->storage.file_pages; i++)
              set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
      }
-    spin_unlock_irq(&bitmap->counts.lock);
+    write_unlock_irq(&bitmap->counts.mlock);

      if (!init) {
          __bitmap_unplug(bitmap);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 662e6fc141a77..93da6d836b579 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -2,7 +2,9 @@
  /*
   * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
   *
- * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye 
Technology, Inc.
+ * additions:
+ *        Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ *        Copyright (C) 2022-2023, Shushu Yi (firnyee@gmail.com)
   */
  #ifndef BITMAP_H
  #define BITMAP_H 1
@@ -18,6 +20,11 @@ typedef __u16 bitmap_counter_t;
  #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
  #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)

+/* how many counters share the same bmclock? */
+#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
+#define BITMAP_COUNTER_LOCK_RATIO (1 << BITMAP_COUNTER_LOCK_RATIO_SHIFT)
+#define BITMAP_COUNTER_LOCK_MAX 65536
+
  /* use these for bitmap->flags and bitmap->sb->state bit-fields */
  enum bitmap_state {
      BITMAP_STALE       = 1,  /* the bitmap file is out of date or had 
-EIO */
-- 
2.43.0

