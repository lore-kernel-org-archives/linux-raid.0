Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5651DE4E0;
	Mon, 28 Oct 2024 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129349; cv=fail; b=bfomurXDcGwDf+PGw55ae2DJbL0MIVmCIuzfSUbRSdDajFd5Nhz+Y/C2hkYLjqdHnmu+kTLmeHrTJorR2BBZKQPHmWTMsWBvEFK1WmmmiN618qZcfWCsqp1h1QkS3N/3c2CrLl4PNDRwkAMsC7DGVZnb2YmiRvd473EkzQU0jtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129349; c=relaxed/simple;
	bh=wfJxrWHXPA5YhkPSQf1lq2Qa6GVsnrDhw47V3asnLDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tDDMYC6Qsh3c34nnESYR1+oG8PPpCED6D6rDd6p7NR5pY5StgzV/gQvy34/LVx5PzsNylOl9vYyeQGxYZ3ygcLQ5iRgJdxEgnSguYDHekp0eKr3tVWv58oa0ICwgCyPPArMJgWq5eVsVXCgkd56T/U7zlpTpjIb2rSAyjw4dxm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W/3VQg6/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e4GK6mNU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W/3VQg6/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e4GK6mNU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtbBV022365;
	Mon, 28 Oct 2024 15:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eI/46pvMtf0+TrOXZu8yO8DexourEwTZqsgrWS+KEKM=; b=
	W/3VQg6/hlsE03GfVcXYzRLtq0oK+OhGT4AmfK0R2XpFeXmeUKZqUcfk9YcAVVJ/
	nysCFg515Bxe4NKEUXHnmPOOtqLXpPJjzgzBJyJtRJSfn1YLVVnFSElZkO7WXATh
	G95FG+oXMkZ+JicUh2xGz8jR+/5mKW+lyz+6vdywM7bLjMQBN0ThL8S2I2ejNksT
	20f3E/l8N1uWCMV4ztHaN97fvfhdd9z3c5yvMvvWnpn69+xStmgzre8RzdL35Uka
	MWyTgYrGIjMj3b6SXFlEkAIt8kbd2XJXXy3xO4JXQ1i8lwRxTdWFc3bMLdtntIqL
	RrgKs+Lx7RhieoSuz+67tA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdp35wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEoWrb008350;
	Mon, 28 Oct 2024 15:27:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hne82epp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBN6xdZ3S8AzvXBUhAUITrk2cgQWucjeAleTaylGxjmW2y76tr4WhAzdQ/s76A8vFzI3vlf05FcfVehQaduEHAg0oG54cfU1UezfdOH4Qlj/NDNgejXBZP8yvrL0J7JrspXnG/FBCMK0D0gxNEECfMaYzXufib5MZjNUQVa4PTD6YVUTwU0UNC/XeSQE5BJwROSiXulS/pmu1HPVLlx9Ki6xaPDZNOQK5YitBk8kv5mce79BtI2Yakw12soluat9B5VkQARClqGzdPUGF2iW0jnt+88+3OvSxTeKDFGtjJwtlZMqFxmqlfcn8QYSKBAjq99pC90ansXL3LKFoijYuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eI/46pvMtf0+TrOXZu8yO8DexourEwTZqsgrWS+KEKM=;
 b=nrQgSItBZk3RAl6AIf9kVTIsdYqb14DemeF4BGVuBNXw/LCk26il3oegLVTV4w3kNePu6S7wt2CyIF2DMLoj874vR/W5Ec3/noMfMmt4mEwuLcL3S7Q3FQtwNT73yb/U0D132MAt9AGM2x4c0beONmFzf9UYGg57LPLxJRKWZtgtKR3hxheOX5nJs2ECcYVmnl7VxAjsFYr97M+JP9ZsHUj278kpPFuhyfdvYls16cXRldlQPQwAJH1wHhQ3qU8bLdQ9tzZJI1B7HYKSlGGVtqDFBd6b5J2IsZDOBbg9WKgfhI95nIW7VpNOR986Tgyl5QEHhtn4DdQzIpS4JqGQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI/46pvMtf0+TrOXZu8yO8DexourEwTZqsgrWS+KEKM=;
 b=e4GK6mNUu3MOww3Kf5L2Vw/4rYTVxyW1Z6ANepQxrPKCxpbwnC35AkNTggPWtXswFcFMTM0WLVHN77UhkW1OZlBmEz4mHswZufoWp0GGi0jBl3C7P5AsDc48xAhOaO8ehIo3Hit46vvYnnn1hG4XOMz9g3k5rBAfKaod2VhUcdE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 4/7] block: Handle bio_split() errors in bio_submit_split()
