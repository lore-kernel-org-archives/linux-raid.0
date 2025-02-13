Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C33B8489
	for <linux-raid@vger.kernel.org>; Thu, 13 Feb 2025 06:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739428747; cv=fail; b=UFi8fI7MiRBX18zN2UEAqFfpwvVmcpaIR25wIiKEeJ2gWgV1g81ZQlurHPNvFvWkZSP57IPSpuGek98MTnZjpFjBMBHCO0VcziLXBwBtMe+bErhf4yOHF9z160s8AdQ1JJIwTP0qYzwVVvjugNrLH+fBeFn7/iNEP6JKXsAGWJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739428747; c=relaxed/simple;
	bh=1lS0D/E4VS9AI9/Re7gOMHiJQN7B8d9PfdQSTJWWWbc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AaEBlT06xFm9L3AfmRdXumCbHBNh2TEl8GTb1Hrx/06BXTNG0bCoWoO1CMDWrk0VANQjh7xuXSEfuJi3vpV3gdtABiXRLjK0XMOE4YtTwf2RDA56Ipsa//xZrEJSXyeU3eIvavk7Wpr9EJyFwovkewQFQdspiPTLiUUNiHwxjTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QHMhbPi8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kab9xXXA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QHMhbPi8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kab9xXXA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pfmb006546;
	Thu, 13 Feb 2025 06:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ne32y1VXOhYdK10pKird/VX+gNtCrWPa31GdRq7iII4=; b=
	QHMhbPi8pTTvvpSPrDKG9XpfaqJ10rNUFcbrr8F3hIA+Rb2zLLra8UwI3iERlt9r
	oem7u2Kptt7Hs6U6nB4Zs4PNY8k+v9LHsTbmTf/CyJNd3/y7lKK4w3bA7RYFWSzy
	5GYIP61coAEX5SfdUmB+GV+DYZrswND+0FZICdpNZ10eVw93cyiU4tVIA8AejM+m
	iL6oBoK47tbxhKTR5oHUbzsQAaf1QTk+Sc155IImGae3m1EhgDIuSa5uorWIlaj6
	JcZd6RSkCVGnszqiJrcZVBO9S3CFwyiN95eJDMOJoJSVEi0+ykgfO3w69S+CKyb8
	HzegcJ93XGr6lHPbVmNfvw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq9491-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 06:38:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D6GfC7002619;
	Thu, 13 Feb 2025 06:38:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqbb8ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 06:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIy3dh4XbEEKUcjoTKnfB4HSeKgfinKSlI+Wo+99I3hU3ej9K7WB8eUifpaAaVGEfdu52eNA1E67d7ObQgTrOagW8d/ndbk0vct13W5SKyy83RWJMG38A9o25zrPmzytSiMzc/akatu9mlt4+BillDKyfmJMQyvfoAb9FwHbbGK2Ny15LX9goDlZm6n42ygKBGFZp9tmn5GIo7Z+3896MeVxgg71euEHt76tfNu6AoJw0nNNDZaqC453P2UqqVYcouCCIh5kAugeElutPkJwdLXQ1LZQaJgtCWb+hSLJrShHyRkHOEzoz75+G33GqGCfgSs6dho9q6IuNts86AFFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ne32y1VXOhYdK10pKird/VX+gNtCrWPa31GdRq7iII4=;
 b=KvsSDWGP6MYXE0ox5XRK5XtWnfN7lkgShVgivTY/pnv8iCuUI3/nDc6IvIo9/TjYoQDmVteOgiMdu1jC4z+eiZzPxWdfWmNUnVjzSMw7+LljagoG5ne/B+9FcijdjGhxFuyqJ+Q1FdG+5HTfmm4+2Hq4bEIOcPYv7hzgFXyV7ZE+pwWJUDWn4M0bTv0Ohb0wyrNKwaXdJXeG0bTw92P4dpFPkVGqDXZbdiQZo5vmrOkGq2B188CrLChMejFLA2u5wD2BTt5c+ydQ3eH9Vt7Lll2ktf6q9J6TMovfr2Ja7CNl/J/n4/qiMQdalrWkkNZjEYvJeFLWoD1Li+aw0K7giA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ne32y1VXOhYdK10pKird/VX+gNtCrWPa31GdRq7iII4=;
 b=Kab9xXXAKwQzmNzu9OOg5TYtAR01p4zf5kW1ANIzthuB1JEjYKaH3GOX2F6ADj1Y1ZYsN/X4gT6X+qxF8mdppw/07q6TSwnTJfFZEQ3cFJ7MIQ03PDbK4K0EBcSRGA3oQ2PLbtKeOF9iCHU48TOobI2H9WHjYqehan04ydAn+uI=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by BLAPR10MB4932.namprd10.prod.outlook.com (2603:10b6:208:325::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 13 Feb
 2025 06:38:17 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127%4]) with mapi id 15.20.8445.008; Thu, 13 Feb 2025
 06:38:17 +0000
