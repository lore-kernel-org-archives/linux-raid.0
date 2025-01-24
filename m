Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FEA1D61A3;
	Fri, 24 Jan 2025 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737706457; cv=fail; b=HmoYiBe2TxVzP5Ag+8mDIfmtJ6CIL0HhiAnMpTK1DfJfDhXnDdK/Co+Clx3GhoTsk5nJcHaG4L/BRRkNwy8iP0wgNJZZhrZnOLkq8yi09jFKzXnWcX8Qxd6QaFsaIm5XjDH4Y55AT3rG8FBEoWLTY23t25HukuCf9DSYD2XtSrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737706457; c=relaxed/simple;
	bh=MLXf7s9+eTzkT9f9faRePsvu1iO/1ZDiHDZMBAk27Fo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cyAuGHkxbBuGnpmKed22dBmqpRdAVrrFe/gwHzDRYSLWL/4d76dKMaq/UHTLQ6ts9PZopQ1p26CVfELIcu+3zz0sFK478agqsmpfkA4BA+D27bC0mvGdwI5nTARIAJujqOwKP0HsGuFehYIGY6M5p7xlAAOBnkan/0V9QbV7+nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VshKDHYZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B8Ryjpcj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VshKDHYZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B8Ryjpcj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50O7fiJv005261;
	Fri, 24 Jan 2025 08:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jPJ8frkWBSIQ0bJORRDmXDKuEW3wshyM/4jVB5JRxvc=; b=
	VshKDHYZQ294b+yD4VoF8UYEPLU5ejfOSgwE31mwt27RKmDWC/Ww+O09GixEb+L8
	Zae3ZdY8G/R7y2RglI3AMfUybs/VUJ3sZUpYDp5sbTPPyEDY1euaecmZV2SCgSuh
	T5Hxe7xqIZ6f1ENeRd9+oTPPg3jo3auvLvDzcBo5g/EXr6dxOHzXjIn4J6eMxVl2
	rSzPVtQSj87jn5QvhtoYfvMt507DMyndR/rmZNTQOxFwqRSVZqY3sKIt87btLGqk
	j51bQud6N8HnF3Ia9Se8YGMKDIZJgpmNmNAtgbv/SczQNgI6sVECDIxBaUI67QiT
	bFG0H4CfHtRuU/B3DcK6mQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485nskdb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 08:13:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50O5YVEZ018682;
	Fri, 24 Jan 2025 08:13:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4491c620xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 08:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gd6gwn10fcFzQKOCt2UNuIJO6JFhcfoOIhoJXaxXB9tNJfgnoDV1V+Zq8OjJRH9bbIKKcQP2aFwwaA9Xrse7eRubeoKIGVzcpH9IIYv3dkLCC4cC9gLIAKctsWZ1GoWROL//+UWKpkjalLW3BeK7yFI+7u5MmQrYYYJ2rJ97UvCOODLtRx4ArZMFd8PC2gS1sGqcUMQ1joIXc7a0fMWveIC8ldLrzSHOSNf44/VP2Wj1F0xml3QD7Rnh8fDy/hN2R/RLf1yyZFLRh88nNhmxncG1T1LJB+Xio8QCQxB0wahRe5LCVOA20Vmt4gtoT/eEPvgQyX7/vEzm6wuVXc/sPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPJ8frkWBSIQ0bJORRDmXDKuEW3wshyM/4jVB5JRxvc=;
 b=hoeDJ1Vv0mpAoXiX90yM8o6JOkZ1vq43SS5p9wngbMdUFgKBXwKuiPzJ0FECuHoQ+bIRFyKHzT266/1N0nAJLvdXVpPkCgr3WkegFjdfJt6hc40iKE1SwbLNG3iSShwykSO57wpzRwlVpCCmFEiWXqBOk4KPS5qDLkN/YQ1h9fyGcbnJeRiniaXfEDypyuRCKoRtw1quWgQphJPhwH1rFifILrxrGnR8QnHatpwruKRwq4N5UjJbJVZOlWFZF1YrzwdRz2gXLBDhJAxQys4VPM+f9IfFfu9ymjzXa8WtGuZgIa7aOScm9MYDL7oK1w5GMuzOz+GQaB6AX9mIPPX4bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPJ8frkWBSIQ0bJORRDmXDKuEW3wshyM/4jVB5JRxvc=;
 b=B8RyjpcjQciajrC4LujYYcpBf6U1UpH50htXSFNFRIxAUniBhtDh0w4pYacPji1QzCRapPCO8yXE7RgVdZkJwX2HlL+5FuaypcrpwtYYyGSvx2ehs8zPavF0AgUCycdtEmMWM3Asp3IoOHX4O+NuKESAKKQtCTrwIWNpytvs6rw=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CH3PR10MB6859.namprd10.prod.outlook.com (2603:10b6:610:14f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Fri, 24 Jan
 2025 08:13:40 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 08:13:40 +0000
Message-ID: <48589759-88c1-4d13-9f08-321484180a7f@oracle.com>
Date: Fri, 24 Jan 2025 13:43:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] kernel panic at bitmap_get_stats+0x2b/0xa0 since
 6.12
