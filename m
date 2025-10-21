Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD135505C;
	Tue, 21 Oct 2025 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761050006; cv=fail; b=mylJ/daqx+/5TBG1iL4KUsX7tkUs3goroG+PwVQfmcHL0RuGFkpEUf2GYaAbghqJW94CCL+Xpt4HKHSg9nrw6+tckrMMwD2/IvkqnjoVCnnskxUBtoDTfuva91jGwLjjNOZRKX30P4cLMfAzWYkPE2qy3WETYakVVixCVMAXawk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761050006; c=relaxed/simple;
	bh=7qsRBfPLY+PeIIqYmLQSzP0z33h2aab8vr1taatBWac=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=phRCaRz4o4T8heagTwxDXWdefXr6N7wogCBBNrZ1ijZlVAxcmLGFPeWashGkeTUHKZzy1wzQHVZ3JEquHRTQqAvVxzGauzXisVV9FsdlXFYw/9uWMALbvduWe1DZlD1oS5vyoUacqHxMZr5Elx081XjXZ1SibPh3ve6RfsyMvX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o0PeI45E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R8wkmyt0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o0PeI45E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R8wkmyt0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uTvn007810;
	Tue, 21 Oct 2025 12:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6gAUtWw83+GESbmIuOxQHEobJAg5v9h1HBKd0wlsnvY=; b=
	o0PeI45EW29ZPh3uRypS1jnBgFKlh/KPm2ImXAhu+b0DRIj8AMDQjDokB0Cze4NT
	JpLzx5YTIQcvZhmjswuVn6kpx+5TFjK7lEkpq/hdZG+BZA375W5lQVsyC9rCtVgx
	BxvctIWrvhVbySirdCMa83d2GzmARZhlNWB53SS+l0yAHm8UOSU1oA71FETI2H/2
	5x2AgDuhZsQ1zRzuoXcUuOa5Z39qj5AEDd6LI27A7qJaCsR8osgDNOH314/grunG
	5dCTmccT+MoS+SplXIpAJxjLFZv0Gd+9NAGTtvaJs6F6YgANNqSLNkw7fznKvG5z
	ebE5+SOXByowoDMBXgHaNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d51qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 12:32:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LA0uxU004361;
	Tue, 21 Oct 2025 12:32:58 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011003.outbound.protection.outlook.com [40.107.208.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bc1u0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 12:32:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8jguJw1izFVoWctHstW6LRDq5Albd4KdQcf0tsQOXPHkfXPYjyxJXtxmap7Sk6hXLshhUYwmwnI34AOqDjtftSEew+EetBcpp/XOCQI6ert67zFZhxMuhzu8ZQEeLHSiyq9jgr5vwJTrD/vNyqrQQnygKp5fl8BSPyOMu1SWpvjwb5o+jhv3LbsUgOZKhrP9IhF5p7wYVV2/SkNhCrvOXjY13bWZ8z/J4sqvgkMebkOHNbyc4CfwmSEUUVNt91e12ZylXekrhZki4mG0XWyeKjxLBaq+3NmlCNEevfAjn1LD5Jae+qDjOcIqZ87sRSZtRx3qORQlBlLXLhhO8gNVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gAUtWw83+GESbmIuOxQHEobJAg5v9h1HBKd0wlsnvY=;
 b=mEFZ9ZaQiyh3yl5Ly73z4d+GxGwDnS/MEcAsIW7cNfFmdPMXQgBAPiANV2Lg8XzVOlAxHIT+KTdq94Lm5im7na/ZAQt4pGuDqoLohoB0nrBg4g/3SYgjHwWghqZn3pGwtlbLxG0gglAGlEaV8+hXtpXNvmhHvTJMQSv3Xj5A6g7ucvx25vTvcxhHi49B7iSe54+rkGl2/+2KR+r4HPWPkcp4ptOU4is6/bfuDFSFfgOvd10mF2/qGsT5wPW97bIRL3dTudepPuRwmCT5/tDsJbLX1RXVPmExLYl65bkRvnmSUrRXTh4t8rNp5Im9LtW6xNq9EsYe6nTLNp4T6NjGKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gAUtWw83+GESbmIuOxQHEobJAg5v9h1HBKd0wlsnvY=;
 b=R8wkmyt0nLypAiMdFGamLhQiy5bQY+j0QAjMivasdJ36uN61iCtFoAxAgWlKNmcrwNsbPZSrlBBDoHrSQAUTCC11fP0EHJg/SgmEzzlS1re4oZqHafgGlEFNTuawdstsqDPrjuPcvwB39DDQx5sGthCcOvCJPoBH35B2D/CECC8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SN7PR10MB6476.namprd10.prod.outlook.com (2603:10b6:806:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 12:32:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 12:32:56 +0000
Message-ID: <77d801c1-110f-41d3-ba4f-c48d1eb92cc1@oracle.com>
Date: Tue, 21 Oct 2025 13:32:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
To: yukuai@fnnas.com, Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250903161052.3326176-1-john.g.garry@oracle.com>
 <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
 <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com>
 <84bbff83-b5db-6789-a668-61cc5cb7c761@huaweicloud.com>
 <c26f4b7f-f311-4cea-88b7-d1d6905c2c06@oracle.com>
 <5069c55a-5b3e-477d-99ef-731bacc6c427@fnnas.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5069c55a-5b3e-477d-99ef-731bacc6c427@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0412.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SN7PR10MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: e714a28e-9de4-420f-26ab-08de109df627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3FuVW95WFVXdFhmbHNpdk1LdUdmcnNJenZ1dTVsb09uYjFFcUIyTjl3TmVi?=
 =?utf-8?B?Mmxyd1IyRUpDNDRlb3R6UmhJZTlraGRIVDEzQTZmQVlqVmc3NTQwRmFKbkNw?=
 =?utf-8?B?NmhkMEVYT3B5VlRFMys2QnpSMXd5c2pva1VxcG5zazZuWmVMaUEzWHpsejNl?=
 =?utf-8?B?NHh1OUdzQ3pKbUlzRFkxb25tZFJYS1F0dGQveFRrSWw4MnlNQlFDOVFJb1dv?=
 =?utf-8?B?RVlpRkpFQjlLcTk0czAwWkZGcU9SU09sMTJhMkVSamx3WlJiOGlZNkNaVjRR?=
 =?utf-8?B?RmJvV0VUcENjTmVraCtnSEU0OS9va2JzTDUyK0VLSFV4VFY4SmN3bUl5NVdY?=
 =?utf-8?B?ZHhkNGs0aEtXRUFTOG9pdzhzQWFKWldaZ0drRnNFKzM5THNwU1A3MDlyRTZC?=
 =?utf-8?B?OFZqTVk4T0hBVzl2ZUlZUFF2Zms3b0U4dUNPbzJ4eURUNUpaZXBhaEU4TlYz?=
 =?utf-8?B?YTAzRHJhNmNqNlZQZVNyY2xXNE1QVHZQQVNVTUdDaUF3bmpIaGl5ZFplcGNJ?=
 =?utf-8?B?ZTdFYUZxcTV2NlZHRzUzN01tZTFDZS9sRE9TTjkwTW5DUkFZbUhEUDRJQUVn?=
 =?utf-8?B?aVM1SUpYSWN6Y2xva2F5Z1E1MEd2SUIzRFU4dlpGcFVWNGhHUDdFMW0wc01D?=
 =?utf-8?B?UG9VWFJ2UUhhbFB1WHI1YkUrS2Vza1lyeHI2T3FxRDFyTS9NTWtYSkIrdjI1?=
 =?utf-8?B?RWQ4Z0xJRW9WaXJ5bkVEMFd4NDgxRnRSalErbkxLeHFvL0twemxrL3ZmNExL?=
 =?utf-8?B?bEdoKzNEdWtCRWZEOWIrcGM5aXVuTXZTeHIzdDhpYmRlU0FjRC9ZSTd3WXRn?=
 =?utf-8?B?c3Q5cHNqOW55YnFvL0ZOK2ZaekkzY1I5OXZPd0d1WWlsZ3lWVVFxeE1TZjIy?=
 =?utf-8?B?T3QrZVQwZEdtU0FiTEhhK0FVeEJaa2RZUTJnWEZKYmxteUpnc0FuTWszS0I4?=
 =?utf-8?B?T21KU04yVzl1WnRCUkZFL0Q1b2ZxRVlyUU53YkVoMExGeFV3bzZxL09oNDJ1?=
 =?utf-8?B?VzhpL0ZDZkpRY0VRQ0tOZ2JKYXhoWlNaRVArVGdvckltbDVZU2gwbnVBME05?=
 =?utf-8?B?L3VvLzNuRkc3SEZ6Z21wN2RSbWpzTnJwMjZmdHVQZDk4TVI2YWFLYldaenI1?=
 =?utf-8?B?S1R0eXRQSFFtMENQOE5YM1luRE9EMFk4T2VaYXpDZnU4V3k2MExib2FyQUY4?=
 =?utf-8?B?YnMyUStGK080ZUJEU3IxMVVKOWpubkVWTm0wTmFDTDBzZHQvcWhvL0dhajh2?=
 =?utf-8?B?bFloZ05LTHZOZ2JvOEY3T3REalhMTUhQMXNWN0l1V0RPM3JUNGhzbGR6OHpz?=
 =?utf-8?B?VVZ1ejVJeVltZFQxcXRiUjU4ckxVSjJtbkhyOXNrUDZvdm1qZVU5dGptYnpy?=
 =?utf-8?B?bG5hbm80eE8wbmlpMno0d1B0WTlqZFhDUGhxRGNLS0tDbW80Rk9JaGpjRHI0?=
 =?utf-8?B?V0NhdlFaMW8wUmRJQXJrSURkR2QxNXhjeG1RZEVBZ2JacVBySzJvV0ZEcEtk?=
 =?utf-8?B?T1NBb2VxMEVvRzBnTXhFcmR4ZWUwZjEzWnhwcFkycjJLNm1xQ0RHNEpINkZ6?=
 =?utf-8?B?TFNJZ0hxckczVVFIUjRCRGtlaFRsdFRIeGRhTmdYQXFPd0tFUEIyWDgrWVZW?=
 =?utf-8?B?cWJYTUNheThHdHdIbXJ5cjFKN1JHWThicStlTUM1UWFBcHFvNTBsUTFDRnBx?=
 =?utf-8?B?NHhmeldJaEl0Rjh1S0gxTWx4Z3lXWHRjcU1EV3h1RzljcXRxV3NYbEQxTU5F?=
 =?utf-8?B?amNTaTA2WlVIL0tOT0kyeHNvdW4rVFpqUGFIVmVYMTFSQm05SDJsUk5vbEN4?=
 =?utf-8?B?NmJhYWNiUXhENnRwQVhLRDVRM21jOXlxTjd1dXUzTHJSSk9YRmhnMVN2M3NL?=
 =?utf-8?B?OThlVDhKMDZSdWJwaXVOT2hTbTZDdmE0Y0tQTzY4NHprb1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ync1SmpJa3g5aEl4eEIzZ0JYMmlUbUREQW1iVmNCdy9vS3dYQ2FhNGlEOW0r?=
 =?utf-8?B?Rkg5WVhFVERyVCtvenZJREhpY1UzSVR6QmI4ZFkvR0RpQ01iUmc0SDZzNUU3?=
 =?utf-8?B?RVk3RHA0a2JkVmsydE9aU1dPd25IRnA2UVBWOWwrcXF2aUFKYUJiSUVQTmxz?=
 =?utf-8?B?bmZqWS9TdjlteGlSRmFBd0ZtZmE5azJ5d3dHZFZvZkZzd0NGNHVTejkvZjdk?=
 =?utf-8?B?VlNzNjEyU3MzSGdQTGFLRGNJbzR6NmJVTDdBcGNYaEZIeCs5Z01QaExrb1E5?=
 =?utf-8?B?MzNTUFQ4Y1ZXWjhHYnJLcmd3UzVPcjhNWEY4aUZKRGZWL04rWGk3dHFsNU1h?=
 =?utf-8?B?K3plbENkc0hiSnRhc3IyeTJJVTN6bFEwckNOaVQ4eGNnM3RwTVJwNnZjY0VS?=
 =?utf-8?B?Q0k2UVBOU1dpei9Nb1g3TkFoQUlaREFHbkxuTFEweHdKUENSa0EzdFpzR05W?=
 =?utf-8?B?UGRiL0RaY0lEQWFHYWk1TjU3dnpyY3FHbFJmS3RSSHdwSENMRXFpa2w1UlRZ?=
 =?utf-8?B?RVlaVDFPM1QzOVFRb254L0RHYnZDQVJXUWN0UkxmRm9OQkVNM09jbUNaZTlF?=
 =?utf-8?B?UUt0M1B0aTRjczg0N0tPV1phbTJYZlRHWXlmS21FL1FxaXRndEVxSmt0WjRJ?=
 =?utf-8?B?bG9WZjI1T0FKK0k0OGE2Tnk4TU9MYVY2c3BTYmV1anEybGF6MWRhc08xYnpk?=
 =?utf-8?B?bk1KcE9pVE1XQ1J2RitMemVzdkpaUkdtSUlQVnZLQmJ6WTBuWDdvTWpoRC9C?=
 =?utf-8?B?aXpJbGg3dDBKT0srbzY2Qk1nc3BaWFpUdWxUTWl1R1JJR0E1c2RITmVWemhk?=
 =?utf-8?B?NnljODIzaXA1TFc2L2d0RU0xR0h5eG04L1JEZlRidW9UR3R3bXFyZ0hIVi9a?=
 =?utf-8?B?OGtmd2dTSk81NVNFMW5oUnFEb1ZqbkJkenVOaFpsRUhHdWw2K1NPeHAwalpl?=
 =?utf-8?B?TXJ2QzBTZndlZU8xc29DREhyMXN4OGVmbDU2NFEvbG1RRUt4UUJTV2lHejBT?=
 =?utf-8?B?S2RYN0h5bS9sRUFBR21xM2Y3bi9jV293RVUwb2tLL0R0TXcwL1FzRnA1WUpo?=
 =?utf-8?B?WkpXTTdUNHNESEdGRVIxd2FxekxCL1B6a1h6N1NVMU9QamtBdDFyalo3RjJx?=
 =?utf-8?B?cmtxR3QrRlliNEp2anUrQ3Yzd3BhSmZKZFlGSlhuODkrVHJuM05sTllwTlZC?=
 =?utf-8?B?WmI5T29jWk9oN0hhd3BDc1kvT21haUJlWWVPYTI2Rzh0UUdwQjQ5S0o4VElT?=
 =?utf-8?B?Qkpmdm91R0FXMHIwbW5wRlh3ZU1NNDZjV05jNDdxTjJpa1BncEE0bUpMQThv?=
 =?utf-8?B?MWdFTmU3TUlwRWhUYlRjRkJwM1VGanZRdXFUS1JveTZ0ODJHQ0RuT2FxL0RZ?=
 =?utf-8?B?dDhmMVBEMGNWQldsZlZTZitERmZGdytVNkUvanIwYXVkUHkyQjVRb21kMkxV?=
 =?utf-8?B?NEhzSUVzT05ZdE00Y3JZT0FldzhrMmlUZ3Y5aHlHYWJnQWdjbGtubnNlaUZo?=
 =?utf-8?B?TW9hc21BNjlPc1lYeFRqMFZPT2NFRHNnYnJiUWM5VzFQQUxjZzIyVFNKTDZT?=
 =?utf-8?B?eTEyd0FSaVdKMjVtTEFmYTRNSDlyVWJpdFpBOEI4SUN4ckFxdGlURGZIbzNE?=
 =?utf-8?B?eDdpYWZqdEhaOFNldVdPWGdEdmloWkRpZHpvNGJXalJzTmY4b1FzaVFJbGNW?=
 =?utf-8?B?T2k1NytibkVXN3NnRjlBTSt6bm0wVmUrUzJXU2g0dldiTll3K1VuM0pJenFU?=
 =?utf-8?B?SmxxT1J5T09uSkdhRmh5TVRXTm4wemdxMk5GaEczWnhodHl5MHdSbFUwZjg1?=
 =?utf-8?B?dk5WS1ZPRW1jaC9aT2xiSG5tbVhwYzdHSnZBOWRQRzRaeWhRVnpCOVEwZmth?=
 =?utf-8?B?T1NHRjMyQVNNTzhCbkJhcEFIS0tWZDc2d3JmNnRST21nalhqRW5YMlRlRVc5?=
 =?utf-8?B?OEhIWDEzblUzdDk5OXBSOU9rUzdvREpOY1NUSGdORjN5RTlhWWRac1R3NnEz?=
 =?utf-8?B?Q0hmUVM0V1hNVTJrdDcyTzlnSXNNVTR0WGRxNkFlbnZsNTFNVFIzSWExYXQ5?=
 =?utf-8?B?TndtaHZIZXRLWmFkbWhPMlgxMmRYcGhJSklQVEdJMlNsc3BiczZGNmNvQkts?=
 =?utf-8?B?bVhrUlNHQTc3UUNYTnF3ZlZpTitpeVQvRVlHT2E4Q21KclozaVN2VEdreC9n?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eYBp2FiH6niTkeWlK1Ho6WzJIc9SwTDyy9lHmDeY58DCrO7dsm4qDD112ewSGg3IonGmn7I2fZWzf491hj11Yu0ei/9l82mvmriNE1nJVj/CXyPj7dsypGZqx1rNm0wX0Qy3JlgTyn8BH+r23RNoRMRKZBfm9+28RojfTQ7TPkXv95MYRKABViLcW4afEpbroxXoso44iocbQAo7VOd58E2RU6HEv6tunL4WU54zxChAdontZOFtxzun/rB9EpUCrO9byn8pAAKEiHjAO1afmr69U5zqyQuuGzdTE4jgvjKHaSbG5/FfasiLh+4AbdAhWk91IXBQ0Z9EhfefJdaWcfWuFOyA+Bvtr9ruROVmEzxghBa1VFjQbySV98PEiM0AUTSzy0ByXVb+OlJ7YFZvd+BH0QYKIW4hRg0GHX4ZfDIiekBffU5YwVVTD3Gx2pN6g/U2L4qqn5fszxhiDEyPNvWckm6XJhpajt9Uj+ptP9nGtJ93TBvZ+Hd8ZChtQp6rMUMMRe89S64eXBPA5yBUSNgl02ItimHrOVnMXUi2hqChpegdJtj7+CtoMunCstMaHkhTvZTbrno5DnsaSdvU1icXy5hWNV3M6DAgOf92YXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e714a28e-9de4-420f-26ab-08de109df627
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 12:32:56.1518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wkk+8HpUIfzyHUwHZI4xSUt7vacGEfKCY1jhVWDdxA/u8B1N7G04DpXl+b+coZoUQGMnXjnjXu0KDZX4sb9XBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX/I6C5T8NU+Ct
 //OpSk6W7zh0n1Gvm1vQTiwBsgXzo7bZ6zfQ00NTZ1HV9lbGgP7Tf1tQF2NsqCHrAsHyfhwcboS
 6iKpDWg5OxiEngzxc9gUYc4wKul8h766uNWDHkfflihibSSZz+lmDtbftwfr2kN/XlugoNU4YA8
 UtYOh+X4BCeVRXi+h5dGcXL/L91uSIca+BWNeZxBJ1ab6VHkCYtP6RSIAFaphwafJDja2iFmXoH
 Y2Q7yZXj6/4lWqd1oVrW5Iomfh4F6UJVTDjEC9BxY7Owok++5MlQ7OUf3NxFRzwKUaP9vVmnCBO
 rQYwN6eCz63h8jisSam2TJiqeeP2unCRz5PTJ9V87Q9I33eo4hqXREHQlIKnczNCEkKCGQo/qsl
 QjQ0ATgGyzWtgWojCQ8sNP0IiI6/pQ==
X-Proofpoint-GUID: JwncWVuBSv98EX7ExU0HXGQrr3CtheI8
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f77d7b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=VkNzIX_FQvQJ0w2z9G0A:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: JwncWVuBSv98EX7ExU0HXGQrr3CtheI8

On 21/10/2025 13:06, Yu Kuai wrote:
>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/ 
>>> kernel/git/mdraid/linux.git/__;!!ACWV5N9M2RV99hQ! 
>>> PjpAiklrZ2jXVm26MVHBqbH9IDHG-09hkOGCPfhhjaY_LmpE8adnn00dWKuC3TX8flblYA2DICgZeSY_$  
>>> commit/?h=md-6.18&id=b481e72d24feac15017b579232370aa4b33d4129
>> This does not look like to being it into v6.18-rc - was it missed?
>>
> Yeah, a few patches is not pushed to v6.18-rc, because I was switching job and the
> old emailyukuai3@huawei.com is not used anymore. If you don't mind, I'll rebase with
> my new mail address and push to for-6.19/block later.

thanks for letting me know

I'll keep an eye out for pull requests to Jens at the end of the dev cycle

john
