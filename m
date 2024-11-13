Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6ED33086
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731493079; cv=fail; b=NGlYoIx8ljJW18sSHOd8gRS9jFYKU7SRo1OOvvjv8aPgdCQb28o9QhZK62Lhd2NZ34k+xjsXrKThvArsY5w/L27klbOK4pDTawGUyRzIqFeGqq6tVtASlRPxjS7ts/HCehPbD6WF6M9q4EpY/62oUYW0Pm7XUM42907x6VtMA6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731493079; c=relaxed/simple;
	bh=r5SRIVU5o7qj+I3/4oA4EMRLoelqZjiYGG5QlPJpZlI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SKjP4AxN8682bmvfRKVrKUVLJV6+BQ4Apt4GxPsfMgiXaaTtFYbD5k3JJz7734jiLHmRrW9CHSZxuKi1xR/BM6MF2rRVGFDy8FBYZD72eBN/bPnjpjZPYVMRRnxGNy+EPHYtnZ3E2SgfYvR0u1kOeQen9q++LxxdzxlexOdxxNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eqd2YTvm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jw0BC8wN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eqd2YTvm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jw0BC8wN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AD8c1JA017853;
	Wed, 13 Nov 2024 10:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bY9MHI2Y9qqYasvu6OnfWr5y9N2/83hoq1iDc3j6BK0=; b=
	eqd2YTvmyT8lILh8cr1Sy6MOYTxxuCmUoDc+GaQVXdH+V5EG8nTkoDtCgzYkgZee
	DYEhL6FTeMfw1g+Y0tc4dlOwHWiQXScN6Ab7noxtA9mVu/kOp52V/9dP576AUptv
	yLeCK+lGyl8pFGPC40aczBQOld51kMw9Zj4SOlNl8ZE8wrX3D83+joCnEIKl8TRY
	zhc4F2WRup6JhCILUY1BqdavTPqJC2Q6wuzoCMEFa5WQCfgH6vUgM86/opeMb6BU
	Vaw/6RmAa8qgffK7cG3LHNvxw31IA4IvVcOQyZsWgDt8+wOdSovfCiSeE610UJWa
	t1UjZ7gar9VuTRRX+YVtjg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwpf54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 10:17:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AD9e236025918;
	Wed, 13 Nov 2024 10:17:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6951fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 10:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B48hpW69VuKct1eNLrSg6+GwOwPnXJ18y3whxsrPPFV4kZkKYL3+ARVV3a3eQeG/Ymk2NPJP8BZPO734J5i4VeH67dPkcs8AMoSvAij7jQeJMKDgsWItdOCSkbpvrNyVFafkt10/9bzL4Uh87BIsiYCRv2IAwFY1c8u040DZSIpp5u5xW4wEi4kDIDendCdj7Zi2aq50GUUFiXyW/LRvRV1f4KU2Cw8DeEoFUBT6/GKBp0de58Y5I5eMpbTvfboYV45SgoDVPzwdXFDZo2MHg8Doo882y1nNC8deCUs1Q0e6dKMe2GvFqLYFtY/hNzup46u8dxThGxzbTLY2/7y5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY9MHI2Y9qqYasvu6OnfWr5y9N2/83hoq1iDc3j6BK0=;
 b=bCrJyXB1m1MRlxTu6icGFAX++fEXyoD7lcNK/aLFh73ESaBZzUD0PoBdAro0y6BKH4yMM6MFDCRI4IcmHXX9fyiE6ftIBsGDTop/7h/w9BgOiJu35Qd/tutf2etd9J1A6Bc+FZINcLoLs+XDr3xmNG3qlvwkuo8qbInSXPvfZFntwcIZTVB3MMbHlD/XXUPPanm3pByEEF3l05N6ikou89/0n4vUNYRdyK6b5/ntc+458z7RGGbpWJmwbjqGupdFeckFfzUiV0XXAP6pF/dj1Yg4dQ6Mlp+3aUGfC8NszEgwO5UXKw/p7/DyuqLiLddjmM1Iz89N+g+h1Dv0WWs++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY9MHI2Y9qqYasvu6OnfWr5y9N2/83hoq1iDc3j6BK0=;
 b=jw0BC8wN1DKGY6wwNg51YGQ1aguP/5f1VFKRCaReR81VDGJNuH5KqaEfB08AAQ04S6C1w7mOE36yX+VTc6G5OsHUjZjcLVrDrQNzqbsFXDnbb8Kivw2q7bEMY+KZLy7bMmVrDKLwM+TYURrBjeMiFsYQDDxgemfGUaPUtOBvwTc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7399.namprd10.prod.outlook.com (2603:10b6:8:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 10:17:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.017; Wed, 13 Nov 2024
 10:17:46 +0000
Message-ID: <46c9b171-25bb-45a6-ab4c-990815f5c68b@oracle.com>
Date: Wed, 13 Nov 2024 10:17:44 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: Song Liu <song@kernel.org>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
 <20241112161019.4154616-2-john.g.garry@oracle.com>
 <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
 <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com>
 <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0632.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: 076528ac-941a-4df1-708d-08dd03cc6b59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1NhUjVQTjBQVVc2a0tMbVl5d1lvbVNZSS9kNEg2MzBoUmZOSm9rWlZMbUJt?=
 =?utf-8?B?TkwxTHFHMHpZQTdTdTQzM3hFVTJ3VWdNaHRJN1BnV3NEa3E4dTVJcWdoTlZF?=
 =?utf-8?B?Yldrc3FDZjFRVHBxQmJYQWxLbzQ2dUx0YnJWSWV4dndRbXpEZ0Q3dXZiVzVI?=
 =?utf-8?B?RDZSTkdkRTljcGkwbDlsaU9HZWZCVXhUZ3k1citWbXRCWjNLUC9jN2tqb2lz?=
 =?utf-8?B?ZThkU1daWUVCczBCWkJpbFlYTW0zUnJLbWF0YkRoNDY2L0ErQllnRTgxSHJ3?=
 =?utf-8?B?K2V0cCt3dDllQnNzSVp1Zml0RmwxckIwR05JTit4Y2FHZExLRjFvVlpoN2w2?=
 =?utf-8?B?Mjl3clNZdnZzTnlmS2dNSmQ1S1NIb0xYTEJRRXBNUndVbWNzb1BBYkJta0dJ?=
 =?utf-8?B?TC9RYUFSKys2Uy9PNW9mak1hZFd6QnBKczJGVU9DRXU0MnJDZUM5ZmxVTllq?=
 =?utf-8?B?Ymt6bWJiRXhjS0F5VDJIKzJ4MEhjdEhFY2U0YTRHcFRILzY4bWZRT0pPdUZn?=
 =?utf-8?B?RWhZdFlPaHFyQ1YxUkpYdUQrSE1yTWY2TDVYc0xuWUo3SXRNaTlmSW45cGY3?=
 =?utf-8?B?Y1RmOXlzbGljRVpXV09sQnc1NG5YampzK3ExYk1sQjRHanA0SVVubUdWMFpV?=
 =?utf-8?B?STQvWmhxVU5qZm9DdVVPY0tFRjlXY0JoaVFHKy9vU0MyODl2cHFoMUYzdlRn?=
 =?utf-8?B?ZkhFMGhWOXVEeU4vcmtNbWFNeEw5TzNmYm9XVllsbWRSL2RsNEhXSDlKK0JD?=
 =?utf-8?B?TWJ1QkgxRHRvV0Z3dTVadllnbkdEaDJNZlBjUmZ4OUF0UXQ2RmE1cEZ5YjNC?=
 =?utf-8?B?dTlDRldDSUozZjFYMmQ4bEszYlo2Z3Z1SHpVS2lvdVc3YzMrNTFmTnZGQTFM?=
 =?utf-8?B?UXZ1ZkliMThtZmxEeU5MWG5aakdDL1BKSy9STnlqc2lRSG5KRjZTN255OXlX?=
 =?utf-8?B?NnJBbnFWNkZaQWFJejNtQUtQalRHb0ZzMzlEOXNkWGxQN2hIdjhNU2NKcThz?=
 =?utf-8?B?eFc1MTNZTWVCV051R3pPbUNwUzRXUFNic0xhcWZmazN0cUJsQi92WEpCencz?=
 =?utf-8?B?SVBZQ2xIYlMxRHBvTnhnRHlVUVBXZExJb1dKMFpjT3RZd2ZjcHlpdjR3aTI1?=
 =?utf-8?B?ckpjK1VGRFdCR0RjaExMY3cxR0hTcXV3V2ZqdTZqcHhLWVhrNTRXTnhJamZm?=
 =?utf-8?B?VHk5UVZZd0Z0ZHVxQ1BCTUlSZEtrL1ltelZZRVp0SDM1SzFselY2RVp6NXNE?=
 =?utf-8?B?bE94WERKSVY3QXhzZXF6UWt3cmQzQmZvNUxBNEVNaGZPZ3JSWTFEZjV0TVdz?=
 =?utf-8?B?TWUvNWE4OEcvSDJEK1NWbkFWUWZUOVBhTC9UY01XUnZuMU9JT3pyMlR5RDZi?=
 =?utf-8?B?RTVEdUpiZGM4NU1pbTNXSGhWNnpiU1d2UkFLUjFwYkhpc09nRHdpbXhlWHFq?=
 =?utf-8?B?eE9wSVZPUGdlMzZTYjkxSjRWYlZMdktMSHd2ZCtVUnlKUUExTHdvS0RxNkp3?=
 =?utf-8?B?Q1ZBVDdXc3dNUDYwZjJwaEpUZmV2YVAvMEhUWnNLU0J5M09VYWx3SFIyQXJN?=
 =?utf-8?B?RjhvOWZmSmExRkJ5TTFtV28zZzV2K1JUZVF6SFdNL28wVnpFYlBVZk1EVDFV?=
 =?utf-8?B?OEZBai9zeXFyUGN6eW9RbU5nTmhqOGVlM0dCMGJaRThSUFFiRWFVTTEzTVlM?=
 =?utf-8?B?emUzeVFPTmVHODdOak5nYnZ0cThRb2JVTTcxWEkzZ0JKUGpqNnFVcjFLNUZK?=
 =?utf-8?Q?ueucTiWgkqWhNVEsBopRgkIgWN/Ih3wLkHmrSQS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmVJNlB1dDZwRnVmWUhiWlBPTDdXc3JpVnR4cFJiK3cxVlh6cU1RV3J3T2N6?=
 =?utf-8?B?V0t5UkdhdUtvYmxHS1RhNE84ZENQRmVEb1dpOEgvUVFQbjBLencyRG9jdXFi?=
 =?utf-8?B?ODg4Sno0Q1ZwZXBTemR4RVZwWXhrNTI4YnFFaW9rQTZ3ZDNBSkxDS2hzbWdp?=
 =?utf-8?B?L3M3VHNiSzZPbE84Mzh1ZXhkTWpLWGNocEVjUTFDb01NY1Y5SUc1M3c5a1VZ?=
 =?utf-8?B?ejkxM3I3SmRqb0FNbkkrcXhBU0ozQTZLSG4vaUdiSHlJME9VcklhVTdYMC83?=
 =?utf-8?B?Mjl6YzF3em9OQWREVnljZnhEVDRXNFZpU0JQUzE0eTlIcHJmQVk4ZjIrWkwz?=
 =?utf-8?B?Qy95MWNFdmplZnFOQXo5SU1tdUhUbmVyWGlxUHVjSEhWLzlEVXJJUXlRZTBl?=
 =?utf-8?B?VWU2SFBTVEdpd0U4ZGpEdUQyTmdjY1RYbm5tV2hJZkZ2OWVuSm5oUFM0TDZy?=
 =?utf-8?B?MEs5UERQZ2dGS1c3Ky9oVHFxT0VESVc3TGczYmZEYzRIVjBMY1dhK1V2ejB0?=
 =?utf-8?B?NGtzQ2x5aGN6QS8rZExCODEzeEpUWkVFdThVOWxDMmM0bzhqemgraDlxaCs1?=
 =?utf-8?B?VTNSRWplYnNsODNwU2xjd25SSktwYldsV1BvaXd0R01Ib1g3aW9KYzNsb2Zj?=
 =?utf-8?B?a29pblFIWFMwanFqTEIxc3lVRFA1K3BxRHhjYzY2Tm1DdmRHcG1MUVpMZlJ5?=
 =?utf-8?B?RE0wWjEzWHpxTEJWU09rMnZDVUoyQ1VwSWhKZTgvbWt1V1psNmNRYkQ3MHJx?=
 =?utf-8?B?Y1ZveU9QanQ0Z1ZoamVqUE9jM0dJcktOT0ZXOHBHblpSdC9LTUdReDQwNkpY?=
 =?utf-8?B?MnluWVh0V0FIMk5ORWxjMWtDWWE3RC9KdmFYMWV2N0NVdFhYelYrTVJienhI?=
 =?utf-8?B?T0hrNCtNTlZuZ0dGcXlzNlM5TUhUa21jQ2NJSFNSeUE5eDNTOGlETUsxWjds?=
 =?utf-8?B?bHB0aTE5ekZaakloRzluTGt5QnhObWZpcFR0OHY5SzJYWDVmUDhVdXczTjB2?=
 =?utf-8?B?VUl5R1lRUXVXRWd5ZmhXalNnUGFicHJPOCtnM21pTHR2WjR1aVFoZ3puTnpu?=
 =?utf-8?B?aDM0bStMQ2ZPWFRVMkptWVJKTmVjMFhNSlBwMXV6Q3VwRlk4dGlxbExFalg2?=
 =?utf-8?B?ZXIwVGxtNU5IdWFmbDhhNVhoSUFOb0FFVytVbmpUVzU5MXBNcW5qaWlTR3lS?=
 =?utf-8?B?TW5wdktDSXkxMGZ6c2VhRE9vamp6cXZBRnM2aDhvYjlhTEJWOFZ1c1ZlT3pW?=
 =?utf-8?B?aWcvd0w5U0RsUERZWmlaMlM0c2VjZ05DNnNOZHhhZkt1R3Bwc0tpb0o3UnRR?=
 =?utf-8?B?MWs1aXlMeXFKOTM1WGJyMms1ajNlcm9YM2VDM3pGa3NMUU51L0RLNjR4UjBT?=
 =?utf-8?B?NXNEYmdMdFVkaUdIeXIxS2hpV25IeDZPREh5bFBwRXdFaW1iMVYwZVlNbDNF?=
 =?utf-8?B?cDkvcFBETi9RQmh3bncvM3orWWZRY0hLWnhrM29NYWxEeDRudnJ0ek92cU1Q?=
 =?utf-8?B?aUdSeGJ5WkkvNEdhUTYveVdZZW9mQnpQRU4wN1kra3F6WlFQWmpTN2NsOWdr?=
 =?utf-8?B?bStwL2lGajdYQmV6V3l1MFFrQ0d6TGR1RTlSTVZlSmk0L3NWUUhxeklWbUdr?=
 =?utf-8?B?SHpKNllCVHBrQ0EzMUN1SGZtOXpLTU1HN2N3VS9mUkQvdGxlSS85M1VPeVZo?=
 =?utf-8?B?b2RMWnIyNERJVkZWTFdtZEVxcG02KzVQdjFnQWFtZlMwbE1DM1RBdFVsS3NO?=
 =?utf-8?B?anVNckkrN0gxQXhkbEx6M3pTeDFRbXBmQzVGK1RtcGZvQUhtSUFpMzRJeXlO?=
 =?utf-8?B?OGVxS2s4cERmS1VLSHhSY2JEUjAzOE43ejhtcjNTc1o0ZTN2UFdMYU5iRVFX?=
 =?utf-8?B?Q3N1U3pyOWs0eTRHeVFVQVl6bDc2WU5WYytjOFVsaE1OVnF4UGRKV29Wc2J5?=
 =?utf-8?B?UUVnUGxjOWFnSjR2VUQ0eUpUa0Y4bTRXN0R6RzI1OWRFMjdVbkhTRFkzYU52?=
 =?utf-8?B?bzI2ckl0dnpaSFd5UThORGRkTzRGMkN5Si9nemtsSldqQmVQYjd4UVdFL1FF?=
 =?utf-8?B?YXZzQ2trNXFCcjZYa1FIRzlQa0FTQnIzYjQ3Tkd2aHZIMld2SFBHR2lrTGRM?=
 =?utf-8?B?OCtyQ0VpcVJPQWR0aWpTTjVQUkpCTU9OSkl2UnlpWlovdi81bldoeU9hR2s1?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AKfi0tG1R3DML3IvSqfKf6eYTTluODDJOPSJUNuhM6Jk5aKcqcjmvvWnmx7lQVEq6HcY88gtTx+6FeSc32pozVBlUeShlFLe2ovKpbBUU/RP9WsMXf9VGjeJSgWRiY8X8oNQ9ZHbK7b4ipfkZQdPtstJm1fU3dYTjJWWbt5fSdBYoqtQ9kqDTDrskJrAiG2yQiLnfvc+0361ThKhDYFS5OoRqceejSNcVegvru9BpzWMP8Rb8ID8H4d1VTwunLZAAyZxp/Vc4G2vn6Ty8GqWb05dEW/gN7gBgs5O9E8WXatJag7IQKDPFXRVJ6gEiPqD7Vi3ibYDx8Mc460dCpYGF2WT6se+qwvviRFldHkDY/oNUH2VHwmbw1QZNSZ2k0RPaezt08f6HNcMFjqjCkIs3jwE19D4lh5krAfhzDTBJ3xXWsOsC2rtRKaKkjgShpup5D00gKqKAMY2I039120qoJDMSVHfjbNRv3nO0Nq+prrkJw+R7Hb04qqZVHvBUgFugdKM0zGpa+kMKMrmUqjveLE9AsvXhrp3yv2tzoUs7np9llZoSJt9xxNZbjdyDxLl5XlNe7sfY3ky6b0flCRRiV0yITYFhYYk6yZbUKhSDmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076528ac-941a-4df1-708d-08dd03cc6b59
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 10:17:46.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs6OJjFhgvJdfZApBOND/hEPW2ZVPwtZlesHEyQ6gLP1DPY4ajseZ6PCMHU1pj5ZgQYltR8UGlWPXJSaZl2lSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_09,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=899 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411130090
X-Proofpoint-GUID: kGgkP5MUolSd3SeGKlwYAYpVfoilkfMv
X-Proofpoint-ORIG-GUID: kGgkP5MUolSd3SeGKlwYAYpVfoilkfMv

On 12/11/2024 23:05, Song Liu wrote:
>>> WDYT?
>> Indeed it is confusing...
>> So the string is "raid%d-%s", which is
>> 4B for "raid"
>> 10B for max int (right?)
>> 1B for '-'
>> 32B for DISK_NAME_LEN
>> 1B for NUL
>>
>> which totals 48
>>
>> So I don't know why/how 38 is ok. Maybe there is some auto-padding going
>> on, like you hint at.
>>
>> Maybe just using 48 is better.
> Makes sense. I will update the patch to use 48, and apply it to md-6.13.

ok, thanks.

And let me know what you think of 2/2, I am even less happy about the 
solution there.

Cheers
