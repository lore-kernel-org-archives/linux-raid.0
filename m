Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF373137750;
	Tue,  7 Jul 2026 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441283; cv=fail; b=XVz9B4WkUX9E1SIQXkd9HvzEYn/x9EitTrVUsxQflzndtGpINIlW0xNWfyIlVOWcu7ShY0lBgHTto7gY+SeV+8mHrIHWVRGnkAg6Z/8ZIAWzlq3YZc05tScQ1kv3u2wJnSHlfh0wz52FFh/G2T85i9KmuUux0p1Ub9+znoB6hUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441283; c=relaxed/simple;
	bh=IsmnRewMBnfz1gAgom+Wj7PzmBiWl8AjtccBtrp58hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HF7JObyASb8lCEIkbY7IqRvnkCrSdac0Jv7alzuQLsTbXZmiivGrqKEBcmx1uyPoZunukP1U3pELsZ7ez9CEiBwuvuHct4HvFeos/lhBTJVhmohx4R9sREtKWAAKv1hEQJHBPx7YV4b6fdUTxztJOfYe+m498vDwRoZjW2eeSwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z87818j9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ceE8EZ35; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z87818j9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ceE8EZ35"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667CtURD819648;
	Tue, 7 Jul 2026 16:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4UmNvrgRPSiuWE9BjcgVWOa1GpEGML8eAr9mvIpkboQ=; b=
	Z87818j96K3iV1OAWAJtJI/q4pM1kTXfS3KknUYTeu1K8XVLGBnD9+Q05ZxyEM+v
	bpeVsglJ7h+s4b6tMjjzoLHU3n7zRQTecRCMFbOpUht+174dsmCs6eVk1H0BQoX1
	QOSu8V7eW+6kGW6K+mM4qOAk/RW4HyW/ZX6+F0i6SgxKmuXiK55OJnJN349QJCtv
	yaw4U02sgHrvcPAHfFUupG5GHumcm1f9pUIdYWr8S1OTn6cfngOb8ZcNSYJ/p7VK
	rjLBo5ITCDseODrhiofGjho13N4JNKxJcYCqzjzujHCkXCNvar3ipnRBhzNLYY1z
	L4gGys7Q0ZCibaU0oCSL3Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t2a5vet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 16:21:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 667GI6oc008675;
	Tue, 7 Jul 2026 16:21:05 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twj7uur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 16:21:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALpRPxO1phl4MdxcnL9W1SYc38WFiHtZPsU/1S6EzP7H1ZFp9aGgFHAUMA+ql7lPk7F7hit4Z3EboFcNRW4Ta5JUaV7rLS+T3y1BUCY0kc4630bKiJas8Gm8WdjTO2v9FzieH0Cnp2VEeVW7etSl4Waf78KxEW/D9aFgPw9Ymp690t95V3/LOC8tZxYcPDbep4k2XXd1AfralAcIXQmcfzeeky37Fm+QkRR9Cqgv1KAQ3m5NQHMD0a7kyP/pVB7Wauk8nF9V9m+qaXKgC+kZ4LvBg+Eej2dGroLmLiZYJWAaSOBmG57ZMbVG861gAQlb9rKxxDgQaqa5W2UDmY2IUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UmNvrgRPSiuWE9BjcgVWOa1GpEGML8eAr9mvIpkboQ=;
 b=SVy261wzymAHiE8Vr3BoVh04zImxWHbAKvEzL05Z/CAXwfDR99MtUnkVfgEeoLoQcb6wbXcczrVsEe7xrubOQDpN5g84nYU4+CLLdG61OWU3g03/6o30gfUVCRzdoIgd9YuE5jcp0sSEF/hbZWad9+kaVxmQFOAtlx30zjeAAIzsmxssyGyjDt7iDh/B29XRJRi36ZfkB6Jq6DMonzjedSOxq/1jLfq9+3Q3YpYW9ZrDOP+LV5S9rFNGRXxsDpQlz2ldNg1Tva6lOT4oQrA2FU4mDTZ8LDItLYs8bvaRo3wKI4TbaqEgAkjdyuj5iJ3zYpMkUCwfJNJwwaJ/tyPDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UmNvrgRPSiuWE9BjcgVWOa1GpEGML8eAr9mvIpkboQ=;
 b=ceE8EZ359zLgxvs3TTbaq2mM4IZYdsuTApKoRQGGCBmpS7EQ9TdZ7FYKCe2fCjd5+aQKR5+awdSIn7l6FHnNQJCev0ez2Hp68CiRFv0ipznkoC/UoX1ppokCW1tW+2if7JaD60hQhGUCQrPH0KlYaPmXate4BCcatqh1kTyIqZw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH8PR10MB6501.namprd10.prod.outlook.com (2603:10b6:510:22b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 16:21:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 16:21:00 +0000
Message-ID: <fbf1a5d6-d362-4eeb-8434-2f4a114a70bd@oracle.com>
Date: Tue, 7 Jul 2026 17:20:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and handle
 runtime constraints
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
 <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com> <m2se64zak9.fsf@gmail.com>
 <856abedc-d2f3-4248-9583-4d7e1a11abc1@oracle.com> <m2pl1073l5.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2pl1073l5.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0216.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH8PR10MB6501:EE_
X-MS-Office365-Filtering-Correlation-Id: f80b149c-3ecd-4cc1-14fa-08dedc43bb6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	etgf7bTrUUQc6A392OTtRlt3rZT94KXFXf2EnIihQmBDjPGrnE45wy5gWUqLAZIrVGdQi5XvrnFnCxlgOA3Uw9avEXogTObn2jF9c2heCKjszQz8JTndaCLZjGoG/V3lCG+Ijlkmcoof7n7jAStqXOc1xLJ+MS+Q7eEixN8iSfUkfHQ/Z2ffky/uSic/LVzqVNyVW2AEh9QGd0tioI4VTWlQ2BuMWGbKAUdDwMOeiLeVUDIqFHH5aeQEjLwzcKHCIpxQSVkNuZeTqTTy3Cpjr4De9tjAeDKqXVYM8Pt2dD5LI3z3MmgCiKd795t37AlnlVqk3UjJHlAIsk8c2shmUgDMhtK9cndSZ4PmgInwS7agMWsoayAGT7g9zZOA4Rve/jc4STGqNJnOiOb1tE0mXfDXRGToTlS64uyzKvTdtS169MZTWswdUVPj973UuG6fwW2LCfFr5gGOLvXcQyvoFtwsShqQ+Y3hva0rKqGL1qLZdkCZ26NvtO4/XzaDyB5DMSdAyHMugsaib5tKHdwTv610Z6Bn5Iq0T+c64My2aKHPK8ywzhJl9LwXiBkRX7e/hutwjIIHvvlPSqEjykRGcd0a95dp3gfBhX4GA8lx38ma2+bebks/tT1LhvCGQjvbRmpCj4PxLAvWhrZMzkA5zykTcWnjTSlDePL8hTNOGTI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG9lVGtsVVRiUFY0Y3JWbU03YTZXeXpYYm9RUEVBYUxKRWZSa3Z0aTJsdzhH?=
 =?utf-8?B?YjBubkpEbFlkRGxBcHp3SHlhVXM3QWZKSTIwUlBmZlBud2JDZnRGS0pYTHBK?=
 =?utf-8?B?T1FXSkxHc2JFVS9ZMW5INERhaVA2S0RiOFFpR1RiK2Fta1ZYVWxPK0dkT2VV?=
 =?utf-8?B?U1RickppeG41TW9rTEgrS2xoU0ZxWkV1OTRYQVhraEZodTMrbkdPVVViWEky?=
 =?utf-8?B?YjRDeHhMZWxnR1F5SzVkWEF6bkNKSk5PbjkwU1RDbENjVUZjQTlHeXZ6UXlT?=
 =?utf-8?B?T1ltbUM3dndlejhtSFNKU1EraGQ5WTdjaXU1dDdXaUJWTDRmOWpzeGR4ZlJI?=
 =?utf-8?B?TjdWQkNJTG5UM3JsVGFPWGM3OXZlRFQvSlAxQ09VOUR4V0ZidkgyVU1WL0Vt?=
 =?utf-8?B?VFZlbzVOM1hLa0JBZjBtby9Ib3FXWnY2MXJpcE54U1NTNlJKR1ZYRlJIcm1r?=
 =?utf-8?B?WDR5TWljT3B2Q2l3TEt1a1g3anRXN241amJLNklqSmhtOHU4WEVad3hkQkhr?=
 =?utf-8?B?R28wVlk0N1JzbTlPMko3MDRwY1FqQzhyMlNkd3ZMV1BDcE9rOTAwVHVlSUt4?=
 =?utf-8?B?ZFVJc0FWWHhnTjdtcDk1b3RYTGZWMGNoMEZtbDdjUExLMmRHU0QyVVFqOE04?=
 =?utf-8?B?Y2lGMW40ZUFKUWp2SWFhbDBpSDlIOGNYOVg2V2J6UHlxTWhtS3FFZHRqKzdm?=
 =?utf-8?B?cUVIalhyWTFEZFErVnlLN2Z3REdRbHI5QXJRMmJHalFNQy82RDhXd1F4ZU4w?=
 =?utf-8?B?bVBCK3lRSEFHT0VsL09UWGx3M0ZCck1lNTNsMzFpOS91WkdDanRCNzNlRGti?=
 =?utf-8?B?TGp0RGpsa1pxU2NlMlduWTlvLzZGMEhPOFFpeEJUNk9DekVxQmYrajZiWWJ5?=
 =?utf-8?B?Zm1XN3cxWVB6M0IvckdYMXc2enBTUWIwNzVwZHNzaGVpWGZvaUtleDBTeUxn?=
 =?utf-8?B?aGdCT09KY0dtOGJhK1phRjA1V0RyS29Ud1BtamdBZnpTK2NjTGVKZzllVVFJ?=
 =?utf-8?B?Q2VsbEo0ZEc5SzlvN1lubmpncjczZWZNWnlSUFp4WGwvRkw5SmlVWkk3VVFJ?=
 =?utf-8?B?RThNbHV0RHhISklGRW9NOGtHSU9zVGtnZFU0WWNCemZBTDJIbEVLVFB4OHVo?=
 =?utf-8?B?blVJdXJiRXRuWFozNG9UbEhlY0FMZC9GcVpLdnUwRnF1L3ZVQU5ZaHRlanpC?=
 =?utf-8?B?OWNPeW1uN0UzWVZMQ3EweWZjM21XeGRTY0pkQjRscU0vZ0t6QjJuODJid0Qr?=
 =?utf-8?B?RDM1aFFNTXJoM3Y3MEhreW1MQThoam9IcjBiTzFPemh5UmszVDFRMWlrR1pU?=
 =?utf-8?B?S3hmVFdxd3NWeU9FT3lKMUUxbnUzUmY0Z2t5ZWd3TlcvU05rTWF1TG1ieFhz?=
 =?utf-8?B?VlIwNjNKTXRROXdiMW9ZaHJBTVdqV3VTVE15c3VVRDZzZnhTN3BUbStFQ0l2?=
 =?utf-8?B?MnBRSUtEb21zZHN2bkpNbTFmVGxkMUQrb1gwamE5T0lpU2YvMGs2WGxZRXRu?=
 =?utf-8?B?M29VV2d1NFc3SjAyaWUxUGZXTU1tdXIvaTFONmhkV3BaVFpHYTFuYmsrQVBY?=
 =?utf-8?B?bW85cHVwYk1sYUNVbklhUDRPaFRnOXhuL0oyOC9YS1JscUttN2lnRmtJNmxq?=
 =?utf-8?B?RmFObHlqaEJCZGx4UXRKRnZuYkVGOHE4WXZmSTRtd3crc0t3M202dmt2U3dC?=
 =?utf-8?B?OUlUMnJVMm94b3UyZjRKeVBwQ2hCakJDdkVkTGhUc1hOOGc5bjJMbnFQQ2x2?=
 =?utf-8?B?KzBpbXhTeFJ1TVBPK0Joek9URGxnYXV5UzJyN2REd0c3NCtwSEhyZ3VBSThl?=
 =?utf-8?B?dVZEdHFoVm1WeG5PZzNCN2wydWZFakJRakVmOWFhTVVIZUNpR1Z4NGNqSFdw?=
 =?utf-8?B?Z3drd2d5QjJtT1NmRFF3dmtyM2ljeFF2SkJQTlM0TVVBVkpPRGV4K3lWUWJx?=
 =?utf-8?B?SHVGd2xMS3l6Sm1NOGpxb1RNTVhRMDZYZUpNWnBoN3gvTXYzdWFLbFBOUnhN?=
 =?utf-8?B?SGxlZFJQSmYzL0JLMHNQTGY1dWR1OEJPeXZVSzBHem5Dd0MvSlhLQlgrTUY0?=
 =?utf-8?B?TWkzeHN0M2NzckdvRW1qalMwRHpZQUpWTW90d21ydTBCampnQVlmTGtmbkor?=
 =?utf-8?B?OTF6L1Z3dHNMK3VCSU1MazF1SGdRMEhkL25OdEdJQjdaN3BTbFhja2pWRytq?=
 =?utf-8?B?bXhCUUFydTk2WFdreGtHc08zZVZZYUNlR2VXdmRYazlMU1Q5aGg4STA2U1Z3?=
 =?utf-8?B?MjE5Qm4vejFLaGRMRWtwZFovZWNXWnc5dzdKbWlJTmNUZkN3SXNsVWdxUnM2?=
 =?utf-8?B?N0ttMmRtaXJMSjVPOEtQenprMnBLTjNsMjBobjRoUDFHYjRpb25mUT09?=
X-Exchange-RoutingPolicyChecked:
	kPjtU6A0sizUJEL36gN4D8dDJSI4ydbyI5SCVCbYoiY/E7Y/SqMKrLe7U6pmv0VvJinxMzLKN/NNjtFcQeyVVfGkHUlwgf87hEOq8wTHUkoTj9R00PW+gc+K2mNH9G2ppH9Gw6azOm0FUBMNZPb/aykBWj6v5Z5bv4dshi+IneKGkxhWqzIbL31ZjwDjDkioLK3GnNPoZV6iToMKmVZIPjp5YXjRVVmMnn1klKeh+MrStQ8Uhin69vo1ie2dPdf85/JltuQN/9gCUhg00I8lCB6WvIj9Ih2+JtDiy4++0sAygi5/KErhZLcFgkc3xd/yPJXD6gbI5vJ+3daxmJgEvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	anAa6WVy+blbnGbMqZm7Pt7EMDJbpv7WG6nCrCrO8oqNy3XOPxAw5/3ppe7fQoNpWv3tedh5J1bkZh5EbfjFqJXmlqUpKcHcz746IWtuDfF4lcNmsZnmMoK44cCImzGPqp1KG4VhkCNqOShKY7IHN6cCEYTR9ypDFdMs0aHb93FD+mG8MN+TK1aWJ2g97itm8hLHFhXy0fWX98yCc/JVwnRQ9LO95x5TAGnnTIMaXFWSwhr21Qe248Xc5aONKcV1RUykuEDCFWmSpyLlriVrxPqo6/alJEHhhQfivm8U83aHbHRcsqfFgBpLdZdWeQXV3tvNSh3f4uiZ1TW1Kro8Wmxf/6zYfBUGbpyAANU4V9N8PteITwoeyR4S8UF+rVqsApwuIljLBI4vKydE4t889/MqX3xnnVdW0ImpWGhZM4QJrZFebNxFfXmUu1ZaNpIX8gXFFuTQnceEPxNBIntGxKF7NGA3uymjtRCLDSashfq14+9W9b3RkzStdf/E6h/JNcCttBe44xargw4PuFvMUlnMrP5Nf8m81cAx6+lrqGZGYZC/J93OUvx6iMRajmJCqozgZcow+DnvDr9tfjkNnOxrl037tmrpy2pp8pQ5pk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80b149c-3ecd-4cc1-14fa-08dedc43bb6c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 16:21:00.1436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHvZtb6PtmsY1P8NEOpALDzwNDdrDH42t/VLx60/Tlq7lNX8WkRrL/gxE8Fjvg6v0Nf6iDG4DtWzaaZskH6osA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6501
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_04,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=818
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607070160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDE2MCBTYWx0ZWRfX3sqxJAOk6h+H
 zvow5SpxeEahy/1RhkL3KEIAF67PRtYtYvtpRR2t5hZWmPZMPxeDgWAVZkVQVdD+969418q4zyn
 6xd23cezoSq2wlP7d7Sr13YDCrNTOd9+eoKkwUfI/JMKHlJQDHNAbMtBEEDfdco8hOvUiecZhih
 Zs+gRDOTB6YV8BcbIvHxZWq0hpF0X/2On6IQGse1vlr5CR37JhcTJpEMO+en6yAY9erxEz8Vmq0
 OwxxL0ql4sNEZxZWR6ObUSjnAZEkCWxbNbVJsZNQDZH2i2kqBiJHgBxVCTIcD7y6D8lXei7jGs2
 SpdPJrLEmpfI9DU/2kvsRepyq7dll/KKiuE92spdmhZ9UJ5zcOvxoqt6wDvmpR3Zw/mpmjGJQEh
 gT2UCp/abpfUO4ODE6m45m6ref98ZaWYsVPlrO1dVBlXL1QTk2BYbEm8nz/3EPe9pzB8KeypylL
 KNepao0YcSjkccEFh/Q==
X-Proofpoint-ORIG-GUID: ge-fK2pa4-sUkFctOB_Qzi-B-FSiTi8R
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDE2MCBTYWx0ZWRfX5t7wacjMh8+p
 amD6F3/55tG+75iYnwIjsLZJN4H2U2PDfaS8yI0rdmlsDYu7W6zAq/xc7HLDFZ9pDnVME+0RBYj
 U7KsdgfrdsQoZ7XJ+ojtdJQfJUpev/LKGtMekH7MLjzN/NqPE6s7
X-Authority-Analysis: v=2.4 cv=fdmdDUQF c=1 sm=1 tr=0 ts=6a4d2772 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=_3ukxbErcNWW56JuW_UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ge-fK2pa4-sUkFctOB_Qzi-B-FSiTi8R

On 06/07/2026 12:35, Abd-Alrhman Masalkhi wrote:
>> well it seems to be that everything in the driver is split over
>> BARRIER_UNIT_SECTOR_SIZE, so is in effect a chunk size.
>>
>> Note that atomic_write_hw_unit_max is going to be small always compared
>> to BARRIER_UNIT_SECTOR_SIZE.
>>
>> However, can you check the blk stacking code to make sure that this does
>> as you want? As I remember, for stacking we take the atomic write limits
>> of the first bottom device and then stack the other bottom devices and I
>> don't think that setting atomic_write_hw_unit_max in this way has an
>> impact - see blk_stack_atomic_writes_limits()
>>
> I checked blk_stack_atomic_writes_limits(), and you are right: setting
> atomic_write_hw_unit_max here alone does not have the intended effect on
> the final stacked device.
> 
> Also, since atomic_write_hw_unit_max is expected to always be smaller
> than BARRIER_UNIT_SECTOR_SIZE, 

Yes, always expected to be much smaller.

> it seems that there is no need to set an
> additional atomic write limit in raid1, or even to set
> atomic_write_hw_unit_max at all. Is that what you mean?

Even though we expect it to be much smaller, it's good practice to 
ensure this.

One method to do so - which I already mentioned - was to set the chunk 
size to BARRIER_UNIT_SECTOR_SIZE. You were not keen on that.

Another method is to set max hw sectors for the RAID1 device to 
BARRIER_UNIT_SECTOR_SIZE.

Thanks,
John

