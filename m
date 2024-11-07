Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3382C60;
	Thu,  7 Nov 2024 06:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730962181; cv=fail; b=ov33PycXKuQaOvmz6rWyh0WY+KJqc+pGP6hv+CvJb8bPvL99AmFqtcjZRihfRs1FTzLvBtkdNb4bUnQvNb6ep01rhTPsAv5JUX0uNrF06BmIO9ak2amc1nARBAaXezvIJIU+kjbyzhkVXLdCm2LIGCBuo+nhSPyzhDb9TzUT1Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730962181; c=relaxed/simple;
	bh=0WjUbbNClzycRNIdqe8zjLzKHrT+gEcGxShbB1s41EU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nOoJ4kUIkm5LCJsvrMwrtyLtdGeQwq14eVoJTdgg2S9D1Z/maWGuuiG3z4xMwakz75mPpiCONSot0QxKSJ9cq5fgg12Gft0ZX7nh79UA4/iDALqe/3jtwMoUOSSLAmRQXUQD7CvEkxZsz4cB1VUJVmADJoMIamNUT0Qq9p5AtJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IGAYOEE9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AzftZkcz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGAYOEE9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AzftZkcz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71ffQK029838;
	Thu, 7 Nov 2024 06:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=; b=
	IGAYOEE93fxKyz5geGosPk+wKxfTY/Hu5m+p3LN7z8sIbSST8P3Cy12dcbng/gPf
	TsT01WhIuOOIO82LNC/lwEHYi0dZE+4RyLIpwYiGVh2JG0Zo2tTR6ocLHB3UuXfU
	G3NdjXpZzg2sLFBVurMBvcpW5EeI0uJzQPWNBhx8QBaIue5OMkwWjDHDBOTfcWbE
	qeZLIJnhmmImMsrs7q75Rhfr0Uiiq0bDqclx24iCQ3GG+vKkUgrn3mHlj5DoMMEk
	70+FDLfwUYYUw77k9PE2PrHNPTKFFZ9StSHsfhyXt+PDHYVRMox0QF1w6FYPCL8q
	2s8LbzI6Lf1t4/NC+usx7Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42qh03cutf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 06:49:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A75xb0l009077;
	Thu, 7 Nov 2024 06:49:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahfwhrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 06:49:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+5AzCKvnv9Bmg7ltpA9vCq92L2b6GKL59aYM+Jt6kI+SOMQfAm6q0I5U7AvUD11nQ+pg8ZALhyqutuuglk9ytjl0bkmOm1uNeq3hgGoOLIzZFWUevqrZBiyLzrWA7sJvA24ZnWy/jK0FyyRcuR5L/GFgumdbqGWlkn9dZvHZd/Gg8xVdgxk2HzOWVgV+GpQZfS12UdIEd7SwwxB+DihjiFi4giuI0rnUNq3SKWQZ/BSEL5F+KFfHsmRVftfOVnDG83f9kSJgThHyIXR3KBx2aIlpfXMcVZCzLP/2C9lA+qyg3Ccf85btyUduwLn/tv1dnYrSX/IpvHFWB3UPyZVhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=;
 b=uUmIfrvhmkACxQiA+72FvoMLgg0MiFAarbd0W7nOJx8jTiH+vpHIsVRk7WO0C/VrjWXRY+Dhhx4hOhZ6z7w+JECHQbCUIE/J5Dnp21B+d/rwuXJjOzwI03XXgyBbRAksdylmhvrhHw8YG4GHpAuKDiK7Qd5jczgFKY5t9ULaNY0YiUu6RGkrpAYZrOilF0qlNFtsMVTVlrdKpV1FuK5WnREYMwH/Mpx3wOcJSxN+K3tyFMnxsSyCoAPXHYcGOoeQJCsI2Pgrp83CvJfdq542kf1rS3qFoQ/PCDayU8pc9ed7Hdki572CWURHV35/8seAHwzvOHOKmeiE+ow3+SEIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=;
 b=AzftZkczT/RAmZNFHQOhuo3+/wNcBfhbIa6eMXEiMiPi29nD6KjDfoVRNZVwegC7n4bEd7nKUW0LbqPbnifW8hBF3EK9ROcvVYJwxShYYhCERnwjT96OJv+iZvh6oM/uT6fwHyN/Dm1mEtQqlfZiSofp9Qhto2KHFEZCDJXQV+U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 06:49:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.019; Thu, 7 Nov 2024
 06:49:18 +0000