Message-ID: <6d5c8902-ec3b-4d2e-baed-c926ad99cd8d@oracle.com>
Date: Wed, 12 Feb 2025 22:38:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
To: Blazej Kucman <blazej.kucman@linux.intel.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org,
        xni@redhat.com, yukuai@kernel.org
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
 <20250212110713.1f112947@mtkaczyk-private-dev>
 <20250212225016.000060d9@linux.intel.com>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <20250212225016.000060d9@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:408:f5::29) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|BLAPR10MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: e5633be5-71cb-4c46-2ef1-08dd4bf8ff37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VU9Wd2xXUGIvV2Vsb3g3TWMxR25Nbmc0czhuZS9KNGVsRlEvQ3FvM2tKY2ZR?=
 =?utf-8?B?djY0Mnk1Q2ZkbzhJQ0lSZUN4WkRzVEFDWXh0TTBWYnRVY0VCQlJEZ0pQM2F5?=
 =?utf-8?B?Sm9wVUxOQlV4RFc4c2paOTZXaTgzbzBiaTRQZW9leW00R3BJSEZ1bTZYRW5O?=
 =?utf-8?B?cFN0MjhkZ20vWUQvbDdBdmNKdUIzTitIUXkvZkpseDRaL3M0bzczcVlpd2Ur?=
 =?utf-8?B?TE5CUmZjRTY4VHZIclVsZTAwRUIvSmRWTDBwSGFQWlM4enFaVVp6RVVCREdv?=
 =?utf-8?B?ajdpSGluOEI3azlHWUJwaDlWQTZSaXBJa3BVdU1jeHk1SDUza0k2QjJaK3RS?=
 =?utf-8?B?UDhsdUg2elNFdE0vWXJ2S2FVMm41OThKdk1VY09aTkQ0b1l6UVBBdjVkdVRE?=
 =?utf-8?B?bmJDWFpXeUdxVlh1RVNSejRjTHQrNnFFR0wwZm5IQkpaNG1rYzduOWpId1Rj?=
 =?utf-8?B?WEhBV0V1cGtEQW1WWjNIN1hra1NyMFYzMjY5UzlEVi9Lck13Zjc3N1A4VjU4?=
 =?utf-8?B?NU1aNTk5SnJGeHhtN2R6UnpIMUNBcEVPUGxiSzZGc0h2V0NsZ3AxVWlEV1B2?=
 =?utf-8?B?Vks2a2czNE82a2NscHBreG53NTZYSmJKdVhGVDQwRXhGVThkSFRVTStiY1pr?=
 =?utf-8?B?UG9SNnJ6K2dtNnVFbjF5ZVpnc3VhdmhKRWJTc0c4SnpRWGtoYWxKbWRzVDc5?=
 =?utf-8?B?b05xVVdvY0wvWjBQWUNNT3FLN1RpUVNoMnRqWUxrb3g5MmxkQkNZRGI4NTZB?=
 =?utf-8?B?NEhqUVVuZE94b2JxbjF2eFYvTEx2bDNYYzhrb3NaY0pWVnJTSFJrOFYxdzNP?=
 =?utf-8?B?ZEZEUndhM2E0bFpxU0ZHc1RTTmxlaEtzNkVTUXZTTFg1SWxmQnE5ell0elpE?=
 =?utf-8?B?RW9DOHRuL2VqZndTRW03ZEhRMjdGeGc5MzQxR1FZcDVlanlKa1p1Wkt5ODhX?=
 =?utf-8?B?SGtRc0U3Q3U1RDRIdjVqRjM5eDlQQWoyVTdTTi9jWGhod1pGTDhCT2liTktn?=
 =?utf-8?B?VlVENnNWNFhHUGdiVHozVDQ3eDQ5QTUwWDNCaE9YcXd2UTNUV2dTRWxodkFl?=
 =?utf-8?B?dm00MlNpbTBKbEN1SCtsWTJzVTVaemJxZUdkOVJKZ1E0WnQ1OEVWR1NSMjds?=
 =?utf-8?B?UGhtMDY0ak1mcWpJc055TlFVaDdxc3g3UndidTRCQkNicHFUcmp4bDJIVnZv?=
 =?utf-8?B?QmI4UFVBVWlRblA0ME1jeUU1dUN4aXlqS2MvMlpMcTVYK1J5c1IwbG9lUklS?=
 =?utf-8?B?TG41YjlzaG4vY3NKS3FKNWhxWHVWMGRWSWZhZ0d1c3pzZkEzQmx2bHd4ZmU2?=
 =?utf-8?B?QVBJdUczOUlxczkrTEVkeHhsS245MDk3NXRld1VGQXZPNnFIZ3dMNTB1cE85?=
 =?utf-8?B?NFFRdEJaQVQ0d3dmS3JGaXhLeTcwU1I2T1ROaklnSThWVkZ5RnIvcGxjMTdm?=
 =?utf-8?B?WVRtRGtGVUY0UHd2Y09nOUhNS2t0RkM2TUw2ZVRra2xtZFNHRkl6dVBsN2pV?=
 =?utf-8?B?b3FEMWs4MVcwcnZLLytkS3F0NFJ2dUVnSkhXYllPL3RtWTdOeEpZdUZJSVBi?=
 =?utf-8?B?R2VYZUxVK0hJQ3RxK3duSVcwQlJUVHlybE9nd0Q2VUJkS09zTExVMmxIeXR3?=
 =?utf-8?B?a2cyK0dPTVZWSzMwWGxUc1lEUTRwblZmbVhZWndDWjFDLzN1NnQvdWhuZE1F?=
 =?utf-8?B?ZlVFaDJ5S2d0eVlnbzM2Rko5WGpPQlA2VEpXY05CWlRacWVsZlNyeVU3Z2dX?=
 =?utf-8?B?TjRUMjIrcUV4TXpWSm5weVFWckFpSXRwZ2VWOU9XcWlhd0IzODBwcWdIcmJx?=
 =?utf-8?B?NC9XL1FyN29JY3hWMmw1ckVGemQvSE5Ia21sM3JuV3ByRy9xUWI2T0krYTEw?=
 =?utf-8?Q?9mIlmzmziSDjq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2RVREp3T2ZMSGtzUnlKMFE3Y1VFTHZyOUtDY0RCUHVPMTVsS0VSeTRSVlNy?=
 =?utf-8?B?Zk81cGVSVEw1SU5jdmhrU0lsSUVOanZSZ0R4Z2tvWVZZdnJITzJvYlkzVy9t?=
 =?utf-8?B?U0RNRll6VXVIWE5hcTZOZmRickdnU3F1Z2lIZmxMUUMwd1ltSFV3WHh6Zlk4?=
 =?utf-8?B?clBBajVOVVZsR2FNNUE0OFNULzRKQ3p0MEt3c2ZYLzZmSGVTbDFJZ21wSXpM?=
 =?utf-8?B?T080WUlCaUhTdllSMFpGZHVYTFpnVG5RZStBM0lyZ1V0UkVVMGd0MHNVcFl1?=
 =?utf-8?B?alVLeHdseElsTE5xT0c0aVJmcHpOTjJubWozNXR5TG5VZVN2bk9GL0NpTzR1?=
 =?utf-8?B?Y2tMb253Q1RaR1lwbHJPbTAzQ2crd084SVdFUW9xWXVMa24vWXhVVVBwR0pX?=
 =?utf-8?B?YnQva1JQWXQxMEVVVm8reTlyaHBpSkJLWVkyVjVsUCs1bnhMV1V6NnZNM05Z?=
 =?utf-8?B?VDR1VUQyTkkwVGlxcUh2OVBMMDV2aml2WC8wc2hZQytJWE5PVWk5WEhxOVdF?=
 =?utf-8?B?aTB3NmJuMkl4eHhkVUxjb3U2cU84TzRPUFBSenpqMC9rdTdzaUcyQmhpRWgv?=
 =?utf-8?B?SlRXbFQrbUJUT1NkR2dMM2wzaW1hSlEyQXRJd0VCNXlUS3daS0dscnZHTlQ1?=
 =?utf-8?B?NXdBVGpNQ1UvazFHNmJoMXhIZHJZYnA4OEgwdzIzUDVzVXE3eFdydVY2TmdB?=
 =?utf-8?B?TXFQa3B6RVpvSWFmQ2dYVi81bWczWUZKV3dLL1cxMGg5dEJYYTZRSTZiNFlT?=
 =?utf-8?B?SXRpU1JkNlF2QlpOenA0Yk54Q2tLL25Lakp4dGZNbXJ1RThmdm5xQjBObTlm?=
 =?utf-8?B?cWtNVHlaZTVqY2NJdXM1Qm9kV2dYL1VJTWordkZ5UlVIKzc0NUUrV3prNzRn?=
 =?utf-8?B?T0tHSXl1QXRtQW5xN09sZitJdHByWjhEcWgzSmhicVhTR0cwNXFzWEIvQ3VE?=
 =?utf-8?B?Vi84VDM2N3hpRm1BWkUzMUxYNjE4TG9kVERZT3hObmRCcE5veG1KYk1VeFNp?=
 =?utf-8?B?aWpCSkZPaEp3VWQrNkVaQVc0SzgzNjJjRnZ3RVJnRjAzTXZXRWZYSmprK2VF?=
 =?utf-8?B?b3ZjeHF1Wk93OURZcG5qMXpyVTEwc2kwYUlLMjFUVXZLZFplWnFTK3hZMER3?=
 =?utf-8?B?R1RhOG03bGVEYjNyNmZheWlIbnBjZGl0SGZNUnlGWHd0dEtGL095Rll2OFEw?=
 =?utf-8?B?VXpTRTlUd1gwMkp1WFM1eWNBbWJlOWMyRzB2SVNNYnZNbHVnN0ZCaXJxR1Ji?=
 =?utf-8?B?dlR4c2N4NW8rU3JVUUQzODRzRVQxRU4rQnlobFl3anNnOUVLVHhTbzZWZzJL?=
 =?utf-8?B?SkExNDJ3RFJjQTk2bkdaR29oU2FTQllYRmdXcDlsZXBJOEhINVk3NU13TnlV?=
 =?utf-8?B?R3pZNTJJcDVORzhBbG9kbjk2VGVRRURZb0Q3SFFmNzdVYjg1bWV6aFZIVFg3?=
 =?utf-8?B?THh6NTJPMmZzS2RiZVl5Y3A0OCtaYnFtRitiS2dScXNJRHFaSmFEODN1SjB4?=
 =?utf-8?B?SU1COWJKaTFSSmdFSUQ3Q1Ywd05oN25Sd3dLSStlTUUxcXVZQ2dnc1hJZjVN?=
 =?utf-8?B?TVBXbGFGK1YyS2k4SUxuR0lpdkpjaXloek84dDFmQWNGeVJHaGphbysxTWpM?=
 =?utf-8?B?R1c4cUp5QUVPK1I2eUF0TzdOby9QR2ZDeTYwK0JUZWk5UUV5UXI1RlZQNXFF?=
 =?utf-8?B?Y1Racm9COHJqR1g1ZURUNXFaUkw0UDZ4UU5uNWNXUzRrZ2wrNTJabjdWTEh4?=
 =?utf-8?B?aW83U3JrZW0vUFJac0x6ejlmRTNFTUFhd2k3RndDY1ZydW5nbTZySTBHVmls?=
 =?utf-8?B?WEhtVDEyTHBFeGdsY1JPMmxIWml5RDI3VENYMk9NdG52NU5lamYrLzY1SWlr?=
 =?utf-8?B?dENNQTlNeUY1VEU1ZWV2UTRKRjFteXEzZnNBKzFldTU4dHNCb3RQMzI5TVJ1?=
 =?utf-8?B?czh1bllMaEpRWS9EKzVwSkttY2JES01tWldQNWgrK280YjRRZWo1U1piN1JH?=
 =?utf-8?B?UUVPaE9ZOFBYcVEzS0MrdEpBUGQ1Kys2VEY1UnJ6T1hkUjl5d3NtUDdLN09X?=
 =?utf-8?B?L3kxMGs3bVZUVzVNQTFYTkMvWnRWSjRZYW1KdzVYVkNMVnFDVnFmY0RDWkZx?=
 =?utf-8?B?Y05OK1NseFgyV1ZYR2FOR3RsMUxuYlNzdmhKdzNaSWEwU2VNSjJMZ2RMSWJ5?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ySeqF/BCgOAu4AZXLXWUQK0ba+yG0wS/tbOy8VtWwl8qamCTUBPaB6GNhjToG0yRPouG/1TqHliNdb18yFT/v+ixVB0p3Cr/2YFGv0pRxWHg7OPhS3yqOJ05k70EuuciebYjz+DSCUomvkI1Vj6H4oWiICZII/b3MbdObxc2GRUB3ZcPaK8tDLJJjxyYs2Yzx2Szo/2+9zoa2jLBZdTkEDwvRRb21+R1iDbZYbIf1AgdetIskVaFzVOc2s+ncq35KuteFkO7/gyZbIlQ91IxIPIw6DJVrpQU8PAXY0Hm6PBI+nIVoQw/hauNRSoNOTBwuNsMN2MVDgccNJW5/oSpEDBUaTWxgbbZimzzBsMJEBjitzui2Ru16HfbwFDa/DYspcn0sdC/O4cka5SO9pUIa2UHc+K+Cs+d58n/pmngk52qhGb1RS4xtO4EDOcGBjEV1JZWEp+/M+QWZDpDKm8ndzWA4OAWIcZdwRh89KnohybnTxzSuLw6x1YXeR5J3xolhFCuqFOQ/44ve2zAvxfec/cHxE8Ga5qVjFtweyl+KjX8+TQggnP9DlxFUX7PVQ2WBXWecwKAce3JByMng4QQw4yXA/jjsuZb07NG+r+Bhsw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5633be5-71cb-4c46-2ef1-08dd4bf8ff37
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 06:38:17.1513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qF19Chq4bmPtrQEiBvlJUWOHhPekUtJx1obZXOesodVnXJQp6i3APayknGw8Om7vSSkfGdkwgvdDsaSLWsahnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_02,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502130049
X-Proofpoint-ORIG-GUID: u0nXddXz8Ox2HhQjNf9-sO3NFzAsuT5s
X-Proofpoint-GUID: u0nXddXz8Ox2HhQjNf9-sO3NFzAsuT5s

