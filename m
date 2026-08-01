Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3EB3CF678;
	Sat,  1 Aug 2026 02:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785550646; cv=fail; b=HD+KUv5afSHQYcbiYdIHtF5FSMbXmdgj2YBQIR0fXS/zXIkOKfRQsu6kE0NdnctS2uL89D5/+6HkSgTmVlRcdEkT5mwZnmoNEkXrc6edyvj/snPvI2va7vti/SPixKMZ1zOBu0dIpV6EvQmJcKq/mmNQpe62e6k9IO+hc3vsnro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785550646; c=relaxed/simple;
	bh=nm0Pl5EDyQGxBl7iOm4Btby8IKLKXykDG+VrdUgjv+0=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=Asq/1ZHwvg6+itIqdDkKtz2+vybkkCawhZJPteCwiywHcRs5+bQlXdmo/JJ7TD/7X96fS/krE/5ZnvOLTgU1NIohVtpl9g45T+xars52kPY5nCA4s3hy6o3cjI44/RcuXhQcJVASk0kpwHcz3Ljhu77gowGXu+pnycHoSJTyTrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AkwXcHaQ; arc=fail smtp.client-ip=52.101.61.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AkwXcHaQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQXipCbDCYZvd+/4XVq9SqIDa4M46ysxo9SMQUoGKg4RQqGMOZDbYmu7ZwhXA4c3XEk0Cfqch+oYixiD+0U5ZRt2CmwawPhJMIQoeksBZ591VWaxf8NTy4ZzxWCvsZMcoDnFj59kvAK8IVq0L0nOi6WzuKMWaifDhwHkdv7re/jJ29xzCvWZfI45ak8sKaQ3Zhp29Iljj0MBPT0BzXs9xGJAc6AJgdszmpRb9CCbV7Euodjp0VKlt1fdBmlrdyiPITSaXixmwcLhN9J8m4p4eTy94dv7izfvPJcIM2BErqWa174E+qKmt7/eLnf6PN/SBqc35WchwvLdt5fI/zWEXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJvqsac47SOz07N8rXHOifzxid6Tu7zuGdAeXj6PwQ4=;
 b=aKE1ANh/W2SMmTa8lpNXRNLqfjjXoGja/D57COTozVcr2hxQOQquKEAZ2W7epYdG4wFwB4d4+jTsGIPzLeBqqubpk4m97CwB+1hBFbSZ3QP27R5NZ1V52YkG41wvNjg+z0xlbHhLHRbelQhbky3GIUXGCyAIkAudyR4QVNs5uUl90iVdbyrLluvoe+53PSyEJA6fDiqDZRPRhyvk+SNzSGyW0fN8wLIKOX/gxjp2HhBsLRjjeLwVi83NGVz3sMIhaxXao2tvGp9wIZj/LrxJx1D69tjAFM/46eUBEFpaCWV9zCo50MlzcNdpZYsClCSGp8QmKjzrlQBchKxrLNPegg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJvqsac47SOz07N8rXHOifzxid6Tu7zuGdAeXj6PwQ4=;
 b=AkwXcHaQXUCtmjzvsKXGpGgWTsaANzZM7Pi6ONGCU1udySxEuq/gx+xEt734XQ8CEdNPHztPcYVaKA1UxazdYY73GruIhO9TWb+n3gcheJgwx1prGS+XACBljG+dfWllgheQJbXV0ojAfTaAZU/757JtaHwIWFt6CFSzWNXh7OXZl7xpyRfijA/NaSl6z5joroamQuztarVPTgmWzOdZmhq53L8zVGm59cY1Dm+xzfPTBTz13avBEjekNSkFp5ml5a8ejFu3c9fmA/18y0oIWSYyGZAJg4aLRi2Yf7jEG2sv3oHGrTwnFaAo9ZgAausHcXs5s3geBVDF4rxxOXC/ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:17:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:17:17 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:35 -0400
