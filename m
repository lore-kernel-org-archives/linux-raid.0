Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D128EA66
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 20:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746649557; cv=fail; b=icwnSDnfQ+UvHMVU/AC0PiB8aOZxXUlAHhlXgYwJpo4uPpu4sfP8HOVnevb7qGeVhW3wk9NKUTLXwRAuaxPxr6ZKTFnW9REZCK9ZKy6CKcC8jwf2ix1juJtrwIFNfHAMXHGNeJDDJGxK/2pKHx8fW0G76VEcft50KUJ0GLwuqjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746649557; c=relaxed/simple;
	bh=jeL7LlKjVdn33bFSJUeVejUVLEgwhp7uWtzIIND/uhc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sWDEme9MgxaLqK02EVktPtPoScPKf2KfaR1MjxCarSu8y+mZW2qpBhlsK4+IYUzcNxeLLrP8UHmST/KMzYQ2LLBOk0Er/XNJm4IwdgfhDBgYO7nabmD02f2MxgRtLzZFC3Gv0dT+//QgBsxNsE+TFdx710av4PI1OryvPdFOap8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WXmMdRNL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CoAQLnjN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WXmMdRNL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CoAQLnjN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547K2Bho025187
	for <linux-raid@vger.kernel.org>; Wed, 7 May 2025 20:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=lJ+ljMF8wsi3Kt0k
	P+qzoi3Tc8TN10kGHYRDyMyoFm4=; b=WXmMdRNLSHo5m2K9OYodGTBWUxR+sHE5
	7LoG3tOZJYmQMM0QB4dLLtQlmzIYC1ZmQMkC4i/QDUXSJO11yojdBABWNlGgU0Iw
	9CpvaHDdb3tjIVqzB1rTYL5AS4W+sJXYCsx5OBj++twekt4uu7nxXvhsKUPPar1h
	gRAao6buCWJRf5qpvfQL1EUrwNoiCCLyKJZ0+tAzkW6H2UOC0YUQm2VpG24T5GnM
	0wqet1O4SOwznV/M4cdM+bFPuVKKLFKD0+CR5m4/9x0Kzcd+bcKRNeOT5muYfwBa
	9nJP4IZ2dcYlEO79z1bHW/BpEE0NEazV2n3pucjfVnCstA0Sw+njJA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ge6u81vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Wed, 07 May 2025 20:25:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 547J8TJG007326
	for <linux-raid@vger.kernel.org>; Wed, 7 May 2025 20:25:52 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011028.outbound.protection.outlook.com [40.93.14.28])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46fms9fg3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Wed, 07 May 2025 20:25:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCG1y+/LQaHNVhFBHY0pnCA7NCVcYiNSF8mNynpL+RDsBZKx/jwtlaIicdRyGUYWQinxVabbnGES+CPHrbkyVH9fcrYa3Tx67kmNaS6iBXxmPK0gzimP+an7QZKrwtZlVPqar7/7Zv/4Me8x0V8HRm2wPDv252p5gp8pSKho3JXPkcxlRFaNmf1OD+BhnkPv6aBS9QTCUu25fiLmcKPv8jZVzwAjl3W6MAUvINGkOmlsn9qk+x5BEWulj4YIzEkdx5W4UUDMgVLOxhdsxE0QgJQ3GVAr+p7dmzVAL3h782j3NZVOSQrqL8viIOZ7iw6EcVPWCs45OKd1eED1EMKpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=y9UJlFeeMmcs4MGEPgJmWh8P3ciGCtaib2kjWGKvCvBat184+m2L0APa7suWcijdV85wxT8SVN9CaoIrJApSButQ1BPA+/s8TOtZuYs4KrryeOO6FPaIHBFJGNoBd58B+n20WXsRtPq7N+Pizs8DLpNDsXL5KIhmJbbGKFxowDcdsBd1R2AackS9XLrxtmTxsNn38JU7qxjriXBDqpohxB28rfvJEIM4FOHgyYuwNocQINTo163inw6LFCURnYEUpGdkxhezYRrrSKmDOWtvZ1E+Pcemg4MAeo4thjg6ijQkeIV/20ex/fQFsAHopTf4BUz0Q/XQZb9F8sqVE4zTqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=CoAQLnjNR3Tj+2FfSpynfLtddB/MZXOWAsoLLpiPSnOsgkTlVux0U48MZbeVp8QxZntM6a2fI5YXA/Rqzrc97YXnlKQV1BK7WdvZF4H4VNUkUMMBdtSwVxNEdwAKG1cbkYE13kITh+dSCChmI7Fdx0Lkc7gTKLaKyVCI+YaY/7o=
