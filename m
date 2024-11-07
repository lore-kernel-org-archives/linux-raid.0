Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E018FDC5;
	Thu,  7 Nov 2024 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730962218; cv=fail; b=GpEmyUDWI9E3fFbg97w4Pl5aBmztp5UE5ZejZ1qQahkrM3n+FqSr+NRmUz55bCyf8UzJX2kl3xyz3FXjKuxdt5EMLE7DGCZ7H6HPP9gix35Qz1LEwo16pji8f3eDBK4UOKO8Elisya76qOTwv3KmTybh/P2xB7t/o1ELCAIpD30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730962218; c=relaxed/simple;
	bh=0WjUbbNClzycRNIdqe8zjLzKHrT+gEcGxShbB1s41EU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E/nq4SOGSI2rZNoAGl4DJz+A07ve87WwQidCWXKccQbOYcDP/7kb4CMmTq2CxD9a08izVKW4/6ojPDfraoOu1QaleerY+tOS8AvCsBsufSOSF5zn3totmfVcNEQ06ipFRJJsRRzthI1yWjWRfsAVv6wC3CZtHeiPUlPfzk/WpMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X9wlgxI3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jz9RqTRc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X9wlgxI3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jz9RqTRc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fcTa018863;
	Thu, 7 Nov 2024 06:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=; b=
	X9wlgxI38bk+iYDK560n+K2euqHSFra7ITEnqQLVo5GirunhBBh/ZjmzZOIgbYEF
	KCSqTIJSpbXg0AzGWAlt26A2I10FW3Kog+1q/9Uzyx3aK41q13H+HokoooxPtRpk
	Rv07IYeMZovu+1ZM+eaD/rhZ065Bd98M40pX0fY4cjkfujJy9qwfnGtDm7dxtY65
	3YNjL0+FSqNKxkyrRnYTQAvgwx4xyQkqFMip6cAzIcKwSTAselmlGGBW2Mlnpeg4
	YubIVJjaCLBzZ9JTdK65beuxOHBBjZ6yY7XMFYRGXrNBwLGEf67h1/7w/DzdMs3M
	4CdlSjelQXYVcLAcwJir3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ncmt9qr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 06:50:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A74B6nJ005099;
	Thu, 7 Nov 2024 06:50:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42p87cywjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 06:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cTVQHPBaYHXCW2lOuw5tsb0yAGJHGRoYoJRG/SEiiyUZW2Sz8h2Lo6Vw5zoQ9B0apCV2Cx2BVyvZPNyQ2WHreiUBSWiEj7ac/R7VvYrrYcEk7fME3j0DD0K4BnsuLIvokqK8g+QbG+8MBKwxV+CFNcfY7uXyvC46OOx2oVvCIX3CM7t6hEU8UpIaVos3AK5Lx23Ix2A1vGZwIqh07npqjiyp002U6dgJlw65YEpbF/CrPwSReqKkqUtJ73puAyy1GcS56KdMymnIz/zK1hFEs4eBngH8zBoYCmIvfK1n/5NpWx2nBvYZTdUkes3sl2rd6c5iN0C5UmHOblWoWbhx9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=;
 b=pXgcrAplfLh+Y8YMavgn+MFgzegkQCm8WcgbukCLpBjBAs7PN985b8PFGrSCrJex9iLarDRF+gXkqWSwwOl5NzHJWAm4qDk7OBtebqWPHID6xkEC0CsTdA/+NTIjMB/IGF9lKR3wDX6Q9DrMsVyfZ9vRSIDYWLIoRD6/ReOnpQB/+ZXAArn6CojNBkrj4P/jX5lReqkmEaQPP1cD/9kU+wTfRbkmiqvqznzgj/7MAknZeJ0KOQdrstrmcF+kTBN4PrvqFJ9cI0tKBtw/iKASSKa8nRmeRz0fZcTWCnFv4AMUb0Y2W1eKiFTL76wm0maPErSmR0e7XW0gb5DrRNVclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULiv081Kj4y7AoOY69hF3b36tm1p96i2rLI5g7h1Hu0=;
 b=Jz9RqTRcqD5CU5WMH8lqA8ikEM2pwgcllBvD+22JjtY7EoFrH5WDtMBOMSA1Bjs8Z9UNfUHb9ABzGbi/w940iU1hZUz4azSLR0rQT+wJpmRRH5gaE5tJGCPX1dJO7vxbp62xqXIs02/C7pu9e9GWMPbvbHk36NVhpOkFaDwWhYw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 06:50:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.019; Thu, 7 Nov 2024
 06:50:01 +0000
