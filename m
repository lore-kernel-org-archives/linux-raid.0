Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BE7202F8E;
	Tue, 29 Oct 2024 08:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191565; cv=fail; b=bqvndpdvzWvuh9yU+KypKbeM9agYSrXzGjJUiaiVxve2hppNyvfAunRs08KhrjrC6Oa6oyGbD3EljCg3ixdQ57Z+XBDmVoBLVjRQi0VeEzi/pUoDF4XzGjDM7SIiKdQumC8uvFz/VmfhcUe6xVCekfO4jqpNXDcI3cZew1AsBDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191565; c=relaxed/simple;
	bh=QVgWBP5Is9hqpU3Mr+TEdeTH9Mv8CsyKEOcOhENi7Po=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tLrxHTFjEvYSe4UljBzndThEn+9Lud495xqlOl/DWBh/ydeg5cghefRpiiJzh6NjS9oB8q8dMM4lDYF4Gzemp4R+Kf250w/rpNCtH+HhPYQOf8bcAey/do2ckCVgEzHrkzp/4Lqz22Yrtr6MgxMaQQumMRZCbEIderCl1/Rp4ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cXsEw5QH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eFOV1oKd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cXsEw5QH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eFOV1oKd"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49T7taHW029751;
	Tue, 29 Oct 2024 08:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Jg6fvlMw0adPxViRnnFp/EmCV0sOQlcbGcJW9mTuXBg=; b=
	cXsEw5QHSCeHfI6YWwZq9T6dhntsJlSfUO/b7cl3Uu498tTqS2uaknsUgn1bMeqq
	hi53Y6zbiRwTxxoAWl34yZdpXZC2Ww94J3o46+4tjQcQ5cLancLd4j2OcG4KVZO8
	smaZDl793B+KOzKzdYp4NzjlAAmYJv/qSjIfhZJDYqJpUI0S2u3Sk5T2jBe11C3u
	2sdp7Bg2QIV6XbNfR581DAOP52VcHu7GuXVooyX2DYMmobh0TmEGyknZUM8KuRd5
	b30iTzeDm1qjpvNa99E68nhAOblP5seKrgWMzUuYCMK4dkQqu7U8EPIrgGTFXeZD
	HZiHrlLFTIIFjFqqQ5ik0w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmcutv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 08:45:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49T6kQ10011891;
	Tue, 29 Oct 2024 08:45:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnac74x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 08:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XjFlHvDSwiUW4p/+7HVSh24jBOeMRtr8ML4uRbNfoVW0IeLxZJYoFLuaU/XEFCbm4KD9IuB4cgIcVQVzOqDNqdWm4ngZJD0QLqEbKH+3iZ1h3sVOGpCGqMRhFA0Pd0aHKvzU2Pca+rlbGVCDCRkfgdJcvr57w3ySuKsK9cdf6OoNBLuEueSxqOrhsEkDkTtVVNBnR0YKvH4kiqmHAHkjFbZuFFjxBh76aMoH8cRKY5TdZVtVRJtoUrrG7R//wmpAdy4kaRsJnihkZU4nT3yQzlMa4RCiw21UvbO4kF1ksFCIwntRXVfFc3Ou9tD5K9hNDsvXDgvZSTFGM5cBJbFZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jg6fvlMw0adPxViRnnFp/EmCV0sOQlcbGcJW9mTuXBg=;
 b=rxXCePiTpNCDveBjAH9SwWwR5aXUNc5Oh2qQxd8NQYlZkt/yVqfYYHxDsv4zgnw/wbYiP20Ei5fkSuuZ8LNqml92jhcTaXg9ruDydbfB4lqiX3IAKZzm5jWxgZIsAnLv1eBf40idmptOXqiIvTQvcWhZqRSkBRC+4Vx1Tbv4XOTvpJrhWYgcJh+dUlI1MZJz2nsaeoHTRsInSVJ3ZbJL7XQnyloIOdsDAkDJjhChn3XZOiVlJoKrnLLPfRZ94wUhu/0nFF5bgw4s6PleYTmj86rOfdHHaPVXnie+0rlrbCwVx8u1/xftgAZ10Rsdk0/R/V9mWGd9VH6cX3NpWah90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jg6fvlMw0adPxViRnnFp/EmCV0sOQlcbGcJW9mTuXBg=;
 b=eFOV1oKdvRcwe9jMvp4bLH6lgfxurmc6bSqCu5F/UjKn401p8wyDGVm26nfH6XFjzTHTV/l2PATfbhHuguBOuJPL5Bibv/d8kA+YlaYKv+ZaQY/WV/XBzwzqV0MuQwYGAgXm9oJ6YgVbZt51AKXfEyvK1k6DI1ch5tnmp2uIlW0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4468.namprd10.prod.outlook.com (2603:10b6:303:6c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 08:45:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 08:45:35 +0000
Message-ID: <879c8b67-2eb4-4e9d-81bd-8f207adef7e1@oracle.com>
Date: Tue, 29 Oct 2024 08:45:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
        hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-7-john.g.garry@oracle.com>
 <c79e7bb4-6f53-344e-9651-fc146b12d240@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c79e7bb4-6f53-344e-9651-fc146b12d240@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0308.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 84962d39-8560-4a63-edf3-08dcf7f60e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkhWczNzOEZibzIreWdkWjUzTTRob1dBd2l5WWNwazlrR1lWeHJqNkUzbEpU?=
 =?utf-8?B?YTRFQ3Q2UzJFaUxueGl1ejNEMVY2WUJRWDd3Q0w4VkhDTklaS2hmVkllQVNq?=
 =?utf-8?B?aDNDQlp6MmFEanErQSsvREZsNHl1eGFFNTlheVN0eWxBNDVDcDArL2I0SmlE?=
 =?utf-8?B?bjUwK3M2d1pwSXBMMDJWbHg0VVhQUE1rdG9VZTBBSmI4QnBxYTdpazRIOFdz?=
 =?utf-8?B?ODdiL0U5MS9aRmg3V0ZoMG9PR1lETHZDL25uaGgwbGhobEV4VnZ4dXc2Q3JS?=
 =?utf-8?B?elFIZ3hzRmluVEtmR0l3SEUzeHFyWjNlaE1vRG83VTl5SUFjM2ZxazQ0Yy9q?=
 =?utf-8?B?V2xsanU2azcyYVhya1NON0QvdkROaWl3RjFXZ3ZRbnQvTFlKQVhEVzZUdzdk?=
 =?utf-8?B?dDhxdUsrYWE1c21MVWpGcXNtTXJ3aUtuZjYrSzVtTzBTaFRaSGRuZTF6TmFZ?=
 =?utf-8?B?YS9MWnAvdy9qN1pVQmVOODIwN1QxTzBNYnZVU216UTZhT28yMWFqbWg3NklK?=
 =?utf-8?B?THcycmhNYVpIUkxJeTQvaGppeUJLaDRvUXpRZnEvMktFWnFocXdmQ2pmYXVV?=
 =?utf-8?B?UU0yNHJJTmRWeHZ2K2Jra3RuV3V2QzEvdEkzOWNPR0wzQnc1c0Q0RnltK3FQ?=
 =?utf-8?B?YzNHbVVpd3gzNnIyVVlJY3FkbkFIYnNLaTJyUlhMalVPNTFuY3loNnFJdzdv?=
 =?utf-8?B?US82bmVBR3dMbVZETkZmNytMN0xwTVB3bWJPSUlIQ1p0bXhDOWE4Yi8vQWNt?=
 =?utf-8?B?SkU5ODRQb0N1R1Yva0hEVWlRTTg4ZTZaaWJqakpKN3VSZXRGU0syd1NsM2M5?=
 =?utf-8?B?MG10M056dHdXaUxWM3BBeFYyWkdYcUNBMC9PQkgwZ1BHOW1pajVTSmxjZjl2?=
 =?utf-8?B?VFJYSDdUOVA0NGJxSE9TRnJEZzhkdm9qUzJMNkY2RUVmSlYzUXNQZHZSRjR6?=
 =?utf-8?B?bEtacDE5TktjeW1EdXd3Y1NPWHE3cnZIL3BOK1pGQks4U2FydTlGSCtjbDYz?=
 =?utf-8?B?QnpqNkxNY3NuUEpoSW5nUk9CZ29ZSFcvSndJbEJmbXM2WUIrdU9XdEtkQ0kv?=
 =?utf-8?B?RU95R3JqK20wRFNQbFp6L25SRHlvS014WlZiRkZGMDV3dzQzMDVzTnR4V2FW?=
 =?utf-8?B?MURGaWRFVVZrajZKSWQvU3NyQWE4VCtCS0xXSG1DeTljR1BZRGRSZGVSV3pI?=
 =?utf-8?B?OXdVT1ljZ0ZociswSERQeUxuald2bDY0azYyRTVqTXZDbTd6bUZjS1dCMWFB?=
 =?utf-8?B?OG5rbHpNNWR1eElRY21ibFJxSVR4ay83S1VUTjYybHhCVkExNUF0MFNaMWJi?=
 =?utf-8?B?TGkrTVFrTmhLQzJWYXlQTGVmRWtkS0V0V29QMVlCcEdqWTNNS3FlYWpQZC83?=
 =?utf-8?B?eFhHbjRkR2FsNkJGemxNai9ZSmw2aGRJVWtSc01CYlVKZk9ZUG8ydGtPNXcw?=
 =?utf-8?B?dGRteDNvYys5OVJoeUUvNjZzSnBsZHZGYklBemZ6eGhNaVZSRkE1bGxnRElv?=
 =?utf-8?B?b1A0M0ovL2twWnRteEFma0xNMDdmOFY4THFoSlBJU1pDUCt2aTdTWWpLRHhh?=
 =?utf-8?B?QkFoQkxweVRiWDFNU1RkQ09XSEJ0eEpzNDlqTHl1UVcrVGNKaFd2ekExYzBo?=
 =?utf-8?B?Q3lDV2IxYmwrM0t5NHBEQ25MbGxPbGdmNkpmeDRIVGVHd0dNYXFjd1lsV0lK?=
 =?utf-8?B?NUtJdkJGUEtIblYrNGh0YzZ0SHNlZ1V3UDh4VWRHL0had215WVRYajFpcW5Y?=
 =?utf-8?Q?OazXw4XSoKkprh1gQoul8miKu7de8I1SZsVwhxv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlRZN0ZoZUxZWXBjNU8rdjNZWmNxTnA5OFQrbU9XNTJYb3kxdm5jM2JCZGlu?=
 =?utf-8?B?WE51V3JGNjR5V1NWS1hYZFpBdyt5dEdHVjNTSDJsVEFYTmxwVEpzTVNRa3FZ?=
 =?utf-8?B?N3BEcHpSV3ZtR0toMFdCYzUzbzJtamQzVFJpbE1vY1NCTEdoeG5lNFhGWmY2?=
 =?utf-8?B?UURYQzc3T3lYaEJHVzliQWdWcWZXSlRRdkhGZ2diNTZxc09DMXl1c0pkZkE2?=
 =?utf-8?B?RUxSWGRsSjJzWGdCc09wMHFRWi9tc1dHUjZKZVlYT1Y0RTM4UHJ6Y2VYaGZF?=
 =?utf-8?B?bVRtWHo3RHMrRDNIcTdueU44YVd0YnYxSW8wNkZweGh3K1kxSFdJckhkeGdG?=
 =?utf-8?B?ODFQR2U5NWl4ZDBuV2R4aFluODdYVnZ4M1ZmOHB0T0xNUG5OZDhvbXBvdDFq?=
 =?utf-8?B?UEVvM1NmaDMzS3k2eTJXekE4dm5JQkxISkhyKzViSmZqMk1yQ01rdDhxUlRu?=
 =?utf-8?B?T243eTZXWDJmVkl5dEhoOHJZR2JqMGNId0VLQWVJVUFQbC96MDZ0aDJNbVZi?=
 =?utf-8?B?MDlZNlhnSW1UVTA1QnRMa3BHL2pnclEycWYrbVRhRlVOZEhLakZ3MjRkc3JM?=
 =?utf-8?B?MmRuWWhjUUNCdlRidUNPTVg5NWorbmdwTzhwQVFheFdxOFFsdVBLWnlmNmNS?=
 =?utf-8?B?cG4xTHBQK2tGUGY5TWxLbUZPOXg5VUdNVkVIa1R0T3dsam82ZTNBMUlmcC9E?=
 =?utf-8?B?SG1KZlFTVzU3YUJ3OEUxQVl4aWIwZWJwYXhhMTJWVmtqdlg4NzZ6TFVzSUNJ?=
 =?utf-8?B?NHJrbmJZdmhBVWJFdjFkMFFXUkd2ODIwWlZrNG0vY1FBWjFjNEg4aFBvTUEr?=
 =?utf-8?B?WHp0TDUwRTdVSVNhR20yWC90cS94dmxQT2s3YlNTUnhaaXdYWXU0c01BNFBi?=
 =?utf-8?B?U3VpQ2dXcDVaVXFuOHU0SW43T3pydExLTzBucm9OZThZTnhpNGNabUU3TENq?=
 =?utf-8?B?TjBtREVKWmtsRG9FNEZHTDNLT0YrNUhpUkt1SlpOdzlDajZOYUp5UW8xS3ow?=
 =?utf-8?B?cDd2emtwdythVFloRlJWZWxGblFaU1ZLMHJ2M1FhUStIZFNqNXhaaXJ5OHRU?=
 =?utf-8?B?TVBucnZpTkJJV1FkR3BwczRvTFZ2TmNleHhBVU9vRGlEZXZuTWVuUlRzQkNK?=
 =?utf-8?B?N1B2bVl4eVY3NW83SzdzUmVvWDhjTHV2K2kwVzRVdXNpM3NJZndCLzVLamhp?=
 =?utf-8?B?S1RyRkJzZDU2b2MvMEt4Mk5vRXlnb0N4bWhMbUhwVW5EMnlRQzl0L3Y2Qnha?=
 =?utf-8?B?VkxzWmo4bjBFR0dXd09UekkzZlFES0FSbXZzTHJWaVd1UUc0OGhUMTNtaDdo?=
 =?utf-8?B?b3RvMkpWN2g3bEtSVnVLYWZVeVZuWDc4ZmxNZE1GZXY4S29XTktvazVyZ09D?=
 =?utf-8?B?M0RVS3crWERJeTBNb1o2K1ZTNG1RUEVvSHk2K284dmhiL1lMQWtBc0NlOVhx?=
 =?utf-8?B?a09rVjZHa2dpc21TSXlqNFlIRTlyK3JvVG5QSUdmajMxcFVpWlFjQWZMZjh4?=
 =?utf-8?B?YUkzQ2VvM2NGY1dhcCtnSDY5aWJCRUxhbVZVWm5wdXJ3NmRvcThpbDlySy9p?=
 =?utf-8?B?bkFubjRkTkFFUm1mNWt6d3RkQ3RnOFkwS3MwUjR3TThDRmM3VzZsZzJtaXhL?=
 =?utf-8?B?TDgyOXRvTVI2NXhiSE1KeTZYeUIvQWlaRmQ3MHo0b2d4UUpqd3pIdG5MUnYx?=
 =?utf-8?B?bm0ralJTdVdHUjR5aVAwV2JjUlN5dEdyV2w3aXBhaWdCNHhTOHFxRVBpK09D?=
 =?utf-8?B?NURDR2xma1lLOExuVUNnSGRQZnEvS2t5cU5jK0pYZ2ZIY3ZjOFd3Y2VweXZ6?=
 =?utf-8?B?ZExqN21QemxvOVVoK20rRWdpQldFYWpvS3l5MXpxSFEzOVgzVW1aWFFHWFNt?=
 =?utf-8?B?RmRSWkdpK1ZDK0VNK3I2TXZoRTZOT2tsejNheit1ODdsT1VoVEhVYk9EV3dm?=
 =?utf-8?B?RTVWSHg0UFZVbDJMY2F2YVRRZmhxdThFLzRmNE9SOEtlSDUyQnp2bzJMamRs?=
 =?utf-8?B?dVY2Nm9hOVBZemphM3pKNHcrZ1krMlFKU09nQTFKREFZQzBuUm9VdXA4Q2tJ?=
 =?utf-8?B?dXFaZWdOYWFNWmpSd0lZV2s0ZXNxVzRnWHhnQ212eFNBMnJGWEZWa095Z1lx?=
 =?utf-8?B?VFdzMUl6TFdCc2wvLzROWGJVbEFZZGsyRDR0alMrQXZnZ2tRcVNwZlF2VGVG?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uFWUMFx0tWR6mkHEAlOjU0es9vD+1Lf2JRaGMTolDOtBKoZc+jN8Jb3tVqFSjxeJSRYjp9B0dUXJIAWiWr0Q3VI6punq0ODqK1AY9V5Iczo8qmAYkgFOxqXH4PBaFu171ooYEG2bXJ5bAaJ0OurRTk+827+3d4a7g6cYfuKqkOuTH1/i8x3c8OrdzLOmPw/P1Ze7678xA8RoxKO/9l1SrJWcTXPkRC9GkwqwrqvZM/aIJRrnQBNKLPgX4/xZLa5fcsYjfQ2kxBY7BhuSggegTVd4Kutl75t9XfwuTyfAm5x6xyyUzk7GJfXNsvFCi5Taj+fBxfSLUKB5Gb+WnPiMk20xeewwVpewgX/td8AdOfuMEn2CLbcMANvIf0070lUdPxUNrDrGn3gDIaIwCI1gzgfrQVrtv46hOsS0JVswyQlOB/NhLvDj+sYUjkMFdfftP4i7wRCPxw+mjabUy6fL9LbZalb495G6vgw46aapw7stPg55CRyh1P+heeFsfx1shu9jzdvYeDsurvVxhc9BXPH0vxMU7VErOrnDNSmF7OwxFcroiSzBBxizsGLguhVKZVQxq5HxrfjS7LXlX74VniJe2otJN3oWOnoQYVr97Qc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84962d39-8560-4a63-edf3-08dcf7f60e0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 08:45:35.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gx+wl2LXzWJNXsL9hZJv72F9zoNgkMM8jaYLQ/lLjnnVYWLd3jHGqzDIgeD3iRcRRREEENGMyuc7GXWdqM6QvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290068
X-Proofpoint-GUID: O-0YEZ2aQaJOgZoNAS3zN4UQ1dQtKqXl
X-Proofpoint-ORIG-GUID: O-0YEZ2aQaJOgZoNAS3zN4UQ1dQtKqXl

On 29/10/2024 03:48, Yu Kuai wrote:
> Hi,
> 
> 在 2024/10/28 23:27, John Garry 写道:
>> Add proper bio_split() error handling. For any error, call
>> raid_end_bio_io() and return.
>>
>> For the case of an in the write path, we need to undo the increment in
>> the rdev panding count and NULLify the r1_bio->bios[] pointers.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/md/raid1.c | 32 ++++++++++++++++++++++++++++++--
>>   1 file changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 6c9d24203f39..a10018282629 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       const enum req_op op = bio_op(bio);
>>       const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>       int max_sectors;
>> -    int rdisk;
>> +    int rdisk, error;
>>       bool r1bio_existed = !!r1_bio;
>>       /*
>> @@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (max_sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, max_sectors,
>>                             gfp, &conf->bio_split);
>> +
>> +        if (IS_ERR(split)) {
>> +            error = PTR_ERR(split);
>> +            goto err_handle;
>> +        }
>>           bio_chain(split, bio);
>>           submit_bio_noacct(bio);
>>           bio = split;
>> @@ -1410,6 +1415,12 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       read_bio->bi_private = r1_bio;
>>       mddev_trace_remap(mddev, read_bio, r1_bio->sector);
>>       submit_bio_noacct(read_bio);
>> +    return;
>> +
>> +err_handle:
>> +    bio->bi_status = errno_to_blk_status(error);
>> +    set_bit(R1BIO_Uptodate, &r1_bio->state);
>> +    raid_end_bio_io(r1_bio);
>>   }
>>   static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>> @@ -1417,7 +1428,7 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>   {
>>       struct r1conf *conf = mddev->private;
>>       struct r1bio *r1_bio;
>> -    int i, disks;
>> +    int i, disks, k, error;
>>       unsigned long flags;
>>       struct md_rdev *blocked_rdev;
>>       int first_clone;
>> @@ -1576,6 +1587,11 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>       if (max_sectors < bio_sectors(bio)) {
>>           struct bio *split = bio_split(bio, max_sectors,
>>                             GFP_NOIO, &conf->bio_split);
>> +
>> +        if (IS_ERR(split)) {
>> +            error = PTR_ERR(split);
>> +            goto err_handle;
>> +        }
>>           bio_chain(split, bio);
>>           submit_bio_noacct(bio);
>>           bio = split;
>> @@ -1660,6 +1676,18 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>       /* In case raid1d snuck in to freeze_array */
>>       wake_up_barrier(conf);
>> +    return;
>> +err_handle:
>> +    for (k = 0; k < i; k++) {
>> +        if (r1_bio->bios[k]) {
>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
>> +            r1_bio->bios[k] = NULL;
>> +        }
>> +    }
>> +
>> +    bio->bi_status = errno_to_blk_status(error);
>> +    set_bit(R1BIO_Uptodate, &r1_bio->state);
>> +    raid_end_bio_io(r1_bio);

Hi Kuai,

> 
> Looks good that error code is passed to orig bio. However,
> I really think badblocks should be handled somehow, it just doesn't make
> sense to return IO error to filesystems or user if one underlying disk
> contain BB, while others are good.

Please be aware that this change is not for handling splits in atomic 
writes. It is for situation when split fails for whatever reason - 
likely a software bug.

For when atomic writes are supported for raid1, my plan is that an 
atomic write over a region which covers a BB will error, i.e. goto 
err_handle, like:

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1514,6 +1514,12 @@ static void raid1_write_request(struct mddev 
*mddev, struct bio *bio,
  				break;
  			}

+			if (is_bad && bio->bi_opf & REQ_ATOMIC) {
+				/* We just cannot atomically write this ... */
+				err = -EIO;
+				goto err_handle;
+			}
+
  			if (is_bad && first_bad <= r1_bio->sector) {


I just think that if we try to write a region atomically which contains 
BBs then we should error. Indeed, as I mentioned previously, I really 
don't expect BBs on devices which support atomic writes. But we should 
still handle it.

OTOH, if we did want to handle atomic writes to regions with BBs, we 
could make a bigger effort and write the disks which don't have BBs 
atomically (so that we don't split for those good disks). But this is 
too complicated and does not achieve much.

> 
> Or is it guaranteed that IO error by atomic write won't hurt anyone,
> user will handle this error and retry with non atomic write?

Yes, I think that the user could retry non-atomically for the same 
write. Maybe returning a special error code could be useful for this.

Thanks,
John
