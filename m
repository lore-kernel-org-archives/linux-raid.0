Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04olkn2062.outbound.protection.outlook.com [40.92.45.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444911DC99D;
	Tue, 10 Dec 2024 10:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.45.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733826076; cv=fail; b=bgaw4QdYbsTRnHeqf771Ws5Yv6kthVwQsEw1xGv2QhA22ecoQ7/GLaGP5kNkiFCbdU0XQwf7WVbW4tUfwiFfEmizZbkg18Y5th1LSByyReYsAm5X2GH72PBrk4l511cipnqVEE4LESnHzgoEt1ao5KrTUWJFzoq7tpGIf8YvlQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733826076; c=relaxed/simple;
	bh=1bOPhIHUbR3NvRNVw9xk+XPgeg9+QjEZz2EB5KQjaqQ=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=ceBRKenRfgPZ1l9rcQTUnVeOCbM+VvR8lNkRsU579bbJYw4E8S2ke4YuOtloxlK9ZJm+N3PGxPkkUNJFJqW9HK032rqbBwNJJ2U2GED1PvzQb25/ikSSf27a0NEV5ZBzSBxYjrUZdW0c7vceQayQhwkrsUdJHko16IjVo1SQztE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=m1WjHFhf; arc=fail smtp.client-ip=40.92.45.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="m1WjHFhf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvXI59T6kwVJgyrwcjK56B/8OvAsX091XsiABtyLwhD1KcmndiFSOt74LAo+WfYxfTOml0xZKnmtztNUPy+Ssqu9Me0Q2pCOcmAUBNd7rtO5eJdTld5EPVPfkXvRD/aAC3TNDY2eGQjPTdmhQpz8OeiYlVblRKjN6Zn/uC36QCBvEsEbJktsiu1fxIEhk5S9MuWeOnuFT1YouawdIpRUGL8MHhg4WqxrNkxIlF4ydEOef3SsHTHmn9YOS+JdeLw4l+coxyb6NTn3zFfnQvi2ouT2EAYoXxCCdV1wLac+yT8JBVjh8dp0VG48arPcXKWc/TuQCxIfkEIbI7c4p0dsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wfvv9FnysrRqmNUh5ZsSqs8t+/rsu0FugKwVmkUu4o=;
 b=Wi+uAkbmNPGa4vI/G5NgpJwYCVSC8gInEMjSYsTux31mBLnRAN7JqeQKIhI9Iusx7jZ6IevSC0/uqtr+jn8auqdpyMsf4P5abNNxEuCwnpCEfmY5EQcrT5AL37i/0c+qQ+2bZTvbjNbfqoOBMb8+b2NotncSzERVVGCOPZnh5mbOuNtariRzn3J6DZ4fcZoKhvbyCdc+i9Kg/LMoA3GmKIk6syhZ7ljl7ZMmoBhTJN9JXfDC9rMtnFBt4KPmtiNg++P8LFqIIpgiaywzd+riaUuxJqfSLxjFvZ8IQB+A8qTlLk2UhGX7d6WMGg+tPf7k5QY4aVU0+3+ukrtVb1yvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wfvv9FnysrRqmNUh5ZsSqs8t+/rsu0FugKwVmkUu4o=;
 b=m1WjHFhfcovai5ZwKWKEx2OB68Y5j/hpRZropvSpOmTqxQ6zDp7Oo9t41lW+QQNI54cm1qYs3EDDntURaoXOFXEkU7hA8aVyJ+ToEbtv6oxTndE9OEHuXOXmYOWlnG93//T0xOEOJmG0IeAyYh4/54uPyb4lDgKZdeRpOdR3KH9jx+C0nKfotLPHnOEdal0H4WWESI9Y/QUfBB9q7WxIUzAcsHjURJC4DlfHYfjOYwurjmsWp70ayd27QNipfjUtAlYLUzxNMxacUYGyOf5tM0qoHi+2/ck/UH0NYEG/yReyAU4KWITDeHU81pwPsPHD6ESyw7lN+NAOwi+nLThuLA==
Received: from DM6PR12MB3194.namprd12.prod.outlook.com (2603:10b6:5:184::13)
 by LV3PR12MB9268.namprd12.prod.outlook.com (2603:10b6:408:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 10 Dec
 2024 10:21:11 +0000
Received: from DM6PR12MB3194.namprd12.prod.outlook.com
 ([fe80::289b:7e99:bb4c:eadb]) by DM6PR12MB3194.namprd12.prod.outlook.com
 ([fe80::289b:7e99:bb4c:eadb%7]) with mapi id 15.20.8207.010; Tue, 10 Dec 2024
 10:21:11 +0000
Message-ID:
 <DM6PR12MB319444916C454CDBA6FCD358D83D2@DM6PR12MB3194.namprd12.prod.outlook.com>
Date: Tue, 10 Dec 2024 18:21:01 +0800
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org,
 paul.e.luse@intel.com, firnyee@gmail.com, hch@infradead.org,
 teddyxym@outlook.com
From: Shushu Yi <teddyxym@outlook.com>
Subject: [RFC V9] md/bitmap: Optimize lock contention.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To DM6PR12MB3194.namprd12.prod.outlook.com
 (2603:10b6:5:184::13)
X-Microsoft-Original-Message-ID:
 <aea714a7-9bc4-4331-8ea7-a6f3c3ec8f49@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3194:EE_|LV3PR12MB9268:EE_
X-MS-Office365-Filtering-Correlation-Id: 032d5b86-07db-4aed-80f5-08dd19045e07
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|19110799003|8060799006|15080799006|6090799003|5062599005|5072599009|10035399004|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFNkVWFYYnRuWEZGV015N2V1U0p3ZHBraTBOMHJVditNL2lYMDRYcEVRRDlt?=
 =?utf-8?B?YlpKR0FsSlR0SkRxMTJoQW56ckJDZFNHQUtTZm84VG9FaS8zOHN6QTNIRkJs?=
 =?utf-8?B?TVZYMjhySjhzNW1RTlpJZis0cjhuY3cvVDYwcE1lRUcxOUxncGt2eXZEM3A2?=
 =?utf-8?B?UGNGSFlFb3NPdXhZMnE4L0QwTlhYeHUyZTZ5TVkxNHdCd3FDK2lrM2FJMitr?=
 =?utf-8?B?aWxaNmJZeDVNdGk4aUQ1MDlPYjZzTVVQWE1QMmQ5RzdQUUdRbTRoTUFFNFJ5?=
 =?utf-8?B?d2NFQUJwbkgvSmpiay9ZZzRZT3Y4VWhDUmtTUzV0SDlZUjNUZ3BZUzVPbHZT?=
 =?utf-8?B?WXY2VkxabzFjcW5FZ09QdkUzdytmTmEzaWt6dXA2RkQ0Vld6bVJrZ05NQ1Zz?=
 =?utf-8?B?a3A3TkJSYWFpQ2FpWGYySnBtM3RuUTdCSklaamxvdVpHWlZ0WjBFNyszdGRR?=
 =?utf-8?B?MFVIaWN5QmFIQUVQZzNCNnBtbTNLdGpLc2dCWjU5VkRuVzJ4QTJxWXUxd0Zj?=
 =?utf-8?B?WjVuM21ZMm4ya0RmdmJyeG9jcEYrNy9jOWhGR1pUVC91RUdyWnNLN1NNNHl6?=
 =?utf-8?B?TldudXl6MUdPaks5c0d2dml5cHhibS85MU9FaGo0UzNwQWl1cHZJdlNXc2xN?=
 =?utf-8?B?b2R4dUxIc0xVL3dFVjY0VGp6Ky9rK3RGK2kzTjVxOFNNZlFwV2hvQmp6V2Zx?=
 =?utf-8?B?WVEyWXlhUnlqQ1lab3JxZ3ZQdFdpbDg3Y3FpYklSK0FSNlNFcGdSbEloL0dx?=
 =?utf-8?B?RUVZdmJadU5yWHArOGxKQXJrMXMyUDZwMzlOWFFZUWpQWUhLL0VJWnoxUTJK?=
 =?utf-8?B?SVZoSnNuZHE4WnUvQjVzRjN4N2RwRnpYb2Y4Zy9HakF6SkdLa29tc0hDeHB5?=
 =?utf-8?B?a1B0cnVMVXZMUkJ0ZFNvZGYzdnFwa2cyUzV1c0hyY3ROMzAvZDJDeXcvTUsr?=
 =?utf-8?B?TkxFTUpJVFNVZXkxNndsYlNqMmhPdW1UWU83MkU3clBHZFJlSG5RZ3MzNnBp?=
 =?utf-8?B?TjNrM2Zpd1JuR0xkT0VFZVF4RzFVbXp5emFOVDhkcTNySVBvQVRaSkZLSktq?=
 =?utf-8?B?dlBFaEN3aHVXNzFGY2lKU0pwaUtVbGRKVkpoWUUvYkttMDdiOXU2VGtCYXRH?=
 =?utf-8?B?dkdScy92Zll6R2d5dmZEdkh4VFhOeTUxUFhHcXIzR3hYbXRQNXFGUTBSMkRz?=
 =?utf-8?B?TEVFWkFYeEJ1aW5ZMmdzbVVPR25qQ1B1L3Z5RWxTdWlYaE1HZVI2SmlLd0l6?=
 =?utf-8?B?dCsraitGdlhuSm9JRGhra1ZqeVdsOXUrZ1JUWklyblcrSEFtbkl1U3JGc3RK?=
 =?utf-8?B?WDloaXNzdXJiVzdXWUZObWJaWE9xSGFad0pCZ0k5d0dlVHRRVWl0TFFWSVd6?=
 =?utf-8?B?Y3VmZmZ3alV5TzlFM1QySUlIMU12REhaSXY2cURGVmxYOXpMOTFuaE1vamJP?=
 =?utf-8?B?V2ZpWHBDSjJpS1FiQW9na3BIQWpONlpESUVLa2YzK1BUVmhjbDRYd09vYXJr?=
 =?utf-8?B?SGlyTmdHRU9QbWE1Zy9Wdk03cHFldjBQQ2JELzRKQ0x0dHMrZTBGeld4Qmps?=
 =?utf-8?B?a3Y5UT09?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXJESmdMQUpDS21LM2xNTnV6L2Z1TFFZTGkrbklIQWk3UUJlS3RvS3ZvNlhu?=
 =?utf-8?B?MjBvR1dkMTQzUkREaGtJd0Nvay9Fblk0aTY0R3JWYWhHZzRKMjBjTjBWSVVT?=
 =?utf-8?B?cm9VZDNIeFF5TFRUL1BZMGdpd0FWM3A0bUFzaTgxS1d5dFpFbVBhcW40UDhB?=
 =?utf-8?B?OWovVytDZzZLQVFPLytGN1ZmYUhRRVdTMkJCTkZyTnBkUE1Lb09Bdi9jNXJJ?=
 =?utf-8?B?QmJ3OXpraVRnT2l4SGU3UG54TDVpOGZTNzJRZ2J4OGdESGRzMkdqWVBVa0J5?=
 =?utf-8?B?bWFZa01xSjVhYVZQaEFjaTYyWEZwYW1lZis4dHNZTXlxRk1Pekg1eVdMR2ZU?=
 =?utf-8?B?VmhFUlJXLzlaVEZPTTEvZVVrSUhlbzNjNzlLNXNodUNjWmNTa1dTTnEyd3lG?=
 =?utf-8?B?ejlpRTJHMm9scmYwUmJrTTBXejNHNVNZbXBHQ1Q1dUwxcStySFBuUnR3cmk3?=
 =?utf-8?B?YWVVMS9UbE4vMUpyNEgyK3pBYmM5WE54ekJvVDFDRjdCb2dvbXVwNDUxQmNI?=
 =?utf-8?B?OTFNL29SSDluVVcrMEI2Uno4c24yYktyM2h2NDRKY0dHVjk5T1B6bm1DVGxY?=
 =?utf-8?B?aGg4QmpOZXlCVDJrS3MrVVJCTEEyUkdWUHVTRzdXeklsNmx0TTFaWHRGSWNO?=
 =?utf-8?B?bzdmQ1grYkFhdC9GaUhJdmZZdnlGTzZNN1dtbEV2dzhEWE11L0hnZ0xZY0J1?=
 =?utf-8?B?c20vTXM1VjBCWXpwNFRCLzlQS2Q3blRNUDRRVDVKb2l0cGFnQVdPcFd5RGpH?=
 =?utf-8?B?K2VsOUNuR0ZxWnhEUms4R1N4YjAya3FlSnhCbHMwMlVMakdDeWdlRjk3UmIv?=
 =?utf-8?B?U012a0lSY3hoQVNIaW9XcmcyUFpiR0dqRGZOYzN0aUhZcERnYVJ3Q3dndmJP?=
 =?utf-8?B?UFp5VnZlZDN2MGdoZ3ZTenNxRFBxc3BwZlQzY0p3c2RueHY0eUN0QmpvaWhE?=
 =?utf-8?B?ajJNVURCK1ptYlhRbnJiam5lMEJrTmFaTXNXa1dZOEFvTkdyMnFzcGlmSHZT?=
 =?utf-8?B?LzV1bHNOUTNzM2JBRVB6RHNpTFZiT1k3K05PeU5EbVFibXgzL2lZNnI0WTZi?=
 =?utf-8?B?ZjJVQ3N5aUpDUG0ybm9GTndhUU11ejdsb3VWTEh4c1A4UmtoKy9zWkNlUjlF?=
 =?utf-8?B?NFFxZnJxWnErZTNXSW9QeFRZbjRpMWFBMWdYV0hzVE1kUmdWWWtMVHZtY2FB?=
 =?utf-8?B?MlFkVkYvRGs3K2dERVlhaC80ZG8xa1NaT1B2VHc3NzlZTkt5bE8vM0NmUm1x?=
 =?utf-8?B?cmp1aDM2K2o2d3FlY1NqTytwWjNqR0RJcnNzZ0ViTktnZU50THRzUDFJWC9z?=
 =?utf-8?B?OVhCckczMHJwWk1OOTUwRUxQb1JXSERxdkZFbXo5cllpb2hranhtakpycFZa?=
 =?utf-8?B?MGU3TGlqVVZOOHRDVzYyTVdJWWpYRmFLYXJnS2RndHRQcnhuWHdaT0M0MUNP?=
 =?utf-8?B?a3dXWTV1dVRjMzR0ckIzVWUzZ3hyNFc1ZnNBemI4YjExUmdLMGp5M0RyUTZj?=
 =?utf-8?B?NkdOUFpEcGJMRElpRUJlSUxaamp2WWczQlJ6aWZ1YkVWQ1BJd1hUczg1Y083?=
 =?utf-8?B?UjhoQTI2c3ZsTlEwWDljZlRjeE15NWJ2eVFqeEVJVWtVS1p5eEhXeUNjRVd6?=
 =?utf-8?Q?gQisToAsO3X3v+ojMUFMOX8+j6AbpyNIaoO3CdHUqhV4=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032d5b86-07db-4aed-80f5-08dd19045e07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 10:21:10.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9268


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
V8 -> V9: Rebase onto newest code (md-6.13).

---
  drivers/md/md-bitmap.c | 199 +++++++++++++++++++++++++++++++----------
  drivers/md/md-bitmap.h |  22 ++++-
  2 files changed, 172 insertions(+), 49 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b092c7b5282f..65f5c34d47b2 100644
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
+static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned 
long page,
+			       int create, int no_hijack, spinlock_t *bmclock)
+__releases(bmclock)
+__acquires(bmclock)
+__releases(bitmap->mlock)
+__acquires(bitmap->mlock)
  {
  	unsigned char *mappage;

@@ -73,7 +75,10 @@ __acquires(bitmap->lock)

  	/* this page has not been allocated yet */

-	spin_unlock_irq(&bitmap->lock);
+	if (bmclock)
+		spin_unlock_irq(bmclock); /* lock for bmc */
+	else
+		write_unlock_irq(&bitmap->mlock); /* lock for metadata */
  	/* It is possible that this is being called inside a
  	 * prepare_to_wait/finish_wait loop from raid5c:make_request().
  	 * In general it is not permitted to sleep in that context as it
@@ -88,7 +93,11 @@ __acquires(bitmap->lock)
  	 */
  	sched_annotate_sleep();
  	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
-	spin_lock_irq(&bitmap->lock);
+
+	if (bmclock)
+		spin_lock_irq(bmclock);  /* lock for bmc */
+	else
+		write_lock_irq(&bitmap->mlock); /* lock for metadata */

  	if (mappage == NULL) {
  		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
@@ -1202,16 +1211,35 @@ void md_bitmap_write_all(struct bitmap *bitmap)
  static void md_bitmap_count_page(struct bitmap_counts *bitmap,
  				 sector_t offset, int inc)
  {
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+    /*
+     * The stripe heads are spread across different locations in the
+     * SSDs via a configurable hash function rather than mapping to a
+     * continuous SSD space.
+     * Sequential write requests are shuffled to different counter to
+     * reduce the counter preemption.
+     */
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
  	bitmap->bp[page].count += inc;
  	md_bitmap_checkfree(bitmap, page);
  }

  static void md_bitmap_set_pending(struct bitmap_counts *bitmap, 
sector_t offset)
  {
-	sector_t chunk = offset >> bitmap->chunkshift;
-	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+
  	struct bitmap_page *bp = &bitmap->bp[page];

  	if (!bp->pending)
@@ -1220,7 +1248,7 @@ static void md_bitmap_set_pending(struct 
bitmap_counts *bitmap, sector_t offset)

  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
*bitmap,
  					       sector_t offset, sector_t *blocks,
-					       int create);
+					       int create, spinlock_t *bmclock);

  /*
   * bitmap daemon -- periodically wakes up to clean bits and flush pages
@@ -1288,7 +1316,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
  	 * decrement and handle accordingly.
  	 */
  	counts = &bitmap->counts;
-	spin_lock_irq(&counts->lock);
+	write_lock_irq(&counts->mlock);
  	nextpage = 0;
  	for (j = 0; j < counts->chunks; j++) {
  		bitmap_counter_t *bmc;
@@ -1303,7 +1331,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
  			counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
  		}

-		bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
+		bmc = md_bitmap_get_counter(counts, block, &blocks, 0, NULL);
  		if (!bmc) {
  			j |= PAGE_COUNTER_MASK;
  			continue;
@@ -1319,7 +1347,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
  			bitmap->allclean = 0;
  		}
  	}
-	spin_unlock_irq(&counts->lock);
+	write_unlock_irq(&counts->mlock);

  	md_bitmap_wait_writes(bitmap);
  	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
@@ -1353,21 +1381,29 @@ void md_bitmap_daemon_work(struct mddev *mddev)

  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
*bitmap,
  					       sector_t offset, sector_t *blocks,
-					       int create)
-__releases(bitmap->lock)
-__acquires(bitmap->lock)
+					       int create, spinlock_t *bmclock)
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
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
+	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
+	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
+					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
+	unsigned long cntid = blockno & mask;
+	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
+	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
+
  	sector_t csize;
  	int err;