Message-ID: <dfe4b3e5-c39d-4e53-8df8-8ef53a1487f6@oracle.com>
Date: Thu, 7 Nov 2024 06:49:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] bio_split() error handling rework
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI1P293CA0009.ITAP293.PROD.OUTLOOK.COM (2603:10a6:290:2::6)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO6PR10MB5572:EE_
X-MS-Office365-Filtering-Correlation-Id: 213bc6a6-af46-41d5-19a2-08dcfef84d66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UURpWCs3MWxlOHNmN2FObDl1NTJIU09MZGV0d1B3K3ZhVEk1VUJITTZlbE5r?=
 =?utf-8?B?d2FJaGpIYmtxUjF4eGdLVmlCMHFVNzV6WXI5cVhodE9MZHA0TEZySnJRejgw?=
 =?utf-8?B?ZWlYbGw0L1A2Y0wyMGU5eEJEOFdpNGZIS3VySFF4QjBrVjkwZmkwY3lUVG1W?=
 =?utf-8?B?OUE5LzI2am5MS2F6b2JaN21BYzlBYkcrWk9WaU1nM2YxbUFGOWo1bjhKcDRs?=
 =?utf-8?B?aHFBdllOOFhSa3J0SEhma0xYZUsyUS83eGtVWGVIajVsSjFJZHRoYk54R3Z5?=
 =?utf-8?B?ZFpWc0pDU25MSjF2ai9DcksvazBFUVg2aHVBV2syMTNkTjlwQjR6cC9tdUc5?=
 =?utf-8?B?NWxUVTBneWxvTHZReCsxK3drL2gvMlYzSklhbzNRZ0FueDdBeklmbjUxdmR5?=
 =?utf-8?B?aGdNMVdvd3VuUnc3V2Vva21rUTErM1dIS2lDRDN3ci8vUmh3L3hCcEFoVndr?=
 =?utf-8?B?VmxZTk5GdTY2b0FyeXFOL1RxTHFoVm5BLzZmTFQwWjFXQ2szUjR2TTNJaFpq?=
 =?utf-8?B?SThESkUzUitMcHEyaG1KUk1WU1ZvRTR6LzNzSzBPQ1Z2YnFkRjY3a1lBcnRm?=
 =?utf-8?B?ZWZackVmdmRJak5DUzJONmFPRnRRSEhyREQ3djlEK1dObTVqV3RFc3YyQ2RR?=
 =?utf-8?B?djl1VXZuTlRiY21tYVpwamtlc1A4SmtweklDbi9uTE1wRkdGeG5Lc3BQWmkx?=
 =?utf-8?B?cmpxVldvTUNkMVpBVnZjTkJhelhONzcvZWxEOENaNEpHZGh5Q2tMK29CUkdB?=
 =?utf-8?B?UG1CU2E1NWhiNHRHVDQvR1BpSVBtOThQd0p3NndYekIxdk5IdTdCTVYyT29L?=
 =?utf-8?B?OE84R2x3dHFoSjh0T3pqZGJsaCtqdytxREo5U2VxNGhvVTI5TStEaHFCOWh1?=
 =?utf-8?B?djJhSzhFQmlTM3puSUdoWUlHUzVubm0ya0RTOURFeDI3U3NsVllwcEtlZTVl?=
 =?utf-8?B?VnBRaTE4VTRLZVJHdWhVSDdXUHNVelRVWWdNNzZDUkQwUExPVHlCSTZUcjh2?=
 =?utf-8?B?WG9laG5leW15Y1A3aGFBM3hacjVUN05hWHRjRkJPenFMWHFWd21WYitxRkUy?=
 =?utf-8?B?TDFTc0xUOEhFYmxhaS9QMnRoZXlEb3QzNTNEL3pvdjlBc1Rjb3g5UXdqRlpp?=
 =?utf-8?B?SWU5Y0hjWXZhNXltYk1EcDhXSUNPckJpZ1hzVnhpK3pFSWV3Wlp3Y1VTUHJn?=
 =?utf-8?B?L2ROeEhSKzRReW5ES1c1endMOGozMlZGMk5CRmg1R20vRFZjRFNJeG95NFlF?=
 =?utf-8?B?N05MYVpjaGpsWUM3OGlybTcxQnZTSEordHhjdEFKVE91KzZpWTZvMndUd3BQ?=
 =?utf-8?B?aDgvck1IaHdVUzlvVm9BMmkvV1JTWWI0RWtqN245NTRxSXBlb0hvYnlLVkpX?=
 =?utf-8?B?dU52aWt1VUJtZkdSYVh1cUgwdGt2cnl4QktCanh6UG5vTnZSQzU3clAvUTI4?=
 =?utf-8?B?RkVmWjMrbUROMDQ3M2IxSm8xaUFKbzJaTjVhSVdiRFA3Mmo0R1I4TUpxZkhr?=
 =?utf-8?B?R2xhSkh3dWNkOHFoSENqZSswalowQTJqdUJBSnowcEtNQUtXN2Zxc0o1OURk?=
 =?utf-8?B?cGt4V3ZKNExyZ2ZhWm1yamwxZWJMcVZXMFhzL3hmSnNjZzhNTzBMRWpsZWVm?=
 =?utf-8?B?RDY1YjRaSzMvUWlGZjY1cklJUFdJakRhdDR2bTRGekUrL0ZCUTREbjNiMC9Q?=
 =?utf-8?B?N3V5OUljZjVIYThtUzJXODRpMm5vaVN4bWhuN1k3SnFqZXYyaW5lWllsY2lY?=
 =?utf-8?Q?bviY9yv9WB9F0klj+/hjQajXFQc9zl1GWO0X2se?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE81ai9Xcm9zWjdmN0xmYy9PRmZJNjBQeEpTN21adDkwdUFIVzkvdWpvYklw?=
 =?utf-8?B?NnVrWXhjQ1R5YXFRMTlzTnM0bGZnYzdyRVpTei9CdzVlWE1ZTENSY3dGdkdM?=
 =?utf-8?B?SkpNN3I3bXBtMGcvaThtc3Q2K21tZDFNYVMvYXlvZnh1QmpQblRZSTNBWWdo?=
 =?utf-8?B?VVJLSUpWSlMrNXFHZ1Z2dmxNQ2lFOGpwdkxMQ3ZQWElJSStQN256VGU5Uy8w?=
 =?utf-8?B?Sm5PZTV5NEdGcDNzeGsrcXI4di9GWVViNndrcTk3cEs5dmhob1hZelpZQjN3?=
 =?utf-8?B?aTNGWjFPQUZKSjFwZ0pGdklqOTJMa25MWklRN0N0dFhNME1Kc0VFWUdsNTRu?=
 =?utf-8?B?aVFaRGVGY3ZlQjE3T1RNcVduVWJ3V1ZWVDd0eWxnQ0lKZnRwc2MrOHlVY3ZB?=
 =?utf-8?B?Rkl5bzVNaEFlV0tpNTUwNWswWXJaNlJTRWM3aS9pdG0wZzA1MlA5QlYxbDVv?=
 =?utf-8?B?U0FtOE1ZTHVoS2xlQWRLbDlkTlBBL0wxMEhjZWpPRUlTQ1FzQnp4K0R0NVE5?=
 =?utf-8?B?aFhmWUJRRTJTbWpraXFTYVNBdk4rTUd0OWREbS9FM25aV0U0RXIrTjhCUmVH?=
 =?utf-8?B?TlE3MlllNTNCK2NFNFJnTEk3cVcvL0kxYVZodi92UlJINnhHRnArYjY1VHdK?=
 =?utf-8?B?TlUxb3ZyQWJyV3NDcll0bFdLOFVUUjJSMHA3dk4xWHFWTGZYN2FJc2hwSTZE?=
 =?utf-8?B?YngzbURVQlBROGRSeW9hU3EvSlBuUGRQTWdBdk9BU2pTTk5BQVlYaFJkT2Jy?=
 =?utf-8?B?Wk1nVnFOOGo5dW1DVzJBV2JaRUJ5SElWUWxiTmlFbU0yTHhPWmk0aUIrN0hq?=
 =?utf-8?B?YzV6SzVONStBeVBwdnpCbkRPSUdJcE9FVjB3ZElFOWRKbTYzNXNURW1iMmtp?=
 =?utf-8?B?SDBkd0REaGJtSEM5czRwb1lHaUhveWpuMVpLYUxEZlk0bU1ieVByWjM1VWRk?=
 =?utf-8?B?d21aTXJzOWF3a21WV1B3ZmxyYlgvR2oweGpJcWQreFBmM0RHbnd0N1dlUThm?=
 =?utf-8?B?SlFKZEM1UmI1bHdVVG4wUWkyamJHSGZtamFpK293bWp2WkxwV1lMWVJTRDE3?=
 =?utf-8?B?SGZRaEFCRG5PQk56bG11QU51MzZXWVdsSndrTFdkN1lLZmdSTnVJNFBQUE9O?=
 =?utf-8?B?WlRDNldNOTl1dDUyNWRkWnhQOTBnaTFLTjZ3Y01nV1lWeEI1V1lpOVI5aEZn?=
 =?utf-8?B?a0hkZUgvdDlBTGdYSk5MUkYwR1VCR1RheTBpSTgwRzh0WUlNSDFkY21XaWVh?=
 =?utf-8?B?ZWpxak9HcVN2ZTJjamo2bHIyalRFeFlUNEZYaEVpWTVWdnBGdXdwZkMxSXYr?=
 =?utf-8?B?Y09PMWZjdHpmVUNDZmZWTFo0eE8rZW5WdEJlZmxDOVYrVHErY3QvOCtEZ2Fy?=
 =?utf-8?B?RUtMMWhJVTJBdGF2ektqeGh3ZGJzdlpsQWtqMVJqdmpMc25nN0pWVWNPby9J?=
 =?utf-8?B?QTN2UGhsS1dEdkxpenRNRU5QVTRBcXoycVBSTFNGampDWERsUURPcHhqY09m?=
 =?utf-8?B?TW9USUsrZnFoUk1GTm1vV05YMVk5bGZlK3M4OUdlMnN4YWxyZytQUWdEdVJT?=
 =?utf-8?B?dyt4RmVzMWxZTXJNQ1l3Q2FuNTdYc3hsb3lxMzRBSUpoRWJSZWNNeVBBZ0JM?=
 =?utf-8?B?YWFjL1NkM2lzdUtqTSs5OEVBMUhJSnJkWFdiT0NOanhydENTTVZQaWxjTWhO?=
 =?utf-8?B?c01FOW5ieVR2QVVkZ1dwQkczT2FkRWFoL2RUbWUyNGw4WHdYTGVRZTIyOUc3?=
 =?utf-8?B?K1NLTDNHWTdaSEROMmZBZTdVUFRqTGdQOUNsbEpxLzRtbis4MUFuZTNCWDVj?=
 =?utf-8?B?aW9hV2lEeFBVcmZtdDk0UXlHSlkzTS9VWFFaS3pWbVRBREsvYzQ2VGxNdUZS?=
 =?utf-8?B?Z1JLNkd6R1dPckxnWXFacnNPMlVSSzlnMnNLZjNSR1VHL1Z6ZThhdWM1bWd0?=
 =?utf-8?B?RHF0T094TWNEb1U2UFhzQy9tb2hVZFdpZ0FBdmV4L3gzOUJHUTl4UHc1alFy?=
 =?utf-8?B?ejdGcUROUWhsNStKRGdaM0x0L2RlUFpEMlI0dGxIWjBvWldEc1U5dVV3Tita?=
 =?utf-8?B?dDMwSnVDeUhFZENsWjZ0QjYyTXN1WllXcEVlUllSbURvYVdHaXhWZ0oxZ0dK?=
 =?utf-8?B?VURLTThHNHpLQUoyQkNhUVY3QmQ3MTZpNER1L3UxTWtrMzJYZjM2aE9uQzJm?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J7KDzUXlaeqiEb61VpCZsJXsE86ec2IIVbKgRMR82KS0gGq8H966QQD0eO5ZVxGUAVUliKco8GD1SqU0M2YoaIr5XGSkoLuBow0IGjAm22gosscrJ80mmINHUji782OlSFd97IyqVsas5CnLuZZdV2kaXIYZPa73kjD4qBhKjgtwMjgER0bglcPQGyV3EkY7mnVVy3zWljceKsZZvz1PY/XyIzKX+ij9oQfdMV8liJjh3ZdPqwT+TOWs3CYwMFTVDTw64Lg8GUJQ78pfT93NOE64YyWjEwa3qC6gotOAq1CUU3ILYyExh5+ErRJgpnnH3SvcqAvqUxG2aZcvOiJJtcwvDPKQlm6dqihTqqSeKQ2i4mCw5DvGJB8MoaI8OOT50YvrrwzVqc1CwnkyiQCa1CRr9Z0vmN9+uAuqad29bnKxuNAxyzQYw3VbGD4Z58LSfvd9GMu+hW34RgTSh4vHPLTjwY2Lr29OAFic4n7HmKZpcyXiI0KJvUsj+CkNKnET9Qxo9Bh31u3UvLzXL300xbn9MSDzpGocVQRaCdMn/TvMi3Kjpt6N6kV5/Qhf8Bu23Hi6L13J/ROeNB/ugJIHN2DjuVHYUl9LIZYixncLsvA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213bc6a6-af46-41d5-19a2-08dcfef84d66
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 06:49:18.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXK1qOJfB45gqDe5oNCwlIfvZdC/N2j3HouJPLDY0zUMQDHNK/CIB3KikLW3qUzw11it9GfwwCShB19Kc3hG5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_20,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070051
X-Proofpoint-GUID: uYh6TIVNu0p5CFElBdrkt5qsiFXU9-oI
X-Proofpoint-ORIG-GUID: uYh6TIVNu0p5CFElBdrkt5qsiFXU9-oI

