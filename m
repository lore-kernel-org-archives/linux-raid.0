Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D075205AD2;
	Tue, 29 Oct 2024 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203621; cv=fail; b=qSA/+2MlfaVzwHtKLbDuZH5jyxSgLaqFOlT2ypLQyyUkYSCTYsy1mwbGRj8x4tXl/g1vCzyBlwFt8Yg++hcUx6iEXZM0oITvOm0Ri1gQmMmEHoI4DJ5r11PnBSQYeAQjE9sHMPgLMkPv/4VEmdueo26l4NuzCcm54zAUO+7wax0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203621; c=relaxed/simple;
	bh=HzhwkQwCZlovn4324+OUqOvOl3F6PzVza2aWCKjZQdI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SQed/E3Ia8enZnRt4LnRvP8Nzhc+XLoNHf/2znVOUdHBaEkBF0rNeXmWgVlK9LUIxVWeHBe0c71CceLLwhPdMqfrNzv491XRwIF3hvKQNWsajmHPSDEAzvCDNRbf453LTY0tD5Y0iFy13FhcVvR34+1KyqIZD9h0IFPxHjU8WMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HGn4BqAY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D+tFj48Y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HGn4BqAY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D+tFj48Y"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49T7tlGO021566;
	Tue, 29 Oct 2024 12:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YQSXHi0FLyl6QrMLORKqTWzxyIWPjD2hXM9I/ZjOOAw=; b=
	HGn4BqAY24M4/J7+cUbiNnUIOPq0a4txm6ezXaMu+myjfCfT5ceRnd8oAkN/eI8I
	WnMiyoVjVOJEhosUrny9eLWQDjV/XqfOKyyyUpSV5Znt18dO6pVoWfpGvYDkV8ZU
	LpRjNkujdAd2JCYHmU0KQAG/gfZ3EnAd36ZNEcsmhJOzrzmVxqmKbZJh7+GaYxDL
	VXm5EpMt3riKUJFxCmDrVXztXKVMg4E3x3hSWLMi+F7ctd+BabCPF8WlOmFQfoaV
	I0WaLWGtfV6hH92Zo4nyx/wUp/3yfFYE7lXlfjiKlrHvW9sVQ8VCFDXer7oCIDue
	nzMBHvNwD0bpSRJgQdN7FA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys588q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 12:05:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49TB4ta0035542;
	Tue, 29 Oct 2024 12:05:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnd7j81h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 12:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxbYTYQIAyyT+1A9JyopGctjll9fLNdI9I+HRIXKSvQIg07Anlz620cyUNO6oC5KS43QwNdIsaBiLztLCzRI1uoe7YcmU8LDE9jHYRJBH0k50bBcNTpMENmhUPYOAhULIE9CbEcPpLqXdXZgeOcK0/P0wb4nllG/W4mg9Sd2YgKP8/aLiCYlaAj5IexwINFL+klgXdVFPU8c/sMsxxp8tQYnK68fUszEaAlzS2qK6E6D73G7M2kFLiNTYqxLQoPf1BClp3ChdYhPk4ezBR+F2RDe9pFmQRKRdP6Oit3a2/xvLdiRO1k4cFdTWDxQThwaDQzFmIEMhCzcA+8LPUVu/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQSXHi0FLyl6QrMLORKqTWzxyIWPjD2hXM9I/ZjOOAw=;
 b=da++z7m+LqhBcLmp70moPMAJ0sM+NsZNEJCSmUpRUGrvSEpDGS5c5JOwE7YLMN4e6GU0160c9jTN4Q9QJoD7rFO3mVFYNbuZVYqISArVLym4sJZF1ChHx/IiacSvsORCwb8JYNnuWCmcLVdBqLI3AA3HNG9s2Nfmmz0PiqCGksgphcL299lrIpPlzIPSLsxiggpxiS75o7g7OlGKoKZgnqkQwZOWuRRiXnJq0lhdhNRg4wqeEYXudM7bea2v5dem2E6HJXZkH4KSHCJuW/LtdA2kJdqaiQAAuBKmTsA/C9GCZUH+v3YnNl7KxRGGuhPG6iebH7pYKNP5jhLrAZm22w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQSXHi0FLyl6QrMLORKqTWzxyIWPjD2hXM9I/ZjOOAw=;
 b=D+tFj48Ygib9E9gQQbtka1BRF3LGYcYh2R5pAqrfFlfOqZ+Ah3n64VeycbT+szw32C0ZiidAicp3weQU6XyuLDB0+dSsNVbqNykCVwK0RaP2Lk2NZdIcUSyCcsz/29B+XQtNwg79iL91joui+eEtn4Y21c0WdSqreIOntHse4WY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5826.namprd10.prod.outlook.com (2603:10b6:303:19b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Tue, 29 Oct
 2024 12:05:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 12:05:23 +0000
Message-ID: <f0ecb0b1-7963-42ed-a26d-9b155884abb6@oracle.com>
Date: Tue, 29 Oct 2024 12:05:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] md/raid10: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
        hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-8-john.g.garry@oracle.com>
 <eeb9ca32-6862-6a07-bc51-7bd05430f018@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <eeb9ca32-6862-6a07-bc51-7bd05430f018@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P195CA0037.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 82bff563-e5b9-4375-a32d-08dcf811f7d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0N4WUhsZVMxbGsvd29EQjA2OTBlb2Yva0g2TDVwYndUbm9wVTNKb0NnQ1Jr?=
 =?utf-8?B?OXUrQ2dFd3dBdjMwUXhBYklCNlkrbVZVaEN6Wi93WFJ6V0NjTGFBdHVQdlJp?=
 =?utf-8?B?SmdJelZ4c1M1TExzbHZtYUpsb3pxdW51dSs5d0YxOVlVVkdtVHRUZklDV0RC?=
 =?utf-8?B?eVBXTFBRMUpsMjBTNlNqSVRSdkVwVXlvcGRCVWRYTVlTZFZSa29nRUVaSnc2?=
 =?utf-8?B?K1plR25RRXlPYlREVkt0cGc1aFltMzlnM2dGcWwxMkpGWVNuVWNpaDYyTTB4?=
 =?utf-8?B?dno2TmhQSk5ENVZMSkFVL3MrY3ZZWEF6MjB5c2J5MEE2cFJwWCsrTitKR0F5?=
 =?utf-8?B?b3E3K2w1RXo0VWpUUWpTZFRzMks4RHJpc1VlcjI3VHgyOXo0QVZlV0tKamVR?=
 =?utf-8?B?L1NDYmNtV1FzeXB3QkcxL0paZVFHNG1SMmpWZ0o0OHR3ZUhOV0lEdFpHanMw?=
 =?utf-8?B?dFhFT3d2ak54ZnRibHZydllrVHhuMzVISGxGazNFTlE5Q0tJTEZtQzIwTGc5?=
 =?utf-8?B?SWRUaXVpREVNY1Z1VEtBVkxjVnpwWjcrZFd3VlRWSm5vcVQwbVZ0cmxRUXND?=
 =?utf-8?B?Qm9NRWJGdkltQkxFOHFXVFUvNGR0YndZV1BjQ1kwSDJIdjFtdVJtQ3Y2UHNH?=
 =?utf-8?B?ZEY0L1JJTlFlcHJjalB3V0hZS09sdDY3WGtwbkJIdzFMWDZzSUJBUU5FNE4r?=
 =?utf-8?B?OEg1amxwSTlhbVB1UzlMTEdLOGx2TUJxTTFwQWJjZFdsQ2lUeTNWRk1aWDRX?=
 =?utf-8?B?dytNRVR6SldkNTRnR2NZSC93Z1BuYi9kV3hpUFVXRTYzSy9NL1IzandWZUh2?=
 =?utf-8?B?YkYyZVkyb0N0Zml5ekd1MG9IdjBqNmZwVXBVU3pyR2tXSlVkU1NJeEpUNjBE?=
 =?utf-8?B?bFB0Y0xqNWJMMnJyUXhpLy8rMlcrSVZjS1FWYUFqU0ZVdlhmSlVHUjJPRnBq?=
 =?utf-8?B?cWRZbFEzcHhrand2V2FtYVFvZVdFb2NJZ3ZLMDRpVGQ3amRzTklQMGZXOFk1?=
 =?utf-8?B?VHJ1bEV5YVVpa0l1SVB3SVZkbWdhY3MrcExZekQzZE5VZnNoRWtzdVBEbEV3?=
 =?utf-8?B?b1drZXltdUkzYnlGMTlIS2RudVNIQVpRM01oK0tsSnVNNk1NUmdETXdTcDJI?=
 =?utf-8?B?OE5FZ05rQ3pzb1plejVudlRKMHdkKzg5RWV3bVNMTmhSK0VLVHNSRWg2TFQy?=
 =?utf-8?B?OUVNMXZYVCtmOG96aElxbitpbzYyY21mZFdudi85SXh0aXpIc2VSU3FYN3pM?=
 =?utf-8?B?RjNNSnIxQnN3d2dNL1dxVXF3c014Z2dLVk91QXl3Y1c5Unl2bHhBUVcyODVp?=
 =?utf-8?B?ZG5VMnVLRWtFT2YyUE42RVF4YlZzQmhqdGZsUDBpSlgwZE5DVHcxN2tITGxo?=
 =?utf-8?B?Q0h6OWhOMXRiUTBxMWMyNkdWbCtzb0lzL3dYVlFsV0YyOEtucm4vWnlIRW9W?=
 =?utf-8?B?WndMeCtabGRiaDNoQXhQTUpua1ErZlhXOWVOcWJYYVMxdW5wTWIrZTkyOWx6?=
 =?utf-8?B?TytKbzM1MmV4UTl6cVF1UE4wcHBHcENQVm55eDM4bERLU2I5Z3RhOVdLVzJm?=
 =?utf-8?B?ai9GMklTTm55ZHBlMkZVR29pNVkrWW16clQ2VHhjQVkxUmx3aGczL0xXSHNu?=
 =?utf-8?B?a1J2anNEc09nc3JUK2ZPdXVCQlVVUm1mKzd5NlVuOUQrVGpVWHVvVjhaV05D?=
 =?utf-8?B?Z1RQYVFTZVlUMTZNcWQ2bnllckhRWmJ0ZkEzUmMzaS9wRW8ydVlQNGFURG9w?=
 =?utf-8?Q?quyxQXXDd3wxROoFgSlvr0LpYe7tJutMHmEp3/p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TncwZWJOMGpjOGdUY3RTMkd4TUlpZEFyMTV1T3ZaZlhSdEhGcDNVeUl0c3JZ?=
 =?utf-8?B?Tk9wTSt5aEk0cXUvenZrUU9kUmFuc1dVWjBMOGtCeXBZSzU0YkpFNnhuSFZw?=
 =?utf-8?B?MkhuRDRqdlhhMTdON1F4eFdEU3BSMnpsU2NDMDM0NGxrN3FidUlMaU55clV5?=
 =?utf-8?B?SzZIT2NaZlNyVHlCWmhZcE5kMGZOQ05LWE5HTmkzclg2MndVcElUQU5ZVFVC?=
 =?utf-8?B?aUhVMENzQS85cUg2MTVGRWN6c3A5TG1iUjZZZGg1c3JXMGxxSVNWL0hrUm5F?=
 =?utf-8?B?bjlkTG9vK0JkVXNvRWt4ZCtRTm53VUNaWlROTXFCQlVRV1JvSVJYdk1FaWlH?=
 =?utf-8?B?WTBFa3BRbWZReExRVHpVVFovREVtTzF2Znd2Ui9qKzd1cThXWjJKZ2dFSGN4?=
 =?utf-8?B?OFcrK3VGOGlqNkpxU294cE9hM3c2SS9hRzJKanZ4bjZPa2ZpUTBLbUNETUMy?=
 =?utf-8?B?YlYxc0hHbUlJNXFNcDFXT1JKZ0JKTnBTb3FiRWQrV0hIczEyVXZRUGJIT2JJ?=
 =?utf-8?B?SVFXRmx5djBLcnp4eVRRSkZuR2FEVEFxY3E2eTJKRXlJN2xnbmFibkNuRi9t?=
 =?utf-8?B?THgrRElJaG9OWWRBREJZTlZnVGx4NlM3R3pFQk0veEhVUHk0aGcwUXJCaDU2?=
 =?utf-8?B?S2FLSFRnVHdaUXEyekozeFZEMGgxeVdlUmtkUlpvWEVtcnpVa3IyY2o3NHh0?=
 =?utf-8?B?SHhlNmloRGlSUTM4dW1qNG5zaW5CeXVFeHEyYkxGNkQ4UkRIU1dkdlcrWGZl?=
 =?utf-8?B?bjcxejlIVC9aR0dUaTZmU0g5Y25Yc0pZbnVFeVZVQ01nc1VMeXZmdUtVRUpT?=
 =?utf-8?B?SHBxQTdDa0hiditkUzByV1pzSnRuUHJzVHlvd1k5d20zaEUrbm1lL1pmOWpX?=
 =?utf-8?B?Vk9RKzM3U1lTWE9XOW5TYzd1TjFmWEpVMFptUmJXNHVTSzYwY0hYZ24rQmw3?=
 =?utf-8?B?RGRoY2hvelVUQSt4TlhWQlo0MldheVpzbHNsOUpFMVBpUmd1OWdsYjNmZ2JP?=
 =?utf-8?B?QWdSWXlRZG00YWptZzU1Zm5BWHJYZGhPd0pDTzZ6V3RPSTNhU2UvN21vRUg4?=
 =?utf-8?B?KytZV3kvTU1Rdmo2dGJSYWhEemhFN0RpOUM3a0FXK3JaSS9Zb2w2SXMwY3c2?=
 =?utf-8?B?UzhsOHNSY1gySmVNOWVsRWNaNlVIcE5hL2MzbmpnL0llNUNRWnIyRTdPSCtW?=
 =?utf-8?B?eHd0bGJiMjROT0lEa1pRWFJVQWdZMDBoS3VLcHpOem0rLzRaN1E2OTRGblZX?=
 =?utf-8?B?VnB2dnZkbGo4UEtyZ3A5VEYxV3IxWndzK0pjN2sxZDlmZzR4SDFqMTBveFRO?=
 =?utf-8?B?Nkw3TytGQWJtMzd0cUd4bjJ0TjNiay9kVjFpbENlVU5reTJuaTdyTFJKVmtm?=
 =?utf-8?B?clBnenNDNlFFdklvdVpBRUwxV2lqTFM5NXpvYU9KMzAwSTh6Z3Jrdm8ydys2?=
 =?utf-8?B?ekxKcEZmOS9pZVB1TUJXZnNybmdiS2lUcllxWFAwYWlVbzVURllBRjJ6S0ZN?=
 =?utf-8?B?UkV2YTdrUnIrWW44akVGR0tJci8yaUo2TUdaTXZzNmlBYWdhWGJVRW1PVXdR?=
 =?utf-8?B?K0hrVWEwOFRVSTluMWdvMC9sdml5S1lFdENxT2ZBQ2pUSVREa0JqSDBKOHpv?=
 =?utf-8?B?QXZMY1VSdjdRbnR5YmhQK1N4YnJPY2RQelErdXRCMDNkM3BqVlQyLzJQOTI4?=
 =?utf-8?B?L0ZrZTBPTS96OXJqd1cyR0NlUUUrK0J3NmNWRmZBL1ZJYmg3VTZRbXh2L0xQ?=
 =?utf-8?B?Z2hNZVU4R3Jic1gxTkxnWmkzYnZXaVJpNnVIZWNVc25NdXRIT2w1ZWJ6aDJq?=
 =?utf-8?B?VlhBeDQ5dndhTlFNcThqdVd6R256TFJLVExhalNwNGtNVWJIcDJCY29QKzhZ?=
 =?utf-8?B?cW1iMGVRZCs2aFN6UytGdFV0S2FSUVI5RmxFZGFQV2tBdTZNQitUU0krWGw4?=
 =?utf-8?B?TTBlOWx3VGdXOFN3UWFRNm1wVklwei9uYWg4OERsaTgrL2dqVlgvV0NBdHFH?=
 =?utf-8?B?eWVqNWR5Z3ZadW0zTERDK2pIRFF4RkYzZzhJaVVhTmNoeDdSYVg4SGJyTCtt?=
 =?utf-8?B?YVQ5eHFURGxabE81b3RFUFBVc3pWWmhCOW9vWjljV0E0QXJkc0QwcHVSM0FH?=
 =?utf-8?B?Z2JxT2Z6VmZtV3pPZWtiTWpkZG1jbTNuMkk1dTBIanFuMkk0NDlaRFNza3lD?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J9Zr4jGnFJkZZmNCrBck+ePQ5R9foG679gj8jK9OHDcPbC2FTkI+jZgaVkWvI4BdLTctw6NxcF6+C5KoNJgUSJplrg/2LmjzeEDDkwIyTh9Oh3kieJw8s66IN3gCJH2/amqp7vyZD+G52471G9wJCZoRwHEYB897np6f/CTdu3mzT2i4I6PKHYKnIR4mtufCe/nPaGGL8vedw+0S5Jir9SDtzPB4ChvHNZzO9JbSTgE+8UX141FFXSHp8+m/QJ01o7UlU+TDbhS7bX2eFGomp6JbvXE2hYPMwKUgM/7MODQEU6TTRo7mpmTQGj6ctaPYPg65RSRmhh1fuHD9ipxozLDAKg8Q71SV4ewbkvFmRq/9DKY7r/oRHZnt4szb7atW19GYpQpV/EDE9v77JyJie9AJtcI46NYnNkMQ6NBBqDKbf829ELoiUpnG9vdylB3cuN6vRp85QD7HGmDwacdg2lUy/O/67otp5tKIVDevV0FSVPbR1DZq6pIuGhtEC0eIEHqN+Sdpu3vSqrKJDaafMjljM/tgR0q0ikTHDg74ChEf8wKUhGEi4FWDNegeoiqTldBtYnVsUkbAmh3dyybUYzlvxvtt0bmZXLbv1mo88Zs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bff563-e5b9-4375-a32d-08dcf811f7d7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 12:05:23.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WKcJgK3r9xQ3QkMIHNQJ+QEUfQgM/8pSJ8glZyl266bRQ2rKgobS03bAFCGKL4+Jzwg5Z6AV1UGjSggwe7Qzqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_06,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290093
