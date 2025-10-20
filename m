Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04BB2F658A;
	Mon, 20 Oct 2025 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968424; cv=fail; b=BL/eRH1F/zVdsXHzai8XdHDGDB9t41UVHkABPpLCJ2dtQkTfWBERCO+T8D7MQzuikO3XlFRzQPwWDDhKer2FwZnTjXVH/+ReC0AEU5aCg3P1w1c+1H884wv5rD7lJ2u1eSCPnXkHgdJ+Ac0SI0xWC5ilcspgCciL7O7jJ9ToT94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968424; c=relaxed/simple;
	bh=OnIhU2q8rQ2V//TPXiNSjJ6VkP+Mecd6dKubYBMpq/A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j8DrhpISV+PJOiOvHeG5zb8BKSSw0+lY/Xmz0FESMXc1DYw7kyVGS/rcvWSXm7yxZEXhoy/RHgIro5yy2r7IkdFsseDnZ+m2UKTy8tP1jE1y5KTEeLETRh65y5JydyMdvKdql7nFHWFN3/IrzarVKYwcmfF9F1tkLw/FMJw6+2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BMiDe/ro; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qGZfDpql; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BMiDe/ro";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qGZfDpql"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8RmoN025511;
	Mon, 20 Oct 2025 13:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E//mRIK7QTBMWR9pmiB9G/b9TaDBQxKQ7h+hZ7n5Fk0=; b=
	BMiDe/roOrHSKkith4JnZmhEyJi1+OBeIJGZGQJdXwH570BmRjXRlo8QkWWmEmHq
	TP5EeLFgpZdFCvq0aCQ5lV/P8nAGUIGGtk3nl+2/CD4VJ9/SPfJmB8Vrx0Lmmj0g
	2ob6JBfuWYqfbX46f2x8idByO4LxqWoU3B6ZMh4ayAA81fXQFqyVjsspQjr06OdT
	37jMxwkCFiPRGuyGmeLzNjUIXscXGB41HFxZUR0PssDmnU5DFnNZuZwtu73JuLpK
	fCDyBEX4sO/PtZh/aEd7XpW0qMHhmjJUTRdGv0Vb2WoAshlm838Fuy2xhDLMBULM
	6X6PztdoyTEH6Gd1gGhiIA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3esj9nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:48:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KBDvSo025420;
	Mon, 20 Oct 2025 13:48:29 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1baq84s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:48:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9ju2wpwlc4DPJejYJd067J6A3Ghu2EuCOAle1W9E+vz4hu2Qgd9YLN7YbstzbXL61hcOrZGhhDqGRsPpzUrCjtFszaEJgtTfikpqZYqOqubFXU9eTChB45MlYEh9sPVFzx82I599qgBj09sx0gPlCBot0Jnq+EOjZUiejnXf7FcH5dFl1vbuKtjJjSkEiAKI16mjO8uED4WdqG6xcacjT3+uoaNTR8Sv+Je9E8egA5WH63ir0FzhjBsc3gGgFpGD/IxcY4uukyw1B0eX8POnBgiL/Y6CRl7+PeJaZHUspWSBzYTghNi2ICopXcm5ROpbwH7kftfTKcbhfIFnU+XFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E//mRIK7QTBMWR9pmiB9G/b9TaDBQxKQ7h+hZ7n5Fk0=;
 b=fQ6twbmucapygesQLJp4XR+5PcU2hED+q5TuhsboNpEt2NJf3C/tepDI1vbzgs2P7+/0K9Pd/ye12rtJSSYMbwOoIL61EFWQjekSeB2SFgawmgyQUfFGs1doxPn/8Lc9VGH51mMXzgpai3IXnwI2L7Yi24R4CLcVRL1TSevoTTdgic0JztJ3lXsLlK9kLWrlt0gpRty1zVtpOrvdfDtvo/XN/7jkpKZLHy9vzHCbk0J/Q3kykroWZ/QYbplTnQ1kYDgV30r/HhAKFLVonbNQFNqEn5OZVeyFL4EgMk30a4KxJczjMlhy5j9R8BqBB+miVmdSRo4W5kBFcG8Bxbswpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E//mRIK7QTBMWR9pmiB9G/b9TaDBQxKQ7h+hZ7n5Fk0=;
 b=qGZfDpqlUwTJbkP2L/ZaPu0tAQvt1HpVOjKwKu3BzrRmRQvzHMt4EcMz9DK3hEZQnQ+SRsHopYDsgOFV9rIUpD/uh9YzgcH/tF0MvUCYsoEn+zshyljGUkipj3Qgk61+BwRPVeMhnEAMtTIlEf+5AIct/lA91oAJ0FloiOtnsMU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CY8PR10MB7368.namprd10.prod.outlook.com (2603:10b6:930:7f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 13:48:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 13:48:07 +0000
Message-ID: <c26f4b7f-f311-4cea-88b7-d1d6905c2c06@oracle.com>
Date: Mon, 20 Oct 2025 14:48:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250903161052.3326176-1-john.g.garry@oracle.com>
 <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
 <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com>
 <84bbff83-b5db-6789-a668-61cc5cb7c761@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <84bbff83-b5db-6789-a668-61cc5cb7c761@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0567.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CY8PR10MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 83142ead-b368-4f50-3eb5-08de0fdf4c9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHM5V0N3SzhoNERmNlhwanlhS3VDY3dqR0c0Zk96QllxQVpDdS9ZQVNQR0kr?=
 =?utf-8?B?bXVjR0J4M3NBeG9nUkNPM2xacFk2Vy9ISG9RdlJVUElNWW1vcS9icUlTeVlB?=
 =?utf-8?B?NGt1ZWNCL3ROWUFLUEhMVTJoYzdrMlUwYkMrbzRseVBXVVBqeHJ0enZQcm8v?=
 =?utf-8?B?L0VXNGhvdGhUeDVHMXdPMjZlTXZOS25LSEFkZWRvZGpHemNhell1b1JjUVlt?=
 =?utf-8?B?NXpRb1hCV0pva2wzdnplejFub211T0xNSVM1K241WVp5QWZYMXgxTkFJcXdv?=
 =?utf-8?B?N1lOTTBPcWdFTnQ0ZkVoWi9ZTFdseWhiU2VlVW43UEs5aEFKc1FHSVcvb0ZH?=
 =?utf-8?B?ajUwSUJibjVBKzhwVjhsNEwyUnp4THc5WkkvNGJIMld0NUlBVzAwMUYrSS9U?=
 =?utf-8?B?bGJ4WlZMUVI1K09PWCt1WDNFWjU2aXlPYnJFblVMaDczeWEvenRtRjlLa0xy?=
 =?utf-8?B?UkVTT3RWb2cvdzkxV3hwWmZ1T09KMnFxTTF5VGp1dFJBcHd4VzYrcTBuYVhF?=
 =?utf-8?B?UUkza1RVSDJpclgvUGZTMjRkV25nVWhlWGhnMW5oRDNNTVI5TVlQK3VtMlhJ?=
 =?utf-8?B?NUo5eklNRmpQS3VPY21UN1VkTDl1dGgyakIybk84Vi9Lc3lMRVlBYUZMbnRz?=
 =?utf-8?B?WEN1Vm5vMmFqN1RPNEN5K05EclEyQmJVMndSU1hZSmFFaElFNy9BM05VMERJ?=
 =?utf-8?B?aFgvUDF1N3NsOUVma1U5VnhoVmpEMjkvOHkxYkI1cVJQWmI5YTFRVzBWR1N1?=
 =?utf-8?B?YUdDdU9lcGdlb01zeFRvd09UZ002b1M1RTd3WTRUREZlMUo2enlXNDVsR1pn?=
 =?utf-8?B?eFdjVkVFa3ZQRjNVc3FDTmVKY3dpMG9CbEx5K2ZzbEw0eE9yeXRwY2RWZFhH?=
 =?utf-8?B?K0xrZ3llYm9CWkJsZ3pTMS9ZL2lhWWNCMGRvSWlZUmIzWExhNmUyL1l1dUF2?=
 =?utf-8?B?SWxQZnhFVFowRVpkVGNNZktOb3N0TlZXRXhzamlEcXdScHR6MCsrQXR1ZFdz?=
 =?utf-8?B?ZDgzQ1JxMWl3OERoNnRPTk0wOXR3b2F1TmluaUFxQlZUNjdIVHhTN3ZkdVZL?=
 =?utf-8?B?Y3hydVlndHJzaDE1QkNOOG1PeDJzK1IzYzBQelozcjhKTS9DSXRBbFRKYTBn?=
 =?utf-8?B?YjVoUjBzK01pRFhvN0swM21QWmNoRk1BckxkQTR3eWsxd0orUXFsdTNIV0FH?=
 =?utf-8?B?WXc5TXdqMG9RcTY2Nm1Ld1ZpdTRoeG1TQTZURnRHalZFQ3EvaVRwa1V3b0Rn?=
 =?utf-8?B?N2k5bnREaklSZWNrWEVORnBlc3RvWFVPTUo2OFBsTjlURXZCRFY4ajNLWTlW?=
 =?utf-8?B?bjNEUGdXa2RSM2RMeWxsU2tRemtTc2c0SUVOTlp3QnV0L2hQRlExbkRENkNY?=
 =?utf-8?B?NmVTV1JLcmcxNkhBNkRhbkdyQ3pUOVpMWkp2a245eDJSL0J1cFBOUkxQR1dU?=
 =?utf-8?B?RThlc3VUVFhQUlZSa3RtcUY1YjdMZFZJNytrank1RE9RVGZVNDJkbUJkMG1r?=
 =?utf-8?B?dWFKb0pOYmdmaGtyd2tNOTBFT3FOaHkxdnRsdVpwRmxCYUFFMUU4TVRjOGIz?=
 =?utf-8?B?OGtieUhNYzBwR0YzdGJWVTk0LzA0cXpsZ3ZEMGZSMWE5KzRjdEVvdDhlWE0x?=
 =?utf-8?B?VFcxMXc0WnNadW1jRDJaY2RqZkRLVWpwTzNIcGNTeHN1OEV3M3ZSN0xIeDd1?=
 =?utf-8?B?Z252ZmtNN01iZkJ4K252VzFsWkQrTCtzR0dnZWdQc2IvUzdYb2VBNmNYVkRT?=
 =?utf-8?B?ZDF2cFRSb3lsUkgyYlUvaFg5RWVZdmdCMmxlV2tMV0FlYlJtMWh5WHFYTEpS?=
 =?utf-8?B?V0NNUEFkem9LemlFeUZsWHZRNG5nL0dSWnFBemdubWN2TXhyajBDeHRqNzc2?=
 =?utf-8?B?amptQlVVNEMrcmxjUnF3UlhPUS9ONUVZcGUvanNQT1ovdUtXdXdsNlNVdlYx?=
 =?utf-8?B?NmlUbzl6YVI2bG96L2J6bVZraExiQW1LaEd5dUgxS3g2ZUtlT2NUVlI3WXQv?=
 =?utf-8?B?NDc0VVQ5dDN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VStBZjkzdkplbG1qSjdDYTN4MG1qVEpvMkZYZDJTWklUVnhyREdpK0dzcG5m?=
 =?utf-8?B?S1EzOUo4QTJqK01oNTRldTN2NmsyMFJtVGZGVDV2YzhKZERTNTRLVTJYMWlB?=
 =?utf-8?B?dDFmTlZkc09qY1NGM2ZRbmdmLzZxUWVWbjdVQWUxbWJJOWNrRDNFbUR2aDgr?=
 =?utf-8?B?QUxZNWx3K3RnOWpwcWV1ZkxzM3U2TUhuRE5YajduRHdQQkVWRUdKSjJGeVJJ?=
 =?utf-8?B?WGRIRjhDZzNkV0RoWlN1ZjN1QXM1M3VCdUxHam5jcWE2VTZmRTBtemZZMmti?=
 =?utf-8?B?YkJhbldZUE1PQ0pTVjVXRWhkL2xTTjdjLzBFaGg5RGpMODJyaTRDdTk5cjcx?=
 =?utf-8?B?UkhtRGptNTlYMmlmYkt6bTAvZHVBNFVtVWJaeFNINEFFcEtvbmgvbExWVWEz?=
 =?utf-8?B?ckVyU1MrYWZqRkd5Y2VIbmRMNTR2eUNXSHJWeUgvVUt4TmJaenR3OVpUcjFK?=
 =?utf-8?B?am1ZNjVXeGtlcDZqNjQzeHhKSnlTdjZlRVp1RDZRblNudC9FUzhIWkhiRklZ?=
 =?utf-8?B?ZU5IQ21EYzFGVDI3a2dmbk94dy83V3BjbW5zbW9uVTNlYmw1ZUpvVk9zMVVB?=
 =?utf-8?B?M05RSkZzcUUxb3JrUHdudVRFU2RVa0kzVDBldlpBZ1FER3htZ2tGNzF2TWIy?=
 =?utf-8?B?T3hxMTRQcE5LY0t2bVNJeVhUUURZbnNGajBZSERjTHp4N0swdUFQeUVQMXdW?=
 =?utf-8?B?TnFKWCtlRk9iR1VnODNNY0NEdG1lSEFKc0p3aHFyYm1kejBtNEpiZ0YyK082?=
 =?utf-8?B?ZCtNNXIvTTk3V3dIVnhKVVpBVUJTMzErU1FscmhaWlhxRTRIbW5tUFJUbWFs?=
 =?utf-8?B?d2xyd2E2SksyVGtFT3Y5M2VlbTV5RG43N2xpanBYUzhDenAvSVhxamtDUElj?=
 =?utf-8?B?bHFxOHkxOFE1MmUxeFA4N01wQzJJUkpuY0JIQm15VmVCWVd1OVZtWFVCa2tr?=
 =?utf-8?B?cEdudG1uYTBwRjRpdWxQM3A3NGVONHRJUEx4SG9aZ3BVcWxsK2I1endncDVL?=
 =?utf-8?B?ZmhMQkVKYU1CUTdENFRwb3dtNVJwRm1TY1NLbmo0cnJXYW91dHp4dEc4bU5v?=
 =?utf-8?B?eE1kYnpQazEzZU1GYWtieENaT0ZtdERublRia2xOVXd2YTlFNktaejZKeStl?=
 =?utf-8?B?QkhxWSs2bkUveTdFZ0pIWjh4MzF0aHJMbGxUUHRsWm42WUdkM0hrV3FQNDdq?=
 =?utf-8?B?czlwcXk2UDNteFNiVEFwcWFpbWhmbDZMaURIeS93eEsxZzhTeTM5OURWZDVL?=
 =?utf-8?B?YjZWQ3haOWRjZjNad0tVVTBKVFhZU2hWajJQVUM2dEpTRDVDTlNXcDQxamdD?=
 =?utf-8?B?Ny9oVW9TaFFyU25kemY0cFBZSmJ3MC9sdzZIekZjR0l1SDVwQW4zcXdoN0R4?=
 =?utf-8?B?Zjh1K3plcTkvRHpLMmdybmpObnRVYUV0R0p4NFdVS2RBeXBRSVh2TVk4d3ZK?=
 =?utf-8?B?ZnFIUnBPUkg5TFZhTXRYRFNGUmwrbytJOTQxYk5jdUpLN3gwZXlubFVnN0Fu?=
 =?utf-8?B?NlozQllDOFEzdk1OVGZWUjQ3RzI5QS9uTXNCOGJ3aUpFS2VMR1VvdnB3YzUz?=
 =?utf-8?B?ek42TzZVN1p4YzFLQllraVZxalQ2VkcyUlZVdHRnOTludzUzc0l0eENVTjVJ?=
 =?utf-8?B?dFhseHNJU2YwaExsWGl6NENKc0tBaENEOGhBY1plVTRTUWVSZU8wT250USt0?=
 =?utf-8?B?TExKVHZPK0xrMENXRFFMd0tHelBsU0t4YSszajdDRE8rSW1mbW1RZGs2eHlx?=
 =?utf-8?B?bjRCaS85QTBzcXExOG02blp1cmZuek5XcXY3K2t3WnlqSmcvdzJqVWVXSjBn?=
 =?utf-8?B?MGFwNUI0aWZ4ODZzQmdSeElHL2R4Tk9LbUd3aFYwbHdSTmRxT3ROWTBzWld5?=
 =?utf-8?B?ek5Ja3Uxc3JGNGZ1TTcvTjRzNGNTSW5GcDFrQ3IvTkR5dmE3c0ZmbHR3d3dZ?=
 =?utf-8?B?dC9QYjQwbkdTNTZ4QnNEbUtDRVdGTk9ENXJZdlBCTUpCWWQvR3pGZVVjL3Nl?=
 =?utf-8?B?bWtYRk53OGI5dzJ0bXhjcG43OXd3cG9nc2hkN21SVURqeXJ2R2tOVDVkYnFC?=
 =?utf-8?B?SDd2NUdzK1BZcUhQaHV1RnJtTk0yblNWNnJiNU1sVGY3bEFHYTFEZ1l2ME1R?=
 =?utf-8?B?WFBqWSsyczNvb3lOelhwMnd1S2FpTElXK0FqSVlxVlpCWDFIQVREZlBxbkZ4?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W4+nv3J+VNelte+ru4ySNKca63GbMtznsROM1yKFcHSaJjrKZfxZBqt/IravGmuKP3xYQ8hq1uJ4D++PZXhqjAu0/r8XkP+tdSvsFBBzWTpFOdjQbcGQWMJhR1FEBZdvJ47e2be303ESA3DKVJrm6Sm6lCRkK873DR772B7HYH5+hMpyFAeZLUiXHAtowVXLZenSKVjWq//0F3Xxr/Ka11vQQVgqk0z16UpTorp+g6x/qYZPRvCP6WxdxkULTJ8lRzFde3ogskDxENC6R1lPZjniKslTAIXPNOLgLChn36GUDwPFan3SE1NxZNPcFCnN53tm0Mnn9BwkCy3/hlcwwjBmNXk9+nnmGHKMTXY6kQdedMKCrQrhkXdvkIrFUdf/MLVkRhP26eGeF03Xj/rTEV7WUVw2iZ0207k09NGkj2a7dnjK7zgd/gukBCTeLeGuu2/LHqZLUnLiBPl8IlK5KTJsyZq/W7xqpz0TIr8pVb0Mgkp0dFBA0y4JJb5xNSYc7zcSYyT07zAxHH6+SgNYfk3yOmSX8fuAbvzhyO1vPvGTwNfzZ0a42R/BmNXDlavIsB7hh77mH1i9AjY3fiH9pqC2QXcLksHh8fOdhhpj1Co=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83142ead-b368-4f50-3eb5-08de0fdf4c9b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:48:07.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7bwemvNzpu2JglDS6y3rLnO7MCGX7m+IaulNJ/gEXot1uvw1Vzm8nqSOfUzFTZRWwr6NA/9cjMUiLXV9F2afQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200115
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f63dae cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=46jvOt3-I8sen4Adzm8A:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: EgSLQS_rI_Cz4SdCWDmjaBLPbr6UMzDX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfX+GWNzTe+U09i
 pqDth5/yxpm0o4Phy1t3kTIScQphUAFh7Uz6M+sdgK/SpIY2/JgkLdf+0qR06GD5550fdHwKZo0
 90I9bCVlHiGroduJUsMx1LD9K52CRWYAqYu2xKaSY7k0p6dFm2AdlWAoAvPiawHzf5plT6NTRGB
 O/HuZR+TQmj8uaSQfIXn8vrEnHqvKOb8z3/xxJ/9OSqbhnkInUnD5KMhaaRWftefAElfiBNiW0P
 DgMnxAhT8N9Y44HcSveHeGyR9bflp5x/LgjbkdxUwjp1EsQB+jgP172rfyVXLV9Dek/2gGZslcT
 UsqbKRa8ZVCbD8mQp3SLQ4B49sAZ7m7XIK+OOj2Fa78on8QjATb09AZ0vLqwBEfnRko28r9UlIH
 TNzfBpX9d8McOOw3lsFYIe6XNF9Mow==
X-Proofpoint-GUID: EgSLQS_rI_Cz4SdCWDmjaBLPbr6UMzDX

On 23/09/2025 10:10, Yu Kuai wrote:
>> Could I have this picked up now? Maybe it was missed.
>>
> Already picked last weekend, sorry that I forgot to reply.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git/ 
> commit/?h=md-6.18&id=b481e72d24feac15017b579232370aa4b33d4129

This does not look like to being it into v6.18-rc - was it missed?

Thanks,
John
