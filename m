Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382630C60C;
	Tue, 23 Jun 2026 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782206440; cv=fail; b=SubXWcEThppeCgOBb5XqyL2AcxUia7Gvtj0EUfEru6+AcqMtIdzBVd3plWlkOE50uEOSzzhrcQ9qYtiJ0/Jwf8+sWV3CVGB4mSuUoi+PuKIO/DDhxWrbDrpYapImgV24NPmuBsPtr3i3eoiEkSp85urZm1hGLrmnJZAYeNibpM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782206440; c=relaxed/simple;
	bh=Tnezl8VD/YcQpvRJZ5m+kOTmKiksJ4TzkodZlKn2F3k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ub5ISouUWlr5Z4VcOnDJyviepDwmdj6F5Z6RnvRyLD5Vlgxz3lg1xUlK0sfLYOGTicgVatv+AK2RKwBZO4Xj+L5ly2w/NfODzcg5EuNsdl6wQ5eeYvMU6o8uj5fQ5EJpt4Fub4ZaLy+sP1g8XS1NFj1H3j/7wIhcCz0JTOSRauk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EFLPwPm0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m13uH3s6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EFLPwPm0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m13uH3s6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6NiOp3419223;
	Tue, 23 Jun 2026 09:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+hkBAZRPUupSjn/h/iLmXFq0m+e46sbFJI5o1hwfx70=; b=
	EFLPwPm0iqjQQzXx5g9oMtqd6RNngy0+05GxjYKTb1gsVbNBtL65CMXdYVIf9Ej8
	CAytj6WIUi8e69vCz7ex4x7Y/VXuYJL5IGNTFi/o0kcjmmAIBlI0nTOIXHWrhg2K
	LWTlE1p1om0SDWmumEJ9RQsQ57kcoo8tM6585z+4oZPKIloIP/0aNdAxYkA7oYo4
	Vfm2MvOT0NumJj1EnLLJXG5vPhD3nhsdsI9fTv/1iGaCsSEYO0RxsMhDwc2EEnwF
	5Dmf6Dii108CJMQqlkxuarrtn70TPNXIa9GccgjxiavsS1IMdJMmFReUpA5OUwlP
	ZeKeaDaw+qC0qHe+AUPACA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ewhn2uaup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 09:20:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65N9DJcl010607;
	Tue, 23 Jun 2026 09:20:22 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ewhabxjng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 09:20:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HW0AXdQYIbatZIXyZqckreL/DNZF7YQXuuN5a54zNEckQthy0HQxNT7o1yeBKx1bMP8VG5Mdy1VCEvvmZdnGIsk45W2RPSRS4Fc95A9FgyhITo47Fv6bvVpCbSvkWDFRQKoUB187EHqdB1zIn16+KHJdy9VoL97oE1zA1DChnXQU4dHc3k2g9y3nGYyKa0pCI+rFeDr7q0DoC9/W6k06o8uR7DVHfgebD4tkC1MtkOAvOZ1tbOBnPanbLfoCohtDYtdTCNl7eDTgrA1eg+ndJqQ/5qkkKpCc837lEm1iX3Zx6PU5ZdIGb5z0GmJiE8im8Ntwut5tEVO7jGaGUg6hWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+hkBAZRPUupSjn/h/iLmXFq0m+e46sbFJI5o1hwfx70=;
 b=u4gLXDcKY7+Tbt+EZiQUXrtLzEO652ncCfsGDYWdquecP52KB3BAmyPBEXUykLOIMG1yu6RrDRhaA084oxqeLvt8MhmKCUMDGha7RTVTPqGsbX8rUdFVEeQaKX10SvXFzjit71HqmU+MXAIBpA3TnehqtAXUJxmQWbTM8dm+DaL9Rbqm9E5a1n/HRw0OOSkyvPxZGmtHvnCgseNyc1dfSx/nlngITK6va1920UFRv8hiAqZURlEQGuO/kgiiQ/8TYVouZzn2fyec/vKfa2H30r0ekOp9VsGuoUnPTIz+wuCa4ulsFWZHMBacgL3fxyjBqY9OTmgt2NteKMRSBgdQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hkBAZRPUupSjn/h/iLmXFq0m+e46sbFJI5o1hwfx70=;
 b=m13uH3s6Qsu0govp3h69bpE/K86FHWNtEv5rQIFXNn8+0NlvmiC0joui4dTXy4//39/NxSy4usmS4lBA0vWBUXM7WUdbNjx+7ur1zLV9LTp68+6KN98sxmnJlPSc4Tywzc3VIIh4keyEn6xAoSL8HGXaqoLPp7jwGPykHyVR9q8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7977.namprd10.prod.outlook.com
 (2603:10b6:8:1a8::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 09:20:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0159.012; Tue, 23 Jun 2026
 09:20:19 +0000
Message-ID: <6130d0cb-4cf8-4042-843e-98a9d8aa00c5@oracle.com>
Date: Tue, 23 Jun 2026 10:20:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
 <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com> <m2se6d1vls.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2se6d1vls.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0593.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7b0296-b453-4a58-e8c2-08ded108a4bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|4143699003|56012099006|18002099003|22082099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	4aRLCez3Z9PVVtT/y+cX24VCbes/GnYDQLxqS2iHCFc3Hu8WSPTjwBCNKRGp08KPZ9zKBJEg1MxN41vHDp4zT29+9+gOqnoz+hkoc8WJ7G13+m5r/c3SYbC+AD+ki81k57Nr7SQ444iTBD2Q16evPzCRJmg3yp/l5WqSDFc++1vcq7VSuywQrQj27SYxTkGx3y1D/D7mHm04lkUfvRrAIrDdyyuApLNej0onB+7ziEALDSTpClJk5CKVABn2/AczUkBSy+2LCZTT/uhfGOAKmaXcOUxqWvSf5wYJGct0BWBhtaNPjHe1dlQAzL45/rFDBo8+EbCA7OkQMo/JGhTsJ/pAcJLWyRQoTY7tMJfZijis5y+//cM4HLsoawYbFOHaPZhqskBMrSpkSa5dZpsOW2TL4yDMGkqiU3k3Tch7aYqeKfHP0n2cCRoxxCZCW4iN7qdQejjneslhWaQo/NpFRVSdYSmXdpA1+Z3YNhPJ0MbBiKsZisQrOrwSF/0EOU1XmurH3lEfbWYRIKvZ4s559eNZvmQKeRaCcUZUc4j/9c8ljjgGpt6cSo6mSaGMKJO7VZKwNLHGMctPBpRymMLZc6bHuqYV6CNiHIdgndGNVpPX7cMvC7/eS1Q9lL9PveT7wc1n3X5zBiMbgvLVKgdcHtdEWwRZE6B/nnx1cEnV10k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2pyMVROUnVySGNGNVFWUUpZRHJ4WVJRVTdYSk0rRko4VXpVVzQvdTQ1SnMz?=
 =?utf-8?B?dmt3emptZzFKRExuNk1ubWZwYURHTG0xVTlXaGdRb1VNSzhVRnhMcTJVSEI2?=
 =?utf-8?B?dGZnQlRnWjZEQVdoaWtkaEFmU2tRV1dlREk1K290V3ZWREdMMDhneW91OUNo?=
 =?utf-8?B?elk3MkRmc0l0UXV6YVdONG9hYUY5T2ZjU3ppdFBjUXdRS1RDei9GSDlHK0ll?=
 =?utf-8?B?ZG05dnV1RXFPRG1iM0U2c0NHL0l4c2N2N2Ryb05UendGWHR0ZTRVc0JTallC?=
 =?utf-8?B?OUtjMEFscWNBc2NudkNISmhxbHBCTVA2NXlVUWV2SkVkN1doMWFjT0VsdFNv?=
 =?utf-8?B?VUgxNXdHQTJadStRbU9hYlBxOTZwNlMrL0ZiSHlQbXZVN2FmNEROa3lORlhk?=
 =?utf-8?B?U2lvLzcxc3h4K04yOVh2dTVkcGYrSTRsNTl5Zmt2OWxoZ01OUUttOFgzeE92?=
 =?utf-8?B?Tm41ZmxTY0t5SXd5enlNVWs4R1BWU0hJczcxelJiM21pZFh3REdGYXhhQXBl?=
 =?utf-8?B?ZU9KWktuS0doeVA2YTJLTFd2ODYzVkJTVWJVTmVtaERwR2haK3ZtTTJuWW1L?=
 =?utf-8?B?eHFuRUlWYnY0QXdoZmRsRkdWeWtWQUo5ckY5TDYyMjU4cUZBZ0IxZytubzFB?=
 =?utf-8?B?RjRLQmZMaHBjNWEvZnkvVkgraW5PSnBGWGFHRm9WVGkrZ3NaK0NDM3dvcXJh?=
 =?utf-8?B?MW1zZEpoWkJROUU3QVdHc2lIZzVRanlSK0RNSWpWTE85ZlFHaEZzMDN2Q0x0?=
 =?utf-8?B?N3UvdTBQaCtzaFE4dFBGTVpXeFM4SE1mNko5VVFkL2VzbjRXWEtBUEVvRFdt?=
 =?utf-8?B?czhmbi9aemgwV2JlcStJOGpVQ3hNbWwrbGZqRkYvVjIreUltWUlyZW1uTit3?=
 =?utf-8?B?ZjhhRnAwMjN0aEhHM1M4d2k0azlua0p5dUswTitWVE9kNTRYUG9oaDF0K2V3?=
 =?utf-8?B?RkczSjN0VlpZVXo5cmtLVmJXQVN3aWVQSmFqQ0c4YzJIZ3BieEJiWjRLZGMx?=
 =?utf-8?B?VFBoYm9tYzVVdU9UZ3BqU1l2RDFST0U1RW9kVFU2aWRSa0ZHczFCVDZ1SlVy?=
 =?utf-8?B?TzIwbmNQRnJObWVXb3VNeHh3RmN6eW9mMm9FbUxJMEl6eXoxZFcwSmU4MXBt?=
 =?utf-8?B?c2xYYVFvUjBrMlNBK2NSZW8vT3E1Vk1WQTc5aUNuWUFTRk1leDNCYWc5K3lj?=
 =?utf-8?B?cGZlQTMwQ0VPR1NYUTFLNksvbDB2bDRCaytUaGJTZ2x5K24xVFhMbENsYzZs?=
 =?utf-8?B?N0ZxQUREYU9GbmQrOFZsQTBBdXVlQy9QdHNJNnVod1NGdTVxZkg5dWRhOFBy?=
 =?utf-8?B?bGI0RjhoZDBISG1ndTgvWmM3bCtaWGk2ajZWK0QvTmxpSUhaTjZ1YU1nV3lL?=
 =?utf-8?B?WHJGNFhNT0F1L3FMNDNwNklmRTdQR2toTGpuYVVMSms5OTROZ2RKZGdDQmM3?=
 =?utf-8?B?Ti9WUEJueE1zcFZOa0pRS3FBRzYzclZrdHVtcU10NWszMkxlVzU5ak5VL09I?=
 =?utf-8?B?dzdjMm9MZTB5NllUdzZWYWg3WGE5c0N3dkQ5WTdzMU1yMmFQMExkOXJZMWUw?=
 =?utf-8?B?eEhuWG95MkpBM2tEVUZ2NVc5UTBOdC9zSGs2Y1lybFhaQklCNlV3dWtBVlov?=
 =?utf-8?B?VkFoTWFNc216dzUvU0cvM1l3NEwrKzJUTG9GUVRvNWU4MkVHZkIxTEpwdURr?=
 =?utf-8?B?Nnd6UkU2NHh1M09HNHBteVpUcGF0TzRkcWFIcThRS082RDFVM216ZDBUdjNN?=
 =?utf-8?B?UHZQc3JqM1RFWVRlZW90Z202d0JRNnJPOEpwR3FDM0EyTmNpdjVmRUo2SVlM?=
 =?utf-8?B?TFNHMUY0QVJOU0p2ZTV4L2hheDlVR1NoOUtpczhMdTdJc0gxUXhBbUY3VzBj?=
 =?utf-8?B?SGM1YndsZ29PY29WcHlaQm00RnBFQ0FpVGJHZDlIcUxqdUNKZUZaeXhRRWx5?=
 =?utf-8?B?eGhzbnhrMm45bHN2TFhWSEtBbzJBSmFNWWFSbGxIa3c5RC9hdHlrK0tPRDN1?=
 =?utf-8?B?Sjk2eG9tbHIvMWNCYTVubHhqUXphWmFqUlhEc3NzellaSnAwT09wa3pZMHdz?=
 =?utf-8?B?U3Y0TUkreXlnT0k3cnl5SmJkZDFuS0VPR0JOSkVPZ3lKcGc3R3JGcUw3NXUz?=
 =?utf-8?B?OS9WYWxiWkxXZGE0UFpJVTIrMy9zdkd1WnYrRDNZU0h4eHRKVC9pOVEyaTd0?=
 =?utf-8?B?N2l2ZFVyTzQ0K3o5a3AyOXdUR1FRc09MSjZzRW81c0ZYdnpRTHV0V2kwNG1H?=
 =?utf-8?B?SitNOCtnY2JrTXEvdHBoTUg4d0ZONDV0WHpPZCsydXJOaGdORWwxUkFzV092?=
 =?utf-8?B?TGNyRDBxQ005SnhrMnFIaXNRU01ZQnd0Q3JuOWg1Mmg5U05yK0svQT09?=
X-Exchange-RoutingPolicyChecked:
	nC7UbRH5MzpnD5HqtvU/q90HOkEIYRrWrCdNdzOwt0W4w7QqG6WBCHp+kpGVAHqxvmpgkCMaBv5dJM7675kUqFhHjar6r33MFvD5LD2zYPGw8LgzGaD6VrCXVIWHStt52KWPzO2yujiTk6AA1lY21uzQeWAQSGN5DarxnGEPPjvaVFTEgbSDVBVwclz3gB2mYrhU6nPiQA8e9UvPenyb21k1ZZW8gm3Vg+Z7fB914ZlFKKLmq35guRFqO1FSFW+5kKrgnsh9WgvUYWTGffttBEHYCybTYtjCiv3exZH/ZxZKEbAASiZfnHbH686nTHWSnnc9SShyznTXmNPJMQ9O5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FnnTRQOLydnyCbW/ZtNuB8nfiFdzZzBCCsYRwGh44XRvbhlK5kbARwUaKwhY3+PYilVAh2sng54iRRtuV4ykd+1gUpCNKCdN4Ouq86yH/WlzKgbCQnoNkxmsIsEwnvP097GwBJee0KyWskGXM2uacNYYKgvjhmyUlYDCgnP/mHq3uUX3hLvdGtR16594V7KU8YhBJx9sPTU0UT/2l57LlbQ6sUxJiXrKVa+GRuzwCLlxdi3+ok9ItU9tvpnARsROHZnS04f2S2vbGJ2KxLhsrYzfj17M40dpxho+20PAmvKStlMvDr2e0BMX6oc8DESL9h8mSft1ppDwKuKrTNU7lEfpHV0MI9d2B2lDmlaHtq9YPVQK8b5eDfKCJxj3TPu8LBub0K4nrW9VETWOpU9qSE8ix8U6Mo9kF7Pc0drGnCovYYzcAd7DqXmIOFO43LTACrQcj+s03i8VeXtUqCOYfF3+c3RKKp4dmwtKowgB6nXMbXHFWtpedJQVE8y2NEKF7q/KXI7jb0DrY8kuj4Ll482UfwWcf00oOhLpRVkm1UIkCUeBvNGI2qSoyu29/tDKnQy5MV2NsUF9ntmLYLcBW6+2t9wwQrbgRe7g9/L3sYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7b0296-b453-4a58-e8c2-08ded108a4bf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 09:20:18.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZi4eVZKR6rNQQMV4GGkhIh7gEu+Mpdt9jXPVvFoHN2UZn4+nAieDsGE4pxZ361VewE1mBQQTfqCAloMU6uuTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606230074
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3NCBTYWx0ZWRfX95kfEgv8av9J
 35/aLJ1vRkhgEbGtjn7bkpxBOy7LSp75fcKT5p5xqCO+evEXaXgD5gNNqlITKvRa78IQ8Flgf/C
 NbTeyDtUbZ+LqK5GJ+FAGQR2j13i55tvA2Y4KhjuFiIIZde2qZ/fpMLczQp1QExaLMXBkoaSk4N
 JSROtKQy5CSCtf1F5NDTfv93BJR81VbNHDFiaeDW5GKSzQWd57XDuQbtQb6VAuQSBPOoZLuLL4z
 Thk2OuqpUWsJQtu/fE4a0b8+TIstzf4PV6VIjtiYBhf1fJJ5V19FbOhtLbqDxgsFfvoWnjTMlEH
 o8jzdHsjTHyopa0RGdCEO76/o+Ri6JbJIVvD4inp11hMiSGsGcik7chc5TAynmu9BuUJkQpYGC2
 XRPs5J8OPvEAcPZi+8tWoCRBD+fIONd4jGE8o9iXtQ9/Z9uVv7OKiLofQ9+BMmdUuIx6mXHIUSD
 z9J8fUKmao1p63SZz8w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3NCBTYWx0ZWRfXxx/dc8/WagGl
 dwsVci7Sr+f2TsnKwwmCvBVp7kHQHyr0tBFBywNVFZiip6Er182Jfrp/624UKyl6oSgIJZ7Hsbq
 g8n7l35nFLA7cLxSOX4GUKTDj+dS8G/4byA4/qwayj+EZsGO98WI
X-Proofpoint-GUID: bsNACBM3u7eA_6cfCZ11yk3HMZBSzfHS
X-Authority-Analysis: v=2.4 cv=E479Y6dl c=1 sm=1 tr=0 ts=6a3a4fd7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=8Clj4kNcoGCNtXYKbBUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bsNACBM3u7eA_6cfCZ11yk3HMZBSzfHS

On 23/06/2026 09:58, Abd-Alrhman Masalkhi wrote:
> On Tue, Jun 23, 2026 at 09:11 +0100, John Garry wrote:
>> On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
>>> If a request already requires splitting when entering
>>> raid1_write_request(), the current code allows it to proceed until it
>>> eventually reaches the split path.
>>
>> The block layer should catch invalid atomic writes in
>> submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we
>> even get as far as the md atomic write handling. Having the check in
>> bio_submit_split_bioset() is really just a fail-safe for the block layer
>> not catching invalid atomic writes or the atomic writes queue limits not
>> being properly calculated.
> The request size itself satisfies the currently advertised atomic write
> limits, so blk_validate_atomic_write_op_size() allows it. The problem
> is that RAID1 may further restrict atomic writes to a single barrier
> unit via align_to_barrier_unit_end(). Therefore a request that crosses
> a barrier-unit boundary can still reach raid1_write_request() with
> max_sectors < bio_sectors(bio).
> 
> If the barrier-unit restriction should instead be advertised through the
> atomic write queue limits, 

It should. Any restrictions should be advertised up front. For the user 
to issue an atomic write which is valid according to limits, then it 
should succeed.

> then I agree the block layer could reject
> such requests earlier and the RAID1 entry check would become
> unnecessary.
> 
> However, there are also cases where max_sectors is reduced later within
> raid1_write_request(), for example when bad blocks are present on some
> mirrors (or due to other RAID1-specific constraints such as write-behind
> limits). Those reductions depend on RAID1 runtime state and mirror
> health, so they are not readily visible to the block layer during atomic
> write validation. In those cases RAID1 still needs to detect that the
> atomic write can no longer be serviced as requested and fail it
> appropriately.

Sure, and we do this. As I remember, we should return -EIO in this case.

> 
>>
>>> Along the way, the bio may instead
>>> fail due to other conditions and return a different status, even though
>>> the request was invalid as an atomic write from the beginning.
>>>