On 31/10/2024 09:59, John Garry wrote:

Hi Jens,

Could you kindly consider picking up this series via the block tree?

Please note that the raid 0/1/10 atomic write support in 
https://lore.kernel.org/linux-block/20241101144616.497602-1-john.g.garry@oracle.com/ 
depends on this series, so maybe you would also be willing to pick that 
one up (when it's fully reviewed). Or create a branch with all the block 
changes, like which was done for the atomic writes XFS support.

Thanks very much,
John

> bio_split() error handling could be improved as follows:
> - Instead of returning NULL for an error - which is vague - return a
>    PTR_ERR, which may hint what went wrong.
> - Remove BUG_ON() calls - which are generally not preferred - and instead
>    WARN and pass an error code back to the caller. Many callers of
>    bio_split() don't check the return code. As such, for an error we would
>    be getting a crash still from an invalid pointer dereference.
> 
> Most bio_split() callers don't check the return value. However, it could
> be argued the bio_split() calls should not fail. So far I have just
> fixed up the md RAID code to handle these errors, as that is my interest
> now.
> 
> The motivator for this series was initial md RAID atomic write support in
> https://lore.kernel.org/linux-block/20241030094912.3960234-1-john.g.garry@oracle.com/T/#m5859ee900de8e6554d5bb027c0558f0147c32df8
> 
> There I wanted to ensure that we don't split an atomic write bio, and it
> made more sense to handle this in bio_split() (instead of the bio_split()
> caller).
> 
> Based on 133008e84b99 (block/for-6.13/block) blk-integrity: remove
> seed for user mapped buffers
> 
> Changes since v2:
> - Drop "block: Use BLK_STS_OK in bio_init()" change (Christoph)
> - Use proper rdev indexing in raid10_write_request() (Kuai)
> - Decrement rdev nr_pending in raid1 read error path (Kuai)
> - Add RB tags from Christoph, Johannes, and Kuai (thanks!)
> 
> Changes since RFC:
> - proper handling to end the raid bio in all cases, and also pass back
>    proper error code (Kuai)
> - Add WARN_ON_ERROR in bio_split() (Johannes, Christoph)
> - Add small patch to use BLK_STS_OK in bio_init()
> - Change bio_submit_split() error path (Christoph)
> 
> John Garry (6):
>    block: Rework bio_split() return value
>    block: Error an attempt to split an atomic write in bio_split()
>    block: Handle bio_split() errors in bio_submit_split()
>    md/raid0: Handle bio_split() errors
>    md/raid1: Handle bio_split() errors
>    md/raid10: Handle bio_split() errors
> 
>   block/bio.c                 | 14 +++++++----
>   block/blk-crypto-fallback.c |  2 +-
>   block/blk-merge.c           | 15 ++++++++----
>   drivers/md/raid0.c          | 12 ++++++++++
>   drivers/md/raid1.c          | 33 ++++++++++++++++++++++++--
>   drivers/md/raid10.c         | 47 ++++++++++++++++++++++++++++++++++++-
>   6 files changed, 110 insertions(+), 13 deletions(-)
> 

