Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4044838A;
	Wed, 15 Jul 2026 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784112582; cv=fail; b=roEux9Hlzmh62JotS67QreFtuUKNYJ+lyTEQ4C9cQq44s4fccnkojEDGOtbfUOMwxw39d2K+PLN68DrneZ5FcB9ovASfnc9QX2vV+Lyp8elXLdPECAAU0/f/SBLLAZrCz5TJvkB8a9ajqN416qCshFYeJD2bYfWnWTEmWKbjYss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784112582; c=relaxed/simple;
	bh=vb+V+XLpJfbPyX7loItg3iINwnyptRIRE/HVmeRl2kI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UVM/atlSsj7uv43V8N8w+81GYRQW9nK6QPM1S+sqzfs3+aDTRYYiFqGQEw9T5LVCS98eYd0l2GspxNj54pepLBJZdwYQeJVInDz4HI49VGhVAfgoNkbKDXCqeRgUTSqepM+NzrNlc7EiXTiRLANJ9wU6Mofa0pU0MI3G05ibx7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hPW1Vpx2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xRQrC6FO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hPW1Vpx2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xRQrC6FO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66F0Nnos1025457;
	Wed, 15 Jul 2026 10:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iCflRt5WotiMnupy++EpZfAwHMKEjBGBNZ7HjMi0h+Y=; b=
	hPW1Vpx2VSqW5uVSMCmeoV26CfrhEWShJdJKMzbWUsgRdetDRhrPxpyG5SwghH+P
	ByrncV9G01vYUho2vBCAxSb36aSnKQNXOR7SIA/3S8qvgzcLGhtfbUqKlMbQGtYv
	lqRPN5ZD/N/wQ+GSdXLAqDjHD+daTRtEs9yk5cPlmmKav2wwMkYfIGkTV/sL7k0R
	zKOO8DuED6KEqI8k1WIezah1Irjk1W+6e3vNC093PoGKWvc7hPcb1dMDmkjkY7uw
	EAxRnS/11M0hmcV9QMk9GpeV8cbGBevfCzQOpI9GnmZX2IbJ2zrnnWKqbtOXNyIo
	ekU/WrFIXyqAhyPJEEB9mw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedpj8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 10:49:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66FAm95Z012726;
	Wed, 15 Jul 2026 10:49:24 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9eww5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 10:49:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tghJ8WJOROTVqBmBKIaKhgNMkwBef0ik/yKr5ulXzzevfNjnmAs21yJ7McfbcRoR8ZTEZuAOX3echDoxQjlXDRQip2/H/9lDfdR55fV4Wec8OrfxPKHz+RMCP4alwJ6yknUOgG5VAJMbmVprBiWHBR8CnzaUIO7dsHecd0nlcqk4SXEXENz2Sl6ZqM8nuzD3hJe0Q4qPZsuoMcUDXobYYBCRxl4TTeRo+hIaYQ0v8CUzcA7/ESjG6gFeWQr4wpMt0ITtVY/FmSYLRLc8Uk3MYueNEdJ3uF4hYUZ0c5+H+HOLZik7w1LQqwuj+EDeTfvHlo5M77IyhpvAnH36AaKSIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCflRt5WotiMnupy++EpZfAwHMKEjBGBNZ7HjMi0h+Y=;
 b=VUShO5JkBPA7RJJU+z3lQE28FYApqGBz3Fd0VWFMSaR4194sRLC0Nh0Re14qTNzkUGkvT4wkavBlQEU+DfQbb7mKoXUaJ2pIQVnWUgz+66QC5XUyKK+rcMIxi+3ajaZY7gOEo1ybH+sekHNtOI9FBP6tyY6rtbEMihqi6HbeEFotsgdzc6ODMU5semJREohBZk64eDSKMrwYQQ42fU5VKd/Xx18rmLmSVzutVq+kVnHx3fNXQcIVnreY16s9hDaarldJRyM6t7StO1juuoZZp2pQ7UevfATcUrQB0TYM9D9F6bxJvEjP0SEklVpiO5nz/VNqfNcpV4xsHw6Oj7diiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCflRt5WotiMnupy++EpZfAwHMKEjBGBNZ7HjMi0h+Y=;
 b=xRQrC6FOfiP1gXZSJxcgoNa0OHMbGkxQI2V+2ItuO2AJY3OMlMUsHTKSoxNKmyyWPC6vDGOZza68VhDfD3STnycxk62mTodRNvhmrG3hxbsNVKKY6yli4h8KO9AfgYX/8bVwWLeaOazuR/Rj/l5ViKjPdZXZIdamHcJIByPDf7o=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB7985.namprd10.prod.outlook.com (2603:10b6:610:1bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 10:49:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 10:49:19 +0000
Message-ID: <f8554f5b-5a3f-4972-8bea-36fe983ded5e@oracle.com>
Date: Wed, 15 Jul 2026 11:49:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that
 require splitting
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-4-abd.masalkhi@gmail.com>
 <33aca226-f744-45e0-a137-1f85ab146e02@oracle.com> <m2tsq0eff4.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2tsq0eff4.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0115.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: fe0f2d26-0e89-4552-b05e-08dee25eb8c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	mSgXF7Yb0XYggZEcBxUJ6gDGq90KFB+g6HaMjFx2m9CXjRufaC5m5ccJmDlO9BcKZZMBpUT2sgI6l49v15n7/04CmY/DN6LmReBasnnntK4BcpObfewZvQ+IVs5qsDCT59WIgTuedvJavToClx4QSicoUfdkEwMH6ozMYlfHEv8//evhNRyQodNACf85gKD1BVJD/F5VWw86rsHZ/BlZ2MbjQQ9kXkEfs4WmeYzlr8ej8yoNF+qAC+vmSnE2xPEJYpzR9Ds7IAMAaPfiOkhvoEpHtXsXXcpV1AN9Rcjk1lwvd2Uw3CFAyT5y+dm287/AjGNCnLZ0lVejZqQpJC90tv1qu9lbxPHsmYMEzSBAVqeb333ssXyWJN9HUUtE04yQXz/v+qblGpJV21TaRuHNlv8eYxSh8YHd3LMaSbcmZO0V5mW8hV8fJdU0Xz861koo79wnmxRb8dLFqnR6U4UIRv93fGhsi9S/mIxPJ+kDhFv/2lkyZ9Qlxg6NDSHsFTqQNaH8BBzkaSeozJYignUK9/0m+zxLvtJqWfATfP8DDuL5oqwr761zueI3Xfdg6mLRcptM/bOkbghkM0jLh4aSzHM92HhfJVnj4qJ/BlsiZLYPvKRz2VSthAfJJ4RJlz1ZDg7QB/BrSBJdUtgDhfhPbKzYsXakC+S0MClGaQJoSsQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGMvWFYyNmFOUkRKTUNNUkpVVkxGcklKMVQvclMrQkRDdGhsVGdmVUxUVHRD?=
 =?utf-8?B?aFhtdFY5WG1jUmdpNXRIZkJDRHZCSEVFSDJjNDl4TWZwMmdlYXpwaXUwQm12?=
 =?utf-8?B?MWpKaSs5c0R5UU5PVUowNXBualgrNm5DTHlyYmR1MGFzeFJqK0dvd0NUeUNj?=
 =?utf-8?B?RVNDakdvWHlsN0gwWG0waTc0UFA5RDcyc0tBWFBJTEw3c1UrUlRLSW91WHZV?=
 =?utf-8?B?M2hxQlN6dmFuMzRxV0k4VTI0Q2dybDR0NVY3SHFYc0orQTl4QitXMVRESHpL?=
 =?utf-8?B?WWNqZ0xPR0ZXdTRrVVFsaS9UVnYrbkVXcUh5cE83cjl3VDZPUXcxdnY3K0Vm?=
 =?utf-8?B?NmgwSlhQN3hlaFhxYkNXdlZGN3NKeGtMci9ZNVpjUVFrZCtRSlRFMStEOGp6?=
 =?utf-8?B?SldHMUVoVS82eVRhRWJIb2ZoTzFxRUVYNEE4V2RxZ1Rqa1NkQzduaks1RGcy?=
 =?utf-8?B?VVRIVVlwQllEQVc2d2VLcVJWWk9ub3BKWDV2amFkcHRmMG0vcWNjMUR6RWxD?=
 =?utf-8?B?ajdiZ2xDamJzNk00c1NVZWtRRTJtNWtyTkYxNGFVaVBHaE1RcHNsMjAvMm1z?=
 =?utf-8?B?MWs3TTFnS1NGbmlFQnAyaUgwdEJMTHZvNzFhZFRwaHF6dUNVNWdHVFFabXRi?=
 =?utf-8?B?cW9mZnZtSTQ1ZXdYb3N1OFhaUktibzBybU5FTDduYTZTOUdJTUNRNHFRY29x?=
 =?utf-8?B?bitFOXB1Zy94akJrRC8xQ1ZQZHBLaENvN25HQ2dFclhCYlJGQnF2QlR1aTdK?=
 =?utf-8?B?TGhlUmxvRExoS2xqZzAwMXRDRno5UHdKTkFWUjFJSnk3M1RYblNvZjBJTm9o?=
 =?utf-8?B?YlpqaUhwMUZNNU9iR3hVZUpjSHh5aTRuNU40TnpiWnlHeVV6enlnYzVBYzEx?=
 =?utf-8?B?eWY1UlNvUFFLVm02clNhVjZzR2YrUTFQc2lJSXR3bG91RTd6R3g2dGNIbUdM?=
 =?utf-8?B?R0dqYXVvLzc4Q0NYWFh0eDNLZjZtaThrdmRHbUt5WUxEb0MySks4VWhNM0dF?=
 =?utf-8?B?STlWRzVnbWxFZHRnY0pQRUx3NlFMNE9yMGNySEVvc2trM0ZmYzcxZUUySy9F?=
 =?utf-8?B?Y29XMGcrWXowM0hyRi9iMm10UTBFUE1lZnRlZCsza3dpTnRaUFdZU3IxK0dz?=
 =?utf-8?B?aU04UnZ0S2luS1VSZ1VDUUcyQ1NOL0hENjlsTVN0ME1rdjVxZHowcUlvdGlO?=
 =?utf-8?B?clZkUWQwcFFkcmJhUmNtQ1d3eDZrdEZ1NktSTUVjQUhVRjlneUZ6Z28rU2tD?=
 =?utf-8?B?azU1dzVGUWZIMUE1dEt4U3dWWTJjTkFCMGRoSXZJZFg1L1ROT1pycnhMckZk?=
 =?utf-8?B?dk1EM2hmVHgrRmhxZUJxcVNsZzFlaHg5YkdyOXR0SkRxZjdrSWc1b0ViQjVj?=
 =?utf-8?B?UC9ieGlOdVR1cEhGOXJvWVpMYVNWUXRPL1RuTzh0cS9ObVhIcVZ2aEJWTDRw?=
 =?utf-8?B?V2dMZ3psL1VZN3NvZCtGZHQ3dmxLN0NpdXY4WkRHdldqc0hoMitGRnMxQlU3?=
 =?utf-8?B?THRQd1FSZk5BSmNNTU5oYmR3MkpkR3hyUFlDRmF1QlM0bzhoSlM2ODVHM0tN?=
 =?utf-8?B?dFdOK1ZBaTFrUVpjaUIyWGRVRXpVRHYxV0phWk04K1dWa0FDSFE5TEF5SEw2?=
 =?utf-8?B?NCtkVnZ0WTN5aWxMS3JzaG9lOWkySW1HUUJ3ZlhNam1DUGNiU0gvUVQ5Rnky?=
 =?utf-8?B?LzVoVHVub2ZVdnVEYW1SUlZDb1lPS3BBREFGVjZzOUk5K3FTOVU2L2IrMHQw?=
 =?utf-8?B?TDBtTnFpajJjRm4wL2dDM1A5eEEwN09PMmlyM3VGNEYzM2JvK2p2YVN5NHVy?=
 =?utf-8?B?ZjdLOGpXa1h6VWNPSm9rK2hEaitPTjZxYmprOFllZ3o4UUhMS0pJS3duenNm?=
 =?utf-8?B?SmJncXIyKzJ0cmR5NzlKbXJWaktoTncxdGFXeHowTTJYVlFuZUJzQ1dNOHZx?=
 =?utf-8?B?MFZHbkg1SGdhWGpFb3ZxZHNDY1FIelFiTXdWcnVXcTlnVTJQY3kvRXBwMXVN?=
 =?utf-8?B?NDVJaW52Y2FKdTh5dEh3V1RYaVVFOWxXbkk2V2NWcUJZd240VEVOZFE1VWVW?=
 =?utf-8?B?SFkrRnhCUTUyYXZHdzhFZ3M4cnhFN2M2Mys5OGMwRTJKb1lxc1NITmx0Q2Jt?=
 =?utf-8?B?b25YRGU0R2FIRFpFUnRrWjkzOGc4UVJXekR1SGNMVVl1YWloc2U1eW5wUk5p?=
 =?utf-8?B?Q1N2OGlIQjRJUC9tUnJkeU14Qkl2V2x3ZDhDU04ybHRFM085RUpUYWxyNCtK?=
 =?utf-8?B?YU1ua2ZOMU5vYi82cURjOTJXZEpYQmYwZnFiQ2x1SWo3dEpnMWJ2OGhGMzRE?=
 =?utf-8?B?SCs5R3pqUkl3NzBkVTdLNmljejM1cUJOSkxSYjRZcVo0MXhubGtVR3UrcWZl?=
 =?utf-8?Q?sICiY93SUWzrwXc8=3D?=
X-Exchange-RoutingPolicyChecked:
	n/akve49VPNgCEZOtCKp4oofyOMAfrj/UxDZIvj51wWGdan2Fkb2B9dN5N5SikxLmP2U9FBty2A7NPXxWOr8JwcVsQysNCzT0MUmfR01b9rJP9ljSjrH/1zVR9oMmrEqIzhqEx79VssUdWgzEvNiijeKo0qRS4uIPTS0cC5BtUlGFx08SQVqK14N55qQBtDsUkF6wBsHbLEGug8WxGzOdXWIoL4Y7vDi0UkAEs02Z+5qX6bmnEM7df8mSpE1HufzhOMz5avDOJnb+vA8SnSgrgtAshMoCoXGArfn6Ewu/NdMp1QPXwDuVrAXTtjw/RZPwGFcQb4TngF6+bo4P1oU+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jZ9jF+jM9qiaI6wzHJqXNMKuONwT/prRfoEITvR01VpbiR0vgpnZH7CJUXzgqqmVn73nrZuqryTzoBWPHwLWb+pX8aWR+5KA8Vjg5ps2mVBipgGX+WJXNEy9aGWFYm5rBMIHNFkHfR/I1HELvXfgmAYi+wJ082v8RyMo9MfdDW/rXRcbYEYhCpfV6cX/IKKse/Xw6BSZGlm51RILvdmbKOomXXM531V5Nrek7xdvGCXBxHhPtIbjU2MYR0XVEBHBFib3KTaRDNSTtHi5f3LhFvx3FpHd89DNKQwpS2xcoJpx4yXisFzWqnVACUMPo3MlN8zOVJqxtxiQS/Z2zsWaml/i3PBjsa1stB3IEZqVOqPlywGzq/B9I9djfo95Ivstr/b0q4NL5YLiZa4Iv3IVuIAY5zR+XJ7tatuimzsX+KgyI56mEXXvq0Cx8s603ovIbovEouKGUUyloVn4uoqzTd80Rm054dzUwpaFej5b3M6uZ/XUpIPZRP3uCv5JVkq4CeUSXHFwUmcfQ6aA+22u5+0Nr3ma/3OgslOC2OD79il+RFq4KIGX0CZtK1y1Wds7jF+V5MeBThCxkBM3HoDkvVUSZ/RAjFUh5EG0eyev9LM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0f2d26-0e89-4552-b05e-08dee25eb8c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 10:49:19.0755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wbDovBH0vT/dT6v4B4eIkMuCxej3VoGF4fZkzVRvQxLq9k2mfGFgKY76WZh327KuvGrMKeHr5L8AMvAOtdj/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7985
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607150105
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a5765b5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=q3qzJH6UvgLXacJqrJgA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDEwNSBTYWx0ZWRfX4zjgZRRTo1zw
 Ox8WcvVvurVef35HQLK1IE2kdEXXEUF4l7AOm+MoCwF38+onWX66IMLY52RnTuMy0CLXo6JXLBB
 IeyCEp6U/xBGKjCDwfg4tLe7Vge3lhaErrXXwI97YWDPcdmvvLmVPaiXOYTVRgFrxILEKaeEa4+
 PO+UgK3Gb6jDECf6ZDKyWmUqRUGWm9/rGP2/jTV34fKre3qidrxEYJ9q9XoKamcf1Q7qOR6Dakt
 DTrHT0aCKythTtr/4qpS7QV4uvCuhZdt2F+Rv2vRB7s87LyTeRtVrJ7neXkiYbCoDAzxq1qGJWw
 0RZbN5lVN3S+pA/a98cK3fQD1S0I/QFxY0SXaxzkoIny2swdz2jXycHUfqGFJiJhFEuyVA0N3lK
 7P86XUr5hRse/SSflqhMJEZ/yln64LMMi/6EXkUBPcZ266cN6n4/soUjL7aBXSh+w9tShij8QP0
 kxH1NXz8Ey2HjOUNA8g==
X-Proofpoint-GUID: X_DE-t_0I4AQiygJFEZBtQxjqpkS0iGj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDEwNSBTYWx0ZWRfX1JDtAy7gw7v9
 xcPJX2tOLQZACL3mHeoqp9YID39lnWYC8lHToTEr48LrXGB/o/Sio6CFHMRcUzLveNMqCBLaC/2
 rctJks0pRCG+eZ0HJRGsICRmwjrwpC9/SRwifkpnaWzyYhDLSKUd
X-Proofpoint-ORIG-GUID: X_DE-t_0I4AQiygJFEZBtQxjqpkS0iGj

On 15/07/2026 11:05, Abd-Alrhman Masalkhi wrote:
> On Wed, Jul 15, 2026 at 10:25 +0100, John Garry wrote:
>> On 10/07/2026 11:15, Abd-Alrhman Masalkhi wrote:
>>> RAID10 currently handles one badblock path explicitly by failing atomic
>>> writes with EIO. However, another badblock path can also reduce the
>>> writable range and force the bio through bio_submit_split_bioset(),
>>
>> What is this other badblock path which you are referring to?
>>
> The other path is when the requested write overlaps a bad-block region
> from the beginning, but the intended write extends beyond the bad-block
> region. In that case, the current code silently reduces max_sectors.
> As a result, we end up calling bio_submit_split_bioset(), which
> completes the bio with -EINVAL rather than -EIO. This is the same issue
> that existed in raid1 and was fixed by patch 2.

OK, it would be nice to add a concise version of that info to the commit 
log.

Reviewed-by: John Garry <john.g.garry@oracle.com>
