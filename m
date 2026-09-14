Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D43316199;
	Mon, 14 Sep 2026 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789352699; cv=fail; b=rR8Oe2cKPRXmAqiHDpomJpDivWMEwYPNYf/W/sebGmF6/VHO/X93PZPHqbzXLmQWWpCjloztA5jTRh7JtsybsYceznt/9UesZcF6KLCOZwtD5ufc6BFzA1GGhMwExIDCCaSzWzHBiZpVDgimDW6IuiDdvob110hhKJQngQwNC04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789352699; c=relaxed/simple;
	bh=agCJizruJlF3nAug7gTmM1DQyo8eSIniBSYyIXSc3WQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=cH15i0zBYo4R9jbQVsHOVhmwpRRok1FyVHEM92lFBiOgwBjq7/GZk1gnf7OkLekqAd/EHnyP7JJ8zvi4J4SlThabDxvCM3ZaPzW48Vpx1L3RyXlHPrENfOSaf4kVTlTkoRFsgSySWCkI++UiOfaOtog5l+WIavUBQGhficFPLt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qs2DllZP; arc=fail smtp.client-ip=40.93.195.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qs2DllZP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a63Py/DwKtXFomzQlH4jTIpgUWzlquj5phRgrYkm4f4EXKMkptLsIqfARIqnQIyjco3UX4UPgPhng9fCr9nZdkAyQltFRXBia1UXlZwKqLqPYNkQzhbD7RqJi9w/RoiO+RqNxivuMwGGuXvCMWRGgJywe8YySepMPvYWK9KUyLKpVD7pXyHpqYXIqmGfaKKyQ2T6YfU8eTFltX15QyHsHk8iqn5o4LyExpvcR/j0Kopw87SHCCUKaIbP9EHDNfVEOUBX92Q3qGPSpdhLQxKPhbsf2Nu6cNRKJjBMMdA9W3DR0BhLaYuERTvbUMbWbKSxzDCNdwFQo4adgDTb5xPWOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDlA0+heN6S6+Mwdl/1woktOf81BfLWp8uGIODOxyhM=;
 b=w3huh+7Rwtjf9BjgkwWCfo9tHdy/LOPCpsXMIH6+PKDo6h7XNSAW40JmnAYsueXmkRLfkobpxmwAn9Nfv8Meu7geeP2UFX4tPy7HcN+k9/gex1jP8PjoAoxCmUf8BoZg5l+u5PFCnjAmcxohbPprqBLFe3kJUif8n0WviWXBulmPg5u2bdClIT7Erjc6SZj6D+CXeslK6mgk7CWhPIAl2DgmSxFs9GvlkEGtNOHGIE/D7ageeuO7u59zijNHMPJ1RgXNWUktiom4/Mw3oB4wll6pbZ2mjHvR0vACgtkrfBJeFlmNmY4dLMCNPba14xsFZstfT0pAqBYn0BoFWkHByw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDlA0+heN6S6+Mwdl/1woktOf81BfLWp8uGIODOxyhM=;
 b=qs2DllZPGLK4i+Wz5sQ1qJM/kSXDiah71w6Be8YhF5sq5zTUP7KohQ5OvpKxGtgdslglFQ8Rw6iyBEjNejsIYU8KJFhG4ICsKsOJyQ/oEu1q10TKU8Zu4ZKvTV5uZRAqWdPTCVmaoQ9CxnhC4aWjYOhWP6JIVbaeDy/5NBKNqcem4BY3ru9TMbKzWWjQbD5DqLWKq+GU7R44xmoB5qS2tVAnVpc9ToiE8Zfsd1L5qE7FCNXxiwB1dAMuM8Kg8y22jf6hFKaDVkIQGMi1++FSt3EOl4ovSSTJ6Toxl2yJ5Is9VrnXleiqXOQy3EsAK8Z9cO15M3XlcOnhhx6/SIEO6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:27 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:11 -0400
