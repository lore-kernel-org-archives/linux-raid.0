Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010004.outbound.protection.outlook.com [52.103.33.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055AB7DA9F
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 11:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723722708; cv=fail; b=lVK495+7PdWQXLvLgt1ZLlUYmt8TvP98LJXJEgAob7vHZipEBQknFwQvWg1rhvvf/RntcVR+2xh2znr4Qfz86V2bAY7WoDRNchAQGF24fJ8IRPSZnNb6Zs0aGFJV5OOHFIAcQd+1JArlH1yHT0wKjMXHJoGbcCkSE3cN90jplGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723722708; c=relaxed/simple;
	bh=byk3L7FAqMRzrXEbJTRd+a0MGzUs0HtFQzZDGjpgPbA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qodZJqK1kQjbfOhxt+f+VIbrNAQAXhIRVML/Aw1hkLYbZDfF5mj7IRRDvC89Mop1CayKZ5Dj6+GF1m7G+AYCidmH5TUkamIpzBo/jVSHMsiV5NZUjxc7zZAaHexx+rd/J/NHKCVy8JSGj+cDgDxw2ZAeQUt0EryJPccp+f3gADU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at; spf=pass smtp.mailfrom=outlook.at; dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b=kbTzlqPS; arc=fail smtp.client-ip=52.103.33.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b="kbTzlqPS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRIPT5bCi5A5YbCYZMFO66aM3ivwqkAwhbUe881dVEp2LVeS3i7JR24Uh3fQm7CoxY/4V119JkErIpTvlfG95b5GkHBqrSbsIZVQhecQ0clMYg9w+1opqTfoQR0nWISvLkk4/hgEw+k9Ki/9kbMXk6DLDlWcDplHzLSdi8KPJ2aPLU0qhH462n7LC3KoG483KHk0I+lYc/p5CYcV/T1kycyHWF/ux2yqH8kSpwYf8g1giHD6vKi7KpjSIHz7eirSP5QIWvmNPpdzqguOb7s/mmWzNJ4HvvdSP8/K/OPZWtLAzkAh7OiQ/hhtKEZ+zZG7azkmmhFEDMo5UJwzlfnpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daFVvPErvmDivWYOeowsr5mVLTTLwcCR31TcZ8lUToM=;
 b=wBRd6sP4C29jDDXBZmq4oJdLZPxKL8zP18gaUCxQo4UdH30FYnULf5euQWebFwZuoS/OBbk58DUkclcYajOw6025wpV04/eglmzDgfCd6ji1tbXrD8HZV8EDKqVtV5A+2BpfEbVd49jVTRjKHlRp3a1nmP2fVbf7uN+aA03XKbyMZURHKgDokEl/z9erztOXWkCuUzl656RZfgMeIczfVBpAlg2N3nWwzrlY/FN6x3EjL16xq2ItMuWu0Ga9yRvN47Cd5ps1m2LMnO8SUv2SOp66r6XFrc77962yStctFM3bmYupJs4v/DYCpUp3bwnA8ZE8NpWTG5GUvH4UmmwwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.AT;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daFVvPErvmDivWYOeowsr5mVLTTLwcCR31TcZ8lUToM=;
 b=kbTzlqPS6LWsNMAaYwroWZF05iZZdK2b4jUaHno0Vz7cgijyL5YOYAHNZIJhgIUZ9r8o5r0kgqxBZzNumpbVKv7YwdMCEmHTVVCGqZ12XCSAedPmpKdtn2I31Pol+ySjQMk9Bxhj+mlhz40ZLTRVM+f2gc1zqV3sSbcA/xMstdX33zxKpJuQuinDJ+T7v59dYUV0d/fwtFrHlCM1EQTo+zyarJEl5cIQRh4d+hMApSHnkzXOnrk/1DiSnHPNKuQ5YsGkXq6638Gt+ZBezGCVGl88iuI0+j2tpAUQCvByAYdNtLS9UJ5P1U+XInpN/wL/NcLApKTp+qWr1U9DzyXYHQ==
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com (2603:10a6:20b:640::9)
 by VI2PR03MB10785.eurprd03.prod.outlook.com (2603:10a6:800:275::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 11:51:42 +0000
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab]) by AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab%4]) with mapi id 15.20.7849.021; Thu, 15 Aug 2024
 11:51:42 +0000
Message-ID:
 <AS2PR03MB9932638D9F2804E7511CB29683802@AS2PR03MB9932.eurprd03.prod.outlook.com>
Date: Thu, 15 Aug 2024 13:51:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
To: Pascal Hambourg <pascal@plouf.fr.eu.org>, linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
 <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <7a05ab70-2b1e-4477-a8c6-56be1989a96b@plouf.fr.eu.org>