Hi Mariusz & Blazej,

Thanks for the review and file PR.

Please check other comments below.

On 2/12/25 1:51 PM, Blazej Kucman wrote:
> On Wed, 12 Feb 2025 11:07:13 +0100
> Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:
>
>> Hello Junxiao,
>> Thanks for solid and complete explanation!
>>
>> On Mon, 10 Feb 2025 13:22:25 -0800
>> Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>
>>> When manager thread detects new array, it will invoke manage_new().
>>> For imsm array, it will further invoke imsm_open_new(). Since
>>> commit bbab0940fa75("imsm: write bad block log on metadata sync"),
>>> it preallocates bad block log when opening the array, that requires
>>> increasing the mpb buffer size.
>>> To do that, imsm_open_new() invokes imsm_update_metadata_locally(),
>>> which first uses imsm_prepare_update() to allocate a larger mpb
>>> buffer and store it at "mpb->next_buf", and then invoke
>>> imsm_process_update() to copy the content from current mpb buffer
>>> "mpb->buf" to "mpb->next_buf", and then free the current mpb buffer
>>> and set the new buffer as current.
>>>
>>> There is a small race window, when monitor thread is syncing
>>> metadata, it grabs current buffer pointer in
>>> imsm_sync_metadata()->write_super_imsm(), but before flushing the
>>> buffer to disk, manager thread does above switching buffer which
>>> frees current buffer, then monitor thread will run into
>>> use-after-free issue and could cause on-disk metadata corruption. If
>>> system keeps running, further metadata update could fix the
>>> corruption, because after switching buffer, the new buffer will
>>> contain good metadata, but if panic/power cycle happens while disk
>>> metadata is corrupted, the system will run into bootup failure if
>>> array is used as root, otherwise the array can not be assembled
>>> after boot if not used as root.
>>>
>>> This issue will not happen for imsm array with only one member
>>> array, because the memory array has not be opened yet, monitor
>>> thread will not do any metadata updates.
>>> This can happen for imsm array with at lease two member array, in
>>> the following two scenarios:
>>> 1. Restarting mdmon process with at least two member array
>>> This will happen during system boot up or user restart mdmon after
>>> mdadm upgrade
>>> 2. Adding new member array to exist imsm array with at least one
>>> member array.
>>>
>>> To fix this, delay the switching buffer operation to monitor thread.
>>>
>>> Fixes: bbab0940fa75 ("imsm: write bad block log on metadata sync")
>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>> ---
>>>   managemon.c   |  6 ++++++
>>>   super-intel.c | 14 +++++++++++---
>>>   2 files changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/managemon.c b/managemon.c
>>> index d79813282457..855c85c3da92 100644
>>> --- a/managemon.c
>>> +++ b/managemon.c
>>> @@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent
>>> *mdstat, int i, inst;
>>>   	int failed = 0;
>>>   	char buf[SYSFS_MAX_BUF_SIZE];
>>> +	struct metadata_update *update = NULL;
>> If you are adding something new here, please follow reversed Christmas
>> tree convention.