-	err = md_bitmap_checkpage(bitmap, page, create, 0);
+	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock);

  	if (bitmap->bp[page].hijacked ||
  	    bitmap->bp[page].map == NULL)
@@ -1393,6 +1429,28 @@ __acquires(bitmap->lock)
  			&(bitmap->bp[page].map[pageoff]);
  }

+/* set-association */
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
sector_t offset);
+
+static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
sector_t offset)
+{
+	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
+	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
(PAGE_SHIFT - SECTOR_SHIFT));
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
  int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, 
unsigned long sectors, int behind)
  {
  	if (!bitmap)
@@ -1412,11 +1470,15 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
sector_t offset, unsigned long s
  	while (sectors) {
  		sector_t blocks;
  		bitmap_counter_t *bmc;
+		spinlock_t *bmclock;

-		spin_lock_irq(&bitmap->counts.lock);
-		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
+		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+		read_lock(&bitmap->counts.mlock);
+		spin_lock_irq(bmclock);
+		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1, 
bmclock);
  		if (!bmc) {
-			spin_unlock_irq(&bitmap->counts.lock);
+			spin_unlock_irq(bmclock);
+			read_unlock(&bitmap->counts.mlock);
  			return 0;
  		}

@@ -1428,7 +1490,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
sector_t offset, unsigned long s
  			 */
  			prepare_to_wait(&bitmap->overflow_wait, &__wait,
  					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->counts.lock);
+			spin_unlock_irq(bmclock);
+			read_unlock(&bitmap->counts.mlock);
  			schedule();
  			finish_wait(&bitmap->overflow_wait, &__wait);
  			continue;
@@ -1445,7 +1508,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
sector_t offset, unsigned long s

  		(*bmc)++;

-		spin_unlock_irq(&bitmap->counts.lock);
+		spin_unlock_irq(bmclock);
+		read_unlock(&bitmap->counts.mlock);

  		offset += blocks;
  		if (sectors > blocks)
@@ -1474,11 +1538,15 @@ void md_bitmap_endwrite(struct bitmap *bitmap, 
sector_t offset,
  		sector_t blocks;
  		unsigned long flags;
  		bitmap_counter_t *bmc;
+		spinlock_t *bmclock;

-		spin_lock_irqsave(&bitmap->counts.lock, flags);
-		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
+		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+		read_lock(&bitmap->counts.mlock);
+		spin_lock_irqsave(bmclock, flags);
+		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0, 
bmclock);
  		if (!bmc) {
-			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+			spin_unlock_irqrestore(bmclock, flags);
+			read_unlock(&bitmap->counts.mlock);
  			return;
  		}

@@ -1500,7 +1568,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap, 
sector_t offset,
  			md_bitmap_set_pending(&bitmap->counts, offset);
  			bitmap->allclean = 0;
  		}
