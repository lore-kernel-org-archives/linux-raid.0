Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B935519A288;
	Thu, 19 Sep 2024 09:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737836; cv=fail; b=RYXxQF10rF6XLGEaT4M67yq+Skii2U00TxYEleLJXe8plx9HzFH5kcoSgaWWnM6PFBkmWqzPeAxMnU+QsYgr4fZGUjEy1MOdPkaDNUUlD+wevzbaVmqq+1/4zGKqxiCMj9ZWYZHP1LrdO9qj2ccR31/CDsV6jxN0XNgbb2Wgx/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737836; c=relaxed/simple;
	bh=PhJAdLM7FqgBy3a96esENhZwU+N7ilrYmVNrExOZNpk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G371MT092q2gkv8shlhVPnqHxzSfjNgBf/73lA+PdyLqKgFr2yDDsep0yfQIdJtGYNK5QH+Noy7utQcfGDBxSBvNJZ9NFvcQIRVLGEYfUUUBsX6UD1Bhnt+F3+RZ1k3oMA0PpbxpxOGCydcnpxNbRuW/ssHvb+V+dZ7fRtdu2fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cCFF2M7C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RojhGgtE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cCFF2M7C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RojhGgtE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tYXD001188;
	Thu, 19 Sep 2024 09:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=enqSZCLGKXElcAq3OZ8//9QBHRZ4j93Ztk5qLwlbl24=; b=
	cCFF2M7CXYpLeSLR+sHwqqz8Xza/JiESMyk5Pym3mndLktvyyj8VZqhsf1dcSyNH
	Zk2BtbadMh78Oun30TuxwYDe8teGNa1kHf0r5oghKFHGbscnBL3U1o5d7ehLVnv7
	r7y4GnPmve7I2xcR6aaBlUq1ZGNoJwXIr/1AN+SPKQ3BUaFKrfhCAJvHqVInDq6U
	3NRd6q66njej0fDGtwrAmcwnADftIUIezM/lTYH8gXTlyQOoaijPTl1Yx9v50rnu
	WV+Y+aotsNdve+Phk7E70d17Cb3nxZwNaCcyI8rHPXaVWe/N600n4K+PNSry/ZsQ
	nnMM+jvkuodu9TD2S9Rpnw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rk3d01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J8rlxi017777;
	Thu, 19 Sep 2024 09:23:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyd08cb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skGuQvM+DSnNhJTLhVaBhPq5puzgAwD1MMjuXhASavhNwFftiVuTkzmoC1jHKL7JYzum3wQ7qKD+rxRtO2pDeKA3/y9FWgUZZm7uxG7MFpTsJDK8cn1MtHGOqzSMC0sHlgosBj/VzDZorhk6ApYRL3lZ4fZayYqpih7vB9p1J5+H3BfmTxS+y3WgDc/jn+E4nLyX9BDo0hsTK6oSGAUAxiwPjBfiHfAuzcwebepJMgPUfgRRL0Gg2nF070nemBiecLJPf9xBHPa6Lnwlzzp9qqgYOQjgXcvI6JT6ZgdFk09dqSU0IKQ1nsLf1paoDC+TDEezpsk8x0NGa/hbI0LgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enqSZCLGKXElcAq3OZ8//9QBHRZ4j93Ztk5qLwlbl24=;
 b=DyTsarlfj97vt4LLOz9bcXAwEqBlYN7dmkBmiQPIgSCeH5Zo+3tbGvLO71amip7k9MOASJHIYw+hT+2XTJbFrGS7S2WxR3gQfzsOPBbSPGjTVku0EZOs/ahIz8yLrKbvVxR6/WaOjb7NIfecnH91Ln5b/ajA79FbDnXUttJuRxX71PeYvdN3WV65un6yAcy0i4PbQKvoUP7TcTq4K2DUIckxAAsTtUcUH0LtA/R7mCWM/JSYY5VU8KRw8oRaG59uxYQc5gSEM+IvWRtoIVBWusJ1red/7kwjgsxts4hR7/lWM7gZPdlmMrR8GtV6UBr5p3jF9BxqKagGrp9vaH9DyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enqSZCLGKXElcAq3OZ8//9QBHRZ4j93Ztk5qLwlbl24=;
 b=RojhGgtEbYeENfToURsHMNa3ie/tAGFOF0yeuJxerZ02V6Uye0AaD677Ng67Xy94ToDaFmAkrPlda/sHSfm7Y4DZMHmi0GqhTHa2afM7VYkcRcGgWj9EyDOTmqhhxk9wbmsGH3QBk7MkmEmJNPlG2fbeuH6LkmrKi/+hSoLI5w8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 2/6] block: Error an attempt to split an atomic write in bio_split()
