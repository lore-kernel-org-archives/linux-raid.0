Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC91CCB4E;
	Tue, 19 Nov 2024 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732035977; cv=fail; b=SbtRASzKUWPASSoL9EaXwRQGLs1KLsav7tT3yP7IcjsC86njH1kSrKozWKn/DrGegKrTRETCjauCRr4oaTqcwUVz+TjXeTtjGwORQs3UWLaRdEzt7woMDTQmltADOlMbKg6ZR6l0xtuchjjWzfxgoWV9MFFq/BjeXnkN0TjZD+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732035977; c=relaxed/simple;
	bh=7zXnZAPBgRrqBSggySl+kDDSe3eQhv9yjm8HZ8uNZrw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XMkA/2pY5zIx/N7bw0amcaNMnzLWyyl4+nIlENR8F1vtR+cKWVgQ0GqQ96XXY9MRmeiviBXrmTbeKW5TGa6M/jdtOu/wMEPEjpXBGCmQIn2QSKfOI2dNpYyfQlFZGtV1BJ+Q7nuXqzQkj7t4quFvfVDWp6Uu7uwB4LyDVVPtT+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mgZTQszN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OW9qWvZw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mgZTQszN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OW9qWvZw"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJGtXj7020746;
	Tue, 19 Nov 2024 17:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Dyud2dDZTOvufDoXRNSfLdD1CmmUnuv+t9nAFD6F+Xw=; b=
	mgZTQszNP4W6KLmKQKEU2uWX9RvSH+5YNYvkjK8fvAQHZNblseGpHCK1Vv281uBU
	TAPbwYpVFrvgjd1jCrHl3rtsD4uRhE2QF2S2zwmAOHPp8bYWAULu1M5LMvNCPm6e
	asImzI8mzMqHbg1CNvL4XjCGmyzK/NOPWstzf6K0pZtJKLzPSftMT+5bXy6lKrVL
	YtRBldQYxi1h4LAkDSlhkMfM6NJ0xJjRjsplr2Gtnbp+lolKLTw0MfR0iB8htoah
	BioLs3zZrbdrA+qDsPhJqVE25JhRUzVGrswVCz6igcZVIrt94d6eiiUSSPWcItfb
	H9yweW+xbL8mhboAC0jpXg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 430rs58uws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:06:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJFnlml037310;
	Tue, 19 Nov 2024 17:06:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu90q8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:06:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GyxL9im2AMKuHn7Pn/osFrkwHX5KVFbCuYozIEa6/vd8kKog7jmfgppTslj4xoSAsERxfxEELpThC47Un49nN6WHitzAsipjQGgVtiyRH0+sqGGcnVQPAvFnf+jgNxt4nFHPpYvHERa0zWzEB4ZR7wT6IysXxNiO+DpjREuCkDexnGYbk/6Syo7hs90T27M+g6rlAMC1Er4Sr09+5NmsMVxQ05nFhqHi1fhmu39qEU4VeL3u90ZEhg7AXoY/Blz0rqMrZD/6hk/uWc4ARYRxWp/oj0/QwIwqQvrdcXWAvyLuu+4co9gs0IyXfbsK4HC4G16VqMCXc/hE+jw+OL75fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dyud2dDZTOvufDoXRNSfLdD1CmmUnuv+t9nAFD6F+Xw=;
 b=Fs/nR3yLlWXmPOZWciL7pN5WCuXFI28vptT9B7pz9zMI0bqcxU/tWNy/CbyVFlFiZRo6j0nsLtni1FlgbiiW6vWld8lkQcKpQ0kfd0Y3ZRpBBrDQbjJqt6vWyxdgdBPq1QJUW+h9oi46mltvWOlVbapfuHAw6zBbZvX8gdv50az4TL7MDl0tVNgT0x1WhliEu4Pg2iV1oajI0sIJvZZD1WPsu8V+Ovb7PnpP38J9S4+6dE4jGHERTkc4cgl67KfVXeku+KKRXmKPbO8ueFB2q/PoJuZdvQCRZutRWJDmI3m5N2LvvUELWp0JcicU9lf9KuVAwI/ltxTfzF67b6hyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dyud2dDZTOvufDoXRNSfLdD1CmmUnuv+t9nAFD6F+Xw=;
 b=OW9qWvZwpxwESslOKzzAzreVVPcBl1155Yie1JyRUde7JETzEBM4dIRdegWScpSKK0DPlh57+tDvK6R5s3fAeQCPbA2KiFpIeS9sfwk5Q2QXbiEv/T2vjwChfGzziRobq3UdjLH+REEfSw5vXm7nsEhQp8kH6MN9gOwncLo+CPg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4989.namprd10.prod.outlook.com (2603:10b6:5:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 17:06:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.014; Tue, 19 Nov 2024
 17:06:03 +0000
Message-ID: <ef021fd8-1cfe-49d6-a6a2-c9745cf61441@oracle.com>
Date: Tue, 19 Nov 2024 17:05:58 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] RAID 0/1/10 atomic write support
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c7556eb-b5e3-46ff-f6bc-08dd08bc72be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dCtBMnMvbVQzYlN5NWJOME5rV09vOUVrNnhhMzBpYjB3WDUxazBiejl4ejdX?=
 =?utf-8?B?ZVJTemVYSWViZXJuRUdKbXc0OXMzV1JDaURiaTBKR29wakE2Q1ZiVmpYOEhU?=
 =?utf-8?B?Nk80ZTNCZWtFemFpaER6czBrSkxvZlVQc3VrT0RaMFJNSmdEODZmMzdyQzd0?=
 =?utf-8?B?WGd6Y0ZqSWIyVVVwYUpDcmp2Qzk3WDdUaTg3RDk3YWxWMU01enVRcTRaQkVN?=
 =?utf-8?B?ZVJ3b2UzMkVoMlp4TE1HWUxMelYrZTRtSldiT0Z1bHkrQ2g4Q29QOXZHY2o0?=
 =?utf-8?B?TFlUQUovM0RKSS9kRnZsNXp6bXpaUXBBV0M5MWExZmRTRGdEZTN3Q29OV2l2?=
 =?utf-8?B?d2hHdVZNZ0NKSnpzZnA3bnZxS0NXUHI5VXhqRmhlL2hpeHpOVXlZWXU3L0VM?=
 =?utf-8?B?cDdlRmNZa1AwTEY5VUFiTGdpWEdYd3dpMDhjczR0QXFzQ1VEYkNJSVJhZHUz?=
 =?utf-8?B?REQ5VVYwZzFEcmVYZE9TUjFyWGZwNDRNaHc4VGd4WWpNS1ViYnU0L1ZNWi9r?=
 =?utf-8?B?enpHYjA1TFdteVR2VjhXUk9hQTdOTC9wNHVyejgwZEM2RmdOT0JqaHNJckp0?=
 =?utf-8?B?WUVlVmwydllrR0ozc1ZYbUtkOVg0UnRPeUFoRE9XUFVuMDIwQ3E5dHk3bFhE?=
 =?utf-8?B?bFpZaDUxandPaXNYTG10dmM5aGEyQzR5T0RMVHlRdTl5NTZuZUl2b0E4M3pS?=
 =?utf-8?B?MVdwSHByUERQTjVxZktjVldhYW1mRFVCVHBkRVdVZXBYd2xQTUNTQTNRY1pU?=
 =?utf-8?B?M3pnQnc5RHBGQnR5c245aUtiWTBtR3JDb1pLTXYxbFZTSm83cStNd3NLcTdM?=
 =?utf-8?B?RC9oYUNONTNTeXBJRncvN0E1K2t4ZE5PQVVDUUQyNkdBZkFSUDVJWDZ0NVF5?=
 =?utf-8?B?ZnVyMTJJVjJKdGFaZDRvSk43USs1d3c3NjZrWDltWW16N3Q1M2NGYi94bGpv?=
 =?utf-8?B?ZzZFKzc1UVVhSmxwU3p4a2VFQ3pSOXFGOEwrczZaa0JjQm16NkRWeXdnYmVy?=
 =?utf-8?B?d21MU3pvN2ZQZ05NSGRXa2N2ZUNxclBvNVU0VmNNb2NhM1NJZmYxbjRtN01X?=
 =?utf-8?B?OUpQMWpQcTB1Rk5aWUlPQzM1YXh4SEtaTUpmWGdyZUNKT25sU1FKbmk2Z2NG?=
 =?utf-8?B?NVhSdFZ5cm9wMDVLVTlGQTlEWXFZbzBVdlNOekQ1dmNTRlVzcklmV29ldTRi?=
 =?utf-8?B?RGhVeHpwYXcwY2pkV0paK2pVUFBUZVRZMzVtbjU5aVlsUVJBaCtsdTN6RmY5?=
 =?utf-8?B?REdNbXlWVkxXTVMxLzVjVWxLcDd6UjRSMUlPN2FWVnM3d0JsOEF1YlY3TVVw?=
 =?utf-8?B?MFJSVXY5enJRZVZGc0xDR3kyaFp3aEdxeFY4SWszb1VnRldNdWhVd3BGY05N?=
 =?utf-8?B?akdpWTBJbVk4MWxYUG5qdVV5UjkwWTFjU3FUckYyUVNHZlVwR2NBSUdCNUVE?=
 =?utf-8?B?bEtNTGZtblFFdWVXZ3B6OWJ0Q1l3Rjl1cEYvcStQUmJmdlJkalR2WXZrbGRp?=
 =?utf-8?B?MFlablRGMS9vbnZWWnFpbHIxV241M2s4SGp4VDVUL0VTMjYyL3M4K2ptRHFI?=
 =?utf-8?B?eHVncm43WURvSGdmRlRCanZOTGM3M25xcE5IMjB3YWZRNm5Tam8ySUVtUUlN?=
 =?utf-8?B?UUd6U2h5aTF0V0llM0R2aGdqdWh6YitlWFVGb0w3SGpxVWwrWnRLbU5XbFpm?=
 =?utf-8?B?a2h5T01PendXRk1qdVB4S0JDNmRyS1V0ajR0M1REL2IraXhjYzV3WFB4aDJX?=
 =?utf-8?Q?0803Fq0J4t7hAYCfmX5w+Fjm1yD0c6zt/q1xY/p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlNXbTI1L3FXYlhFYXJOaWFiSHNmc3lyRGFoVjJLZmM0cGU0L0N6VEpPd09z?=
 =?utf-8?B?dWtCQ3M5RXNydEJCaVN2eUIxazJBYUJNeExIdGtIUzMrbHFIUVlscU1pcVN1?=
 =?utf-8?B?RTYyZTFGeHZjR2NiMG45VDVOUWlqNG9VMEtIRUJrc2tDaXJOeFBJNUtHLzln?=
 =?utf-8?B?dWZBZ3dwMGJkUENoemhWdnFPS2JlbWllamQ1OUF2bW96Uyt6Qlk2aWZ0Uzdv?=
 =?utf-8?B?d0VXaWptSFVjYnFJQ2xCVmJMaDFKdHpGUXNITnFUNlRjWXcxVThINFB0WTZO?=
 =?utf-8?B?aTdhMTNqR1lBa3RJdHE1TkpsZFcwM1AvNGlGZ09sUTE3U0ZYUFZSamdzQlNC?=
 =?utf-8?B?ZkhrZHl1d3Q2SUNoTnhQZEpOVXptK3FZMDYvMGNMaUE1YUJUeFhrdElDaWlY?=
 =?utf-8?B?RzdtVjhRU2owY00wSDI1N29jekU0NDU5Wk5mN0pRQ2VaVC9EUGJCamo4dmVt?=
 =?utf-8?B?MXZaM0NBZm96Sk8rWXNMclMrZFBwa1YvcnA4eC96MzVobW9EdTZ5T21IZEtM?=
 =?utf-8?B?ZlhNakNQL1BETVhSa3NrSUpkUjRIM3YxbWY5R2daTk5aU2lsbkNUS1VqNEZi?=
 =?utf-8?B?ZEt0THdxNi9oZEcrZFJPTWp2aGhWc1VmTjVNNFFqYVFyNW0zcExidDFHakJR?=
 =?utf-8?B?aTh0YVdOSkI4aEtlSW1wZWU3Z2JnZmdLNThHT2tEOW4yUUd5VGlmZ2xUQmVh?=
 =?utf-8?B?cGQwaUFpeTA5ZFFwcUNZeUpLOThDTThvREFkSzRjTWFwaWJJdGwwbkhrbmJs?=
 =?utf-8?B?WkZ5eWtBSUdHTWh5b1FOTk44N1JvaFBYaHc5cjJXQlNGMUhjaS9hNllIVDdQ?=
 =?utf-8?B?a05MUkdaeW02eHY4WGh6aTFiK25vVW1NRGtCWXVFems4NkJKbkFoaHhoREUv?=
 =?utf-8?B?M2VvTGwraDRmYXBmR294M2pReTU0WFR3dy9GSnU3TXB6RHM3N2FxVm1DRUYz?=
 =?utf-8?B?d0VBZWJSYWxYZVVUUkxGZTR2N3pwcUVubkJRMEVMY1pCWThZeUJZNHpsbDJE?=
 =?utf-8?B?L3AzQkZ4SVl6SmEzMFp4aGdtSTZtbzRkTk1GZi9Yd3FjcWpuTW5JM1BKZlZX?=
 =?utf-8?B?VlZhM0FzcVI3aHNBVXlHdGxtZ1A1YlV1V1dlMDQrcnNZTmxYTHc1a3g5TTF2?=
 =?utf-8?B?MGt5d29EbVNoZU93OUZna21sR1EvdWgwU3cyVmRCMVJlYjVQM0ZUQytkTHRD?=
 =?utf-8?B?U0c4bUVsQUdTMFRVMTJPeHdPTWM2U3NxeE1HVEV2U2w3b1grRjhOemdjejJN?=
 =?utf-8?B?UENDVldjZGNoa1d0Rk52ZHZja3hXcko0VDMrNUV1VHZ4T0xMeThRQ0ZHUXcw?=
 =?utf-8?B?RlExR2c1UFNrazcrRWM5aTN6cnJXcUJkUmhISThaVEpvMlkveHFyQnpOa21W?=
 =?utf-8?B?c0pLUkN3bmNJYnl5bkpGZVFabVRja3FaQm03SmlGQzc3Mk15QUE1OFJobDBC?=
 =?utf-8?B?eG1ZYlhWWXFrTi9tYlArZU5vR2Nwa0ErSHVadlovc2tOaEFIMnd0STdOQXJE?=
 =?utf-8?B?czZBbFphaFpkMmQvVzdHakFKTURSUS85RVNXT0VSN1A4UC8xSTJWelp1OVB3?=
 =?utf-8?B?Zm5YTCtackRXeFJtdENtSGpkRnRVbTY0bzJhMTNTemNMRHFrcFdnKzZhNE1z?=
 =?utf-8?B?Ni9GRUhKVEh1cE5WZVM5Y1JxTUZPU1E4MjZHa2czRkVlUk9jM0tyaGFDeldN?=
 =?utf-8?B?ZnhJNGJ2bHJyaWgxeldDekZ3L0xWL2ZNNEIzeWNsbWJYOGZJMHJMcVg3blEy?=
 =?utf-8?B?djI1REdGK091dFRWdHVCYjFOalY0U2d0UFJ6LzY1NlRGVGJJL1dOUnN6cHZx?=
 =?utf-8?B?R3FpQS92MnVYSCtGRk9RQ1ZOM3pYeDcvUHNJN0ZPVVpLaW5GbEEzQlNjMHVV?=
 =?utf-8?B?by81WDliQU5xRE9kb2M1bjBWUkRmNTNPTG9FVlhRS24xRUU3bklSdTVJTlEr?=
 =?utf-8?B?VHVvRDVlTFNjTmlmN2N5bVFyNUtIKzljdGkrcDA2MFpDWDlHZkFJQ1VZZTlk?=
 =?utf-8?B?ckdXTDRCcDU5K29YcHJyekdvVDg4WWsvS0RmbFI2ZXFObkJvYmNWaWdEcTBM?=
 =?utf-8?B?azAwVFFsUmRMaWNnRGgySXFIR0dScFlLYnpHQmk0UFB1cFdVRURYRVppYytI?=
 =?utf-8?B?RFdncEJ5UHFqaVg3TVZmWVUrcU9xUi9qM2hVWmkrdlYzS2ZpUnMrTlV0Rm9Q?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4yiscT8QLJXrDa/xTMrfDfx2cL/cFvJ0BR6SwH0BV2ur/4TEBLZ1Pl+BojYwYheNIxBuvoAph9dguOWveKWRt2LeWdtwP1EdzPgRQet/SdhHW55zZg7AJTTb5jjdy3q9TLti+ve7O3M3UAcJuHqXr2+EbDW7+3Tb5kbgYemMi82TuSprJNF/f1NsjY8s6Xs0SiKEo6MZdgJqp+vrQTV+3M/K3wDbNvyPceYiGjmbdQ90gf4AHe2591rkezfxZZjjcptnKM8sJqB9ytRov5X8xVtcZb0tXe4LFel/3FoMJ4Of99Ia9vb1Iv3kFfmvibAOTpxHlp7HrSy5xwVEGNeUNR78MXTvXcOfNmMCAOfOJu08TZb58+CMb2ZGC+hZhlL/Rpf26BklRf56dRzqJEzbXimUIeDsnk8FxdoujvsxVlm9QFNfXZBjdmDnTKdgV2aKM1WqTn1rfJ1/3loUPLvZPxpIm2LUyUjyTs4LPcgQ9k4NM9nvEjFQjkgJRU/t5MGqDiLiwCZnDRQxgjJeuYQWrA8NSCEqN9iyLwGAyhG7e4TUD9WP16m5Gm9Wgur6bNWadWxcE83/fXM3bjVGBZz4CYyF/sD2c6nMgRk0ecfiBCQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7556eb-b5e3-46ff-f6bc-08dd08bc72be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 17:06:03.1404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aR3n04tF/oiXR+TEQWYp4ANLPvyCeJh0Yl4dPT9BDXPWxZyIZK4OUQkM2VQIIr/DehigGRZ3LHaWpZ3MjOqowA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_08,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411190127
X-Proofpoint-GUID: BwKFl5R2UBiTmi7f68j5u9G0P_OH10ku
X-Proofpoint-ORIG-GUID: BwKFl5R2UBiTmi7f68j5u9G0P_OH10ku

On 18/11/2024 10:50, John Garry wrote:
> This series introduces atomic write support for software RAID 0/1/10.
> 
> The main changes are to ensure that we can calculate the stacked device
> request_queue limits appropriately for atomic writes. Fundamentally, if
> some bottom does not support atomic writes, then atomic writes are not
> supported for the top device. Furthermore, the atomic writes limits are
> the lowest common supported limits from all bottom devices.
> 
> Flag BLK_FEAT_ATOMIC_WRITES_STACKED is introduced to enable atomic writes
> for stacked devices selectively. This ensures that we can analyze and test
> atomic writes support per individual md/dm personality (prior to
> enabling).
> 
> Based on 88d47f629313 (block/for-6.13/block) Merge tag
> 'md-6.13-20241115' ofhttps://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux 
> into for-6.13/block

Hi Jens,

In case you are planning on sending a 2nd batch of new dev for 6.13, I 
think that this is in mergeable state.

If not, I'll repost for 6.14 later.

Thanks,
John
