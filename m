Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B498736F90A;
	Mon, 31 Aug 2026 19:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204364; cv=fail; b=qG23Yj5cXKyMuAJcLePrlRMDCxsE+RvxdzqApD/PYiFsUIEyu6hG1L7n5MPEtXUQEo2sf25BaHVp/ovFXQbktCIVSxaVeaTrcmB4HuNXBZfiCkcKN9JI21q7Efp/kEsvKfkqtjoR1AOjopXKF3A6sJnE3aAQ2fQiGWvYth17n6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204364; c=relaxed/simple;
	bh=aK9mOhpFt7XZggxW22GEovJdLOclN2q4+ttFGV73rxM=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=rP3DIedcCzYoap/cpVCRpvlUC/h+lcDD114zqmMIk7VsbjWH9ebAZRW90/cTkj33jUjh07WjwbrapuKhDFgIWS/fKayGI1+qvMwsCZ2EmyrP0Tcd82CjihCv/37FGTAAl6+d5I3BJtvnhA7SovBlZ/i4vD0kWUfv9rlp4Wktgj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VUsQilxe; arc=fail smtp.client-ip=40.107.200.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VUsQilxe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4rsVKKlHfXh3l4lMZIUOgJlCbzBMk8CaSmABQHHUUg0oS03t4zSd986OjGRr/83HHbHzYdmfYAfCOk9wPgmSePf+59IckyOaWNIDDOy7sIZg89xfgm+SCO7mq3ZZtff1dJrzWz29NwwzCLTqDaLfnC9A9IEZzG4ItHBFNbAIPahWtEhySkA13780r6eFGQOs5F4y21kQ4FSNT0RWunzCtwoWZe0+WDP90HpseWdrswC5OnawDbw5Z/8zPtXDqVEb1DhtN2KmrNPo+y5TSLyWAmzuMBclII9nTFD51MyuV2x7qWuEJUnVoFZxu4+rusoWCDUnE1XeOLVdH+ttGwFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=c1pF6WlHeUOZjvTMZ2a9dKoW4IuFLkxUKxs17zLhHkhNV7OBdpoKZAvsh3aIWz6iD5h3rWOEI7Lv/agoHtayIUFdSRv7q0UiPsXCkXKlUauGc7qYkhPBn7CSHceG46w/jPWTxqB4fgUTnxl5KMdk8UQDuNO8ouGwy7XddGddJQB3HA/JJoW0mtkJsWJULkGh+ONPJHWaFsCNW8efkG3Hj1mefD60YL5UMT4s1yTJMfaOPkhJEQ+TNe4E0tj2YAySMGYwCzX+iiE8gXP95+fNUhPqkMrUy2bFc+wqp5bfLNAamFVYZXM6v/K4ZRVKZs1HArx6SN25MxQp+hVUYvWbUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=VUsQilxeQ3CeDti/jJ9ypcIEl9HoIaLBDvQyVi1yc6wnS5BujojGLUK89fkUjtkJTlWxYdZuZh1tpOQSrn2DVhyzzkFFqcUKy2sbap0WT0tMKpuGPHbWkYcFmlU5SUcqcU7wWV8xInvYvBbVBeGb1AeolcHInStGbcEG3AROrgeKJgQeIC+5Uy05XcK74NR1JPvsUYqq8RqNFF8BLu55Wr1YP8fjLUFpUYbrOlVGcXZpnd2X/JxeL2DzXwxQbemZacobPGLlWD+FnE7lSHOhsMUsEe8rPeEsvcyl6HdhA6EWNapTwtQtsa//zf4mKZgK6tIDCeb7X20azJIHPmjSZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF0C60B25BF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 19:25:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:57 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:35 -0400
