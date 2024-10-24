Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9911B2191;
	Thu, 24 Oct 2024 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729760275; cv=fail; b=pWtezu+dplOKodpMGp8sVmcchjPYNTK2bnX8xYD1RGDc4oB/W0BW1mUx0InDgMP3Zal/mBgwsx3Yfqg+hjo9zcUH+CGSH9BGu3wu05JY3KyafrzPcIscqLHVnylnrDmI2GV4oWT0ucWHwYSoMDNO3jcNTuDOXwEJOoEIPLDMq/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729760275; c=relaxed/simple;
	bh=KNLyOIyuDy9Gt2cLiFM3wmCvfyvdZm82wMp45l26mlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ebE6+j1FiLqnA9H6AoEYdSGKYBCBda2Eq/O8G7aOBtiSkIoPXBooaSuNq8B2OisgxJXU2O8uBkS+tCnRnvZyw//VBxr4Tq/ddufCoHgm4R/8ivhMS1kIz6W5oDrrV14QvV67aiPA0okW0YGVF7tfG58KI26Brfg22/fP6BCy614=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ajmflxWB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wu8QrQQ1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ajmflxWB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wu8QrQQ1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49O2farF007215;
	Thu, 24 Oct 2024 08:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=R90CpeWypJFfEcopwIK49Zp03sb05J7qS7yX0S2QoMY=; b=
	ajmflxWBdiLjbzDXDyJ+i2SVj13s1/UrDLd0EeZuGkb35ZIMwyTV8G+FtErnl5QJ
	x0jqRBZ1u8jQydYUPZPdSbdQhuKBzv+DJEilrD5FyAL+Li++4p6sD3E+ww74jXxy
	TKIFnj2QdcdUubtxGxrW00QvJ1H/iQN40KasgTs57SS8PahiqD1UAONpoKAIYhFi
	uTsQeHwpetle1hZS4Pct6uG9VV/N3OriapYFXQ9Qb9LoTvPvbGKgBImAiV0bnDXS
	kD1Vc+dbjubIS7s8EJ24h5kh/hEwnJ6CtasiurKInacqDgn+wn+XXWIVcuRnjjcf
	DtmSRIUYy7BbgpYUt1s+ow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c57qj38g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 08:57:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49O8d2Le030950;
	Thu, 24 Oct 2024 08:57:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emh2mgvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 08:57:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGDKiF7pIGY1MxGe220Zzrfa8gJwYMyIxfnLplwK8tzgQeyzzPSXm2Zssr9y4rZ5UpjxKPRHU+1upypTXk218hGL3iFXkW8EFlpw5OPr9uLNLpvctqD3E1VkSIekVdf+IslV16AWryLJyszA3NMVcEjpA5pF6WC1EwmRNNdoHEMDP56RwyWclsn3s27HCT0MOMcs/n3bLPrg0hWOXwrlzjynVyczwmYW9aprgvksujR1hEeGtBFjnUml1f26f9A53RWa+WxsxbtG4V7h9lymHl0HiIl1SxIqSvLFyFgsxEDinaN5ROvpc+zgu5DmWgOKpPTT9bgyVvvyRmc20yap8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R90CpeWypJFfEcopwIK49Zp03sb05J7qS7yX0S2QoMY=;
 b=jlSg20lk5O2gGd9KGmN0k/Z+k39J4/B0Mv49M2qK5S0keCQL5DEuVWuZqaGzIuHvidOBMW7c/nOhIUZkz4I4J3CvCycIwgj3sIB2518afA8gqrGmcxQDu8zC5Ya5OCy7nztCEMe2FsLggt2B1WqHYG/ZUyzhjL1O2aPGYRoq0VYfyVZhAjx9j4wYU4jdVVUmv5n0aYiTHZmGcqoWztplqocS32DomNjojmD52+3xIndqJPbDNBHYQNOsKzw+IljJ0Oyvmimrpn7hF9FQIvmZrZY21v9XcE3oKboDf5ggTk7KsRz6gw+CeOgrgZX4325TCe+1U7eTNoVfWnfmA/QD+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R90CpeWypJFfEcopwIK49Zp03sb05J7qS7yX0S2QoMY=;
 b=Wu8QrQQ1JRqqkmtjvZvbHfladwkGbvbaxK5M+lyovH9+DfI3/8Q8bRfuQVbous5xHDMN5BLxswhpCfflmyODZDmZractU5ZwXHpSt4erfzEooqYx+zm8zMvqEgtg70mRV6X8jhp2tSLWj/TRKXWsq7JMom+XhyUClICBmKHde0M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7569.namprd10.prod.outlook.com (2603:10b6:930:bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 24 Oct
 2024 08:57:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 08:57:31 +0000
Message-ID: <3654e52e-d51e-4a61-aead-789e745599bf@oracle.com>
Date: Thu, 24 Oct 2024 09:57:27 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ea19f2f4-32e8-e551-c59d-19185da1be0a@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: d96713ad-690f-42be-66f2-08dcf409e4a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cE9vVmtMaGF1b1BOZHFtSUdDYW1sZFNIaUI1Z1ViSkh5eFNzbG1WSXJ6YmRO?=
 =?utf-8?B?Z3NIdXk4M05kWG1GRWlYU0xjSlI2LytWMkZ2YnBHdHErMEpPMW5aZGtKa1Ny?=
 =?utf-8?B?RzNXNmJka3J1ZGhYL2J5YWJheGNoamRJRU56S0tkU0RwenNialhLazUzanlF?=
 =?utf-8?B?MVRScUhpdU5lQXNvalkxS2pCaXVQeVN6bWFxbDU5aFVEUG0zQkp0c0dReHRZ?=
 =?utf-8?B?MFcvOXo4VmpSbUJIMFlZZjZLYnF2TUxTY2MyNnZSRmM0TmZSRzIyMmNGWjBi?=
 =?utf-8?B?OWVXcUg3bjg4TWdXR2I0REQ4Qk0rZTVTcVVpSEc1NDR2bzU2bnRleVBDMnVk?=
 =?utf-8?B?NE85VDlrdG5LL3RvZDUxVUFKZURiaUtsNTV4eVkyWVFCOFduRDRUcU5IWGd4?=
 =?utf-8?B?R1BTcE03OVNFZGRhWWlOQzgrMWc4RXp5bkprb1RkOGZ3ZGNtT2FkdUpCcUMr?=
 =?utf-8?B?dWtNY3NLMUt0TG9JY3NMdmNTS3dQci90MlRpSHJ3ZzVDdXZrbm5HZFBpcEF1?=
 =?utf-8?B?Z0RuUUFNUkFUNkcrQ2ExNGFuQURZeHBMZzA2cGxuZm02YTlQeXlXdHdibHMv?=
 =?utf-8?B?MmdOdjJnS0s2MWlnM3FmZEJuc1ZlL2lMcU1jN0dQN0FUQkRvVlhTdkJ1UVgy?=
 =?utf-8?B?VXB4NVlOUDFzZ1FpZWNia25oRjdtTjA3bytIZzBMLzRoL3dIZHVnaTlqNCs2?=
 =?utf-8?B?a0xwdjBzNmFKc0VKMTc1dVR0YVMyZ08wTExxakdmMjd0d0dRZ3prT1A4b1ZW?=
 =?utf-8?B?NkNxZDBkOVZpRktQQzdtbnA3ZVh2dkwwaVJNMzN2aU4rVUt2U0wwdm5VSHFm?=
 =?utf-8?B?bndBNnA5ZlBYQ2toLzR5T1JJc21zV2gxb0psSWl1Sm0vOHkvSTFURkhyS3pa?=
 =?utf-8?B?TmptMXIrRXpBcFkwOWZpTmhrTzdsUVJxeGg0Z2tFZXIwMGlKTUtXQitPL2M3?=
 =?utf-8?B?WlhaODYyOElEcWRqVGIwR2JRTGpFcklkVHFXdGxGelJMdTJOak1ETi92azh2?=
 =?utf-8?B?WjczTk0xaXpVaUorREp3MndmZk9tOGM1Q1F1aVoxZW95bWVrSCtnNVJjVkNq?=
 =?utf-8?B?Q0ozSTRCdmI5M3gySnNTOWoydU9RazhFSG1jMzdiSy9ZcWRGYnFDeFBCSm9O?=
 =?utf-8?B?cm8rd2hvQVQ4N1FtRjVsVU40YjQvTFlXTXZQaXVrTU0yUGRCNWJLMWJEQUdY?=
 =?utf-8?B?WndhQ0N1OGxTVGZXaEVSbWcvZGJPVEJBd28xZkNNU0hGYUl5TkFZb2tnQmFW?=
 =?utf-8?B?eWdVdzRrajNOOXB2alFqQk43b2lXNjhQaGJYUFpMd2VodWpwT1RwSUdIMUU2?=
 =?utf-8?B?aHQ2V002OTJpaWVhWktuZHJDTUJmcXJrZkJkYlhvTmpKNHNwbFErVDJOWmNK?=
 =?utf-8?B?RzRxMGxJYWZwVnJJYk5acTZrTTJ1aXlRSHhXOWdVelJMeGJ1MEN1UUYvODNa?=
 =?utf-8?B?bWpwZVVhWk9UTzgxZlNuOC9SeXMrRWwrYlo2OG4wWlkvamZ6eUdqaFJlVUdX?=
 =?utf-8?B?ZVFFR2hJdjl4bG5oY0xDT3dRM2xiWFBtUDNyWmZ2dWZVNjVNcVVjOEdxaEdo?=
 =?utf-8?B?UmV0SThGQVkwU1BhWW82S3ZnQlI4NUYrTlgzaCsvQ1BmckN5RkFhOHMrNnI3?=
 =?utf-8?B?TVc0b1BXbWgxVTc0QUJGNmV1OENsb0YwaHhwT0tGTDI3dUhRb0hSUDNmalZX?=
 =?utf-8?B?S3lNdjlOT09yRFJROVZFSjVJN2R2MjZLNUdNY1ByMmpsWDNxblRNNkkxWW5m?=
 =?utf-8?Q?6xMYOOxpf87pZrP9Fron6ojUk5Eya6RrgN2zuiG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFgwY2J2bU8wM2dpa2dNb0h0MjdENkFpL09mU0M3YXphUDBCMFdWcHU4UXA0?=
 =?utf-8?B?b3VrbG1WZnZnclBvaUlsTDhBQXN6aS9hd1E4Um9KTnh5ZEZ4WFZjNjRwZzRR?=
 =?utf-8?B?YUZqWGhVVW41MVRhcC91eVFoTlJVeGk3WG4rYjFuNm1kZ2FxL0Z5UlZwdkx2?=
 =?utf-8?B?Q3ZiT0hrVnhhNWhBU004WVl6QlZ1MDFSN0xoc1FQd2FTWngvZ0xmZzMzMGpC?=
 =?utf-8?B?UTFKdjBhSEN6MXIwcWQ2WE4wT0ZlU1JYRFN3MzdIcFgrRmJSSDRqUUhnS3JW?=
 =?utf-8?B?Uk1RcGp5MkFhWThjZmkwRitGQi9KeW9idU5aT2U0azVaMkhDNVlzZHZNTjM0?=
 =?utf-8?B?b2xBOWZaeFFXRytpdDRaOEk5S2daNy8vUVdXTFRtU1RtQnY1QWpTbmRGTTU5?=
 =?utf-8?B?TnN5eksxenhqbXZXaFcxYmNtb0NxeGZ3ak9LRHd1RlVxRnU2Skk3S09UcXo4?=
 =?utf-8?B?bVN2T1hWcnlnY0xESnBlT2FVSmswWW5DM3FOQ1hlendENXdiUi9xZktqeEV5?=
 =?utf-8?B?WEYwcVh2cE5tM25ZUGl2ajQzUVY4bHh0N2FrbUF0dXhVMldNQ1dibmQzR3Ni?=
 =?utf-8?B?cGJOWXBDVWVvWDJEcDIxZHRCM0N1dExOMWgzOVltUUI1TXQ3QlkwRkNYSlpM?=
 =?utf-8?B?Z29wR3dFYVhobG8rVGdqbGl0ZzdPRmxGc2VrS2JxWEZsYVhTWWVjY3YxcWlM?=
 =?utf-8?B?VVlqLzJJRThRcnhxbWtWTnZ3bUt5b3dGRHpqb3lLNlgvNXNOU2VTYjY1b0RO?=
 =?utf-8?B?azRVaE1yelNaZzRTcXJvaW05ZGtERFQ3elE5OWt4VG5zYk9Cc09henhvUFlX?=
 =?utf-8?B?LzU2Z2ZWK3JvalZNU3YyTi9WV0ZoSVdzUWxPSWxuUTBkemxsSGd6NlpvNlFV?=
 =?utf-8?B?KzM0UFVqWUxYNm1HUk41WUttbG9UUnZYTDZ0Q0QyMm92UG5mZVJxdUVtdmRT?=
 =?utf-8?B?QTBrSHRqSUlFQXhWVmRVZ1h0SkxHZHFiNTByQ3ZWWW05b0hVNklDZDVZd2hs?=
 =?utf-8?B?OG1xRjhZZkRWdDkrQXJmWkdGZ0t2K3RkNXhoN3RwQmkxYld5dGlEMjNYY0s1?=
 =?utf-8?B?azdLOG5BRm9ZeUFIdFZkOEtvS1ZwNzlmcnQ4aU5md3Rvai92ai9pdWQwcUs2?=
 =?utf-8?B?azhKZDcxK0NOdkNYa0JpczFKelc1NDhjWEp1K0E4ZmNFbjcvOTRLQUk5RHVB?=
 =?utf-8?B?eU5NVWRYeFc1NFdHT2JGYjlaQW00VUZGa3NxVUhNTG50c3FWQk1idk1vckNt?=
 =?utf-8?B?SkNCbVhPT3FCMkc3aW1GbUU0RityamUwWEthOHBjSWtua2ZlR3phUlg0ZmRX?=
 =?utf-8?B?aDVEYjYzMTVoaThCL2dVTk5yL0xVdUZhMzM3TGU5U3paSEdJNkZXQ0RUdHlW?=
 =?utf-8?B?eGIvc210VUhnUW41WExVR0cvWURxaDgvK3NMdTFUQTFaY2ttOHBpSkhocFpO?=
 =?utf-8?B?eDF2TjFhckYxMlE0dDl2WmFzN2NKaXJUZlNBbHlYYnpoNUxjU3JkSzBPVTU3?=
 =?utf-8?B?SDdPamVVM3FhdGRVOWZTeGd4STZJRXFtaEh1eGZDVkI5d0pBSkIzYjRnd1BE?=
 =?utf-8?B?T2psVGI0WXdLU20vVWJIWTJ5emd0K0Vja2krZmRQWUt2WldPaWtJbFMzSG1h?=
 =?utf-8?B?Y1JRMUNzNHB0WnlNOHNUVTIxRkl3dDdKdm5EZzBockFucWVsLzJid3c3dlpD?=
 =?utf-8?B?YklYVnZ0NEJ5MjcveXgvbnBLWUVKWmVaUnZRRVhnN2R0bmw0bm10cDYxRXB1?=
 =?utf-8?B?Um9EN1pLOUdKRXFvUS9US2dVcGM0ZG0xZTFseGFMZEw3cHkvWFAwTHJmdzJU?=
 =?utf-8?B?eVkvR2xldjBYMEJjVlk5aklxUXYyNEM4VThLMjBLdnl5SzZWZUtwYzdTRTFR?=
 =?utf-8?B?c290STdNYTlSMEVwUE9ranhuL3BEV3ZTMERQdWpFS3BqbnpkdnVuZUJtdnhi?=
 =?utf-8?B?enFueHNNYnZ2dkpGT0trNVE2bEw1WXFvTGMwc1E1OGFXRzIvS21qSGhMdkxG?=
 =?utf-8?B?NWxQMjlvNFJ4QXlHaE92SnN2c2RpRmpkUEFzSndIT1MvcUJrMkhYOTNqV3Zj?=
 =?utf-8?B?bUdPQzJSOW83WmNyZFRTbUcyWGNla0Via2VwZ1NVSk45TitvNG5Xd3Vld3lv?=
 =?utf-8?Q?ytezyX1uyxmk3W7knAl4/8W8L?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eUDiVSaQTxTeJPsj/f8Pzzj4mxb9bsjy/0xrDBuCQoz/Thvxk7fDpFlDC1vIxrpT60DwFugaytVN9onCdtuYwkpgF+DvI0E1rcyileZgikKDQ7P31N7Gtw5IYgX3A13rGrOTnk2q+o9TfW2oG57QdRabtNyQdtBvWi/o0jGJYusZQvtF85Vq2EBv+Vs21XlZYeonaSzGupa/xeQy/vcYGcbZOyi8kQpb6pK217FWjCtcatCIN8aHNDyVHaItPWLfr3KrigxqWKqV1DT8OD5V1DDP2GMnJpcrwonQn5U5z5uKX/M99OKsahOdVcDX37+CqsTxebkBuN1bITApen0GQzjCKHm+lEEtwcjIKmahOPo69MAUPRTprQLrb4/nQ1hJxpdxJxkUkwzTTUzNCvx9+xKPitZ2Zwhm2KBGlGqMA1R7LqFs3gI3Ny3HxoDjLJOvT1f98uVZZO4TtYrBc9RTJaf34eWPCP8oHaocEdnHtiS+w4akhmCrXFuVTwamTP5aDkJpuatIiztoj82k3rQzxDb/Lgq9CsBAG2QncXG9y3jCMYvAAu8f6bYHbV3BUqta3oFiJzT416eK7r+o2zGBttGOa6A58SEXeutS3/sJ9gw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96713ad-690f-42be-66f2-08dcf409e4a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 08:57:31.0442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rlj7obfGlDzx0rG6kEqnK1qOW8MNiLctSO5F6Rj7sdDfWj2rieNS5hwEgOVrFmrvRiN1oXa8z7wUIvDEstJ8Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7569
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-24_08,2024-10-24_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410240069
X-Proofpoint-ORIG-GUID: d7uUmtIJyNmzaDYTFCcStUNIvy2aZ_10
X-Proofpoint-GUID: d7uUmtIJyNmzaDYTFCcStUNIvy2aZ_10

On 24/10/2024 03:10, Yu Kuai wrote:
>> On 23/10/2024 12:46, Geoff Back wrote:
>>>>> Yes, raid1/raid10 write are the same. If you want to enable atomic 
>>>>> write
>>>>> for raid1/raid10, you must add a new branch to handle badblocks now,
>>>>> otherwise, as long as one copy contain any badblocks, atomic write 
>>>>> will
>>>>> fail while theoretically I think it can work.
>>>> Can you please expand on what you mean by this last sentence, "I think
>>>> it can work".
> 
> I mean in this case, for the write IO, there is no need to split this IO
> for the underlying disks that doesn't have BB, hence atomic write can
> still work. Currently solution is to split the IO to the range that all
> underlying disks doesn't have BB.

ok, right.

> 
>>>>
>>>> Indeed, IMO, chance of encountering a device with BBs and supporting
>>>> atomic writes is low, so no need to try to make it work (if it were
>>>> possible) - I think that we just report EIO.
> 
> If you want this, then make sure raid will set fail fast together with
> atomic write. This way disk will just faulty with IO error instead of
> marking with BB, hence make sure there are no BBs.

To be clear, you mean to set the r1/r10 bio failfast flag, right? There 
are rdev and also r1/r10 bio failfast flags.

Thanks,
John

