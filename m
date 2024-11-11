Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A8A189BAD;
	Mon, 11 Nov 2024 11:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324277; cv=fail; b=lzHC6Ba9tcadXAGuetS5tjb2NFwl+9qccTWZVCdfVYTwRTwOsd+s0m4/w8UrHCK7n9ypXFBGaM34K6ZHUn/R8Dz4tTrVCTvo5sUP8risEIfvKZBfLzF9mYiTktlwDLlXtzU4I0c3P1QAtzDyaryphmTedMuN5YMrdfn2DmRQA2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324277; c=relaxed/simple;
	bh=9p9Hf9mfZvHDuPIntFbjvs3Lh/e+LJ9Z0sTNZIxNTak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YK1sxjgUp3K7gN5KkRzVPfOLX+4nFrSRW6GnLdnQ5R77GJqvfrhqoO+D+wKRKJmUV5dyMsxiQm66XcIbL7CYFXtbqKLte+m2bkzxaPMvs0wman/l/DpnCSIkEImYDb6Yjjuvp2r5RI45LWI8z7FEqviJJ6dE5iOVakNesoX4cpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fm1DD9Qo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r38oIisO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fm1DD9Qo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r38oIisO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9sqc9017741;
	Mon, 11 Nov 2024 11:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mERBgal2NjUMyVe/2gn647OuzFE18WkFOymC5X6Nqds=; b=
	fm1DD9QoHRTS4j148ieiVyYoHK5Hegsa5xzkDZc8wg+5b9i7LXhfEUrcjRfTbQPF
	6wef72uZItlTRl+sE7V7UVA8JCEw8Y9K0F5lpcZACT8/OLyliMERcaizdrvpPGEC
	eGyctVIyxyXthkWFo5/0Zor3T/dh9HsGGQz87wNRpK6dcGVvUj5y9RZbrPIvc3DA
	4kCKqRSsK/v32ASBGR22W02yulHsTT5Z9o3jFRuK0XVVP7fCN/dqRj4kbb0yf1MZ
	vAZarl9VkN7wYb+LhKqgOmd69K1osbtq0etZ/IauhA6RonE46FzfrArFmrjfWPp6
	3CtRsTTMYvPi03a1iXlIyQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n4t7ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9eMTs025432;
	Mon, 11 Nov 2024 11:22:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66tkug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6EtvoeniMWPm6GjcDS8YxopBvGpJc2t19f0ng9ane+hqyU9Xsd1/lzbLUY28QqMfhlhHj3dwgKnRunbic8zOeaJzuJG/LC4zb/4uWRxpjPcVb+bXhE1MTCYg003xWeQnmOttY7rwebozemgdc6fEBDOEGzFt5kUnxwUWmkM1DUHz5DMZlBM04WbQUERe40nGaxYZk7zshvYp66tK/mpHjdwcF8jG9USDe7CIxZT9VgUSFrUZuhAwZXvP0a+qeYlnvMCsjNLAqP/OY4rEkCTb0V/mmYfFcsa3fQtYOavgFw6TRU2jUIGEOqGYEDuV3oJvbgTYR/BIOSDr8gCT77F4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mERBgal2NjUMyVe/2gn647OuzFE18WkFOymC5X6Nqds=;
 b=Wr8/SodxRk6HimI5QctQ6rghgpjzWRQbN7PVAnFWSmvI5Z9iztIb5O7PNuenej+NxRUgEasQJq3RcyUXU3W6uRN2N6+ry5Zin5Q+EgPrLjEt1VEwq3SmRz/oNt9IEWzecP6H2OnfEH9FMAVvStaCozi8Auv3EONjCDMYJRuWmstHV++bcZ7XhRSTksrjvUYgXKFv+BY0yHV8GlgLVT27m+nKyw540jfchq6r+mo3IZDj5vGGvj/IaNyMsUefHQHPUgKLEMFJLYoNj5r37Uu+a5u6/phdm8RELG1PmmXwOvEWEtlWpToSVXx/5kRVgePOoLCEFjbu6B6uE4SaAP70Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mERBgal2NjUMyVe/2gn647OuzFE18WkFOymC5X6Nqds=;
 b=r38oIisOlwyLWGgbV7rNOEtRNaUcsH6vPzWKZwubCirqruQshpWpwwEvmzSwS7D7Jn0O2mZQSHK/f64FJYv+rRVj3Mh4ivydkBc88SgAe41FsqS3h3Ykam1kcIgx8AYWMP1vNm00rWuuqTuInYG++PQskJWn9gyg6tafHLew3Ok=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 3/6] block: Handle bio_split() errors in bio_submit_split()