Date: Mon, 28 Oct 2024 15:27:27 +0000
Message-Id: <20241028152730.3377030-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc59dbd-edc4-4124-042b-08dcf76515d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mTvXdpwUOJpr8UEKn+/M7xZfWyIb8PRp0/MKvKmPx7dAz41wh+9R60GLq3w0?=
 =?us-ascii?Q?KSx4iDmkEj6G7gs4b9UTUXOMZIAK9HexUSytPCmFgKATyPjiH82EXjer7BLC?=
 =?us-ascii?Q?xKHWNg2I/7NzvlMggcMINdaf9iFbiZxBn7X+8Ne7/6XfIqYyP8RyViaY11bA?=
 =?us-ascii?Q?DAGyHrJWroprItI+pomf1YL5ihdd7rw8AuuBjOpQSmHJBxhjBh1wzvYphJTQ?=
 =?us-ascii?Q?Q5QJ/xB4RtuR0eqXvWpgLz1M5qJxqFUkRt+fEnNIjwi3F3JRfX1pf4eTXNjD?=
 =?us-ascii?Q?PaVUdlWSStyA1WBWKWZeIzIhqtdNeGBPZ/Cr2Zb+gj1sJbfo2RvjQYf7lE0v?=
 =?us-ascii?Q?4wxfyVcbu8X7RTNdvbU1EkSuFxST4MRXr2MCRzy4hmsm9xEnd0RPJYaXtjJf?=
 =?us-ascii?Q?zgJzJeO7LMXxeoh5gMpjdzGZTbWBmBROozw+z5nfVWbHh4G7b84gKn+XgVAa?=
 =?us-ascii?Q?5SZhhEezeJZShD8FIqwtoM09e7W9PFP/+EamkXIDd4bGI3spIFkhinNqG8he?=
 =?us-ascii?Q?xcbpdpURFEEqPUErVbAHgUZTsEXQWKyDorM13DRvqR8JLf7zmOpXj68DGoB1?=
 =?us-ascii?Q?aWo75JG0zj4cxJMjYoBffENbsrA8XV3Wc+d0/My6twIgdkUsNuAMlHSWUBRH?=
 =?us-ascii?Q?6BWSKV4e+XjCHzImXKAuSZcp3/MrCBCld/81Wro0nKUstuw5gBjCIy0VjKmP?=
 =?us-ascii?Q?jGJR3yUaL4BimxNjpXiAhb2IBTETPGm4NJ087D+DgIjmxKc6sUqyo8KoXz9d?=
 =?us-ascii?Q?OOIHxAJuM6JRa54SKgDKIymFqKthJy6jzUJKB4lu3EA2ThjtqXVu6hgBFJOz?=
 =?us-ascii?Q?kRtYwdA8ghERWigroodWph/+jdYYmrgfdMmhmEKU5TVNbWPD7tx6rOP/4C5J?=
 =?us-ascii?Q?NimtxqB2isko0kPuyCjwOfD8PV7cC27NwUkXKa+H9N6xnW5ekbT2kgjtOuww?=
 =?us-ascii?Q?OeyuV5HczO+vSRZl8G+r9FKoq3EAJ0gG1ZAMfddcs0avVRZP7BJRK8uGbn7+?=
 =?us-ascii?Q?uQfN8gkmC1/Oigq5nqh6r76kNxB8gvCe8JmOHvw+o3TBCn/FJtEcplrpi/dS?=
 =?us-ascii?Q?+BgSePYKChEWN8C0ECDmVc8ilcTxJy1yVfputUGHtMhs0dPSB7RatLKfNcRf?=
 =?us-ascii?Q?EqrhLySU36uKCLZAErq0xwMgJtriw3iXwd7rX3cqXXXcidtAt6p7PrHq8N2g?=
 =?us-ascii?Q?kNPkYGQ2GLdHkIpvmikswp13Cmxp9SA9/33M4blaehV4lXfg6lDDYpG/XNvf?=
 =?us-ascii?Q?MA0Yws/MGWEWhZt0q92I27do16OfgGnmLs87rOs5z7HRAykrdzHOZg5WD5pT?=
 =?us-ascii?Q?9lq5gA1Wh/iHNLgQFt69JiUZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4TtEezXJqzwBtch4czUv1j6BRohnGg+9cIoMwQInEtU+RoIl+4ypnQR0oT5?=
 =?us-ascii?Q?+THSxWL98VCE/Wd6BehrXKWNdIKk1R7IP8WSFC06LvkgN18SjozhIKnMScuO?=
 =?us-ascii?Q?Sb2TTPc4OtfSjicg3Ydlr4qvA5qVu+dcoC9Cx+7vjw+ntvTANr28MlIAmR2i?=
 =?us-ascii?Q?krFPso4XMlQCE0rDIug8eOMAu6K13OscYuKG8lSCeLdUMb3SbboLwFJTbD1j?=
 =?us-ascii?Q?Bk4M4zn2pcrFkITUY21f+YdR30Oe479ukxYaiCmblLL343Fm9LWUso//xAf9?=
 =?us-ascii?Q?8sHEpwID3hB3TbHooMduZdVdUfDWkCQ7glD1NDXa9rC1uAH+T/65g8qwz+Vl?=
 =?us-ascii?Q?vn8R8qTTqIbkK14x6ibEKlE9NKCV1E34PmpfvZ00zwdd7Y6tZoeUHwWPl9zP?=
 =?us-ascii?Q?ODKcPHKENjMXxiByy4RHnYIltJ7RpjCMahQCGej5qNeAf6JlGkWZFXcVA+8v?=
 =?us-ascii?Q?kYNH4qNNudqcOAvCsSlQuC6mTmCZczhVYHJDItWDiaCaggfGq6y+DgxMg/CL?=
 =?us-ascii?Q?bsA2AkhIq0wD88dFt2tzs7qzYSUMowIe27acDuvFY0GZ3nyNBEWp3gfPq4fy?=
 =?us-ascii?Q?GvPmqTad5pZUs/+A+dnnOCxeyVxsfM90y5cC0iUPIG/msCRhZAcjFivF2Fwt?=
 =?us-ascii?Q?Q92zOKAhQ0WyXEurCTN7eJy8QQMIi22z6TmtzIUwVQUT3pLceu6UWgE2skx2?=
 =?us-ascii?Q?HVz/Tf1uVp208X0pGtuTb//Bhwss8L7wPcedZPaJJT6CiGFRURYp8aCVDHka?=
 =?us-ascii?Q?3SAXBUI6yVqdt32lKNY0QJnXcqZto7aFqV3hmoV9/7/6841dTUKMMAjuu+vi?=
 =?us-ascii?Q?6SOimRsBX/4tqQv+dSoFbTU6wTPFwe+IGXXFis75vyQk2pr++E5jNILGmXNz?=
 =?us-ascii?Q?WuV9rrf61T/HO8wzRk+dB+33qW9TLXMYhhnOgF0hW/jYzB6WycJngqG95KPF?=
 =?us-ascii?Q?C4h93TkhNl8+UIH0uIbDwxtQXhoTPWxNyNlB71GQf/gJ9Gv4Z5vCXTVHR9eK?=
 =?us-ascii?Q?c8iYt4oWCNeQ/AH49U/e9nmxRCcO3v117vd0Kvu+aMvj+nJqiqodttO4+529?=
 =?us-ascii?Q?FxbYGptPSvgL3eR0x3gvn52xo8EiGFi9j6gael1bcNNfMg2FzY9GXy03oBSW?=
 =?us-ascii?Q?w1+wRBnP07QQMWkRXBANTjXnQZ/1bBdjY1UAZokpbJkFYStmmjUC0tLErhun?=
 =?us-ascii?Q?Y39hEJ9PLAxXpAN3UkYjUjXKE1sI+q3q7ksWEemY1WXxDN5jK/jBICWHlLrR?=
 =?us-ascii?Q?RATXP574PP9A52rQ/5kWvZ5OTDgbMLhgOMybsVwUdELlK0EibsY71jJcghN8?=
 =?us-ascii?Q?yJYc0qFwEvq5oToYULBQ7WV1Wi5uJqxuL6/DJhzfftkLfNLrLeEeiYXB1QCm?=
 =?us-ascii?Q?3fHPVpaueyWu2VcXMHNZT+prZEr6rtdrI2mQNSRQ3XSN4yiNsqlf22a0OTe8?=
 =?us-ascii?Q?sPvz/16RujBULFmDTvpM1gNEqm4XDFx0ZImkF/CodwlrHIg9fSMwt/zdobfd?=
 =?us-ascii?Q?sCDDgNJ9cUJtrpiglBAiUTQm1Pkn7vB0BlUSFKeXtfnwZjRDO0apAY4EoOfX?=
 =?us-ascii?Q?w20PuuXBX2MfEYk33c1iGnBeHNcLtsR7sQzX5Crb+8fa1Mmj5BUdzH8Muk0M?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wp7tpvaGUe9y6uNhRZEwcl8lJKrv+/3WbGs+Zjh+9Rq6/4QZfMcit4T0j33J7lnZj0Xa+Z7dTxvO9GeX64W+PZ+nx4gqt5ud0Xrd97QCZO14CQrYpN46tZI1JOxLeByxAcZDpYhGksbbdrFS8/iOjRpCyZFpjrUI4X9sIl+w5EkHCVUrpf71PeADBRIT9SoxS5Up0u+nXS/mNo2bPCgTlynwumFvYholQfD+4kK2Xl8BZ+Z0NsuwBNJsquxZZhk4KanyPR+pvtuN8J5qJ4oOPnITwNvv/4qMQT2+SNFu8sCM07ip1K3IXXzP7M1cTeSOKSQqA/dZCDqObm7ursTNzPdXV0h2/SCjoLABiOjb7MAsJrhNffiGyGE7N+eUg+Sg3B5AQEUxp+JyNJcYO8NYfYlQNJwQ6uDwVoYUaCu8rM323n3sfsMb4dKsODB8tZKHFUlk7HQsmEdYj9JARU2VvyQTY8ejCrMNkio8phKIVRPUTjzGxZe/5BXYqGfUPnn4R9aKewa+fwhK+vgwiilxpKGunSTBILA83b1YJsROHWxbTMRVBF9p7F0X8A9ewimA0Bb5qSjCeAZ1STEHEYo5gmZIAx6Z9xltBJ7qSrzXHys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc59dbd-edc4-4124-042b-08dcf76515d4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:51.1107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ys9UXIIQO4YizarHh4j4Qs8MTAuls3W2mvj/0WtMx5opTys4bexoy0DZKlza6JZW6577DTGbomsBKLTqMTgsyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-ORIG-GUID: C2keqsBry7I5-SxyD7rpcFm7RyX_AuLp
X-Proofpoint-GUID: C2keqsBry7I5-SxyD7rpcFm7RyX_AuLp

bio_split() may error, so check this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1c73fd37cbee..b640477c190d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -107,11 +107,8 @@ static unsigned int bio_allowed_max_sectors(const struct queue_limits *lim)
 
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
-	if (unlikely(split_sectors < 0)) {
-		bio->bi_status = errno_to_blk_status(split_sectors);
-		bio_endio(bio);
-		return NULL;
-	}
+	if (unlikely(split_sectors < 0))
+		goto error;
 
 
 	if (unlikely((bio_op(bio) == REQ_OP_DISCARD)))
@@ -123,6 +120,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 
 		split = bio_split(bio, split_sectors, GFP_NOIO,
 				&bio->bi_bdev->bd_disk->bio_split);
+		if (IS_ERR(split)) {
+			split_sectors = PTR_ERR(split);
+			goto error;
+		}
 		split->bi_opf |= REQ_NOMERGE;
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
@@ -133,6 +134,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
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

