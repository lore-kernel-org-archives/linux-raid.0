Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B51CAA61;
	Wed, 22 Jan 2025 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737583132; cv=fail; b=ulMecXZ7dXkSJ/OGU1lux0W34kH8aqN02X3ho3XIO4EVBB/B5ltVypn6WAaz/jIn7LH6J1p/8KhUBYY0H4GPPoMJEHS5MdsF1HuPkPWI//wFdtGVn8SVARbOIHlmZB1QYwz7BGC5iPa2DniO96F0ZXFooZk8vgbZo5sc5uMQhew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737583132; c=relaxed/simple;
	bh=WQBphjxEyE2Dss5iQtJG/E2H+/YbQQCIcBUm8p/jExM=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=tAcdSV4gCbSNXDkRIxu9+tvsK876SoS2CMeIk079xjbc687m5dsgsqr83ghP9OJ/wZZJLJh/fzzMoWDI+B8gt+4dwKwcvPx0A1GjsJGem2M5CHEWGLDiSh8sypUaRlDbDhONO7liHb/Gh5Rz6xY8YTH3FNtKDoA9y/e70wHZw4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I7prlFgy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tkMStah7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7prlFgy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tkMStah7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50MLfdtc026128;
	Wed, 22 Jan 2025 21:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=FMJg4NTNYeKV0B9p
	MJ9nms2+G8i/iCfOjnKBmkDSiiA=; b=I7prlFgyvRGCJRE60zLvvqeDReCXinsm
	8zFetvQ8opgTOAhViYSV79tjQ2cEYx4KKj+g/YgQl27y562gfNFJ9lrsBl7MwYjO
	QUt66eSM+djYwSkgVHV8Tp7XNEYHT6j9gMFOpdFNC6kQgx77a2m5gIhtBsRDj0uX
	m+fU0D26FpQbRxI9RZQT7DeEeIsI2DhTGT0B7V4V9LqZb3I++rNhJGUniyiASmr8
	3AeFVjFyNVrEt4Sv65ltekTQyO94qMCNtNgxMz8rxvCTE/Q7V+RKNdWPwD3IR/zv
	rstIh6NJhIiwlTB++hB9JQW85pxYhb3RZ2LJOcPhtEZ5u5+4lwXz/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485rdgs9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 21:58:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50MK8oxL036433;
	Wed, 22 Jan 2025 21:58:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44917rddgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 21:58:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeOiR1c5VcHSwgvOo63KaiGYZwG/Vk0J3K6AhaSSbelLiOACUZvaVvFRmNmFPvTzZOC1Z0QPChdiUAxHxy15u5LPMpQATS6BSdAm7b4w4YPLs9BGnVbwVvS2E3G1lfSbzvDgnHiIoydWS91+2VLXuHVfdUSsABwgce3ZoQuDRi22o1LM8WQrVRCexoHKJeBwsKt9nIXNavoHfz6hUGQNr17VKQONVaTXmSIdBQ+xLrEooDz6Zxt73wngx3Ecnh2bG9UpCu/7eod6WesNtnPzKM5A9EQVaUQ0gJfBItCzp6NtAXZ/pQ2n0B9dVeDl7xnFRsdf/N5iyZ85APBLOMRt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMJg4NTNYeKV0B9pMJ9nms2+G8i/iCfOjnKBmkDSiiA=;
 b=fR64cj82+M8uT7v3hmTLf3ftovtREa9e+mTATuskMc4yySf4jgDc3lPzoNTG6JrHYuPDn6P8UhPrKwC4nEkXvQGLhG64h9hdin/8auPkyS6O1MZkxnHwFFk8bNvroo+BWC+Ddhg4G/ryS1Vh/maf5gZJZXxMY4HlexOsUy32QE2u98XphnYBDHdywvsXtRGtLdZaDcWxuiL2OzFZ1BUTsOexJp8r8Memc2BhMsA0AeAksF9+MvIb3gcfM/j7A2RzkLTazYulVs6fMD9T8I4JZdn+s48/SSvNnYrRGbZsEUN8szoDSJNfHgmKgDTO5yVGtRzH+T/rOtIWgXctNQTqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMJg4NTNYeKV0B9pMJ9nms2+G8i/iCfOjnKBmkDSiiA=;
 b=tkMStah7j8s/fAO4jodQk/BNUvL6Hkj/BAZuBIqh8FwLOJDJBsI1OywgcaXlu1u1tU5olII1zCHa8qRqvogxVyu44sLTtJ0aD7OES5X+TjCE0JIx5OAq7anw49mVCAaESc6lsYer7fSSF5Ksj5RtnpRKhiCxHddhYSUmf1Ss+jA=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 21:58:15 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 21:58:15 +0000