Date: Mon, 11 Nov 2024 11:21:47 +0000
Message-Id: <20241111112150.3756529-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:32b::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d8a859-24cc-46f7-d420-08dd024316f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wV/EBDPSZE/IRuWoCra6DmCoZElOy0+dVnE4wHbNRS59Fsmbxc+PDb/9aW8s?=
 =?us-ascii?Q?I5+7g8x6YVMptUJM/tevTmZW1JoQjYg/utt/oPDijUo5VAmmTwJAsl+DGay0?=
 =?us-ascii?Q?Ygb6tEzzq1tFhhrzo/kxKI8oHNAbDN6sPl1CpSSRpIE1ygp9lppo3Dp9QoBn?=
 =?us-ascii?Q?RaXwObrZ1xySi68REScHOgCmgpIwFVJCvmuyAgHf3UU2hmh6NhXrsxHMHTT0?=
 =?us-ascii?Q?quyPAIEzZx1Yqx9VQAKNcdDHhtuP+HgfjniH2SaqOcVVdWAIARBvs66BBgOz?=
 =?us-ascii?Q?borFNHCT6u4afTjSj9iswEM69I7aIwZ4LROH3DlI5LzcYN7i2ptOVf2rAoVS?=
 =?us-ascii?Q?shVZx/ei/eux8vtR6b+987X4d4OQFsghZz2yCi/Hx4xXxyacIN1rUNPgJTFM?=
 =?us-ascii?Q?rW+Qd9AyJDX0NJQa+n7vFehl8okDZ0H11odvyoMIq22plU+ChZay9g7XrttQ?=
 =?us-ascii?Q?zfq6QhDpTXeI2e8cooATTiUoDzi0Sv3YnYC4K5N60MBIT1HB0K/glVnNb6jJ?=
 =?us-ascii?Q?rPzYs2ViiLgSpMHctHKe9KF2NM7iSALQw9zwgwXJwlcNgPpQGMme/P5QSRL3?=
 =?us-ascii?Q?SKfD6lDqgZOgAsggyAmvxcIjyvCT0foKAT3FoUHUjjgVICJAftrY7KoNY4Nq?=
 =?us-ascii?Q?moM4CK53g/dMKLgzbaJGp2Hs4uATciy0fwkmRwIols5FKwnZ4b6fOTbWBbLn?=
 =?us-ascii?Q?LXREygvz/HIg/pGz5YzjAOhCm3FhOeltW/NEaabKlcmIA36S7tpOk8LM36O8?=
 =?us-ascii?Q?wwbZFEADZApllnerfg4gL6UwkRszb5YE7zTRPNZ7c/vgXVEppF6AenSat2Q4?=
 =?us-ascii?Q?ppkjalljWM09F4dpIdSwLgXG+eF/fiGPsPJEIhVmvZqfd8VxSIURPqWYF2TE?=
 =?us-ascii?Q?n3oF2tVdSK+iQa0H1rrbDuNnEBDRGzUq2yqE/KsMWTO/XgvpVRUYxmUZJBdJ?=
 =?us-ascii?Q?WFdXThzag7UeeG1m26e8lGLVr5yGh7BlwyHjVUTyX2EXjokKViSiptUlf/Zp?=
 =?us-ascii?Q?LUQ6FsRiQYV5V3g5RLwdqZ1ir9JErXZbL+QkopQ8uU+090ic1BX82kMx1VtX?=
 =?us-ascii?Q?AVfN8vfcy6A7V9tGDS8WKiNgbcd9BHCJqVZTm6eenVxR+QE5UftAf/UTBGP4?=
 =?us-ascii?Q?JtIgeJTZQBw8lXQRP2pmD0N1I8ctsfWL/6+aCoN2PNhewdtvLxge/I7Zjsaf?=
 =?us-ascii?Q?2mpe3AV/8iEhLBCLX/pVm4eZZtMayscGdIxKWWQ2bn6TEfTxLB07/npKZRFA?=
 =?us-ascii?Q?egSAD+M83H0sWKYOMlzJqR7fuxUY7krDjqXOWhQmd2PMs8HDNtc7A+taRQzq?=
 =?us-ascii?Q?ANQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uu6njKJIvZ1H1vSDG0DSxs+3o0SDl54Ycxuea84haZPyR2X4s4TxlZFoQRRY?=
 =?us-ascii?Q?40DjMHNMACn1FlbEDvb3AzutdR0RUvCmyaf/AEvH50hi7PuvBZAqNvWSikBi?=
 =?us-ascii?Q?WfDLWg3nsy/hm2Ba82OJNfRKD02+38BtBi6gHJbhc1UxtI8B7w+rh0I9YLg7?=
 =?us-ascii?Q?10+3UDJkzXuY8LzmgcyEUrkw6V+80cyfcTQmbzE9+77jJ0CE8wcqK5Q9xv17?=
 =?us-ascii?Q?MZqhA3ZKezGegMwSD4j2eXkydjHusr5hvHPeyQIdlcyxfCDT3aW29Z6gNcTK?=
 =?us-ascii?Q?TbqR9NLBRdPVTOHmzl6KTztkw7cIzjN2CMmiEZA+7sFX7Dzg66xVnEM3D8A7?=
 =?us-ascii?Q?3He7mxumMKIRrPRgGRGcJrCJymvb/ricxsSoUfvfJOp06wPFKr290pqs/R9O?=
 =?us-ascii?Q?SmzJDUyd3XLnR4e+o99mcc+JMRGhwQBzKBl1fUNqwPFsh5gi0JOydhFG4q5u?=
 =?us-ascii?Q?LZhb7pr0WmFKDjSy7EaH6Mfx2hFVaQsiCZYAYawtRKmsRZS/1wh/VfyHrPXE?=
 =?us-ascii?Q?Vl3gddRUFy5tG8zRLhE2b7fG8Y4aJkwiDlj8/E0WZs/EdlCgYx7BcI0Abe9c?=
 =?us-ascii?Q?glJA5muVaZmIhVLgPjqgSf2u3NdSc8DYZm/X0Iv7x4BkFqm1H6iVtzxKGxSU?=
 =?us-ascii?Q?ScwJsM93Q3kIPJOEGXPgU7dKwgqci1Ne9Y4ThrXi4F24UbpCYdfM00YwogDs?=
 =?us-ascii?Q?xy3x2Cl+PzbBfD4P72h+I00YwxRFuYNbXH61GvwOzs6gmH/Xj7RvRxzPlema?=
 =?us-ascii?Q?ZHQGMU66iYsDdZRRrPNtsd5J0TZxUHwECFHEI9oZBKEIDttG3UFZCgLRAgEV?=
 =?us-ascii?Q?Advdpuvc7Xw+RcH8uEyxrMNN8VotXxjB1hM2RcYktBU+vA65GSUDTiXg+nZh?=
 =?us-ascii?Q?cMQCkpvDjiV3d7Wa2w2KnuI1aRq/HVHc5ikqq+jzlTH/AkxVLavY9jEbGs1L?=
 =?us-ascii?Q?3T6ete+ldO0tnyUo6e1LzLdiaaCgiFGymn2SqPRuv8H2hFNSNaz1zJZLM65q?=
 =?us-ascii?Q?l2LZfociVq+omwRzSzwGhbaGUIh9EFYAWU9QU9wiSq0uVQdZhq4v3cWoH81+?=
 =?us-ascii?Q?H5CvkbCh9U3+6Sin2Gfb1vv5uJ7a9KOyVDNMZtX5djvyKpizRYHJaioTnfNe?=
 =?us-ascii?Q?CSk2lxNDHaOb5ifSLZJVyjzJJZFXjxT+YbylmHYnQy+kh2UQi0iQBke9FSjR?=
 =?us-ascii?Q?HKytP+A+rVrAFQq4bcxf9yQnDKRWxe8JQsbVst6spDFwQ/LSNhnf4psTZbbn?=
 =?us-ascii?Q?rAT11cYlTHuZOxl9pQYQKxIUfysMDBzKSSn4NFzuU7kYSxRe1sOWlZ3VFYHo?=
 =?us-ascii?Q?lJo55be6sdG3w7rwev0AuacFKWOmj/1OsDATxoqWmbSX4bkvPcnmfgp/JLIV?=
 =?us-ascii?Q?trz0M/dAM/QbG/6X1gPiOHDF/xum1HoDrG2VR+7HdawPZwUnkJoroJ8Y1uVO?=
 =?us-ascii?Q?8XZGs7qPpwRVYeM1H+kLWaCTdzzen0ouvJvormTTA1NoBMkwbu5pxF+CrImn?=
 =?us-ascii?Q?T77vS0XFykZpldMX/uiSDK/U51tdFl7UsHQFfChVcw9VV1gDSrC5xfXmmBEC?=
 =?us-ascii?Q?PB2651ZaSQHq1+EatLUfg7ckgxNYG+HDyDgbogbOH4h8AYXzgD+aNUXEjGY+?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kldapGGOPAxKvMxgEugL/XOnJ7JX9iIgkqFMiprKfkcY5LfY+WLBPPRQeuqJ8ZJS3wU5DZqSSyw2ILnxDsDAVZUtX/n/CXL2Z5xmRQazwn5jVdoNLjULyZkJzFJmHcjG7os4OQV3YMLQePkS3hYwp6CmGTVqe6bWWwa8V+oTV5kuwBFrP8bdL617lLEH0bE0qk1e0ebYSs1tN8I5r4eNqsvXPD+AgH8IvrhrqkjDNER5wVfHmS9l0/WCM4gOqPw8GF9FPLIqcJU7IYi2cz1rPO6IKztgYLVJX0VTkT4+cJT5MhNxb0fpXt5mHUNpYrpcvDmCXsypXSBxDOSFL/0J7INGFxy3h6VCILMUJ1hMeG5iCYFMt9XNkR7JsY5gZFd+iiba74Uh8K4eqzR4b1g8b9zrVoPSfCl30EWwULQyAzcfWH+OS2Q5vw4pn2DSndT9dWQwPiZUvntvlRKejX+enf4vGkWEFEzb2zuA3cuBe7bQ6cH8VfWDWo8fJHWuSqsKaOx3U2tLL2EAlSxdWnJtlA1ul5RLJK0CYvVDrzbBEUCHRrKVBPInt8Xa6+YATKTiClC80N1LmpXoyiAW32WOPRTsSeuOy4CmsAdc2s33xBg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d8a859-24cc-46f7-d420-08dd024316f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:12.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MP4Y/LwL1VpE4BwlLaLaKBWNWyfQXKyK3NRMsO9iwpDTdt768y9bm3ghyY4D4bLN3CVn7nixyokoKopGCP+IuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411110095