got it, i will move this new variable to the top of the function in v2. 
Should i move variable "buf" to proper location as well?


>>
>>>   
>>>   	/* check if array is ready to be monitored */
>>>   	if (!mdstat->active || !mdstat->level)
>>> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent
>>> *mdstat, /* if everything checks out tell the metadata handler we
>>> want to
>>>   	 * manage this instance
>>>   	 */
>>> +	container->update_tail = &update;
>>>   	if (!aa_ready(new) || container->ss->open_new(container,
>>> new, inst) < 0) {
>>> +		container->update_tail = NULL;
>>>   		goto error;
>>>   	} else {
>>> +		if (update)
>>> +			queue_metadata_update(update);
>>> +		container->update_tail = NULL;
>>>   		replace_array(container, victim, new);
>>>   		if (failed) {
>>>   			new->check_degraded = 1;
>>> diff --git a/super-intel.c b/super-intel.c
>>> index cab841980830..4988eef191da 100644
>>> --- a/super-intel.c
>>> +++ b/super-intel.c
>>> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
>>> intel_super *super, struct imsm_dev *dev, return failed;
>>>   }
>>>   
>>> +static int imsm_prepare_update(struct supertype *st,
>>> +			       struct metadata_update *update);
>>>   static int imsm_open_new(struct supertype *c, struct active_array
>>> *a, int inst)
>>>   {
>>>   	struct intel_super *super = c->sb;
>>>   	struct imsm_super *mpb = super->anchor;
>>> -	struct imsm_update_prealloc_bb_mem u;
>>> +	struct imsm_update_prealloc_bb_mem *u;
>>> +	struct metadata_update mu;
>>>   
>>>   	if (inst >= mpb->num_raid_devs) {
>>>   		pr_err("subarry index %d, out of range\n", inst);
>>> @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c,
>>> struct active_array *a, dprintf("imsm: open_new %d\n", inst);
>>>   	a->info.container_member = inst;
>>>   
>>> -	u.type = update_prealloc_badblocks_mem;
>>> -	imsm_update_metadata_locally(c, &u, sizeof(u));
>>> +	u = xmalloc(sizeof(*u));
>>> +	u->type = update_prealloc_badblocks_mem;
>>> +	mu.len = sizeof(*u);
>>> +	mu.buf = (char *)u;
>>> +	imsm_prepare_update(c, &mu);
>>> +	if (c->update_tail)
>>> +		append_metadata_update(c, u, sizeof(*u));
>>>   
>>>   	return 0;
>>>   }
>> I don't see issues, so you have my approve but it is Intel owned code
>> and I need Intel to approve.
>> .
>> Blazej, Could you please create Github PR with a patch if Intel is
>> good with the change? I would like to see test results before merge.
> Hi
> I've added a PR on github, I'll review this change by the end of the
> week.
>
> PR: https://github.com/md-raid-utilities/mdadm/pull/152

I see this error reported from PR test, may i know how to access these 
two logs?  This fix is for imsm, and ->open_new for ddf not even touch 
"update_tail", not sure how this could cause ddf test failure.

     /home/vagrant/host/mdadm/tests/10ddf-create-fail-rebuild... 
Execution time (seconds): 46 FAILED - see 
/var/tmp/10ddf-create-fail-rebuild.log and 
/var/tmp/fail10ddf-create-fail-rebuild.log for details
     /home/vagrant/host/mdadm/tests/10ddf-fail-readd... Execution time 
(seconds): 27 FAILED - see /var/tmp/10ddf-fail-readd.log and 
/var/tmp/fail10ddf-fail-readd.log for details

Thanks,

Junxiao.

>
> Thanks,
> Blazej
>
>> Thanks,
>> Mariusz