Subject: [PATCH v4 13/16] md/md-bitmap: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-13-848550f7574e@nvidia.com>
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
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
 Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcf1796-5981-417b-1b85-08df12074ca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	2ESeYIuP4ZkDLgDsg3iO8tptM8WKRcM92E0wQguGTZ3DStqA46D4apTLVZ/PJo0WXzKk697WXW89vNP4BofzuejrgiFoIDxfMaFuDhurjkoONbQyasKU1pRYMgYQgj1+gnALt46D9FWjFobq7LWiPL7/gjz8ZJY/2lxZgnmWY49Mk2Abo6SWrarq48EnsSfP0Xd2WbU1k+K0nT/sx2DkpviN0kYzCVHPiEwdQyu+d+AfHqM82tof+kG1SPq+gyW+3f2x6IzxITC9+wKCoh6m20a0Dj4m1u2TkofJTjD2WDoeHJOrS5vfsMSIBFnf6oiYGuoGE+hQDmcLO3eqGli32aLYLCnCoxt/9smsMQ4e5AMr5dwpSmHkf2bqYk3t9BpZgsdfKyy1ZlXu7MG4ala4FaZrSLAHQTJbf35LIg2/qTKBZbiBzTMWr9TgLz2L8FDhpBlooRdnemrtaY/6q3FCkTWLdKG9UrBapUpY7z264UHfS5ZopH6tHFe7obcJPd2vIGbnyuhe+Juu3Pqppv9z86yxikZ26bGtNEjXWD5t4WjybMqmSqlr1giMUamVGkywrsuAMyDGOVJzViv2FbVX2/hNa4PHUGboR4PnWiXFdu2hO/06ounF6ohGyafxulnxspeehBIN5h60OsWyN/HtV+nbWylWCrmUNz6CjlT8ETSf/rtpTUPpqQPUy0+wzpLi6M/GFWeVNhs1rRMlSCToRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0RVd3JFV1hrVjRkRWxIT3NhVkYweTZKWlFSYTQrT0diSUorNkcrQy9RRkNS?=
 =?utf-8?B?U2tWdVF4NWRDVDl5NnU3b1NycE83MTh0QjdrckZ6Nlc3OWNiVko5YW1TNHNh?=
 =?utf-8?B?WlV4WDZkRXo1Zy9teUxIc3dLd1BDU0gwSXlqeVNlWW5HWDJFMk9TZTRUa3Ir?=
 =?utf-8?B?Z0R4akNUbW9BUWprWkt1OFVRa3lzeEoxc09QdFZ5YlhOTWpJS3dQcklqQ09s?=
 =?utf-8?B?WUppbWZIczY5UHZ2M2t4ZksyZzltbGtjbW1wLy9DNVRPbjV0eS9zM1NLUHE3?=
 =?utf-8?B?N3RiT05weDAyWGFlUmdHdjEySTNmVEY3RVdCT2U0dVVuWU1zSXBKYWxNdEdv?=
 =?utf-8?B?WElIdjdRY3lTZGI1dW1YL3h1THVPU0k5NlRJcitmdTV3VURqb1VZM3YvR01E?=
 =?utf-8?B?TkdXbGJqUnpTUFplYU5sZFlGWHdLWU43Q2JUS21VczEydmFRNTgyTkdjQ0Jm?=
 =?utf-8?B?OTN1MFcxai9MdGtQMVpEY2oyd1JWQnhtbXdRN3JFT2w5T0FHUnVvWkRwSzBN?=
 =?utf-8?B?RkJCcGJuRG1rK1ZqT3JqSkh3eE5KTUZ0amNkRFJFWWUwZWVwTGtaNTZxTDN0?=
 =?utf-8?B?dEpPU0dhc2ttY0xnbTdMQzZGak8yaFlna29EUFJWWUNnUFJIV3N2QmpVMEZm?=
 =?utf-8?B?TjN4MmZ0ZlZUSkJFcWhVSGw5bDdrcXppM2tjMTNXdWU3K0ljbjNJbm16aThV?=
 =?utf-8?B?R2FDaE1BcGxwVTJnakg0ZzNPWmt0amFlZ2lmVDQ5U2Ivams2VlQ1YmFBTUVJ?=
 =?utf-8?B?MDRaNEt4ZVVHOXFGWVVaODM2TVFoNHpNVkREamxUclQ2QS9hb216bDQvc1cx?=
 =?utf-8?B?MHkrWk03Y1FOV3Z2YTBYa3RheWl6Tzk4dXhyUGlUZXFOUldvY3ZTNmNGcC81?=
 =?utf-8?B?T24wQTkyZmxFcEhkU3V2QUxzc0hmaUVEd1FKQjlXOTJDL2NyT3FNeVl2T2Mx?=
 =?utf-8?B?YXloVTNDQnZrc2lvQUlYRkNLS0toWlNtUndYMnprU2NLSlN1a054cDBpOUZt?=
 =?utf-8?B?NXp5R2VLaXR2NEdWOGFjTTJGemIwbVRnSnVSVFpKdFowcjdicDl5ZmVScnlQ?=
 =?utf-8?B?T0ZFNkRwWmRveGVqbUlKVTNoam1CdTJkb3JkQ215SkllOHZyN1RVaStVYjhr?=
 =?utf-8?B?bE1QSXZWL0J2dHBLa1djdnJsY3UrT3diSVJVUVg2KzNsVDNiTmhkVUoxY3Rs?=
 =?utf-8?B?RG1GeTVPQWpaejVTZUhxUjNhdTI0dXk5enA1NFFHZ3doQmtWTjNqVmRnb2xU?=
 =?utf-8?B?cCtiNjZTZ2F1dUt6QzlFVCtjQ0xpK1dseU9TSjhWZDI3TDRLZ3JZVTU4Ykpz?=
 =?utf-8?B?Q1FESHZFOFd1N1BBbkg2ZG9DUGhYYWVON3hYYTBoT20vSzBpRlV1RkZzbFpz?=
 =?utf-8?B?elNjcHpCVDg0YXYxSXNPbDZDY2I2SDlpYW0rRHhlbU05UGZCcTVuS2lWQnFU?=
 =?utf-8?B?VWl5NFFjOWtEdWVMdlcvRlNtZFJHZ1BxMTdwb0N2ZEpOMFo4SHQ1Qm5icWV1?=
 =?utf-8?B?ckJCT2Rnem9iVHZkQ01kOUZiOFYwL1laRTgwdlBVUm5LMUtQOTVtTmNaQmxa?=
 =?utf-8?B?ajZtNWErcnB4UC9WSncvdE0zeWJrY2RaQ0p1Ry9qWGg4UVNLSEI0OThQUFlT?=
 =?utf-8?B?ckEvb1RQR2hxZ05qL3g1QmY3TnBxLzYwYllzUndkZFBEVURJZjBNRXZoajU2?=
 =?utf-8?B?aFZPWHBzMEhIdXRTbFZYUURRZTlXS3Y2SW9RcE93VkJHdGlmdVNCamZuY0E3?=
 =?utf-8?B?aU84ZjR4N0g4YVlVTnN5NU0vT0o5SlFiWmNFNmdFak1jTnc5N1JKNEVmTVpI?=
 =?utf-8?B?aVN5K2IzU3B3QmlnQjFKMWZsbThyYXBhdFJZOTZPdkhDSXM5QnBJZkJxSm1S?=
 =?utf-8?B?K0E0cmtsOTU4bEovMjN3U2VaWUFjQVZkNXB0bVFJSjhtbGV6akFWWDJFSGgw?=
 =?utf-8?B?Y0dPdFlRSC9kMk9yM2pqZ2ZqeXExaGRydkVoZzVyRGRZMXNVd1VDNEIzWmZs?=
 =?utf-8?B?a1M0Z3AvUnpLd1UrM2dOYTBETTczMkRiU1VrWGtoaXpKTlZsRzZHNHRpYzN3?=
 =?utf-8?B?V2RrZWJUME9rY0NQSWZPeVduQ3k4a1JGc2tzb21WclQ5cCtHYXhQai9ldGsz?=
 =?utf-8?B?Y0lxNk5EaEpFOXp6NVFOck1Gekt0TnBqd0RXcEwvai9ST09QNzlZZkowUGFj?=
 =?utf-8?B?WDhUcVdtalNDTUY5a2RMQmpZbGI3WGpFWHZza0Y2dFlWWW1KaXhyYmc5cUFp?=
 =?utf-8?B?b2FzOWdLcnNpakdvVnVYS250NndPYklSUXFHOVRGOForU3pYUUdYRm1FUXAy?=
 =?utf-8?Q?2M5CGcr3+iRO7INCei?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcf1796-5981-417b-1b85-08df12074ca4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:27.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8ng9Hh9bZ+G7m4k0tWWuATt+BI90ojwCx/55N2zYfaJ0CmlGtRuMPj9cLB7w7dq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486

PagePrivate() is going to be removed along with PG_private and its
implementation has been changed to match page_private().

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a371..84122834b6108 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -535,7 +535,7 @@ static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
 	bh = page_buffers(page);

-- 
2.53.0