Message-ID: <e0a82859-6c9e-43d4-b6ee-4b96fa193fa9@oracle.com>
Date: Thu, 7 Nov 2024 06:49:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] bio_split() error handling rework
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI1P293CA0006.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO6PR10MB5572:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd8be8d-72a2-4931-af7c-08dcfef866d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnpiZTMrUml5Vlptd1lYZmpyallBUzJCalJZak9jMlBJRm1tQ04xMkpyZnVn?=
 =?utf-8?B?ZWFrSklpalZRbDlmdnBvd2VWUm9lOWpzN1hQUTNHUm9kUmZiV2QrNFFqRUFD?=
 =?utf-8?B?c0EwRmlLUjhMaDY5WmdLN2N2dktpTlJlRXE3aEJVb0hRTEphTFE1bDkzRFp2?=
 =?utf-8?B?d20wN003dzg2MXBNWCtYRFUyUWhkRHUxWTdLOS9xQ1ZzSkJlR1hnWlpkeWNW?=
 =?utf-8?B?TXcrcTkxckFGakV1RUpST3AycDc2dmp0R1FxN1B3UnRzMmdNNnd1N3Q3eWZx?=
 =?utf-8?B?Mlh2K0RxVnFNVHJ0U2R0SXMvcXdncUdxMlNmczlHU0Y0SW15TExXNGphVERI?=
 =?utf-8?B?TklTeE1CQVhOQmhidWJuNjkwM2FoWlcvMFcveXc0WTZYaTlNa3QvNnFnTFUv?=
 =?utf-8?B?My9Ra0NFa3FxS3FEWUNDSzNETkNNeDNDekdZNFBtcDJWRDdkNWhzcEFMNkZ1?=
 =?utf-8?B?R0Jrb2R5MGc2dUN6UWpYRHVydUtzZ0pPREczbzRyMVpBc1NHSkJ2dHpORnBn?=
 =?utf-8?B?a1NLM1FMRDU2R3dGL1RWbnE4MnNvb2Nyb0JoZS9yTDNydndadXhBS0hJb2Mw?=
 =?utf-8?B?YURiWWZWWGhmQm5jVXlWQk1kcmRiSnhNWnlBTCtSSE9aY295L1RGbFFLMlZo?=
 =?utf-8?B?WklFNmlNVzZ4amx6MjBVNjhoSmloc1NNanhpS2RhUWJnNVRSbGh5TWJOZEpT?=
 =?utf-8?B?NVRYTklZVFRIb0RiVUdHOEZjd1hzd28wSnpUVERLQW9rc3pMeGVVb1NpbGw2?=
 =?utf-8?B?UjJLaDIzU0RScnA5Mk9mSzd1cy9SYUFIQS9KeUZmT0h0Qy84QW5Nd1FwUnc5?=
 =?utf-8?B?cHo0cWVaOWZyNndtZ05MMlAxNG4vODFqZ2RPQ0xocnlyZm1MOFd5Lzdia0F6?=
 =?utf-8?B?anN2QklYS2RQZjUvRTI3VktDaWllaDl0Q3MvL2hpa3ZVVEZ5SUhjcE5PV2lH?=
 =?utf-8?B?aGlFazFBVTVWSW1BaEJLMm5rR3hUaHEvZStJM0JvZTJubmxoL09TTUdjVnlN?=
 =?utf-8?B?MU8xbU0wbjNEZFVhVlhnQ1lCb3Z0UmNYN0xmRy80TnVxNWd1ZE00a3JoNnJZ?=
 =?utf-8?B?cm1KMWhSU0VYeXdTb1JadmtQM2RNdGRkV2lHQmJLSnMvaThxaGVYYVJWRjRT?=
 =?utf-8?B?RXFuMkZTOWViTmpDOFg4SXpQdGVFMUYwenBHMG1vTU1pUXBLNWF0R1hWNFNJ?=
 =?utf-8?B?aFJsSEU3UXdQSHc0Y2k0eklPV1Z6dmw5VWVlM3MvbklabDh0TjhKV2RyYVZp?=
 =?utf-8?B?MVlVOWsvY0M1NndIcXM2czdPTjdJOHkvNlcvbDRxdnlQMnpITnFUM3kvSGIv?=
 =?utf-8?B?ZzQzRUJKYkg5ZU9HZXJMUEFSM2dnTjh3d2lobnhKSHpVeWI1RlE0T05jTXpz?=
 =?utf-8?B?RTN2dGYzbHNVdmZqMXRMNlI1VCtoYU1VUlJxRi96QWp4MWJHS3N6UHFadXJT?=
 =?utf-8?B?T3RwY0g3TkpSNWVKMGg0WCt1UUxTekhIRlY5VUU3VjhYSVpZSG5MaTlBdVBh?=
 =?utf-8?B?djUyRXN5WEkrdHV1NGZDaHE3SWJsS0ZtK3ZLTi9mZUc5cDNiUFYzTnVWUER3?=
 =?utf-8?B?Zmk2Zmk5Rnp2cHAzTEFlRlNJc0t6T25DV2N0SVBzZ2p2S0tleHVkSDljVUMv?=
 =?utf-8?B?MUhYMDNxejlvMlJreWZMNzhNZ0tBb25PWVFpLzhZUHhKTWQ2RVE0ZlVNWndS?=
 =?utf-8?B?b0Y2ZE5uNExSelkzdnBuSFVYUnFndUJXbW11T0ZQWHFjd1F2NXhZYXczTXFl?=
 =?utf-8?Q?9+spXOixCNrOnU/9dpj6rsUfZd8Ln4AEcH37ban?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?di9xTytrYmw3SVdTOVpGY05EOW5tSGlxL0UvNENGWUdsMmkyWktUdTh6Y1Zu?=
 =?utf-8?B?RE5WR0kzWDlTcW9kUEFLSC9GeHh0MXE0c29wcGgxRVFoekFKY3dodG5hSFEz?=
 =?utf-8?B?aXlMM2g0akFSR0Q2TlloVnFCeHIxRGRtcVduL2xGS2JzZitaTVF3N1l5UEw1?=
 =?utf-8?B?TUdsTGF6ay9Id1RqU3dZUDFmUnpzRFdRTXVWMnhPYjJEZ3Y4VGQ4UHY1dWdm?=
 =?utf-8?B?YVJnVEd3NXp1dWlpQ0RiUFhrNXJkR0hDZi94blhwd3IrZU1YUWsySndZLyt5?=
 =?utf-8?B?Qy9FM05FUFJZZGpzVVUxVFZMSHV3a2VRbFVFUFltQ1hMaGxZeS9NLzVhc3ZS?=
 =?utf-8?B?bmdTbjgrT0lORFcvNGpVaTl1cHlNVkxRZU4wOTZ6azFYTnppcm1TS0svTkpU?=
 =?utf-8?B?Z0tJdW9PTlNPRWJ0UE1ZQ2Y1cnp0dWpkT2tPeDJrZ3Eyb2hMeitMc0ZDUDZo?=
 =?utf-8?B?dEZwNFFOY3VWcmw4eUJFQ1NzQm1GeUcvdTgydkFoZVlBVWF3eFVTSjc0YmhZ?=
 =?utf-8?B?RDdkY3RWSHE1bCtzR2xOTkl6TDlDeUJsK2c1dkNYRE52RXFuUjFZYjJNRVhx?=
 =?utf-8?B?WHRwY0JjbzkrL1hxemF1b2NGUHZaU1RZQkd5MTBLeE5nS3grN3hibTljL2t2?=
 =?utf-8?B?cFZTek93SmxwL21KL3BPY1I5Q0EyZEhyWnA5NC9QMGdlZ2JVTTVhaHUvOWlm?=
 =?utf-8?B?U2pKN0lKSktxckdPd2JKd1lQazVHUVAzY1grVDRpY2V0aUw5dm03Y2VJVlVz?=
 =?utf-8?B?eWxoVHVFcDE3SE1LQi9aWWROdE52VXRzUUJkR2tkM04rNFlWeVZtd1FjTWRH?=
 =?utf-8?B?UCtVQUhNWTJwd1dnMG41UHdtbm5sYTA1ellycGxrNWREVFdGUHVodzJ4U1RI?=
 =?utf-8?B?N1NKcXhucnFmWFFxK2xkcjNOS2pXTjFobm9GTWdKZFllejFqVmNYam05K2lj?=
 =?utf-8?B?TE13R1VIM1hENTVFYTRwM0JPUitRYXB2ekxmalp3UUZPOEthOEZqYzQycU1T?=
 =?utf-8?B?R1ZGYUtLc2hIaXpiYXhZenZ2My9nV1Arc1U1ZloyeE9taGlyVnVzdXBLc0VD?=
 =?utf-8?B?NG9QOFZLS2h4R2xlMlhkWitxVHM4MVpIRlZvWWJHblNMaXk3OGoyRloya25i?=
 =?utf-8?B?ODRuWnpNSGc1RUlOSDBvUGdpd1hXYUMvOUkvV0g5UmxMWjBXcUlnUjAzSGJP?=
 =?utf-8?B?VG9MekgvSmNHWXpoSUtzNng5L1JIeXpBQ3BzcU5ZNjVyOTNnb1BWSGNIN2hB?=
 =?utf-8?B?bjlhd1dDbXBxTVExWmlVclNNNjZ5LzUxdGNxV053S3VJN2xxSkdtOSt4YkFX?=
 =?utf-8?B?NjNicnRwd3lQOFFPUmI2d2hYdjJ1bVBON2dPWHFKNW5uTnB5eGNvTGpPU3JX?=
 =?utf-8?B?SlB3VnVOM3IwMEF5Q2NwQ3htNzE1STM1YXdDN0JqdG1iN05aM01PQ0tQQkly?=
 =?utf-8?B?bkJYNGZnVHBoQktBdE43MURRV3FuVnprN2F3YUtiVU1mbVg3Nm10V0RyVUV0?=
 =?utf-8?B?WlFwSkgyWnZodTh4bEN3MGNkV3FJbzViOVFxN3l0U1ZoSXJxS3hRcGFpZTZk?=
 =?utf-8?B?QXBnN1BPdHN1UjB0MDNsNE81Z1RyT0tuS3JHZzk0Tm52TXJ5RlkyWGxtdVhh?=
 =?utf-8?B?QkcyTlNCTjlubnp6Ym5XZ0ZvOURpNnduVS9UaVRJdHhPdmluYnJIMm1WK1ZQ?=
 =?utf-8?B?ekJrT1ZuWGVjRUdPL1kzYTBiSFlpY210T3B6c3M3d0FwZ3V2ZFg2S1BzOGpW?=
 =?utf-8?B?NThFak5HdldjQUVnWUVFcm45OEp5ZXhBZXhzM1FQNmh4ckZZKzNGNy9LYzh4?=
 =?utf-8?B?UTBrQkY0TVA5bGY5djYyRE9ZeTZsTHY5Uk5YdldxZnpVcHcxbEd6ckpkbFNa?=
 =?utf-8?B?cjRsOGZhcXlDOXB0K2s2V2wzZGh1dnh5eHBtcU9UMktjSjhtaDVNRU1pSnkr?=
 =?utf-8?B?ZlhKS1FJb0NzbzRGaU9XamFORlZEcGlvcTU3YWVCZ2VMWlp5TGR3eU1HcElO?=
 =?utf-8?B?NTNCYnJZMk9QMWwzVzB3UUttNXZhZnZhYSt2a0FLQThlMVZxVmlUckx5Ry9q?=
 =?utf-8?B?a0Ftam41aEw5WFo4RE03ckhrQkx3a3BDUG0rZ0drSlJvc3pzN3BqVWhTOEtI?=
 =?utf-8?B?UGdRT0hVU1ZxTjVaaGova0NpQWxFakVrd2YvV0FpZWlmWTJNajN4eTJNVklB?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YqwuxdeqOWwz8WPuo6Ag6czL2EDxFcGSIpJlGsEiCLgTtZ+vPIifJT9Q/9FnDK/Un7SVh7VU26n5vmWN1almu2/KarUnv+VGU+ZkE/J+I+zampiMp2OLA7nOQQWZt95Xo+v3+saSDG1IaTJxdIG9PcXhq6XgZVXZnBtEwYcsC/I5t7xBf9gXxL3qyC/8vFwELHNUm5N+Yc5E7qxiQ705PqwIsUsEc0xKfMk6AGGTumtC2pfczsWaZuIJ8m0tLAwmDC6GzpZZqDvoHsv2cQIx7d9QBhYVXDDAzFAUmOt7oWl/7BHDR5KyAoNlE6aBUOPobCIfmYPahEfy1/mz/pDwp6O/21inBFhW08c41WBDWqgkykeOLlTcZCmQE5yR4raJQheSjhApoL58j95Q8pN8mHBZBGvAFJigSYOvXcBNVWUI1JG2hl6dMjiBpjRbq4HA0Tez7WkiL2YMVOBBYDxHP247pR77EC+25Zm6aw/yQlDm+q16936xUrEpCZl+nn521ZPMiOUiyjVODe1mK/+i6JVI4oEBvdc5QPhwXBQGLaXl1Wy/IFk52bZSjn7g1cQCvphrIn/oFLegfCCIFkHP7hgqJiI2d6MkM83cUwBEJu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd8be8d-72a2-4931-af7c-08dcfef866d6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 06:50:01.3298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kTkHribgDiM1jMTMyxcGNsd/dzLcaGz1glsowi0BkmrSYgYA5+T+RB0Rf1Pq0fv39aJHGoX6Mog1kiVDtMrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_20,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070051