From: David Alexander Geister <david.geister@outlook.at>
In-Reply-To: <7a05ab70-2b1e-4477-a8c6-56be1989a96b@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [DZ9xKiA2FRE6/y6cDZQSpJf+71y66mHq]
X-ClientProxiedBy: VI1PR10CA0110.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::39) To AS2PR03MB9932.eurprd03.prod.outlook.com
 (2603:10a6:20b:640::9)
X-Microsoft-Original-Message-ID:
 <d0d98c7c-081f-4c7e-92d4-96035233ddc4@outlook.at>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR03MB9932:EE_|VI2PR03MB10785:EE_
X-MS-Office365-Filtering-Correlation-Id: e77f743f-865c-4262-01e9-08dcbd20a164
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|15080799003|19110799003|8060799006|5072599009|20110799003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	gGmt0XGZt4t6+fpw0NGSbv+H+wkdjIcPeHeJtXAWQebxGcAaYT+oi/0+jGuRALGaN0r0fJIvnM0Kk1Kw7pqmkbbBNLZXPoJ7M7Cz9zduwUrqijjGcayXC4rSYQ6/Qnie1dn1N0h/d5FctKAPXW+UCSrHsjk696w12CDSld0Z11+7fqiVBaGGd51+jAIl0Rfo1dH+lTUEdwzvtw5m/jcwjMw9GS736FqbgkGcniSCUwLU2tTjnhvSQndX5ZYrNiBUYKQ70gURHvnLOHRDSuuM90U1fC/ZBjluG4uT2ANbOmtEkullpy1N3vdrFzwdllo18PXRgVtsMsxvF/HWGXnTXwSosleSm5UZTSW2oG1AUq7wX2VwoctHZYwHZrRitPAvxnzw6JR9AhLTa0sMnytYq7M9QWcG+L9iy//x/bMqJNBuL2FBB9nslUhjlFOJ89CUwNUDSIcWAQGC7r3sqKq+yXI4mnKVq68sb7Xx99FvUgBT7MroQ/FqPoxqP6wJjchNOxRH7u5/uKYOiExL32H5Gupr1FuchqCr3T6Ogc3/CMPdq8G1LSDSapyCO/0Ng6rT3d7wi3MytEH6tBRABu+uh5NztXsPGUKX8Wb63v5/UjzDIzfig1qLrgRPBge7TMO+6m92V/4Q85gwq08tvGRYzBT87qJxikwCABUIDlV0Bh0sB1IueBpc4ybviYAbvuIPsQ6uKIrRxJHYCbJaK1wOLuwJQlDvriPW+1WlkeJqT9mtQiBQ1X1n5/CTWoKGAlcv
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NU4vM1pPZmtXZW1PTXRYUzN1eVNCMFEyVGtFMG0wSmhUT1JzZUxKL3dWM0Zk?=
 =?utf-8?B?ekpoSGhteGtFTHFKNFFqeWl2V1RpcjJIWTRMem1Za1JyTmFoN0NlU1MyMVpt?=
 =?utf-8?B?aHFoaVdSWTM2WjczbVpjUi9rdWs3MmlTQWZ6bmlYaHk1U3pPY1RYK2RxSzNB?=
 =?utf-8?B?YkhZM1Z6c0w2UGhYNCt3S2UwNEFBY0ZJcFRybUJ3R2Z2N1FyaVd0VlA1YWN5?=
 =?utf-8?B?L255bEpMNnB2T29YQ0lQandhaTNOaE9sUWQzREFncEpTNkl0Y0xLVXBybW54?=
 =?utf-8?B?eDRTNVdQeWRkK05QcXlBQ2NNcnVXZ1M2Zm5rVlZRWEpOeXIxV0gxZHprRzNu?=
 =?utf-8?B?RWFyTkQ4Q09HdXdETlFyYldNTE9RVWNqbWxZdHZ4MzRlYVVJQ0RHekd4NDFu?=
 =?utf-8?B?NlBxNDM0dkM4cC9YdythcTd5bVN3bEMxOGtlMU5nbUQwcHgvekU1a2hnZitp?=
 =?utf-8?B?MitNOVMwdXpuTzU2ZHM2cmtuTEQzRHZtTHdUZGE0WnN0N3NPTHVuL1V5OWp0?=
 =?utf-8?B?elJCMk9zRk9TN3BrUStUSjhSN25sOFNmZUM1cXB4N3EwbHQ4QWZUYzNjLy9o?=
 =?utf-8?B?bWtkSGtGZFk3ZVpRQlNoU3hkRnNMd01DWVUwNHlzcW9wVUxETC92dTFDMVRp?=
 =?utf-8?B?L2Jpd29kSmMyYXZkbU1JRnBxREk5Y1VUTXpWRmRMM0J2Z1hUY29PTkwramJj?=
 =?utf-8?B?b1R1Qi85VVpYQlpOL0xMVnpoeHUySGVSU3NVVGpWbkpaOHEvRllUSlBUSnJ3?=
 =?utf-8?B?bERxWWdHeUJEUWJ6SHRDQTdRUUJ4YXgxdFUvRXJqRmExdHRXbis1US9xa1Ix?=
 =?utf-8?B?dDZSVUhlaFUrR01qYkYzZ1hiYUIrTERGYkw2cndweXFTYm95MmEraFdoSjAv?=
 =?utf-8?B?MXdBbWZSTk1wUXFwa1VGRTBFeE11TTdGenpSR1ZOaUo0MWdBRy83dnFVd1lx?=
 =?utf-8?B?SDB1UVdZZWxFWFZzU1NlQytGY0Q5WmpzUVJBUlEwZWNtNFFnQlcydW45djgx?=
 =?utf-8?B?ZXNRaVVHN3ZCekxzcUFyQnh3dm5LQzVmMWFYMjAvbFRoWVdPUExYLzlUTkND?=
 =?utf-8?B?MTV1TVo4UmdHaGdiVitVczBXdDdwdVY3UnlKYnJ0a0ZoTjJCYW1kb3hIV3BB?=
 =?utf-8?B?MlRFb3RmRXVWd3FXbXU1M1VWb1V0N2hhYmlJemllSHE3Y3Q1eVJkYjFFWTZp?=
 =?utf-8?B?OVpNaVlJMFRNbE9jVThZbDdHS1FzaU4ydlVCdG5GSGVXREdiQzJ6dHdHS1Ba?=
 =?utf-8?B?NEdwRURuUjdXbXNkVGlCV3NtZ2hzWW9SVTRpaUxmT1dLV09HNmRUL1pUUC9Z?=
 =?utf-8?B?b29sMVRCV1VFcFRvMmFxdlVZT0ZHdGZucjNsRUR0TmYwS2dhYXdxcktZZ2VU?=
 =?utf-8?B?d1NmSkR2cWgwMkZKb1N1Q2VmQm1yOU90V1NEc0wxeWN0bHNmWVFvL1lKMTF6?=
 =?utf-8?B?YVlyaUxnTSsrMlZURFlSaCtGK29iZGVxY0RvdWZvTzFDWjNubTJKejZLcTRp?=
 =?utf-8?B?eEoySU9uU0UwL2dDMGRqVVRqMCtzdWN4L2VZRkhIMU84RVdLSFVNdWlPdGJy?=
 =?utf-8?B?Nlp0ekkyODBidmZ6Z1VOYnJRa0UxaVpYUkU2RmZIZ21BaHdyYXJrcVhPM1VM?=
 =?utf-8?B?K0cxMTZXNjVnNnBYYnZoWEh1VkFLNnhWRGc0ZWh3S042TklMQlp4NVlvU1RD?=
 =?utf-8?B?cVR4SjJxN3ZBWDlsU1M5bEZ1UU15cVNpblB5Q0owblR1eFVRZVNNNXZnPT0=?=