Date: Thu, 19 Sep 2024 09:22:58 +0000
Message-Id: <20240919092302.3094725-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: fc618e73-2565-431a-998d-08dcd88cc352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KjZ3TeERcKBk9MaPStlpdvT9VGakVY/AvO7zBx7YRdBdQqeWd0Lpu3bLR+BY?=
 =?us-ascii?Q?KUSiDmDn0x7UZj69GKO0eaH0THqJinqESEHvzX7tNId9yPL42qQNBkmwwoey?=
 =?us-ascii?Q?xssl7KnsVLIayaqlBBtNSvhKRmbohjKXEcMBqA+bAX+8WSFpW51T3FSgxyOw?=
 =?us-ascii?Q?Oekcjv6JcO3NLWuoB5xkGJfnvAU8SUGcntcBRBfZ1vOdmpSPjJLIHdWHl1I6?=
 =?us-ascii?Q?s5hlw0bQHnmimiccbbtEpCcXvMj0regkLd6vMgiBPGXE+AEa6evpkwZ9YInr?=
 =?us-ascii?Q?yqDkIHX4iNk4luBsm+F0h0tnxIoWijYNwNkB6vxDoaHr6WAJSJ4OwSa0EBrx?=
 =?us-ascii?Q?zb7pv5C0KfAvVuthxFLhFQkHJnGpDAe5bxcq9k8UMgo46cUMt9eYkFeF5Gf7?=
 =?us-ascii?Q?m8o5TQzpcen0BWvA8YmIeyDHtUeRofz/KVF/aoO5go6qmBrgMWfxR3vSTvmr?=
 =?us-ascii?Q?5t0VppvV21SeuHb8vBTCVgOYpkmHJm2mE7JuJ8x6OSlUVj2wJr3hPxu/7QcW?=
 =?us-ascii?Q?Z+ubJcon4DpMk4eCr71l9B+i8HKN9Umi2jf/gXKEJfj1FRUfNiF89OhC0ctr?=
 =?us-ascii?Q?FBe4qtr80HJA5sSDxnpmK962iG21UZUyRC8XHRxRtF9rCyKbHc+f7LYU9iyN?=
 =?us-ascii?Q?cAr+5TP5RQpxduSnVcItUuYaB1JZIM09L1g20Jeo75MPYNl+cXSWiNjw0ErD?=
 =?us-ascii?Q?L/wkhrQD4PQTdSdVicP4Lqnfop5IZW84JnDPiFC9ZjtyjukJO1M+PiOzuYCL?=
 =?us-ascii?Q?LCdqUvtgMtSSg5nDlHeJgeCD2ni+/egXLxmXvhpHBVV/pLrX/vC5HCGYjzky?=
 =?us-ascii?Q?nWi+Ff5uJH9/ZzrBUOj1+vQTevEvOd+7j3NKS3IoHhTVwKxs4/zCumoa2Qi7?=
 =?us-ascii?Q?Xh1uYcEI/OlV1qQR9R8atmUBh8wIcD12wYL8NkCb3crF8kJuJxZc5PteHa+V?=
 =?us-ascii?Q?TontF4kKGabmg0Ryim7v4EK0hTv9ApRGOlcqjfeNELYxtk3z2fjAQNg0ol21?=
 =?us-ascii?Q?83gjBrxLYkrr8rohRYpyCSWXudi9Q864Xd7vdvY3LQHo6BSpuM1XGSgjxHrr?=
 =?us-ascii?Q?4ax11YKmWvemxYpbEsZPx5ouTaMSkAIFXmx2wVrQ5YfALlm8+4HFhYxdSGlI?=
 =?us-ascii?Q?8EOxITitouX2brbgvKX/tvlbSkPdKBPETIFU1qDbPIoVjMzf3PzENMaalWBi?=
 =?us-ascii?Q?+yiJ4qwT1fcmVSIx8klugPzPbonSXjoR3P3FftaJCWq+Mh8Y9waNh9xqXBlG?=
 =?us-ascii?Q?6wpxn5F8rzXKfyj63p1bcIfQhcaV5TEOiBX5ND6bGxQGZPXRbj19AQIiW3n6?=
 =?us-ascii?Q?X+AJ1xM5l8zVrNI+ro01bTJyEYkL+s+wodUq9+y3ZY/aDQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pkIO9jD7Qli99zTZnERxAFex94TDM/KYHqKTzLPHkH9+J8draLGDrl9+eHAj?=
 =?us-ascii?Q?j7vU8lrQJ3zMgUNFS82SjtK3zRShrGY4jfGl5TEXp7EP4daXd9RPGf7WatGx?=
 =?us-ascii?Q?M74mKBFQOdL7NHJlAa0P/pKcpz1S+lFwSdaTi0m94eO4Rnj3d0/6M+6JHiaR?=
 =?us-ascii?Q?5Sd3ShnY8Vyw5M5p5lz1lrOGYywZaIy/Hen5ALYXqAZzkKBLm64FyugHbX6t?=
 =?us-ascii?Q?JqqafitD+kKVTa3f3VvevNdM517GZ1D8EbAjHPTNWzltBzSYYq8wkM/QfsCq?=
 =?us-ascii?Q?fwVPCv2h6jz/65on43Tk21CA0chf3lblxjbxawkqKJeAh3hEepZdJhKQrTE7?=
 =?us-ascii?Q?TzWCbJEGtcUXa5hW04XvsdkJ1VJhDKsXpOQJmFaGTnmkRSB6I4B1WPmmbclz?=
 =?us-ascii?Q?oZW80SRtGvqyE6VVuEBgxrA3cIaWBRmAKqyKz+0lmeqplM0ZUVt20cVXWD12?=
 =?us-ascii?Q?zsYhPzzf/3bjRIm4/+A2PGk0kKOWk0BcZBwZZf/XwxoAGXIYNug4Fk5TkTIW?=
 =?us-ascii?Q?XunU+Z1JU28eBkZ/cdQCNYGDp0ekfWGc15p2vWbc7hiSxSuD2zNFdkjCigPe?=
 =?us-ascii?Q?KK6GbImIXF1jOKi91q0PgxYzEX/7OOlMBy8un/7N+EhRJsJJzzLfGNTSWwrG?=
 =?us-ascii?Q?Me9rhzU99mJQ7thy+aJ/Y0rRq4ANJ7Ck2cpBwdYCG9TOxjYI2RX+RToiTixd?=
 =?us-ascii?Q?msurDuMzCPWKKIb5Ed2spqqMWxE7UEsQ3OJk/3wZ4kpGgcleqpKcXXPZY37l?=
 =?us-ascii?Q?BOad1keORBL2lI0oxcHfx8kS7c/bdNS1cgzTkE/OrR7zLkJctlN7O85Hp7or?=
 =?us-ascii?Q?O81g3n/2YXrWKzRjVoBTQGiDyLeXcRL3iPUftiqL1uZKIOafv7dFB9o2ijt/?=
 =?us-ascii?Q?vnnZHqLOUM0GYT0bQ38bWbiJtXvavWddYM4e+ArpZH6g5QlLxcNMZhPYCoWe?=
 =?us-ascii?Q?/6zsq0kbDNfJgLug0QVILCuHHAueD4j15t1ebslB8oLVdyK9EY3S6NTMOn5a?=
 =?us-ascii?Q?Crwd0OdBPVJPyOZSpr9QeDOk52zy20mu/XbRDeTR2MhawiDHZfZpArgEztsE?=
 =?us-ascii?Q?9B9P0bavQX6Ph4EhdYpkvnKmF3ka8rBLU+ExuesOwtylNeLiTQwRSKS95uiN?=
 =?us-ascii?Q?pB1ZhnImNEUEiklAF4z5gpzH+wTh34RbBDYGPzdQeomKLd0zj/rIwJZJ2FQi?=
 =?us-ascii?Q?+lV7rB1M3pE4+uFVr35PeP6ennPPutgfniDcBlmMCShEdHHVlON1R2HLE87m?=
 =?us-ascii?Q?ppeok3j8K0yMzhDT8SSQiZRmAlIX45xq9GSadAb7Zz0R+Ay9xhtg0AqHDcqW?=
 =?us-ascii?Q?6tHjNlDBCJLdKku6MEOfSiFyLnpvMS2zCEAgY7rXQ55EULS8nkvKZn+8pIU/?=
 =?us-ascii?Q?zZJZhV9UphqY3gcxVC6MPOxrtz0B/Hw0zcoKTGts+HxUwjBDwZrx7gX6OW3k?=
 =?us-ascii?Q?wpk1+ls+jT6xvWIvmXnadxgVvMsThQvdWwUOf2j25/SZ2n+QoBF1tUV2vy5z?=
 =?us-ascii?Q?AQa+Tashxo8dpYRN78eEYiEAGFV73OkIKpQjYm0k4BtmbEVeLoOj7rd16sYy?=
 =?us-ascii?Q?bJbDSuHYvjhkrUvU+5fu7tBBxmIZShznIrw5ADOkEWIldAYEiLmKKbB9I4X5?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9n8E5Lf5DTVseIwRp01/0JshWS2QnBFedhSDMOOTFfrzZsYIXhkmwXtlQGIBVkYvXTmsxjO9833n0sJbXZlNm/O7GN0QgQexApQyVsO5VoGYsiSlQbiZozMkdnalt/EuLmzgR2ndGOVeFxe0AHeGiqVjYHxvHGQiga8t+YyRMD1pFsGirBwNz7Qsamk0815lbOvwqgN/teZ0VqqC0HJEGVlcRinwNiAOr7n+OErYh11PZwvyVIhun6ag8wFvcs4DoWbD/8k7YyX/IRuZiaBcQwfDO78bHlRJwI1z3ZL3s44CiAxPPiTxz/RwARREwNeXQ54CpwFiNXf86a3tcUL6Drp6FKch6hecNmq2i6lySWbpJjCN1nVek01yltdFZ2WkuXS8+4QD3ftw94OUklDvNkXUtH00Rk8Htzic0W9AZcOYpRUX+LJH0gwj2dqusDJAbzpXKr/wyx1h09bZaFzt+2ST67v8XOzTI0cqTvACcdS5Niq4TmJjQVdLA8qJ7EiRZzdr4oxYImJyOU9siVpKVDQkdTeBQDrbmO8TTOChi5/cc2hBVFPryzejQtjdLVP7o8nkkbcLIXN3MjvL4qdRBotSIEFo/u+FRSzidbA3u+c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc618e73-2565-431a-998d-08dcd88cc352
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:46.4790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJqq+BzSHZYhIwqJ8B8WRUb6ZQ+whfpWfBkJt/JYQj1gl7K5CYGeIHO62zVIzs43yREeCfALikb7WiYoMik7Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-ORIG-GUID: tmhes765YiIOMT2uSAlfQ70xnHsAB1Im
X-Proofpoint-GUID: tmhes765YiIOMT2uSAlfQ70xnHsAB1Im

This is disallowed.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 784ad8d35bd0..08caee855ca4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1737,6 +1737,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
 		return ERR_PTR(-EINVAL);
 
+	/* atomic writes cannot be split */
+	if (bio->bi_opf & REQ_ATOMIC)
+		return ERR_PTR(-EINVAL);
+
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
 		return ERR_PTR(-ENOMEM);
-- 
2.31.1

