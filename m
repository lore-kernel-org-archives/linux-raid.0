Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26E198A39;
	Thu, 31 Oct 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368795; cv=fail; b=tiXPioO4Csr5B8EGfJf2EaI96n3ZuuGqqieA0MTNd5SWMfXOlyu85qtX4adfOw4iW4RM6u/ErCRcfd5WdqeTFmaBQjggF9qb8tcX2k1ftJRHMULUmT8Pzt9+4UuKMCVerbSWWQ5dhAyYeFo8wHlGg/oWHlLkj5geaNk0OcgyHjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368795; c=relaxed/simple;
	bh=0USIRZVpezm/X62HP1KGA+g5Fu8SGGeC+lFeSf6kW5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pb1y93H0x9sKTLYfHFuQqMpOtJOxGboUQQjlWMFf4e+ktXGX8kSM2mWACmyF1GH6yiCo+MjG3sZK6nKz4YWKUHJ1DZcxpQO1AWFClVtDLo68D6N8rIibxmE04OODmANPGXi+DO474L54rD7okXu3qKsJGhYqwx+2OQ7Ko3g54t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dA8rh+1X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vO/JkPda; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dA8rh+1X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vO/JkPda"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8tXpg023668;
	Thu, 31 Oct 2024 09:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8CTkAiAm3wkP0fnGTSU/PIk4vtwjDT8tO9VDip3utlA=; b=
	dA8rh+1X3lj8ztJedbxILTMr43lq2ehF//gLshXlZNp9zPHTKD1ER0wcOBf1GbFX
	k3pbIvsf+V5+fb2xTBFWN/5qx89bk9OChJuMkbecwrhnk+EqcEUVMxCAEJE7QnuQ
	Pk4EXlgXi71TYDEAZiIlvazc0W405s3foDOriIDaYhCeUVh7pNNSU5SsC4vOUk1w
	QSWfOaS7+21AqyNZmzPAYAnULHOzOAIqnjDeY3sM1b6XZih4Rkx4GpIil/9rCRFC
	DDkZJS/4wOlxDTPTDl0WNiJoTOLe7rbucW7tMzPfri7At0m/EZp/taAgXT5aU0Cp
	rZuVG+6gIK3R7+4gWrF9og==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmj0t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V7XVSM011848;
	Thu, 31 Oct 2024 09:59:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnaf5vwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rc/kSVDSvk1OPtVbKdvSdyJ+zLj+5hEMDpm3eKoPClikv8YxqXi0DZgQQuEMMkwmuVVtm0GOxfx1+NpUSHiiNZ++ueIVJ5chVa8EmM+3qA2to2kXFRJOayNYvYdljktaMxvarmhP59Ljy0K3cA4T+UxmBxc2MLDHo9nCstaAEsI2chBs8uqQG9+4MQnA/S0eAeKn5QAXKOyeA/w/JoBzDBZqQbhOub36uyofgDnpJpJ5xORtO3Rmv9D2H+nlRGkyaEGsufq8e6gQ2/W8yRoP4f0dD6nTVG5ytFgPm81DdwRD8COKmOS7cXdEAICpz32CJrhp2bCn4snCfOLBtr+U8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CTkAiAm3wkP0fnGTSU/PIk4vtwjDT8tO9VDip3utlA=;
 b=xfo5bom2BY0rLseAMpFPpAICdadQ6sg9lV6qU0uasyR9cyxvNb1myInpaZkHX1PbBop/grLOzIRefPbfRUDJiLF3TC17NjFVrbMI+caAk8siaVruLOY9HJvPk4cf4KXRcf5pozWlRGA0PuG6v+rRwSdPjmSBxbgoxGYupBZ+ZjFWn3SWN4t7E/B42QVkzB4ReoBo7N16MTAZhGUkkqoMaIo2lEUQ5X01OFiEOr1V90dk/FA2ZrVzDOYRrPiylqYSeIhtKDz5tojR6qGElsfjC8GjEU5nAB2mRlmew+teUn+cmK7u24MXQ5sMQJ8Ki53tt8pG+AlcgxqVdpLpfCpotQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CTkAiAm3wkP0fnGTSU/PIk4vtwjDT8tO9VDip3utlA=;
 b=vO/JkPdamVAX5jSED72MpgvvyI9LSsc5V2ezAKDgErVfCxJozV+XC3RH1WrENQc0t6BjhULTnkjy5cJcrWRY/sQS3oAzE0PvISnepXaAmGYlcR5wM/kqy9UB8u1zXvWLG/ujbQSfUxLlefwf41ILtn3fO5dkCagwfPm1wh0XgUs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 09:59:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/6] md/raid0: Handle bio_split() errors