Message-ID: <ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com>
Date: Thu, 23 Jan 2025 03:28:05 +0530
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [REGRESSION] kernel panic at bitmap_get_stats+0x2b/0xa0 since 6.12
To: yukuai1@huaweicloud.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        song@kernel.org, pmenzel@molgen.mpg.de
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Darren Kenny <darren.kenny@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ddab73a-8a13-467e-ac87-08dd3b2fdec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b04vZ0FIWktneXZFNDV1UDdUZVFLaUFxR0Jkdmlhbmd5M3Znc3hmUU9vVlhN?=
 =?utf-8?B?TnU3MlZZRks3SmQxdXg5aER0Mmt2VWNncVZaM1hMZjNGdlZEc202dGkyWEk3?=
 =?utf-8?B?eE55RjcvRytCWHc4VFNnUXFhUlVuenR0N20yYVh5ejZSajNUd3JTRmt2RHRD?=
 =?utf-8?B?R2dGTkRxam05RUpYcHptZWRkQWJnU2ozaDl3bmtBWmlTa0EwOUlTRXIxYjJK?=
 =?utf-8?B?d0JIOGs1cjE4Q083dklhREtNOS94aFhxeW0ydWZsYjVoTGNydFB6eUxjUXQz?=
 =?utf-8?B?S2x0MS95NkppVGNBWXU0RVdIbGR0VVcza1hQWjlMNXVzS28xaDJLRWNYRnFG?=
 =?utf-8?B?dGZMT1A2Y3ZnZEduZnc4RWRBTTJ4UDVRbmNVTTAyRzExODE0cC9IMEp4NWE2?=
 =?utf-8?B?VjBQYnJDS3ZBUzltbzJYL0dvM2NtdTZqL01CN1YvRG1VRjRqaTN0blBZVGRa?=
 =?utf-8?B?ZkxheFRxVm4wNDFTSVlVMEEzRHlXMk8rWS8wMDZjd3BqOFRkdGh4MTNBK1NI?=
 =?utf-8?B?Y3RsU1p6OVZzZ3N4dUpIMzJMaEhxRTRLaG9UMXg5T2FiU3pxdWxuS25iTkdN?=
 =?utf-8?B?YVNTTmVEWVVZem9seUxxazBFWVhqYXB0d1BnSFZkWkRXSStOZXpRYkgyTjdN?=
 =?utf-8?B?VTR4TEZQR2ZXWUhoT2pVY0FyZGc1UUREQzFYMHp6ZnNuOGpRZEF5TlUybEkw?=
 =?utf-8?B?Nll2djkyR05qV3ZnZTB5ZFdQcUU3MmUwQ2hQd29pWnhwSUYrbG1RWEFQTUg3?=
 =?utf-8?B?aVpSRVVwK2xQU1hzTDVpMkF2UHBua0E2aEtXNUhnRmdMVXVvWUo1S3hjVmlU?=
 =?utf-8?B?WXF1UFBTZGx1WnkzVzVjVXJFMXdIZDY4OTc5MHZXMUZqd3ZTc2NjV1FncnpQ?=
 =?utf-8?B?UUVOTC82MWNuZGhqTHRvYi83OFZDcHY2aWd1Q1M4NWluQzhPYjB0ZU9ibWhQ?=
 =?utf-8?B?LzFpV0dSbCtQREIxTG91c2ZPUkdUd2xqR1NnaEJKM3NhbE1WWTR2c1BWeGZ5?=
 =?utf-8?B?SjZUakd0eUdGRGFiRW5NRkV0VnVJYWwyMTYrYzh6czE1cGZWcXZaT1hFcTNC?=
 =?utf-8?B?UGQrNDI3a3o2czFMZTBlUGdyb2l1U0VPVWQwT1o1dENpdzhPdVpjUiswNUZs?=
 =?utf-8?B?bjZCRVNnd0U3allOdTZHZkFPbTM4RjlNNkNaYW9TODdXY2tBUlo4VG91TnVK?=
 =?utf-8?B?Q2MxV085UGlrNTlCQS80alZMOWlKd1IzODFnWmNHUG1nSTQ4YjdkTVFlUFpQ?=
 =?utf-8?B?M0NqZUxMeDBNSG5YcXhQZlU0anNhZVBrUldQV2s2UFdRMnQydzlZV1ZNZXJO?=
 =?utf-8?B?b3Zpb1hOMi93bkNwVENKeDZHemt4WU1ZTmQ1NEF4SGd4dVpWWTI2QWtlTFFk?=
 =?utf-8?B?Y3k1Y2tWeHYwb2JDcG03RzRzWUE2V0R3Y016WDFjZ1k1N29mbzljdU92NXZh?=
 =?utf-8?B?UkxkL1NHMVprdjlLRXIyaDBOU3Y5cnh6S2dwTitsM3Q5Q1VVeHlHUFAyc3Yr?=
 =?utf-8?B?ZzhmV0hYM09udXJJdURUeUYzZ3F5dkFCQzNHcUNiOFR0ME5uckZ1U1NtS1FV?=
 =?utf-8?B?REQyQkdiRWhhcTlCY3JkcmIrR0NDcWVaNENCL2hCQ0NrUEtmYVk1eTMzK01v?=
 =?utf-8?B?RThzMjZTYmhLcUFjeWVXeXpPYVBYYnZkbExVSExWdFhrVHpJOXFDNHYyMys5?=
 =?utf-8?B?UFdDWld4cktLSk85azJ1YjRCNEJ2WGE3TW1NS2J3RjRIdE5CUE1NcGJuY2lC?=
 =?utf-8?B?Vk9lUysySTB6VXJpRHZmaXFnUm5QQkdOSXlranErakVWNlRsR3g2UlRDb25r?=
 =?utf-8?B?NnpvUDJnd0RMQkkvT2Z4UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2JtNzFpWVVxeEtwNzVMQVNNNFFPWFZrOUtqeTdjOGQ4ZlJvLzNXRS8rc2d1?=
 =?utf-8?B?ei9PVTlTQnlCNGdkYW5zTnJZSzBneFJseEJzL2E4RTBOMkxGK0lGRWhFYkFH?=
 =?utf-8?B?UWZNS0FUMlBTb3g2bDJ3bERtdFh3ZTZROE8wTDdFTng4ZjduNjRudW9QekdS?=
 =?utf-8?B?eFZlSmwzR1hSbUt5NFpyUzBIUjVVdkNINk93TkU3Z0FLTDByd2pyTU5hUUZm?=
 =?utf-8?B?NnYyMkpWRzUxVEhlT29RbEpUTUhjeWRFeUdnYUFQZWVMNFFTbFoxRjFzS1VO?=
 =?utf-8?B?M3duU1FwNGRVYnNvOGJCbzVjTDE0T3BsbHQyUlJmb0QyWlZuNGdVMEovS0NQ?=
 =?utf-8?B?a1g0Q0FqWTNlQ2xuNjVYa21NVkt6NSsxUHZYTWNrQVRVRGpVZlJnQURoQ2VE?=
 =?utf-8?B?TXJDOEM5SzFWaHVYRHpKZW10bzhWeUlETlAvUXU2WEUycnJvUGsrOStlOUtI?=
 =?utf-8?B?RUZFM0NVY2dlL3ZFMUJZRzdGdjRkY3VBMlZQa0ZqUzhPTGVkQXpzZENlUjBw?=
 =?utf-8?B?OWZ6L01QRzZkdzIvQ29uSnllbWdDNDdEa05zVnRaQ0lsNHcvOUppd1NjLzRZ?=
 =?utf-8?B?aGRMZEppSElyUVh6MTRFRkVROUMySzBBTXZqUDh1N2dCNy9qUUx0SkdPN1Vq?=
 =?utf-8?B?U3E0bGNucy9aMVNxNHNuMEFRMzEwdWpKazFrZGJBc3kybmlLNXVORXRlMUh3?=
 =?utf-8?B?UjZCcURVSlNRQ0RmYmQ5b2tlTmtnNkhsTUR3TjVicXliZnlzc2RZbVU1aVVa?=
 =?utf-8?B?VVJyMHdIcTZoTC9icFlvTzJaY1U1VjFQc0gzYW82eFV1M3YwOEpQbW5jZDJQ?=
 =?utf-8?B?cjdSeU85NGtUR21aRlJNdjB6R3RxSHlvUTRrc2pNc09vY1dySmJVSUR1aDkz?=
 =?utf-8?B?WlNpazdWcW53NXMreUh6a21uZEFnSFdobGUrOXEwTkx4MWhuS3hpRGhKNUt6?=
 =?utf-8?B?UWJLcGo4OFdGakFoU1dnb1dMM2s5MVhFZjJXRFQyRHdHUnVqQk8zcjVzUlNm?=
 =?utf-8?B?eG9EZi9KNW55bnRCY0FGMGREejV0V09zVjg2d25KLzBEaDRwdDJwZkQxSEdk?=
 =?utf-8?B?eXhsc3lSaENXN2x1WGp1eERzV0FTbVhUNEpEa1ByL2pzenNrZkk0YVFGSEpH?=
 =?utf-8?B?QVY3bXBLVlRLdllKSVYyQXlpekNyQzBpK3BmZ0FHdXRMN3ZjUVkvUStVczVV?=
 =?utf-8?B?cUk2TkgrMWY1WHBNUmpBNUNjL29Qb1piN00rYzFxVXcxRWF6ZEZhVzViNFZE?=
 =?utf-8?B?c0FMZGRVY3AvTmM0WHQzN09idjFoN2lIK251eUdxb2dDaEgwNnBLV00yUzBX?=
 =?utf-8?B?NkhlcSt6YTdLcEVYc08yWnUrb1BScm42cjEwaDlLSmlmQU9HTjd2V2pTTXNI?=
 =?utf-8?B?V202VDV1LzY2QlNNOURIZFdpcmZid2RQVFQxejhxdlhSNlhoaUFTaGFGTEd2?=
 =?utf-8?B?ckpZejE1b0NFR2NYQnRvQkwveDBJelMvcTRYOFpvR2MzRjRUZC9zbkRId0d3?=
 =?utf-8?B?bit2OU94WHQ2Tng2MEE0Z002dWdZakNoRmYyLzVyUVJ4WUN5UEh0NFRZZ1B0?=
 =?utf-8?B?VkhnQlVwU2ZhTGFISHFSOFZ3aDBMbXM0MWE2QUIxbUY5d0ZZM25lL3M4R3lm?=
 =?utf-8?B?VnpzaVZERmxsdXJjVldrSnR4Wi94K00zcXp2d1ZMTWtYUXZOUGc2Y2xSVEVV?=
 =?utf-8?B?MXhoSjNpTHZSSlJRWnVoN0txYmRyU0ZKenBtQjAyaVlFcTNYWm1IbHF6ZXQ2?=
 =?utf-8?B?Qk93RlIybDQ2eHJiU2xmczJnb3BsU2svZFJYOUxYUHhYTElyTzdGajIrZ1p1?=
 =?utf-8?B?QVpTME4wRmxsNi92bG1XbTVYWHl1N0xxYzJIb1RIUmNmV28wRUtKdXM0TGx0?=
 =?utf-8?B?MndjSlgzcy9xa0xsbkFTQTdxcU1oWVBCS3hrb3VsRkZpUXdad0xDUDRtSlIr?=
 =?utf-8?B?WWEyK3hjME9KcWZnL0tlVXNpOXZZRTRWQlpVV0swMVRRbmZRd3BQZjRBYkNz?=
 =?utf-8?B?YTgxZGplM1dmbHZxMGhsNzE1cExMSlMrWTlwMUMrY25wclcrMXhseFIxOEdF?=
 =?utf-8?B?eS9xM1hGR2JYODBZeW9PKzVUWTFDTGEvaHFVSHRaK0UzaHFBNHRrUVJTeTZY?=
 =?utf-8?B?OTFLcmlvL1dlY2Z6Vmh1QWMxSDdMQnRoMmZQWVRSQ0ZDMWoxRi96NWc1eVVt?=
 =?utf-8?Q?NLDeKFqqD+tRM1aF05TJTIM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	79307umTj0hnPdzQJVii83z5ilDqH+xYYuRtcOIh16kYiMMEHZiRti6FzYBmZULpyfiYyzhqp7jeMtjdZDwLcMwcDBNfPn5LwgwsrtTVvZkU+zaaGVlo/kUC9wB3pH63ixK1LrrmZ8IF0VDwRsANA3Af0H86u6CipQP70Xm4EXHqtUtLGip2MTJdWVLhMe24wCfcOAO7S8snuc5u2tjBUp3PxHV20Al9VR5WfsgKQXJ4ea/AniX4H9xzAn7rP5Mab0+KZzjUOCDY9jsn7KaMaaC73jnm/FHSG8Mjv9vyHBMT36YiAQIRfIRZnUSq5hetgWMyTe3UjvyW5y8FvpFK/dcedtchCyBOoWH3Z2dfi5tuUBQv7GARu9y4O9J3kH5GV86DWqpJEGJYA9fMfggVqhYYZpwo4cVXslLxvoLnmuroLRl9f+7l48tQm3AeG/1sL2U3IFEatdolad4mZz0u/Mys2Su7CjiSDv96Q6Xf/dzrJGqjkU0wmwXbgD9nBFxWb8RhkveuGLb/6igi+lfON9ek4tMZq+Q0mfBQpjf5FEQ20I1OgeTgA4K088cUECVvEelI1mRIUOGEcT9OAP+oeflP8mQXFwpTaspztnhWOlw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddab73a-8a13-467e-ac87-08dd3b2fdec9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 21:58:14.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PmkvONXSDMsoRwA7GFEnmroPK34eXQQf9+8vp1JIxgFHWwEknjaZ8h8fwRJXX2g30QFSMyuhGa2hbN0Ou8llB1+Xavsf0osFpZNeN8bmhmsyh5kV+pBRkQw/xedP5AC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_09,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501220159
