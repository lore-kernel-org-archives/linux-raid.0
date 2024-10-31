Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530E8198E6F;
	Thu, 31 Oct 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368796; cv=fail; b=ipq5W72aeyu0WF7aLESfQYGITdGYMin+Yoz2wbBYo4lG2p2LQjzjGrDhMe04iNbK4eS9kpim+PsWXCwg7c4a3x3GHzP77Gf3//TUrfMGkB8A0M8NfbN8dZnLvK4LKBmUI4poAerjCxHHisM8/JZwGZ8ZZZrODJffov7+MNFx0To=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368796; c=relaxed/simple;
	bh=ETOzPuqoqEfEuMWJuPJkO/ik9DAxJLhvFIXkXvvv6rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YNEbzvSa0jzbvnNNg6SHdJWoOokmcUF7mQlrlnK13X7t4AmmsV+S5dstCpdf/2+Ee5CuWIzd2YbmMn6nX5P+FbJk8dlZHN4tMZ1/yxnmFLnaO2es/v2FOwYVTivmrB265H1r9IiyfvmD+AqNKXofvwJu225uy3x7Bl6XxrnjBaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O9xDreko; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bM8w2doc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O9xDreko";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bM8w2doc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8taRM021893;
	Thu, 31 Oct 2024 09:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JSW0tMVT/UtmEnJkgzaxHO7fXwcCXfZENqI01ubJRvQ=; b=
	O9xDrekoAzZ58m3V+vjEXrkjvq10pk6bRAx5ByarDL9YD5o3ljyntcMEbqfhoGJb
	pveHqQRJkZLO4xX+URimu6oh8Ej0LWJO890s1wC2Azw/gswM8AQjF8wMyx1omRWP
	ffDJWQLzty3/qHgacPgoo9rc6lMxkA2ucFcACgFcVCSXKj91o5Tc/6tZtTAPMhQB
	5tQ7VhXlZhrDosbdwCanC098Z31WIDGx/C86L6bcCSCIUhbRHJL1gbm4sqo/4EwU
	jMRo8sviILgFVcgoM7cExl4bUpszy+NyMnblGIeEFdnwVndfW9G7uUVio3uI1ju+
	6Wahs9iwqlI7iWqd7pcV6g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc21tyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V7o0c7004797;
	Thu, 31 Oct 2024 09:59:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2wseth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DnmhBizG4Hd/ygGbMDA4eFb+3ADZ2ejMaOcgVZuLeb933TgZfsQ5TFU8sqxG0v+icK0+SfOaScLiISMDuu8q5ee6smniSacIWPuWqL07/ZrI6Z9+MBaF+a5qaWXRe56krOk+pQZCjoyGw+UX8xVSm3LHNRbSwC1aOX9HWNv1DXfv/+uc+Wm5dLKpbz87QiRqNeq5pD5QQurj43D005xWlSBYDnceoWonnxiKvTf7+SO3gC+mQqR84j1max1Zz8IpWaD85wNVHDDbmemQ3YXIFQdN/1pN1EPBfchOBJnkVx28k4WRzi1cF/lMu2ShZLzbTpjlxEfmqNl2hxqA/uKB6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSW0tMVT/UtmEnJkgzaxHO7fXwcCXfZENqI01ubJRvQ=;
 b=lT4lAp9YhSX7Zo2BUtow6DOHAKufHS2VP9ryI/v9YYmjPf2iT76KbZPQ5d9Ao9tC9WEvpfPmjIbvFITrs18SEh0ceCgb4cnfJoypvM9JE6GzEm3qlLM6jZyKK8Yt3Veoe8f09YfHKKHr4bMrb4S8T8OjaS535zMtCqGyXDr2k54ZjHH8MtAxg3W+qAYEKGfKGaEg1pNGQ4DSgFAfxZzJ3aB1xgZaLdlzdoTVz0E0Uk1ufOeMsoqdNsuiyOvBzV+sEFd6Wp8BxE/6WTdXTW3QOezgFutAGM35dj2Qe5Hi4LLYFg5/RvhqTkHq3owGiMSnddAStUPCEotyx3+wv66NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSW0tMVT/UtmEnJkgzaxHO7fXwcCXfZENqI01ubJRvQ=;
 b=bM8w2doc1xj2X6O/HXXd7Jair8MXPFWv3P9NkTic0RfOwyJIEQnTBNrCjdsVl2MxDOdHOV4GZn4NgXKyclQsVtcuyTK9/dPEcA6Ez0SyE5ZbKyzjGSAlG2MCNMqC03zvYVEyNCQlNqT7rZpANDNV7p2FbRZ71obe9X30chsBUOY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 09:59:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 2/6] block: Error an attempt to split an atomic write in bio_split()
