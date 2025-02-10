Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869DB26462C
	for <linux-raid@vger.kernel.org>; Mon, 10 Feb 2025 21:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739222563; cv=fail; b=PNk6KPyBC9DRV2ZDnpE3MNeWsBQziTvxtHayqJeP9Aa8WJk4Wy+7n2hHdRqd9j6wiYG1EXkffiHfOgyRAy+s7NupGwpike0A49GeO7V0CAS1/dfaOcuFy+vMeaR2haQCaEzpZqATMY6FNu4JeH8HOHk4GXHHVHuI6qIBy3tKiVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739222563; c=relaxed/simple;
	bh=hlF7AeVgtHzCSZbt5cK5/bq9ul/nRvD2DG7ibsfZqfk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cDt8PB2iHXq1TyQ8g6FQH3n6vLGPIrq2YuQ4XVzV/lWt/YF7iATi5GL6DphICMCMfkuao3Zxr3IXnoPEJtUbOEXgNl5Xi11UDZDQL5qTorCl1qTtm1JjhYKcE0DWJ5927exNoKwVhlAfy2CBIqR4GGoJ3bIgKUHAVe10UfNwq/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IP8nzEdX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=toP2eMU9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IP8nzEdX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="toP2eMU9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51AKMgTn008468;
	Mon, 10 Feb 2025 21:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=xVGVbHt/aHmf9y3t
	McA03CjBnaO9c2rnaXlq7jzB9aA=; b=IP8nzEdXaEs1eQskblgqMBy9r8FXUFYL
	j5ekpuZMrd65LT/a/asPypLlYyOU/GG2NLiWeX2yUrLTWBxDAOU85wBdxGMwTt0+
	2/TnMVihN3/xzmntIdPIp4Bncdy9KY5BcdcYXr6kUH3MV2R88CU5bjQzjnxwT5vL
	DY0B1f4R2CC3RurAyX94CLwDUfVF+oQ3nOkNljaQ2rBGpN4FTp0HK5RDZMWDZj8s
	2PgHLS2PfCvSbjTT1swSE8AKpsC1MB/j5KwJcQnrhYMN1Lvxy94oMvce3sXAC//3
	cpPc6cEDzeMEvm25m25S81juA1sCYPTrNORc9LW4VNS8lZz0CWk4Ig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq42wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 21:22:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51AK1N4Z027000;
	Mon, 10 Feb 2025 21:22:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq7xv3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 21:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQDPHXAt7jOA9SLybqrgCDF2iiM9+NyWxOUhhyKgqJT4jfqzVg/ubojwPZ94IqLbPy51g5dNp1NH/lbti24tH6oB9dDPOY6HRoMaOro+1qoyJz4q9Du1DWYcX5hiOAPu2yHzbrx+3w4xnMJpmNUP4Se2DP3IDCOak8pLaDqdlHsmG7M/xjFM4IssQynUvWFdWw087G9qZsCoMGWJ/odbYnIdpHztCm2mBbP3G3J2pd8DmCumFSwszV7BL0uYeVabwt1pNyzSPCEfRC155GRe8rPOs2uj7KVqQx7OcgpGRNwy0cDdIZ7a83YGV+mkDf+OfaCzOTrQcuOg31IJCKFQBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVGVbHt/aHmf9y3tMcA03CjBnaO9c2rnaXlq7jzB9aA=;
 b=jnYE8RlKZdpbXYwiUmg8O7BK2U27OMogRYVxNQyOHR0niZw7ARZq9cPHtjkBHRW8oRaWnsDHytYOEo85PXMZx2hJSsfOlogxYjQn5pBU9dmEZJ9Gi7bm9mMkw5NGk44dslsM12EWxxNW2V0kYtVguEX5U3dI/mmXHZ4hmfAdW7TZxe4nBv/+BzN20iFuNH355Rz217pNXdj2vPD4DCaY58PEJ6Q4t/FnV6/IzIPlZL8TolgF+TT1JN3CjlCoheD+zjL+D1P5K7b0b0JIbAXmJJdAzV+DIKX6YdiA889u+Q7NXZujpGRdpY6mJf1u5pV1VhU6USFjZz0xOUG5vOtHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVGVbHt/aHmf9y3tMcA03CjBnaO9c2rnaXlq7jzB9aA=;
 b=toP2eMU9h/4q0gwKfk/QeFFRLbSU4/Qtz3PdfbbG5BS67D88unq9YhWgi3e8cElL1om6wCjvec6B8afEkqIRbq+kLVUWrMqPvZxNS/7guxUcxeAEgX6XtiGBIDOtzdIOJbcmNX01oBVUO4+6x8On+1q3yE5HlgPrPm9Fy1AnWwA=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by BN0PR10MB4997.namprd10.prod.outlook.com (2603:10b6:408:12b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Mon, 10 Feb
 2025 21:22:28 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127%4]) with mapi id 15.20.8422.009; Mon, 10 Feb 2025
 21:22:28 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: linux-raid@vger.kernel.org