X-Proofpoint-ORIG-GUID: EH5Q6GXpCEb-DQUwyBIGQVT2kSAtF0yY
X-Proofpoint-GUID: EH5Q6GXpCEb-DQUwyBIGQVT2kSAtF0yY

Hi all,


We started seeing panic during boot cycle on 6.12 upstream kernel.

Data points:
* This is reproducible on 6.12.9
* Also reproducible on 6.13 from yesterday.
* Not reproducible on 6.11

So I looked at commits between 6.11-> 6.12 , and narrowed it down to a 
patch series which made changed to md-bitmap.c

https://lore.kernel.org/all/20240826074452.1490072-1-yukuai1@huaweicloud.com/

After narrowing down further: it is narrowed down to this commit

ec6bb299c7c3 md/md-bitmap: add 'sync_size' into struct md_bitmap_stats


#regzbot introduced: ec6bb299c7c3


Also, the panic points to the middle line below:

	sb = kmap_local_page(bitmap->storage.sb_page);
*	stats->sync_size = le64_to_cpu(sb->sync_size);
	kunmap_local(sb);

Call trace is as follows:

[   21.427462] Oops: general protection fault, probably for 
non-canonical address 0x8730d3f80000028: 0000 [#1] PREEMPT SMP NOPTI
[   21.440104] CPU: 56 UID: 0 PID: 1531 Comm: mdadm Not tainted 
6.13.0-master.20250121.ol8.x86_64 #1
[   21.450019] Hardware name: Oracle Corporation ORACLE SERVER 
X9-2L/ASM,MTHRBD,2U, BIOS 62110100 07/15/2024
[   21.460710] RIP: 0010:bitmap_get_stats+0x2b/0xa0
[   21.465872] Code: 0f 1e fa 0f 1f 44 00 00 48 89 f2 48 85 ff 74 7d 48 
8b 4f 50 48 2b 0d dc 9f e5 00 48 8b 35 e5 9f e5 00 48 c1 f9 06 48 c1 e1 
0c <48> 8b 4c 31 28 48 89 4a 20 48 8b 4f 18 48 89 4a 10 48 8b 4f 10 48
[   21.486849] RSP: 0018:ff3e5f658fc3fb18 EFLAGS: 00010206
[   21.492690] RAX: ffffffff8d17d660 RBX: ff27d0600af69690 RCX: 
094b3d0000000000
[   21.500663] RDX: ff3e5f658fc3fb28 RSI: ff27d03f80000000 RDI: 
ff27d06008cd9c00
[   21.507233] mlx5_core 0000:b1:00.0: Rate limit: 127 rates are 
supported, range: 0Mbps to 97656Mbps
[   21.508629] RBP: ff27d0604a737418 R08: 0000000000000000 R09: 
0000000000000000
[   21.508631] R10: 0000000000000000 R11: 0000000000000000 R12: 
00000000012c2000
[   21.508631] R13: ff27d0604a737018 R14: ff27d0604a737000 R15: 
ff27d0604a737018
[   21.508632] FS:  00007f61a01c98c0(0000) GS:ff27d07f7f600000(0000) 
knlGS:0000000000000000
[   21.508634] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.508635] CR2: 000056503c28f458 CR3: 00000020c000c004 CR4: 
0000000000771ef0
[   21.518772] mlx5_core 0000:b1:00.0: E-Switch: Total vports 27, per 
vport: max uc(128) max mc(2048)
[   21.526600] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   21.526601] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[   21.526602] PKRU: 55555554
[   21.526603] Call Trace:
[   21.526604]  <TASK>
[   21.535111] mlx5_core 0000:b1:00.0: Flow counters bulk query buffer 
size increased, bulk_query_len(8)
[   21.542533]  ? show_trace_log_lvl+0x1b0/0x300
[   21.542537]  ? show_trace_log_lvl+0x1b0/0x300
[   21.556126] mlx5_core 0000:b1:00.0: mlx5_pcie_event:301:(pid 529): 
PCIe slot advertised sufficient power (27W).
[   21.557983]  ? md_seq_show+0x2d2/0x5b0
[   21.557988]  ? __die_body.cold+0x8/0x12
[   21.641128]  ? die_addr+0x3c/0x60
[   21.645080]  ? exc_general_protection+0x17d/0x400
[   21.650574]  ? asm_exc_general_protection+0x26/0x30
[   21.656267]  ? __pfx_bitmap_get_stats+0x10/0x10
[   21.661568]  ? bitmap_get_stats+0x2b/0xa0
[   21.666277]  md_seq_show+0x2d2/0x5b0
[   21.670507]  seq_read_iter+0x2b9/0x470
[   21.674924]  seq_read+0x12f/0x180
[   21.678853]  proc_reg_read+0x57/0xb0
[   21.683074]  vfs_read+0xf6/0x380
[   21.686902]  ? __seccomp_filter+0x30b/0x520
[   21.691786]  ksys_read+0x6c/0xf0
[   21.695607]  do_syscall_64+0x82/0x170
[   21.699909]  ? arch_exit_to_user_mode_prepare.isra.0+0x1e/0xd0
[   21.706637]  ? syscall_exit_to_user_mode+0x37/0x1a0
[   21.712295]  ? __memcg_slab_free_hook+0xf7/0x160
[   21.717660]  ? __x64_sys_close+0x3c/0x80
[   21.722248]  ? kmem_cache_free+0x400/0x460
[   21.727028]  ? syscall_exit_to_user_mode_prepare+0x174/0x1b0
[   21.733553]  ? arch_exit_to_user_mode_prepare.isra.0+0x1e/0xd0
[   21.740270]  ? syscall_exit_to_user_mode+0x37/0x1a0
[   21.745913]  ? do_syscall_64+0x8e/0x170
[   21.750388]  ? do_syscall_64+0x8e/0x170
[   21.754857]  ? clear_bhb_loop+0x45/0xa0
[   21.759318]  ? clear_bhb_loop+0x45/0xa0
[   21.763772]  ? clear_bhb_loop+0x45/0xa0
[   21.768218]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   21.774014] RIP: 0033:0x7f619f862585
[   21.778170] Code: fe ff ff 50 48 8d 3d 52 a8 06 00 e8 e5 08 02 00 0f 
1f 44 00 00 f3 0f 1e fa 48 8d 05 d5 71 2a 00 8b 00 85 c0 75 0f 31 c0 0f 
05 <48> 3d 00 f0 ff ff 77 53 c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89
[   21.799471] RSP: 002b:00007ffe50c2d3c8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[   21.808099] RAX: ffffffffffffffda RBX: 000056503c2802a0 RCX: 
00007f619f862585
[   21.816240] RDX: 0000000000000400 RSI: 000056503c28d000 RDI: 
0000000000000004
[   21.824382] RBP: 0000000000000d68 R08: 0000000000000008 R09: 
0000000000000001
[   21.832518] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007f619fb00860
[   21.840654] R13: 00007f619fb013a0 R14: 000056503c280a50 R15: 
000056503c281480
[   21.848789]  </TASK>
[   21.851389] Modules linked in: raid1 mgag200 drm_client_lib 
drm_shmem_helper drm_kms_helper sd_mod sg raid0 mlx5_core(+) ahci 
libahci drm crct10dif_pclmul ghash_clmulni_intel mlxfw sha512_ssse3 igb 
nvme sha256_ssse3 libata tls sha1_ssse3 megaraid_sas nvme_core 
pci_hyperv_intf psample dca nvme_auth i2c_algo_bit nfit(+) libnvdimm 
aesni_intel gf128mul crypto_simd cryptd
[   21.888253] ---[ end trace 0000000000000000 ]---
[   22.452319] RIP: 0010:bitmap_get_stats+0x2b/0xa0
[   22.457699] Code: 0f 1e fa 0f 1f 44 00 00 48 89 f2 48 85 ff 74 7d 48 
8b 4f 50 48 2b 0d dc 9f e5 00 48 8b 35 e5 9f e5 00 48 c1 f9 06 48 c1 e1 
0c <48> 8b 4c 31 28 48 89 4a 20 48 8b 4f 18 48 89 4a 10 48 8b 4f 10 48
[   22.479037] RSP: 0018:ff3e5f658fc3fb18 EFLAGS: 00010206
[   22.485067] RAX: ffffffff8d17d660 RBX: ff27d0600af69690 RCX: 
094b3d0000000000
[   22.493217] RDX: ff3e5f658fc3fb28 RSI: ff27d03f80000000 RDI: 
ff27d06008cd9c00
[   22.501372] RBP: ff27d0604a737418 R08: 0000000000000000 R09: 
0000000000000000
[   22.509527] R10: 0000000000000000 R11: 0000000000000000 R12: 
00000000012c2000
[   22.517686] R13: ff27d0604a737018 R14: ff27d0604a737000 R15: 
ff27d0604a737018
[   22.525845] FS:  00007f61a01c98c0(0000) GS:ff27d07f7f600000(0000) 
knlGS:0000000000000000
[   22.535089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.541701] CR2: 000056503c28f458 CR3: 00000020c000c004 CR4: 
0000000000771ef0
[   22.549866] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   22.558040] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[   22.566202] PKRU: 55555554
[   22.569425] Kernel panic - not syncing: Fatal exception
[   22.576477] Kernel Offset: 0xb600000 from 0xffffffff81000000 
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   22.654941] Rebooting in 60 seconds..


I would be happy to try any patches.

Thanks,
Harshit