-		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+		spin_unlock_irqrestore(bmclock, flags);
+		read_unlock(&bitmap->counts.mlock);
  		offset += blocks;
  		if (sectors > blocks)
  			sectors -= blocks;
@@ -1514,13 +1583,16 @@ static int __bitmap_start_sync(struct bitmap 
*bitmap, sector_t offset, sector_t
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
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock);
  	rv = 0;
  	if (bmc) {
  		/* locked */
@@ -1534,7 +1606,8 @@ static int __bitmap_start_sync(struct bitmap 
*bitmap, sector_t offset, sector_t
  			}
  		}
  	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
  	return rv;
  }

@@ -1566,13 +1639,16 @@ void md_bitmap_end_sync(struct bitmap *bitmap, 
sector_t offset, sector_t *blocks
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
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock);
  	if (bmc == NULL)
  		goto unlock;
  	/* locked */
@@ -1589,7 +1665,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap, 
sector_t offset, sector_t *blocks
  		}
  	}
   unlock:
-	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+	spin_unlock_irqrestore(bmclock, flags);
+	read_unlock(&bitmap->counts.mlock);
  }
  EXPORT_SYMBOL(md_bitmap_end_sync);

@@ -1670,10 +1747,15 @@ static void md_bitmap_set_memory_bits(struct 
bitmap *bitmap, sector_t offset, in

  	sector_t secs;
  	bitmap_counter_t *bmc;
-	spin_lock_irq(&bitmap->counts.lock);
-	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
+	spinlock_t *bmclock;
+
+	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
+	read_lock(&bitmap->counts.mlock);
+	spin_lock_irq(bmclock);
+	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1, bmclock);
  	if (!bmc) {
-		spin_unlock_irq(&bitmap->counts.lock);
+		spin_unlock_irq(bmclock);
+		read_unlock(&bitmap->counts.mlock);
  		return;
  	}
  	if (!*bmc) {
@@ -1684,7 +1766,8 @@ static void md_bitmap_set_memory_bits(struct 
bitmap *bitmap, sector_t offset, in
  	}
  	if (needed)
  		*bmc |= NEEDED_MASK;
-	spin_unlock_irq(&bitmap->counts.lock);
+	spin_unlock_irq(bmclock);
+	read_unlock(&bitmap->counts.mlock);
  }

  /* dirty the memory and file bits for bitmap chunks "s" to "e" */
