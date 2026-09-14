Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BA3254B3;
	Mon, 14 Sep 2026 02:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789352696; cv=fail; b=D+NwnPK/2RqZ8jaPUfgbM0BOVNLnDO0yApxCmVAjLS8o18eEWs9SyktcYHnUsAS4YZsP7ZqUhQn3CEv4hcx47Qo+WPyDVOvW9dHaWUPk1eBEek4j5T5Ijy+tbB9VWu+nTAyrAhHvaL1A119maAmJAmrECkcKyqShpy+582cJcAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789352696; c=relaxed/simple;
	bh=CZXKL3AuFqC0stMI2NR6nbvxmFGZcvbHWKBePqH8hfQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=FmdGUhX8/w2inPzg1KoqGHRXgvffPr4XlYsDtsI3zq+miPxo4c55VVO+7/oug58IJeaieTXQdzjUjoN20YtAy2SlOeNLo7czC1vV1N8OHv4fe/BiOqWeXQQ1SmI9zZZj7OM6mvDMyhCnWNdk7q5om0fgXMVvVuZZjDodhER7qk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JmmhIZ1o; arc=fail smtp.client-ip=52.101.62.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JmmhIZ1o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAvmQ3TfVMnJfuM2O80vtht1sccQtuzzHuYOeyuvI1wSKmzyc5505Rr7eQAwULHYAP15slSXBZDJnMg8hU/5GLsa2JuiLsMOG+Y03bAcpRxNdu8FPZ17CErftTJxIsRoNv26uVGKVJ1Szu2GFroak+QHD9enzbQarEfNLTo2QuU86pcXk9XPAnUFsC8fgAv0QimD63bCTF+FX/z57EsZZnP1pk2QBsubQoBHubRhWOg9TSFthmzjd+mbJ1PnTmyqg/zIU2aOfNEP7unE/gzcOSGxjmGdCzran1arpmf6/m2gpeaVWBVlJ0zZZi+LdEN3lFMLCWLREJgnQ/APY9sxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtR909bQ6Q+E0z0K+MmOpIKOSp1OMThZiLeXMQNGKro=;
 b=YmNPWWKBZWym7wPi96EcVlIkY59+2X6s5Qudd+quC2Nr/qdS94cH1xl4XSz9LTsmLbYxb+r82lxAPeVbjwPDSHpZtufGn32TGPBPqW1U9X2Id9/qJ8BPSPN+Xko8qZDv36jtQ42APGPBDeK+8la8BsgpO7pSFMShFalpWwAUjRDZSIPRXd/+jVAW78JVPGq0y/MOEQY4UHJ7WMi0fiRdZkUaJidY7VYDc54o8716wv96unSLKfqTeNWIgjkFAxhXe9xUOMe4g7OPVDTqCYr7UDOm9xle2ZxEGjJHRxlXZGvuTwzry1oAoADA/RvPsUHut5C67VJqGqhZcC+CDMAzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtR909bQ6Q+E0z0K+MmOpIKOSp1OMThZiLeXMQNGKro=;
 b=JmmhIZ1oCwlJr7xHTFXh3bCKXYVyM+7mcy0YrsmLvIruQEUpieYBuzVD1r/yoOSB0LvBbdB2R7GaPOEyYbPb9dSCIN06/dXmNrxtVeDi+yRJXPsm6bJEfZ5sJEfJzHb02phFSR0/zqh+C80sxQ6Hs31pXA5H6lIgIJNrtx80E1xOgVckO6wHiBNX9x+MbCwN1IBmg8kL401DN0imv0KdJiridZMMEkj2pYBK5dvxA1b7xX7wLx+4lrUsy+9oAocSR54sZZ+ky2RxK338VTtNHS6U2m10fV1REU/vxjjvhDWoH4+An2qYsBpc8B013OKkn0Nuvef7whfWTSZ7phRruQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:28 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:12 -0400
