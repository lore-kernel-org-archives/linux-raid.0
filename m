Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0422F745D;
	Thu, 10 Sep 2026 02:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006211; cv=fail; b=WNkFHNKt5YcIjqQASvE5XaHnjrk/EjPN+lAs2K8RA3ZFMuHo7DjR5vzGlKr5zEYLIfvalVYb+x0CrohiTPWaUuSiW59mrfCyL82fMe0UxSWtUcSNXGjW2Q3/U41wf6BwLBD6nxmXDpySPgvD2apugD1K+Vl74QSuJlKWtAyrRnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006211; c=relaxed/simple;
	bh=AVwuFVZTk8bswcyih7LIzKv2+g0oSnDVmORLCw6QpFQ=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=C+3IkNXttRANAxmGrL9lh9fF87R9ivhWav+wL4LdHUCL7+shv6AT5TV6kkus5QPJ72PkPZ86f1X5ThWKcHm/NgM1g/rJHq2bc7OVKTxk8fWjh+SIw08nTaKrXXv5YWizwyqQ84OhQ0L8MgcTcKW2hny5c4Vqu6jWw04bU9mpmqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lmHQ7HKn; arc=fail smtp.client-ip=52.101.43.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lmHQ7HKn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+FQ7RqgbpNtsHuj6V1rnxf/vadq1Upg+pGT3+qT4+feUEqLyXhY3/Ry1/j8tCSOUzwvHExArUjN2VXYFq4NiZFCxpkbUyGLOZke2J88Wwa7M9IOSnHclNk4VBC+vmrrnTIQC3XrOAD4NdJ9fCd5MgLTZc6psJeEQDzn3B51TvKCbEmEdWr6w+XzQIB2II/fHO+aPIROy0vU96ASPk44LWONE6yID2dTidvkzjd+GCA2uCI+aTr8if5c9Cc/l1axElP7OcIJubAhr3WVKkB3WC4QjqtQfKkC+/gvsodIGzcAeCxLsOQ/varviAvZBnohnoqXQpYDL9YfLT7RtqriHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gIuLCFb8gycGZaQi7RGAzOqRDOP2Z2W3aWVT7dhH6E=;
 b=rWBCI9bkMaketqbg2Mmtm3+JDJXf817qwHY7ETpre24C51Hd05Ia3UtwiUbqdI86Ch6zjMyK8xPVEpgmFC0s8Jq3XSu7XIaexrLMDaOhaUc6hi4tWXMa5QShKbMxzSyQwg+zJub0OdNwYdD7mS9DNn9q1Q60zuwNqm7oXYjC4wMtUL34vUwp3KGFgjAvUeMHZG9DRB/wjdCWeoQYkzYW4gCtT5oUnjw53VRRJCHlijJHwmPuwDOw5z8xMD/oc2gyh4YaM+mMrnEiekWMh/B+WX0upYIWjaoyDOKNO1J/CuA/k0g1s+psd5jrDdv27ed+br76/cKm2w06Qpgp+d878Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gIuLCFb8gycGZaQi7RGAzOqRDOP2Z2W3aWVT7dhH6E=;
 b=lmHQ7HKnuOwf+AqAba6NyZpmJYQzWctdXa0F0DXXGh3RZB/UAHZ3NyHlcgr/YH85K/F/H3RUPdh4qTT7qasKlhX//gBC8O+9vwGiHgGhK2aph3OS+gKUWBlxxolrDzNFP/sm2+sd4ZAUuLeB/w3o7/aFgIr6XvrENWZFwnjVJL1RtO5K2AuU/Zp+hQQ4dsSRUznz2jv0CB8jexwpbblvUeGCFmvTHeKfOtxeOdwXgDvnU/UbBxhY8nVlgaskhtW7WzUvp/sajsoy2pEZAunwP6NOPfpIR5h0y666n0o+SHK3trXZphd+FQO8dSJgfIoNgCRivSeClI31I+387n1Eog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 02:10:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 02:10:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Sep 2026 22:09:59 -0400
Message-Id: <DLB9RQD5O6LC.37ZXXIDYGZJ8D@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 12/14] treewide: replace PagePrivate() with
 page_private()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Song Liu"
 <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>, "Ilya Dryomov"
 <idryomov@gmail.com>, "Alex Markuze" <amarkuze@redhat.com>, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, "Li Nan" <magiclinan@didiglobal.com>, "Xiao
 Ni" <xiao@kernel.org>, <linux-raid@vger.kernel.org>,
 <ceph-devel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-12-6ae22f9d9272@nvidia.com>
 <afc196d8-8e17-4cdd-a6be-94b8816f2a57@kernel.org>
 <fb37c097-4c12-4eb8-9739-e3513127eb35@kernel.org>