@@ -1736,6 +1819,7 @@ void md_bitmap_free(struct bitmap *bitmap)
  {
  	unsigned long k, pages;
  	struct bitmap_page *bp;
+	spinlock_t *bmclocks;

  	if (!bitmap) /* there was no bitmap */
  		return;
@@ -1756,6 +1840,7 @@ void md_bitmap_free(struct bitmap *bitmap)

  	bp = bitmap->counts.bp;
  	pages = bitmap->counts.pages;
+	bmclocks = bitmap->counts.bmclocks;

  	/* free all allocated memory */

@@ -1764,6 +1849,7 @@ void md_bitmap_free(struct bitmap *bitmap)
  			if (bp[k].map && !bp[k].hijacked)
  				kfree(bp[k].map);
  	kfree(bp);
+	kfree(bmclocks);
  	kfree(bitmap);
  }
  EXPORT_SYMBOL(md_bitmap_free);
@@ -1831,7 +1917,9 @@ struct bitmap *md_bitmap_create(struct mddev 
*mddev, int slot)
  	if (!bitmap)
  		return ERR_PTR(-ENOMEM);

-	spin_lock_init(&bitmap->counts.lock);
+	/* initialize metadata lock */
+	rwlock_init(&bitmap->counts.mlock);
+
  	atomic_set(&bitmap->pending_writes, 0);
  	init_waitqueue_head(&bitmap->write_wait);
  	init_waitqueue_head(&bitmap->overflow_wait);
