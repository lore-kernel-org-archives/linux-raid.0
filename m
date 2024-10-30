Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDAF47F69;
	Wed, 30 Oct 2024 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281936; cv=fail; b=WnSvZQtfK0OHIxmVSaPlj4+hRgrIJs8PB9CtxegQlkdoqymsiQsFuhN3W104OO5C0lYabTQN2YMgss3v+3opZMlAxDqKHKPe86WypFHQgTranu0M0yUNdVF9oANU32GxREVxIDqT9UysQSqbJL9PFN/W51POdH5xc6zy8dVMCw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281936; c=relaxed/simple;
	bh=q9CWA4mZK4QadNN4rv2hkgl7Dm3kao3I/60sa34mO60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=suHsTfTW27bChzoL5VnD75z3OcrH0wd9xWTE8fKkZqnxAX4PnNioK4K2uVj6bmcpLeGxu8G9d/nzJwhxnmfAcyB5GoQVfFkn7oi2VnJLhIWhJV/sI+uXmSRTLK1TbSbIQ2CSk4mkF8vap/lnXuA3xWIVoDZf7WI2n7g4vcI5AOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K7dAG0kh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yxoRMgkD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K7dAG0kh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yxoRMgkD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fgvt009049;
	Wed, 30 Oct 2024 09:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gvOBny839wNrSeq0rhAw2RAU63b/Fkl8E5af0+eZAO8=; b=
	K7dAG0kh+CFURpSAwSavUZWoAkvD11kSUgr455XU6/2HCMklopui8tYP+4STwESh
	N3OAdiLVDTYU7ObIRJvSn3f05axI2HzF/eZn+ZJCtlHlZteIPD8qCcYsZWAPlp4f
	HEfrFu0LwmRY97A6OYR4SUnvXSwnafnxrtoZwSU7zbRHva+F4LRFisdAByabXhxQ
	3SDHVjIEDi6PX//RqH+ibmKZrepzz7EtYjSSF1dcKBJJvbq1IL47UHVy0PZe7Fhj
	9LROOMu0Y0onZxeabqmS3wq7wpOKNEee13qTgz5jMhIZljaUi9hAFjW7SP8lmcAJ
	Mqtxa7rO3Tr8QiBp74IeXQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdxqkg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:50:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U8txtj004866;
	Wed, 30 Oct 2024 09:50:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2vfsxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:50:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5zqXDcfuWKbJHg12c1rYon4jfTnj9coFbxaMNvvM8hvTgv6VdwUfqUGTMFU1Pjd4+Q8ZZWR0T/haxYi73ASzB475RiGfaHrmBn9RVsk6GEXpfvj9cnMJyG+j7I374u9CpaFc+vdsxBbWFudf7XgORVP2N19DxGPtd8sKeuHReIRLTo0tP4J3yM9QtvQT9Npx6Jcgvyh+2rLlAuv6QIBm9c6Pz+svFrdsI4Hzhv9Dy3yllVswLUtWhVADCKzPeC17ApVLTiVV19MtRGnQrmZB/V8nWKqYLgEEWOL9NGqWvgRru7lzpe3JNjAjx63tIOdQVnx/gkAjngCcgqg8qKMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvOBny839wNrSeq0rhAw2RAU63b/Fkl8E5af0+eZAO8=;
 b=ykJ9zgckO893OrG34gMInPzZPP8dnXVqmodZpOTYQudBBTyoRoEukqlFcoM/19DH7DO19zfNB/EPTtMrcXZEiKwoalKgDkyySR16mCIk446bxJ3Qv2l/O5sgt5+st1YXNPNsZrMOPBQgm6dL+6p/ZLHrqyTMg32JrS8eH4ABgTdzYGf6QM2bQBNYZUQ4vrlaU/mcslvPwkiHRW7JqLmlprqX8IdyoDI8nryBuw8fa/FZkvH3lsaXbiy6rlqeKQimJuUqiQ6oQky7irppbI8K7GpPp4cge86cgD8hZtvFTAX/omzbOIyoF/sWiYUkGPXILeQ3RqawfXL6FMDFOJ890g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvOBny839wNrSeq0rhAw2RAU63b/Fkl8E5af0+eZAO8=;
 b=yxoRMgkDnSoSgYEqSJKmrZKB1jc7u5XcKh+hDKvSmacXQ9Jo3fL3RGAN/sCV6KO4k+CSS9SnNeV+gj+TS0rGH1LTDAnXPK4CKCKGvFJKAqUMH0IRBkECzb5Ak8d/DZ3cS7uQkZL6uoT7Vt67OH8QGW+6icbHNVAzfGHOcLz7pXQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:49:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:49:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 4/5] md/raid1: Atomic write support
