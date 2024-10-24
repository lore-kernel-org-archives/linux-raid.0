Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D818A6A8;
	Thu, 24 Oct 2024 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763885; cv=fail; b=YIG/IYWqPllXd9QJXshaqBaSe+7seXFG2jd7gRYPs7h09hwqpLtPJDosLiaEaOgKVuw9MDcAiBpexI7qVxU0dxwwUqURO+R3+WNJ/I97mek4//E4TYB8aZvgtcCA7LEgJuqqjU9uoMHslbWl+df2ON+QLRi3rcsDV3nL2yqaptE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763885; c=relaxed/simple;
	bh=EZLT0LwhxcvRZOEeNsVdVd7HIxT038nGz1pvZisR500=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jQoAHp3+3AiVp/5H8HRVML56RELJxFi6X954N+K3KHUaT5ZaEDZTijS/grzJaqh9CQxpmS1gRIi+ePAeljDGDPndBOxgHvjOz9h9FEV+e0pTzPbsiHbg9dM7Mue9bZDXpdUgjwkwf8n9bIjbYKdOnBndRbErLpcWyHCdSKfLgg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WzDU6Wr2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dE23+5Vg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzDU6Wr2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dE23+5Vg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49O2fu1R012085;
	Thu, 24 Oct 2024 09:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9fbcOk7/agtPniL3CySZcMnfU9HXduR9ETMsed1XsgE=; b=
	WzDU6Wr2aDrCiEzqhipLPqBeEGzaQrMeSpPBP/fS0tViXmn4g4l0elXjenZxzmwe
	6hP/HKRfRYsckjtqaRsJn5p/E4MsdBzqu3BqJpoj5j6+ZtAJyXpoSc2QPh7+bUDI
	qsoZY99uu9JerLeyQtKsL2rliyz0mvGEaVtVfR52N14skldTPw6ERbcYnclPTPST
	deFqHZW8Ur7cvwX52wYF49iJwsQvKPq1NrDVBnRsZpQW1oBT45Gx3xBYv+yJFb/z
	gSUyyRTuqtFG3qnG3SG+DqzCfjZ4WZoh+Tmjpx/PgVy7IIAwsQ/BfbEW4NgdtyWy
	L0dgSkJ5m9SvcL4Ok6SBoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c53ut59q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 09:56:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49O8NxY1025346;
	Thu, 24 Oct 2024 09:56:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emhapmuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 09:56:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWCaaT3G9Ceu3qwWdi2tsSMLoymE/yCUih8kBDi4cJYt1PY89mrt5WsZLVY+PnM6HyTvqT79X8ipqdYhW1NZpSqclo+81Fu3eCt8DjVb7crbe/mDCDTczk+oZvaNImUO0XdPXHHI/vPFRa5ZUEKyp7zvohhB71MuNZDVu/5tCRHd2+53Zcbu3ZdYXOZ3TQwG3U7+VGMOUsmJqq4YYQT2NTlbAZ3s4iH+wU1KBkWxiiEaukLeD80VxAwCN0h9Z0pRavC1ONOyzYGgpEVzOhOohFVjw+qSop0As6znsGChRVe7EeTk78yBOHl9WfKDK0Dae0VtVCWnnRyrhm+kzXRs/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fbcOk7/agtPniL3CySZcMnfU9HXduR9ETMsed1XsgE=;
 b=fPUDKPsayZeqjws1wT5/mymoN77VdI27td4xgP4Qnvo/anORowrYpdYdoT+omwK7xmPWCXtYXIToZb/pUIjTFomDv74ObqUW1Bd1j/ze8NYCqD3khr+625tMec6vjPZcj0Mv+ZNdM2ND7J4g4dcXBhr14/vyP+y9umZV/8MvvoTcTxDEiqZGscKyZG5e/y9hhd5k8mNzsJ0Agqz1uDWy3viHqafcjbVjlDyqJNMfprPJGNECnGXDBpiem1fajXL3EJLBvNVQ8RqwL7+7SbgEbqJhGAK/ozQmLHXaX6f+gy/VV7WnzgA4BCOCFMWk0URo4LaX33URYyZjwAngDktwug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fbcOk7/agtPniL3CySZcMnfU9HXduR9ETMsed1XsgE=;
 b=dE23+5VgegNpxcG51GfZaf1UMAyZYvUWCcNHifcxAgk14wEqTXYWwsufuIkhlP/SElZfuua0usniAwYGInKAM+umSVFLYra1fzvaKb8z211uXJNPjyKx/a4RszYPBDBnDGdRfTFEyjJpRF6W1lZ3ZVnlD3ZObiwnAniIqyf2Yws=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA6PR10MB8014.namprd10.prod.outlook.com (2603:10b6:806:445::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 09:56:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 09:56:40 +0000
Message-ID: <82a49b38-2732-4461-a714-908877714f35@oracle.com>
Date: Thu, 24 Oct 2024 10:56:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, Geoff Back <geoff@demonlair.co.uk>,
        axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
 <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
 <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
 <5a16f8c2-d868-48cf-96c8-a0d99e440ca5@oracle.com>
 <ea19f2f4-32e8-e551-c59d-19185da1be0a@huaweicloud.com>
 <3654e52e-d51e-4a61-aead-789e745599bf@oracle.com>
 <95915b76-97ce-55b1-6a5a-7ff8a89bc430@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <95915b76-97ce-55b1-6a5a-7ff8a89bc430@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA6PR10MB8014:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e30dc9-7be7-48b8-b00f-08dcf4122838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmVwcmRUQ1k2MnJnR1czVWN1Q1MrNzVNYmtGWlM0YzdRVGM1QWRZWnBIVDVB?=
 =?utf-8?B?Y1poc2xVVTcrNDMvejdyZXFLWmsyMEdOendDNng2Zzd2QnIxT2xCYWsyWHNO?=
 =?utf-8?B?RU5CZXY5VGxJTnBXS0s4a2tTRWhqQS84cnZqSUF0TEtDUWhZUkVONnR4anpn?=
 =?utf-8?B?RlV0bHNEYUJXVlU4dEcxMEhjb0tWZVAwTksreEJIVkp1QTY0cytwQjFrSGFY?=
 =?utf-8?B?VUIzUkpDb3NrUVhxZnROYWFkM0xtREVOUVc3cTVNRzR4QjdtOUdLM256QkZw?=
 =?utf-8?B?L2xNTkZRZGdSNHQ0QW9oNzhDbE9xdmxtT2ZGTE5DV2Q0VlZZWjRuRVoyejNx?=
 =?utf-8?B?aktsM0dXVVRaVkZud3NrRGdnRjg2QTRUZjl5c0dVNjVQT2loNy9waFBQSG5i?=
 =?utf-8?B?SGZsYTc3ZUhmeGR4M2Z3a3hyWlpPTlFXdDZ1TktTekkxSEJYSnhpdzJtZzRI?=
 =?utf-8?B?MDhvOGZqdlhjaDFKMWdONFBwYVVxaTYySWNBaElLUjBZNlpwOWJIS01SVUVt?=
 =?utf-8?B?dTZDem9oeG1udUVpQ1Rqbm40T1dDOXplYlNRZTFTRTFGc00xVUFiZFVEWVgv?=
 =?utf-8?B?N3ltN044UFBRUDJLRlpCZzNFdElXUDZhYmhGNFR2OXRvTlk4WlRkTFhSQmdC?=
 =?utf-8?B?VjRSUGxuRHMvWGZKODg2N2FiWC9TV2tVdDJvd3I0eUNqeWJUMjMvRmk1SFF2?=
 =?utf-8?B?cDBQUENMTFN1UC9ZczlwY0FQbXdLdDJXVWJIdk5FNzZUdVBpZk82MnZibVJH?=
 =?utf-8?B?QS8rVXBYNHgycjNIOFFjMndhdmY4QllvUFhTVGwyM1BmaVR1Nmppb3V1cWtI?=
 =?utf-8?B?TkJGUUpMTS81eTNDRjl2NEg3cFd5VUlJNWRkRVp3TmpoYXQwcW9KOU9GaUUz?=
 =?utf-8?B?eWNScEQwM1NNSE8xaUdUZWVDaEtsMzFRWVZYenhzUURnQktDZnlNdWVvb3Za?=
 =?utf-8?B?ZWljM3YreXovWVE5K04rQy9QWGJ4OUJadTR3WFRnYXA4bEpBb1ZnWVBxSG9N?=
 =?utf-8?B?dDZZdit4WWtTM3hEazlkRlZVb2JEaXJCd0dNNkpGVDV5d0ZPN1hWa0FFWmJL?=
 =?utf-8?B?OUpXWUdvYkN3QjdGbXQrTDAzeW9obGNDUVpPQ2tnUWRUUFNDZDVVajdzMGo5?=
 =?utf-8?B?WVlaNitNYXdvaldKNUdtU2NQZVF6WExpOVI3S3hOcHoxeTdvdHYvQzIxVVZw?=
 =?utf-8?B?YzQ2cTJSL0V1QXRLazdZcHI0a0c5a2taNC85SHZjRUFrUGJqVGpPU3dnSlU5?=
 =?utf-8?B?SnFhSklIT1hPVGhrR3pCN2puUmJJZ2xTUkVoM082T3o2alFvT3dUR0V5aG9p?=
 =?utf-8?B?ajZzc3p2N1VWeXNHOS9uek81cXVodkdrTWpBVkY4R3BPYjBuaDN2UXFpTHh6?=
 =?utf-8?B?cFhVL00wZFhSNTIxUG5aUGJ5RCtWc1ltN3pCOTJINlU4V1lPazhPWE9pU0tJ?=
 =?utf-8?B?YnAxVE9YakVFQk1TYVczeWl2RmIxL2c5a1NzNDUwWFc0NXN2b3VkMTZEZWRH?=
 =?utf-8?B?RkNwRFFGblJLSXMvN0dGcXF6YWg3aGxYSHRTdzRTSCtiT25Ldm4wVkNSS0tm?=
 =?utf-8?B?VjF1S3dxWHBybVF2dkZ5UDdOY1EyT0lMdnhTSkQ3bDRobDZFRXVqSGlMS1lM?=
 =?utf-8?B?Z0JRU1p5M1cwajZqakxnWmNHTUVwQnloWkU1VXdDVGFnUGdnZ05rajh3b2lk?=
 =?utf-8?B?azd0Q0dONlpGYjNqM1BMeDBCZFFQUFA0aksvWEZtakt4eFNrbW5TQTQ4OXpG?=
 =?utf-8?Q?00lwVEgwxNB6ERCg2qJkORVRJElJjV7eZFPTpIF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2FCanB4K2ZWYk1GMm5SQThTelQwUFhTRmN3bEJCd0taUkFnL0FjTDBPU2hw?=
 =?utf-8?B?RWV3VDJzSXYzWGtjUU9hS1JtQld0TUNmSkN5MHRSK1lQNlBPRFNObWpvSk5s?=
 =?utf-8?B?VXgzNTRSTGNRak13L0RvZnVmS3FlUm92VlR2elNmVHB5WTlYUVlRbUE0ZVZ4?=
 =?utf-8?B?dUY2NXA4eGRGTzJydWV6cVhGcm5UL0lZYXRGaDZXRVBubytjTmdGakhtUE1G?=
 =?utf-8?B?am5VL3RCOEJCRWdCSHJHSm5lalU2dkNjdHpuN2lHRjRJOUZ6QTVnRUFHRXIv?=
 =?utf-8?B?bWlSVXN3aXFyMnR5MmlHbDlJUnJnRVptd3pBb2hxNzBhTitlakc4d3N6STJ6?=
 =?utf-8?B?N2V4ZHN6ZUhJaTNrK1NwOFBZUUYybEQ1UFlwaE92eU5WcG5YVERrT2dCWmdl?=
 =?utf-8?B?RCtPbC80QlJZRlYvTmNvWWpxaXc5ek9KOFNZRHFKUmgxdE9hZzBpM1VKUUNa?=
 =?utf-8?B?ZVhCdDh4ME41bFFpUXJpUGU1eUNvTHV1NG9JSnFRek1SRUt1eDdiWTNucmQw?=
 =?utf-8?B?SnB2TjNoaThJSDYvQThZUGZFbEJXKzRMQTNzWFJsMzNqcWdoNm9xNzlKR1Ju?=
 =?utf-8?B?ZEZ6VmlPU3d1MVBlajJpVWtERzN3cGppMzZUazBWVmVGM1ZwemZlbkJJcVds?=
 =?utf-8?B?YVdWY1hrRy9xL3dleEZpUlAybDNGMkZuSDBGL3lPSTRvWUJ4Q1NYTHVJMk5p?=
 =?utf-8?B?MHA0Z0JvVXgxdEx6eS9ZbllsREN1OGlYMm5QSGJyM2JxSmNlRWtsMlFwSXJP?=
 =?utf-8?B?QnpuSWxDQ3ZxcXpCcFZFMVdrOVRBdVZkQVhBUmNwTHRqQ09vNDViT0NTM0pH?=
 =?utf-8?B?cUNvZWg5UjgxWkF1cnMzaWNUUkxRejREamN0akhoMUFJQlROcG9Rdm5KOWtp?=
 =?utf-8?B?b3h2S0xRV1NLajRsTEZsZFRyTDhkQnhxWGV0T2VIUnRBVmVzeW9DZUJUYjY4?=
 =?utf-8?B?VnYzeWE5cXkwd0c0ZFRET3pudSsvQ0JmeUFKTDRHclZHeGp3QlhiN08xeVhU?=
 =?utf-8?B?VC9rQUI2OVpEaHpwSmYyTVNvZDlYdWgrRG5sOFBqUml3bzQvbWV1SVNtdzJh?=
 =?utf-8?B?M0VuNVgxLzhTRlJLUDlNOXo2VlhPdWNEMkZqd2JaYitETVVpTVQ3dVRWZEVS?=
 =?utf-8?B?UDMvaEM3ZnRIa2FOK29aUHh3T2szRHQ4NTBqM2FlbmdLVk0zbXZYaUZLOFF0?=
 =?utf-8?B?VHZpTkN2T3E1OWhzbTFYUTZkWTVyZlVSdDBHL2VGcGJ3cUdwa1lTUDl1amJ5?=
 =?utf-8?B?eVJBWUJSSGZxRnhYLzE0clNxbVpJMTgyNTZVTkJHN1I0eGVxMEpWZXJGNENH?=
 =?utf-8?B?dHUwbkV1S1JZSXl0MXlsNVNxaHpxQmNpYmNkWHFvV244TTE0MlhLNTFYUDFU?=
 =?utf-8?B?clluNkhZLzNuUmlkcXlnY1F3MG96M1QvVmlDWGR6N3d0eVJMQWdGdGFTek1Y?=
 =?utf-8?B?NldDK0RvK3cvVHYrOUFGUlFUdGg2SEFIS1JmMFdSV2YyNlAvNEJPeU5UeVN1?=
 =?utf-8?B?N2E2MHIwWklBL213OEdzUDhIbHZFK1BrY05zRGRFaEo5Y2VSVlhqTkpwc1pM?=
 =?utf-8?B?SG9QS3B3di9jc0lNNVZSYXNWQ1o5Q0xjTDdnMEpsbXAzWGcrc0RhSEllZG5q?=
 =?utf-8?B?QTdMMmF5MENzR1BWV1Z2VS9wb2poT012YmgwcFNrMFllaHdIWEl3eE5LZ29B?=
 =?utf-8?B?bFNoMVM1bGpNR21CY1FFREs2d2lQQUN0RTMvTU5rTkU0cWJEeXRCWHlBcjdj?=
 =?utf-8?B?SnJTRXNpbXlPQzV5eWkwZjRoQ3Ara1RKN3dteU5NL3pvSVhuNGRRRGhOaU5j?=
 =?utf-8?B?WUM2bHNMdG9NbEd3ajBuK0JJTGNnUnRLMm5CYU5hdU5CZHhJRE1EclQySXNK?=
 =?utf-8?B?QW42KzRaeFBISTFlMHp6M0ZNL1NCQ0dla2ZCVDdmZmVGVjBtNnhhTEJjR0FQ?=
 =?utf-8?B?eTBWelEvS2NaTGh0VFBGYlJUVVpXdDExdCsyRkZPZ1BhQjVrdFlUZDhtc00z?=
 =?utf-8?B?Q2xDUE53V1dqNUNlTnd0S1NwMmtnVllGSFIwbDlTZnkrWFkxQXFaY0Qwa1p0?=
 =?utf-8?B?Y3Y5OEtaVE5uVWMzRDZlQzFGZ2dJck1pQVRQaFZsb1Jucmd2ZGhSTms0Q0Js?=
 =?utf-8?B?ZVR2SlZVNHBVc214VWdUNGs4R1g4TmNyU3FaS2FVUWozN2hvOVN4aS9YZDQ1?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gFAxbfhVYHWutZ50rNuQrMAd2N9Lx2Iw6PYKVMi2poiEyoh/3tqNiZsITrdSZDOMaeAygcORlz9uJObshyLexrm/oBwI5EoY5XyIZbFYgWHfcNOAiDu0R3+rR4te+bo3TGGY+8V8te3FWCLTRhCtgMMF9kgaiqkD4qdkfLlcicF0uiBK3iDNz1ItLMNJZwdPlfUTryO3j33d/FGGxUNfnuOB1VAwzLTH+JWuJtwMRAPwcEKPIhZYzI2GMg+qL3JBbDU1OMWjrmdSoTjEzvNYuBrdyswLn4NHLkgLz9c+9EWGYeuD9Q+o163XnQVxhoqbyAUoLt0e39+uaFHWMibYm9VUbfS3jonuz9+yRghqQ+HDcp1jPld4ce8ZXOJ8CSucQftiSEzT/CdfMd3klJEuCXEoOmjetdq9WqArezXznDYPcSHSI43gkf4eYgPo53YCIIqojczojcsixYfRY/36CsnLL9isvFqGR468cQI2Rx2vJYYkzVAnTbHMhjDbtumaZilGYlFBFsxxHa5keDMDm/ABP6s2TUa+Y4HPPjcIQdl1ru9pelO0r0Qo6rAk/r/FgZ46lgqrZ3/vIgNi3gZt3XTpoLfWWrhjSbgLg/W5r98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e30dc9-7be7-48b8-b00f-08dcf4122838
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 09:56:40.3482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DkY9q+ciDH+ZYtp1e5wcI8P6eF4kJ6kNh6RixRbld5wlknNRKOUazWa7GBTCHRx8uPTmjQiCCcl801lA8OvfAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-24_09,2024-10-24_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410240078
X-Proofpoint-GUID: -4Jmtmw3j3H8kQ35nE4dzasKY45HNBfg
X-Proofpoint-ORIG-GUID: -4Jmtmw3j3H8kQ35nE4dzasKY45HNBfg

On 24/10/2024 10:12, Yu Kuai wrote:
>>>
>>>>>>
>>>>>> Indeed, IMO, chance of encountering a device with BBs and supporting
>>>>>> atomic writes is low, so no need to try to make it work (if it were
>>>>>> possible) - I think that we just report EIO.
>>>
>>> If you want this, then make sure raid will set fail fast together with
>>> atomic write. This way disk will just faulty with IO error instead of
>>> marking with BB, hence make sure there are no BBs.
>>
>> To be clear, you mean to set the r1/r10 bio failfast flag, right? 
>> There are rdev and also r1/r10 bio failfast flags.
> 
> I mean the rdev flag, all underlying disks should set FailFast, so that
> no BB will be present. rdev will just become faulty for the case IO
> error.
> 
> r1/r10 bio failfast flags is for internal usage to handle IO error.

I am not familiar with all consequences of FailFast for an rdev, but it 
seems a bit drastic to set it just because the rdev supports atomic 
writes. If we support atomic writes, then not all writes will 
necessarily be atomic.

Thanks,
John