Cc: blazej.kucman@linux.intel.com, mateusz.kusiak@intel.com,
        mtkaczyk@kernel.org, ncroxon@redhat.com, song@kernel.org,
        xni@redhat.com, yukuai@kernel.org
Subject: [PATCH] mdmon: imsm: fix metadata corruption when managing new array
Date: Mon, 10 Feb 2025 13:22:25 -0800
Message-Id: <20250210212225.10633-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:254::32) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|BN0PR10MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c5fc110-6be8-48b1-6a56-08dd4a19056d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XGnglftEqe5avUZDIv6FNvQbj4yZcuscjqfU437fmMjelSNXwpCTf0xT1wP1?=
 =?us-ascii?Q?QCqVDdGJhXYaT+jcS4eVYKnX9xLRhHzZMq+CdSJHm6ojkoOIjZLBRKQycRJd?=
 =?us-ascii?Q?ySJOeEPdngrYj+pm/2NQ7LC/Zff78xKgnS+U6z/fOotEk59lhtSl6dtl9+oQ?=
 =?us-ascii?Q?j5kcRLye7DJ5GrvygmfMGBug3XaPecfoExhubAIB6pBnWInRx5svyBqhFibI?=
 =?us-ascii?Q?MjBOHtjvZB/4COC0SjtKIRZdiOEtXI7GEkZBoUdbNzx052Vz2fwlR3Uak8FU?=
 =?us-ascii?Q?bhliizO7C/w0LzXHIn/7yVZ21ONfjKn93TVIsSOejyQ93ZGnui2cJ8mhSoWp?=
 =?us-ascii?Q?BQUYSCI69ujkm0SKBsNKl/ITJ82zz0WsD3+WgGevmEqCT5qeP3fhGAMjOpkx?=
 =?us-ascii?Q?uEwH6cO3rfdwm6B9aZNcOSB53Udiqrytu3p0VPi0Pu6loRsLCHc4TDgpBL/a?=
 =?us-ascii?Q?ER70ZWumgUdaOV+sDHXngJkmLmfKuKG3HfjrBK3fEIre0TMD5KWrTJOEReyV?=
 =?us-ascii?Q?1SaGAp5Tzc7ruz00lrE1GqllacswryotFSiWsaU/92TZXuxs816+PpAV134D?=
 =?us-ascii?Q?WxLviBat1M+0bRtMzTwowLldVo6qLrSn9C3g7wbnlofO7C1DM6ruysVUn52o?=
 =?us-ascii?Q?mLtEyxKgQvboQ4MLocHlVX11xB8TWwfQJoIgav3mc7+BqgIDNCvDfnJp6l+M?=
 =?us-ascii?Q?asLjLkBDU6njb26xfWSCj0bXuLxkXvlxq+nms6X4JwvLrkLlMYWLPlq81xOe?=
 =?us-ascii?Q?tjdGnG5G6b0/bpYXAVTCX9fiS7EGT6StVNHVqRkz82o8fhbPdJKSrl1b2EWH?=
 =?us-ascii?Q?eqka2v+ASN8SVM/LoIwpDLSbis+8B33rJflu1BiWvdPx7s7Oi1CsWz01Gkg0?=
 =?us-ascii?Q?ZCJOsLOjS9vshXXT6SXMCv0E3GTD0ZEYu5D/lWboRfh97AZya1Of0NEu01z1?=
 =?us-ascii?Q?W1FoSMx/ow6Hr3VF0kBDyxSTPwnZ/2GvXJM7UGoQHxOZg0OZ9nEl4m0vWHdm?=
 =?us-ascii?Q?fuoGSBtzR15lzbW1FFnLzzJ8jsIwQW8AqAjPYKvofyuQ48Dh53A4pbD+cwYJ?=
 =?us-ascii?Q?ZbUdRo7XaAqEN+CmZDZXuzdL0DKFCNVSwF8mtEaH6oOkhVfzODimzT1TG5q7?=
 =?us-ascii?Q?ObJUSuHLHCWVz7vPkjHOgeF3BjkD+klKCpMR+knd9Y2Qlf7OlYSQttyall8g?=
 =?us-ascii?Q?yCwESuqzGsrpGU9mOCmmjXqCV8lZUq8NLDViegDWiTtk4lVA+xoc2f8BYd38?=
 =?us-ascii?Q?Ff1atznMT0iF0F9kfrmpowww+h/0f+8R0r3IZWjVbVltWo/weXrqe5/QcLy9?=
 =?us-ascii?Q?RgBHGY7f9MJP0uaJHiKGwtuGKjaePBgk5U3HSGnTkGyjQaAsc6mGVg97iKQc?=
 =?us-ascii?Q?1S1McbubsYgbGVlkwyuoet8ZPCPp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H+vQzQwVb80Vx0KzwrCR6CYRFyQxCNunb67HomH1lJWra2WnVre0jt9B4Nqm?=
 =?us-ascii?Q?Zwr5QN7Pb8B3AqIwb9SQTo64RmMcpzY4B2x90W9sqaaL32hgiCINeV7/Arob?=
 =?us-ascii?Q?zSDuCu32D2/ZxtdWmg0zVcGNZ5Rv8U+yNx5OaGYoHWRzvp5ZxRi/ZXTwxqwJ?=
 =?us-ascii?Q?7xIdBlrMoHifr6f0uywkfMDYo3p0SQ7RffUypaR0510wasUIZBamSiq4PcvM?=
 =?us-ascii?Q?CqPqdoE/Nvcfn8Pfx6bHVSzAwy66HlM3W6XIu/urMEowx1yo0WFGpEbygSgO?=
 =?us-ascii?Q?pC02kLAR4PtR4X/BHcnYuQLOHxs1rGHHW/SPiia+2RotkN62FcVqbPLSzFPE?=
 =?us-ascii?Q?f1EY7hGA4onj3ZsGdWE9mfPu2D1XgT4sOPprrVJFYyYCTiZ0EXN1ZOGYU5xT?=
 =?us-ascii?Q?F4i0r6luZ5CS75KPFh3B5ZvpVJRfqvrul4Jkxo+RbXBQy+eKkTC9ft4JXPf7?=
 =?us-ascii?Q?/y0XWn52EBTr2/KQK9MsciiShsdvPOBR42EyAEUzFM1FduECjYI9Kq1RnZbO?=
 =?us-ascii?Q?DnRWECajsza5ZjjLHu53lIasgk1A5Alf91xzNmbAj7jgSTg7aYuV3shx1KQJ?=
 =?us-ascii?Q?lxr+RP3dnoTz33uoLwWltvZYjZYjdY5iahVYZ9ShWcd1Qrs9i1PdBwzzxcEg?=
 =?us-ascii?Q?3drV2UhGlS/fk8paPIv5TYaV1giYcjLcJpICpnhhI4vYYwqUQJjW2ISgjIwH?=
 =?us-ascii?Q?CxGvHvkfNXPaFspjp65K71/1o52fuGka1s3cnG8++oxEoJizMN0MtRSfPnrg?=
 =?us-ascii?Q?vD4AkmyfROcRvKcI28dxt8Lr8L8KX9/O2grLm1XKg9nks2+Cx+jB3kFCWsNL?=
 =?us-ascii?Q?8DvPgq6CNBrgNjMMxWvrsc/3pydapTC4AicTZDb9Ti/yyoM4HqaKzYdx+pfI?=
 =?us-ascii?Q?ET1zcb5tUZYjMHmlCBoKuL8rEamZL/dPjg5yMmWMwoXq/uXDAF1o1etoIiyN?=
 =?us-ascii?Q?w5TMQzE1eBDq/fZCUNulm0/+cr8E1CXAJSMweZkl9bO571xqrJD0UWSYYlh5?=
 =?us-ascii?Q?1xmYDq9S83soIoklQtOX7X7bcO0gSZZIMtth+5FTupEMgL6jGDFVLPtsnexp?=
 =?us-ascii?Q?OtTqaQ9EoSNGiZQ7ZTb2Y3QUvaFcXptkqu437H8PItA7loVCN++A8OxTkNZ6?=
 =?us-ascii?Q?dV5+UxJiWpy6FGvUDVDnkg02LrvFZ9PodLIO9/Z+Z7ohCN7UAfuRVojq+EV6?=
 =?us-ascii?Q?lq2+Z2zlw4Ur5Aou8zvoLVE0X1M3iLQxD0zBobfkD6VzAmSu8D1hT2qUf6TA?=
 =?us-ascii?Q?KOo1+KRQ7BIZ1vkHEpbDNnY7YraNYuCnBg4aa73qBH3tpcMfA5+mVxLcZezg?=
 =?us-ascii?Q?P+ApzW0cK2lW53C9YN5z6QW39yOU2mSSEyzo00iH6QQsUM3NQYMT/OjjT+l2?=
 =?us-ascii?Q?pyaYmq0PGP5HTQGtmOQjcVnI9Wlwf8UHPNsSwfoT54uLuZUHT3PjZ4eGEuhw?=
 =?us-ascii?Q?bkTNzFLx+KKUJRPQIJxa2B2mm94mC5ZnFUAtmjCV8zTaZ9YxEa5d6wOoJ3BT?=
 =?us-ascii?Q?YODvNoOyyWX8tr0Tu14OHV9tJzEKVp8h6qE8wWwKnwuUHCR/KvmgXVbiG5NH?=
 =?us-ascii?Q?eZLExIBTKaUte/yDiryAvttIgGrpkYQBs99xW8Fv9vul5oMTjde1735JOKLb?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eu44OqR6Px5kgXWdUbTj8Kp367cSgEbqZwCnqVb4Vm2YimF5T+juFk0dYKWQFUmdX05PXeK/bEzow/h5g1rhMQESJ0mHzHQqSx1GYhuzfCFuEaZpoQgR6baIdA02orHgKHgvfbksUCipsh++N7jughgv0hl6jRpUOToytzdZRU37G2xw1gpP2rSfSZYO1gJVCOOfYV937qWI3EJb+ufhN/gi17/aO3XwRViGGaOiaT3br1F66CtR2vdYN34X5QFFlJhr2gtNsPkNvW/NWIFY3jtccOMgg8upER2kxelYZZscZ0pcb7AmSwSy0wgVSIqfIJmdu0vckBy5MWP1oAsBm5w7iazwVCcqOeJkakgc2yW5Lik15ZyC1kv4roIGELvpwoPkvIjuEfb9z2TPbfKYey7Dia5Y1bWzLb7ZGPLHc4Mx+kUy5uDaFZaJM3GWIs5FsVlrlOPhNIcJSlCPB0GNlP1tQgCNiCP14eEKEQc7foUjs0h+YAPD5F5RRiinwhLd23ITPRlvLPU3ngFCjuIGcdJlklrsB947TAukh+Rq10WquM7GaD1l+1bg84y7zQCX/gdpyh4sbEH1ZgxLYB5jjpUPIswdbKtkcudi2DSKXMs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5fc110-6be8-48b1-6a56-08dd4a19056d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 21:22:28.5391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INaCCBiB0g6Trs4F3MC1Vf6NMg/Znjyys7VRSCdi/xxXzOoKqRL/6Y02TAZmnssi3Q5RkjD7lsmc477hGy4pOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4997
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_11,2025-02-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100169
X-Proofpoint-ORIG-GUID: 4tfwRzFcD94Bc8lALdxDvSC31qQHlp4F
X-Proofpoint-GUID: 4tfwRzFcD94Bc8lALdxDvSC31qQHlp4F

