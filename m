Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776533148DA;
	Tue,  8 Sep 2026 02:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788836224; cv=fail; b=OgczohcM9GA9Fi+I0WciHsI7qbjCzBcfS0kovfzQPjtSEg9DwkLWfvF/OxRogCz2k9v5L7j6AYFb+b68Eq/8jLsCgjIrTA60HTkID/BDWbE5YmKWv81TdVDiqhKewnQVcLY3awsCWtMdnbmNCyjHMkTpgaMM8ag1kPyq23trk28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788836224; c=relaxed/simple;
	bh=aK9mOhpFt7XZggxW22GEovJdLOclN2q4+ttFGV73rxM=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=olqIEpaY5MghoiRxvLRfSccUIt9pMoj7yyJvBYxMmVAnalwzKNqFatSxkSlthLTs/t4dOZQ41d3eQdI9E5o973qC4kBfolkytKyNJXqLoHsoCf3bdKvFUZgKdpLjHB6W5kecOdQzmIrFuUby9ahnA7Vabse7C4RlBQtbNBh+Dus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p4k/9Bu8; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p4k/9Bu8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsbSLKAPYyRDirhE0YIhAq2Pt/nXG/I+Qkh17lplBhNRplVmVRZXWIgdToNLHO+yuVRTJy38Qv3Oed9JtI7rdD0J7bbl0wSwasJEVAMPuTNEtYweIylSRx4nhtfCaQFz1n5pAm8g/NB7LcVwfRSbKk3tQBOEbrlKRSb0fKdxW5cHB4/6s6vOHRLmrsJcHS6yCvt2Oy1YtZknOJDGpEVX9FDwc5/0mkveA/Z04643AY1gxBShr1r+J38N6uFpal9WZXHrcrPsT/Msj6G1ISmadouIEfrfECZEaOAL+No4PbpWLj/sQk638jr2V2cnZk5sWiqt1sbcMp1lXyMPu96bZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=fe6/NEYnYmtVRzdmrwGmMsoylNd50uHufknesREGiRz59TQLpFlgioe2geBSPSZtVBOcPE1RxIlF1qwKJ2UgLKTWt5R839puwi4oOmjeMtHugl/LOZzmCSZ18T2yXrgUMdV5AXM78a/TBmMQO8uqegr7710xo95SKkh8pZMHzedcU2w1nGHm0w++29ucnMdSXhSQsZwAXwPGxX2ajrKgKvsvAZzzDKIUaNRHbxYfByphduJnEi3QsmbfM9tEwl9Fht2AIDOXEJwrzN1JwKAfrpFFChBgZSJPmcxjlxroexr+GfdcY5Q2xDeYnww0YjxPJgzPhJI8AA3SiMcDrzeOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=p4k/9Bu8BqPShWyYYC/efcA08jGG+GNpzHFd9/XeYPeim/iwfPuqCGcFSWzSuUdzeKrJ0iOHDa5UI/BZV/4cw+/ZQ/4jQUhXoFls7Rc+u8tUQOcAFBMsPSysnBAgkL5FCoB4HFt+lohKvCCrrBqH/dI9H5DOgOGvjq9OFLYiuZeq/1thSfPsfwdRf+6a+s/kTmXH6OyYlGarDvTorEkjl9IYfCQ7W0L5PxcNykREQ5f8NegxIN81ZV4/HVHAKL84weT8F9Qgox/id1CVLtyfdLk3Q0ssp2OOyX2PAxbBfMFFDI/oY0mVwc2SA/2VODAwBjOEgeNzRvFbqmZ+RgjeRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:44 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:19 -0400