Received: from DM4PR10MB6040.namprd10.prod.outlook.com (2603:10b6:8:b9::13) by
 DM3PR10MB7947.namprd10.prod.outlook.com (2603:10b6:0:40::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.25; Wed, 7 May 2025 20:25:48 +0000
Received: from DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66]) by DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66%4]) with mapi id 15.20.8699.022; Wed, 7 May 2025
 20:25:48 +0000
From: Richard Li <tianqi.li@oracle.com>
To: linux-raid@vger.kernel.org
Subject: [PATCH] mdadm: Fix IMSM Raid assembly after disk link failure and reboot
Date: Wed,  7 May 2025 20:25:44 +0000
Message-ID: <20250507202544.667496-1-tianqi.li@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::26) To DM4PR10MB6040.namprd10.prod.outlook.com
 (2603:10b6:8:b9::13)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6040:EE_|DM3PR10MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 35fe5c5f-6a72-4c14-839f-08dd8da55a1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEhNNU92aENSTUVEVEZzdmp1emNlVWk3RVdUZ2tFSThaYlJrTHAyc1l6cXUx?=
 =?utf-8?B?UmgzcmhrOHhJTGNrcVdiYXFlTStLa3BmSVZ1bVBIUjE1OVRURW84VVV3UXNi?=
 =?utf-8?B?dHZvM3dmeW9EdzFXdDd6a3dlcGtMT3hna093YVBQaTB5d3NvTzJ6VC9ZS1Rs?=
 =?utf-8?B?YXl0RHl2R3ZaUURQL3R0L2Q5Y2xRSGdxWjM2Qm92MEJRdjd6dGdaVVpYRWNN?=
 =?utf-8?B?K3FtNTRJdTJydy9Xbk9US2RTMkV3Q3RxQktCQjhLYVd4eTJUNU9WYVFnbGQy?=
 =?utf-8?B?RzFiU2tjSHE1c2FReGJUOHhjMUl4cit1T1luMUhxNFJIUFJPQkZhVVN0MTFV?=
 =?utf-8?B?NXpEVkFsZUpqWW9Zd3QwWTdjNmJjL2NnRE9OOWYvUVNrbGZJbXJSVGE4L2pY?=
 =?utf-8?B?aHVibittUHdIK1B6V1V4cU43enhxSWMvTjJJNzZmSEVmaENON1o2NlgvMHBZ?=
 =?utf-8?B?QUgwUW1jUk9RS1RER2pYQWR5Vnp5M0lEOUluaHB1RDd3REFpTVlzbmQ3QytB?=
 =?utf-8?B?dkFhbDdUSDFYZGdoQlBBcW81NHFUV0ZPOG5tMzFpbnAzTElpdGYvMC9qelVZ?=
 =?utf-8?B?RDVjVDRJOFpqbVFiVlJFdE5ONi83TTVNV1c5TEV6anozSWN6b01IS0tsYWVN?=
 =?utf-8?B?TStVT1hoY0NBUy95aU9ZVVlhTmxmaEV0Q0VibmVDL09wdkU3M3JiMGxDbzBJ?=
 =?utf-8?B?aEc5Z2Q0cGpYSUM3MnBCemtCVmd3V3crQ2U0Slo5aU1BTkhxZktVTFVTZjVB?=
 =?utf-8?B?b2JMQVkxbEpFOWl5YkplR0pXdmdaQ1QvZ05TWnhEV3RQZDJydzZDVm5Ec2ZP?=
 =?utf-8?B?VmNBTjJNTHhJWXlaZW9LQUJYOUtqdW0wNkl1WDgxUXYzQ0U2WW80SGhpUkxV?=
 =?utf-8?B?aEF4dGp4OUM3Tk1QR3pOcHZtZUNndUNOSWZsKzBONTU3andBSXIvcGhaWmlR?=
 =?utf-8?B?TjlWUGpqVGdnNnN3aDArbm5hRnVrdnptVXVnMU05ZUlaUHBZR0lkUHJQRVpR?=
 =?utf-8?B?T09vaDNrbllFOHJnRXJiZEMyNnptWExzajV1VHVEU1dqcER6bFpueWpqZ2tN?=
 =?utf-8?B?dDVSUTF3MnBvdUxzd212am53emVnQ0F4a0tMN3RBTG15MjRwbU5tdDBIQi9S?=
 =?utf-8?B?TkgwM2J5YkVWVHYxNjZucnIvL1h0anZYZUZ1a1NHcEtxOE5rVTZKZHByK0lu?=
 =?utf-8?B?VUNkMzVQWk0xUjJSUkFXTmdCVU5pUWJzd2hhU0U1SVZzOHhOQnNrcmtFa3F2?=
 =?utf-8?B?TDVFVDZNdkhzcURUbVhXRjJOeGJWU2c1UUN4RExWcFU4MjdicDJHY2J5NFJW?=
 =?utf-8?B?SmxwSTlOY1NFZE5SN0NPUEFsa1NKRmdrdytIUEliYjFGbDZkd20wZVNwME1Z?=
 =?utf-8?B?RERRN3h6RWhKVE5oQk01aTIzSktBWW94dmNRVVN1TEZmSFB1dW5BeUszMXdm?=
 =?utf-8?B?bHhBZXVXU0tCaTRjZWZWbUJ4ZHlMaUlZbXhDV3FNcU0yK0hLZUVuMUhNNW40?=
 =?utf-8?B?WkZSZ3BHYTlTazIzNVZ0ZisvcXB2SU5RaEEvR2xSRWpBMGU4RjRvQXZOekpk?=
 =?utf-8?B?UDFDR0dNNjNKbEkyRnc2cXB6dy9BN3ZEUWtSNHhGZi9tb2tTZmw3eTZxYkRk?=
 =?utf-8?B?dzQwYml0aEZFRDJ6REVxUTlDN0NtOTc1dThHSmNKeGxiTlZzQnp5aXB4VDYy?=
 =?utf-8?B?dkE0Z3IxOGszNlZXSFgrN0xiVlJqdUJzVEpBOW5scmlyMFhudmlQMTdxN083?=
 =?utf-8?B?RDNQcnlpRWxvblE5VjRId280ZEZGUUNyRU81V2NPQnI3TFZDY0prS2I2aE1k?=
 =?utf-8?B?UHhqLzFWRG1wc25sRks5aE5QdEFEbmQyTVBmYUZLZXIwVGRDNk5wSk9JSzNQ?=
 =?utf-8?B?UjJ5NDg0Ni9ndVd6ZHV4bUY0bDNZTWtQb3R5SDV5ekRlN1VqNTA1RTdGYk5P?=
 =?utf-8?Q?ovDMpVRLTDM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6040.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWxhYk5GOFhkUmJqUjh2alEzYnh5NjVoMklxV1ZwclJtTjVrR3hlNjY4YnhB?=
 =?utf-8?B?U1lJdkdtL1BNazk3YUVHb0hZOVJvQktVYjByaXRJU0ttRUlHbWZpSjlrVk9K?=
 =?utf-8?B?K1gxVEdYL1JnVmVkcGhTQzZuYTlzTzZRbW1VLzFmeGdnajg2dmxCbUMrZHd5?=
 =?utf-8?B?VDljOEFrc1BEYkdSNDRtNzg5dW1FS2J5MXhZME5FSFN2clZvN3ZQT2VXc2tq?=
 =?utf-8?B?Uy9sL3AyRjVBK25mS0RIYS8wS2JHOUxKT3o2S2loNWtLeEE5ZmREZ3dzZGY3?=
 =?utf-8?B?UU8yMmhEZHk3R2dLcHZScXFrUy8ybG0rdGcwcENza0ZFcFIxM0Y2Y3ZIVVBP?=
 =?utf-8?B?RUFaSW1Jb1pjZjZaUlYva1V6elI2b3JIS2s2dExXaWxCQmZzWU8vbWNTWWtM?=
 =?utf-8?B?bERiT2ZSbXdaVGZSQVNja3ZmdmI1K2dIZ09NYnZMYmhZeER0di9UMmhjNEtS?=
 =?utf-8?B?cERmZWNORHVGYzZxa3d2cGNUZm00SS90NmNqby9ranR1N2tQUDdhMndLazZo?=
 =?utf-8?B?V2hScjJzTThid3lPa011OHUxNk83OUwxekNwMWdiTmRNSThoNVFTVW9UYW9H?=
 =?utf-8?B?UloyUWVhdjlsdWRHakRMRThXSWVUY09VZGorSzRsVThTc0lNK0hCSnFQL2hG?=
 =?utf-8?B?TVpab1ZDdHVkVzdtRk9nWFJkbVZTa1JBeVFubDhBZVVOSlFKU21PWHpxVUE1?=
 =?utf-8?B?SDNGT3QvZ0ZJVGs3d2lMeXJFYk54enFoT3crcnlmVjlMQlZGOGRQeFQ4QzQy?=
 =?utf-8?B?UnFDVGtNZVRVK1NyaDBVTy9uN213T1F2MXhaMjQ2V2tsbytFK1F3SlRBSkho?=
 =?utf-8?B?UTFVbXozUzBiR0hzbzUrZjhQeFl5OXZRalRnUUtIS0hONlB6cFFVbjBxTWlW?=
 =?utf-8?B?cGFPaVBFYzdIU1l5ekpBYml1VGU1NWt6NktxaDhJVTQ3UEVlanVOcWNpNmRm?=
 =?utf-8?B?Qy9WYW01OUwyUUd6NEY4bnFXWHdnREp2Q244VjhzVG40M1p2ZTVsTTM2dkRZ?=
 =?utf-8?B?WVoxNVVGMUkxMkZBck9WQnRsUU9kQmlRbXYvS1RTREVmVmxiQVhMRGxvYW5y?=
 =?utf-8?B?ZWZkSGZvWTZSdHFZazkxdTFrcGNQblh1Ukp2R2YwZ0hLQzN2dXpITjFLK3ZW?=
 =?utf-8?B?cEpsZFB1OFMrcjA5b0RGdHFlZ1NSN1k0cW5vRWJqK3g0TnZmQUp2bW1hakVv?=
 =?utf-8?B?VXpQcmlGRUpydlJwVmZlOGxSLy9EM2pFMlVaTkwwWUxYMnA0U3R0NEZnTnQ2?=
 =?utf-8?B?SkJ6YlhNNWQrbTU0bWwzbERUSTRCcm9VYVRZWWV6ckFVYWpzVkJMbjRRdENN?=
 =?utf-8?B?SU1Rb2hURzZEVWtrZDBseHVmdEV4QTgzUUUra2xieTBlRmEzOExvbVdTc3lr?=
 =?utf-8?B?Nlc2Q3dDUG5HcHVaZEV1cjd2Z1lLT3JjcTAvb1ArQ2Y0S3c0eFZtZDJ4cmNm?=
 =?utf-8?B?WVlpK1JiWVFsTmlBYnhCemlyK3R3RzREV254WFkzL1d4VDJBYTkrZnV3WTdX?=
 =?utf-8?B?Q3d1bmV6VzF4SGpJaUoreFFMZUlNaUNHYWpUQTRZMWxyc1lid2UvTTIxbXZN?=
 =?utf-8?B?WkgyQXJMUmtYeHVOYXhyUk9FR1RWY01TMEhPQUhYY1o4bXVyemtidDZ6b2J1?=
 =?utf-8?B?eC9KSmJMQW5BUlg5RGZTTFBSYzVRZEdzLzNDTUFEazNRWk5PSU1SQmd6azNI?=
 =?utf-8?B?aFAzMHluUFNJNis0d3hSRk0rVTFUbFJqWDljbjcvTFB0MFBpaU9rRTM5NzFB?=
 =?utf-8?B?TWp3TENYTVFxVFNQdEUyM0t4K3dQRlYrL1p3eEpQUkppbEJ0ZVNoNWcwTVZi?=
 =?utf-8?B?bWRJQlZ4RzE0djlBS1l0K21UKzVIMU13Q0toM25tNXpPMWVjeHgwdC9YRnBo?=
 =?utf-8?B?aXhDcTlOQVRGdGZpQzFOaWR3RWUxcEExYjdkQmFrUXVsWml5TVI2ZVcyMHYr?=
 =?utf-8?B?M2NwQSt5Z0VnQnNzSXMwMTJTN05rTUFHVmhNWHRFWUFGa1ZYKzdudmdBMzJE?=
 =?utf-8?B?eGY0ZVZDbTBkVnAxQUdISWlsS0hOWVpBVVBVM25UVktCTGJJQ2t3anhxV2Jk?=
 =?utf-8?B?OVNwYllCaDJkdnBSSDBod1YzcFRUcXVhK3VMZ29UV2gxOG5MdHpVaG5zZ3Qr?=
 =?utf-8?Q?o91Hx9mPSq0znLAe8DOuWzkBH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4MgKhWtpay1bn9t/nRTaCN0hFhzOdL2MHncIufek1CC+wDPW1+L8dH83MlH+5BcEdTx6Eaw8YNKLb6XD8nIZ+jIIUBmY3ak/rG7BibWv8jKgm9hPsiFYKnVvcCzw3kapqB9HlftbUfY+rIMOGvHKkBdbnGdyGA1p7gYx4qeK0yvEcql4G0BYFOYvry8U4L+UBLK/UbvhB5kWEn7yuSe3kWKcE9qnSIJh8S4gPloHYjnb8zDdjOc/jszfbLTTwjorPwCxEGQhDtagLkYnrhOoygt7+RRshvw+innqO9kpiBBbuSGJ2ZI2ynamk93V2rtoohr/V9/+TpsHp1uetowH5IxL4yrNE8Htpav/SPBG2JQy6QCFC4GhH3frqExvrduxN+jwuzAenszsZ1TrjknsvoMHFMBLbS/kw7JlTUNcQ6RI05fIqjxXmIY/AagZQ9bgRkt8xHeO1dDVcfnnA8SB6PFn15sIczKJutq4K6xMR+PxDtrOoNP5OW2VK0QBf3dxwTBuYxCxzbkrzcEejMljr+Gpp5xC6/VhISCfRUBuwuc0GGZlOKOsA1Bt2XETjNKHLnJwjiibJpTfw3eMDw7LV5MYm7YORcwl7v2lGc3DxVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fe5c5f-6a72-4c14-839f-08dd8da55a1c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6040.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 20:25:47.9228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxdaoiCq63pEQofpkfCKrpzSJS1nsP8zS9WD8YW5RKR5nHP3qDpmdLvQZo7He/UEQLeLnBQ5deRPseB60Sk2iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_06,2025-05-07_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505070186
