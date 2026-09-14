Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010041.outbound.protection.outlook.com [52.101.193.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFCC441021
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396601; cv=fail; b=kP+T9pf1NUQjYR5gT6ix6gYC/pY6H6p/F7C2ZEm5ycZUycs9DivoU7csP4KCarfUbInNT8DmQpj7/0z0wICfVFaKmUBNRZED/LdwsPb0ulEIhZSS09X/EV3as6g4tMSiCVKe9suynZGIHgYTp/ATAnC663JFNL7fALRa1kt2Enk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396601; c=relaxed/simple;
	bh=Afq9is8EXUDF3hUBjjGacGban6p9xwn+5ekCBU0Qi90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PDT/6yGcdQpkhrOBVQtdv3lJZIsboBhsGhTL1ezJRJgwKwGk4FcqyMOiiYEKwExInzYGSROg9w8qsCVOhYHtfY83K/MMAIoOOLev6dOqRbGN9+sf+xfl16EUh1hwJihaUQicOj0SP3d4fveclOg1w5SWeJdS5fnvLabZuHgIAP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BUDHLYNJ; arc=fail smtp.client-ip=52.101.193.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BUDHLYNJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Obp5V5HHXkX4UPNFlv+BFgzrFvkWaY60g4JTHcdgiqgmvMwwkGDgP1u8bfDfpBRstYxydVcxfDaPhu1BKVhnraZTg3yry7hwRVGvg82IyvLxmJRcfUAaVi4ldjWZeQ5sWNjKNom43/OgKj6p1+SpfO3jw8TVNHpuO1oawDnk1LBFB6H60FPFJICIwNV1j1hWBWS5psylMBAouASCgx+0u+lEHRQ9QQ6u4vu4NfeEu7Q1PhYnwG1BQz6HvTsIX7O55usUdBHSsLgl6LU6pq8LMPK3dme+K9cDsNKLqYwDuUGDKXvV6pM4eWAltKyLPGC2cIosOJqYRu+kWwSVmBojVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuvk1XHkm+wQ7Wb6x7TtNZEG67vtSgcoEEzvjL9X5R0=;
 b=JgHBoiYvytrS6CxxpaFh+4pdfI3dmN8i1b5lljriGalcP3QakaNzKQMQqfghDID+57pkJlr4t3wENzG2oBaEc8krlIgoGS4obZ5MLVdEOC59seVMJcGKRoiMT/1ylKWCxlWy6eXv9uY2/TnVQI8xAviEgVmgG6rLwb4pt3uY0HwpGYP+xSughvNhF1lI5UWvpXKVAElZUI6MUxiFA87FFcWU5fAyxb1QNxRHo/FJGJd4/YVmHRtBOs8AHZMa2qDW03Jl0ZGqoKleZwJWvz+KO1dG89hhy/cVqqGAWh2rtRV7S6ufz+b45kWtCalK+gakORV16lz+qgkC4nv1OnSIRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuvk1XHkm+wQ7Wb6x7TtNZEG67vtSgcoEEzvjL9X5R0=;
 b=BUDHLYNJ6iVLyyl/LemY7wtMa78DTH5t1brqJnM9uVMt4E/w5mvKS7zW8svNgI6beTahzhK/RBc3dEz0J/Jsc6KFBYUBYiV78KjHOI7BO0cYmRNjVdYTtBm9ZrMykFDsEZe0fjOBQk2Id+nBqtRgWxZCdTBy5LWa206aiyNntaLLqAJNHffpObJYO/WZ0ub5t/lVfSDvBD0c4id9vh+SXP7UP3xweInp5HukmFXI55ciKCsXVbyxJdiNiWIWaJON9R9bFsVmLfub+ew/5UlPAhKkmUL82zPpNGMeeLW4ioT4JshXs3VLvFQ2iObtBRhti0gTgrTQcLY27U7RzfR5Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA5PPF6CDAEAF48.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 14:36:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 14:36:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-raid@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
Date: Mon, 14 Sep 2026 10:36:29 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <0CD8026C-F462-46DD-A93E-210C6EDA0E13@nvidia.com>
In-Reply-To: <37784fda-a91d-4b70-864a-67b62aed1828@kernel.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
 <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
 <aqf0A22W4MHXD9wG@casper.infradead.org>
 <37784fda-a91d-4b70-864a-67b62aed1828@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:36e::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA5PPF6CDAEAF48:EE_
X-MS-Office365-Filtering-Correlation-Id: ce2397ef-cc4f-4eeb-0457-08df126d9105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	n1Q+j4h6J0wC0eHoJZQdr2ttSZTWg2CX6z+Pj4CKi0F4olOIEWkkmUfBn5zDi3v4NlagA7PtmTNI3408is7eOkwV1Nnx3Psa0wgnIv+O4eLxBbVaaBxJ7btKH0gfbbNC/I84VArFxpxBw/FTnh1ESlvglWJD76MHKEdkilFZnNnEOZzGCsYDFdnO8g37xODsRMYKnGTznP5AN6pU4lxW0mWPYKlSKPD9YRj9uJNKSmvZYTLYYmiR7RQ0oSQ1E5gnscZ/+QmCrt92gerIrRYVWv4Ue9ovuAkJeFeD9VtnoAA2vJON1E1d3v5t8GU30HOH/uIKo071JZhWH5IBz9fhiHcnc58cCnVXnNLQmpyAQpu14umXPRC/Pzq2tc2zvTz5qsElD17Qy8wj34Xnpa641lA0CJJ8nxEwGCL50AM5hZ+rnvBO7TeI3Zh7QPrP51gNDRDyQ4VXQ5Wlr8EbcaFuT2nlANEWR45I7M9L6U92hPqAnc37XP47cGtPckX98NhO5YHTwHz8VFl+O97O0GuCYsQp+S7jwCHiAak45e1NZJss2AkE64iEOLGch9xUBPpw1rkOSut4bFTxR4jnhRuw/1HWKj9zwuxTV9ECXDeP2TwbbKV1LcSU3DLgZHPmyU1hYVDoZXqdp17RZXGjb7mII+/gEReADK699XwnGTi1BA0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eiqrs1xmXGSfiCEqJsjv1g2DaXhbOjttM7BgA2/NS1cR//dem3qPQrcc8fvL?=
 =?us-ascii?Q?vlOMpC9ZrQo4V2zPvJObqMzDdRfO7we0G5yZ2C0nhdLClNATONsC1MGtlFcz?=
 =?us-ascii?Q?/cXSsaDEW0wJdIOTXLncGGPUA1KxQJUyqIxknjy07uzG98SqkHgaJb9SlDOa?=
 =?us-ascii?Q?GONOJGhYS1KMA8p8SbG2xZamKOkG0c3Z7t5EtgsKd3OUX2SRURBXoaBsALUz?=
 =?us-ascii?Q?epMakQBXyF35e2op9pDgFu71uOUf/Olf6jTuap0/QXggJYvg837c/mizjnnF?=
 =?us-ascii?Q?LK53121Stsom4OJfHLcEXwgDrzLYu7wBJKfOEb/07ybLfN+C7liDAA2Y6r9P?=
 =?us-ascii?Q?hXQ6RN+ZrfOz7rgckzFmljizXDMzjaBoVvzA/6mafEdLNTKEud74dNEPDuNS?=
 =?us-ascii?Q?Ku/wngaTeri9Il9/tzUVZp3QRWTrtNwMx2cwv8dvOeuS5fPreWJhXoQijm8y?=
 =?us-ascii?Q?iUTkVKBy4pn3kW5GzMakAEokUJEuYVMvwb/x7mFRJoSKxu7pVFozmZgI8U4f?=
 =?us-ascii?Q?i7tvlS35T1oosch4XR6ht0MFgQ4mEIFFVWuo7BaH8p8BUJvhBxHd+PmyttSl?=
 =?us-ascii?Q?JXkrW5wYW/tzsFhJkW2ovdKzx6ye/RjaqzYaOpHgOu5IUmCeWGnyzYX+F8Ux?=
 =?us-ascii?Q?+5WclGVFz6su7qlpYs6Seg7Xeg2v4Ppl2qfor8sH8aqD/a7e0+vwTbxQF59g?=
 =?us-ascii?Q?waUdA196n0h+9SIVvDYl3EAhEAsqK5beO8O17PXvYoB7YNdwRbLSnITFXz1e?=
 =?us-ascii?Q?MjRFlzaWBt9+VyTJJQjUF+03XVdcjDyiik9nDiM+97G1taXIGYsncO4TrPW7?=
 =?us-ascii?Q?oERv9hspJQnajksoKO8qaBPJUEzxC28ZasDyiAljHiB+J4NnAPYdT+mLgfbP?=
 =?us-ascii?Q?l8x59/sh98BZPDLCTFFCoQ3HQfwwFs3MYTndd8kqKPm4qC3nIgfNDEUJlD5f?=
 =?us-ascii?Q?ns6/Hq55ymCbCnOqwJgb8JBTX/z+hO955lQAIz+9r8NSRmdIfZcHsd7Q+E9E?=
 =?us-ascii?Q?3/Lhqtf9P4wDjGDDt0+0+xNBj0AUS7px35rAifPZfEbU+uVbAhI0JXyTCRDc?=
 =?us-ascii?Q?t1hct8qxBDBtZ8EgZHzdIFWczrwfpMM+3NfT8pMZui8vcMQyDcPa4OSwXhUV?=
 =?us-ascii?Q?EQ3u5sXy9gEFEQ/Sx6ZmbhYVCTFFN8XTCXVQc3dr4wIyLijk1qeX1ewv4Ncl?=
 =?us-ascii?Q?RW29cuxhKTXSxD+V+XzYdYwhqnUWCgK5TJaY7UUlNZegLAi1rJLfuxjJ+baX?=
 =?us-ascii?Q?eU+0z877874Bsm5kC7PtKJpmBMf93d0WzA9XqI4xgGXEuRrUPQ5bU2rzUXlO?=
 =?us-ascii?Q?U9GfGj4NzL6H1PJ2GEbfI4EUaQ1JZPEeYesAs+sX0kqn5xbbzFlEZic8xXc5?=
 =?us-ascii?Q?z/GcsTX3aLWaLrh67VJcfumlcWXRNkeyWknMNOH6JZH71ymp1WMHJ165N/In?=
 =?us-ascii?Q?Gss2zcFDvzJS171J++8pBqyrgZSuBDqyrvTYbBTQ5tDcHk5I02wtjMbG5ZZa?=
 =?us-ascii?Q?rrgbknu0kn3atvL2vmIUb8WgdBph0kEUCh68JXce6lxw9cPQ/DE9hC0YnIwM?=
 =?us-ascii?Q?qYzJowU3WJnGqI6RI60keAglJ5OebZZtRnIMA0TGnqx6twNSQe1L147n2gE7?=
 =?us-ascii?Q?SIQaLy9Tcc12I14+agXZ+pzGmCfPU9ul15nCLBvyqGsYLmZ8ZpKsQsb0h/MP?=
 =?us-ascii?Q?iweFi7pVdTV7/hGkAdvn6mziP2lUfZSbOBcEw6qzjWPorbzuFcYdm1zGEAju?=
 =?us-ascii?Q?KwhsY/7a3w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2397ef-cc4f-4eeb-0457-08df126d9105
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 14:36:30.4770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7//VAQKs+GzyRbQ0SQDcXRp/SMR64oIRm0WXqbUIQb4czMBGB5IMWC8Oi/e9xSt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6CDAEAF48

On 14 Sep 2026, at 9:20, David Hildenbrand (Arm) wrote:

> On 9/14/26 15:17, Matthew Wilcox wrote:
>> On Mon, Sep 14, 2026 at 03:12:31PM +0200, David Hildenbrand (Arm) wrote:
>>> On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
>>>> Remove the last user of alloc_page_buffers().  This isn't _great_,
>>>
>>> You should tell us "why" this isn't great.
>>>
>>> Because we're allocating folios although these things are not actually folios? I
>>> can only speculate :)
>>
>> Well, we actually aren't allocating folios in md-bitmap:
>>
>>         for ( ; pnum < num_pages; pnum++) {
>>                 store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
>>
>> and it's not clear to me that we should be allocating folios; they're
>> internal memory to the md-bitmap code that are never mapped to userspace,
>> nor enter the page cache.  But they do have buffer heads attached to them.
>
> Confusing indeed.
>
>>
>> The md-bitmap code probably needs to be rewritten to not use buffer heads
>> at all, but then I hear from some people that it's scheduled for deletion,
>> so don't spend any time on it.  But I can't find anything official about
>> that anywhere.
>>
>>> Code itself looks good.
>>
>> Thanks!
>
> I'd assume Zi will pick up your patches and can massage the patch description to
> summarize why folios are awkward here, but that cleaning this up is future work.

Will do the replacement.

The new description:

Remove the last user of alloc_page_buffers(). Use folio_alloc_buffers()
instead, since alloc_page_buffers() is a wrap over it. Although
the pages used in md-bitmap are not folios, as they are not mapped
into userspace nor enter the page cache, but they still have buffer heads
attached. Cleaning up the code to not use buffer heads is future work.


Best Regards,
Yan, Zi
