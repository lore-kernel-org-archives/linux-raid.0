Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1A31114;
	Tue, 23 Sep 2025 08:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758615703; cv=fail; b=CVWq9K9fPwpDF5IuILQOOMCCfLc17hP4Ytbdo84nVh1ar0LfMNoLhAFk4ToqIhBk3DR6Qqy1R99YuVHd2hYBiuARGZ/fkfgiiwAtr1m+kX4ShNGMQvManSEMD1/gZcRCTyeZlWkOoSB/LwiqnxXBPiRJDf4pUpWS+kvAplf/G84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758615703; c=relaxed/simple;
	bh=PRG7vTqwZ4xN9aDjJghtdi9Ms+lmCow/KhNXHGMhQfY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EOVmUQdNv7b3BFgQiAmZ9buJJgozGBR4RV0ehfnlDOT8tulel7eKV5inYEYTQM8vLs+BjOoQnua2gg52UtFEdDb/IjOgLcIbN4qNZN8iE0ZGooOvpMyDEZLm1Fm1xyN5qXAlMvVE0JM6jTsgXUbMNLaZ6yG7mB+N9Yp3xOAyLK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cNJayF71; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yUklciU1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cNJayF71";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yUklciU1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58N7u5DJ006814;
	Tue, 23 Sep 2025 08:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M3mr8FueGyTkQlJXcZA+cVwGxQTJKgoisL6zKXJAh/w=; b=
	cNJayF71BD6oExP5/M0P6f/n/F+zupefq0Ja2f3rss9Oe1YI/iPAvqwsciYhLV1n
	4k/6sGQN71mrw7txmlrKwXa+Rgz0PZlHAfc8lm0GBJqo5+xSQsyjMD7vH1Ob2q20
	9BXCwNqbrd5WU25B6GGTvP4nzYvgBZ01g8++9ejb2sjc4bI95xPjx2r/FRmdjpbP
	Ew3PwszDLETB/h2XlGND5UM0LOFQKdaTYLiRQVQMc70Tu695DKh/i1aLNnXZkLzR
	hErjZ6YzbK1uCew3K1YiSnsr47tYs14jIgd2gyItfAiArB948q/6f7oGKRsBplSo
	8VO049qpuO4k4lQgjUsnhw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499m59c2f0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 08:21:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58N7h5XT034371;
	Tue, 23 Sep 2025 08:21:20 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49a6njb3dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 08:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahSq8OfxM7NBLHnuyC4mANjHK/Ikl0uNQ/tI30aRUj6EhCywNqhVB24K0I7f+vioM4zGq6X1ov3XCLbpar5VKSzNrJA+40aFwaW4W2tcEwxPfAbc/+RMBKbROnEj9xjLFQEH3Xop6RR6A4RB1SU5CBd2Ng3dbppBrVCunx3V2GyDG+mGw57WW+qa9v3nzYwYpWxsUVdjFEELItNzG08XvKZlHtS+P42zJmhxijdFZ5qfLeyH0vf8KKpx0GK1jcwq7TKgut7Fnh1r5Ri7SC+mJj7sx38c9oUbdBXgZgUZHvxw3hxpkwNFS3uJrubBYRyCN56m3SVHjF2Ek6gvVNaPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3mr8FueGyTkQlJXcZA+cVwGxQTJKgoisL6zKXJAh/w=;
 b=t6NemdXgOIXboGbDJmZfjk6HNEzBi3yXaFNbXfv46MBh2S/tQx0XWiLdfaUyIB8xIxAUzWG2yfdcNbvw57IEeFuJWnMt93g4gug56UO+QJiOfWNUugLHeL+5kGyHv9IXWb3i1PC1mfnPeVuXYHGLT3mtLQzN6BjfEpt2Se+ueZ+kGx5L///BO9QRLGQ6WiVepYR11GTkgF00QUqP3pMmhxrd56ZZaCl5oYwgI+NmQZPuDAYKWGdJRLesGso8ZeUQnZ9yNnATNk8ItjAoeaPHM6IldlO+X5xsuLBijVs4rHuGOp2HIAAbm+s8yy4Y3Fzy56oDz3NpMtWfQ2PXTCTvcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3mr8FueGyTkQlJXcZA+cVwGxQTJKgoisL6zKXJAh/w=;
 b=yUklciU1rhFfRAy6Goxt3FjC90WTnp6GjA445x4j878+6DJhw0aSTqzghRVqVPD2nOgpkRRr0hNTeuiuGqI21UXRMTn21S6cb2AU4yXKQh+Z6+lEnXz+Al/4IT0w5l4zKwNgfjhdByiYji0TKOPsIpWl6fQ+maScnNQ3u9aVGCw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH8PR10MB6671.namprd10.prod.outlook.com (2603:10b6:510:217::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 08:21:17 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Tue, 23 Sep 2025
 08:21:17 +0000
Message-ID: <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com>
Date: Tue, 23 Sep 2025 09:21:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250903161052.3326176-1-john.g.garry@oracle.com>
 <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH8PR10MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: c4cccfdd-cb3a-41cc-0fed-08ddfa7a2aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWZqdVV3dkhiK2VrYTFOZG1UdG9KSU45di90ZzZPalZUVkFiUmN5WjRJd2pk?=
 =?utf-8?B?TTR5bEdrSW9Md0hkaFFCdk1UZU91bktZSStuYVZxV3Y1SGY3ZDNoVFdwaUVa?=
 =?utf-8?B?WWFHYXRqVHpFZStNdVhPQUlxNEhqSzFuV1ZQT1BHWG1EMThHSjhGQXNJSy9i?=
 =?utf-8?B?N1Y4aEhXVXVRR0lXa21uMHh6a3dSckt0UFNYMlBYdlJkZmRCYzFEVjJlWGU4?=
 =?utf-8?B?RjlxWWxwVS9qaTVTbWxrdTl4TjJJcldDenl2T2ZnT2taTzN1NTlCU2tCNDJL?=
 =?utf-8?B?RmltcGFGTEJNMXpyV21nL01KZkxZUENkeS9LNUlnM05XVFFRYXNiN1V3Sm1L?=
 =?utf-8?B?ZUFCQWVrdkR0dnJGLzEyL2FpT1dzemxJakg3TWRubzE4cFZrSkxLdlo3S2hv?=
 =?utf-8?B?SWsvSThjdUI3dHh1Q0NsTGt2dFo0TmdlellzUkYyMk9BZk9NdEJTZTFlanNh?=
 =?utf-8?B?ZEhFalZ5MHRtZkhHL1FkRGo5c2xxbzB2VjBCTHU1dC92YTlYODVBcFhkNVJS?=
 =?utf-8?B?bDBDcWwzMGNJSGxkZFAwMmZXUWdaSjB6ejdZRUdGSU5hSGlPckUxaWhvaEx1?=
 =?utf-8?B?VG5zcUpYcm9kNkZyeGlmMnRFc20zTEthWVhRTklrZ1dobzhVVW5iOTFQTVhM?=
 =?utf-8?B?QmtTb2p5WEVuWldKN2g5U3JoNmxtR1YwN1JHYkJrYTg2dVJ5QU1HQngxaVZu?=
 =?utf-8?B?YldWcU81eEhLNGN6ZkdJelNGU1l1VVNwNytOSEFMdW9zUlRLUFhZeWVyVUV2?=
 =?utf-8?B?TmFsQjEvZFJ5dDdvQmlKYVRFS2xaWEpSZHNjNmhwRUl5ZFhBU2pkVkRVWUFj?=
 =?utf-8?B?c0hkUVhUYU5vRzRBOE1tWnZxc0NlSlhtUEFQb21oN2lOZytkMUl5aHl0Ryth?=
 =?utf-8?B?Y0dVRDBjMEdPam5kY25XZDB5U1FIeE41UTRSa1BWZCtzMzI5ZCtIanYxWGhl?=
 =?utf-8?B?SXIvcmd1VFF4cGdUcWVFZFhJVnFGc2VaOENTYmFzVUpxdVZtZUpqRG9kZS9H?=
 =?utf-8?B?RzFld29jQkpEdHE5ZnB6eUgrS1cvRjhpQ1VDRnJjb3RoQ3RHMlIxNVlHWVdP?=
 =?utf-8?B?ZkQvZzlobHpEUlZUYlF4dTVCWDlvc0RxMG52c0M0K0VmZFduTi9KcSs1eHdP?=
 =?utf-8?B?TSt4VUdSMmdDWmhOTXlPOFg0a1RFaVprdnI3NVhNdG5OaEJNNWZtSXJPUE1o?=
 =?utf-8?B?clBxeDNXNkd3bVdpQkVycjlIZXJUOXlmM0I2aythSmdrdDRlUkVmcEVickV4?=
 =?utf-8?B?VjlZRVlSV1NtMDc1MTkyQmVhTllxMlJ0d3JoWFRjc00vV2dOZ1gzSGczRXVw?=
 =?utf-8?B?anlrWGpScVZSMERWQWFWeGlUWmlzWGtxcHcvSXF3U25telhNVUhBVVljeUJz?=
 =?utf-8?B?MEtFdlozdS8xQm1vcUdQaXp2VmR3RktjVUxtV2UxdisxQ21XUXNjR1BCeFFj?=
 =?utf-8?B?bkJTWTM4ZCtIUUZQYk9YUzRpRU5ObmdKYzcrMktOdXk5QUlhd3ljS29SdjFn?=
 =?utf-8?B?RnRMNll1emk0Mkc1bVlVNy83RmxSN3FoVWJ4Sy9zMUM4dEtsMS8zRjA5QXdx?=
 =?utf-8?B?b0FSN3ZESFFQVXV5VStvUC9zdCt6NzRuUFdTL1QvVUJRakZwZmFUaHpTQ2pr?=
 =?utf-8?B?dGVPOTVabUhNTlAvTXZ6TzdtR2dDTmIreitaRUZySXlCOVY0UWNMSXZlVFoz?=
 =?utf-8?B?RFJ0d0dOMG9WUUt3dU9ZSE4yL0pHODE4YUJRZUVlbDNmZno0S0kyS0MvZjZi?=
 =?utf-8?B?RGorcVFSZElYSDEvM1hQTTlGQnRvVG0vcUVNenQvT2NtZEgyVTJ4Z0ZpQWJD?=
 =?utf-8?B?d21sRWNmOStRcDZ3RlFTSkJ0dTNvUFc0Vk15YThPV3FRajZFYndDN20wQURQ?=
 =?utf-8?B?OXNTOFRqV3RCMXhZRVIwUDJCdG1Wa2kzUGxaNm5xMDBidTUyeG5PdHdXbzdY?=
 =?utf-8?Q?tL3ubbmiyNU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUNsVmZzM2F3biszWlRpek1RbFVLbFQvSVQ2MGZsSUN5SmhiTGZhQ0dnNkVT?=
 =?utf-8?B?YjdTNWYvMVdYN0lJckgyWnM2bFdlZUpXOWRqUTdCaCthendSa044ZnVzWXZk?=
 =?utf-8?B?WGVjdEkwRU5nMm1UNVpDY3RFQmNxSU1sTVpqV0Z3eVl0TmZ3N20vcmFWK1B1?=
 =?utf-8?B?OFQvbXdsZTFmTmRWWkc4RFY0bXE2aTVXUll0N3E5cVo4MW5ZRDBpcUluWnZ4?=
 =?utf-8?B?THY2U0s0ejF3L3F6TDZiK0RzS3dGT2JuaS91emRVeE5YT3RYN01ucmZPcVI5?=
 =?utf-8?B?L3UvZTBZS203NjJjYTlXYWhWWkpQUHVwWGhpZEZZWEhydXNmRzRWa1NhMmd1?=
 =?utf-8?B?Y3RZbmRwMWtyKzRkNkVEMHRiR0hGaUZGUnZFVnFyd2dxL0JQTFYxZDc5aEht?=
 =?utf-8?B?ZGtWcU5RSHhjWWdrUG5uNG1tMFA5cktML0xidUgvbDA1VUwxRUhxVldFaHVj?=
 =?utf-8?B?bDF4ME5IY2hEd3hjdWZHZXZMYzA2c041K2IrbC9tQ2FJNVgwSnZQS1Y4cjJL?=
 =?utf-8?B?cW5QTWNNOWxUUkpaM3hSSnRYS0R0VG5DblpLWkluQzFhT3EyaFZoYUxHSlY2?=
 =?utf-8?B?S1JYYkV4L29MTVVwMG1wU21NdGc1WXJ1OG1lQit3RUVIbjB4SW9RWDBWUU1o?=
 =?utf-8?B?VmZvaFVSN1pUeitSYmNxNlEyekRJRGNtTUJqWmNsbUowVG1oUmZWSlBReVFW?=
 =?utf-8?B?YUVObDBwNmZtdzdnSWI3VDUrS3BhM3JuQ2FjdDU5bWJkWjd5ZGNjbW0zajRH?=
 =?utf-8?B?NkwwdU9jVllmenZDa0o2Nk5ZVGV3Smw3TE90N1RpM3FKTjYzUEEyTHhzMXZV?=
 =?utf-8?B?aDFwQlZaVU55UFZ2YllCanZBLzM5RkR5YVQ0cFdkMng0YzNPbW16MlUxV2xa?=
 =?utf-8?B?Ykh0ck5EYjUzZ0Z0YzhqMjlOY0NUNFp0L25VZytCdWhEN0xTZ3J6SHlPVTRW?=
 =?utf-8?B?aWRGM0JVb0UrQWtreUwwMGZIQUFGZklVbHJRd25HOVgyREp0SnRvbkg4UWRR?=
 =?utf-8?B?cWthRXBqWlZ4QVZCUElGVU5GVEJCdGJKNE1WR25pOTJTa3k2bm1YOWRmbUZV?=
 =?utf-8?B?SitidUtEYUNBVEpDNUdyajJkVWlzODA5V2JNWHhKeXFUL25LMTdhQjRQR2Jj?=
 =?utf-8?B?WUNKSWprMEJrZ0FqYVBjcW1tLytSREJyTmtnVlJ0YmZNZkpzcldFbjZ3dHAr?=
 =?utf-8?B?dUZOa1N2aE9tUlBnbDQxV0s5d0IvcEV0RFRsR251NHo5bXh6N09qYUdQZDV0?=
 =?utf-8?B?c2dVaWczL1YyenFXeGdJQXVXdGZ6TG9VdXVVWG9RQktTc3JUU2hyWXRDY2d6?=
 =?utf-8?B?UkNza2NPRzhjc1NFZXVVRm5oeE8yMWVZcGlLS1ZhMVVyalA2WTVzOGl0a2pu?=
 =?utf-8?B?eDRMMGRuS2Y3OGd6b201SEhDMm5NT0ZQeFFPaUY3L0g1cWFpNTFDMHZwSi9G?=
 =?utf-8?B?TVpsOFFBYkNVOEdrZk9uTkFIK3NiQ3d0cVlKS1Noa1ZPMWJ4ZzAvbDgvVWdW?=
 =?utf-8?B?WThwYkdUa2FpdFBsQjNhV3ZtMEI1NVZaVnUzUVU5VURSZ1FHd0wzR0cwelZG?=
 =?utf-8?B?UlVqT3YwOFczaGU4emhQMXdaMDR1QS92eHI1bWt1NUQ1S2VpZmJqc1BxcTI4?=
 =?utf-8?B?YXpmSkI5L0UySFlZUWZUUmU4cFNTdlN3OFlkUnEzOTd6aEtBMzJGWStUR0tI?=
 =?utf-8?B?YTM2cUhwQ20wSmZFOG9YQXNsbVVkcFQ4L1R5MDZpQTlBa0R0cWNLdjBwNldi?=
 =?utf-8?B?YWhqUU1kTGdqL2VVSkJTenpQRHNGNldOVFZXOTFudWVlN3lOc3Fuems2L1BG?=
 =?utf-8?B?OHlKWjJYWG1xWUYwWGQyMXVVV2RwN3FPVlQ4aTVPTG5MQWdFTTc0czhRTFpy?=
 =?utf-8?B?QXFkb3dTYnBmVy95cE5SN1B2N0xvTUxBZHVNZk9LWjdKUEpJY0lSVENHSktM?=
 =?utf-8?B?Ry9IczV6alRObFBWRHVhTlN5QitycVF0MnA0OS9hcVJvUDlkMlJnMFFha2Nq?=
 =?utf-8?B?SFhER2JRSnpSRFRRNEdaZmVESC9ySmZrcFZzRkR2eVNFc0RLWmJEbFdWeUth?=
 =?utf-8?B?VmNNVi95b2dWV3BUWU9WZzc2TE5taFFyQjZMc1F0V3hDOUxUOWYrSzM4M3Qv?=
 =?utf-8?B?czNHclpIT3FNWmNFalVzdVJoNjNHdkk4a290TDRvbU9kbW5mV2tUQzJGSlo2?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J/8tAJlXyCWdnm4jpdSE6nOZ340jXKbwGFNddERa8qy9v/4G7nzJioLlycfFVWLk3AhodyAIeW0r7dhM5x/smshTZ2A7tUshUzWtH4zCN1Pb/NJ+kZCKhLsA+w67/TaY0QMxzbH0LvLgXBaeBv73QG7u945xQxMHKkQEKCdbZeWhZ1pg2NIkv0bOQ/yeH4AL206Q3gjTgg4ceItOhLRjwBRx3GHighxZKzsw75otm6AnmbDqnfpp5UDcwEhZtOLxlE6mQIidjaHu0kmkM3ITfZ7XEK9b7WMWn4mAlpHATXXMX331u2r9kbYQD144OX5GVVWbiTg/oWILP2Wl5DHPwWvnEBjHT48nNYT1r99/QTbejiilgoKEhA+CyKx5XxppE2tjoGNaSJWdGIbFRdYztNpCzoj2R2yqLsZsKKqSpZRxDkmRMGjsHGipdvF8y/briBtN1XK+WX3iUJNiHkgMrv+DkgcJnrZRhInwK4G6n4eLtnPACNA2OrL4dOvSlDI2WV9fHPWwnJaOkosPI9GAMGioApaCS5dsn4rfISwh06jOHWW7koKYxxpsuXzkf377tkugmTXIY0ZBNwKprSUG5RXxw6hrkGjenmPwu3AZCVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cccfdd-cb3a-41cc-0fed-08ddfa7a2aed
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 08:21:17.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZT5lyHncZ/BIpiGOE8Cc6W2YNL5B3W4jVuan8JxDXnPKh9NYhFB/iuKCzEzfmgkT6wYWkczwYVsVlrSLnpOdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_01,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509230076
X-Proofpoint-ORIG-GUID: 6q6-fYNE3yGhCT9YsoI9fbarxxZ5lWUm
X-Proofpoint-GUID: 6q6-fYNE3yGhCT9YsoI9fbarxxZ5lWUm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyOCBTYWx0ZWRfXzLsFwwyryd5t
 k/tnI1GizDYj94SRMLbPjWKXbOA0wsTYFkUQC7cegDae0sMOjWOytN1ImX9WVY4uyGAwrsmXkQz
 LLdWDPrJo7kSA6YujjY4YgBIxoQaICGwQQ1FdymiLj4jV3WBbWOHI+jWjW0ZJ/JVcmGpSXCVMmm
 jne/Bv/g8ylBJkIWgLJtHQCtxtNvcK1sduaEQ9cOIYVfxWa9Y+H0P7lm7xbOs0c3BAvoipdJt+x
 ESTerGKxzVPT+RP5G0KA2o+1fGSdCXgKSfAW2aOCa/NyB4UnoFgnVUL5xZK1u+oEZl1Vvfl0zqM
 in9Ee4b9CLr/biPNaXCIH+bYrdPkLjIRccai5QQQm2bae/Q4mxloLr85rgz4A1qS+sg5m6A7663
 5938luWzj6R9QLCujyV1LpG7WKG+tQ==
X-Authority-Analysis: v=2.4 cv=HJrDFptv c=1 sm=1 tr=0 ts=68d25882 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8
 a=VOirtW5yCBhMmUwYzE0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13614

On 05/09/2025 10:02, Yu Kuai wrote:
> 在 2025/09/04 0:10, John Garry 写道:
>> All the infrastructure has already been plumbed to support this for
>> stacked devices, so just enable the request_queue limits features flag.
>>
>> A note about chunk sectors for linear arrays:
>> While it is possible to set a chunk sectors param for building a linear
>> array, this is for specifying the granularity at which data sectors from
>> the device are used. It is not the same as a stripe size, like for RAID0.
>>
>> As such, it is not appropriate to set chunk_sectors request queue 
>> limit to
>> the same value, as chunk_sectors request limit is a boundary for which
>> requests cannot straddle.
>>
>> However, request_queue limit max_hw_sectors is set to chunk sectors, 
>> which
>> almost has the same effect as setting chunk_sectors limit.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>
>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>> index 5d9b081153757..30ac29b990c9b 100644
>> --- a/drivers/md/md-linear.c
>> +++ b/drivers/md/md-linear.c
>> @@ -74,6 +74,7 @@ static int linear_set_limits(struct mddev *mddev)
>>       lim.max_hw_sectors = mddev->chunk_sectors;
>>       lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>>       lim.io_min = mddev->chunk_sectors << 9;
>> +    lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>       err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>>       if (err)
>>           return err;
>>
> 
> LGRM
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 

thanks

Could I have this picked up now? Maybe it was missed.