X-Proofpoint-ORIG-GUID: rCtAlLPB3MyIFegskV33_X15KTUhoKIj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDE4NiBTYWx0ZWRfX7Z1ebybRazlw Il1PdFSDXKA9WPqtTCjGfuwIIC4EbKuJtf5bCkxEai7HyBUSp4bhY8eLqrrDyqxjARiz0mTDFTL duicBOPBzWwSZjoZUo+moFu6SHhvDsxM86M4AO/PrObu2ZZ0BgT/70NM6SmT1y63uADVynsX5CC
 J+0C2ydkApklH/UnZic6dhJbnxHD7XEXm5OeFRe6axqdrt+svbAsCgAJFWT+aU8tnWSh1ZyXSa5 GqWz+jMauWDefhsluHMMncJ0SCnSzTxVhzV1hUK0a6P5cvJXwFkEYqdVVuZIa2b/SsyY6X4vrKN HIq7LIc7CmY84YstJltWwsbzcOD+FeBte1JZBInMlgE4Zwsy3iXYviT8YDB/23sbZwAUykCJSWW
 EYVTWkYmieRKY1xKfy1FH8qIjT7E7fS4umdRk8zCVs7InvY3Kivl102KAnHnuCAYPW/UY7UI
X-Authority-Analysis: v=2.4 cv=SKFCVPvH c=1 sm=1 tr=0 ts=681bc1d2 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CSnNaLoam6terLhnIKsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14694
X-Proofpoint-GUID: rCtAlLPB3MyIFegskV33_X15KTUhoKIj