To: Yu Kuai <yukuai1@huaweicloud.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        song@kernel.org, pmenzel@molgen.mpg.de
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com>
 <e6b8d928-36d3-d2e5-a773-2f73b8f92bbc@huaweicloud.com>
 <6b72aec8-cc23-27d1-38ae-827bf800f21d@huaweicloud.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <6b72aec8-cc23-27d1-38ae-827bf800f21d@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:802:18::16) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CH3PR10MB6859:EE_
X-MS-Office365-Filtering-Correlation-Id: 15f53de2-144c-4714-d4c5-08dd3c4f025c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VSt1V08yZk1NLzZRZVBtUk5SU2pjTVlaOGtuYWhEeVRxSUorZXN0bHY1WVJv?=
 =?utf-8?B?Q3lremVURjIxRVl0bngrWmlxbGxNelJYVEpZQWUrQ21JeWxMbjk3YnV3V0N0?=
 =?utf-8?B?S3B3UVlNaDhOR1piMjZvZzNnODkwcTVKNVZ6cTdUbm9VK3loUURTU2lPNkt0?=
 =?utf-8?B?TmlTYUdRNXpqb0ZlWFQ5YWE5Q2tyTG1ldUhRemRhMU5aQmprRHFhVXNmR2Rm?=
 =?utf-8?B?QzlBZVRRVEdvNnpGQU9jdjU2UzNYaUo5SkRCT1ZsZlZKc3I1U0ZtQVo4Y1Y5?=
 =?utf-8?B?d0RBdVJlOUQ3ckw0U1k5MzUyOVF2aDk2SEJFTFFvR1R6bFQzZTJidUp2Y1Zj?=
 =?utf-8?B?dmc1SmNxckY1L1VNL29uMUxuL3RLRm54SHVkbUNsWjA2QWVuQW1rdUFvSnlv?=
 =?utf-8?B?TEpWcGpxQmppZnpBQzNjeEpESFZFYTVKZStqVk1IMDJvVkwxRmFpSHVEUFc2?=
 =?utf-8?B?NlAwUDB6T0ZKQit4M1E5cHU4Y0dGcFVLWDB1UnoyUjJEVDRPNDB0azBLQUla?=
 =?utf-8?B?MklYbTlMNDdiL0hpaks2L3RiTU5wU0dYU0lGVHIrMzRnRm9PUWtGWlNtM2p4?=
 =?utf-8?B?My9tZjNQY3JLVDdjNHpiSjI3MC9KN1RXbS9DUlk4TVNQS2tRNURBWTFxN1g3?=
 =?utf-8?B?amJkaloyeTBjOHV6N0ZKYkRlZXJPYTh6RXU5RzQ1Z3dVTzJQd3ZheHRyY0cv?=
 =?utf-8?B?dlE2NE1mMHZyRTVGN1RhSWd5eTc1ZWN3cjYyQVRsOHNjQVpEOW10UTBqcVF2?=
 =?utf-8?B?aVQyMTdKWnhkQS9XZlBSQ1ZkeWJYSDlxOExRY0Nicm9Tck01cnNwVmtYQkc4?=
 =?utf-8?B?cDBFa0h3bE1NcXRwRHpUR1RkaDN0VUlPMDNFRG5LamNnVWhNdDZ1UThUdzRu?=
 =?utf-8?B?OHhycHQwZm1hMlhZS3FiRnY4UmpMTmJQa0tnU2I4UTVKQXhDTHU0YmxxL1Vr?=
 =?utf-8?B?NEk4a1B2UW8zMHhwZnFJeFJseFR3RUNvRG1HTTFiekZFeDE3alpsSkVGT2xE?=
 =?utf-8?B?b2N3VXQzMlh2RXJ2TkFQQzJPOXJxNlBIM09kU3ZjTlk1cS9venZZN204NTZw?=
 =?utf-8?B?VUhtSFdSaEE4YWFtQ0FIR2NoUjFrNHNZZlNmNmlOWGhMdzVhdk5nZ0Z0a1ky?=
 =?utf-8?B?aTdWR3Q4clRIb2NlVVROZk1TeVM5dHhEWnpwUFdlb1FEV1Zpd0V4MVNzcSsx?=
 =?utf-8?B?cFdPTzFFY05PYUo2QkVIdVdQUE12VE84Z25BWFdSUTlvT21WME0yK1NqSitZ?=
 =?utf-8?B?b0ZjQ1hoeFdLeXA5TkVoVVlNZW5vZWFpdXlHWkJzZXU5YjIxbDJYMTNhQnVN?=
 =?utf-8?B?ZUhFMHRhQ3FzV3kyUXJxNm1NMXNoWjVoaUFhVkFwaHBGYzQ1QkFwZ2tsZENF?=
 =?utf-8?B?S3hVbmIvNnhDdWxnNGpCQXlyRkNrZWlEVmV5OHkrdlVkRkM5WkpqNWx2KzE4?=
 =?utf-8?B?RGo0cXoxSTlBSnVBSXl6QWR6R3JmSkF5dlBHR0pTVG9QSlVNUXRGYWhxWkQw?=
 =?utf-8?B?c1Q0b2U0YlUvM2hiQkFlNXlBUFFoRUw4empDRkcrS3Y1YmRSQ2ROT1lGaXJp?=
 =?utf-8?B?Z1gxNnMxWkJmWERhZjNDS1Jtczcvd2NpbndnUnlBTUE3K0NXbDE2eGpraXhr?=
 =?utf-8?B?ODY0dlkwTFBCQ3hCemtYT1lhUEpiVmt1REQ3TmtTQUZ2dFEwZjNYdGtSaG5i?=
 =?utf-8?B?YXkvM0Z2akE2YzRwWS9tbDhsQXhCWm1OcmplUlVBVkZiOFdTUG94NVZ0TVRG?=
 =?utf-8?B?NktSajc0UkRxR0RmOE92Z1BtWS9iUzVrV1pNM2hyWDN6MFArbjFEM3BqN2lz?=
 =?utf-8?B?MXd0TTMydWQ4OEhoR21Za0VNMXVXWW5lR0VEaEJ1bFY2d0RHOVFqRTRpYzQz?=
 =?utf-8?Q?MDSlWU2IOnelv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eml2SHdGc3E3RUdSa1ZpM0pJSHY1OWxtVXJONjFXcmQxbDQ0SjgxYnFVTkpE?=
 =?utf-8?B?bmxsR00rdndiVy9sWlVTdkxpSndCMFp6SXNpaFBaOVZsbU5Ib1BTVmlpWHlu?=
 =?utf-8?B?YTVRR1V6eG84TFNKSGV4QVEyeWVpMVd1WkNRUG03aHNWYnNnODdYUENFQnUz?=
 =?utf-8?B?M1pVbkdJWDg0eXpCbVgzV3NSSkdtNGQ5anNsV0hZNS9NRWh5d3RGcHJzcDJj?=
 =?utf-8?B?Tm92OFA3SWVaR0dFQ3RURENibVNUUWxKenlhSEFucncyYnR2L0MrTmhyQnVv?=
 =?utf-8?B?Z2tBNGE1bWcxd3A1ZFkrbUhyYW4wVENrTFQ4WjlEVUFGakdXVGU5V0R1RURU?=
 =?utf-8?B?dTJlWkkyV09ucWJNcklMd2Y0aUlRR3lrbVlHTHFaOTVITWpPMmR3QXR2emVh?=
 =?utf-8?B?dS9vSWc0c3lrQ1R4eGoxOHVxU0htTFdNK1ZCYklIUkV5Tk1KNlFsdWdhNmNO?=
 =?utf-8?B?ZEZTNWxYWTlKWExNV1VJcHVWMXQ2VmJyejdTdHlwc2J2OW5qaGFRSC9BdjdV?=
 =?utf-8?B?ZjFydm5yUExvZis5VnZJVVpOaXcvWDhvejBJbFhJNlQ1NDBlZUJMQTJGVlNH?=
 =?utf-8?B?YU5xSjR0Z2NNUWFMYU5CSlVPZjFSRU96bndKVTdORFVqODdyQmZCR2xQLzhJ?=
 =?utf-8?B?MmxvZmNVUWM5VVNBUDZOaUJMUlhTZ3VSY3JpQXJiVW82V0tUQmh2dVY0cDJY?=
 =?utf-8?B?QXdZQnoyNEhLcGsxdHQxTTVaNlFkeTRweHRBMXFJZFBZWjNnQ1Zrdml0UmNL?=
 =?utf-8?B?TEFTU3E5bFhKZHE2Vi9QRjFJSDZXNnpmL1ZTdnd6ZEdzMlp6Y0d5V3I2SXdB?=
 =?utf-8?B?d0tSM0k1RWVCcGtCYVVYU0hMUWZjaDFpNjdJWFAxRnVmZnZXaXV5SlFkSzhH?=
 =?utf-8?B?TmNMQUIzdWp5RFhVckErdXhHVDdqVFlJbFNzOFoxMm1QQnZrMUZYenJydVAy?=
 =?utf-8?B?SjdLeGxRclBvV2FVejZMaER1Wkl0VHVZbmlaV0lCS2xuMkNheVRVaFRpSXRl?=
 =?utf-8?B?cGhmZHVQTTRFZkJ6QjZGcG8rT0lONnJ6MnNWUWxtZSs0T1VBMDZMby9tTlNu?=
 =?utf-8?B?ZTVhN1U1dThvQ21WbjNSdFhuWWNZZmRUdExMVFhXKzg1NzhiNk0wZm5Wcy9G?=
 =?utf-8?B?bDBnR0JyNU9Pai9Jek5kdnJPV21iT1I0YTF5VTRzR3Q4Vmczc296UU13elpI?=
 =?utf-8?B?Wm8vZHJOZml4NGdGSnVUSFNJWkIwbldoVllUZm0xUzUxaXNhSVFEWWE4aEpx?=
 =?utf-8?B?ZnZCQ1F5dWxyd1BITzJGdHhvS201MVNqc1lUVjYxZnVHSUtIVng1a2xJdERo?=
 =?utf-8?B?WGxpTGkzN3lvTkVOVXk4Z29UYUo5WGhPSzBteFJuS0E3WGpMNnVuc0RzYy91?=
 =?utf-8?B?RWNVQmhTRTRXSjVwK0dBUzJPSWJ4d2RRaFRLbDFNWitTS2Z3bTBDYzNYYmhJ?=
 =?utf-8?B?ckg0eFB2WnhMUXRTZmZRaTc5dTRDOTVveE9tQ3hzZDhQQjZFSHVKeGlWbm9v?=
 =?utf-8?B?dHBqOHZOdWhhZ0xNYWlycDI5QTdyU2RwUU1XNkhGblVGTXZYUGxobVAwN1ZT?=
 =?utf-8?B?Mm1yZXZoNzVKVkZLTVgzTXdSNmplZEhkU3ZNUEtXYUxnREsveUhHN2tYYkxz?=
 =?utf-8?B?c0s4RmxmWlVzQUNJMDEzTmxvU2pmWmRCaVZOWnBaYVJ2cEc1cFRLYTVSajlp?=
 =?utf-8?B?NXU0LzE3SlNEL0JpcFBhYnU0MUxSUFlWVTB2ZWtQdkg2ZjIzYndlN1JYSWdV?=
 =?utf-8?B?bHRMUDNnR1p4TGJlbUI3TCtOOHBsTDFVRGE1WVVpVDNEcmJHL1dUZ0tjVWZm?=
 =?utf-8?B?QkhRUDdBRUlXcHd4VW9VaGtJYmZyTUZGYkFubXAxZHFwRWpBSk9IT0hObUtN?=
 =?utf-8?B?bHpDVGt6K2w2Tm1JU1Bwamc4UG0vamNDbDM2OE4rdkFEaFJmbTBJbTFhbUxG?=
 =?utf-8?B?VlVIRlpKYkg5VTU0b2dBS1A5QmtMaGRZNnpSdkx5VFY5YnFoMHJlTDZSVFNQ?=
 =?utf-8?B?TnMxTXRQM3JmVUdCVWZKTTlyZkVrc1VNT2hlUlJZZ2M2T1c5T1BIR0FkSHBZ?=
 =?utf-8?B?V1k4U1pFTXo3cTlWT3V3QWhLQTZwSE9Lby9kMnpwWEJ3bDNzUjlXTmpHM2FR?=
 =?utf-8?B?clpZWGl3V0xEMjZXRzBMS3ZFRmE0Qk43RkJGUnlzYy9KNHlKZ2VhLzVYdThS?=
 =?utf-8?Q?jkhlm9gLbmOEtzDvQ7r25RU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KeahAMxYZVg1OTJXlNkK/FLU8TTjgy/xEYrveMinipCUuXMgyn/AXvKySE3Qc7f5OpLHU6KQR+wr15+tuVU6BDCk45kWIc/wxmPYu4fbGswARebcD5dDZPuUgZwlwoU1u286b4MBnBv81XF8n17MaP5WRT6Y++BnJyDyumpFK4SOu+TV9fOECSkd2Uy/OvHLhE20c0pKQ2BzkTE4asHcsoVT3hy0/EvqShValADX3N4w9F+eoFeHCTnQYW7wUpkcIwUG0J7Oxun3606Qim/4ofe8z2Nf/nQCCKP/JRpKEPvYBrdNEh305nP/oAjto0leyMZl/gBFKJivuUlffhnDZsCdyAj2DujkKbtUvpi21PXfWmG7lekLoL8+Zz+1w+IrYvPQ6J1t5JjLWWpR2O7jFOmqG2C1PQYRi3Gz1AY80zx3Im1yeirDMyEXqLf7WitG4mky+w+9FoIpux1EwWb1rdneBsjAvLn1jnoLmgZaHLcg/sLSDM72+M6nq7/BwxPz5KVQBPAQ697Lf8L82CVdKOgd8Xh/jOam7UyA3qEFC4kdDZ9O0vh7ESRWK3TTzNNkrWHrzmBkMZc9U6cDI8U8bUFWxa7DIpAppsXT3M7Hjd4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f53de2-144c-4714-d4c5-08dd3c4f025c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 08:13:40.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpa/h9l9tmdnOnVdG47yxv64p+voFEF41YZfwqKtiCDLkOjDMQTsFc/D6ZzbG+g7THJqc5oy3J4XSkVDp+YA6SOkvqnazHV/HbnaGsBKRciVI/bTwz+sd/i3GelHR54L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6859
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-24_03,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501240058
X-Proofpoint-GUID: zixpGrwIXXAN1f8gYFCczdXZBCnLTYIt
X-Proofpoint-ORIG-GUID: zixpGrwIXXAN1f8gYFCczdXZBCnLTYIt

