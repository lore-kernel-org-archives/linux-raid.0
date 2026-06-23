Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091B2749DF;
	Tue, 23 Jun 2026 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782202301; cv=fail; b=VXds7FdKkpBScGIkiqipxDoA6t3tEU1DW3JGNXn/WZX6FWnhmmAMUMliuNFEoeJxmU4++MZ9gRLYQj8cOk9qGua92DFtmPbudznlVOoD9gGFkZ7d4CE/8ztEKeUjR7LJvMZW2KX5cYZw2ZX789uVdWKZEfju1I8fbIV6iZxbzTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782202301; c=relaxed/simple;
	bh=A3DfvNQjay2qTzWYCwcevIe7CEuSEzhVQmBxT6tqK4s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UogBwiZcvCCoM6Z7WDBPP7N+oIpBDE0LEy5dswaEShTG2wO3dwDHHEMZOt0uRTVz5IDSD9r+Yy4qIFAwF6Y2XEmmKndSch229dDYkxYwJ8VWSxsvKLjmEEV2kcYmm1+6POVKHgSUr5NDI+Imis1BObIxkpOc2VkentWC3POBMrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NeVzXp+Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vi6QqGj3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NeVzXp+Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vi6QqGj3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6NJfj3421017;
	Tue, 23 Jun 2026 08:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=psxdzIRhY53zTZO2RCarzoOiLqSVcSy7CncHmu6u5WI=; b=
	NeVzXp+Q6R26PmT0EuxpoWV51VApse+ylLvjBhOFbQU2aAXRd/PyBGG4e2mQfzOK
	89TdQa+RPg65Mx/ZbAGENo8IESxwvnmJq9cCDJWfRgu8Bxx6gnQrT/q4R+YidOHN
	mAywi7mv8EBP9Pj0iT8/piGKc02MrKVoIImMB9wUiEBn8t0WNen16v/Oxu5Z3eYp
	BhvjCsUMEwyrMWkRD4OnWgqNBeFoaZIk0d+RzxLVMtY6a9rHPRWOkbagTrsJW0X0
	2d64qspJ5BFfFu8I0s4rnTn+vyC23ByV/VXYUKUcYqAPIBgNvVquzOOjl/qD11+d
	jxK9ax14kLn51Ofs2wxtEw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ewh9c371u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 08:11:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65N837Pj016325;
	Tue, 23 Jun 2026 08:11:17 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011023.outbound.protection.outlook.com [52.101.62.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ewhabvqk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 08:11:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vg28nSMhevg8JUH7OUca7JCbbJ7eSWUh5Mz2no4edSDRom+Fq8B5ycP7zQekh2Avuz9lBXa9lcioGkjv88Z131g84HNRk+6S9/jS60FSxucCpB+30H1aepcA/43dDgggZ2G7mrAD9G+JnvGmu5pIFJYbeWNHbU200uof20GKYwbYcF7Z0m52jkS2robCSutiRcnOPsxp0FmIgEwfELhdJArJ1UrjzQMFmlClcxEbfyXUjkWsqk/092J1EGukS3vWXsLXerKiWVRosfHEclkPgYYKDLYTljmXbpLeSQzIvxaC+en7o1gE8R3wBdrKgJei9xH9r8h+C0h3sGMSbGQehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psxdzIRhY53zTZO2RCarzoOiLqSVcSy7CncHmu6u5WI=;
 b=Ww5qkbt+t8L86UVf34Ly8Q4yPGsAM+XNxADsNBb0iJKP4svs5e6GE962y6XIop1qYwEjWQ+/aCu1Yf7kVKDlRr0LvwvoFGHosmRCxyOiMKyREqO86rZM2ylDLSKWDODLNSyegyuU8afwPBF9R3SbN+sP+12k/K4qDRjUBsL6e7aG1c0FUUTzKQqldk5+pCBBr/Z7w6YlhLHLQFZKx+24s/XJzxPjI/eFjfNIqGIJLKnMrEN0Lu7DKDIBgNZr2+qv3LEbg4ACRwmsuN1ZRLvaWqVSP2FILS4gSDFFloO6PBWwCZdk/U8u/EVqA02YUfrxrfK/fv3k37w+6m7HCc1Orw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psxdzIRhY53zTZO2RCarzoOiLqSVcSy7CncHmu6u5WI=;
 b=Vi6QqGj3w14AQ6Z91JWFg+RMVVgRZadQo70vOVPCkDkNh+s8JqqUj4v+s3DRXHVQlxbqr1IUcNy5fDhIK9jztTNEE0UZIbX3BzINkqg35HIbj5Rou6C9HIrh4YgMU9UFkAoGiQjDxCGXUChmILZh5SgGgacN7sHpx3eK50gC2Qw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB5107.namprd10.prod.outlook.com
 (2603:10b6:208:324::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Tue, 23 Jun
 2026 08:11:14 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0159.012; Tue, 23 Jun 2026
 08:11:14 +0000
Message-ID: <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com>
Date: Tue, 23 Jun 2026 09:11:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260623072456.333437-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P192CA0029.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 173f406a-ba67-4b50-97be-08ded0fefe6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|3023799007|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Cu8+X7cesjMLyI8b4sKO0GPGawcl1KEZy8gaUHiM8cfPkl7AQM2cO9ffPyWTikhuUeQ/mNpSPamhwb1AbHaXDw7rJs3mN8XDRUOilQUQ2y9xVsqTREFM+I2PHEJWKOJhghRdXnnx33nWheDUMmcOPZJe4sCmBa7Mjx17oLrvmOM9vStAZw0fGeHBizdUqcVC06JMC1HhiRG64GzJxqnJWMYLda8oOyX9FcF/pZgDV/5PNZpp6VsB77TIp7nN4ofZ9nWVdU5CmDAFtdx1LzgPjM6wI5RG58EUYarSmXzFsvDBNSgjJ5tR6fwx7WwlTdt/45CLAy+HOPyG/x6KP1v7ytPFvNq4tZnpHbd2eopqkRc+PeQAU4HN3CFlMHo8LaE4oN0pgWEFI1UW4g7osf+d5C9YQU7l8tWY9Wok+ldRQ7+xtLBRHeg4osVs16SufvT+zocNc1d3fZ28ZcyITgpWkHVlRWi+ilkSjZqxLWtdaYj8vhRsq+F1TW8XvV54PX+pQlKAurEesJtgllK95r82mx+0RhGCXurKAzDANeq/9g+v5nS7Rbd/yWD5cx4przjMxtbh0PJ/sfxlop74GAi+ME5V5GdqrXnO0QssZ6r/jdeeqtM6rOukgw+2UN7IkqV4sAJ8BHCQkFuNch5LmEoOgQrMzZVR00vCAMBFJLZBCwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(3023799007)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnJ6dzlieE9qOXJzbDNRYWJOU1dXQjhpb0liWEpRUmlOMWU0Q3BKQVR0ckNI?=
 =?utf-8?B?MWRzcmNqK0NyeXNqZ2ZFNTY0S3FUc0Z2dHZXY01TczQrWmwvL3A5a2VGeGdM?=
 =?utf-8?B?RW1XWWhmMHJsZkg1c0FCaG1obGtpcVphRHR5YWZKOWpQc0ZvYkI5L250UWg2?=
 =?utf-8?B?dzJqSjBGNk8zbVZyVm9rdmI5WkxZQmdwOENpNkIwcTM5bmR0UWJYVWdWQ0dN?=
 =?utf-8?B?cGdsRDViNUh3cHJqREgvbFR6eXFRdEVROEpQUy80WEI0aGQ1UThKR0dZdVAv?=
 =?utf-8?B?ZnlhZHVQUkx3UzF0VUV2OFI5QjBJcjg3cnpMbkdLZTVSbnV2WDZzcml0bjE1?=
 =?utf-8?B?YWtwQ0w1ZkdiTDhWSi92WEw5M3lUM0JieTYvZU5xUk5yYWZ4Y3BnZ0dEY0Vn?=
 =?utf-8?B?YWovcW84K1dKbEVjQ2VkZW93LzNWdzZxcWdncGkvWUw3ckNFSUhRVW41bVZW?=
 =?utf-8?B?QmY2aU5CYTAxcEREL0ZrSHVCN0tobzkxQ3pQbVRlVHJwVTh3NTZ2WTZhWkRZ?=
 =?utf-8?B?VFZDRncxbWJXbm0ydnZGLy9kM0Y4S0llMnhFQUZxUkhRbEZrRVRjNXc5NUU5?=
 =?utf-8?B?L0xFQWtXNEdTcjBBM2tXWHFzck1LeXBiMFZwRHJXL0VyVDFoeEdKODgxczM5?=
 =?utf-8?B?RS9uVnJiNlFDRFVaYnFIT25UL1Nyc0N6aWhMSDVmc1dQSlBzbWZ3KysvNmZG?=
 =?utf-8?B?VGlwZjcvVCtLeGhtN3VhSm8yR0lDYWhrOHFFbVdveUsvQTZCSUk3dzdtWGhZ?=
 =?utf-8?B?cHhNSjdRSlZLWmdyUzRrZWo4dWNEb09HOC9EcVoxYTZBVnBLaS9lZXpsMW16?=
 =?utf-8?B?RTNLejZwS0hxM1RhaVg5Y2g3eHMxOSsrdEJOV2k4QjRNZWdLMk1OU2E1WVBk?=
 =?utf-8?B?MkNpUXJqcjdRWlNIZ0gwVVBCem9FUVZNeVMzbkg5Ty9ndVBzRWEybW1Tcklo?=
 =?utf-8?B?MkdVcnRvRmpGZGJDSURQZmNZQU5SYklBbWhNUS9TTWVLNGFTR3c5cFF0Q3FI?=
 =?utf-8?B?Z212Z0ZsbDV4UUFCMUloY2U4NVpZQXlHbzNJWWhrTnlEeTZ3VEhkWGw5ZE9B?=
 =?utf-8?B?M2dSTktscE1jeXNNVzRwMG1wUnJiS0tyaTBKN0FYZ2NtV3p1dEZ6bjNnZnFn?=
 =?utf-8?B?WlBjU1FWQXVpc0pLdk04S1g0bTZlbXdKOStjVitObmloUXdNOEw1Q0ZJTmIr?=
 =?utf-8?B?VlNsZVd3V2l5OGFtcWYybW1zSExlUFZUczg4VlkycVNjRWpUeDloTyt5OUFn?=
 =?utf-8?B?ZUdhbkU0emRjSzQ3SFpGYVgwSzFraTl4T3JZSm5OdmpLaVFvUk9HZnhPbVNy?=
 =?utf-8?B?cUZVaVhlcVB0dnR6REhqK1pacVRuSGRUZmJEdWwxU01BL0ZSUDl4UjNzTFRr?=
 =?utf-8?B?MXYvQ3cvZENnbllWZHVacEJoOVpZdktoQUNUQ2crbXl6WnpJS2RQclMvSHA3?=
 =?utf-8?B?ckVxai85UlNnUHppNHdSVU05NlNEcUczUm5vRlJwYXJ4YVFJUWRiclUyeFgr?=
 =?utf-8?B?OXRWbEYwYUJ2dTltUHkrYUtjUG90RElmSlRZUmlDOVpRVGtsZ2dndi9FU1ZT?=
 =?utf-8?B?b2VmWGFld0l6Q0RXNDFVTVVhQ2JQWHJsblZqZVBqblYyTWJVNE4xUFkxNGVN?=
 =?utf-8?B?WmlpWmd1RllSMGpod2xNT2QyNDM2MXk4TGlTWGtiRnowQ0phSVdmZVhzK3VR?=
 =?utf-8?B?WWpkQVdyUFZrZVIvUS9lcll4TFFZckNBSEQ3VTBjdlc2NmtML3EyMjBtcm9D?=
 =?utf-8?B?K05oQjBNT0dqSnBobXlVRVdVL0tta1FOSXVrczVKRWpiUnhrdC9YOXVzWVJK?=
 =?utf-8?B?Q2dPdEppYnlMM1dtM21pWlVUdXdWWFNMV1dzaEJCNFZtcXhZaktrcUhGSzFP?=
 =?utf-8?B?dlJmUmtoYXlPUWJJQlByWjRPdU1jYzNmZXdLbzZaeHo3RWdQWUcvUVhTazRR?=
 =?utf-8?B?ZHFubXZQZG8wOGdlM1c5My93TGgrYXlRS2NYaDRRWTg3MWJneURIZ01sWEZM?=
 =?utf-8?B?WHFkaCtpZ0M0ZFQ4bDJ4WlVRUjZzUzhvU3FibE91U2l3ZXptU1UrWTBjYWFh?=
 =?utf-8?B?MlBjS2JLamY0a0ErOGJHNDM1ZUQ4U0xMRDhUa2NCUzhmeDBON3FuamNTZ0pJ?=
 =?utf-8?B?RjEyTVNjdmdSL2k1d0tBQ01UeEdIZkN2SnNHOEJGbTNqaVJhbDNqdDJxNXRq?=
 =?utf-8?B?ZVF1YVR4SWEydUg4bEhqL1ViWWh2RktzS3piWmxRZVpoQlFaNkcrM3dmL0dQ?=
 =?utf-8?B?eVI4WTRDM21FVm9nMVlvYlk2QnRteWR2eHl5dTlCRU9IVG4wV2FkOHh0RGVR?=
 =?utf-8?B?Y2FUZ1dOL3FOY3lNYkh2ai9UMmFncU9OVDRnR1hCR0RaaXBNaDV0UT09?=
X-Exchange-RoutingPolicyChecked:
	SRjYzK5XzV8pTSudqVj1pemcHy1lQiekbu7wPZejvQWXSqZy2h0jirT3Wy9zGiFSPb7i8o9FAVm1AraqXO8a4fJQFms+iaZbBxfgprHQ+LTxbuwKZyYKYFm5VB0BnN4/9y4N69SDm88CtuCbYqyKzzA0qP0QQks3a003lC6Ukwi4THCrC66Tw3l+o9DkTY5PzKr6K8e96Qj/n6ww1Yj0IEoR1EPOqoLoorw3Akh7zSlWzh82i0s8TJ3fBV7kjH6OLUTBN1lfbpCNJHBZuTWWe9ahWq7Qt5PWOA+5fPcBugJJmV2wUnV4gdgdPBh1O4SwsI2XyUEuwyV/pVvncdWZDQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fyNFaoKJpOP9AJ963nbBfxwZNS75bxn7atqQT0SImBmaBD+o7QWFdqzzLZpBz8pwDSANKxXkdT5x9uQ906N1fQF7waYgQvplY4nWMriup1OU4n+zzqM5QePjZMHZzM3XEnTvxaxeFhxguPYo3j8fzpYuMxmn3QTFbr3AKk8Y7PwZ9ldcQI8jAypH7tMstiinIJ9tBOxPnAB9Vszy3z49AhP5BnNS+p8WjOWDZw1wLiQanLpjQ14BvAdODFxiFzdsfo4PgpNNRLx9DXFnhqe33ZR6BOKKQEavzrggP3ms4CCf1h4kX5S47deQf5DlWAvBL8kGwnZoZxT2s/N23hymI9SarRJUNPBlTUS9M1grf2XMpjX42KAYOYpHrLnLDYefvWRmPljJZpG/7Al6Jb9bJnOhVrB8mgTJHExTmG59lhvUGpJ3JlARKxmKwJVk8eOlRYbHsujSDJNJTP1vMpdu+dbWzK8pahvWLMBIZBdI7CepBqHvJM8v6YsusNrQrwGniScgC04XpOX//UdgbrWvVHwGQq+8H0Zl0CQHc6t4tYVwEiErSpZxSZIZNnwhZEGhEHMHZG3drhkSLh4ZmA8jdkf9csAxl31jEE/qm7ZsxqQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173f406a-ba67-4b50-97be-08ded0fefe6e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 08:11:14.4769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npWaqbwTc8jxCbF38w/yaMY/8ZDcuRdG7W4GuNzhaIzsx7QEK2n+yF8+/P6I7DM9NyQ0tD/6jBCYV+0UOMQIvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606230064
X-Proofpoint-GUID: TYa6VHclJnF2cmNerurxA8fKjAw7t6dA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA2NSBTYWx0ZWRfX4bV1P8IN/h2t
 CZSxDdGSKsZSVFCLH6jODqZBtRWqah0LlYOdyfYmZECHIZUIPelvfNRk/Nzek6WiqGJ6xPZhQz3
 KqdMQqN/SpyjJIrV3OtCCJ8Iz81sW8yaHFtDl0lKT1yHScHizSuo
X-Proofpoint-ORIG-GUID: TYa6VHclJnF2cmNerurxA8fKjAw7t6dA
X-Authority-Analysis: v=2.4 cv=Rd+gzVtv c=1 sm=1 tr=0 ts=6a3a3fa7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=pGLkceISAAAA:8
 a=9EQ-xIr0CRF3itfjUb8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA2NSBTYWx0ZWRfXwEb2xdVcO0Fh
 T60czXpwMiAaJoi9K6F2keQx/z2O+qLMA6PW4+Xn15gz9MybZqV6+nGCWk9/Um0AIjois/U5o0I
 GAQg8PuI2Zg39fzD6kMwaIMec1wMoOhOP468DJttcmagSBSCZWGL42k6dPL9cNsreMbnGxG9nd4
 An0YIqKTscyvTwq4SLNAqsZjroToqDt1dhOfhw7pECoe3Pfdaug36cVVEa2ZrO0qnNfiU3auoBS
 b4zLjTMkmrFi6w0WYfUqb/4oK2lNmMbV339guMXz8uyXoHQYtOBbER7TFnGom1o4csOyf8cMs8I
 Msl6RS+OsvbXioBR19P13u8+HvVMOnxqyYtW5NdvFkGgS8jdKnrfB9ZIfkynSds72Q95j6QEKCt
 6jdhJKoumt8HO34WdQmxDJoAJUvYKoJ5pUEBeDxSHcADyzBRD4pZQY/xfhfAc71tgvEg446UgaA
 j5WJtgAJJw8i8b7+Daw==

On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
> If a request already requires splitting when entering
> raid1_write_request(), the current code allows it to proceed until it
> eventually reaches the split path. 

The block layer should catch invalid atomic writes in 
submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we 
even get as far as the md atomic write handling. Having the check in 
bio_submit_split_bioset() is really just a fail-safe for the block layer 
not catching invalid atomic writes or the atomic writes queue limits not 
being properly calculated.

> Along the way, the bio may instead
> fail due to other conditions and return a different status, even though
> the request was invalid as an atomic write from the beginning.
> 
> Additionally, an otherwise valid atomic write may later require
> splitting because bad blocks reduce the writable range or because
> write-behind constraints reduce the maximum writable size. In these
> cases, the bio currently completes with either EINVAL or ENOTSUPP,
> whereas it should complete with EIO instead.
> 
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/raid1.c | 25 +++++++++++--------------
>   1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 86d4f224ffb1..8386d37343a4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1511,9 +1511,15 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	int first_clone;
>   	bool write_behind = false;
>   	bool nowait = bio->bi_opf & REQ_NOWAIT;
> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>   	bool is_discard = op_is_discard(bio->bi_opf);
>   	sector_t sector = bio->bi_iter.bi_sector;
>   
> +	if (atomic && max_sectors != bio_sectors(bio)) {
> +		bio_endio_status(bio, BLK_STS_INVAL);
> +		return false;
> +	}
> +
>   	if (mddev_is_clustered(mddev) &&
>   	    mddev->cluster_ops->area_resyncing(mddev, WRITE, sector,
>   					       bio_end_sector(bio))) {
> @@ -1592,20 +1598,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   			}
>   			if (is_bad) {
>   				int good_sectors;
> -
> -				/*
> -				 * We cannot atomically write this, so just
> -				 * error in that case. It could be possible to
> -				 * atomically write other mirrors, but the
> -				 * complexity of supporting that is not worth
> -				 * the benefit.
> -				 */
> -				if (bio->bi_opf & REQ_ATOMIC) {
> -					bio->bi_status = BLK_STS_NOTSUPP;

what baseline are you using here? This looks different to linux-next 22 
june and linus' master branch

> -					bio_endio(bio);
> -					goto err_dec_pending;
> -				}
> -
>   				good_sectors = first_bad - sector;
>   				if (good_sectors < max_sectors)
>   					max_sectors = good_sectors;
> @@ -1626,6 +1618,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		max_sectors = min_t(int, max_sectors,
>   				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>   	if (max_sectors < bio_sectors(bio)) {
> +		if (atomic) {
> +			bio_io_error(bio);
> +			goto err_dec_pending;
> +		}
> +
>   		bio = bio_submit_split_bioset(bio, max_sectors,
>   					      &conf->bio_split);
>   		if (!bio)

