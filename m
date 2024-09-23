Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448B46425;
	Mon, 23 Sep 2024 10:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727086901; cv=fail; b=c0Jbg7OYoTb46Wj08okV18+RUFslGFmGvTpKecyE9k3LzeHn9Fv3dz0a2NPtgjkYQWo6iXpxT3k9tBRaxRAq3/dqgb8ZWf3fkjmxKHuXhQDQM29WWiK37Qx+ZgeIl2gIIULfPfFS4WbHyJB6Ym2wvxFeU3i5Q+EW9Cn9RSsMzGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727086901; c=relaxed/simple;
	bh=moqZVLo07+rg/NzUXixoyvTF91Ryr8/+BavLkMkovsQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B8fhKVjQIFt+ZxzzmgpmbDDR3kKowP9dq5qCiH3GT8OPp/gmFSR0Dh2lYVkWBUejwPC0Cq2JAme2RAA1jaSU0bkRx2dkgqVnRy2nF09HUz1M7vwWENvjrLvotKqPo6slWvHfSUSb1J/LkePEd/c4ksikog00REoCM+Eqo5S60Vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VV2siaug; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EiFKwsNB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VV2siaug";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EiFKwsNB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48NABtjY020288;
	Mon, 23 Sep 2024 10:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=dMKnzSt8nf3RcTMD/YCOEhIIqk5gQQScJKWWqWYlFww=; b=
	VV2siaugpfSGMHrJNmu/D8x5bS0WYoBGTqARdpG9PtD+IovRtr7GU65G26cEdecx
	b391Lbg2nl9aA8N/aiHUD1XRkTE2jXYFqnEDBY5wvKH7vy4NgU8KjGM3NBB50na5
	3CzRQRZSJ77e5KV1f8HZFqP0QFVNkhw1GqGCluNR8MwgoGmAPKz0GzvzYGu3fdzq
	UbDwI5YoZrNr9jbJ87FlpQ9GruQxb8QaQAbYyg+0WEcShZXo7T3v2d3DxkN6uP41
	QyryH3sQpELKZp07au2cuFmxvmTvefLRbS/P9vg3MSL3Wesw8ta0mCfsFFN3QWbu
	4q7C7lc5vra0b36A6MJFNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sn2cmbj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:21:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48NAF1TK029552;
	Mon, 23 Sep 2024 10:21:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smk7k7f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oXYSiLUPvKzpDj7u7ls3nyM3yZ+uphkV1ZkmAwe1z8uA0o7HwE0mrT/Six+ekbxPaoN1aAvQrYxJ60JaDi92T7YauFRiYlAQLpn2BjCkmrPNYgSWKTlpYnI9cEVPuhOAKT1r1R5hxTaZXG8M1kMBulMrM2L9o8GQJQkBunD8ZxwETweUrPeBZB6WgIGftTLYfpGV+JvsuMcazKn7axQKM5ScHXwEfYSmqpfrm56Yxxzu2rHRvFsxTJJfYxh8tY4cWkHuk2KyBqm3Clv7mLQqVFldrSBSZUC4XX9GfTm3npwtVp6GHa4JWJjw6lEsP8ptfqWn2+11dPwzmOwPhGlGTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMKnzSt8nf3RcTMD/YCOEhIIqk5gQQScJKWWqWYlFww=;
 b=p1YYyeJaZQmbg5IBONFm+N3Muvmc+TjV05WApzrlKquPEUKx5o18CkSKJnyUcLxtRVN8BKQp9rqpIKV3PU6exeUCaWNUMTDQIdUPT1NR3Sr4Mo7w43f7zYbRpf/RiLDDT/chkaZgzPe2QLo1PxVlCMNOhnJtEavttvTP5I2OmVk/ovp5o1RFYPlbPuFxTmQFTYg7aB05wsTJU6kF0SnXKaz+92Uv6kUAKLDOTgGwAWUIQuU8201Bk/xMyZ+HsRir2t1U2YqCeh6BJEktLtMkskC0GVF8+HFyvWzPPKxe4PJBl5Lwp6JDZpTGfsmbhYRd9bPANafkiDR7mqp+um/yuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMKnzSt8nf3RcTMD/YCOEhIIqk5gQQScJKWWqWYlFww=;
 b=EiFKwsNBMSwiIktXDMwpQJkACSgMFKOAfVwas0O1BU6XJqfZC07PJDRhFa+vzI6mwVfiD8CFFaOQXwngBB874D36c8VFWuJkXg0R/dNS/MnWbJynRX7vgPo1jKiuv/zD3KhaTzERY3tCpGTO2qd6XL9UNfnYvHk61HKUuWiKz0I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Mon, 23 Sep
 2024 10:21:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 10:21:28 +0000