Subject: [PATCH RFC 12/14] treewide: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-12-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>, 
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: YQBPR0101CA0256.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b24b9a6-03b4-456d-ba7a-08deef730283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	l8VW8MJNMQ+zKeBjGBMCtZ58ZO0GJCoiULSAWZbccsAWxRRS9ApCb59D/Q+aBD57LGP7WBCTJTuYvelhJB2yQs+66T3FHO1/R2juJO1IEqZY4nw6af4CIrRyvJ2JaZKbTUe/ft2q9i2xTCjhkGYoQQiQHp/USVGdjuLMlft0bbxW7U+ENium7Y/DfY12RZlZtIuXSEaMV6NXhspOtdlf0waD69tVUx12IjyVzCiSl8GYQ74Qt3it4WvRgf2aRmhHNKuWqtAkBgoMej44Nem3ztcMsstmfqAJ4LnqKK1nik56ZSrTxHKuo373XamvjvTaFNe/ntiN6jaK0RC09TGF2c6Q3dzgkq0eQtV/pUvOfbAHk8iMZIE1rfcfuCC9M5/MM/XQ4VnEHPjJrZ6Z9j1HzZHS6ySDRyM4C2ZwhHLJFXL5mt+2fMRGjtK7bhzy517jFJwF9SLadFXvsQUGwnYkx37wP6UeiPYmyt4Fx2ngK6vZN1pJzfTN9CdKlBMn5sPSEU532cuoEPk2lrmNYFA17cqWL/ap7X5J4oTKx0AbCO+Cd+0blmPpLIra6S3UaXThT8QSzy0QcvnMNtj733s8eVfwPJNgKdUEngTRi0evoI5oXVPtadOJi9INCGJzeMtbUUORhTlf4vJW4mBn3iUb/656OyQ5gExROp4jk8b4OmeHSco9qoqiXFliqm4NWydGKwdGMgrfy4LeIF4//IGNHg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUtsV1VTaEhBYVhZdUhQS2NXN0RGWTlwdVJ3SDA4RXBtblhDa1Zza3lHRUwz?=
 =?utf-8?B?ckZVVVEvTmp2Qlk4d0dWMEQveml4RGhOcG9uWW9SNWF5SkE0bXphZDlqYUYz?=
 =?utf-8?B?a3ZoTjRGaXBXSWxNV01sdDgxQUlKdkIwQ3dERTA3MzRWWmxDZVV6ZzAvVitI?=
 =?utf-8?B?MWcycGd3MnBtT0h3WXJyV0VxMEZMTGRsSC9sUmVVN1VyQVFIVFRhUk93SzE0?=
 =?utf-8?B?ZHRCYml2dW9kZjF5QnFoNmM1c0NGR0FWMVBpQThId3VyRGlJZmNrbVlzMXRD?=
 =?utf-8?B?b1AzSUFkZXUyaWtVbFp6WFdiQ3JFRXFLMmhPNHB1MVlEbWJFai9xYUV2ZEF2?=
 =?utf-8?B?UkcwYXlVQ0F4aENpcU9XSWVOcVYydHNsZnMzdUU0Y056WWJBdVVSa0h5UkJW?=
 =?utf-8?B?b0l5NjI5OFZZTEcwM3R2dDBFRk5ra0V2YTYyazB2WERqUmY1cXpKNExmVUFZ?=
 =?utf-8?B?UUxDSzlZSDQ1clFDTEVlYStpYXhMK0dLZkhRd0sxTGpKOHZyMWc2S3hTVEpy?=
 =?utf-8?B?bWM1TS8weG16d3JhdnVKWFJ2V1VsRitleW9NaE5pRHZJMXBTbGozcVMrUVBs?=
 =?utf-8?B?WVZJZGlmU2VKbmgvRklzVDBHaDhkSEhtSFJPVVEvZXpvbDUxbUErK3lQMnpF?=
 =?utf-8?B?OHZKTHpjWkN5WGRCRC9qWDlLaVJNcjI4TlA3Z3luYjBkWVpFTlFUTW5MVFVy?=
 =?utf-8?B?cGduczdTbHZyeDlheXRMejdxdTgzQkZnb1hEdnNFaCtGTTFWaWxlQmR1LzA2?=
 =?utf-8?B?TS80U3FWL1kwUVRXemllVzYvMzEwcjZUb2liaGIxNFYxSCtsQjdiaU1jWXZH?=
 =?utf-8?B?N1dNQk01a2N4S0pWN1pQcXd2ZmlQTDZmc1d6dHF3UGw4Y2tYZjl3SDBic1ZV?=
 =?utf-8?B?U21wcDZhTGZ4elRYNWh3SzJCR3l6WFB0cGxRSlVBNmhKTUgyVUp2Tlg3VEJM?=
 =?utf-8?B?WjlRUHloa05BSXhKTmgvek53cGJQM3NXU25EdXZZQWxsRVFvQkorbXlIMGtI?=
 =?utf-8?B?eFUyV0l3ZXRqTSt2SlZReUJTUkwyVzZOVlUxdGRBSTI3M3NzU21NQWFyakdp?=
 =?utf-8?B?SVVUTnRlMFppcmtoc0xITlY0MDhpaERzbXNyN3ByWmlZVEFxM0ppclhaR1NM?=
 =?utf-8?B?bjIyQVh6Zm5JdnhPSTZMdjJEZnozMTRWMHJ3TXlFcUJSSzFFcVdIdzdzUmdi?=
 =?utf-8?B?QUxYTVJPWEJtbnFZbFN2dHd5QzVzSlZ1aHFKTExqOFpLZm8wd2czZkQwL044?=
 =?utf-8?B?dVNQby9uSUlsMDZhdVQrcThCTkloR2NPZ3AxVG8rRnArcXUvNkQvTHUvZ1lL?=
 =?utf-8?B?R09HWXdrYWdLU2NkMnRyN3pJN0FicU8zS1F3bFM5VG4wYzlxWmRRcDFRay9F?=
 =?utf-8?B?NW1EVUQreVdhZlpiay9ta1Zjb0NQN2FKK3p6TWlpY0lhS0dFT2hYMGF0M1lP?=
 =?utf-8?B?a2xaakJQaWZaWUpmUHN5YWxweHU2MVRXNUg2d2JHWFErRG9FaVUyQTJxdDUz?=
 =?utf-8?B?ZCt0N0YzSkkyZlVLNXZQeE1Tc0JDZEE3TEFDNVVCOU1DRTd3OG1WZG1iZXll?=
 =?utf-8?B?UFBENTR2anhUZDBIdWc3STdvY29VL3lRMnAvS1lZSmZiWTZodWVUL2xlNTU2?=
 =?utf-8?B?UmR4VmNSMW0xbkltaXJlNkd4Y21iSTFqRzRKdmVZWHI5T1pBMnVpUndyWmV2?=
 =?utf-8?B?REF4U2hWRlk5L1MzNkxZVEJQZVNHNTFZdXQyZ0FINHErZGxicy9RM2FSTHlj?=
 =?utf-8?B?a29NOFozaFdVbFhpeE5sbGFrUEJvNHA3VXVGZFMzcWFmbTFYM3ZxMUJGZW91?=
 =?utf-8?B?bzF0NEVYNUthTGJvSVZrS09TSWxZSWoyZEFmdG9NS0JDMTdTaFRaRlZFQjhX?=
 =?utf-8?B?TDVpdzdkcTZTQmVLV1hOUDRJK2tJNzNtVjZwZnE0TFpRNDJvQk4xZUQ3cEgz?=
 =?utf-8?B?TStJbDZMRjlISVhBWVFBRFVaS3B5N3BsaG1OaDZIQmIxRnR2ek1pSW5US216?=
 =?utf-8?B?L2pOR0dvbmMvZWNQeXE3ck5BRFhXckhneG5lWG9HdU9IWUxnWFhINUpSWmtQ?=
 =?utf-8?B?eEpBTnQzRDEzWVgxT0RhMnNFWk5MeXlHeFBmZVpRVDZJYytnM3l0QmtFbTdO?=
 =?utf-8?B?ZjFMQ0J4MkN3RmlkV21CSG5BY1dsSlVXeWZrNzZweWNCL2d4TmlIL3FxV2kz?=
 =?utf-8?B?SVRyN1ZzNE9yMkx4OHg0ck8xZmJtakNYNWZUZEZZMVVzR2NTKzNyeUlRclFI?=
 =?utf-8?B?RmhGVFFZdWlMakxZNmFHWU1TcXRHTXIrNXRyQVY1U0E2SGlZMXVTeGFHTUdH?=
 =?utf-8?Q?UzLrov+esZ6LGdKWuk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b24b9a6-03b4-456d-ba7a-08deef730283
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:17:17.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02f/mGVVjw/BV/zXEZ2LX0cYytl5N8jAo4109Yos3vyD3fPEcIEhy6hPt9wuEmTC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

PG_private is going to be removed and its check is replaced by checking
page->private != NULL.

Replace page_buffers() with page_private() and delete page_buffers(),
since only two users left and both can be converted to use page_private().

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Ilya Dryomov <idryomov@gmail.com>
To: Alex Markuze <amarkuze@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
---
 drivers/md/md-bitmap.c      | 6 +++---
 fs/ceph/addr.c              | 4 +---
 include/linux/buffer_head.h | 6 ------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0f02e2956398d..affd4807013e1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -535,10 +535,10 @@ static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
-	bh = page_buffers(page);
+	bh = (struct buffer_head *)page_private(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ecf33b66610c8..92074db8732ac 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page->private;
 }
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 8b23bc9a244cb..5cf0b8c058ce0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,6 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,

-- 
2.53.0