Date: Thu, 31 Oct 2024 09:59:16 +0000
Message-Id: <20241031095918.99964-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:408:141::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: dae6cf3d-f978-4379-9eb3-08dcf992b864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QZyNHwMBFMk8sJ0hUoGEh183mV1a4Vgc9r63pMRNn09MbaO6PKKGLoQUou3Y?=
 =?us-ascii?Q?bQK5uRjiEfpWChmyulJ7MaocpNG4sswrUtUezDDGBJt78Ll6Yo4+Cd5uX+Pr?=
 =?us-ascii?Q?/RL+vW6zbA7bGy80bA8eKphB7qW8Rz4lBs5ug4Y9y126I6qfUMeeZ84PWxRD?=
 =?us-ascii?Q?usNZ5SOLwIA8+/B31/HUiUas2uDT8/nHutuw+6OKYgbnyevqBDPSnYRhsosY?=
 =?us-ascii?Q?9viyqdj282RYe0tcBdbPQ3SjbnjTuTjQP9/k2v1yBu3AHaWdNtTrJLldlt01?=
 =?us-ascii?Q?PcRsdOUMY/tZUKqbbKMUU/lzlI1Bu0yF7lM3w8N6K+3RYYDgCGCR3ZZp81bQ?=
 =?us-ascii?Q?2iONtr8F9W4mS9HWZ3ManI19fuu3fJ6XM08bjAtzwG5MvipqhhfWwDs884UQ?=
 =?us-ascii?Q?+XU9iFnPUdU34yuE1BfzVeY+yha/Yn5JAHWMh+eoU+Mwb9nQwLw89UN4yvS2?=
 =?us-ascii?Q?rMNinZHI7w13hdwpH9XcE0QDjj3M7GGDdIKJqfPm+WTKmAcj2MhaTF2j7qct?=
 =?us-ascii?Q?i+TNcHU3qkwN70l96lbc6Vc/2WSJYqb3SlcQZ6G7yJvFDnBbS/BjPQTXyBsA?=
 =?us-ascii?Q?437rS+ZUF7Wt/kJAmyIRGGVI46hKxAJfur9rN4Q4TE8MOLfCDB9yeDxOCjZm?=
 =?us-ascii?Q?iUIxFDI/NfxOwnU/cE44QqABiavTGs4ws2w/AQgUWqzcHG7WShPe+1qWcnJN?=
 =?us-ascii?Q?PcC8aV3dsy5ff7Qx8cPacZXp48RF+TiWD8z984ZrKtetQbTZ9ZkgIXD1LniR?=
 =?us-ascii?Q?PYk54kMl4t0HPqLzRowsGugDIeBocQDkxGEisppnFnvY7FN1VAxcQGX79o9g?=
 =?us-ascii?Q?bS8GFa8TaqiE+yT2bMeD1SIKA6ZvdNdCni6gZNRniFpDR0OTV/UWGa8MWDMl?=
 =?us-ascii?Q?901SYuSe8Db+3Tgn20XmRCFd0GJ9Dt0vSWFOeGVZNRWyIG7hpFXFT7I/0akE?=
 =?us-ascii?Q?CJxfqc90z/yOrbiWwW4l1JZGOsJ8HRStsJZSITRkr8lo+SPqm+U9Rqip7Txf?=
 =?us-ascii?Q?28lMDzz0sR0jteD3xTunvwntGb18TQr0IjGOJJGjC7KNPlTzKABL9UCRgdfz?=
 =?us-ascii?Q?OVrO3lwaqZS6+EhFckCyD5fBery7RUdbVVGGa3mEh3NkVaA6vo6QV4q8wBHL?=
 =?us-ascii?Q?f72qyWgStwcQCMipO2v1ikRBPdcZ2Rmu/NQZB/iue9VY5eJeJZYoy00Kzvd9?=
 =?us-ascii?Q?lauy6WydAyErCEZmZK0O94NPbUQYBDHlmFn98BW6mKXO22DtSFMRPoqxw+Fs?=
 =?us-ascii?Q?TinRcK8zvq/KBEBOrNAE0cjGjFtcXKPaTgJSKv+w92ZV/O5ZfiVr1q39d/xU?=
 =?us-ascii?Q?2RE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q5UccMs/nIxP43CQcFIVdGa2eSkGKR0UIWT/dRJ0ZddZnAEAuYUewb7LxYwz?=
 =?us-ascii?Q?MdE2arDn3ByC6egR4c3Hc5CvQM2kHsDWzjeqQspyguzRLH+ciSY75BPzeYFj?=
 =?us-ascii?Q?DoJN/p04+9yE+ADuG2dCC6PB6g1jZ82b/Ajs+mRMNZlIDR+r1hcEpp+Kj0Rm?=
 =?us-ascii?Q?qlxXGVCjEt9qKRDfWyA4GNCAFP/jciN/T4xXlMtJVZnTFcXzWOv+g8879pc7?=
 =?us-ascii?Q?s3B2bsItHWywhX0nYhgfN0/vrQBhd9/sNjtMxTmNgjWN2sZhfNxUtaUH9DDc?=
 =?us-ascii?Q?I6vSID4xpml+SQCxJihVt4fFIf1Ocs80SxWIVAWg7aYR1CvdYlBtJK2jhnlE?=
 =?us-ascii?Q?FSJZCQ0gsEpb8RQupDW18LXRKXzCl2Fhpss4riG7R1xm2fCDOpNM9g7LYtis?=
 =?us-ascii?Q?THbaSHgcC+KoAARejLpO8lLAzNUTo0/ST4dekLEDX3l05SwRxdMEij0AsJQN?=
 =?us-ascii?Q?9JglXpvQ38LOlHuPQlUlcGa5Wstymu2mLzZLToaAxQd9mybgMtkfdGDO2Wj9?=
 =?us-ascii?Q?i2LDi2rPhT8/clbY9HvMCpkoPBupNk3d8IkXfYLrjTc6GiPfSM1YNQSKXSum?=
 =?us-ascii?Q?HYq73n5r6qY+k8Zn1afQzPhpPV1HBdV7p4gc6y4N7kfC+Blo8Bif5++43qCX?=
 =?us-ascii?Q?qzAOJ26gdGw4f/FTFF1ahnq8EyGhlCIMqc4i3f3WRG9GHbToA1v8zxTEVvwZ?=
 =?us-ascii?Q?2BkoGmMeJA0G/nBxH9Yfb2/NgNhqxhTUxdwexjt860SNtIIJeC4oFh468fbI?=
 =?us-ascii?Q?eNCDbIvR2KnKGEH97cRletRaFBXVuOJ3nCgKMDQN8O8snZB7RCpYuAPS9F4C?=
 =?us-ascii?Q?30KaOEErRfLmqVpQOEHQ9LjRA4MaNUKmH5T4MV0JTc4UQ5138QT4qILpDAlq?=
 =?us-ascii?Q?7+bgL/gxQZvfBUC08tlUPpm/auDGZ68epm/nlvTq0lMOhia1+wSru53n/FvX?=
 =?us-ascii?Q?ajNrK7Nc6vJm72DxrEBqwzEKXMeAk/cBzv86LoW33Ik+W0iD7JxB+IFIr3jl?=
 =?us-ascii?Q?vavdHpK2DSeJ8eN44OXd8pPx9VJYQqLnUMO7lBwuaambWajMV/UOmYJj8KE0?=
 =?us-ascii?Q?HgrQUcHVOAxTFE9g19/3nWwkNOiMglFLpZJQucMbrVN26WeXO+6PzxmT8++B?=
 =?us-ascii?Q?tVcIpt4Ica2lzDK7SCqBwGn6aEKmQqKxweKWxjalkNTGdPEMuL66bH4GGbqw?=
 =?us-ascii?Q?x8Q3S/t+fZ4Zyt65fsFXl9MQ/uIwe0LjOrL3AO7gFVKcVoZZ31S02yXKWyMw?=
 =?us-ascii?Q?aUkXeTddgNJ8lnGXn3rZiWKCjE9pfnerb1fiiQ5aIulhMmXLJf1Lb66XlO6T?=
 =?us-ascii?Q?ew+q0aN/1BTeGoh/52mudmPcssSNtA2u23YWBSijVPFBZEvxk+pRsZvSEyRC?=
 =?us-ascii?Q?6qV/gRFXdouTYaZ8faiSNqg6NxUp3XEwyKgqfPBkjEqmMkjo3zfcAskj+caP?=
 =?us-ascii?Q?XdveUX+RY3D3WdbYa7siV2xCtYqmfeGZp87znOY8el0JfaWV4z9ME1qbt1F9?=
 =?us-ascii?Q?vpGJdhl+roteAIW9go/6RyK3D9p66bSYMzIfNdqPKwPzn7FBPDVNImHzd9IV?=
 =?us-ascii?Q?i5fNqYGcYgTicj8wv6ibjgGWvd0iOBI8z3sPzdDSY68TpJumfWgE2merbWbV?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QRBDjpp/59SeKBEBWv35F+O3gepQk95zHA/D74eWMIsqCq6p/TdOaN4s+K2WxTFmIN48uCuPd2rt6FxRnqe4l376aAqnb2JT9/00Fe9fb7zpGfpww6jcQkiuj6/AGDagzHIAg9G5Vba830CLg6UmvHLLC22KN0UkdkxzypxmH+VhDjqHzCrIqxzaLo50SUcpz8/WuMIyT3qTrmdFfMX7eZEkWna0SG6/0DshH3rbB3z87Ljxl1E19wU7F91tb0GztQQDlj+Ww1GtdvFa0qOjP/kKCPubLrslMeBwAEE9CRtfUeX3syd339U97UHFoy3fgxFbDVh3gfDVIdtNRHKLJQjrjIna67PC8EkyazgysksyQNStMCnLC8rBNU0cM+O4SMJiFKy8XR44yfsFyuY78wLx2eMl0CM1DVbIgtUlMq/29STwRK6EsvxFtfHgETmKkxNA7IXqX9m6lkVHYH2JgDNkvJFMMF90rijK3dsFrqEretyK6sre/W69CgqdTwKL4qIIo+GtPO9gZPuoFARjtx8rBcftRElYs2zUoP3SRWm/VzGqHsli3QhHBrmoUQNEHI7TkVGqbr4zurN6mAjrNDBBnWZ/mN83r3uy/bpqO8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae6cf3d-f978-4379-9eb3-08dcf992b864
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:33.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMB4ms5IbRdJBnKeuavDuxxU7LjqLo+5PS2tYqY72K+6IRwhw4CQ+oA4kKhPiXVSD5uQ+F71YbtZQjbJipu06A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-GUID: fzn38IynrcVtdyJFfMQ2ovSfQeUWqGoW
X-Proofpoint-ORIG-GUID: fzn38IynrcVtdyJFfMQ2ovSfQeUWqGoW

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 32d587524778..baaf5f8b80ae 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -466,6 +466,12 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -608,6 +614,12 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	if (sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return true;
+		}
 		bio_chain(split, bio);
 		raid0_map_submit_bio(mddev, bio);
 		bio = split;
-- 
2.31.1