@@ -2072,6 +2160,8 @@ int md_bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
  	int ret = 0;
  	long pages;
  	struct bitmap_page *new_bp;
+	spinlock_t *new_bmclocks;
+	int num_bmclocks, i;

  	if (bitmap->storage.file && !init) {
  		pr_info("md: cannot resize file-based bitmap\n");
@@ -2154,12 +2244,25 @@ int md_bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
  	blocks = min(old_counts.chunks << old_counts.chunkshift,
  		     chunks << chunkshift);

-	spin_lock_irq(&bitmap->counts.lock);
+	write_lock_irq(&bitmap->counts.mlock);
+
+	/* initialize bmc locks */
+	num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
+	num_bmclocks = min(num_bmclocks, BITMAP_COUNTER_LOCK_MAX);
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
+			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1, NULL);
  			if (ret) {
  				unsigned long k;

@@ -2189,11 +2292,12 @@ int md_bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
  		bitmap_counter_t *bmc_old, *bmc_new;
  		int set;

-		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0);
+		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0, 
NULL);
  		set = bmc_old && NEEDED(*bmc_old);

  		if (set) {
-			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,
++										1, NULL);
  			if (*bmc_new == 0) {
  				/* need to set on-disk bits too. */
  				sector_t end = block + new_blocks;
@@ -2226,7 +2330,7 @@ int md_bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
  		int i;
  		while (block < (chunks << chunkshift)) {
  			bitmap_counter_t *bmc;
-			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
+			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, 
NULL);
  			if (bmc) {
  				/* new space.  It needs to be resynced, so
  				 * we set NEEDED_MASK.
@@ -2242,7 +2346,8 @@ int md_bitmap_resize(struct bitmap *bitmap, 
sector_t blocks,
  		for (i = 0; i < bitmap->storage.file_pages; i++)
  			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
  	}
-	spin_unlock_irq(&bitmap->counts.lock);
+	write_unlock_irq(&bitmap->counts.mlock);
+	read_unlock(&bitmap->counts.mlock);

  	if (!init) {
  		md_bitmap_unplug(bitmap);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cfd7395de8fd..ff43b61f5ff0 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -2,7 +2,9 @@
  /*
   * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
   *
- * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye 
Technology, Inc.
+ * additions:
+ *		Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ *		Copyright (C) 2022-2023, Shushu Yi (firnyee@gmail.com)
   */
  #ifndef BITMAP_H
  #define BITMAP_H 1
@@ -112,6 +114,11 @@ typedef __u16 bitmap_counter_t;

  #define BITMAP_MAGIC 0x6d746962

+/* how many counters share the same bmclock? */
+#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
+#define BITMAP_COUNTER_LOCK_RATIO (1 << BITMAP_COUNTER_LOCK_RATIO_SHIFT)
+#define BITMAP_COUNTER_LOCK_MAX 65536
+
  /* use these for bitmap->flags and bitmap->sb->state bit-fields */
  enum bitmap_state {
  	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
@@ -180,7 +187,18 @@ struct bitmap_page {
  struct bitmap {

  	struct bitmap_counts {
-		spinlock_t lock;
+		/*
+		 * Customize different types of lock structures to manage
+		 * data and metadata.
+		 * Split the counter table into multiple segments and assigns a
+		 * dedicated lock to each segment.  The counters in the counter
+		 * table, which map to neighboring stripe blocks, are interleaved
+		 * across different segments.
+		 * CPU threads that target different segments can acquire the locks
+		 * simultaneously, resulting in better thread-level parallelism.
+		 */
+		rwlock_t mlock;				/* lock for metadata */
+		spinlock_t *bmclocks;		/* locks for bmc */
  		struct bitmap_page *bp;
  		unsigned long pages;		/* total number of pages
  						 * in the bitmap */
-- 
2.43.0