In-Reply-To: <fb37c097-4c12-4eb8-9739-e3513127eb35@kernel.org>
X-ClientProxiedBy: YQZPR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4183:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e028bc-0baa-431c-2ab2-08df0ee09f94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	KuaxvEiBOdASYSM/dw1SVcFT8UH3GL/3glhrY8GhmJHpzxqQNoXeToqPeBC+BGdxkwympov1GbFpuLqjcpzwU0zQA26nRcSAPd/8I4qmK3t1dYTOXk9SR6ro8yFPHwpzgmkryPUZ3jglvfFqrvKZGZvJTuzi54HH7UL4hqwD59YsabEVr/jfpfU23Jp/1HaX4rXEz7z5xteMMWQ0PeI7oRi8e9pBpguwXdD1WHYC4UfhquoSyjRZ/2BbAgfzFZ1AmeLIZTA85U74WRSBHulNOHpKist4rWwge3xJXuEgrP99eDOkPwAUeI18NB9O2+JJiJas10gN46zmh7L+96iS85l9YeI7A6B8k8OLfu00r2E2Gvg59XJBrdbKBe45tKcCzZ3TQzNdeo+jg6SPOKaoNCV9hSXCbFU84YybYjcX2CI57yRUoUL9nH9NhIQXs2VHO/asZC7W1IyBPzsxQfScluDBoNXQK6zwDYq8cwfiLX671laBZIF9wsLb5MG+D5vZBI9K3rQBDR1VIj2odYdJDxbNAced7N7e4llh8tbSlg5LPhaNpmYpQBvt9CrhSeKGUyUTG9HI3rerLbTnZJIfS1Qb/Kc1Iws1bxcOhJmQzZOs0o1ARKNhiOhulZ1wQRoo4PYEJ9scTT4XLZJ6CF5LOnXZFEsUx+Zp/LkaGvwqdQfTj5iWiiZfQvPFVLgtdCI7PFZ5cvqONFb45jBvkz/BDQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OE5qL1E4S2pVTzFyYWRXTXZLcjBkcEdEejhzUStGeW01cHFzWVFTLzNobGFU?=
 =?utf-8?B?NzFLOG81RTNDcm9wWEFSRUJMam50eEt6SS9yaHJ0ZVhBY2h5ZDRKQWl5NzBj?=
 =?utf-8?B?REw3ZFFwRGlHMVJjemZDamtIa2Ird2p1Sm9Od1pHZFdVSElXOFNMY1VlZVkw?=
 =?utf-8?B?bDlrazRvbHVrS1RYOU5Qc3IxWnM1NkliQm5NVG9xbXZYWjZWSjJjcDV6Tk1T?=
 =?utf-8?B?cjVNYitrei9VTkFzYVJkMnlzb2lGeUtBWXFrK0tkLzBXZzQvWlBCZ3FabkZh?=
 =?utf-8?B?dmkrVjZjSlg3b0JrampBUnQ1UmZwUkxDYlVDVGxpOUlDczVFYlVIOUpQaTNh?=
 =?utf-8?B?bDNoaC9QZGROVkxxS0RndUxGQlRySlVLSUlzWHlKRDhwbW40U2xmZWIxOFZt?=
 =?utf-8?B?QjlEbWpLOVcrbTVHVUJYTzFTcTlneVg2T2tLYnlKVWdUNXlWVGcxQ20wa0Fv?=
 =?utf-8?B?U0h1YVFLNGlHaG5SMENlTlVESkJiMEVRMmhPemJYZWdDY1loSC9la1hxR0I5?=
 =?utf-8?B?Q3ltMWU5a1JON0VHMXlJdzNLYmlobkRqRmdHcnZSUEhZSnhZbUd1RExWMDBN?=
 =?utf-8?B?Tjl4L1E5NVN3Zno2SWF2TmtQbDcxY0hFMXFMVFp2TGlVZzlqSU5qY2RWN2Zt?=
 =?utf-8?B?aXhxaUo1M2U4eUNjSFQ5b3ZkVXc1MlBSQy9jTjN3ZUNmY1VpTmFFR0RHVWl4?=
 =?utf-8?B?aEhvMWxjRmttbTQ2ZjlhWHQvWWpnSDNLTTllU256Ky9iNUZkMXJYMlkwSHc0?=
 =?utf-8?B?QWdlcmF3WkkyUWp3QW1oVG9uelYrVEhxOFdab24zbjN5bnJWMUpmdE1wSE5z?=
 =?utf-8?B?TEJhR2lOV0txUVF6ZW94c05BSjZDc0RiZmJpQVpyOHN0OVZDb1NUemhHTFE2?=
 =?utf-8?B?dzZMS2pQczhEY3lkVXBZV1lIZmZEUU1yMWRLN2FuUUNmc3UyNTBiT2ZwejRr?=
 =?utf-8?B?ZGNaaVArK2VHQUd1cEErNktqc2V5V3VJUHRRM2lwcFBMZ0dMYjZpejB3NFVB?=
 =?utf-8?B?MUh3TmVmMzNzMWpUV2kySVMycHFDekFVdEtZdFVUUHlZU2UzVE5sRVU0S2dF?=
 =?utf-8?B?UXB1R2dIdHpzN216eTd3U0NtY0tVaGRLUXB1QXZIV3BhY0VFbEIycHBnai83?=
 =?utf-8?B?UDlrc0VRNjE1WmtQLy9haTk5WWErWGVGQ3RLUDlGR202dUF5V3dybHRWVXlp?=
 =?utf-8?B?b1ZyUU8wemRWYzk0ZWQ4UWx2VmIvSG5JSTdLZGt4SVA0akc5NjBrbUdnSFZo?=
 =?utf-8?B?cUlhZ2dDdnFLSVBCMlUzUVlsRmZ6OGE0YkNOLzZCY09ldUJaRVB6eUVtSFgv?=
 =?utf-8?B?bTJ0WElHampzY1BaclZvVUphQU9hYkJQNFpHdGRZQUI2YnA1VlNtSkN4VlpV?=
 =?utf-8?B?SENlN1pTb2orSUh5TWNLQnJKS3Btd1dVR1diNVdVZUFycjRBQUoxUDJPSUxV?=
 =?utf-8?B?N04vNnVCcW9TaVJKTWxxOFZDOVhydEpsSEdVbHIrUGMyVU1vT3FLNnRhNy9S?=
 =?utf-8?B?MWVHMTFGS0FPQUd5SGgxRSs2dDNIS3lIUXFqWGtNY1FST2lETGpGbFllVUh6?=
 =?utf-8?B?VjZ1elBYT2hDVWx3Qk4yRTVOa2NwSnI4N1FCSk1va1g2VDFRV3NCOGFjeWFa?=
 =?utf-8?B?aGtNQnBDeFVTdnRyYis3ejRxeGZzalpueXVBMUVjemptZGhGeFUwV09Pa3pJ?=
 =?utf-8?B?d0NrcFZVZWxGYVF2SVUwQ0h6N2NycmtOVWZWcWl1dWcyZ0FtZ0Vpc3ZYU3FY?=
 =?utf-8?B?UGsrV2ZmUFEwUGxLYlFFcFE1SUVPRnUxb2NIckFveEJMYVByMVF0T0dTaldv?=
 =?utf-8?B?bm0xNjNMWTZPbG5mdVdtRmtwRHRGWHRhOVRUNlhlenhWenJLV0ZEaCtJNVNx?=
 =?utf-8?B?UjRGMW5nSnh4NGE5akFQbWh0U0tSWkp0bnFkM2QrbTM0c2x3RHdXUzMzUlA3?=
 =?utf-8?B?b3pRcE9jSTRBaGUxTWFGTURvYlpSaVUxY1BheHRWUlZ1Uk1LU05GVkJmNlJ5?=
 =?utf-8?B?ZGE4QzJWQzJuNEkvS0YzMG9SNTZZTVNxeUNSZGkxWGZaTnVmdlE5dDVoZU04?=
 =?utf-8?B?bUFXblQ3ZVB5MDdjVmJjR280cHBqNythS0wvMUtkUkxwVGE2anEyYlBpbzVo?=
 =?utf-8?B?a0J2RXBBb3pjVU1pRk5RM1RPd3FDYzVwV3F5cnQ5V0tlUmxRR04zKzZpakhv?=
 =?utf-8?B?Q3NWWUNyY0lOMXNpY1hGK1dLd0JoQUpSN1llUWpuMnlkS1FrbWtTdGNOK016?=
 =?utf-8?B?aVVlYlBOSGxRWkhTZzk2UUdWVjZDSkdVYnpTb0RCNDVUUmxkaUFYMldGMTEz?=
 =?utf-8?Q?Y/keIIclMWTHlOiYBD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e028bc-0baa-431c-2ab2-08df0ee09f94
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 02:10:02.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJrMgX2rh7h3ORNeVWrRSgm9Zw/072GfFGdtFavpx8SGObg9Liw5kjjov9bQ7pmo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183

On Wed Sep 9, 2026 at 10:23 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/9/26 16:18, David Hildenbrand (Arm) wrote:
>> On 9/8/26 04:56, Zi Yan wrote:
>>> PG_private is going to be removed and its check is replaced by checking
>>> page->private !=3D NULL.
>>>
>>=20
>> You should likely clarify here that, for these users (the pages they dea=
l with),
>> PG_private is set if and only if page->private !=3D NULL. Consequently, =
there is
>> no functional change.
>
> Ah, in previous patch:
>
> +static __always_inline int PagePrivate(const struct page *page)
> +{
> +	return !!page->private;
> +}
>
> So this is not about PG_private *at all* :) Best to clarify that.

Will do the patch split like you suggested and clarify this code change
in the commit message.

--=20
Best Regards,
Yan, Zi

