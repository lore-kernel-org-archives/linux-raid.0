Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E82772D;
	Tue, 23 Jun 2026 11:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214736; cv=fail; b=IllY4iemTh0dDGfuz9sGUoINaLsbChlGtg0/8G5TjrMT0j+Cbh9/yZS6yki8k+8DE+dr2bmuRp1Z2sXj57+s8JZ++JQhC34MQZx2Qda1moz9Q6s+/8kkW+vzKDnCEnRP/jA9tw6aKOCWEF/KTckYnaxvC5mTTBuQoVVLcKtS9eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214736; c=relaxed/simple;
	bh=R/G+92fLmbam9+gkz5rnRuaf77D9y7tmIhn4PlmM5+s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jrtD+zFkJMKJPkl++mUrPwbpoCJHBcktaZyCW821CZND4CrHlmxe4o4nnrTneVbhTvHdfu2Nb5+D4yIJq0r5oQefDI8V9kIMZ/flMBZOeHw5967rhq5sccPJqA9zIms2f31hIs+rkt20VwUH2KEfAf3Fm+rZfK8vUoNGy1e/Oi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ll2HMuBT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gXqu60uT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ll2HMuBT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gXqu60uT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6NDUv3591154;
	Tue, 23 Jun 2026 11:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FSTcctvqYgDS1FWzBh7TdtDpJRaApvL7wJR9C6sSZTo=; b=
	ll2HMuBTBCsMAVubGJUP/S49eb1TpAB1MJM5i1ycyDYnEziCjuMPoCsF3FJgmN13
	HDTI4Eqq7L9o6ehMpKqz76DWeivmgbHNK7ohe4+uXRy4P0tp3uDQ8xYBl/PAAZ0G
	a+jNh8jz6iO0TEO1kio8LHe4+59BVMRullPr+DKNpmzjXvxXeKk1MlcXMU5ZuMyC
	BzVeFloqtOiIexlBcdXxMVotguyjf184hJiPMF+jpDppO5HPXQQdCrVlbHncM4yn
	2QmSiakxJ/Oafx4w11yTNWyH5g1gKowBpwno4J+IM8UnSbHK/rGKTdax8G01gfRc
	+ubSSrMPNg1dBI4W9bExDA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ewhs93jsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 11:38:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65NBcad6006155;
	Tue, 23 Jun 2026 11:38:38 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ewhapycj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 11:38:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DaGHNM9F1ekw68CppGqj0bFjuhWMNe4flNVEcH6VD/gzx8uA9pxuU/9uHUfQrrpvoLwE3s4KfssXSuk7yHT7GG3GAkrKbyFBS/RWl3ruZjt70zr1tZKjVJk9GZPagTizk1KVpVkoXoXsA1BPZpsrb/vN3hIu3Mrz8+5ogWKz3fioGZVbLi5GvEsS+S7grqz0hqdXmOM2yvkvr2uBRXfRAdmRLNSeoUiqpBbhliK4yU6zWcLbuLHnwV7WGI+iT849LduJMOSNolMOZPXXfQ3JdRwFs8Y2x43gHuQUnTySXIzzDqgLcLE7knTwN6urrrekEMEnw3cnV6iP/0f78lyFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSTcctvqYgDS1FWzBh7TdtDpJRaApvL7wJR9C6sSZTo=;
 b=RkMbcWnN5zN30g0EmcHNp038AyB3tQyg3eEJVU2zPXRpC0gf6aVipijNvnNRWN9CCliKd69hqm7HeV1Py86QuF/BkjWJt05vPv2b57nw5lDrds65fDdTQ+HUVfaVJ88/jZNaRPC69BiwcqN9PioZyv2hE9wnhvP/rUTv/iQlbZ08ugv074OwHDVVEjq7W1SDo23mo7Ds0eqB8WfgDhXHSUazCsc72r03fC3scPBAovYheHPEvIx1dvFlj/aQBgIGa2imsvzUl2wHDpMMHXEwA6pS7+aB2SF1ItbNUSuKSeRE8yUdhMcoCoBCD0UZx/UO/bwKnNEiEY5TUBH5CuaskA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSTcctvqYgDS1FWzBh7TdtDpJRaApvL7wJR9C6sSZTo=;
 b=gXqu60uTHcv23ZJeYCJkCQIB5LEbSjiEVu9npD5mzPReAP8H7or55MWrQPMHpie9oogVnDyHbQrZPUpVgeUw0Wg0SCwqfumNrLj8TnPIf1MhRU2evefnKP0Vmy0Uh+vUZwHSRa/BWpPOChquD1/MfrXyiFM77wL93Fc8b6rC7rw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH8PR10MB6599.namprd10.prod.outlook.com
 (2603:10b6:510:224::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Tue, 23 Jun
 2026 11:38:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0159.012; Tue, 23 Jun 2026
 11:38:27 +0000
Message-ID: <007416b5-d099-406d-b1d1-ff0db2edc48a@oracle.com>
Date: Tue, 23 Jun 2026 12:38:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
 <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com> <m2se6d1vls.fsf@gmail.com>
 <6130d0cb-4cf8-4042-843e-98a9d8aa00c5@oracle.com> <m2mrwl1sha.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2mrwl1sha.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH8PR10MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb2ea77-8060-4418-5d58-08ded11bf133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|3023799007|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kPczqBEFHP2QR4t5SSi8tEWp3I/6j6vxlwgAE2cSE/YC6jhzvhSo8LGqryynOEMSAe5UNbOe9urxr0bERIEXLoeqsB0sl0totCKutNe47XLbCPeWTzb0AOZi+OnKzAW7pCcFKf7Sv3K8k/fwVQQAuaZz3yBuPWdmWyvUuc9Sic07bJDvF2Ux+qk0IRRQgjNdvMQr2GPx8H37K6XcVXxayiUfEJqn1q+onIX3rt0bRtF6iu9RCb8plkm5GkKO292ViUE8kbTfSz71KBdLJkbecIKxT5mhF9i/sTYXfyq+Bv6mUpsh3GKMPwgz973OKh47C2dgXE04bmPm+YmH089Zdglwnv1lbddlhDNMXelkpwgp3w5we5M+ndd0UgHz5i/aSn6Hj+pcTx7uJa2Coxy0+dbeMdrOtgZUdMMgy+k8XPEumhhHCXG+s9/4MARNqseQsibcaX9dhQ2PsJ1OrT6QQHIDte3gALbsmLqEK7b0OwZKwnLmCv+VXIRWkqpV/l4EusAUitYd0vgYHGMKsVMYCvfTjd5exHsAgSImFswN3ygvAiNCVEyfCxs0gJ45lh8yQIS/GwBr6IexoOXI6unkVvGnwuw4mAbkEXNRPpfKxgDtx94dS91vbMxdLy8f5r4eUsGP+pI09yOYtCa6ZZ1jwBZgcOEEBSrcnyixwSw+5y4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(3023799007)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGhuR05XZnpQU1JmNWlyUkpMbTFjVUgyYTJNOUcxU2JqaS9veWluYzAwR0VD?=
 =?utf-8?B?Z3h4cEFLQXlLUnVFREhFb1VrZ2JwNVlaVDloSkNNK2tmTjRxWDBrZGJudG9J?=
 =?utf-8?B?ak9SS3F6OE9Eb291czhCQ0ZESmxvY0VuY0duWFZJREVza0M1SlViWmFoSlU4?=
 =?utf-8?B?dm1XOGY5ZjZaSjlIL0o5Z000M3lQYWtZYjE0OTNsWU56L1NKMzBVRFZPdzYv?=
 =?utf-8?B?L2RZYTJEVjhyenErK2pFOW5EVU8wRHl2YkRUOTFORWtYNnhFUjZyU2hzTEdQ?=
 =?utf-8?B?cnU1V3JzckZ0Q0tTODIza21PRm9nbWg1Q3VCTU5ZdE1ZSjlNRHkrM21TdGFl?=
 =?utf-8?B?T2pGTFd0U0pEcytORmR6eHduSWgyeDFEVWxVNG0vUGxjSnJ1MHpxNTA5QkdJ?=
 =?utf-8?B?Q1ZrKzU4eHZmQm15ZDlHL3YvdXgvVGV0V3BWamhzM3VudE1HMnpTNkd1N250?=
 =?utf-8?B?cWFkbjEyNVVsN0NmNTBkdytuTHBTY3dDd0tzUDAvRnBTazR2V0s0T00xeUZP?=
 =?utf-8?B?dk5IS0hObHQvTVhQL0NIbVFKTU9idjRWamRUUG9UeG9OMi8waDhwMlE4SUNP?=
 =?utf-8?B?UytiUzErS085Mk9nK3Y5d3dQdFV6SXRwVUtGMk5nRmxybWNDbS9IR1owc3kr?=
 =?utf-8?B?dzUwSUM5ZVRqeFhPOFFKOFJLNEFOb2d0NGJuWjRpeGtSUHRqckd3VFJPdlJn?=
 =?utf-8?B?dmM2V2QzTzRXQU94SGl5aDRGTHRlZTNpQXJLM1RxZk4yazFGSHB4a01wNGxt?=
 =?utf-8?B?VnVPb0xTYzc4SzZNTllQai9RWkg0MC92czZUR3dUdmp5TVZ4Nmx6WnBoZ0N3?=
 =?utf-8?B?a21SZ2UxTTRlNk9VczF0TTV5bGsyblp4MldLYy85b2YzWkoxajNHU1p3bjY1?=
 =?utf-8?B?bjRyT1NCRzlLVmgrNTZxQjAyUFZkRGdTYk5ud1dXR3hlUFk2N3dHZmJUODE1?=
 =?utf-8?B?VUJkRENJeTZkTWxDbFRqaktxelZ1M3A1NHFSUFM2aTgycVJkWS9UbzdsdEds?=
 =?utf-8?B?ZXcvMjQ5RXVqdXZaWTArWFoyb2pPbnRONGEvVU5RcTBGSjE2b3NpQ2hGYng2?=
 =?utf-8?B?UEVGZG5FdVdVanBvN0hXQUNsWFR6K0U1OWNaNnZoUFJ5NGx1czVNMDVKaHE5?=
 =?utf-8?B?TWZnT24xZVM0UWRsSCtoZ2VzTHI2ZThtTUxyK1BSR2FvR2VmZndueStYUmll?=
 =?utf-8?B?OWVCeHZHU1NXMWhRTGROU0R2NGZTWFZTZGR5Yi9PczFxQS93bEl6RVg1Tllv?=
 =?utf-8?B?R1BmN3R1M1pFbXZUTWdYbVh4eHJTZVVvZXUva1lyNWxqbS8wdFJxaVpqSVZq?=
 =?utf-8?B?eHNCUGQrVmFBMWtyVjFMOVl3MXM2Wm9qL2FKdlk5R0NYMGlXNTlyVlc0K2I0?=
 =?utf-8?B?QnpJWjA2c2hpU1ltb21zcDVoVm83UUplS1RHS3RHN0NheFM5L1VhcTJ2UUk3?=
 =?utf-8?B?R3F0dFZHbWlIZTZTdldEK1VUTUN6NTEwV2cxVnFQN2hTanRDRUFOL2NBa3dN?=
 =?utf-8?B?dUV1UVoxeWYzczdwOXJrOURhU2tqVjg5NzA3S3dpSXVEbDZMY1IrWldHVnpD?=
 =?utf-8?B?QWtXbUlpb3dPbmUzRlR1Mlh6SW9DenZYMTlkVVRWaS91bVVtc2xTc0VUallX?=
 =?utf-8?B?VVR0QWNWamdHejVlanI3WHRCeVBtL3pHYjBoamZtcDllaTlUMUhjSWY4YTYv?=
 =?utf-8?B?RlpkSnB1ZEE0NjBBT3FEUzB6L0dnelJSaXJHMEtWL1pkaXlkNzRMOTd3WHhV?=
 =?utf-8?B?ZEZzSGRaSTJGbUtMME8wT2JYVEM1WGJMSEYrZmRndWxYUUdEa0ViQzJWdlU0?=
 =?utf-8?B?OXZ2VEF4cVc2SUlvU0tENjBiRUpxblVZNlhlakVVTmk5NWZZeVBkeDF1c2gy?=
 =?utf-8?B?UkpHdVFNTGJuZEhlS0UvTDY1aVpKU296SGdvRVI1S0JJY1ZmVURjYXpPTFU3?=
 =?utf-8?B?SisyYzFQUHlYdmhXb3VUeWtaOGM3em1FbzQ2aGRzQXdZVU9Gc2RiS2JOTnJD?=
 =?utf-8?B?bUpyQWE1dmlCcHdJVFZQMFhOR3F4R0VYNGtnM0VKSWhCaXl6c3l3UlRISEpm?=
 =?utf-8?B?TFZxaG9jOHJTWkV0UVp5NTdwN0pFVmVyTFV6NmRjYitKOFJBdzk0Q2lmL1VE?=
 =?utf-8?B?cWtlMnhhcHRucHZjYXF6SDFadjYrUGdlcWRva2t0Z0UxSk9xQlJWYldJYlpI?=
 =?utf-8?B?NHcxQkNBR1ZBcEJVUU9TRTQyR0JhaGV5dlZvNVJManM1NGNZOG5SU0F3NWg2?=
 =?utf-8?B?aitLWjJyTUJ0bS9qYS9RNEt5cDlrTG1TL2lTY3A3NUhJN3NDeEE2dHppbXUx?=
 =?utf-8?B?OG9vM0xLSHh0TTJhNU10Qm9JK2JPSGV6QUpFLzJyQXJPV3pVM1FMdz09?=
X-Exchange-RoutingPolicyChecked:
	PqkdRk18Mq1YHWGurvB9gHNXERgibljJ51NZs4OX38wEFFKpKeEBiUz5hteftbbJWsqLbu0b2vtkCyQLxci0e0be0Rbba7Vke40sUBkGf/IvY2+2g/wJ0lrJY1b2+2NrUhEB8EkuS719BXcDcEzLEEi2rbxvMx3vRUcHnu24zPcffXLc8+Y8J3CJOO+Je1gunxpuFw87i0NJrUuYh8O6priJZlCJodxgkKgStAAVz/3y4r4bhAHG99wGTuzfFiswkm6UbcKvNt4t8eb71Oi6VhzwhXWSm0omIiYCyo4oZTXx5bHDtLxrQnqVZE7CZM+yovDoEHQkmTzIr51fT2yT5w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rveGIKla3Foa3GK8+nJ/CUNvEzVSEmnQuWV91TkxaNr0PxQPCt7fGzWJQzLmqR6Bcmn5H+8bz4VZ+ZlJ//wrLnAkb5B+Br+uER5H+YE9masbUjAiclD4JiKfKCWpAU2lvpOwR33V4rujw+lEQq/1RuQ6aWZ/+DRoOCW2nK1teBqWdUc8MQrL41nF6+yMsmI+qeDy8vQa0j/kVFjbAnTYAzEK3J4qzUn393mMULvd574YY5E3y4XQ8NJwynxRYfjjkjapiwjPjhB9YnSGwG8FxtKA5pUR2tC0o8GpGJCiZVJfu6MiYKCP7l9elfF09NYOF0R5rlp7ll9DxUvD2xKw9kMHSeA+rSDbv/kL9zInsTD5UKPhndhF1O7eDDu4A4nSoTjtoNWA4zP1az92BVOnjVhGOGQn4RlhfZMs7tCLL/n7UDRRESs/JJxs2Fd4gj6XCHsJPuSXQbA41s39N+ZfEM1nkcjx8dvEzDMB8wVNBqKNyg62OJmK+Tx5JswiIdcapXYMhoC8m3LECHbm6A7Di4kTxerglCqel1EvcnlqcUgZxtRLhKKuBgZGmugTigJStqoonmNlHMjMNIV/wsy2IeYocnJOAwvyLwgcf7rylWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb2ea77-8060-4418-5d58-08ded11bf133
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:38:27.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbB0NLJ69ePJS1eANTdXxghzYWonEhffrRGASO5ERWy0PHk/2BvobyB8dM/24hqVrRMCQD6YMc8WZOcFv3lxhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_03,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxlogscore=978 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606230095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA5NSBTYWx0ZWRfX42mKlY2E80WE
 V6J+DR7kVlyCXc1cXWZfRnYbYnXxqRn7AKrXSNYo837X+m2E4fUFvkHH9i27XLqX9PvvrL4Kqie
 U0azF2sMQ/22Cs2Op3RecNmWF/mmF/L5U6VEMQ9yrQfgnY7Rh6lnqKLbpHIUTQb5ZeNQPxYuV6L
 ZRHfn9VPm/AKETBA2fHWrBjFPvA+MVfECAYFOpLG8PoDiNaqy9IjUrWr1GxjxQ/w1t6an4bS0Wm
 l1ApjY4hYhFmiqkwJptK8IZR2Zt6FtFdJRn99Pagur483pHFh6c9bLPFZM6fJn0/hcRwXW/3n6Q
 Gw/PRIWliMWon00V6wAy0KIyKYl9B9YgfdHZJXn3pBS+yAKsq8soTQEr7X8PkKCHqBpwrvJkE1Q
 dQs7tz+FWKeegeyoo+1D6yDYpxYnH6zJ/UBYB7YCsp0CsB/qRWWT+l1Ppjm2qmC9J7hNgTFpiXR
 vH33RIgaubP/7IWbCWadOAkCvOL6vFsKkE5/p+Kw=
X-Proofpoint-ORIG-GUID: f9iK-gtpfnOfnb3ezNQHKAxOnLG74_wI
X-Authority-Analysis: v=2.4 cv=Wokb99fv c=1 sm=1 tr=0 ts=6a3a7040 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=5i4mvrbl2NsasIjO8bgA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13723
X-Proofpoint-GUID: f9iK-gtpfnOfnb3ezNQHKAxOnLG74_wI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA5NSBTYWx0ZWRfX4jagcoCxn+9j
 yt0IO8XLXFGTw6/Naz0LknD7LiN6NB236GnLzsGRtOpxqTCkH7g7FK7cjQjfaVobKddi6FpgRpg
 wSyGmjHZH9UDWnSM1Q7JeGS4hcEAMy5/biBQUF1tPeprqWbsMblh

On 23/06/2026 11:06, Abd-Alrhman Masalkhi wrote:
> On Tue, Jun 23, 2026 at 10:20 +0100, John Garry wrote:
>> On 23/06/2026 09:58, Abd-Alrhman Masalkhi wrote:
>>> On Tue, Jun 23, 2026 at 09:11 +0100, John Garry wrote:
>>>> On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
>>>>> If a request already requires splitting when entering
>>>>> raid1_write_request(), the current code allows it to proceed until it
>>>>> eventually reaches the split path.
>>>>
>>>> The block layer should catch invalid atomic writes in
>>>> submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we
>>>> even get as far as the md atomic write handling. Having the check in
>>>> bio_submit_split_bioset() is really just a fail-safe for the block layer
>>>> not catching invalid atomic writes or the atomic writes queue limits not
>>>> being properly calculated.
>>> The request size itself satisfies the currently advertised atomic write
>>> limits, so blk_validate_atomic_write_op_size() allows it. The problem
>>> is that RAID1 may further restrict atomic writes to a single barrier
>>> unit via align_to_barrier_unit_end(). Therefore a request that crosses
>>> a barrier-unit boundary can still reach raid1_write_request() with
>>> max_sectors < bio_sectors(bio).
>>>
>>> If the barrier-unit restriction should instead be advertised through the
>>> atomic write queue limits,
>>
>> It should. Any restrictions should be advertised up front. For the user
>> to issue an atomic write which is valid according to limits, then it
>> should succeed.
>>
> 
> I'll take a look at how best to expose that through the queue limits and
> rework this part accordingly. If there is already an existing mechanism
> you had in mind, I'd appreciate any pointers.

Any write must fit within BARRIER_UNIT_SECTOR_SIZE, right?

Since an atomic write must be naturally aligned, then I would expect 
that the atomic write max unit is limited by BARRIER_UNIT_SECTOR_SIZE.

> 
>>> then I agree the block layer could reject
>>> such requests earlier and the RAID1 entry check would become
>>> unnecessary.
>>>
>>> However, there are also cases where max_sectors is reduced later within
>>> raid1_write_request(), for example when bad blocks are present on some
>>> mirrors (or due to other RAID1-specific constraints such as write-behind
>>> limits). Those reductions depend on RAID1 runtime state and mirror
>>> health, so they are not readily visible to the block layer during atomic
>>> write validation. In those cases RAID1 still needs to detect that the
>>> atomic write can no longer be serviced as requested and fail it
>>> appropriately.
>>
>> Sure, and we do this. As I remember, we should return -EIO in this case.
>>
> 
> Right, and that's the main motivation for this patch. The original
> atomic write support already returned -EIO for one bad-block path, but
> there are other cases where max_sectors can be reduced (e.g. the
> first_bad <= sector path and write-behind limits)
> 
> After a4c55c902670, those cases can end up completing with EINVAL or
> NOTSUPP instead. This patch is intended to restore consistent -EIO.
> 

ok, but I could not check this as I did not recognize the baseline code.

>>>
>>>>
>>>>> Along the way, the bio may instead
>>>>> fail due to other conditions and return a different status, even though
>>>>> the request was invalid as an atomic write from the beginning.
>>>>>
>>
> 