When manager thread detects new array, it will invoke manage_new().
For imsm array, it will further invoke imsm_open_new(). Since
commit bbab0940fa75("imsm: write bad block log on metadata sync"),
it preallocates bad block log when opening the array, that requires
increasing the mpb buffer size.
To do that, imsm_open_new() invokes imsm_update_metadata_locally(),
which first uses imsm_prepare_update() to allocate a larger mpb buffer
and store it at "mpb->next_buf", and then invoke imsm_process_update()
to copy the content from current mpb buffer "mpb->buf" to "mpb->next_buf",
and then free the current mpb buffer and set the new buffer as current.

There is a small race window, when monitor thread is syncing metadata,
it grabs current buffer pointer in imsm_sync_metadata()->write_super_imsm(),
but before flushing the buffer to disk, manager thread does above switching
buffer which frees current buffer, then monitor thread will run into
use-after-free issue and could cause on-disk metadata corruption.
If system keeps running, further metadata update could fix the corruption,
because after switching buffer, the new buffer will contain good metadata,
but if panic/power cycle happens while disk metadata is corrupted,
the system will run into bootup failure if array is used as root,
otherwise the array can not be assembled after boot if not used as root.

This issue will not happen for imsm array with only one member array,
because the memory array has not be opened yet, monitor thread will not
do any metadata updates.
This can happen for imsm array with at lease two member array, in the
following two scenarios:
1. Restarting mdmon process with at least two member array
This will happen during system boot up or user restart mdmon after mdadm
upgrade
2. Adding new member array to exist imsm array with at least one member array.