Message-ID: <b909783a-51d8-49c6-a9a0-a23d51fb6d29@oracle.com>
Date: Mon, 23 Sep 2024 11:21:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] bio_split() error handling rework
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <bbe71976-c16c-4e3c-b110-6bf8eb709d54@suse.de>
 <86f3586d-5b0a-483e-b94b-d4515d5c5244@oracle.com>
 <b3cbc01c-e314-4df1-bf0c-b69bdcd638f7@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b3cbc01c-e314-4df1-bf0c-b69bdcd638f7@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0041.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: e14826df-579f-49da-01e7-08dcdbb97c6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTdGKzlvMGpXSVZMK0IyYjhOaU10SGt5dHEwTmNZSXUzVkZqUFY3NmZHSUdQ?=
 =?utf-8?B?ckh6TXZncExpZHJURWg1M3lJOW1WcEhrd25KcGdaRC9MYk1iWlFScEpXMmg4?=
 =?utf-8?B?bTdjRkFVZ0VmS0hvdWIreDJvMVc4QWNxWDNhemQ3SG1XQ1hSZWIxTHZUMTFP?=
 =?utf-8?B?ZnczWUJtMXZ6YVh3M3BEWkRBR3ljYXlUbU1yVVRuYXNZU3JWMlpSbUhkekI0?=
 =?utf-8?B?NVlYVkt2NjlFZGpoVjBjRXlnUU9ISGpGNC9iU2VZcGFGelM5YkxOL1BFT2Z4?=
 =?utf-8?B?NlVOaUlVV2JyMjZScGxCQXFnL0wvS2FqNm9iUnV4Y1dqd0hYSCswcnFlaW9V?=
 =?utf-8?B?VUVHTnN2VzJBN3pkcWpzSFk1eGRUQlFST1VQOTN3YnVoTzgxemppZ0E1VVcv?=
 =?utf-8?B?citRNHREVjVycDI0UEhFa1plTEVhTjB5Z3luNkVBYnpLRVdOejdKQTc2b28r?=
 =?utf-8?B?bnZsVjVzaHVyTzJTeHQzd3pTdzRrNGVsaTA1Tml2T2YzT1RuK0w5Y1pxVXVo?=
 =?utf-8?B?RW9yU2lWRUVuUnpXdEdUTU45azJFQVZkWHVnZlMreXo5RzZZbmVyTjJJRnRt?=
 =?utf-8?B?ckpvcXRya084R0gydnZvUU1Ba2NmdmJxaWUzSHRoem83Nmo5WmVEUzdzQVFx?=
 =?utf-8?B?U0JKdnlBWkRKT2pwUC9oOGFRK1F2N1QwSzRiRVNiazI1TU5zN0ZqbDdnZ1FX?=
 =?utf-8?B?SVdSclAxV3NWQkpYMUd6RUZEOWZiNDdEa0ZKb210dklpUENzWGdibHlzeFBT?=
 =?utf-8?B?dVJtUWY4ZVlnVHdSNkxmdkFMZzhTbWtSWWtkSklxeTJPcXU5NVkzS3FrTTdL?=
 =?utf-8?B?cDdPNlNROXgrejZ3YXNvYXNLNU00MWI5a0xVbnB4YlhRQ0lzUDJrTHNVWEJu?=
 =?utf-8?B?elpQeHFlZkhRWDZlU0NPVG15WmhJUHJxRzlIM1pMMHlpVDZJbW5MYW9tL0Ns?=
 =?utf-8?B?VTlUbitWOHNaQnhZSkl3N0lMeTFwZWVZQUNGd1dqVk9NMDRmaGxuQWZVT1Vy?=
 =?utf-8?B?elFFUHcvVmQ0b280YlIwL3pBZ2RlM2lrSWJzS0lpcERaRWVlcG5uT1BHL3BI?=
 =?utf-8?B?N05pdE9OUElBVjVHMS9iNTZsc2tIeHg4TjhnQVdiRVFEYmJITFhzR2dVd0Zu?=
 =?utf-8?B?WURJcEt2YUhFcXVCdjI5YkZENGJ1T1VuN1FDZEtQRzI3UVlEV2tHY3haTjVJ?=
 =?utf-8?B?REZ3NzEvazNkdy9xV3F6ajRJSDF4VmRiN2RaTm1lcXh5TlBkSVJCY21maGhU?=
 =?utf-8?B?QkdWTTArc0xJZVRyc1cvZEREMzV5ZmY4d0RZSGl1T0VFZVBnY1lMT2RQNE5s?=
 =?utf-8?B?aFF6UUhRdGp1MWJkMUE2MGZ4UGVjejFwa0xqZEpTTUhYY3FMN2V3R01kQXp5?=
 =?utf-8?B?TU96NXdSTUtUOUlNTTU0WTBCaG1jV1NyeFlEZkhTSEQzZ3p2Tm1BVEs3cGhr?=
 =?utf-8?B?VEZRbTd1amJMRUdtUStwckRyZzRYKytRMmZkYjNzbWhoZ21LNk9Bb3MzS2Jq?=
 =?utf-8?B?bW9zVkdVRlIzbmFrd0gvRmZQeml2WWFjWlRMSUhrYy9Mbi82amI1eHJQcUE4?=
 =?utf-8?B?TXdkSWhlcWZZakVEdHB5ZmJ0cTBoczdPQitVbENvTldTSjRPMnFlWGZhVlJ5?=
 =?utf-8?B?M0E1V0pZUyt2VVZ0S2ZSRncyaklTRXlXM2xRdEsxS0ZVZ3FhSlNNZ21wL1hp?=
 =?utf-8?B?SmpUZUFVYUJIbUp6MmYzWjNBM0RLSXpDekhkd0cwbjBjODNMZmN4YWcxWnAw?=
 =?utf-8?Q?41KzTWeEgxnAlt7Xbs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzA1dDg3N1FKMVFvSmZVUExuMTZVSVFyK1VQR0duMU1xYXZ6NmxSY21wWFFh?=
 =?utf-8?B?MGJwb25lVEErWCtDalFiQVJkTUJ6RFVGTmlIeE1PWHRLQ0dvelBpRmR4bGcz?=
 =?utf-8?B?dGZMbUJqNFAxQlhaWmN6a0RKY3dSdkMrOVJYdXF3MVZqM0lxVHdzZU15TTNK?=
 =?utf-8?B?MWZFL0V1b2o0amhxWkF6OS9DNkttcUlENlk2RlhNYldsdWZLT3ovQllRaXFC?=
 =?utf-8?B?RE14RUJ5Y0RBMGFIWXhMQ2JIOER0Sit1T2xKdEgxQWlLa3N1RE1oTXMxSzJj?=
 =?utf-8?B?YUVHdFJ5K3JtdUFXNW1OcEZkYXovUTA0QTBxb0FjenFZajBndzQwSTVpdmJ0?=
 =?utf-8?B?UlpEZmRZSUljaGhtOVJmZzgwaHMwTTJYQ0c1bGlrbFpyWlJGSkNLdTB6Rysw?=
 =?utf-8?B?Z0wxdjdzODlEZTVXRTdLNFNPZkFPbzRUbWxHaVhBaU1HNy9kZGRXMUN0MFVG?=
 =?utf-8?B?RzFwSkhJLzVhMXY5R29FREJMeUExbFpXRXdTRXNxNmVGM2FTT3J0bktOUWhC?=
 =?utf-8?B?WEVyNFlUQXM4bkJ0QWVlWEovMnlUc1pGazRETDhPZmJsVWR4S3JDSFIxVTQx?=
 =?utf-8?B?VmlyWW1ETUFuVkVka2xjQWs1MC9QaUU3OTNwckFtaDJIUTNzamhhTWptT2ht?=
 =?utf-8?B?cmRMWEhNcnFKb0MvUU5ydjhGV0Y4d3dUalgvMzBPeW9PYWx2TGJjK05pMndM?=
 =?utf-8?B?dE42STJCaFZ4ajNVb2xVL3dTdXNTNnJ4WHVIT0xRd2h2VWF5VU9sZ2kzK0Vj?=
 =?utf-8?B?KzJJY3VWalRuTnI3MFJPZ1dKM2t2R3E0NGoxREhmNzliZXZLYmdEVk9GY205?=
 =?utf-8?B?TzdqdXVKcjQxWUZUemJ1TW1EOUJqL2tEWkJscVA2czQvdXBDVVJHUS9McUd6?=
 =?utf-8?B?eTdJZkxWT0kxdjIrbzMrWmo3U1NET29GK3JuZEVOZXh1T29qcW5Ya3pLbG5V?=
 =?utf-8?B?WFB5aVExbGNWZ1EzdFJYTDhmbFIvaXkra3BJcUQ4eGEwSkFtcTJlSmE3ZThk?=
 =?utf-8?B?KzRLN3VhV2RUNjNxelkrL2NHSU9hcXNDZlFMek9zcE1jV25wUmVxbTA1MlNi?=
 =?utf-8?B?MFgwYTBoNnNNclVwVjFzMC82c28wMkdMK0RsdHJ6enFHQ2QySFpOQkZjbGVJ?=
 =?utf-8?B?OHlCWldnTVRST0xhdUZmemg0RWpURHRzK3AxYkw2WmpGbDFobHRsc1dPV3hk?=
 =?utf-8?B?ZEY4VEwrSm5yWjRzRlFNK1JyN2VoaUYxTlN5OFlKQUVUeEJud2xmR21aRlR2?=
 =?utf-8?B?d0lKLzdad2ZXWUdSY3JYSEVwbHBNTWRtNDd0U2syeXh4bHZ0cjFvdW1pb3VS?=
 =?utf-8?B?TVd6RlNBVWNVK2FTODJ1VEE2WFRaR28raEdjaW9aSTl5bTNDT3NGRTJ1bHIz?=
 =?utf-8?B?SDNZc0ZwdkZ0V1BSOXpweUt4cEJvd0dIckxvcW9YbzZZUGRodkJQcGxZSEpT?=
 =?utf-8?B?a21QRHhla2cxVGhoSkJDeWlKNXB0MDEyekM3TDZEczZ6cGs4NnFIUmY4SjVH?=
 =?utf-8?B?OXZWbDNPZkFXSVhuQXI0MzZXekJjNDRiZ3Z6UVFqWXFyOUg0NmM4a0x5NVEz?=
 =?utf-8?B?K0RIZkhjMXRHU2NFdGJmZlJ1elJYRmk4eWttV3JRamhkb1d2VVZTYm9MS1NM?=
 =?utf-8?B?QTg4RFFBS3lqaWRlWXZ2cFFYNHp1RCsrQzVFcXg1L0J1Z3NOYjNBR0E5dGVV?=
 =?utf-8?B?ZnovTmNTR2hnMTZIWVQzbmhhQ1RpOW14QjdXRlpMUE5YSkJ1NU1SbVhhL1hp?=
 =?utf-8?B?NFFmakplcHRRd1JCa2orY2x1ekFPMitCemh4aU9OS3BBbVZ5RStyRDVqUU83?=
 =?utf-8?B?cU11V2N2NDB2a2ZaRGtUODdCSm8xS2F1ZnVCRjRLMkZ5cFllQytxb1ZiY1Zk?=
 =?utf-8?B?aU5ROFBvNmkzNGhVQVAxd3VhRjFCUU0yNlJDQVJGdSs2MU5OQjZFTW9tY0pr?=
 =?utf-8?B?UkxJZE1PYkJPdktZZm1MRTlsUDk4SjJ4blBZZVlPeEpYOFU1NGMyNnptWTZH?=
 =?utf-8?B?c1lBTEsvUGJqQ0NjN3pNeGFXR3FSMTdwaDBLQ2FxaTd6ZCtYMlBZTTdrRWF2?=
 =?utf-8?B?c3FMOUdjOVRxSS9TbUJFckcxdVdRRnBnMFNMMGsxTGxndkl1SjBCU015NW1Q?=
 =?utf-8?Q?zcVLklNtHyml3k87vf9rTl7nu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D/0LAaumTdF9xA/9z8hjOl/Tdp0PsgXmqmG9iGZCs4dIZZjitOoivqWMcOdLvIsFD9zoeT2so1ny6ipQAOIRTiPQT3yiSe2e2h2Db4fv5iBLHTia/M5Tu4vMubThm564Lz5LEooQ1FrMRUex0bUmZpM1OQJIBaK079gGHDHzldPGRsZwg6ToRPwJYMyTGHXoFLQkM0xRqhpQhAcy5N1UebhM/QeuAdOWwiOsBPTAJlnzqJjcqg16l4FiINmS/8WMHS75h07mF4U49jHZR16uNQtEqYDQZ4HYBbin8enKlSkKbN0mdsR5x42NI1az5Yir235nCcQ9mDDRle0Yrenn50/+NZ0qjRC9sK18eGgZwPuxKxc7Smuu2gbgNBFE1T7Yw4JIHitCwbeoNNYC8UECElZP7JoqOek+dAEv/XE7Rl6tG7yZcHYFAxMzQw6zIxDzvTEIGYmbb8TnDi1ycQvE8TgwtWflFYFh4FfiGt6EnddouI/iY1ifth8BenCciD9hkSZNUWE2GisLfbb/eu9KCzAA6tgXOF0hz1qhadwdLEJNH+5IsT3GMUTqymxSwf1jxvtZDv9emClCsW7YsYkhTc9+n6xpgagDnOT/ORYT/P4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14826df-579f-49da-01e7-08dcdbb97c6b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 10:21:28.5638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzvMC8f98pBHjFCI+eZnHOQ5wEdCtiuZhHE6yXEhuNBHq1Bjaxrq6ELb5RwI+rPJ51VBtHX/UJO5cDnGdxcVSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_05,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409230076