X-Proofpoint-GUID: Q_h9pKzkDXCHTKjMu4Luf235ZbSEp-2d
X-Proofpoint-ORIG-GUID: Q_h9pKzkDXCHTKjMu4Luf235ZbSEp-2d

On 31/10/2024 09:59, John Garry wrote:

Hi Jens,

Could you kindly consider picking up this series via the block tree?

Please note that the raid 0/1/10 atomic write support in 
https://lore.kernel.org/linux-block/20241101144616.497602-1-john.g.garry@oracle.com/ 
depends on this series, so maybe you would also be willing to pick that 
one up (when it's fully reviewed). Or create a branch with all the block 
changes, like which was done for the atomic writes XFS support.

Thanks very much,
John

> bio_split() error handling could be improved as follows:
> - Instead of returning NULL for an error - which is vague - return a
>    PTR_ERR, which may hint what went wrong.
> - Remove BUG_ON() calls - which are generally not preferred - and instead
>    WARN and pass an error code back to the caller. Many callers of
>    bio_split() don't check the return code. As such, for an error we would
>    be getting a crash still from an invalid pointer dereference.
> 
> Most bio_split() callers don't check the return value. However, it could
> be argued the bio_split() calls should not fail. So far I have just
> fixed up the md RAID code to handle these errors, as that is my interest
> now.
> 
> The motivator for this series was initial md RAID atomic write support in
> https://lore.kernel.org/linux-block/20241030094912.3960234-1-john.g.garry@oracle.com/T/#m5859ee900de8e6554d5bb027c0558f0147c32df8
> 
> There I wanted to ensure that we don't split an atomic write bio, and it
> made more sense to handle this in bio_split() (instead of the bio_split()
> caller).
> 
> Based on 133008e84b99 (block/for-6.13/block) blk-integrity: remove
> seed for user mapped buffers
> 
> Changes since v2:
> - Drop "block: Use BLK_STS_OK in bio_init()" change (Christoph)
> - Use proper rdev indexing in raid10_write_request() (Kuai)
> - Decrement rdev nr_pending in raid1 read error path (Kuai)
> - Add RB tags from Christoph, Johannes, and Kuai (thanks!)
> 
> Changes since RFC:
> - proper handling to end the raid bio in all cases, and also pass back
>    proper error code (Kuai)
> - Add WARN_ON_ERROR in bio_split() (Johannes, Christoph)
> - Add small patch to use BLK_STS_OK in bio_init()
> - Change bio_submit_split() error path (Christoph)
> 
> John Garry (6):
>    block: Rework bio_split() return value
>    block: Error an attempt to split an atomic write in bio_split()
>    block: Handle bio_split() errors in bio_submit_split()
>    md/raid0: Handle bio_split() errors
>    md/raid1: Handle bio_split() errors
>    md/raid10: Handle bio_split() errors
> 
>   block/bio.c                 | 14 +++++++----
>   block/blk-crypto-fallback.c |  2 +-
>   block/blk-merge.c           | 15 ++++++++----
>   drivers/md/raid0.c          | 12 ++++++++++
>   drivers/md/raid1.c          | 33 ++++++++++++++++++++++++--
>   drivers/md/raid10.c         | 47 ++++++++++++++++++++++++++++++++++++-
>   6 files changed, 110 insertions(+), 13 deletions(-)
> 