Date: Wed, 30 Oct 2024 09:49:11 +0000
Message-Id: <20241030094912.3960234-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241030094912.3960234-1-john.g.garry@oracle.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0057.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: 782c2605-7117-46a7-d7c7-08dcf8c83692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UZn8wC9y/cWVDYFJWrkLk/AzElRD4v/6GVMSNzrJu6853G3VJpeIv+Kuuy+w?=
 =?us-ascii?Q?2sSPi937lFtQkqN2OpYy0ibWAY1OmI8dn8+UQa7XxlcwzMdBIdqDl4g8QmF7?=
 =?us-ascii?Q?l8Y3slE1ISJlxc2dxjcSU2bBmvb7ByCzHesyLaucGFO0TzKUeqXR5GXecZh9?=
 =?us-ascii?Q?RG3K/2Sj22LtyO5mAQNvOr7iVcedwe82u9jxW6a544QUjhwxpnF69+2F6UnA?=
 =?us-ascii?Q?QvL4eOarfDSthkiaMgAt+L18qMirxDNjvYan5/ZevEZ1QkycxNqbf/TGUGBn?=
 =?us-ascii?Q?WykbVlwYeLyClJb9GVs16SzvFf5YmznFSg5bvnXGKc+VznxlEa91Aa3FeRWL?=
 =?us-ascii?Q?ip3+0cNPBDAAG0UFEh3ITk9XO5wQ+4uhPJuLe4KwrGngS21zi4BwDEwfBZSX?=
 =?us-ascii?Q?snCXfBQM/jv0WW6f0AYzag8EAfqKrwVTzkJuPJgP6ecLsL6pC1MEKqUg6T2Z?=
 =?us-ascii?Q?MIzR/EbKM+4EH0pT4QGLefIABBla2O6dhy1NJNwCCqNRY1305BcI6QoZW70O?=
 =?us-ascii?Q?5xoukumzePYYElqaKT/FsCISsn2naiDwyWbHmsMc3hPQ/SQVVlF50/+Yied5?=
 =?us-ascii?Q?AQvQJ22FQKzevLCLJ6vjkGa0alFenoknRFgWdkVt60eFR/cCycBBi730nI5f?=
 =?us-ascii?Q?YFsjqylc2ipZQOX8xjFaaeslQazW8EMP5jVR4varOMQ6Q0l9UKvhY5ojEtG5?=
 =?us-ascii?Q?PHMm2VE4dM9ezTufwvcxzkoDMyj3O5rlS7qSRyF9L5JH9632WNYo2jiDxYvH?=
 =?us-ascii?Q?aE7yQ50qtWKT/zlN0BnrqMrvtfPnVT33v1WOP6LdHGT930/E/qRqsRxuCzsM?=
 =?us-ascii?Q?iMlhGf8b0OTEIrTB608QybUE4qYN99gXJnndL2x+AavMNqA5E7yuaiUMgo6I?=
 =?us-ascii?Q?dcEtNkk9LR44H6pjQ7bxgfwSn8oVIT2SAGQgemf+3GKkFuVY06HS1VZa1euY?=
 =?us-ascii?Q?PjVQUZZjbYdtAtcCg7w6onIUhbksjEF1MIBkuwHtuQQ7Vp5exykoMXosbP65?=
 =?us-ascii?Q?HcDI7s+RK6/JJ7zNeQ/wE70vvdgz4NXi7jqM4IipAgRdGYV3EXuC2lX/Rlme?=
 =?us-ascii?Q?ubVP4e7UkY7kXNCMo6aNcSiOSvJRh20skQ9j1FNTNQ8zezHZjweHzFFYRT3m?=
 =?us-ascii?Q?shH7irARePrHJfeUvIcd7GirXI7tT4TareUajEVWGr+VPAt0C2sfE3qwW2Ew?=
 =?us-ascii?Q?HdHLgPn6DlU9kWHe3l+OmVGEzEGU5ugE4kHQf4A+dQgGtpZJ85BNKn8KjMrT?=
 =?us-ascii?Q?LhxMocfFfWdujE+URFhf+9JcQX8NkiJVfOrV+mYd5mo2p3wRZLaTT43RDLyh?=
 =?us-ascii?Q?ftcSWMG+1s8+tnhZdZNnN1EI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dmhIqKCVeRFEM9qCgWmcLpYcDrnikhKUONniN5IhKnC/sw4od6G16pjNTOVm?=
 =?us-ascii?Q?bFUMFBpL7iHvcKhhdtTKkjcpc9vPL3dPMOrgFknOjV5/GljLBUgPa9eEK/VY?=
 =?us-ascii?Q?8EHpF4WufhNeYykb9y/tnqqm2iycnr6JNWOBb9LMYY275aMzENQdkzNHu9e3?=
 =?us-ascii?Q?a6Zfj6wM4m2/hk4UKz70iDtBiyqEHqrmy9eCu9f8kkWwHAfHC+rgE7k64huy?=
 =?us-ascii?Q?0c4P5FLZUcU+ikpYGaFMr02YPvYaHVTmT6rT9Ka4H4/4c6DKNXGe7OkCr6Dt?=
 =?us-ascii?Q?SPFcBpNtUu0owLW5EtMOgIum6JQbkhthd7zbIqcNxXDza4aj5hs/NtAv4I6R?=
 =?us-ascii?Q?H4pFu0p2LlQ6cTZroOYsbwdpReX4CL0FOTDjH8NTfbAGN2dmWkf+uIoRtvG0?=
 =?us-ascii?Q?JlTHNYAqqfV4xjdPy2nK6nFUIOQhqjtjUcMUTA5W6srj1PwsGClbTrl9sn3R?=
 =?us-ascii?Q?X5etA9Lja5XaYc0aLKYj6OJbW51nyr7vmrtXrg6CmMaINE41Q9do5WHXGrxK?=
 =?us-ascii?Q?3HBijK7bO6MbJxFKshFHTyVxnSZFDS+N56XGNsmLQHnWrI824VnJmv1PozJO?=
 =?us-ascii?Q?Efqk7cWVlCxq12+t5/EPk+/7Urh647fHYtVTZXS2vpuhXRnjnkCcRWIpqJWk?=
 =?us-ascii?Q?9H+IRKxzdAl/6CTPzDWdf0bgyOiqFyHGstSX/mZLZhzf2z0AB4W2y19gTiDX?=
 =?us-ascii?Q?ZTFLVo+13+HM9618CSRz+c/177fruHX15StWBz5CX+SLhd2olqCWxxuaO9vn?=
 =?us-ascii?Q?IbVTxuyA10OAdQ+2GWfzjTwPDTBrMPkEtrfmFNZB/cilxfkPiAjfxFEgcg6S?=
 =?us-ascii?Q?3fOvs/RMOZaZrItGmuZ2e2b3RHYkzC0BJyrsJ+g4anNeKw9N7XiOrGAlQDro?=
 =?us-ascii?Q?foAHJDQ9M7hqx12G28xAa+3tT/wZ0DZ0Jt1JuXmYl8aanHeS+2vQUzwQwpEz?=
 =?us-ascii?Q?IsXjPHH3A6lauCrk+o7jzY+PJSUUbT4z4kAIKkt6A24e7ow0oUVnTiuzCSUh?=
 =?us-ascii?Q?wjfAMuqT9xT7leMrtVxAouZnJBCxT9tDetlIrk24AM6rRCu87K3cNNyW5fJa?=
 =?us-ascii?Q?SLLQzVzQf9sQy47IUDzbxmsRvmTUVPD6ypPshh5BEpejaRiTG8P81dIQouoP?=
 =?us-ascii?Q?BIi39kGjAOC9xczqqD0yiND4g4F79dlI5P9R8qw81bNn4Hc34Aw+wVClo9tu?=
 =?us-ascii?Q?XiddCOLcnGtq4bMnWrz5sKz+o0lPkIjHdTUkiriHnWmoJS1nn82trSkkUsYm?=
 =?us-ascii?Q?KuyJyK1/vzMnalp/2asE1sLSnAhNkIJdrYO6Smm9S6c/RBY//hOAi7fMWTsI?=
 =?us-ascii?Q?RUjfpynECLK7lAaGBJlbsTqU8emk4++S6s6EY1wBqH320IP9te7JE8Cv07Yc?=
 =?us-ascii?Q?3IbmYyhmdW2V93SD2klQMf++xeQIWqdczBNSwpWp1d/VBfIiCNhpuQl6nHdc?=
 =?us-ascii?Q?JtrEcWQYmGW2QPCwOOIcsXP4bDBpIHzVGFGKY8Uv8pTW0m/EvSPNsDUt/2OV?=
 =?us-ascii?Q?Y75zdH/GUPR7PHgIYLQNChge+1CbCBlN42x49HlDSovN/LDRDFJur5NXlgeq?=
 =?us-ascii?Q?f0ABrZFSCpnzBQA5jpuzlWsgDLbfsCc1ZnKTtR51gn7aVNSL3Q0oJQPJgPbk?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HqT7yTL/Ik69osG1gP+bQFyRWg2E4aRWG1xRNIsB3r0/2CMCfvBsgrXFHsGYv8ArHut85MtWu0Vrr9Tu5VdOseXM2nWmbZYUfHok0BbxLALHfd2RDHZhu9HELsw3mbH44x/ZrqquxpLf78ytqJXyFM0K/hDnL04AoT3g3s46nhShblXKCDyiHgUhSVLADol/RWSMXLVL5mwIyLcOZsOLzzZDn1PwpoCr6uAz5Nyv7HXnAA+2n9wIYhF5BDEySnr1RKRWqWZ5TLfMG2lqigzcqdCLU3wLbpddPobZ++0gBtQXoVwcmFQk6WI2lwh6vb9E6v+q9kxES0l6mK1N01OO4HuaDgSHaxIqPoBptZwVCFBdt7nmAhD8FTrrbxiR3+hvIa0TMP0IRJ9ZBZ57D/OtVnSz8/nJRiYrFo8FLiIaYR4LTE1kK6nPor9uoncR9aWf01k5U2Fv+wLuDAg/V3VYYuML7nBmphe4AZs2V2njzTsPYsQLl4gHEkheXXv28VlHUFFJFx5cZHRK14lJjluW//YLNqoRw40Imzn+lvwdR4FkVIsGiukv6Q4z6HVODRbE9yPMALcWEJhbzATcSKXV0E+lTy+7La+3Aa07B1y4fww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782c2605-7117-46a7-d7c7-08dcf8c83692
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:49:57.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOeauPkfJP0Zu4bOA05swt9U1GENr4JRIUN0NYrpqcWcg/H+whtcFn+oejcf9FVF6WyqdA4Bp2psNLue4XdeGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: TDv-IA9scr6s_QwWAvwWQjou0uSf_I_x
X-Proofpoint-ORIG-GUID: TDv-IA9scr6s_QwWAvwWQjou0uSf_I_x

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a10018282629..b57f69e3e8a7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1524,6 +1524,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				blocked_rdev = rdev;
 				break;
 			}
+
+			if (is_bad && bio->bi_opf & REQ_ATOMIC) {
+				/* We just cannot atomically write this ... */
+				error = -EFAULT;
+				goto err_handle;
+			}
+
 			if (is_bad && first_bad <= r1_bio->sector) {
 				/* Cannot write here at all */
 				bad_sectors -= (r1_bio->sector - first_bad);
@@ -3220,6 +3227,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

