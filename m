Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BB40B37A;
	Thu,  9 Jul 2026 12:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783599112; cv=fail; b=R2pW6SDcP7kSHEq1hBr6npXaRUh5DbYah3P60Cq6z3FEt7XJdddNXJlD0OCUpA6gMkUjz06qFaacyZ9WBygQh0Ee8h8PAaxutaDR/4/4V/OmyzxoHalbei2pJvdwStpIOVzmzKuvuNRRB9nEPdWl2/KQGdnhrS+1EiUelVGlqJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783599112; c=relaxed/simple;
	bh=6dzdM3vg50SVNf5SsFligWY3TAsGZTriHnMyKdA1lE0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l1SryMIZgZl7++axOFfQcyi/52Mg8m30RilI48E0NkVyKqN02XzZeEdszTGSVvFWJqsRbNnfnWs2dtl5wjeL/1b653HlAT3JNjSvawGb3uBszeGmXzI8mLYxepNLEjetM3IPZGkk8+Ptkb+QYhUW4qSVtrQvwamxzDdfyhloRlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ia6yucJm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AeyX3t0O; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ia6yucJm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AeyX3t0O"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6693Gs0X732177;
	Thu, 9 Jul 2026 12:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ged8k98H5pEw53eupPatHjW9Rz1oF8FwwFgztsfEeGU=; b=
	ia6yucJmlw1We1CcLUPo008faMdextEnyD5BS1w0vsWYjMM1ZwgufVaMGs99mMVh
	ERNzsFFp3y/W51nDG4lRxqNKwja6sYDte07GYROqOi+jAYCjoALQixAmBXSWNhtU
	daRWVb1v1kIjw0oFYajW1tWIiPGQULG3waWBexxX/w8ED8VrPTHgxp0xyTBjU1g/
	ttIRQY+0qWKGxGGyP563po9KwpqVs+c9IlW2Ag7FX5+L04j6EuD6iW/9v4OXs+FG
	899s++iW97khBxWxl5epQXGbvoUDkePkr9uQcV6lIHhw09MwbNkGMwLIKpLZqles
	TeD8KGoqTL7632o2pNRhKQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6s399de9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 12:11:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 669C8Wk4020362;
	Thu, 9 Jul 2026 12:11:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f8yv0aqk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 12:11:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXGjbQbZVGkiU/5wCHBKL8sg7P7Nm9XkicTmlvTmf/SgsOB+nKN1hI3TfxxtI4T0rp72eor7wX1jCZ0znspdrbTiF5qCaD7y4UHSuItVIHoyworMw95kIr6efkmhsJ0OGdIo/pDhV5uXcWoR49rlMnoi4ACJvyohRbwpCVWhuR5akVC/NZdZlnc+eReCItHGyl97sbfg3UD+zcXvM56bt2/0whgOacll8TvnwhsJsxUEEkfuUGftWk91qoBezU11Mx0VMRcH8isG6bB80IrWf00/CW0ledYsK4DCZRQjGWEobpWnYTUEKl+DnkC6Br1c0O8BnUO/oVF/ZrDg7r85Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ged8k98H5pEw53eupPatHjW9Rz1oF8FwwFgztsfEeGU=;
 b=xs4y5qFYb9vvGBkY2RVG0TzXR6F9aRZBOBLGr4SYeLwNDhUs7avOnPkOESUmp0BUV/EiOr5552RUJ+SZHVQxZaLNechnlnCbKz6QPyZNcMnt8Osj5S8ZM8pMz5HxqFmP8vqDPN4UJSnVye00PagPXxdxutr965vvzHlPKVanExJU71olKfvFsiHtAtm50cp1OAcaT4LTQWKq+l+iKmrF4IXOj13rusnJ250u+JwJEw/Po4H84GpE6RiribVBl2vS5PqATHX4y/NXoFnezzCXLyLqDjmcJvLbgkj/PQtMd8iDDJP7nMAOSuEWLLXaummVd2yRB5IEnxotZa543y5buA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ged8k98H5pEw53eupPatHjW9Rz1oF8FwwFgztsfEeGU=;
 b=AeyX3t0OuGSc1TOGq0WvyCPe0ko3Lw3aMOUEOQZ+oL1W0bbqahiXOLJGV7/KtyRS66GjgjQ2y0Ed5aZ/3yIsbExVhwhMSXxrWYhiPZJw74dd9AnAhmOt8kp08rFwNPVKCOXxeDNV+DaZpHulWw2FwWgDvU0DygndK2eQEjoLNA0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW4PR10MB6439.namprd10.prod.outlook.com (2603:10b6:303:218::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.15; Thu, 9 Jul 2026 12:11:21 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 12:11:21 +0000
Message-ID: <350a2662-7de0-45e6-a905-76dbd0a99e98@oracle.com>
Date: Thu, 9 Jul 2026 13:11:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] md/raid1: advertise atomic write limits and handle
 runtime constraints
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        abd.masalkhi@gatech.edu, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
 <20260708101341.473750-3-abd.masalkhi@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260708101341.473750-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW4PR10MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a1c1b1-a08c-49b5-e514-08deddb33066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|3023799007|6133799003|18002099003|22082099003|4143699003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	7yQzUcACYA5bghdXorBDtoTFL/vXAAojuFPUjNpqtS2cq5HyqaCrg5ZOJgJrbiYMIryqVe+PSNpmAsXmdJl8K4w/tCqpJeWHrvkzixUUpD7m3LNiugHRS5Gm+X5G0tYZdKk4pWkCIhfGVcp90eej3osAfhDt9lb50rNcYTu209cUytdzQoIeNAU8hqzkCnGbX6Ui33LUJykjUKQDrGGQ+PVp5klelmSDoxRjSHxbBX569/v0bDnJBAd2S4UijnH3a2W8zVKw8JjLTe0PXq97MxFagK/ivAvo2IJKK7gZv1lp98x1+NYJHCU/CDtdoHGeIhqXsFFZ//OIvtj6O4SG+Z7QcLJEKuJkTtevIHjLONRkYohKUvroju8auLW+Xwrt8XBe2+OdIcvFO56ZzPIyJrgZauId8Syx9fHjzcmQG4u/cFWqaUK4QA0Ffxf20PQ1YT5H4TkuFAp05lcegMafLKDv0ZqV3+KQR0RjtEJ2QS+gf7ZLc+JVm4TAATx9A3YhZ4wjGT2+Hu4GzGlsQGe2XtikemgSz1oSg6+XDj/GRFdks4Kv28euIGTa5WtRZIXfcGPDPcMXDiJfFMw5+9oiU1LWdAy+YuuIeVYmlLSs0PZiZfxIbPqjrfQM9XraDXQ2lOe553KAMsUTLt+6uz3osvksfXwT8h3ZXfJPsG/53Jsd+M1ZF3LRKyCt0fe1ohkrM82K+3uzmQu0sIEA8Erpxg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(3023799007)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDliL2U4TC9qRTE2cXZpOXlvSzdaa0RFY0lhb2JoemU4Y0tqblpYTlpVdWU4?=
 =?utf-8?B?OCt5b3YvM3JKbk02R003b1hvWDNPdkF0WVE4OXorN0J6SC90Y2lNYm5wd1hP?=
 =?utf-8?B?ait3cGphSnVaMVpEcUtUL0p5L2lKT3JmeG5keHN3dUF5VXRPY3RLVzBHakYv?=
 =?utf-8?B?bWEybGpxK0FDYWg4b1lRRXNKdTRlMlNDWTVacVJEZjhlMm5NTjJBQXZtdnFJ?=
 =?utf-8?B?bVUzOFIwTG5pTWFPVEF4ZzdQWlZIQnhXcmJEUlR4NnpnKzIrZjMxbFQwNW9D?=
 =?utf-8?B?UXREQVhGTmdub0lKZkZoS3dPb2xrTThtOCtMdm1LM3lTS2llWkVmYVNmR3VX?=
 =?utf-8?B?M25mR3E4bDY1N0p4N3B5Z1NYVUtBb0hvTzdIa1ZXdi9pT2YxQUY5OVIyQmtB?=
 =?utf-8?B?eUlnL2xuOHFPem14aDFNRWlaM0xHQkppN3NnTHVTMXUvMnpUWVZwdVhnVnBs?=
 =?utf-8?B?WmhyMG5XTnhWR1krOHFQMDhTMWpiWGc5NTJvNEtGcm0zMkNCM0JvRzNQSnMr?=
 =?utf-8?B?K2QxZzNPYVZUdEJpbUROdUNVM3hHOFhJVVpEYkdSbTY4ZkplLzcwcEJMMWhD?=
 =?utf-8?B?Q0l4K2xPZzVqQmNzaC9KYWFVaklPZE13WSt2WTVpSFdtRUh2aWxpcmZQU3Jp?=
 =?utf-8?B?MkxtUVpVVkVRaTNHMlhWSExLcXhReGFMMWQ2Vit6aDUwSVBpKy9YYWY0RTU4?=
 =?utf-8?B?SnRhcDF1UEpJb0Mybkd0eVhDZGVubmlZYzh6a1RuSS8rM0QxcTZkVUcwUkVR?=
 =?utf-8?B?eXhKR3AxdHZJc2dEUUJZL25jSGd4YWJmbVJxVXFxejJMMVdGWlQ4RnhKenFC?=
 =?utf-8?B?Mk4yTnVzZk1TVUxSbXI3LzYvZ3BiMThQU2FtZ3M1Y3FIVkFhRFd5K3FOeHpi?=
 =?utf-8?B?Q0VyMVk3blpuYmFTTlo2M3VZV25mcXNLalp3Z0N1YjZ6NXZFajJxYVhsbHF3?=
 =?utf-8?B?QU1IdVphVWdBSHdYQ2RTVGtNeVR2M2ZUaEcvWTBWaXNENGhFdUdyb05kTGZq?=
 =?utf-8?B?Qm5tQm95Qld5WFlleGwrTFl6VjRscGhrNlFsUVYrSEVrYlg0aSsvVTd5Nngx?=
 =?utf-8?B?SHJycHl1SUFRYUwvZi9QUUNlWXJ2azRSRmNITmZPUWZWSnNjQ29HUVhleXA1?=
 =?utf-8?B?M2o3NU4zanN1Y3BqWnVnMHdFRGFuajNkOUx3clAwQlk2NExtcmpTaHNrY1pE?=
 =?utf-8?B?NzhMTWNBeTZLUWN3K21hVXQ5NW9rVEtSb0U1OFlXT2lReHB1U3RjRzluNm1I?=
 =?utf-8?B?ZTFhbVRUamo0RlpTV3AzTGtwNWZ6Qkx5cE5hTU80YkhBekV1bG1iTGFwMnla?=
 =?utf-8?B?Qm5XeUZnTDZPOTZqRmxBV0kyb0FlZ0V4WHZxUnZiOUg5aUs3dXBzVUs5OVp3?=
 =?utf-8?B?RTVyenc3VlZNeXpGS2FyeEdZa1BhcG1ON3AvWnIxbmhOYVJxNXlXaGJiOUY0?=
 =?utf-8?B?OHJSNXhvZ1ZiRXFoeFNOSmR0a2J6K0JPcGJIcFo5N0RuTlJ4ZDBtM3pyTFFs?=
 =?utf-8?B?VkVPRm4ycUh3RU5OMS9FZlpmNExTRE1nWDM1bURXUU0zS0FGUWt5K0s0Zk5M?=
 =?utf-8?B?S05oK0dUMGM5ZGdIZkFhZ2JNYzFzWkd0UWZPOGhhUjdCcmZFMm11NXY3dEdz?=
 =?utf-8?B?NnZxaThPV1B5b1JUTkZaWmJhK1ZGL3JmdVVSL0FzU2l6UmpyTVREeExXZlZW?=
 =?utf-8?B?SkN1L0dTUzRmL05hWjMxVXAwUlhZbSsybGdUcU1ydDZESHZYTm5ybXFrVDJP?=
 =?utf-8?B?NVgwQXIyYjdzS01pdmZEUUhmREdZNGthWDNucDJmd0QwL3R3WlhJdTB6aERp?=
 =?utf-8?B?QXdXeC94SzM2WFhEZkt1OFZVQTNpMkpPSmVjeVplMDFCYk9xWHdQeWd4UWxs?=
 =?utf-8?B?allsYkNOdm5zMVM3a0Y5LzROanVWSGxRVFp2MVdRREprMHdMcy93ejRFcWlZ?=
 =?utf-8?B?djB3U0FyZjBQYk1NRU9RMnRpTjNIbU9GbFZqRlhNQnVnd21jYXVRYmttbnJK?=
 =?utf-8?B?bUlMVE14VnlldW5rbExlK0lDQkx3UmpWWDR6d3FHdVIrV08rRjBBMHllODR1?=
 =?utf-8?B?ZnhWcThJUFZ6Y25PaC9EUFdoK1c5aW40eUkzekFQVmJVT3Z3dTRtakR0WXI3?=
 =?utf-8?B?OER3a1kzS2tnUjBKeEpXQU10OEUwSi96aTNWL3FyamREOU5ieEZqWCtpOWds?=
 =?utf-8?B?MFFvdWhRcUxPcnZDUTRrZXEyL0RERE11WWQxeGlFdVJ3L3U3MGxFSlE1TDhl?=
 =?utf-8?B?bXNqWFhpMWtZcmFMbzdXSmROdjY4b2g3YWcwK2ZyZUswcDUwRWltTFhUaU5n?=
 =?utf-8?B?WXhSMTJRM0MyekdHRFBSdGM4d1ZPUktyVmdSS1dpem9NcUdxVTltS1Rha080?=
 =?utf-8?Q?sGjTodJ+ITZ/H1Zc=3D?=