Date: Thu, 31 Oct 2024 09:59:14 +0000
Message-Id: <20241031095918.99964-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:52c::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: 4051da85-6149-4709-cd0d-08dcf992b6b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vTQgl4jlzlKb+Gd5oR29Iy99Ba5s7+eDUb2zVlIfhB7FbA4/++WvI4rwZOKc?=
 =?us-ascii?Q?DJCP5Gi3RmGUO/wmEF9MlQAAYBQRCa4PiRs0mqBt8yul2Osf3fBFgIZwlWry?=
 =?us-ascii?Q?NmyQ2SjQpifYHWTS3MYHRSBktPTAU04XWbkKEcYc3nlSzUSTAAFeeBlrhT9Z?=
 =?us-ascii?Q?7zz+7EIsAWk7muxqu5epOwIxNpzHrnJUEDHP1v19p3cZ75IG/u+vyrBZ24J3?=
 =?us-ascii?Q?+nTwg0n/eaKX6cwFJNtqJ59OAE9SVQcqN+QWAURp56ZL0Jk96ytOdzT+ZNCb?=
 =?us-ascii?Q?dX3zElUtA9eXFoPIk21zfA7H2EShkKo1vrqwkB+A7OPgW+tT9KbBGzczmnL2?=
 =?us-ascii?Q?3164GwH44vKfWckrUvu0mYG2SRp7Nhti7H9WwEHoY4C7CeeJQ5U/uMOKd3TW?=
 =?us-ascii?Q?kae9LHw8xVO7FnHLwX193dCINdjZdPflWoCEcUtTeSzZSjvpcODO5GrJ8pXR?=
 =?us-ascii?Q?JG5JQwaDG/5bNKhXNZbqUuiRv2a5ubNMKXIthfxL0W6Pa6jDWp0PEEVdCurj?=
 =?us-ascii?Q?ccEh98sQW9OhkXuj8I8wuEdP9zpKhKYF/qkGB+zQ9lLj9KfbtjS2gkOwIxu+?=
 =?us-ascii?Q?Y3qmKwENbw48ZoDFHhYmpazT/W0OFzPWjkV7AhurvPbb/kuA8b3313As83yF?=
 =?us-ascii?Q?XfsPGDuuVFZV/8Cow8r9yx6NR/40KmUR+51g3h/LF28pyRK3lGvLbyc/YcB/?=
 =?us-ascii?Q?iQUZexokPdrKVTvhNMznZqkKzC4lWn+Q4H5b3NbtcLhxzkRPGuZvGKy8XZEq?=
 =?us-ascii?Q?LFBVtMKB+HQR4zLd0Tm2eNIDlmcfFNAHyt5yJQmDSEOf8wkMDQcHHsjzm+fT?=
 =?us-ascii?Q?JMk7Rzx54v8sDDvMWpIbg+tZqdOFTC0y1z5xnt2/VdJUkzUxNiwwJ5Kd2bsC?=
 =?us-ascii?Q?sEPEG2akFb9R+8GW0qb2D4+ExMJ5BWNhCG5iiQaNSeoyUcmL8QjnoqITePjf?=
 =?us-ascii?Q?wUVSht/obelS1GkYc/wT8K94eJBKetJXXv+dR210RxkMhRciMtJhzjthD+0Y?=
 =?us-ascii?Q?YhpvpD0e6hXrEmpdbyl47n3KjUGN9ROLs9tR9pEBIWfKuGfHpy3lD6cukGmS?=
 =?us-ascii?Q?7a94ZmUXwz2PpkGFROOBMOHDxb9vyOkuHkTEGxx7oBeON7ohuXnl0gIeR1mS?=
 =?us-ascii?Q?tXEBx8hpkdyXQ4i5fmWjY2IpF028jhL3UzU4jG9w+BGJuEYevEYnx9AUHLw9?=
 =?us-ascii?Q?b0oSy0wlWCafWk3hXLm9VWs3JONx9FBR45wsUahg8lrlKbbfpuktDa6q72dD?=
 =?us-ascii?Q?DdWTFp8yEhadSUUpijapwIGSBX7NkH0QbalieymA9m/KUYyFL09lvJkxEUqE?=
 =?us-ascii?Q?jS0SfodEJKV7G2vlVnT4vupW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GkNNuOEaXP+3y1ku3qfxHtf8Hgwp//BnQ9D4EA0mrdhK9skqXbyjp+1PWFhs?=
 =?us-ascii?Q?XY+18Un7kWlR5yhxZpseka/dAIMsvXhDsv+O+PRNI/7RJncBJiT/1R0xsN01?=
 =?us-ascii?Q?q4CyClOZxR7Vg5nldDR78KTl9T7AI4TgtyJHxGczSs2/0RfGQHrMQGTBoC1z?=
 =?us-ascii?Q?Fb9fxeBm9jQag9PRlVy7Ba3ThNboQxNLxZ0WvYg/Y4Fhy+B687cn6UO+RFxx?=
 =?us-ascii?Q?ztPcPkzwExiWCGrcPMpuNDG08UkQ5JH+eDhztULHTJetibE2tkKY9qvTJgfm?=
 =?us-ascii?Q?GChnwJPuklZg0IbU9+WNILzT2W8dqAcMTiQzMlixO8nB5biW84JR2qMqi54g?=
 =?us-ascii?Q?kAmaK6pAz9B867gnV5diQ9Bnk8y5M3TB57Rhi5Zc6SsJVYCgQ7LcXW4r9/YD?=
 =?us-ascii?Q?AhkjZ/WbDM4qnUK3EhPs6eELc/PQyMG7TsauUIJPz7xXLNSoMkvSMhe2b6Wc?=
 =?us-ascii?Q?AQKOS4LNkS4p6SvTzahNBgNyUMLM3t3AVnQMKhf4dVnBLWS43WdYJ4IgsX8T?=
 =?us-ascii?Q?7SEihajsqNMiZecAfd1btCC7SZW2Gsz5F9H2xpeIy71RnZNcbdfxk1c2l1Ji?=
 =?us-ascii?Q?4Gj3KOwh2rrE394FgoYmPhnMJA1rGll4Ebkc3NoeWD1DpflggELTXJjKMZu5?=
 =?us-ascii?Q?3+EFjFtBQbKgWNMGIppYNtPgrydiGCryKQtAvUZq6me9Wk8PhrjwG7EBncNT?=
 =?us-ascii?Q?r1yDSa2gDKdW6sVUOgGTB9TsPjlV8/OZ3htE5iwGBCp1iMHUofZtA9Z6H6RA?=
 =?us-ascii?Q?llc3t48yHdFYAM+agDWl5Lrnrtw6g5usiXD8jDfoC2gGTqw4o7ptjvWTpp90?=
 =?us-ascii?Q?3gTh7miUO2WOx3RzmBNKSCr7l3+S3i4yVOZhPudy3cK3CstwmERmmdE6O75E?=
 =?us-ascii?Q?gQl0r/OUS12AF1uXCiBVVvjFIfjn+L2XfFSt2SKfGzJZcs1jA3ZTydkQAjgP?=
 =?us-ascii?Q?3ZXvrf7yU2ZuvAVQzE/EJiwgc/4iFmHpy8CdRlfdWp0UHNZuusnd0P8lL3sK?=
 =?us-ascii?Q?QGEz8chs40RfmARe23YIjUjY5MMLlDMO+BLqM5iHWTiK4D/JSeH4WsPa/t0s?=
 =?us-ascii?Q?OhPkqM6SI13QQrEFFEaIgzraiqjncFXzrHER3e/gAjkXdEftWiOoc4/nUyGw?=
 =?us-ascii?Q?ZXcsk81vkgIcXBhSKOMUwspUvx+b6M1ekKLsWNSqbhqUuBG/S3ovsGsyaIQL?=
 =?us-ascii?Q?db04BbVy6dklCm9/61aDsq168Zz6wyypLVwgc+VGGyKS5SpmuCwhjAxQQLUi?=
 =?us-ascii?Q?i1LQxjL2Al+t1bCw5y18KnRbfpAls1VtKhytgEzx22/KaZMsyIRephBrZYJL?=
 =?us-ascii?Q?xakQswX+A7juhm3r7pCgl7NmIRZnFcPRI+g7tFAKnuP9NRZG+vEwVmAtRrG8?=
 =?us-ascii?Q?sQLhXtGQS1m+bhhpewmtqL1j79DxLgltIKnbR3VkdfZRDuoU34YIlVG2m413?=
 =?us-ascii?Q?+tuAtMp3LM2FDzJ7dXPGt7UYsPf7z9uBAQy6rRBpp5spS0Ex+lnp0aa76Hbm?=
 =?us-ascii?Q?hmqqW5vpcmAazmToGZfASkr/veH5r96VjHF0TQxje0U3z9ILPPCBvSf1737m?=
 =?us-ascii?Q?Uta4tW4C7LMku+IMZ740j2toPqkxdJXNWQ1aQruhCmJ/WxclfVKod4fUUVDp?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l/pNmap4DZuC3kvadCwqxGqLH6nPI78lKXFU7mpViU+61s+1pRV0dutqQQnEraBaQEh4bptkPNRS62R9EjRkYFE1CnOgmyk8NR664Up2PBxGVmpOLvmK5L5Pe30P0m3Xo/05meuBBjUgTsEuE+3wrwqNgExQtCU5MTGZd1PNPbDnWxeloDUCFfb5X3yNikP5b34vnw9a1bgqXgI5DPEg74PySgNL0PpLTsd8lUPKX7eh6Gk7LQJBVsvDttHxUWUTP8BM9FGsKc8Btowa3X9OJ332YBW4riFcw9A61BWdRZlVlDNS47l8fjFg9YpSEsej9Hg6vBqGdAz4QYX0FxlhvcvqNEU6hBI0/PJRnwNr+q9cSkvaeYkWD4UVmLVPaxlRvJhtXY+5cO+Thjp+Tsd40tp0AfOXkgN163l3bppW9rCjYLSWeE+lagFnxkcLm/kky6FWUZHDH7QiCPZJW4cOYLf5XsODwARxEPmNQdQIvQ5u4YamhQ0JZbWDuKpSJZIjj90+PQebA0D+sUfLMBj+P50GWzRELg9u62iUKLvhspX50dk6pL3WqHHzUJliXaQ1EDDOhSOcjPITgMXfqvkaovxTfELUB+5jOvsSRf8fgTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4051da85-6149-4709-cd0d-08dcf992b6b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:30.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4pR3UXz2XiIWRlwMAT1Kc3SkC8Z1KL88Wdmjy5tssvnfIqVjOyfALA5zwHhTCjetQAvvhwYr03wpwDjM4pQpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-GUID: SI0wtIA0cGR_2YF-Xr-d6pJyORuW9xkg
X-Proofpoint-ORIG-GUID: SI0wtIA0cGR_2YF-Xr-d6pJyORuW9xkg

This is disallowed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 7a93724e4a49..07b971853768 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1749,6 +1749,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
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

