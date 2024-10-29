Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1E8BEA;
	Tue, 29 Oct 2024 12:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730204503; cv=fail; b=hqto3WEq15CaOByTXihqlE/SxcU4S/7jUxgiEtPmnD7QPB+ITIn65FMvZnDy0tFP7NS8YU+CH1acn6I66VUvZRhBXguDgHit6xbToppLADwKURUaC7WIwM9F99XyKU8FTJRL1TRPMi4EWX99gqL0Nxkv6WGLSe8I6fErj1pcHzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730204503; c=relaxed/simple;
	bh=HH6hc3V5bR6alGOo/tna+U1MIN1UNnCfxEsq4ehFPXE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ol0WGVk4O4vkSbw+fw3YaeTk1cpylS7UWe+XVmWIIC3Lz3RZFwF4g0s51JSMfomwn2BSOFRlL6LFDxQXx6DbvQfJRDy7yV1jCWiKwDyIGn3OUzk7ZpjDfbeksQuMiteU044jPKghRXGFJ0UJSxY1Aw0tKOr8S/yI04J21DyI5Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZhtAIwnJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E68IDV7n; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZhtAIwnJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E68IDV7n"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49T7tcXD009055;
	Tue, 29 Oct 2024 12:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AtMCabHm5WjyvdN2aq8ZB2ShWxyzoSPjT5oEgl64MdE=; b=
	ZhtAIwnJbWVKeiatyGK5SPNGcTgVnao/U6VS+PRgXrS5Xd5vbGLFfZDgyYJtUvLE
	z0Nx6qTaxrd9+u83sqQvwrc4r5RKkSW2hNPKiVZ9ZyT8wltB7kR/3WzGP/rQTL0V
	lFEJP7zNvylHJR7KKPKUrnaxuUzF8dHzHVLf/X4H8LLM9eq6mKQa2HbrP41nVcXK
	exjSBGJ8ah/WC4CmcU8f2Tg+cM7/JSO/BI2hXKGBDFdNL/R01WjOEigdunCYZxmR
	YQEmtr7xKT6Q/gV+tVOes/GzTH4+i3Q8gLdsRkbXAICF+Yo6bApF6U/7Fz+x6nus
	waqnecdjOcUHj5NsXRC2AA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdp58fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 12:21:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49TBA2HO008411;
	Tue, 29 Oct 2024 12:21:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hne9jbxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 12:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvOrpMiKHiducBMmKJCSNe/a4wDVmm+pRVrvtcd3ro4338NIOrclzocMz1hlJ/dJiBy7VK6wTIvj/Bpv1B7Jo/1FcNpeys3H/KR7MqcXpCAZuiWnmcfVr/HO6Ery5x8RGcwVC0DA10LVo6lEXjAOEwPinJ+1eklcbxAJyYuMuQTCuNpug3SiuMAEy0GlauqfOeg2tMDnDjLYXKoR5F6dUuwf2CycfAA+t/knUbfDG1kHUew5T6iR+huuG2mQipozdrUtQFHoBYnStxoObZIOPZKhGwva/i+WRtF+XhD4Y7QHg4a/Jq+V5Ihhp9V93IO6dzKz82gz/aq/zPfC1O6P4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtMCabHm5WjyvdN2aq8ZB2ShWxyzoSPjT5oEgl64MdE=;
 b=jThksYuyX8F66Gy0hqkefz0ctdWF8COVjnXu1DSsCgPaGljBo3g7iZCHLpgfVEH4j/bxej8OVzttx7tQ2LTtahU0rOMon0ghid4s6GSTNvqIw59lozkQ0dKLLkCcnwt99bUgldnqIgKDRxm1+zOK0KnU0khjx3FH5ca64EcLnvhLtt6pDXyxCN9p3B9Mx09x72Rj1DYZJQJTbJFG/nKAYYAdbLxYnxD7RwbMa4y5FJ7lCnCvP9/b6AFRtNHxZ4uiLyCZ/GpSCYTa58/zHyKmSOkDq0pd9sXkav27YuyXz73PpZMtXB0aio/qH7liCtFvaX9gf0strysNiwHXO5eBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtMCabHm5WjyvdN2aq8ZB2ShWxyzoSPjT5oEgl64MdE=;
 b=E68IDV7ngG0WSvWBovXX3+zElZcfQEtkv3Gq0b0k90VVThNgfFfAWzLeVcuQGyCD041HSbnbYzTrfSlcTH+Y57N6UEteFMFwgUrdk9dRyPfpYXrLwGgcVfWVkKgK3pZ1rfLk3avVEsrIhCCsyr20U4N/HErDM3S4FEBFadWf/jk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Tue, 29 Oct
 2024 12:21:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 12:21:16 +0000