X-OriginatorOrg: sct-15-20-7762-17-msonline-outlook-fa1c0.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e77f743f-865c-4262-01e9-08dcbd20a164
X-MS-Exchange-CrossTenant-AuthSource: AS2PR03MB9932.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 11:51:42.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR03MB10785

 > So you really used the whole unpartitioned disks as RAID members.

Yes I did.

 >and a reason against using unpartitionned disks.
 >create a new RAID array using the partitions instead of the whole disks.

Was adviced to not use partitions in a lot of forums (ask ubuntu, stock 
exchanged, linux sub reddits).
Looks like I did not do my research as thoughtful as I should have. I'm 
sorry to bother the mailing list with my incompetence.

 >Did you create the partition table before or after creating the RAID 
array ?

I did so before I created the the RAID array.

 >There have been reports lately which seem to indicate that something, 
maybe the BIOS/UEFI firmware, "restores" the primary partition table 
from an existing backup partition table at boot.

I did not enter or actively interact with the UEFI of my mainboard in 
any way. I made sure to update and configure that before I installed the 
OS.
Is there a list of the reports where I can check if my mainboard is 
affected? Is there something I could do/contribute?

 >Otherwise, I suggest that you erase all GPT metadata on each disk with 
wipefs -a before re-creating the RAID array with --assume-clean. When 
re-creating the array, make sure that sda, sdb and sdc are in the same 
physical order as when you originally created the RAID array (check with 
the serial numbers).

There is indeed data on the drives that I would like to access. As I did 
not change the physical order of the drives, I'm going to give it a go.

Thank you for your help Pascal. Is there any recommendations from you, 
where I should invest more research time on the topic?