X-Proofpoint-ORIG-GUID: V_2ktVux197MpgIiGNmtHuCV-9b2Kos4
X-Proofpoint-GUID: V_2ktVux197MpgIiGNmtHuCV-9b2Kos4

On 29/10/2024 11:55, Yu Kuai wrote:
> Hi,
> 
> 在 2024/10/28 23:27, John Garry 写道:
>> Add proper bio_split() error handling. For any error, call
>> raid_end_bio_io() and return. Except for discard, where we end the bio
>> directly.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 46 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index f3bf1116794a..9c56b27b754a 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       int slot = r10_bio->read_slot;
>>       struct md_rdev *err_rdev = NULL;
>>       gfp_t gfp = GFP_NOIO;
>> +    int error;
>>       if (slot >= 0 && r10_bio->devs[slot].rdev) {
>>           /*
>> @@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (max_sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, max_sectors,
>>                             gfp, &conf->bio_split);
>> +        if (IS_ERR(split)) {
>> +            error = PTR_ERR(split);
>> +            goto err_handle;
>> +        }
>>           bio_chain(split, bio);
>>           allow_barrier(conf);
>>           submit_bio_noacct(bio);
>> @@ -1236,6 +1241,12 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>>       submit_bio_noacct(read_bio);
>>       return;
>> +err_handle:
>> +    atomic_dec(&rdev->nr_pending);
> 
> I just realized that for the raid1 patch, this is missed. read_balance()
> from raid1 will increase nr_pending as well. :(

hmmm... I have the rdev_dec_pending() call for raid1 at the error label, 
which does the appropriate nr_pending dec, right? Or not?

> 
>> +
>> +    bio->bi_status = errno_to_blk_status(error);
>> +    set_bit(R10BIO_Uptodate, &r10_bio->state);
>> +    raid_end_bio_io(r10_bio);
>>   }
>>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio 
>> *r10_bio,
>> @@ -1347,9 +1358,10 @@ static void raid10_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>                    struct r10bio *r10_bio)
>>   {
>>       struct r10conf *conf = mddev->private;
>> -    int i;
>> +    int i, k;
>>       sector_t sectors;
>>       int max_sectors;
>> +    int error;
>>       if ((mddev_is_clustered(mddev) &&
>>            md_cluster_ops->area_resyncing(mddev, WRITE,
>> @@ -1482,6 +1494,10 @@ static void raid10_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (r10_bio->sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, r10_bio->sectors,
>>                             GFP_NOIO, &conf->bio_split);
>> +        if (IS_ERR(split)) {
>> +            error = PTR_ERR(split);
>> +            goto err_handle;
>> +        }
>>           bio_chain(split, bio);
>>           allow_barrier(conf);
>>           submit_bio_noacct(bio);
>> @@ -1503,6 +1519,25 @@ static void raid10_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>               raid10_write_one_disk(mddev, r10_bio, bio, true, i);
>>       }
>>       one_write_done(r10_bio);
>> +    return;
>> +err_handle:
>> +    for (k = 0;  k < i; k++) {
>> +        struct md_rdev *rdev, *rrdev;
>> +
>> +        rdev = conf->mirrors[k].rdev;
>> +        rrdev = conf->mirrors[k].replacement;
> 
> This looks wrong, r10_bio->devs[k].devnum should be used to deference
> rdev from mirrors.

ok

>> +
>> +        if (rdev)
>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
>> +        if (rrdev)
>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
> 
> This is not correct for now, for the case that rdev is all BB in the
> write range, continue will be reached in the loop and rrdev is skipped(
> This doesn't look correct to skip rrdev). However, I'll suggest to use:
> 
> int d = r10_bio->devs[k].devnum;
> if (r10_bio->devs[k].bio == NULL)

eh, should this be:
if (r10_bio->devs[k].bio != NULL)

>      rdev_dec_pending(conf->mirrors[d].rdev);
> if (r10_bio->devs[k].repl_bio == NULL)
>      rdev_dec_pending(conf->mirrors[d].replacement);
> 



> 
>> +        r10_bio->devs[k].bio = NULL;
>> +        r10_bio->devs[k].repl_bio = NULL;
>> +    }
>> +
>> +    bio->bi_status = errno_to_blk_status(error);
>> +    set_bit(R10BIO_Uptodate, &r10_bio->state);
>> +    raid_end_bio_io(r10_bio);

Thanks,
John