Message-ID: <3ecda8a7-c28c-4fb0-95f7-f8a56d60b7a1@oracle.com>
Date: Tue, 29 Oct 2024 12:21:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
        hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-7-john.g.garry@oracle.com>
 <c670a854-bee6-790b-7d1e-5ceaca8791a5@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c670a854-bee6-790b-7d1e-5ceaca8791a5@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0038.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: 50971a7b-8391-48d4-23fd-08dcf8142f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2JlZDluc2RzT0ZnbWxpajJ5ejRYK3N4TjZVNmk3TmIyYmxTNzlRMlpSM29Y?=
 =?utf-8?B?S3J1OUh4alVDOGxJUkFlbm00a0JKYy9YbWhGdVRvMHJQMm41WjJULzhVNXRh?=
 =?utf-8?B?U1hyZ0VBajd3UFZYaXNyWjg1ZGZZb0ZIUjJoYjh4bU5ZU01pOVplZWpkN0Fl?=
 =?utf-8?B?YUtrRSt3OVVJRFNITytRU0VlVWhicmFIRzJ0MVpWek5haC9lTXlBUENNQUI4?=
 =?utf-8?B?RXE0bE01cmh6Ym1SVHlWKzRXcXZSdnhxUnluTndqVnNhcjJ6V0U4QVpDZU1Y?=
 =?utf-8?B?TS85Skw5RTZZdmYvZTZYa05RUXJ3K0NTalRmTnVoVCt5VzZOY3pFVnlUM2RJ?=
 =?utf-8?B?SytDSzNJRkNnLzhFeDBXY3JjZlZlOExtNi8yNlpENzFidHNOdG0rTERJYWZ3?=
 =?utf-8?B?ZHlubm1HZS90Z0FYSDJ2WEJMMU5WK1F1QTVKbGpIR3J0dEZ0emNpT3pzREhN?=
 =?utf-8?B?NXdpT0RZNUs4OEFaSUhFdEpyd2g5VS95azRnSjQzVzVlV0h3SmZJNUJNNHFr?=
 =?utf-8?B?K3lMOVpjK2oydUZUZGVZVktNRnVFS2dwMFlsT3RUakx4K2t3d1VlUk9sT3h4?=
 =?utf-8?B?eFBZUFZMcVJlRHJDZHVvZ1NxT2NzbHl2c0tnbnhFaFpYT3AvRmVXUGJNTllE?=
 =?utf-8?B?cEkyaFhSbmdETVFZMm8rSGRNNmFNaVNnWDQ2cEswUElPUmwzQ1ZCMFBJWTBz?=
 =?utf-8?B?YU8vRUlhSG9ZaGVmU2RXUk1FcmdNYWpyZmNnSmZYRVFBSDhURWdGRG1pd0o5?=
 =?utf-8?B?RXB4RnBKV25uOEZkYk91dnpOQXZqNnduUHZHcmlJb2RxYzFjazNmbHJocVVq?=
 =?utf-8?B?TURDR0FZZ1dHaURLQUM3czdLa3Z3WW1lbmNLRDBOWDBqRllSUnhPNXNEZzZz?=
 =?utf-8?B?NmJDaWlPWnZieE9VWVVYYXNqZEd6Wmw5YUhDWmR1Sy9nSXprMU55aGtRNW5s?=
 =?utf-8?B?UE41Zk1vVGpNZ2c5cWhOam90RFhXQUV2VVJ1Tm5kbDRkZmdSMW9zSTRkbkcy?=
 =?utf-8?B?M0ZFbjJoNkxEbWFpU3hoOTR1d2ozRDZTYVhkU1dtZ09lY0YrL0dmVmpjOGpZ?=
 =?utf-8?B?SThBZ3o4cGFsU0tWdDBtWDlyamJtdnBXdmZmSnF1TGhIQzhWSmlLZkRESlJn?=
 =?utf-8?B?NVN6djVTT012TVRQVCtKclJWY0o4TmY3bEJGSWVjRG1lN3pHRWtJeGRNOXJo?=
 =?utf-8?B?UXRVRjB6cUFseVRveHlrT1hYRWFBWFRjNWRaZXJxTjhWU1JmTWZiaTIrdU80?=
 =?utf-8?B?UGdNYUVlMXQ3cVVRN3NvbWJtZFlkcHhPUlI0K3EvbXVxZzRpbDhDa2ZUVHVS?=
 =?utf-8?B?bkIyVkxadjVXc3FHNElCUHhRUnFybG5CYVBqUng2SlcxRjF5aHorOTl2UlVo?=
 =?utf-8?B?K3Z0cGdveU9ZTlBXdVR3c2hWT3ZCalVMaGNJUkI5RVVsQ1J0V3pVMFc4aHZ1?=
 =?utf-8?B?bHQ0MlhHYlVQMU12dXE1WUpGYXAzNG9rV09aR3dxZGJtSGtLL29sd1pmZHBG?=
 =?utf-8?B?UnlnTW1xb2pSZ2dEMFBvTnRrOUFFZ0tLT2hza01ldUVxa3FDSHNrem5SQ1du?=
 =?utf-8?B?eTJ5KzRPL212WVcvZWRIUUNPbHBWNjJvcERmTXJyWGRxaVJVY0t1dXhPRlRJ?=
 =?utf-8?B?aTYvTnRzdEM5U0lkV2UvSXVEaXRubGFyRUxIYXY3MmJNK3MxSVRyK3BXWTRr?=
 =?utf-8?B?MlBwSWlTN0xqUHEvblk2bEJSU2hDZWR6aFBYY1B2dXdleTI3bENZMVdZc1Iw?=
 =?utf-8?Q?A13yKOR2Vtn4pSdDi1UMXDIN+AQSrjfsPo5PMGo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WC83U2NONzhuYjlnWDlUeXNrN3ZSOWhXcGNrN3dvZElZOXBVZ091a3JDZU16?=
 =?utf-8?B?UWJPNUg0Q3NqSkV1cVFuNGY0QjJadFI0b3dXaDg3VmYyV3llZzR6bkhTUHlw?=
 =?utf-8?B?UmNpbnNvaDhlSFFRRmsxa3RIS2drcWRiTG8xbkd3TWozc1dNcG8raWd2Nmdw?=
 =?utf-8?B?aHVxSndiSlFselEyNlAwVEhJbkc0Z0R5eVVKOXFWM3JWM0tIOFJwV014bGlr?=
 =?utf-8?B?L2UveU56dTAyc256K3gydVlGeHllcEo5bzN1MFJHYlFoYjcvR3R0dElqb1pt?=
 =?utf-8?B?RTNEWHJPaTA1VmkxVEptT0trMkR1bHF5VE1CVUdid0oyUDh0VFJDQU1ST0tl?=
 =?utf-8?B?TUIrZG1jNHNGVDZ6Q1R1L0UvdEVhWUdBMmpMYXpOUHUvVFp3YUc1UWNJY1l0?=
 =?utf-8?B?T2VKZjlkWWdLU29aTnpRTnpxaVQ1amljZVVGaSszY1hPckZGLzRZZVU0TzhX?=
 =?utf-8?B?eENYUytHbzEwVGhvdkZRU2NqTU5GMUR4ek0rV0pUaS9nOWhOcGliUllOeFlB?=
 =?utf-8?B?TVNpNlhSbWpvdFhyRSs3Nm5Sa2JucnlsK0ZpQ0lKZzNJSFdaaE8zR0lteVo2?=
 =?utf-8?B?Q0I2SnJpNE5FM05SUXB0SEsxZWRITVE5c25WM1JTY3ZPMXNXNDNla0tCbUw0?=
 =?utf-8?B?K2VlMmFjdHVrT1pFOUJoNW9nbzVzWFlzRmQ2ZkxzNmhZTVhDZm9FSFgvSDRJ?=
 =?utf-8?B?ZmlSUmFkRDJwQWkvQ3RLOENaV0ZYT0IrZmtBcHg1SjZEdUQ3Rlcxckd1aHB2?=
 =?utf-8?B?SHJFSFZRSHhkU3ZWMVY1TThOdld2aVU3MXVmTDluY05XNFhBcVUwR05VVkFC?=
 =?utf-8?B?dU1ncFB0dDZ2VXZ0V3E5NlROS3RUZTlXS1g3a1p2aWxVbGhVME83S1VlSmow?=
 =?utf-8?B?eXlmWVNNMlAxOEcyRnQzemFGK1lJeXRiL3FZUjhSTkhEY211NVhiOU54UnJW?=
 =?utf-8?B?dFduWmRaeEhWRjk2ekxKL0llUGI4SUl1TWFudjBqRFVKMHM1dS9VeVZKZk5x?=
 =?utf-8?B?c25SdlJhQTFFNXJXWkphSWFlWkxDK0VONC80a3dZTmFLbFZPQVRkVVhTNmU1?=
 =?utf-8?B?VFQ2QjBXbUxQS3pEZFFqMHNVVWhhNmRWaTJjc29pNUdLbWMxRUhtWHAzUXVk?=
 =?utf-8?B?emxXaDYrQTcwZnkzVEptbzdtVG9nY1kwKzdKeHdmYjA0dkpTaVpjSVJHZ3Vo?=
 =?utf-8?B?eGJFdk1mRjNGVXJsVEFaMlFyWHJYYTRGN3pTQUxZMUo0U1k3WmlpSG5JbjBl?=
 =?utf-8?B?c1NwdkZnMHh1VjBwdWVpVVJFbmN4NFoyblFjZ1hENlBXVjAzaThZbXJHUFFJ?=
 =?utf-8?B?bkRjeWhQMHFlODJNN2VveEFlNU5ndW1vdmpWSTJDT0Q1Z1lpQ0xJOU8wWjNr?=
 =?utf-8?B?L3lkRjUvdmlIM2MxYlZVYkxrb3pNZDhiRXVISUc1N2JkWk91VC9MSEtuSisx?=
 =?utf-8?B?SzZIdk1Eb3pzVjBuMVAxcDg4Qnk2WUNxc2NFaU1xcGNTN3RtekJPdjUrWEVi?=
 =?utf-8?B?V1QxeFBPaUlPMzVVaDcrRzZ4RVdyMGJnWHp1aGFsRlJaS2Jjd2liK2RKQUJl?=
 =?utf-8?B?S1J2NDBCTFpKY2N2S0VSQkpEQUxOdWFsbUpQa1Vwc083L05NM1IxZlBUZ0tI?=
 =?utf-8?B?SU1kYlkrQWVsdDRDcjRpM0xReVp2U1BIR0xWdXJHSjlXaHRIcGJLZGNZc01I?=
 =?utf-8?B?TUdETlBvckwxRTREZnlXcHdGblpZUElJNEV5NURVbmo5WW9iZEJVWTVkM1ZN?=
 =?utf-8?B?V01xcE5SbzFXL004N3BjaTRTaVNKWTF0VWFETEZpS1d3UDdraVZPYWF5Mkln?=
 =?utf-8?B?c1JMZFpOZ1h1OHVQN05paElQWWVZWlRpay9ERTZ5N3paZ2c3ZnZBaGFQVUVZ?=
 =?utf-8?B?dWI0dXRNcVBmbnNFZUhrTndQUElwYlkxckVYVHRnYTFlOVBmVE9jZjgzcDl1?=
 =?utf-8?B?S3NvdHJrSDZ0U3JLcUhiQVZPWHMwK2RkQjJBRFowRnJGMXh5aHZjUG1SUCtE?=
 =?utf-8?B?WFFrU2h0RCtJQ29wQ2dicTkzRjdhQVhWYk5WVXArczhMenpPbDE5ZkptenQz?=
 =?utf-8?B?WTU0RG9zQ013VTBZREFIdHE4M3dWeFBSeVJ4SEtXU1lCMXVpZXhLNG1OZ0lh?=
 =?utf-8?B?TzhtWEtCNTFvOVpteWo4SFdCK1FIbVVMYlBZbDNBUU1mSkRGWXZySmVGZmxB?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2E+lbchmS21lABPrIkS8VduY08Sj0uHkH87IPLu8ZcgpFDP85wt/FGUAq+prCWsI0822owl+YVf/g0jYy/IVqM6+ahxfyPb+wveur3/sLMLsqrl0ERjMYTk1dVIBbwMGEFE0AlWH+RnRyBTxp9cWyfXcZLWeOFVwifptDXszt9jm879/cEEvO3DI54Gseel/K9rGGnL78OS/aKt773jwqO3tk83XK9AniduMAXj0mTjyQng+QNDRW/VDEn4J5n2WYz2dfP3DdVwXLFdbw5INx+PUzL2r0AAsQYf5HMYNzqU0YYjTpIEm/OZfQaqqizuncK1fF9JeEUOFIBpeQBBjmn4VsxCrd2G8+D+XcasYHP4y3602vr6Q0GHNtTomeN0YqiVUCgxHLNKVJbZtCtwAsSuxSSmUYfCgHMjBPWD42BM66oyVHzv1bEnxM5q6Gf/DfuWpufIPrnjnlegLTWNA5QX9LH0gBTCUtKW+Gz+tF/piFqgOj4xI21QP5onkFa/9MaIvmqti9xBmvLQEJHaF6QRIAXKEn26gr+E6OiDPLAifPWaM2Idscj99UMTRsNvqdivorl8Yra0evP/g8aWnQpFWXbrkUWtw2hm4BJc+pBI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50971a7b-8391-48d4-23fd-08dcf8142f60
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 12:21:16.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBi5k2aLKChS/U0iepkjMEmnwj/fIgfQAPWrrDCkSKTwAzHc14oO+cJDW100hik3w1Et3Jm4Qkftdmv+nyd2Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_08,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=959 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290094
X-Proofpoint-ORIG-GUID: 15md-zHZEVBYxBu_kuU4BEDPE4UfE3E_
X-Proofpoint-GUID: 15md-zHZEVBYxBu_kuU4BEDPE4UfE3E_

On 29/10/2024 12:12, Yu Kuai wrote:
>> +err_handle:
>> +    bio->bi_status = errno_to_blk_status(error);
>> +    set_bit(R1BIO_Uptodate, &r1_bio->state);
>> +    raid_end_bio_io(r1_bio);
> 
> rdev_dec_pending() is missed here. 🙂

ok, I will fix. I am not sure sure how I missed this...

And I will drop your RB tag.

Cheers!