This patch addresses a scenario observed in production where disk links
go down. After a system reboot, depending on which disk becomes available
first, the IMSM RAID array may either fully assemble or come up with
missing disks.

Below is an example of the production case simulating disk link failures
and subsequent system reboot.

(note: "echo "1" | sudo tee /sys/class/scsi_device/x:x:x:x/device/delete"
is used here to fail/unplug/disconnect disks)

Raid Configuration: IMSM Raid1 with two disks

- When sda is unplugged first, then sdb, and after reboot sdb is
reconnected first followed by sda, the container (/dev/md127) and
subarrays (/dev/md125, /dev/md126) correctly assemble and become active.
- However, when sda is reconnected first, then sdb, the subarrays fail to
fully reconstruct — sda remains missing from the assembled subarrays,
due to stale metadata.

Above behaviors are influenced by udev event handling:

- When a disk disconnects, the rule ACTION=="remove", ENV{ID_PATH}=="?*",
RUN+="/usr/sbin/mdadm -If $devnode --path $env{ID_PATH}" is triggered to
inform mdadm of the removal.
- When a disk reconnects (i.e., ACTION!="remove"), the rule
IMPORT{program}="/usr/sbin/mdadm --incremental --export $devnode
--offroot $env{DEVLINKS}" is triggered to incrementally assemble the
RAID arrays.