X-Exchange-RoutingPolicyChecked:
	Kc34jVjBOuzYo9NpfGGbUh4if6j4lpqTsbqteQcljNvL+82E0bEPMCjZh7gZfpR6pg6yg9RnWCCGMsBmg9Z0n3r9r3a5s8nu85wMg5OPECuaB4bYQUT2eVmk9r42AuvtHhr4wuGvnyR5elVIlalO+F7eGtrUvNRGG4CbF8Bl+vDMDzDRfmPxBvbT4nWmGVyUFvmJo9ooGmoeRex7P3MT7kAyXPKMWahcJoIKLV7rHGwf57aQ4AG69robP1M1tRSqbOyqW6CZf6biSXNtJeaS/rIIV3ZG2ipNV9Q66zjAvGU46kSm05o0BD4ocIY31nu/ejmIvB33olGlqO/stalrdw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6Kv6M9r7WIiYciFazSxEFyxDekGqKXGh3SMOEY30vL7Yc28MWsE+AVIjJ9jnmZV1TuTvguXxZkneCSsoOSiZHMFxeiNjD7dPEaWfdPQzvwN4Phq30Ee6jWS2xi7uNJ2K8U5PuWodZhhrxna38n2Q4e8KTyXoNFJ7Pk3+pbBoIaTrtFVghwcjjJGqdzaTMVDwU8mVYaytIIeLDoFWEuVZhq3jtklwXmcSe2Q7UyKN/jgqjgo8ZoGRkezRmOr3QqVmBd3PlPJrQU+I4j8iN/d0nVrZqLQerwp1F8VNh8zt5LCKrgzadQIL7bS9aX8ZFl/6549XBcJAw0O6/0rBpqJFtUpCkIc+QHhruOwJxnRDYUD0/OxfpC6IW0QH8inDZoCKYrElBR462sTu4h6waLWVgnFN+o7Gr5KR3AlJFcl4Ls0dwJ+dOUZbbWEnoxrG+r8iBF//FW9yA91/82Huo0CuxouRuv7BXUrFDwTl0aG/JdlJ4emhLC4+kHii7ZpbPGRLcDUi8QdvRMGHpdjfYkucQsnFEarfZ22X3duBa8taS7rN0IwdRjGIk2b65AO5+ACJnL5Y8Mn+QBsdCtubKcEbRZIsRYcvC37oKL4vaa9cK0k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a1c1b1-a08c-49b5-e514-08deddb33066
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 12:11:21.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMmSoMd5QLxoArnBUyZpkbAcaPq14ds60RZcV5AHYCMEhwW1jsnel+ii7j5r88XAJI8sjXNY3scYeU96FLAUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_02,2026-07-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=924 spamscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607090118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDExOSBTYWx0ZWRfXy+rJNIwO8274
 Cn9EHWAAKzz8H7CXTwLlaZQxAVwmw0AHTbHWdNvjKXgercYRxKSSxz+GhnfMaaR7a+LvQaczGjL
 GndjJ+csvjDsNHjmub15YXOFyPJyC1AFWn1DwpgOgCy1TjhaAvT2WFwOQ8Q25Umj7KifAlV7X6B
 J8ELvb0qdndGmfNK3La41OzJc6EIZE2fEnOXtCUQFEEnCqLOtZpewIpo8m1Q+OC/TwnXL96CIWJ
 gEeNWud8hk+XfXKpqtE4lZPs4fzx65zA8QfscGwTnIwwlN1fteoPmD/14DsWdeJpmaIMnvCdQVe
 WwHho77gt0FnwmxP5v9VL1WLt8d0G8ibtCUH6Sn8aecO4/wxM5bBu2kcLi0bv49d7sEvBjcEvwo
 0QYVgPqYELDenJhUbavX9QhMzdyrSZSMilewi02C9RbVyjdGJxk/ZmaWybIGUN+r6lPGWX/pnne
 aa+T678dilLLCfEVZ+TZp2IflC0UmlZjRbg3LPww=
