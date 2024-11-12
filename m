Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD274217F28
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731438760; cv=fail; b=NYR/8kjaKms+TID4QuSjxb/N9HZ3MEb+up/Vkgu61ebDD8cKue9aFO8GCiFkV48TfMd0c9Ww0VmgWuJ1Dz37AA2x3EbMTA/rQzVHisbm+RnbqRaLpU+BybWhH+A1iX6wqRgfOod4fgBs56/c7TqN2irVZt8dacn6sKX1nchc0Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731438760; c=relaxed/simple;
	bh=P4FkefpWQLKxiKp56NmJPpjfhIFm/wfAC63MrZ9FhLo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NcpEXW2s7r8f+81c86SLLLc0TZm8ETQ3pb7EyGa3VOBlyP4qb+tDWKM574ixQ+F9ab27sPZF/2DUJJz5dLBM7aOZP+HxhIN1dxgc4cnSxzbTasjD8rrc5RqPzhM0E2ONwb3P4bxrLqHoxzz8Vr5OifjBiOyctNutZ3KyhEWdLjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n2DFJIi7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zr+80lXH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n2DFJIi7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zr+80lXH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtfAo015705;
	Tue, 12 Nov 2024 18:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cDrY2fIafaxmA1HF07zslu+rGoo5qlI8TK77nRyYmjA=; b=
	n2DFJIi7W2DQfRj2+H9yibWlIpVbgyNxSsB2gfdIEqUM3Wy9qkwaCfYsLa6Z8k/+
	8cq+jhpocJW7IuevDjiieq7eptCfuNCsRDrzMADFaTPcXsXBgPcq3WuZdnvcQ66d
	clCnSpgwR1WKC8ok4FyxXrf83gfWYfd+ovWbNz9AobpABCZYKK+pp3N5gTDCeUgf
	b0oGrwbvAdDVV6eS4prIFyGUVWI0/AxfcdwaDuFpLc3EL8v7pCyP1XTCx81QTope
	n43Abj/i84LJMFWIBBKCbfmFMYvzeI/tD+3bCHx9ZWp0dbQ2boN7C7zxDynHXQPV
	bIXGQP0mdO+UgqKfLP6xOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbd3v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:09:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHKAoc005652;
	Tue, 12 Nov 2024 18:09:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68g20p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:09:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDl7x0Co9Xa2/gLOedjoGYqLh+rqFxp+ZMvuirRXCEUvc25px+gmy0grybCI0KmrYK02OlOpUrkEuDn5ABX8AxnydUIfYzJFwUqRVjYb4iseWzMX4I44WsWd8zWqhUI0vf628iaL5mDaDw/QpZ7T4CIxRsHwJra9ORS09NM4uoHg9goSvdkd3ae7BOLAUri1MgKHuGS10ytNoSng0Va5b7pJKvSY2gfOd9pQ1BGuByqegGHtfbpEuV7Q/k9YZobdpEv8eCEe7/5myqGsH2E0PI2ISnmF5TtzYRclXd/uUhFMY+YkeoowNafVR8Yzzx08yUk2Dw0/nxPDN3jCsorcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDrY2fIafaxmA1HF07zslu+rGoo5qlI8TK77nRyYmjA=;
 b=V5V7vNQ9zb0oZQZ9cicOh9fMWUWFCrIy5CGlzAiPAI+dCpM5Zgmn2csEMIB4iBzcM0c/irTlH0CVgqP0q7ijXIIxghMyLAT4wRSdDS2A7MkH1vp2plEHD6xIcOsbWNWYC94ltQq+6mag7/UWWRX7mcSOUMyih6bmtQlJf+i1atNOSBUov8NH1jpiXpY+0TcOc89mU9wB9DB2IHYOIZyHT//GEIVOff5PWxpQjP0OzzKOwTPN2pf2sDg6PqZsFmT3mXuzdXCUYqytHdp1skuBJN4afLRkJh1jJ1KDM3ztlBHdJGntMvw7IInFMwSJJYjebHRSNdcEnecs6karpMFZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDrY2fIafaxmA1HF07zslu+rGoo5qlI8TK77nRyYmjA=;
 b=zr+80lXH0uliyermgR6A0pDWfcms1SXQKE2DnyF3WyLQWHp6HXShhrbQjVRFtaiEMDDEM3O4i58HadmkuIdhuWuERN1bCeYJp7qaEeQf1WDhGl0OR120ZomIX3JN0oaxVEsIGzee+tCRCjyuvIiAdHlwiI8daxnPgsMO2QJXIsA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7393.namprd10.prod.outlook.com (2603:10b6:610:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 18:09:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:09:25 +0000
Message-ID: <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com>
Date: Tue, 12 Nov 2024 18:09:22 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: Song Liu <song@kernel.org>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
 <20241112161019.4154616-2-john.g.garry@oracle.com>
 <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0063.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: 06410eea-f30f-4320-69cc-08dd0345245e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXZkWThpMXJJTUV0R010ZDhMNTNzbUhHbFd0NDQxVXNEbXZzTVRIYkxHQ1V1?=
 =?utf-8?B?bGFyM2g3Z3puamllek82cGp0OE9XRGRkWkxDTThuRkoyMm1IR1djb2M2dUh2?=
 =?utf-8?B?ZGtieXdTYnZXd2JaaUtzMzhkZHBuTy8rNnlRclI1UGZXeGg3S296dzVPQkdu?=
 =?utf-8?B?MTNZVDQzVWMxOFZQSnZpRzlzRzhaZ3QvbHpRQjYvYnMwdEN0R1V5SmNqQnF3?=
 =?utf-8?B?K25Qb09sUWx2ZktXQ1JTNGZxbEpVMy9XT2ZFV1JZMkJJSitmKzdVQmpFak9m?=
 =?utf-8?B?V2tlZkJuYzlwSGZzRGFSTFQ2Ujk3ZnpIOGIwbnhydWtUN003UXlxeWN5dkRR?=
 =?utf-8?B?WmlHYVZoRmJ2dHNZaitLQk91MWptdnp1TlVXRkNaTU9kSXJuMy96WHlQR2Fl?=
 =?utf-8?B?dDF4QUpmOTdRMDg5bEUyNmhCRXRtNnpwYUJDOENONmZEV2J5OEpvLzBEWXRP?=
 =?utf-8?B?OWRjcUNmYnpGUWhxc0hXaC8xMC9lNXQ1QWtwaVlmcTlvaU5oYkNBeitSR0NG?=
 =?utf-8?B?L2ZhNm5yd2J5U1BnNE12ZDdZd1VxYnFzM2VSbWdwSmxvbzhuS1I4c1B4aUhT?=
 =?utf-8?B?NFNHbzZ6Z1lWMGNadGI4Um1DRzcxM3dBcHlBL01NMnNxc0JjYnByM2pVZ2ZE?=
 =?utf-8?B?cjVEanBEWEJPOHJHbkg0bjBySTZ0Y3pqSHVpVjJlZXNpWFdTazFwNkpiVjRB?=
 =?utf-8?B?d05ibjUvUXJhTmx6NWFtK3NhZTdOQ25RT1FuMytxTHNFZnRQTEJTdEVSZ0gv?=
 =?utf-8?B?YjB5aEppQVNTU08vbEQwazFFSlRNNXc5eFhGREphdWpLQ3RxNnliRU8xVXFW?=
 =?utf-8?B?VVRURFh1WXVHS2xvQ1hXNHlGdERCT1FvY0dHN1lQVkZJc1JYQ0dYT1hTOHdn?=
 =?utf-8?B?YVc4OFE2d3ozUEtNTVRZZjdSSW9HWUs1MTdRT2xWV2VDUURoNHVWTGhyZWVz?=
 =?utf-8?B?NmxQK0xRNXR5VGN5aFgxYVRrb1ZaQSs2UmwwdlY3SjZnVFpqSUhGMVJjZzJI?=
 =?utf-8?B?VlE3M0dnQkdta2tXb1VxS01Ub1ZrWE9kb01lL2NpVEt3SlJEYXZLMG1BN3Er?=
 =?utf-8?B?KzA2RzlIOXZabUNoTjhtdTNTdy80cmZ2RW54Y0p1N1ozT0FpUVB6Q01Sb3lq?=
 =?utf-8?B?VExYNnJRN3pLb3NsUDJEY2tsNDRzM2lJT1gzOHBIa0s0YnU2eGh3cU5acjlE?=
 =?utf-8?B?T3IyT2xQOFMxeUYvNjV3K2dkM2hiR09mek5TU0podEhDQ29wZS9qTjFreXJ2?=
 =?utf-8?B?T1JXenpXTUxRMTBIdUY0UGZCTHdUWWY1VmdCbXBVd1NROVRXUVNsT25nQ2Zr?=
 =?utf-8?B?R3c4WDh6QnNVK1ljMnlFbmdtWmY1REppcHJGVnNtL2lnQXYvN3NSY1B1cmQ2?=
 =?utf-8?B?eDdpeDJnNlZZa0pQVGFGYmJXc3pWNlU5eUlKK0xZUVR6WU5pdmkrODd0a0VP?=
 =?utf-8?B?TlRLRVpFZElYNEs0dGZ2YklUaDFoV2cweXNPSXM5QzFCejhlVWtodGdLeG8y?=
 =?utf-8?B?cmh6a1Vvakh0UnhsckZoMjlUcmVrdzVVR1pIU09JZ0paSVlqeHkxcS9ycHBO?=
 =?utf-8?B?S1FwTTFWZGVYdU9NVno5R3hjbndZSUQxWTdoMkFMQVJvTDltQTBvTzJJM2hP?=
 =?utf-8?B?OG0rVCtxVVMzNDcrYXdLZGM1N3F6REdpN21SOGtWb1Z5RnBkY2tpWGxGWDh5?=
 =?utf-8?B?dlVJWWZzeFg5NWU3aWxzamMrMHpVdW9wd0pYZlhOZndsOVVvRVJlQktOdmdR?=
 =?utf-8?Q?oLa7GbJmgWEuJO7jkwgPy9Ev4ak5lGmGI9hebxe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFN4b0JEdGZlc0dYYU91czYyb1gyanFoY0QvRVlkR1JMK1lQdlBqQnpUd3lK?=
 =?utf-8?B?NEhSQUdZQkE5U2g0VVJuYU5KWVNrWjF0UTdUWVVqbFZNUHFDVDk3QzMycUxF?=
 =?utf-8?B?SkpzUlVndmZPT1d1UThvRVUyNkN4Y2xTZXRhQzBvb3g2VmxJQjVkWU5sTE05?=
 =?utf-8?B?L0ZMZmFKa2piMWdDZUFwNWt5TDh5ZEc2M2FFT2pBT2VGMHVhZWl2MFFrRzVj?=
 =?utf-8?B?d2ZUTXlvMkFRMkszdG56U0ZQd2JndDBjK3czdmFoN0I5QU1HcnRHdzZDTktN?=
 =?utf-8?B?aXNDY0xuSmJHL29rNmZYWjFNdWJiK1BCWGw0OHhvT0tsZlJRNFNvUzdoRHNa?=
 =?utf-8?B?Y2FmR1JXMjZyVmp5ekpGWjNQNDBHUHJiRnpxTnI2OTZGUWI3UEJhVmViQ2dI?=
 =?utf-8?B?bWFYUG5tbEJMTmFqeWg1QkFLaytKdkROZGJpbDAvTnIzVXMwVlArUU9aU3p0?=
 =?utf-8?B?RVNIWVp5b3BuTisvSzFJcld2N0t5cHMwUElrdDFOTGUySXZTaXZkL1dobkRZ?=
 =?utf-8?B?SUdwdkJObTQvdklUN1I5aWNaVTZLaU11VVcrRVhzWGhWZUwzWHlRQjhZaG1J?=
 =?utf-8?B?OUh4ZHA5S0JYZXo2NTRxVTRWazdHOUMrbnc2bmIzb2k3V0kwSnFjTUJOamNm?=
 =?utf-8?B?QitibTdDbGdETGhDUW5NMEF5L01HV0pzZVRodG4yWVN0eUhmdlBwSks1Rmpu?=
 =?utf-8?B?MUxQWnY5OVpJZU5DdzlWb2NJeW5TT0h1T3VLamttVk1WczNML09UeEljU2lD?=
 =?utf-8?B?UnlmR05GU0JmLzAzN205MDFuNkt1VnpsVURQWXFQcWMvWStqTXFEWFF2N3Uz?=
 =?utf-8?B?djZOZVFsck9Oc3hrTkhNSURPckdSQVE0NGFQR01PSmllTC9TdzVkM2JKSXVW?=
 =?utf-8?B?SDV2a0NiNzE3RGxscGVVWjFLK3Z1OFRZazgvSzl0aUFTSEVWQzNuWVk5YU1K?=
 =?utf-8?B?dkRYcUQ0c2g0dGNIZFZoS3pzUFJvTDlGODlRMUtsOHN0OWFrZU9lVHFVNUtZ?=
 =?utf-8?B?Zm84eUlvdnYrOGtxT3N3dUZBVXhkb1NRRUJuQ3R1QlA1REtzTDQxb0JoeTlz?=
 =?utf-8?B?Zng0dnVEMW4wakt6OXRha0tDL1Y2dit3TFBocWVoMEtlTm1heEtubjVyc3ZX?=
 =?utf-8?B?aDZ3UlZLZUVTcjk4eXV3L0lWZzIwUFZzMmhOKzc0Unc1YlNmWGpFRFdOV0pE?=
 =?utf-8?B?cGVVQTd0YUdtbVlBbmZZNjR4N3NlYjdUb2JOemZCdUVRNEwyRTNWYWwwZjMz?=
 =?utf-8?B?aTBXaER6RW5IMXE1TXdHaXJtUlNFa1BhelczcFVEUW90cWJIaEdSUjA0dVBv?=
 =?utf-8?B?ME9NQVA2RU0zS0RSaTRoaGlpU2JDL1FmWjdDSkFQNXBuRThuNDlMY1FlYlpX?=
 =?utf-8?B?NE9HakZGcHA0SzIyZUhzTmZWUVBVQUlCV0h0YjlyQTZQaXRZV21vSUNZNVZR?=
 =?utf-8?B?dFIxeGQyellQK3RDOXdkRHYxUFJueWdYNzJ6L1QvRFc1ZVNhbzlYVmwvOHI2?=
 =?utf-8?B?eEZUcGptdVBsaTR0dVZwRzhKaWNuRjlWdmI1VU92R3FBYnlMWHFkanRVTmUr?=
 =?utf-8?B?c2E5akVvVzBGMFJYT29NTG1UNmRmOGxnb1F0TzJJM1VOYWJ1d1ZEYkRKbHQ1?=
 =?utf-8?B?cnVQNVZFL1NHZ09WeFZDNlV3YUgwRDNrVmFyS01PWnNsUXFEOENVemFoRllr?=
 =?utf-8?B?QzRoMHJyaFZ5eGtON1hQc2FFYTFpUlM1V3pEUjh5cnd6b2ZidFprREdBVkFB?=
 =?utf-8?B?dEwxN1JKeFVMYmtHNkI4NmQ5OFNCM1VDcmY3Qlpva1AycDZaL0FlSU1rS0Nv?=
 =?utf-8?B?OGpxZ0pRVDRVMk9qNWpaRW5PcVFyV0haWlU0RjQzb2NVcFp3NTduaVdhWERT?=
 =?utf-8?B?LzBiMGlic3NiNmt4QnR5U2Nub2dPa201T1luakNYZEZtTmpERUlCMDRTQUxE?=
 =?utf-8?B?YmpXVmZON0VkdHhDRjdHZHFlL3BaM0pBZ0EvQzlQRmlCMDVKU0hrZGRjUmJi?=
 =?utf-8?B?NU4rS1lmbld5bjNKUFlwUGwwRlJyS0FSeG9laG1McVVEN0R3Q25zZC9IanFH?=
 =?utf-8?B?eXZDRnhlV0pFRkpjWW1ObS9NYjhpZUlTUENaTERPb0FubmZEOGMyZEF5dE50?=
 =?utf-8?B?dXpPVGFQcW9PNlhmdE1sdkhFOHpmSmw2SGVYVjAvampTeUJ1ZlpYMUttUExY?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	08MbXkY3gXRxOlPLr1RNdbYJ5cbjcs2Oi0yeZRk1J4f/p6LTe9bY9PZBjKJwP+GZFqCqWonylW7EwI9P/zUUMBqdWJNug0frk0NbFusBex28D23q0NWGHszywi4S+5u3aynvXren0eoX6dEpkfxS+QZmM+B359PDfNQXZlzZx78hq33MznXEZtcQd9FozCOsc0Oov9EbARjC2/r8vJKtXrj9y0Cioi3H8RWKfw9JbcMfcHsKQ82Ti/T2GK+I7o/+CIEXUOYBIzLY4AN1FJLmmu8f47MJwzBF/b7/cQlgMKkB6Z+bi7IrCfQu5+p3VUYasOa2ZjvLucwxnUl+lKpe9ibxkAAbUT6HKWuRAP42XN2coBUCJ9/YdGs7tBlBdD8c7oiNqym+0PAx4CssV4c8QJ5u4qEPXxeYoX2D0TZ1DOh31xKdWDHlo2JpxwHTkpH+s9RfVofKAZ2okQyelky+Ka0HJEuJnU4Df1ML/eOE4xMVMdIWlbepJBCmCTjEd6QTd8mQOrZa3q9OTuaH/yLQLd5oj9SYJUFHZG6DhR3zBiyG3Uw13n/xwnA8lh9bfLHF2EkwUArNbSj+/SNDnFyLnE+VS/nucHkRimwWZ/smsZY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06410eea-f30f-4320-69cc-08dd0345245e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:09:25.7066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ns6rhI3dzY9cV37tSQSFbuSW81rak2HrzzHjH3kjCFfJU4SCF/1SMen0iU5G1+Q4iz8iuJIfSyjZABUAvZ0bwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120145
X-Proofpoint-GUID: KI4CDCR-AF3oWFnKd3zDg-Kb_iAaNmKB
X-Proofpoint-ORIG-GUID: KI4CDCR-AF3oWFnKd3zDg-Kb_iAaNmKB

On 12/11/2024 17:42, Song Liu wrote:
> On Tue, Nov 12, 2024 at 8:10 AM John Garry<john.g.garry@oracle.com> wrote:
>> For compiling with W=1, the following warning can be seen:
>>
>> drivers/md/raid5.c: In function ‘setup_conf’:
>> drivers/md/raid5.c:2423:12: error: ‘%s’ directive output may be truncated writing up to 31 bytes into a region of size between 16 and 26 [-Werror=format-truncation=]
>>      "raid%d-%s", conf->level, mdname(conf->mddev));
>>              ^~
>> drivers/md/raid5.c:2422:3: note: ‘snprintf’ output between 7 and 48 bytes into a destination of size 32
> This is a bit confusing. Does this mean we actually need 48 bytes?
> I played with it myself, and 38 bytes is indeed enough to silent the
> warning. With 38 bytes, we have 4 bytes hole right behind
> cache_name, so I am thinking we should just use 40.
> 
> WDYT?

Indeed it is confusing...
So the string is "raid%d-%s", which is
4B for "raid"
10B for max int (right?)
1B for '-'
32B for DISK_NAME_LEN
1B for NUL

which totals 48

So I don't know why/how 38 is ok. Maybe there is some auto-padding going 
on, like you hint at.

Maybe just using 48 is better.

Thanks,
John


