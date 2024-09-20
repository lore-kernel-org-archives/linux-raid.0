Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923CF1804A;
	Fri, 20 Sep 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726826682; cv=fail; b=ZvkblBo00Omag5HESqMjleMD2gK4c11UEUdJJP6c4gIdG9zOQtE1/UnNQOcrOOa13oo8F6CJUDF4l9lq04eMjpxUu/+kimb/OCP516HnfiXfLtJ0QikHn6mn5gaJOgUTi1unn1QvABcx+Lac+RzaAisojgt8y/n9agZaVuo3Mcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726826682; c=relaxed/simple;
	bh=liYdZ93mJsUym6lJbw5MuVpvVG/NQpoATauZKjQMXh4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D2rp2Q1jpjYy7bGOv7LAwQpcNZ6m00z0n3aUQCV7TDqblfHcgf8QA66SMGErXzpYf2kDX1r0jo4iPgXU/sLw9GJ8xw+M6hXdVHMzSC0zi9SLzmX5qJNtasVhRW1Gun9lBoHLQLliyAb4FuHdbUKOocx5Sy+VwhQrbGaArzRNOCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NGzXRL1j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pEAYIKRX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGzXRL1j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pEAYIKRX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48K7tcnE019541;
	Fri, 20 Sep 2024 10:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=p8z603A1C0BAib1SIv469txnAI9MRN2z5nZ9osFvL0Q=; b=
	NGzXRL1j5AMFxSwV4wyxEgxDn01XUcl+yg9ZgowTOltLJKIqEAIFkVUsprsFROA4
	8g3OjBf/PZs+9jBJvctzEXlm78v0Ca1nCK4XBhmKU87Ikcayd3/IQOvRIQ9ccosu
	cKndL46/eEXvueV8ssOQSZait9faYeb7WqbZDfINWCX09JwOAWnrxAdC/oUPViFE
	1M7s7kFszJeGEg4ogx/YRsy6zTLdcHxfsYRxMkVbnIyGGKqSeys6/gGiveoRb4lc
	xY3Gp0nZLh0ePnryJVPDmsC8TkUZjAKs97ScT4mQlThFwAqqaGbchbcXtXXHxKpY
	/zGugTZ78vn/QQxFrunZfg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3pdx262-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Sep 2024 10:04:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48K9pg25010493;
	Fri, 20 Sep 2024 10:04:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nybawa97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Sep 2024 10:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h48XX3On98eervG6Zf/Yn+4PtZBuz68lcuUtBBP+KG7jNrWoYJuAOa4tEGZkHMGvc1z6RpHRMIfBkFI8Wh/W7wQPFCeDBT6Wcv1jYqDkMhpvZMgjlDY+AvAxBEJ7E6HK/xustAB4Q9TxcAbttI1EWsk2yIX/phm/eSmltDk4z6uQGqLaxenM2OAshQglyo7R354yazy7oBWajPHD+vglE2Dht6A8vhAxypa19p5wZ/KFmlpxV5Rqk4XH3C7mC9RUOuS/nqGFcKBk96Ze555PylIc3UsyQhMlCbiSuaLiNK34yFBOUDbv8reKmRBk5P7O2xO3vnPn7WXMAnKCTkMLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8z603A1C0BAib1SIv469txnAI9MRN2z5nZ9osFvL0Q=;
 b=S8kSdAQ2PkKPz3cmXedz2wtrek3E9rYhw8OgO2hr+uSI7let+e3po+uVUR7jKIUAcJ2AwMStuK/A5a0Pl9AAotVv7JHLUf37VKu7WEbY3rFuDdF4wXHWQI+LMiACd4EM3iMOpmjZp7J8zTPmDm68UPw9P6bPGOl7PWP0bo1TMeHyGFl7GpP7ncFoGq03g00FtbMWe4lOWaB8BD8cVBRpi0CgzrYZw2O2UVnX74re5dyIboQkz8Q7HtSZwiLJhG4TBjUKRrzB9QklzhY+CAfzVXTPL7JH2oZYMamM/otFbvCC/NEXPw0NhqEyt5cOhskG5rr+IKtYPLTMcSh+qT5+NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8z603A1C0BAib1SIv469txnAI9MRN2z5nZ9osFvL0Q=;
 b=pEAYIKRXYoySST8PSs/h2nr0VzmYrt9mhL9UTfRRNtRA5X1/lZJwY3rdgf+4+qIg+v7k1ZGhLyBPnnYRbwnf21oCHtXTuvbyntw8kK+nXJ25le+XSV6JXqSUvZZrKA2fvvZpqcQYFDMugRgx9WBVeEd4YFTfah02tFnH5bUI8UI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6770.namprd10.prod.outlook.com (2603:10b6:208:43d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.12; Fri, 20 Sep
 2024 10:04:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Fri, 20 Sep 2024
 10:04:11 +0000
Message-ID: <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
Date: Fri, 20 Sep 2024 11:04:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0293.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 08218c2a-aa76-4876-8784-08dcd95b9321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1VMSWtWeS83NUo1MFAzb0E4YTdKM0FKamlReWlNRDZ3K1F2Y3FpaUhNYU5q?=
 =?utf-8?B?bWtOUUFNTDRCL2MyODVmdThYalhKOW9pQXZEZG1tK1hKYnlTTVAzNUwxUEJv?=
 =?utf-8?B?ZjV4YWNXOW1xQy9pRDV5MVVKR1VZTktaNUJYMitNRGRKTzhzMFBrcHBHalhP?=
 =?utf-8?B?V3MwekthTG1laXZYSnhqRFQ5Zk1RKysvSEdkL2VjT1E4dUVsd1haOGpOQ3dI?=
 =?utf-8?B?T2pLTkwyK2tSZlRsK3ZtK1ZzWDR1SmJVUHF4aTRzZk1mNVRnVGUxbE1zcG5p?=
 =?utf-8?B?ZnlFdWEzU0diT0k3cWpROGNLVVJJRmZkSXNJZy8wRjFpTS9QYzhvc0IyUkZJ?=
 =?utf-8?B?ajREdFVPUFVHL2l2OThYTkpMTlJtb29WTTJlMWRwUlB6ZXJ1VmFuOUJnVzc3?=
 =?utf-8?B?WHpCSGNiUWU2TzFmV2NKVkpvbnlNQzJoWlhyV0w3QmlZK3VBN0ZRdXA1b0pa?=
 =?utf-8?B?TjBUZHROZ0NKRVBLMFYrR1hsUVRLWExiejJudWZWUUViY2RhZk03TDdjVWJP?=
 =?utf-8?B?NmtkM1FqOWRSc1NIVTNTVUE5dEVuYldSeDJ5UXlsc3ZwRE40YlJ1SHhFN3Ji?=
 =?utf-8?B?OTdQbVdzTXJqUHVJa051UzlFdXJSK3hUMWFwR2t2c0ZXRXA1aTdUQ3g4NXpT?=
 =?utf-8?B?RGpuc0hjMzNlOUhpN0hHMDFGc0EyVFMwY0VVWC9KV2FEVHhHd202djdZK0Fu?=
 =?utf-8?B?MUVDYnlVMHZNSk54NDd1aTQ4QjBUakoyclhyczg3bUFQK1VDZUdlZkwwb20y?=
 =?utf-8?B?S0l6Um9kYnJ6azN6QVZGeHFxbUpYNHhab1pmd0ZIMHRUek5FcnJibUdJMUpU?=
 =?utf-8?B?RUhmMUdEWnNPdWs1ZEVJaTJ6UzJWbnl3T3dOdE1qb1JRb1RKTks0dmpGUkxq?=
 =?utf-8?B?cFVPVDNKZFluWVZib1lXeEdHUGZBRU9rSzFjVmpNNno3R0d2VTlkYU0zQ2pj?=
 =?utf-8?B?U2trNTB4dUlzVkJ1bjNYTU90QlNDVmprUVlBMGFvSUMxRXJ5a0NmWm8vYlkr?=
 =?utf-8?B?MG9xdEs1TUVwU3o2MlB6OFJxQnUxZUlaam16Qld2U0tKN2RhRDVhUytSZHRk?=
 =?utf-8?B?aUlaK3ZpVVFrczNiT2R6bWIzTXZORS9uZVFtWDhDWG5uM0Y1Uktub2pGQlhn?=
 =?utf-8?B?RDZ2MFllMXM1VUg4a09Nd2VjYmpQWGxaNlhXdE1WTTFuUXNyR0M5RVNiMHBN?=
 =?utf-8?B?S29EakozMkdyR2F4dEtpSTF4M2hFYWUvdUJTUHU5ZVR0V1libzFMd1pabDFW?=
 =?utf-8?B?Qk9ReDR0V2Z0MFBZWExVS0pNT3RsYjhBblZzUTNBaVFwanNMN0dTaGs1R2Fr?=
 =?utf-8?B?ZWNMSkgxNExsMk1zbmdHbTBacmY5eXM4VE9Jc0xpc0d1UTRzSGszK1dtbWpa?=
 =?utf-8?B?MWM0WE9yd200U3grUjZCYjRkV3pSaEtUZXhsUjArV3pSZlVrUGNSRW1iRlIx?=
 =?utf-8?B?YUJldjVKTWphSjRqbmFSbWVDOEZXZk5jYkI0bFJ6OWNmNC9zZUFZbmNBVEpr?=
 =?utf-8?B?RTFKVFBMS09zTDF4aTNRWitFL3p3ZklZTk5JQlFYeXRRRys1a2tUUm5CTjBh?=
 =?utf-8?B?MHhUOUp0WUxOMmxvY3k4TjJ3K05MRGFPN3F1VEFncC9sZkJkQ0hhSEpkZTI0?=
 =?utf-8?B?V3h0R0w4anplSWZlVVVNMEhLaE9DcGw5Q0FZc2d5bUtmL3ZtMk45TTMyNStu?=
 =?utf-8?B?cUhVdDQ3SEdUVmtjWGFvQmFXaFJZMU5uYXFVc0pxeVpDcWxyZUFEcmlMUGMr?=
 =?utf-8?B?VjR1Z2pkUm8xeGVPUW1QOFZnSmJLSXFJWWhMR3JyRHIxeXczVGcreWRab2Vu?=
 =?utf-8?B?c3FwQ2FDTmlzK2JJc25mZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0VTa1FXSmgvMlV2THkvWTJnVTJmaWlySGpvelIvTEJFY21MaStGdSt5c3RP?=
 =?utf-8?B?WjlHRUVqeXJodHdDSmFvMDRpYStSb3MwRjFLUTJlVGFHWE5lZG9FZTZvQ2gv?=
 =?utf-8?B?bk5lRkJTcHIyUmRyaEE5Um5oTFUwdFo0b1ZLSVQ0b2l6Q2U4QmJMT0Q3am1B?=
 =?utf-8?B?bUtZVHNLelZNK1ZsbFQvUFFRa1hUSU9iWXl1YXhRN2JCVDNJVGhtb1NUMko2?=
 =?utf-8?B?d3hrbU01R2pucm9kaTRLbDE3U3d1UXF5N1k1clZBTnB1VWxiS3JIVUh4cXV3?=
 =?utf-8?B?YUhxTHJYaVpldnpHWDd5UjVQVnh0a01NZ0FkTThERTRuc1dMKzV6OVUyME1y?=
 =?utf-8?B?TXFFYjJSejFRUmpQdDh4N0FFMVplbWNoOWUwNjZjZTBZaWFWSDBqOWlLZ1k3?=
 =?utf-8?B?K3FNb0pRSHNyUHh6SlZmdDltSzBCYkRhSUFtQmRrSHowZ05XellpZkdkNnFz?=
 =?utf-8?B?L20wMDc3RXA2TVhUVEJReVhFampUendZMlB0UXlROGZ0MmlRVjQ3dUpQMExI?=
 =?utf-8?B?Tlp4cXc0dU1WbjVBcUZPd0RUaGYxZXVaUlV3dnhWYWhtemVnS3dSTWdJZ2U5?=
 =?utf-8?B?MGkzWG9tQWJEMUd5TWlvVi8xNEFTcGwwQS8zOE93MnVuTitWZnpoQ3RHOTNH?=
 =?utf-8?B?Y0RRRWNJZFM5dWg4dkV5VTZyTmVGV2tBWnZMWm51cXdKdU5hdTUydEMvdklQ?=
 =?utf-8?B?UTNZUGxNMGxybUZrWGtkOFpRVTJsRVdkQWhJcE9xejdLUVB4WTc3c0U0blR4?=
 =?utf-8?B?V2RETEZvM0pyb3ZFcUNpZ2RHWjAzNHd5RmtCTUQ1VDBieWxEaXNSVVNiRVVm?=
 =?utf-8?B?cUpraXZGZkplUXVnKzlJL1lxRm04ZFFyQWhCNENwUHhtaVhEM0RXZXZtdnQ5?=
 =?utf-8?B?TEE3TFJ6eU51bnQrMTNQc1JwL0dOL1hRNnQxZGFIajdVT2VLN204REZHSkVE?=
 =?utf-8?B?YU5SLzBXRmJFaCtFdDFjVjRZNzZneVQ2NkF6a3lVTEplUFRMc2VwdGJoWmZr?=
 =?utf-8?B?Z2FoQXRCWUVIYUZWU0Jyb3lvYzlYUEw2U2djWFFJcTE5cStPRkRHem1EdVhp?=
 =?utf-8?B?QkxRaDlKUlpsK0pHRHhlR1Q4WGJNMjVNY0lZUzFNa2VTQkpVQjdaaVRnNndP?=
 =?utf-8?B?ank2Sy9TazBjQXZza1RHNjJzWVhQUWZJV3c1aklzMWs3RmVIR0tYckxoaXFu?=
 =?utf-8?B?T3NQY0cwcE9tVGg5T2VwbVA1akNHMlR2dE1kZGhKTlMxTnBnN3VzTE0xd0R3?=
 =?utf-8?B?WTlPMGREdFVYbVRsNjllTHdSaVB0STE3VHlVc2hGakNFS0tjcFZTV3lXbU05?=
 =?utf-8?B?ZmRGNVNjVDZtZTJTbnllRGE5Sm5JL3VWd0pTWURzN2s3Sm52dy9uVTY1ajRG?=
 =?utf-8?B?ZERGNWI1THVCUU9RRmJIU3FLUTNNcU5XNkoxQllpUHZEb3dkMG1wd1dyM01O?=
 =?utf-8?B?MWZVSzNiY3pianF5SHcrcUdDR2JSNmlIU3d5YTFSVlhpK05WN2Y3YS8xVk0w?=
 =?utf-8?B?VnY2Zk5sNDk4NjVKOGxMU3NHbk1leWNxMERJYStEOWZ0VSttOVFFRmRoL2Jv?=
 =?utf-8?B?MHovdG9vVDZueUdGZVNyb0hJMDlCb3VicUUvc1B1S2hNdU83REN5Yk4yVUlJ?=
 =?utf-8?B?WWZEd3hsRWZ1eE1KcU1WTFJnbW02WEdrNVlQMGdjMGNQd24rOU1YdkwrVTE1?=
 =?utf-8?B?b2NGZENKQWFXYkJIdWM2cFRKVnlSSEQvRzczbVBPV2daVlo2QlZ4TVVTOFpl?=
 =?utf-8?B?V0FYcERGZklRRGZaQ0s4Nkd4Zzg4bkNpeCtpMUlzaEFYZVhOSnpkaHRyWkR2?=
 =?utf-8?B?bm1YT3JYRjFCRFoyM3BvMmFuZHJ3WEZTVXJVU3g3c0lrLzZManR2cWovOXRl?=
 =?utf-8?B?Y0VjMW5oRDFYb0lKZTJKZzN2TXpaK1AvenlmdGsvOGVRNDdURDRsZEZBRXBo?=
 =?utf-8?B?TTlHOUtJaHIrVDF3TnlWbm1hdFRUTFhRZEVDNldhaXZieFpkZ2VORDV6enc2?=
 =?utf-8?B?QzhhUUFVanpNUU5YSTVUUkFNazR5MnY3VUw1U0NIL0l6TTgrT1dPTjJ3eU1I?=
 =?utf-8?B?T3RFckVUTkR6ZVdqUWlXcUxiaTBtSkNzVUxhalU5SUpoQjdGOWI1ckRwRkVQ?=
 =?utf-8?Q?DgexEUwW0wAkgpw3vzU17qpK1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vHcpnEsdKnK7EBb5nKT6AQ9wuDbgz10jXEnlDohIE89PFU1o3mmHbOZNO1mwnkE20nSPuvXA5XukORBpKk7fAKZjCLmen9WDs5xAhNmHXoXX0aqVHn6wIV0bh7Jo2DsdvgrzxDqVSXTrAaKX+br+4qmbFHy/w6LdfRPkWWyaZyk5ixZ4Uk6s+1I6DzJsBapS71h2qlxVRngLJiZSCF9LE9ncgOZ1pd1iE2F6br1MyWRc4qLz7Li7jVv/Ngdu4InWv1mO/HCiYpDVlcAzQV3N91q+jU7orfEBR4/hR/mJaKCFqbxFQd+5pZkWofyyfUGRYc1ugMWtRCje3ZOudXanGGT0hq2bchziLZKZZ5gQ9Pgd+1umOaWdkBiERhR+hsj8O1aYLdmR8GwPyeg7pHG8pigqySuDYE4aLI+MlOEcnth2zhUkybjb+7tfoRXO/wEewfwoIzHeGELirW6bBaxnZ9ihlkeNO2XkzWTcXNfaquxl2DSAbb94cVOIq7a4eVHrxnLWc1l2sV/Ul/sN9T/Y/Kexiy80pn72xkTFozUByUh/Z5mGCMxty4sKJP9Sq99u8k9Yj2VJ53Z01jaW3lv4fl+2/kftICHD85oWlcoPjhE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08218c2a-aa76-4876-8784-08dcd95b9321
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 10:04:11.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUZVdlZBZQzSwwPqKywjyc8RGZqLl7rrrZq3P7OE67qT0QOlfbbOJhkrCNNSAM+QhKxfHUHN2wE20CVIiZQ+sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-20_04,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409200072
X-Proofpoint-GUID: xejIyDa067848vXtsNeSH-PmjRnN_uTG
X-Proofpoint-ORIG-GUID: xejIyDa067848vXtsNeSH-PmjRnN_uTG

On 20/09/2024 07:58, Yu Kuai wrote:
> Hi,
> 
> 在 2024/09/19 17:23, John Garry 写道:
>> Add proper bio_split() error handling. For any error, call
>> raid_end_bio_io() and return;
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/md/raid1.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 6c9d24203f39..c561e2d185e2 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1383,6 +1383,10 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (max_sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, max_sectors,
>>                             gfp, &conf->bio_split);
>> +        if (IS_ERR(split)) {
>> +            raid_end_bio_io(r1_bio);
>> +            return;
>> +        }
> 
> This way, BLK_STS_IOERR will always be returned, perhaps what you want
> is to return the error code from bio_split()?

Yeah, I would like to return that error code, so maybe I can encode it 
in the master_bio directly or pass as an arg to raid_end_bio_io().

Thanks,
John