X-Proofpoint-ORIG-GUID: u8JyW6NxuSyzZBVfSduRGHxWlGz04SZC
X-Proofpoint-GUID: u8JyW6NxuSyzZBVfSduRGHxWlGz04SZC

bio_split() may error, so check this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index d813d799cee7..4cbccdbba638 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -107,17 +107,18 @@ static unsigned int bio_allowed_max_sectors(const struct queue_limits *lim)
 
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
-	if (unlikely(split_sectors < 0)) {
-		bio->bi_status = errno_to_blk_status(split_sectors);
-		bio_endio(bio);
-		return NULL;
-	}
+	if (unlikely(split_sectors < 0))
+		goto error;
 
 	if (split_sectors) {
 		struct bio *split;
 
 		split = bio_split(bio, split_sectors, GFP_NOIO,
 				&bio->bi_bdev->bd_disk->bio_split);
+		if (IS_ERR(split)) {
+			split_sectors = PTR_ERR(split);
+			goto error;
+		}
 		split->bi_opf |= REQ_NOMERGE;
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
@@ -128,6 +129,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 	}
 
 	return bio;
+error:
+	bio->bi_status = errno_to_blk_status(split_sectors);
+	bio_endio(bio);
+	return NULL;
 }
 
 struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
-- 
2.31.1