To fix this, delay the switching buffer operation to monitor thread.

Fixes: bbab0940fa75 ("imsm: write bad block log on metadata sync")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 managemon.c   |  6 ++++++
 super-intel.c | 14 +++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/managemon.c b/managemon.c
index d79813282457..855c85c3da92 100644
--- a/managemon.c
+++ b/managemon.c
@@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	int i, inst;
 	int failed = 0;
 	char buf[SYSFS_MAX_BUF_SIZE];
+	struct metadata_update *update = NULL;
 
 	/* check if array is ready to be monitored */
 	if (!mdstat->active || !mdstat->level)
@@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent *mdstat,
 	/* if everything checks out tell the metadata handler we want to
 	 * manage this instance
 	 */
+	container->update_tail = &update;
 	if (!aa_ready(new) || container->ss->open_new(container, new, inst) < 0) {
+		container->update_tail = NULL;
 		goto error;
 	} else {
+		if (update)
+			queue_metadata_update(update);
+		container->update_tail = NULL;
 		replace_array(container, victim, new);
 		if (failed) {
 			new->check_degraded = 1;
diff --git a/super-intel.c b/super-intel.c
index cab841980830..4988eef191da 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 	return failed;
 }
 
+static int imsm_prepare_update(struct supertype *st,
+			       struct metadata_update *update);
 static int imsm_open_new(struct supertype *c, struct active_array *a,
 			 int inst)
 {
 	struct intel_super *super = c->sb;
 	struct imsm_super *mpb = super->anchor;
-	struct imsm_update_prealloc_bb_mem u;
+	struct imsm_update_prealloc_bb_mem *u;
+	struct metadata_update mu;
 
 	if (inst >= mpb->num_raid_devs) {
 		pr_err("subarry index %d, out of range\n", inst);
@@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c, struct active_array *a,
 	dprintf("imsm: open_new %d\n", inst);
 	a->info.container_member = inst;
 
-	u.type = update_prealloc_badblocks_mem;
-	imsm_update_metadata_locally(c, &u, sizeof(u));
+	u = xmalloc(sizeof(*u));
+	u->type = update_prealloc_badblocks_mem;
+	mu.len = sizeof(*u);
+	mu.buf = (char *)u;
+	imsm_prepare_update(c, &mu);
+	if (c->update_tail)
+		append_metadata_update(c, u, sizeof(*u));
 
 	return 0;
 }
-- 
2.39.5 (Apple Git-154)

