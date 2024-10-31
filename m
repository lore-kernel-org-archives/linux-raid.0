Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51966198E65;
	Thu, 31 Oct 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368795; cv=fail; b=Rtl1M8sK750GQbQhcOpSc+aL1KUdQgeutiMVOyTVUMA6DrjiRfrPwkYz58glOQbnKjrt+67ET9aigG4Z19odnkulUDzGawivBCUl/m7/8e+H6N3e8da5BgSC9Ipkl7UWU3o05ctuIQKgRs/ZWUiGQlaDhdyrCMYiB9imeJILNmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368795; c=relaxed/simple;
	bh=bVFgN+Nx0yow5WSnyzUjLTqB7/9BGHm247QIroS0xbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KrXftKO4t4P6ID28gOQeWIwrDdAWSjXeG99voVA4U3lkE0XOEW6LF9p7Z610aqbklop+G9HcfUsOdL6E2ALRoQk+YDeK87QFOi3qXQPzcdGEgoFiJa3txd7t5QSkaTHqxYiZaHDUen1dZ9TJf/8DcHwOT5uZyskvrh2w8v/gYOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gO6WIn8a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fu29Wsnt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gO6WIn8a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fu29Wsnt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8tXd5023675;
	Thu, 31 Oct 2024 09:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=42s53HmVDS8VAifHu8BZCjh+QcI4tyInVm3M2lBnnCo=; b=
	gO6WIn8autgp8JZMFvqtoQd4spAby4AkGvoL8ta3ps5FdXR79E+0zPnt/MP+Ysil
	vf8PhjUDrTlqDbxM98oRgOCplJZx8bYb7htWjONxeeR/twXCFOkPaHWZ2Qd13+o8
	qsrgklwnMUTM7Bgvc9CaZd4yOChf6oNxKwJIccIQA5GaphQL0Z4lsq4kXRzdjYnC
	gT3264cuiPtFgQ6rNm/BR2UGMt5Ew2O4VfH9nMm4rjBsTGc5bcILTyn2FgogCFJz
	2H4paWtHO4TksFlaYiE+Y+eIwFny8icIAr/52mknznzdsXGGPbxTqb8kCVy0XQoB
	G5oMEpDhbuQMQakOBuXigw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmj0t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V7XVSN011848;
	Thu, 31 Oct 2024 09:59:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnaf5vwp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWGO9p7+GI7xriA0WjvkH12GLjrkmnhyHEZaAWDiVv1T+wcQ5zyvSX4YV3lbyMVTqw51ldn3o/axg89/egi3e4mN7Zgi9/FFTn0G3PqrnIOVB82HpJOJ/dOtUE+ztPJUYK2Jl3hD6KeMVB+dt12KfOi5i9kxC16zpPzTlejkhsm7UFkB6i70+V6/y4CaLYXt9QfMj0Bn4SBPB8VevXJZ1FabYLrx2/BIJFIwhpXV0ebV/0wRqDM+/k4iZWUsfAl2j4NykElkh3uCCdkutDNnrJJTe7E3pgixWeCr/4Z20hk6NCig8Nw6wiO0grHdR9tjCP70jZxBLCHy2jfOH9PT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42s53HmVDS8VAifHu8BZCjh+QcI4tyInVm3M2lBnnCo=;
 b=sxAxzkZ2g5LwkVNLLTERHT1tPImUCHddmlUaT952w5kzN8iArQAeS26eenLOKLT835gROrpa3QkJYgixLZdTooVWzD+UjIEoQK2zlSxJeOGs5u2zy/fYvx1r2fccPUt9lf+s7Ce8PPz2umhhQHU7Wt9G+g3JnDlZ0pSwlAfDGqOhv/Xhxhl/WyuDS5gAfPWFslZZRpS49VOKg3lDtZbiYMULxQ+Yn0YihNkwb3QFpwItfOJZiSwcnnH8YNkEj878RyFhAnqsYFuuRNEURqeMz+jLB65jNYYf3Q1rngzW/GpGFA/eKfhXXmD8HgsHiY8ynrtVojCA2u9fmyIa1jAmVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42s53HmVDS8VAifHu8BZCjh+QcI4tyInVm3M2lBnnCo=;
 b=fu29WsntEWUat+eVB5b7PkdZ3iVco3Ho/qbRStMiMzZRCU5Y2JC/2q7P4t/ymytmBTMYrTtfYQA7jSPl6My4E8UH6ZtrJhXHbExbeTLAe0VRSxI+RPnqTSAEFQlTz2QRpKUuw2jjWNSmqLQlEn82OJQ5o4jscHMwEZ7ynSB/X3s=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 09:59:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 5/6] md/raid1: Handle bio_split() errors