Hi Yu Kuai,

On 24/01/25 07:48, Yu Kuai wrote:
> 
> 
> 在 2025/01/24 9:30, Yu Kuai 写道:
...
>>
> 
> Please use this patch, I found that last patch has problem while
> testing.
> 

Thanks for the patch. After applying the below patch the problem is not 
reproducible anymore. The boot succeeds without panic.

Regards,
Harshit
> Thanks,
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 63879582d1c3..e01c2d0479e3 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2340,7 +2340,10 @@ static int bitmap_get_stats(void *data, struct 
> md_bitmap_stats *stats)
> 
>          if (!bitmap)
>                  return -ENOENT;
> -
> +       if (bitmap->mddev->bitmap_info.external)
> +               return -ENOENT;
> +       if (!bitmap->storage.sb_page) /* no superblock */
> +               return -EINVAL;
>          sb = kmap_local_page(bitmap->storage.sb_page);
>          stats->sync_size = le64_to_cpu(sb->sync_size);
>          kunmap_local(sb);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 94166b2e9512..c9de57701e43 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8470,6 +8470,10 @@ static int md_seq_show(struct seq_file *seq, void 
> *v)
>                  return 0;
> 
>          spin_unlock(&all_mddevs_lock);
> +
> +       /* prevent bitmap to be freed after checking */
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +
>          spin_lock(&mddev->lock);
>          if (mddev->pers || mddev->raid_disks || !list_empty(&mddev- 
>  >disks)) {
>                  seq_printf(seq, "%s : ", mdname(mddev));
> @@ -8545,6 +8549,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>                  seq_printf(seq, "\n");
>          }
>          spin_unlock(&mddev->lock);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
>          spin_lock(&all_mddevs_lock);
> 
>          if (mddev == list_last_entry(&all_mddevs, struct mddev, 
> all_mddevs))
> 