Subject: [PATCH v2 12/14] treewide: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-12-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
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
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF0C60B25BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 2550fb1c-0298-4b3d-e2ff-08df0795ae4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	JH3lEVF9GXgssAzehBT3UTWIKt4T8maLh+X5fH/4Sa4+3ICUZG+JvlNdorOcUJy+OxL230VySQnWB/yy/9D2wET1VNaR2BZHWdqPq7PdAPb7mnH12U2GmSvEbbHhYGBxpMEr1jfHiopqblgeKofUEUnkP5h1Kjll4ZhfisJnKU0C4Bis4Gxt72kUEQgCHb1/XDGHWqvK/lgBU+nL6apX8y427SkeC2XKFzAWTj5MgkCWhsPLO0Tzk5lMm53cMvH4p07mszjCVb59Qgr/sHLZVWjsevf65Q55sOyZ7Bjp02FZv0jsQGyjW+dn7DCbeVgTlo/UJIcFWxNYI4pkafdR2xkVnEUXzENQ1a0mI1V8LqaiQhAYPUKUiXB5A84JwO3l4DWUT+7XZi618+E944lFoDuenFXyldjf20SIR8axRA8frW7Rp6Js3G8KNCsvVRvtwK2l/8vaGgmUBvanbmqRqpsRwq6dyJhgFuskpEUlmnQbHiyAn9qZzZOqR5050VKDMsknAJAnWr6muVEB0+d83tBlx2KBtXt1LGqaMQP/NTeX6GtQBsJF4Lq3exSuW20S8m9+mmc1PSaDXeMgZO8WWqMvOAwu+PtnoLywswaeZoNyJeO6jVDEfVihL16KWKaNzFTVE+TeGMGT2x9hxG3RKKqcXZd/hqhVwHVp9mdAjdKmsggHtp3ZCNbSFCvfcJHzjx18V2GxshChdGrp91efqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2c3TkxIZ3N2alRhemJWK3EwYkpkelF3Z0xyb2NyUUh1Nm0wQ0czb2pHbTJ5?=
 =?utf-8?B?S2pzRWFWRk5pRXBsR254ZEh2d3ZKR09hUWJCZ0puUENNaFBzY2JuWjNWZklT?=
 =?utf-8?B?RjRiK1IyaEM3Rit3cGpwZDRjOTZUSVdCeTFHMGZHNVRXMThROEIyZEwvekRI?=
 =?utf-8?B?SG9Sd28wajBRQlpEVnNvb004Vms5VC94amhBcC9BSTlUM1gvMy9IdGlHb0U1?=
 =?utf-8?B?d2UzOEtSQzg3cFZ2WjEwNGhDQ1dic0VETkFISjZaK0JOSm1RNEdFZjlCK1pR?=
 =?utf-8?B?SUYvMW5TZkFDMStLaTNJalpSUVZhRUIxV2RFWkRJbkxRNHVObW0xcS9KcE1l?=
 =?utf-8?B?K3J0MVR5dzA4NnQwUlV5NG85QUUvc010V0JHdXlOTm1VV3FiOXlKSG01YmVo?=
 =?utf-8?B?SVJqNDRMSUhnQ1RGcXBMdHdnV0w5TzEyb2ZVTG9zZmZzT2V6a3d6REowdldX?=
 =?utf-8?B?UFM4d3NaM0IvdWZ6cC85ZWtJUDJNTmo4ZllWVkNseGVqZUFuRWNEMnVsSmdI?=
 =?utf-8?B?a3gxbm94d3VJZkV0RmMwajVaMjQ0RU9INElBaUlnRnFSc0N5YkdyR284YWt3?=
 =?utf-8?B?Y1NKVnFNcnFweGRYZjlreHVON1g2dDNydVdBQy83T2VEa1MrekdCWENlWXVC?=
 =?utf-8?B?dXhLMnNQWTJjaldWMy95RnBVL09CZk1ZUmVRSnRnQUhjVU93RUl6VXpZQi83?=
 =?utf-8?B?eUxyVjkwRTNQdHNpY21zMFgyaStyRjBhV0NkV3dNMndTOFRsa2pVYVVyRnhz?=
 =?utf-8?B?OTFSZXpNWk13NlhaQStTME5RUTB5ampuYnRLYWJra3hoa1UzQUR3QTJuTmV2?=
 =?utf-8?B?KzB0bnMweXVPcG03NUZPMFN4Q04vZldBUTV1TnU4MERYVUdsL3poQjh3RS8r?=
 =?utf-8?B?dUdyZkd6VitMWHQ0Vmo0N3FncFpvRzQ2S0U3SW5zbG9sRVJLRkI3blVWTFBn?=
 =?utf-8?B?SjZoVXVlTjdxa0FkMEJKeDhIZ1QxWXVjcEFJbzh4YXFsOUhRZGo2L1V1K1Vu?=
 =?utf-8?B?c2wrRTJ1cWF3SEVNR21TS205WFhrK1d6NGRIa09zY2FwLy9WK0xNVjhLaEFa?=
 =?utf-8?B?Q2prNlJSMSs0Mk83dlZ4NDdza3M2MUN5dmtReUVjR1ZQWHFLVitrY1U4Nkta?=
 =?utf-8?B?UHA1S1lOMEJzMjl2ZGZkMkhXVTA2QlBKUHlhMEpaUjJIb2tDcEJwNVQxbjc2?=
 =?utf-8?B?VkxNSHQzUGZwY2oxcTFOa0JhQ3RiVFdQVWNWemg5a0JRYnhPNHZZbWt2MTlm?=
 =?utf-8?B?RHphMXdNL0grRmJvTUN0UGNOUE9rNnlXNnpmTXcwSzFXS3dSanBmam8xWmlu?=
 =?utf-8?B?WUxiUHkvdGYwMS83VGYyaVpCcGxDaGxVNkNZS3Y4b294OGFXb2Z4bVpQQUJq?=
 =?utf-8?B?Y1VweXBNVlJXTXoxMFdOS2FodHdrSTEwdkZqeGtkSVhENTkvQ2RBaGtJM2d2?=
 =?utf-8?B?MnNzVkdtMUhnNkVGZmE1UmpDQlZrUkwrZElnOUR4d04rOXJjTnlVWXJGdzNv?=
 =?utf-8?B?eWhwaVQ5N29hNm1wUlM2bm5adlFZbmNYQm5OOGQwV3pIRDEzVTJlbjE3eXhR?=
 =?utf-8?B?LzFGRkUzcUlnVVRiVDJSeHdlM3ZkS2YxelpwQWxHNTUvR2tSQXFLTUY2NFJL?=
 =?utf-8?B?Rml1WEhmQUExd1dyTG5WK3VBUWw2VGFrcnZzbXpvbHhZeXRLS2Z6eWNuQ0xU?=
 =?utf-8?B?Q0tQUnE2YVdGVCtzTTVoNkxhYzAyYW5QVTh3eGl2eHUzQjhSZE0wUHdqM2ht?=
 =?utf-8?B?aUY2VVFhUVVFUGxtTTdxU1NFM1FxdnBWVE92TW5nSWlqYUF3SE4xMnMrVFEw?=
 =?utf-8?B?R2FjaHV2OXYzN250R0tzejhOb1pFbTZSMG01MEtwdCtFWllKUzNQVlRsTmdy?=
 =?utf-8?B?bTZZVlNXckxzTWhFUlRGT1V2QnNhMkFBcE1vVDNyM1hMMGRMVUpFeEd5R1FB?=
 =?utf-8?B?ejNkQndOMm52WFVKM3QwbzhDZ2xLTUgzMHUrQ2JQa0Q2N21aUmM0aGh1c2dJ?=
 =?utf-8?B?L1oxU3YxNnBPeEx0UzVock53SklyeWEvSWZYTkFobUNWYXo2R1JncTBtdTRV?=
 =?utf-8?B?bFpnUk43bnJQc0xra3VrUk5SY3BSSnpxV3hJNE1PcDJTT1pncTNEVGtzWjVq?=
 =?utf-8?B?dHpNMThJREdRNWxwYVlBa2dOY3FrQ01zTTB2S203VkVBNWEyTUR5NyttWGxj?=
 =?utf-8?B?endtS3Q1UlpFeDRZTllidnUxcEFJblpQcFIvVzVMbnp0U3FVMEx2QWxOaHpR?=
 =?utf-8?B?ZDNDb0RVU0U1clY1LytIOWkyVVBLaWEyVHBQU1dsMzBLTUhJRUhNaWp2bFly?=
 =?utf-8?Q?zEHfdWQyDvb/mUF+RC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2550fb1c-0298-4b3d-e2ff-08df0795ae4e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:56.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ByVAZ8Vxubqa6jljEwUkIGzOk1lV0y8b2Et+XbhSlyi9msTbhRc9DbcEiNblmprq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0C60B25BF

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
index b8325cb09a371..0cf14bc1cff32 100644
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
index 657c2cb0f8811..fad17df1d5082 100644
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
index fd2c7115c0542..e47fbd0387b69 100644
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