Subject: [PATCH v3 12/14] treewide: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-12-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
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
X-ClientProxiedBy: YQBPR0101CA0346.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 631bfd65-f308-4edd-db12-08df0d54d0e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sw1rZleqqP7c3P8hBKQNk5kE6H2eoK3BB9aWKxoYkMLoAH4d3Jq3WouKTANWncRwtCNZd3IUoCXtzhwg3+GhqxgBMb9k+LkIbeIUp/KpFSFy4YwYhhL0zxvZbnFm72gUEYUIIMVxdfoW1+EZDZePCH0jYJn60hpCvwZN+3h8Kvq3y4IC1m88T2S8VTFjXcKnKBw9NoNPmGbBCMMdR35icMwh1hdg/60xw4RzBi7MogmeG1BBOWOZTZReOZ0TYa6j0nm3laTrUnFUaIAGCOwbkT+3C9L1SWFEsOPHsXe7q+QEV/lYOPdwxgFbdvIJLo7zCNL8Jus0pmyCAcioyjTa0hkhmWqlSdi8TaX1+rEcO+v4KZWCHdNlTWHYDgpB0Zuy6Eg5Pk0TLJ6QmZ1iknfSUB7QbSVXBBlN2M80CjlgZwFGMnlZGdGoyTBM4Jz48X0xYvFgtNlEo+IW96nRaK7jnzYGiKfONr0Y3uLKz1ROp5ZOiISvGo4SCVWIPgsXfnComSfNMAfeg/EX8gC6pwE6jfCeahNE0iNuMJbixuUCm5OrF+QzxVVhfR2P5cy3U6c1hgiwmUJCejuci2QycZLqIbnLRV9+VBSlZfezbntgAdOOfCRMFOUPw+eovv7El1aZ9vgd0r2Mb2V0mE3ZMsPgcetw/Vdb1SOzBiV3HMTjhJMg99lfMH6aTuZ2Em8yoiCMjK8za3An6WdFABQvOI9JBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzBxRzg5SUZpWEM5akRyMDJzbWZWYzcyK0RTdTdCdWFxbzgxL3VLTDVPMGQx?=
 =?utf-8?B?K1h4WHUvRlNrcDcwUU13VHlhSHR1M1NnWnNkeEJnNlh0Y0gwYUs4UVlvK0VO?=
 =?utf-8?B?UUFaOWUxQjFNSEJYTUYycTNSVFFjZTh1WVoxK1JQYTJGQkpuY0ZjUkFacGZ4?=
 =?utf-8?B?NDNHTEhjWE5SVytoK21hYVMxV3A3VzloWXJaM3l0cTlkMC93a3NyNkFCeWNF?=
 =?utf-8?B?TXR1OTJWSFFDOHcwUGkrZ3lQYURVdzllV1lBcU13SnNRVHVUMUVIYm9EcDRl?=
 =?utf-8?B?MmJKWUZXRkdVRmhERnl4UWpYdzRFeFBka0R3RkJsQUpXSEx6aC8yRTVyRCsy?=
 =?utf-8?B?VjdvV1JoTDc2VU9XRUw1SmZFbVVsc3VqNSt0cSt5OWFNRkJsYlVramNndUF0?=
 =?utf-8?B?SDhRa3ZzcjZYandlYjRVMmRSQlZGc3RPbkQydkpwWnV3RWM0ekhUak9LMHUx?=
 =?utf-8?B?TlBiTVRlN084dGEzV2RKR3J1TWF2YTJHWlZPcWdxYk9WZXc4UE1FaFZLdEk3?=
 =?utf-8?B?bGlkSnNtY0tlVERlb3ZaelMvUnd6VElWRUx2VEpEblFJUWp1V0dhT2hSOTZP?=
 =?utf-8?B?TTVMbnpOSG8yN25pWWhNaFFWUWQwOHhKdXBKdG5lbU9GVnNGdW1VYVhrSmli?=
 =?utf-8?B?UGtJSFF1WnlBYWZSSjVrSmxQZkhxSUJ5bitub1pPMnJ4YmhkSi9VeHJJTnpR?=
 =?utf-8?B?Y0UrcnZFa0NyVzM4YmV5Q1BYSGdqOFRSS3d3dHFuak56OGNuUDk5ZnNNSnpZ?=
 =?utf-8?B?Sm1nOU0yWDk2eERNcTczU2hsMi90aGFYSnR2akIxNmJnK2JzU1J2WERBNng3?=
 =?utf-8?B?akhXbUs0SFZmbHB1Wm1JQWpXVVgySzBaRXVjbEgycDlvci9UMFdnRmZwekxs?=
 =?utf-8?B?ZGo4L2xwUHhzOG9XNXl2bjRQM0tEeHFKU0pWN1IzS0kzWktsR3BNVjFGYmtR?=
 =?utf-8?B?YTJvV3d1OFkwU2Y5RVJoOWRWZU4xSzd2cllIYVkzZWZkL25ob1lydStkL2k0?=
 =?utf-8?B?SlVmaHdOWWhaYm9XbUYxbEc4NGdNdjQvbHNnL2s3TW5QVHg1Ym9JaElLcjlK?=
 =?utf-8?B?TFRkSlgrcTExRkVxUm0rdnYrM2RLNFFOQjBLZ284V2UxQmo3RzRCNHBsNUxv?=
 =?utf-8?B?VnRTVFQ3OGxxVEJwMithOG91dkVWZHRSOUEyRi8wK1ZEN3R1SXppYWZ5akw1?=
 =?utf-8?B?cXh3ckxIZlhZUUZpNEhjZHF2Zyt6eitUS0RQQWUzenBvT0IxNlFwQUlEUEtx?=
 =?utf-8?B?WjRLcGhqcmp3RE1kbHE1ZHhrbGtDc0RCNEcwclBydnJ1OWwwREVSVi9UWXJC?=
 =?utf-8?B?YXFoRThjaDQ0VnFlZUJRQWtCQ3F1amlPUUlqd0tkTk84UkhUTmdTK1Q4ZHph?=
 =?utf-8?B?cmdzaTJwcmc0UjZSSjhodUdMTDJNZUU0WWwrS3o2ck5VYUJEZ0FOeG9MRDdr?=
 =?utf-8?B?Z2tXQnhsbkJIaGpOOHBZdDRzUW9SeFJXRWJKMkM3dVg2WFlKUTRtaEt2YnJ2?=
 =?utf-8?B?VjFZMHZCM2RKYnU2eCswVzVwNlNrTmhiMjZvZlkzM2V3RW4yS3RRbWo2bllw?=
 =?utf-8?B?cDdwQzJPdjV5TzZ4ajU0WStiNHlsNE5xaTBxYXVYWkFHcis0RW90bE9RTkZi?=
 =?utf-8?B?NTdiM3B4SWhPaCtsYU9uSVdiU1FxaDFzN2M1c3JCVnZWaVJSbHpHTFJ4WVE4?=
 =?utf-8?B?OFFuNEJvVHZSVnZOL3RQdG9mcitJNFJjRE5Qb3VrUXhJd3grV2dNbS81YXND?=
 =?utf-8?B?WjlUQUR5UXNWd2RCaWhvQVZqM0ZVM1l3QVFRTEMxNmNwMXA2a3VpdGZaLzJ3?=
 =?utf-8?B?VEh1ai9qR1pZYXpLUkk5ZjNxOU4rbCs1MXZaeHpvTWh6ODluYVZVMjB0R3ZQ?=
 =?utf-8?B?cU5FdEpjVVUvTDVLdXhtcXhLNElHckVZcWtmT2ZGcFpyTlVXNnVjRFNnOTcz?=
 =?utf-8?B?UTFkbzUxeHFqcSs4OW9GbEdlOFNFalRIZm9zWVYrbmFHY3BzUk1pSzlyUlF4?=
 =?utf-8?B?T2FXeHBTN2daQ09ZYTJhdkhKRDBCZzE4QUYrQWljSWZUL1ozQjg5bk04WGcv?=
 =?utf-8?B?L1BVeU9CeDNwcjFGQWZWU1dPd2FUc1FrVzY1K1pzd1BwVmdzay9TbDZzbVFy?=
 =?utf-8?B?QVU0dVhkc1FOdG1yWkMycWZwNWZMaUFOT2xxeWgvNXU2ZXNPRjE4T0x2RWNC?=
 =?utf-8?B?QXVMY2I0TGpwMGpRNmNkU2orZzg3NVB6bFhoZG1rVXBxRlh0dk1nenFudjc2?=
 =?utf-8?B?UWdFdEl5ODFCanlKZm9iRHc0V0c0dXQ5Z0dzMGlJY3ErVzF3U2hUN0t3cFBq?=
 =?utf-8?Q?13MuuGX0HBHcmMgpLy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631bfd65-f308-4edd-db12-08df0d54d0e4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:44.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKjgBCGuEFkEfOc+C4SvHM3tzkrKZa5O3krHDUrn27qgkrfQkYhASkbhGHITtlST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435

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