During array assembling, the array may not be fully assembled due to
disks with stale metadata.

This patch adds a udev-triggered script that detects this failure
and brings the missing disks back to the array. Basically, it
inspects the RAID configuration in /usr/sbin/mdadm --detail --scan --export,
identifies disks that belong to a container array but are missing from
their corresponding member (sub)arrays, and restores them by performing
a hot remove-and-re-add cycle.

The patch improves resilience by ensuring consistent array reconstruction
regardless of disk detection order. This aligns system behavior with
expected RAID redundancy and reduces risk of unnecessary manual recovery
steps after reboots in degraded hardware environments.

Signed-off-by: Richard Li <tianqi.li@oracle.com>
---
 imsm_rescue.sh              | 148 ++++++++++++++++++++++++++++++++++++
 udev-md-raid-assembly.rules |   3 +
 2 files changed, 151 insertions(+)
 create mode 100644 imsm_rescue.sh

diff --git a/imsm_rescue.sh b/imsm_rescue.sh
new file mode 100644
index 00000000..7dcb0773
--- /dev/null
+++ b/imsm_rescue.sh
@@ -0,0 +1,148 @@
+#!/bin/sh
+# Check IMSM Raid array health and bring up failed/missing disk members
+
+mdadm_output=$(/usr/sbin/mdadm --detail --scan --export)
+export MDADM_INFO="$mdadm_output"
+
+lines=$(echo "$MDADM_INFO" | grep '^MD_')
+
+arrays=()
+array_indexes=()
+index=0
+current=()
+
+# Parse mdadm_output into arrays
+while IFS= read -r line; do
+    if [[ $line == MD_LEVEL=* ]]; then
+        if [[ ${#current[@]} -gt 0 ]]; then
+            arrays[index]="${current[*]}"
+            array_indexes+=($index)
+            current=()
+            index=$((index + 1))
+        fi
+    fi
+    current+=("$line")
+done <<< "$lines"
+
+if [[ ${#current[@]} -gt 0 ]]; then
+    arrays[index]="${current[*]}"
+    array_indexes+=($index)
+fi
+
+# Parse containers and map them to disks
+container_names=()
+container_disks=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    devname=""
+    disks=""
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICE_dev*_DEV) disks+=" $val" ;;
+        esac
+    done
+
+    if [[ "$level" == "container" && -n "$devname" ]]; then
+        container_names+=("$devname")
+        container_disks+=("${disks# }")
+    fi
+done
+
+# Check and find missing disks of each container and their subarrays
+containers_with_missing_disks_in_subarray=()
+missing_disks_list=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    container_path=""
+    devname=""
+    devices=""
+    present=()
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICES) devices="$val" ;;
+            MD_CONTAINER) container_path="$val" ;;
+            MD_DEVICE_dev*_DEV) present+=("$val") ;;
+        esac
+    done
+
+    if [[ "$level" == "container" || -z "$devices" ]]; then
+        continue
+    fi
+
+    present_count="${#present[@]}"
+    if (( present_count < devices )); then
+        container_name=$(basename "$container_path")
+        # if MD_CONTAINER is empty, then it's a regular raid
+        if [[ -z "$container_name" ]]; then
+            continue
+        fi
+
+        container_real=$(realpath "$container_path")
+
+        if [[ -z "$container_real" ]]; then
+            continue
+        fi
+        
+        # Find disks in container
+        container_idx=-1
+        for j in "${!container_names[@]}"; do
+            if [[ "${container_names[$j]}" == "$container_name" ]]; then
+                container_idx=$j
+                break
+            fi
+        done
+
+        if (( container_idx >= 0 )); then
+            container_disk_line="${container_disks[$container_idx]}"
+            container_missing=()
+
+            for dev in $container_disk_line; do
+                found=false
+                for pd in "${present[@]}"; do
+                    [[ "$pd" == "$dev" ]] && found=true && break
+                done
+                $found || container_missing+=("$dev")
+            done
+
+            if (( ${#container_missing[@]} > 0 )); then
+                containers_with_missing_disks_in_subarray+=("$container_real")
+                missing_disks_list+=("${container_missing[*]}")
+            fi
+        fi
+    fi
+done
+
+# Perform a hot remove-and-re-add cycle to bring missing disks back
+for idx in "${!containers_with_missing_disks_in_subarray[@]}"; do
+    container="${containers_with_missing_disks_in_subarray[$idx]}"
+    missing_disks="${missing_disks_list[$idx]}"
+
+    for dev in $missing_disks; do
+        id_path=$(udevadm info --query=property --name="$dev" | grep '^ID_PATH=' | cut -d= -f2)
+
+        if [[ -z "$id_path" ]]; then
+            continue
+        fi
+
+        /usr/sbin/mdadm -If "$dev" --path "$id_path"
+        /usr/sbin/mdadm --add --run --export "$container" "$dev"
+    done
+done
diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 4cd2c6f4..fc210437 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -41,6 +41,9 @@ ACTION=="change", KERNEL!="dm-*|md*", GOTO="md_inc_end"
 ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
 ACTION!="remove", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
 
+# do a health check and try to bring up missing disk members
+ACTION=="add", RUN+="./imsm_rescue.sh"
+
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $devnode --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $devnode"
 
-- 
2.43.5