Subject: [PATCH v4 14/16] buffer: replace page_buffer() with page_private()
 and delete it
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-14-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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
 Yu Kuai <yukuai@fygo.io>, Jan Kara <jack@suse.cz>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: ebfb2132-5502-40d2-9f1a-08df12074d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	qa+sMDLKj6ZR6txcfEpFQjOBSZmDa31mur1nw1M/M9KOizkExzDubtsOkyonuqXFKBUeZyu1BDyuC9CxA5Eht2l7Sa7U94CIfKp+6SvSGZWeRTEkJKCsPyM6fO2PQtV5TeKdVvRbpzyOpgTTdgCJnxwnGnM0Rm9SE1j9y23bgkaEjaZ1VxJ561layOdOumgnh2DF3uGrq1xpU/fx08SQ00maANq9eEbllqIFmQuNRSgy0po5WqFZsXVHdJlrOGb2bfRtDtA4D5erOPonIlLCGNA68x0fOnmWvQzVDnURZ4rTimcePtQDeXUF9LkqRI6cDM9nbKdOSBoghNRaHkfVmT9mep93V8iRhxzOfpTuB2WHc/iLi+pzp2+aH6B98HhK2lkJHDIDGfQsgaQ97n8fqpwFST/VZn3DFer1IJBirRdHjKOaWt65Q/LPUewstVfqRnO5huvQFru/ICNjIrJcxo74ZMLYM22xY+dIsox1N3DcxNK6+fsn/d8Iq12UfERZz4pHjBZjRlt7/FR1Wp/yUI5X8+FddeDAa4vqePfTa0eU5l35nSuSqaMHksNSDIIdFVoE1ASsbL62eK2uAmp3NtaNkVKKkanGlSzfJkNsCz8mV4EoyOI15oTIsFzfIzyhods8CRyyuHLtp89EDxhDxM69rVvuQ0vb894MxocL0VuPG1j4vKVV4IU21eQCYHBhpbiJeVDo/RMdkevotcsg+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JtVHVvU2NkclBDdW5udEg2UHlLc3ZoK2M5QUdDakNyK1A5NHpDenZtV1l0?=
 =?utf-8?B?eUxtMHRhV1FLbGpGSXdqamw5NzRiNE13NkNsSXJ0dUM2UUtWM0RCdzZiK0tt?=
 =?utf-8?B?L2FNcHJrT1VMWnlSU0p4NVJqNDNjZVJ4Tzd2WlgvNUtPZVg3dm01d2ozU3dH?=
 =?utf-8?B?Ymx3Z01UK0svZFRPMXJBb2hNd2pwQ1d6UlQ4cnRpR0VoeGFVbHBkMzRHTWV5?=
 =?utf-8?B?NlltS2ZlbnMwbHUyQ3dFT1JMbmRqRFNTSVM3M2lremVPVWlFL25rcWcxTkty?=
 =?utf-8?B?ejV2WEVtTXIrMGVFMW0zbFR1Z2p3dWZzaS8yUHgwVHI4UytFMkxQMHordVZQ?=
 =?utf-8?B?aU51dnJFZ1NZTG5DeE1DZVB1Q0xhdzBZZUwvR0dzWWhXc0Z0MExaT0NFNjFY?=
 =?utf-8?B?emRPTEZuUGs2blNYQ3VydkdxQklwREV4NktjZ1ExQldhRkJ3c3BFLzFLckR3?=
 =?utf-8?B?NGpSQW5hbXRJekRWcnFCOVBxeXdSMjFhcE0xNURRUUZKbGM0RmdNVUhRVThu?=
 =?utf-8?B?aFZhRWgvakwzZ0hSSDJnYUJqQjNIYWdFazNnTlVYajJVeVlHZGZHamFIU1NS?=
 =?utf-8?B?M2srR1ZmVFlhVTZCN3J3QlJVQ0JTSWs1WFRkZlpuNkxmT2FDYXdKUjhVM21G?=
 =?utf-8?B?cjNFZkIrSkVsTitnQWJFS3ZObmkyK0N1ODlUNGluK1BrL2RZVEo3aHNsVTFs?=
 =?utf-8?B?TkdEV1FJMFZMbEpIZFozMHppVHpnZnd6Q05GU3hTeVpqV3pOZVhScXJZanlu?=
 =?utf-8?B?NFZIZ25Rd3lKQ1dZUEEvVzE3RmNrMTRmeGl5RVJ4RTNuQjB3YXo0U2ZDTjhL?=
 =?utf-8?B?eHllUmlGL09JeFU3TjhITGtCSUFlSFVqYXpkMTdxRnRiWTJ1c29HVmVKR2VI?=
 =?utf-8?B?bzI4elA4MVE3R1c0bkxqQnJFc09tRHQ2bGZIUXhBSUJJSHZMQXhLTVFjWWNO?=
 =?utf-8?B?S0FYMkhGR2NwenJPTUxRT0NOMjRxZERPYjNlUk1EME41czJHYUtDWDc3WHY2?=
 =?utf-8?B?QSthZTlid1hVbU9vckQ0QkVPV2hmOWU2V0dKWjZoK2liMHRhQTJzYmNyd1cr?=
 =?utf-8?B?Zm9oY0YxRkNNaGlhUzF5aUtqSFhFVi85aXNHa3lyOXNIb3N6TnYwVDE1cjNQ?=
 =?utf-8?B?eWxLVHNsMnk5NzdTeDFzN0txS2JPLzZZbm9nOFRnSkFBWUkxbXZDUkZ6Mmhp?=
 =?utf-8?B?NTlQM0crdStyaTBJUXhDYnhrSG5FSXEwOVpKWHhwVEJVUktkdW5MNGJ0aHNU?=
 =?utf-8?B?VjJBQ0wxYUxXV1NjeGNXL3FjVnRrbHIySndRT0RCNXVGK0JwZWh2eXh2WC9M?=
 =?utf-8?B?OUpzVmlaUit4Rm9oZU12bmVLdW5EZlNnUTRwZjZBVzFvOWRWaXd0TFd0VHVo?=
 =?utf-8?B?K3daeTRtZ1BVSVBUaks0UnRzOGZwUUJEa3RkUzViMjlMb0xxV2dWM3Z2UnQ1?=
 =?utf-8?B?Q2dzTk91MHEwYWIwclBTR2tneVArZHRzTElrRVZUa2RBa3M0UGFzVDRMSHRN?=
 =?utf-8?B?aHNpQVdSU1pmeTBqWjhoU2grU290Z051Y05sRDRvcFVHdzA0dUlYbTAyaS9U?=
 =?utf-8?B?U1NxNjZiQUpXMmtSR3J4QnNMY2FOQUdIY3pkQlJsUGFzck4yZGZPQVUxRHJs?=
 =?utf-8?B?QnNhYTFaOGJ3L1lzRXdKSkhkdjliUWx1VWtiVVhwRzBFd1FKQkVqS0ZBN2g4?=
 =?utf-8?B?TU1EWGNxeTFRcmhrcW5TT0ZUekltMVNhRnZzZXg2eXBjdWRHbS80clJNNW1C?=
 =?utf-8?B?eDNmR0lvYVpQa1FsNTY0eFMwZGppVlZ1cng5cmpqZ1Y0eFVoYTNjMCtoV21u?=
 =?utf-8?B?c2xQVWYvMUpoMTVzRmxTNXUyV3I3K2g5WTJ2NUlUUTNpL2lUczVOZmU3T2Q4?=
 =?utf-8?B?TW5remJVb0Q2TUhweHV3SDR2OHlrNzB5ODJxSnJKZGp2UWJadmVLREJwZ2VV?=
 =?utf-8?B?M1djUk8yMGJQaGNnMmVSdFJoNFo3d3VRSDdpTVdtWExDMkd0a1dGY2NRUVMv?=
 =?utf-8?B?VFFpSGtTQVgvbzMyVTRIVWZsUVZVVE9KbjhxUkN2Zlc0ckEyNEduZVJDaVM4?=
 =?utf-8?B?a3YzQWY0SHljSGxlMXpyWE5vUXliK0VTY1cyem5jMDB0cXZabU96RWtENDhE?=
 =?utf-8?B?ZWtia05KSDhIYlJXSDZUbWNMcS9TU2pNSERFZDF3d2JrS0RReE10cmY3WDha?=
 =?utf-8?B?Q3A0M0VJOFN5M1NVaDZkNnpHZVZaTE1nYjNHMWZ2amJmOVFFaHFmdERBZ3ow?=
 =?utf-8?B?cUFiR0gwTmYyV3l1K3E0T2ZXMVdEMlVQK0JqOHp3NXJzb05oSzFFS2JVbVo1?=
 =?utf-8?Q?0nFtVCgLq0Khk26YK3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfb2132-5502-40d2-9f1a-08df12074d7e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:28.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I20d4jRgRAZMfTWsr85Dx7FEo4nNa9qvZROXBVqxuDxIuxKWE5ooHeBlOJ5+myid
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486

Only two users (in md-bitmap) use page_buffer() and both can be converted
to use page_private(). Convert both and remove page_buffer().

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/md/md-bitmap.c      | 7 +++----
 include/linux/buffer_head.h | 6 ------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84122834b6108..7b706d3e54901 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -533,12 +533,11 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
-	if (!page_private(page))
+	if (!bh)
 		return;
 
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
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

