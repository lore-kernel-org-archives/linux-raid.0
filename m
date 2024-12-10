Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02olkn2066.outbound.protection.outlook.com [40.92.43.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543123DE8B;
	Tue, 10 Dec 2024 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.43.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733825604; cv=fail; b=LdQH8tkO/FeF7WeCr1aJEaebtAZfuWwjDBm5HdyP6DnlPXj1CRoixo87poqHo2qlVNVqsuhQuvvQCzI6CLxok/rppETbM0OSmVfhZOm3gEl6KitQvV3RkGLMlXql0TcwQBwJiTjXApXtCh7Kv49mOHkEPBRWe4L5AGYa/L8asIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733825604; c=relaxed/simple;
	bh=1bOPhIHUbR3NvRNVw9xk+XPgeg9+QjEZz2EB5KQjaqQ=;
	h=Message-ID:Date:From:Subject:References:To:Cc:In-Reply-To:
	 Content-Type:MIME-Version; b=cYsufgUazkC6lkYWdzQ2bUFjv6xCBbyg/3rQSt8TTD+aNgISj7vJYKQwt6Bw0rXF5G2Aihf9VEjIDC80fHQhEnIUR7yvxKqkCo9ki+WNWWfWN2d6a0cQtTi1E+dcxENi797INiwzF8uwRt703DD6pVW+Y35jihcRKYdtgKXVdig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=id9hK8rK; arc=fail smtp.client-ip=40.92.43.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="id9hK8rK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAZgZoOXIZz3Vp4DyEdyUMvtZ+zv5wSI6WIbUoI6h/h6X9NRLFZiy4O0anng3pVRSQoVzPTvyBLDX5OietYnPmfipdmU4l49Xe25vVi3uVlkY/wQD39aJadQM5XfaetpnONZb9vJgMGTHNui3w2K/zDo6Vt5o+SvyHQyInBRCXlTbMhRxNoxAan9aWds4boqO7WjHH58jmCvKXnMc8LqpUJ+NBAGlsv75rn+lf69mQBsI+SUIWUAC5NNbVmKcIIidT6dGTypiI+DyP+GCkI8ro+LmwHEa39iFC/JQC31ihk/7nCiAcUvxOFw+b485lXSmwI7eh3nsXLIJPTPZs0a+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wfvv9FnysrRqmNUh5ZsSqs8t+/rsu0FugKwVmkUu4o=;
 b=FwW+hRFMHnEZeMVMnVY2xYBUhLQwAvox5mEVMUqKk0dR7sk5qjbjhHRROOsSOVSaI5XofkHlEVJq3KarCPjsAYg97mZuTAN0lFzeGlDSEPYVKVxekC7R6o55XKWzLPTs8nZjx5QcxxWbBsZmCCn+i+gqtqi7m1jHGhkWuBMAwxF61zsqG+oYTwg0CEPFxoG5sbSS5bXvum1XY983QGO135hlWey/HoGTvlI6QlJJosfMpH2OtCgZLoHqslq7e1w7uAtmB/OeKvgRfowJ9jDK8/brs+SOh9gHLHaGzGMmIiT7jE3C7chr+B3Z5Xk2zrRJHPSo7Kt/AaIny5MSb0FoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wfvv9FnysrRqmNUh5ZsSqs8t+/rsu0FugKwVmkUu4o=;
 b=id9hK8rK3GqUD0D31gO5EabL6h7wYD5MkLd7nk4Pg4OCrXnOVgQuM+FYmEkupfaHp6r/84Djsc0nYDbXIP+3Q96Pdkz7r3+9+BTSUm3Qnhbccu167mLnoWE6/+ap0HFWQt2ASgb7mi3T4a8rGHe0enL1hAPjrXquRQV8SVDlIWCel3wz91rkTcBvEOWK+aExChzpgZggk2VXtIiZ1vbb/memsMgDmJVl6q1bSk/FNWTiLfgUidiODd+Y5Yx8MwpNM0vkrig1MfHg/JL1ILDG/lgSFsEUx9IlwIY1PxfN8zlIr3+I1+YTO8BVBcOTFW+jpfmujz+RCaLqn1F5i3Le6A==
Received: from DM6PR12MB3194.namprd12.prod.outlook.com (2603:10b6:5:184::13)
 by LV3PR12MB9268.namprd12.prod.outlook.com (2603:10b6:408:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 10 Dec
 2024 10:13:18 +0000
Received: from DM6PR12MB3194.namprd12.prod.outlook.com
 ([fe80::289b:7e99:bb4c:eadb]) by DM6PR12MB3194.namprd12.prod.outlook.com
 ([fe80::289b:7e99:bb4c:eadb%7]) with mapi id 15.20.8207.010; Tue, 10 Dec 2024
 10:13:17 +0000
Message-ID:
 <DM6PR12MB31942663D6302E7DBCBCE25BD83D2@DM6PR12MB3194.namprd12.prod.outlook.com>
Date: Tue, 10 Dec 2024 18:13:07 +0800
User-Agent: Mozilla Thunderbird
From: Yiming Xu <teddyxym@outlook.com>
Subject: [RFC V9] md/bitmap: Optimize lock contention.
Reply-To: Shushu Yi <teddyxym@outlook.com>
References: <SJ2PR10MB7082DDA3ECBDD9A7A649F558D87E2@SJ2PR10MB7082.namprd10.prod.outlook.com>
Content-Language: en-US
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org,
 paul.e.luse@intel.com, firnyee@gmail.com, hch@infradead.org,
 teddyxym@outlook.com
In-Reply-To: <SJ2PR10MB7082DDA3ECBDD9A7A649F558D87E2@SJ2PR10MB7082.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DM6PR12MB3194.namprd12.prod.outlook.com
 (2603:10b6:5:184::13)
X-Microsoft-Original-Message-ID:
 <83b084b5-4529-48a5-bbd7-2b1315e8dc7e@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3194:EE_|LV3PR12MB9268:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a545dbc-c396-4b1d-8df8-08dd190343de
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|19110799003|8060799006|15080799006|6090799003|5072599009|10035399004|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clZ2cTFaa05HRUZWT2NhVTNRZmZSRklBbERlV29hNkNKZ21uVllpam9KNUZY?=
 =?utf-8?B?eDl3NGdiT3pjMmtJb1NLVTZPNCtMcExMc0U1M3dNM2RPb1hiR08vYUJuRVNI?=
 =?utf-8?B?a0RaU2JSRjNwbU9VUWJYakFzSTE0ZmZPeDhrWWIrWWQzamU5T205MldrNTRs?=
 =?utf-8?B?TnBhbnBtdk5oVFQ5Vkp0Vk9CaitsMDFlSTFuZ2MzWWcwajNDUDRlWWwxS0JR?=
 =?utf-8?B?OFNmY1dnR1NDbUJYRk5KNDh0M1VqbWROeUZvN3c2dDZZUTc2S3lKVFBoaGkx?=
 =?utf-8?B?OWlkTU9CWVUzK1hPY0JMbHcrR3hUOWtYMS8wdUJTWElybURZU01yM0M2b2VZ?=
 =?utf-8?B?VzN4MFRvMzVRUlJrYjVXRmNvdjFrY1BMOENvQXlCL1c2VUJOOWIvNTRXTVFS?=
 =?utf-8?B?V3hJekpUNTVFMGtUVXd1UzZna2kzTml0TVZvTXhqVGZMVng1K0RlcnF5VkFM?=
 =?utf-8?B?cDF5ci9tdTBkRzgxeTVJOXJEaDJkeGUzYTJ3b1pQK2JEWUsycE51bklXVS9P?=
 =?utf-8?B?L2hKZDhmNW9wUDZ2SFJqNGlESC9FaStlbW1SUWcvbmx4czZtUk1reGMwcmdV?=
 =?utf-8?B?UDhNQWJvNFFiTzN6REM2SFpEckhDVHEyR0Q3bjZWMWU4a1NJdDk1VDI4QXFk?=
 =?utf-8?B?VFNlN1FWWW96NEk3MGJXaSs4MXk0bGVqV3ZCMC9YL2MyL0gya09SbzgxdURS?=
 =?utf-8?B?a0VBUUdwSDRnYnJDeWxRaGZIdDl3ajNTazJWM01FRDAyK2dLRjRLUUpHaGx3?=
 =?utf-8?B?cHY5Q2J6dHUwSWo4L2o0aXZ5WFh4aWd5TlhSWjVDdW9CQnpneVRBd1k1VkNB?=
 =?utf-8?B?c3d2bzY4N3lCbU5oSnd3V3JhWFdPRGZEeUc5SWE4TnF2QWF3MmNlaWM0VStz?=
 =?utf-8?B?M2RIRVZwUkFYclNsSGcxVXdmUVNZUU1MOUZWWC82d2FDOHBoMkVLTXFiZy80?=
 =?utf-8?B?M1drc1pmQmdHWmxNcVhVblp6ajBuNHV1UEtDZXJGOWYvaHBGa0ZnU254ZHBn?=
 =?utf-8?B?aWdERHhCbEd6RTZGdHJic2RZWlJiVjkyakFTc3hHVzZJOHhNMnBma3BkV2dI?=
 =?utf-8?B?ZU9wQWxmNkFlV1ZiVGdjMS9HOVI3VG1iUzRqdFc1WC9yKzAySnJjK3NJR1Zx?=
 =?utf-8?B?RDlVY240cjVJWHJINVRUM1BQVXFNZkE0cGNkY3BRTmRYbWxvV2FVR0ZnUkhQ?=
 =?utf-8?B?SGFqWUtSRjVCcktuaHRPYW13cERaeEpJbzFmWm95ODRYRStPcmZFZ29SZkxZ?=
 =?utf-8?B?bEcrTSsrcUZVS0pGVlpXaEJpc2dXdExsVVlyMzYrNkp5OWhld050eTJ6WWh5?=
 =?utf-8?B?dVU1REYyR2hLci8wZDY1MGxnSUR2UWIydVoyWWg3M1NuSTEvYkRBMkV2dmM4?=
 =?utf-8?B?VG9LSjhPT3hPaTRHMm1BcUlLa0NhRjIxS1JjZ295V2dwWlRYam1WdU1jbTRu?=
 =?utf-8?B?Rit0SFZxOHRnTVpQYUNrZXlSOGlYTWRCU2JmcjczQ1dQeUQ5WExidDZ0b3dG?=
 =?utf-8?Q?Cqp0gg=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnRPdENrSnBsRjQzRHdjT1VLU050UlZDbjVCbGs4Uno4NnBTbTNKSEEreVQ3?=
 =?utf-8?B?SFdLeXpPenNZVEtzRzV5Vm5GRFQ4NWNsRUJvdWVQdjNFczZXYXQyWlBjekZF?=
 =?utf-8?B?bnVpaHdEYlZMSFpXRWhEOEs5KzRXaktESDJNWEpIZ0VDaFp5OEd1aFBQVzhS?=
 =?utf-8?B?eUVGVythR284WHdhM1VWOUxReklIQ2FVZXlOSE5lTU1iRGFEaTJDeXJOZ0lS?=
 =?utf-8?B?Y0VwZzF0aDlIaVFLNE1aeTZYUU1NV3VycHVtK1FrOW13R1BKbG5wWnZlMjlz?=
 =?utf-8?B?VzRrSGsyQ2xGclUxVjNsTXkvMGJVOWwrSkpFNlRzdG1Db0hxZEpvNWd1QjdZ?=
 =?utf-8?B?dm1RL09FSG95WXRyMFdEeDBGMDArRk1yTW0ycWEwTnZ1c05Sem1WL0RKNW41?=
 =?utf-8?B?VExUdjFuQUVDSkhrdGR5Zy8xSFcrUDM5RFdPalptOWxRWGhmVUtTWHJ6ZUhx?=
 =?utf-8?B?UkNiZXMvN09hdElyNmJXSXU1Z0pGdEgvM0xRK3hXZDd4M2VzVnEzSHBlUmFu?=
 =?utf-8?B?SmRuVXptU0JSK3lFaU1pT3BTWld1dE9HQTMxZy9EZnBFVmM0RGNHdmc4QzFR?=
 =?utf-8?B?WUN5Y0NWTEM2WnB6djkwVWpiZGVWRmdicTkzL04zenQzODBGUXVDeHF1Vk9s?=
 =?utf-8?B?QlJFM01jK25oOERiVnJPWmRHOEdSeDN0LzFsd0F2N2xNcUZNNW00MXVlYmJC?=
 =?utf-8?B?Ylc3QXU0QkNoNnUvekpoNXFSODJKNmJqWU9FbjVYa25GeGtmSzhWcjExMnJr?=
 =?utf-8?B?dFBVU1hoOUNuU0p3Ly9sU3JKN0tXNTFuMjJUU1NiNDRqSWtIdG1yNk9zQkMr?=
 =?utf-8?B?MGFGcnJhTlphZGdnV2lGZ0EyTDAxSnB5RE5DMnlBTkVmTVRZZTdyWXp3MzdX?=
 =?utf-8?B?RzRrNU9xYmQ3R1JJYlczeElrQjZkTmhGT2RCeCt0aWZsamxyMHZIVnZkSWtE?=
 =?utf-8?B?Ui91SE80TDJGL0szdUt0emtLVjNKdzJLN04vS25UOUFuOXNUNVdIUFFkNkh2?=
 =?utf-8?B?UUhiU3ZzZmhDaXlmUC94VGgxZHdhbkVNR1lTTW0zTmkxZFdHV25rVkFpTkhV?=
 =?utf-8?B?eU9pQ1FXMm1HV1pOSVJtdTBHY25NQURmYk5BL2h5YU4wbWVGcGlJc2Q4K0hr?=
 =?utf-8?B?eHVVUzAwYWJEREY5d04zYzNsdjVkV1N6NldLR3pNK3hpakRsdW10REZxZXpY?=
 =?utf-8?B?RGlURFV1Q004Tm96eW5Ba2tCQm52MUpHRVltUm9ESmcvRnRLSG5wR054NFNF?=
 =?utf-8?B?OEtTb0JaSTBGdjFxNzRzZDgzM0Z4YWNHc0VPdWNPczdyQVN6bUhEUTA4VDF0?=
 =?utf-8?B?cnFDczE0TUFGRVBvVW5OaHZzbERVdmgrZjJjb2hpcDdQUjNmb3pJYnJ4Mk4x?=
 =?utf-8?B?ei8rRHYvMkdLVjdCa3FlUmNlOTBET3Iwc09mV3lQUjFJOE1VWEVSMzVnRjU2?=
 =?utf-8?B?TzVtSGZMK3E1UzBQRDBzRVNRbDJiaW1xbDJpMEZ0aDl3L2JDQzd5OVNPemVk?=
 =?utf-8?B?RHZiQWw0cm1kWS8zWTFnc0JZems0cXpyangwN2V2OHZjWkEwTy93Z1hLcU9P?=
 =?utf-8?B?aU8xSEpGRnVrMGMwd0Jza1RxZklzRzVocjZTNlJ2SlJ2VlRzRHpmcDlzUmE2?=
 =?utf-8?Q?7syiX8GAkrTjKnqyyAXVy9Zha2aebTYJn5vAlSPHyReo=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a545dbc-c396-4b1d-8df8-08dd190343de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 10:13:17.4570
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