X-Proofpoint-GUID: P1cVI9cO2ogKJnhWkT4QYWIHyvMG4P-K
X-Proofpoint-ORIG-GUID: P1cVI9cO2ogKJnhWkT4QYWIHyvMG4P-K

On 23/09/2024 10:43, Hannes Reinecke wrote:
> On 9/23/24 09:19, John Garry wrote:
>> On 23/09/2024 06:53, Hannes Reinecke wrote:
>>> On 9/19/24 11:22, John Garry wrote:
>>>> bio_split() error handling could be improved as follows:
>>>> - Instead of returning NULL for an error - which is vague - return a
>>>>    PTR_ERR, which may hint what went wrong.
>>>> - Remove BUG_ON() calls - which are generally not preferred - and 
>>>> instead
>>>>    WARN and pass an error code back to the caller. Many callers of
>>>>    bio_split() don't check the return code. As such, for an error we 
>>>> would
>>>>    be getting a crash still from an invalid pointer dereference.
>>>>
>>>> Most bio_split() callers don't check the return value. However, it 
>>>> could
>>>> be argued the bio_split() calls should not fail. So far I have just
>>>> fixed up the md RAID code to handle these errors, as that is my 
>>>> interest
>>>> now.
>>>>
>>>> Sending as an RFC as unsure if this is the right direction.
>>>>
>>>> The motivator for this series was initial md RAID atomic write 
>>>> support in
>>>> https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2- 
>>>> a93b-0a433741fd26@oracle.com/
>>>>
>>>> There I wanted to ensure that we don't split an atomic write bio, 
>>>> and it
>>>> made more sense to handle this in bio_split() (instead of the 
>>>> bio_split()
>>>> caller).
>>>>
>>>> John Garry (6):
>>>>    block: Rework bio_split() return value
>>>>    block: Error an attempt to split an atomic write in bio_split()
>>>>    block: Handle bio_split() errors in bio_submit_split()
>>>>    md/raid0: Handle bio_split() errors
>>>>    md/raid1: Handle bio_split() errors
>>>>    md/raid10: Handle bio_split() errors
>>>>
>>>>   block/bio.c                 | 14 ++++++++++----
>>>>   block/blk-crypto-fallback.c |  2 +-
>>>>   block/blk-merge.c           |  5 +++++
>>>>   drivers/md/raid0.c          | 10 ++++++++++
>>>>   drivers/md/raid1.c          |  8 ++++++++
>>>>   drivers/md/raid10.c         | 18 ++++++++++++++++++
>>>>   6 files changed, 52 insertions(+), 5 deletions(-)
>>>>
>>> You are missing '__bio_split_to_limits()' which looks as it would 
>>> need to be modified, too.
>>>
>>
>> In __bio_split_to_limits(), for REQ_OP_DISCARD, REQ_OP_SECURE_ERASE, 
>> and REQ_OP_WRITE_ZEROES, we indirectly call bio_split(). And 
>> bio_split() might error. But functions like bio_split_discard() can 
>> return NULL for cases where a split is not required. So I suppose we 
>> need to check IS_ERR(split) for those request types mentioned. For 
>> NULL being returned, we would still have the __bio_split_to_limits() 
>> is "if (split)" check.
>>

hold on a moment - were you looking at latest code on Jens' branch? 
There __bio_split_to_limits() will not return a ERR_PTR() (from changes 
in this series) - it will still just return NULL or a bio.

In all cases there, __bio_split_to_limits() calls bio_submit_rw(), and 
still bio_submit_rw() will return NULL or a proper bio. This is because 
we translate a ERR_PTR() from bio_split() to NULL.

Christoph changed this bio splitting in 
https://lore.kernel.org/linux-block/20240826173820.1690925-1-hch@lst.de/

I think that if my changes were based on v6.11, you were right.

Thanks,
John