X-Proofpoint-ORIG-GUID: ZvAHbrTftK7hR0Pjy1B7F0Dbq-7HAtEC
X-Proofpoint-GUID: ZvAHbrTftK7hR0Pjy1B7F0Dbq-7HAtEC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDExOSBTYWx0ZWRfX8bnlrBROQvDP
 zz5Fx6AAwoJhOwm6N5jRwL+o0h0thjIU9uJ2SqwdnDyP5nNZOiOlfrr7yJjq34RIV9rB/b6b63T
 7GBZ++YE3jIc4OBSJAP1hgJVyR6ClgtYMXP97N/a1C9XIfgIMCPw
X-Authority-Analysis: v=2.4 cv=RI2D2Yi+ c=1 sm=1 tr=0 ts=6a4f8ff3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=x-DvOxez-S4Vae91BZUA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221

On 08/07/2026 11:13, Abd-Alrhman Masalkhi wrote:
> Atomic writes in RAID1 must fit within a single barrier unit. Set
> chunk_sectors to BARRIER_UNIT_SECTOR_SIZE so that bios which would cross
> a barrier-unit boundary are rejected by the block layer before reaching
> MD.

More accurate would be to say that we restrict the atomic write limits 
so that we never produce a write which straddles BARRIER_UNIT_SECTOR_SIZE.

> 
> A bio that passes block-layer validation may still become unserviceable
> within RAID1 due to bad blocks or write-behind constraints. In the former
> case, complete the bio with EIO. In the latter case, disable
> write-behind rather than failing the bio with EIO.
> 
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>