Date: Thu, 31 Oct 2024 09:59:17 +0000
Message-Id: <20241031095918.99964-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:52c::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: b91b2115-e8c4-48b8-5ca8-08dcf992b8ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a+zqSv5mEILDM46nUE+IfJOQWaRvuQfRipyi6Ppthi/svqRFhzUOFayI+t3X?=
 =?us-ascii?Q?yC2iT8Qx6EGh/S87abtrDbE9MO1sTBLN1dL39KPKwA8TKGI7kcc4YDzcb68t?=
 =?us-ascii?Q?2Hnm2OoRs45j4AKEPD16sm20qs3oqMwnTzkXQ/FTXB3sOrIj8Sg1gaNGSJLM?=
 =?us-ascii?Q?mYyBuZzxAab2wfR80uHTGW/f1KwanysanwMJiD0cOaIio2a4O5x418kMX+3Q?=
 =?us-ascii?Q?27+0EJE1KLpCpfHVixBNexAjfEgOuQS3WcbCFKWDbgyoeWzACIbpuwcGohAx?=
 =?us-ascii?Q?PKAhv+EvY7j5bVeQGjF4x9sDovAeUi8qK0Nb2O+fv1NeiefaSdFo9z/TtGK7?=
 =?us-ascii?Q?lvlcV/jk2klQEmCFgvRt7l01U83r+8wZbMkoS5jSK3YTWFnhiDsdYz5FmBke?=
 =?us-ascii?Q?46EUM3Ddsri6ia+0vHRY5sq6MlxD2Lz6B0QsqqFhGa2HEoaHshcgRtoRTx+V?=
 =?us-ascii?Q?ZxaChd2j8XB6d6KwZQkx617FMZPa8agY5dj5OWwogJFMwPtEo5geGNJ7nOu9?=
 =?us-ascii?Q?0iZfzuz74eYC0OscLu4LO/X7R5Yql4gAigJB/mwX66xjL9GBf1r0pjFslgJl?=
 =?us-ascii?Q?aw/DjM/hmVR51LnGKXXGlTqJJYMzQNPfevp2T9goIsyVeEvW4gk6caGRf8DJ?=
 =?us-ascii?Q?kLBqSIZir/98TwZTh9QR6XzoNV26vsLCprTKmPPldtn/mwQ26QhXiMR3OE8i?=
 =?us-ascii?Q?lZTbz68Sx8ashxphdRhVpuM9sdXgMYjwfopaauFm7MDv/Oq/ZQmm3FsawPEN?=
 =?us-ascii?Q?xA/74tmRLwSFel9BoIhI3R0Eqjdh2Gt8ogVK0kQUQr3m26ZFhjsaTVBfkCh1?=
 =?us-ascii?Q?rvp/3x+0KZoo50dzjcBVQgGPYSdN0hkRDaNKTE9fEJZAHl8gDGosKS1SxkuC?=
 =?us-ascii?Q?40XKYQd82E/DpeQ6Zh1RPheTT0p+UA2htWm0CFFSN+sk/nHBIact1Lg+mYNK?=
 =?us-ascii?Q?B4OQiNYnr/ZL75tgSEb1DGxobplsb5pxHH1OSP6qU88PxAsufzVPtZLBkQK8?=
 =?us-ascii?Q?DvU6b71ttn7aKnbDeBdIb/6mDxbFSGxsIpVMPGcJiAtGfwEXYIdKpm+uZl2A?=
 =?us-ascii?Q?yBkc49zA2d1k8FKIQaMAxFv2SPN2WthLFYaB4A1L955VUi3CUlme4iF1T5a3?=
 =?us-ascii?Q?XXK+aGu1TQqNd2bstsXeP+1LzH5zCQszdbWhd6zrP/wg/ZB29kCrJTVLzgva?=
 =?us-ascii?Q?e8qLJpJdsjvRg43bO3A3UnaeqNpqpc48K3XW8lsXmrNExSebGvtUd53511gB?=
 =?us-ascii?Q?riXwi95gtAaVNNh10u/M9HzQ25eCyRt7FaCuPZHxeo0U7i3NQsMJYHgFGR83?=
 =?us-ascii?Q?mPtmMIHcschG7iEFZgOMWMIS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RYKHBJoT7b7Kv4kbjlErWYk1czg9vtiCHNM+eFlz18ZXG848RpCz6/Tm835U?=
 =?us-ascii?Q?bNPZBk5twXLl9msTfM4BPClZcGS5ctL8uKK9jbdkH34/QbsBlHoFnO6nCbbA?=
 =?us-ascii?Q?K9WTIYOfnI5d3JQLjlj3yuJh8gF0pdVdS0cOVZNdN5awA1n5UZYxFQlujzzO?=
 =?us-ascii?Q?emkwPMdcaYwAUzAkitgUnkfvK2WNT/VjLV+yf9bA9SzIVyLjpU5YQy3nQzh6?=
 =?us-ascii?Q?4m+5rqZGioaO2GklLNCUu34j/UhKIEBmiGxbr6IDkb05E5VcFJHjW7iYL1gg?=
 =?us-ascii?Q?ILwXXviPCBRyF+WiWWcEvTImR3LTOihElk9HhScMWlEJuCKpnaprsEzeb5m8?=
 =?us-ascii?Q?7Ym/o2yjyOHxw0Meu1rj5TLiJXuSIQee8pI/VYn/bvSrlIJ3dh9EIQrfN0SZ?=
 =?us-ascii?Q?PmgMLb3+esjkrU4jQTVfh15gtJHOWsFzqSTQB0Pbgr6/YvEYi7DtLjFy0W/b?=
 =?us-ascii?Q?h0R6VzyDnvqIZW9FKvGm5DjI3ZgGiPRcvEqqZgXOg0wNKGzS5gC7rvakzDfM?=
 =?us-ascii?Q?1ZQMYBmytahvS6XgiqxntMwbJ75tPbqy8g/4w9mowWAJDbb7da52vPtDCufS?=
 =?us-ascii?Q?t3ugSIRU+CCJbCX38ZPUMjMoU0ldVVIuaTQwJDLbIwSBf4izrDSLKe4AdBTL?=
 =?us-ascii?Q?Oca3ruBmur27NFR6hGrnHDrkP2uWjEwrFxTTZZZ/fJn87uyMqvbt9rlvzVto?=
 =?us-ascii?Q?60907U+3XxCdbrdjMHJDcEA+2pwd5AQbiXNx+olVzUajOZ6rhnq2CYaPdbfM?=
 =?us-ascii?Q?YHprhvv4Zw0R3odBJQ2p5AGjbuI7PqWX55eKBleHqtUV3EYtEuaRGLoLjCGH?=
 =?us-ascii?Q?OA7v9HpIa4Sosev2r+MCIqGD9ZGLjxsyzOEUFLghc0ldCRqWHYq0ydvWRb0M?=
 =?us-ascii?Q?iEb6D+P7klFx7p9cekHbaaufQvkZDlebGGm2GK7XlXVT44R8Dgf+H9c9aIdl?=
 =?us-ascii?Q?SHq1/TOgK6kBLdnS7v/H94DrcL1D/fcFQkLeTZobgroDr59q5OCeaN2mtD8B?=
 =?us-ascii?Q?OBXHyaGwy01fwfj55uZtXVejBYOPVatx8sLPY+PdxooSutD/r0WprP39nkZB?=
 =?us-ascii?Q?hEhaiahkgW6uyUzmcNiZPHTAL+Vp0DbGlSNvDnLQ/UMc9+GIyHGNQMGiaNoH?=
 =?us-ascii?Q?7VHAqshlf4QlQNNWyD7rlAs6r3zG8JwGRqziybt5m9j5MeR7DvZXw3UblDxG?=
 =?us-ascii?Q?NPH1Fwcd86Iswp95IiZfzXcDnZJtoB50bsZRMSFcupfIxTTHGodnm1hnuHrg?=
 =?us-ascii?Q?f62waFLBgK7RHk9T7nTqKf6n0gx+3P1m9cOMHzXwpCibHLG693ngPfy726GA?=
 =?us-ascii?Q?EBrp1JPIBx6TCjZhp38gqAaMV5hXMmQIDfIldIXD09Vu1gefIdt8ZVMkMclJ?=
 =?us-ascii?Q?GgthipPNs01GntUJar8kcEuPWcZOcFvgIJZoRUeqGJVJdKYw1pkpdh/30vhQ?=
 =?us-ascii?Q?CQBP+nrLQHg6IYQVuzq1CAILe0mhK0UyGRa6gdUpevFhzfUQYQvGUmbI9pMU?=
 =?us-ascii?Q?OE35HRZfYawjtnYAXHNTj2rBzG/Vngn2bvcIpALL+Z1KJA8qLtA3DOSznXZE?=
 =?us-ascii?Q?KtaILLHuANMVixIsgTXHubBm4nIwHyQArogJo8jsx6HylZt2zZBGEuGgVXNv?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ire01YzlMae56WkLKhiqVj/K5s2bhatk8TSky45TBKQH82cIlE8QXDb+jbMxs9j+GU5nPyrJiwdPpHd5EYlVoZMPMM43p/RhFmp528kpunME4bk6jAR/xWXLaJUj38HEI30W5T6amEOO88jFGiXuqgDWuImr4/YA13t9NfgeUmZ5Oo517XlcYETHZ1Me1Gciud0BjmgSKOM6hbrFbg9NvdyFa+tgtcBEgUowCyDFhV+fCuNmBec895+j/9Ha97hv14sH+AcE7tQfMO7VLPP9b+OUx4YGZjYJOMFDmawfMaW4HWrNufhkh8YzYWC+CkiZ/4Ed/SOgou49J+7C/BbNPLRR3lfcJx5NuA2bUYJ2SFvAi3qASIuuTjHgrKXVen4eRORJKI1EYlrlZrQzbRyoplHAdnToWzasJ5ySfMgpV2IUZATfp48ESF+sw84g/vW+tlLnE5U6f+NIoHblYwdgE22IVMaM3ZG8XHikyYkFYQL8FvrE1iTohFJk6Oc2hV84+NScufHYrX6A1LjgIOMuB4GNOyj63UBFD2foRWm2lz4OHaOa5f3Of30NT1MkTqTLpUlIdL7XYWINMcGzeTBPRmGXpJ3oorEAHWML6tFxoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b91b2115-e8c4-48b8-5ca8-08dcf992b8ec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:34.4036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iaw063zT8n8xdZ6AGxX4D3dnS56foUlvW+yXrnsBYH2XIstzN5fyu4d6vfK+boCDzNhj030bIZBVt9k3FUJQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-GUID: 8WZ8D8EEhSuq5jHrLdccFbTF16Ni1rxL
X-Proofpoint-ORIG-GUID: 8WZ8D8EEhSuq5jHrLdccFbTF16Ni1rxL

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return.

For the case of an in the write path, we need to undo the increment in
the rdev pending count and NULLify the r1_bio->bios[] pointers.

For read path failure, we need to undo rdev pending count increment from
the earlier read_balance() call.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6c9d24203f39..7e023e9303c8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
-	int rdisk;
+	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
 
 	/*
@@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1410,6 +1415,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r1_bio;
 	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
 	submit_bio_noacct(read_bio);
+	return;
+
+err_handle:
+	atomic_dec(&mirror->rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
@@ -1417,7 +1429,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
-	int i, disks;
+	int i, disks, k, error;
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int first_clone;
@@ -1576,6 +1588,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1660,6 +1677,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+	return;
+err_handle:
+	for (k = 0; k < i; k++) {
+		if (r1_bio->bios[k]) {
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+			r1_bio->bios[k] = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
-- 
2.31.1

