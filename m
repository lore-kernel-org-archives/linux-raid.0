Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFEC1A76BB;
	Fri,  1 Nov 2024 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472421; cv=fail; b=PuQHAPxSDX4h3US5J4PzaxAirMXM5rLpEFZ4e8FUFUyS6CHlr0kmZYRB2CDPgrMaoG7dQ06YKvgnwBrfWcfVkILqP/myf6Fo17yggSaYwF0v3NBjFPzihUoP/EFJQ4/ms2XVJqduCejAihgCnsP/5SAmtxabm1xbmcPFDgt7rjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472421; c=relaxed/simple;
	bh=FAbgQ3tcSp8cPuTuNe2Av54P+N6Aj6gd2ZYYLbQmgro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kdfCwLdB9kOmLPz5Gna9h9X1XPYiWSnRDUJtCL8baQfSWFsKfKp187leQA2AW6lIHoc4ASEFbQNF8Kg9UdwbLCrbW55GLfTJADgjsBm9Gaco+XKpA4r6xImT60q/5AK2ndS5bFMHbZI69WkkklC1b0HBUu6+3ELH5QaPfBSAhJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YqP1q6kM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CqC7fmcu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YqP1q6kM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CqC7fmcu"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1Eikps026591;
	Fri, 1 Nov 2024 14:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Fjy46BWNOE57n3t8bwWyyuytGsqPwdI4Q6AqDAp5yu4=; b=
	YqP1q6kM9KcULTyQD4ygHas2FWru7XueRz9ptMrmZK2j51KUtzvNUzIaTzFV9ZTY
	xBHyZZQiXPp2BQ8Yz/Q/FexGSMUyKbzn07Y5SzrRwyG2+l5qtGCxDo2xHFjR8h5M
	HcBXRDMZppKrhH9gncOv03E4psa4nWLo6rVV3rVnSF6CyDsJYbT8ZvOCDthZZzG0
	VMSo8Tccq+DjMX9C1+ySTlsECN8bbmPd7oa3gvbQgOX6P0WDTEjqkRBfQEDQd4Z6
	s1Ao9Nl+Qv2rIUia9m8x8C4tN4hLKNemt/IH7mAA3GDzgqSFUu5R0cNlItP9p1iX
	AfFVvRS4zM+bNyl9BdYYDg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc94drr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1EJQUF035074;
	Fri, 1 Nov 2024 14:46:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hndbktt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pt3nJqYPR4IaGiswUyUEX5vfFCizQ9SLkQ+Za+MBEJg4ovMwWjYosw8F74tdvehdSqLTFADwVYiLos7o8T6cPWQjo7XybGLCNbgRsGLpD3hMIy3kiEuGAgeXNoRtdjTlnJ8iQu/Zo11q9YURCEZN2045L3UWIVl/cOp4Lk3N9u2fxKxr5pIj8H5sWANTcF4BU5zZG4mXiRBlNtsx1+N99UcwIK7Gno90sI3FA9ncNPYVCU7l4TQdh0cqUpqwTVuzwDNJUpt8EBdbEgDYv2TzOph/w4MFSwd68Pza2UjNnOeAjARc/TL/4B6vnCMH1xwow9Dm9ktMmwnH4Lk2ll35yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fjy46BWNOE57n3t8bwWyyuytGsqPwdI4Q6AqDAp5yu4=;
 b=K/DMzv4g3Os9Ezd7WONb8ICBHK4V9ZRqpfED9KkgN2zhESGwJN9Z6lr+spgonjDdZQVVmcUEOmOSwOIxontjDZTfnRAK/JHMmSNRaAJa1qR7dl97S3BodufX9MCtnMQ1dwJtyqEsQRWSgFnhaDXsT+YInddobTUD/+zusEPKDKMBDLi9F+DqS2u5ulGlgqsztAHHy/2tdMWDk/FHcacjI8JcBz2HxdgbuJjBhZd0HHSE54BXZTJh03gp+Gprdyfow9cH+Al1wWciqA0ikh93wFdB9C3Pq1ujcmyhNg7O9i99o4GXZ2wuNUPMLVttIGbGDjnPcgGTgPGHlFWHv2qz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fjy46BWNOE57n3t8bwWyyuytGsqPwdI4Q6AqDAp5yu4=;
 b=CqC7fmcu9f328wT9qc2I73DIXxlZIez4O9ZiHxPhkIlfnyQlxq707BzLBc/RzpHwo+HOPVHQR/KYYG2aloAfQPjrZ3S/5zIYBbTE4bd194dbnGbFecO09CaEMx+uOH/R23TLlJLY04I3N8YIos/ZM3w3NueK5ZSRFmglIfMCFdI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 2/5] block: Support atomic writes limits for stacked devices
Date: Fri,  1 Nov 2024 14:46:13 +0000
Message-Id: <20241101144616.497602-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241101144616.497602-1-john.g.garry@oracle.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:408:e5::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b4e5c2-bffe-4bbe-0e70-08dcfa83fd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wv6pPjKscITGXR4YtuYkTN7I0DkR2tTObJoyA41mCTj7VdVjDgFb+zTTCOLu?=
 =?us-ascii?Q?aeY8ADxk75W//ri3d61d47ho1zOtTGu4tiWhLSCZYePS5Wp8/DraYYRaG5d4?=
 =?us-ascii?Q?EUy28HPt+NQhOu/OR3Y7gF5gUyfgnPbB/GxI+vcLe6tj7kY3XbU/Tg9RWqyF?=
 =?us-ascii?Q?XcrQGU4sSdoLvKLFTNiftwrI6E19egSfCGk4vyVLFI+Uc4s6uIvrtb7q+Z47?=
 =?us-ascii?Q?bGx55VK7ySTQmUuUeAxq5gJpF5oFY4blpKjGHkCU3RkHe8FskLkw1M786UX1?=
 =?us-ascii?Q?Bbb7OBFZedri/LmIJvi7BGy6M0NcR/Be7B2rR6W21+xSEzU2i9X0kqEOv/oK?=
 =?us-ascii?Q?h9M1q3tdRQvTeTFXg8cPF3Dht+CF0G7ZqGLWJZ8uHLThn/40WKVIEozjkO5/?=
 =?us-ascii?Q?7555V2sfCagwPfLJoCJk1y7ylIkDTDS96EW3xVFd5OSzjKWPNgvLhfLwtscQ?=
 =?us-ascii?Q?tyGTr0q/oQqNeaKI8crUbvX/C/HFdJj7dVbZGLZzfVB2auDQrs7TcjGDPApk?=
 =?us-ascii?Q?V8fFj63rBKtg6a6Qr9mUBsCSxSpaOn6N3GtvfmCHZa0PiG7zYSrybu1V6lkP?=
 =?us-ascii?Q?pfUWSW54j07ct5dDt1iJ1DYo4NT7HMAIdX0ybjuuJcN7nSuNZSoylgNlgbZL?=
 =?us-ascii?Q?O8ac0XNge6msn1bHDvEIx+A4bOnxlg9oL+xRY2NljItHRLVs+RThz4J3wBU6?=
 =?us-ascii?Q?r1mCmrbu+VIdUug/kvMxD10lWMxuGbAS/rXppvIc/S2zs7CcUKwKCCwrb81k?=
 =?us-ascii?Q?hETS6Z5lTMO2UqXH3q9J7xuPOH0mHpIpCPodTH6+ehLC2jXFGNwwr0OjYB4v?=
 =?us-ascii?Q?f1whBbi1kkurZSR/XSz/jFghnwag61nzG2+eH6AILrGw837DX0CakDSac670?=
 =?us-ascii?Q?lVybOsn1ziOCBqcN4H59DGGNVoZrrEyPKocDzPycd6F5ii/x12Iv3n0uwL8H?=
 =?us-ascii?Q?uA2FW85BitQHSsLnDxFYW6rP7ianxhLtPr5/+0u2ooApA1zFN9yy69M2AC5X?=
 =?us-ascii?Q?KW6l71NU/MBLSiA26t2WQx5xDZcW0V+q92yIYJjzpKvgKuhjMlVGXF3ztEQM?=
 =?us-ascii?Q?nEnGaRRzRERyhu1eVJoSZRLGkux564p6+YEEsLccZgGUlCjTKX7K/sBY3yqz?=
 =?us-ascii?Q?FPDRPtIRSUb3x0x96yj3zqXiR8HYvjTXrjMZRvJB2rfO7lwWhzTXMI3HVQmp?=
 =?us-ascii?Q?OP1m7bP9CnbYwxPFJgYF/JW1fsqryPRFeK3UuSbjlROp5yJzAZZoAFkSubag?=
 =?us-ascii?Q?v5/ESDJyE39FIqmipHV6lT5EdTFVwa6J+4QHHNPpdqD0ZejdCNj9KfCF7Wfr?=
 =?us-ascii?Q?zJ50iprwYpKOJ685QlRxDTlI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tCvB+bUQ7BdEgo5VWJ8V3wNLgMAhIIE1/Vj/3XQMbEDeW50yL3LnZHqJDVRl?=
 =?us-ascii?Q?mNF4YnWUzjp4kSWxFRZrEIJY8K6XcY2FomFLPI7hYVlCA2W8iQC6lxkmq7Eq?=
 =?us-ascii?Q?vJyYThvY8Xz6wSC7Dqs0ot/AzFPwmFb5Z5q7RGZ7pWVtGsbBkqq1uRuRAUv8?=
 =?us-ascii?Q?btEdbzXTPCHSVb+ORO+pDLqqLkJoZ4T+C5fwp7sN+Fdv9JFuZovilZ63d2QQ?=
 =?us-ascii?Q?PaHtzRzGiKZ5kBsLtU8/BwJXcUtzqcRz8ySgOHWCiGmtGLMzC4DbxA6glsUs?=
 =?us-ascii?Q?NaLa6X+87puuDALFKkv6OeUoboFriCtMaW4mqx+BjiDbqQEgC4U2BSLpySfj?=
 =?us-ascii?Q?mdla56pNItrWimULUvnx4ilcLmGiBRJHshQDhYb6gLwKnF8Lr7xOWm7E9C1m?=
 =?us-ascii?Q?6prxhk90MstaleIZozHb6EO/OouWVD/3CXUl1KuctdidBO7GDFC2FlTNwLRB?=
 =?us-ascii?Q?MFnc1MzCtpxZkiJe4uGkH6HXTktACqmolrziTCMIA+23JRc0Tr0lARXYCsjd?=
 =?us-ascii?Q?vnNaIEcxTNK/Ua82YrSRAL9elV5x0eqDrlMHuQyhSYZ7Penna3OYlR+/6jyR?=
 =?us-ascii?Q?xQXZwlA2fhNIKsYKafG+aErQQBAyieGr1PHmkVgTaSU3Ys8uHMWSHVw7uYn6?=
 =?us-ascii?Q?HJMTg6hnKwgMYfl7tvR1w77fYPzAVrxeMDdQ0ttXtaZJ8B5jOiAhRbQNTWwo?=
 =?us-ascii?Q?yBI+eZtGWVDfwHy61OmfjUahvbTFHpWRCigJTX3g9OVHWVuvtFSsb6bWvBkR?=
 =?us-ascii?Q?AbOM4qcFXiWzvPOeefdRzl4GShWg7UIvpKdOHMiC2AB4ifJFkGdZAdMacLPD?=
 =?us-ascii?Q?xUAl9XXCXEPHfKY+4BMY6JMr533zLIivu0ATi9UdLq8j/oasLSwAzQGgunzP?=
 =?us-ascii?Q?AIk7OPaxEMbXfzcchOS5rpxBYnl2wdEXoZ1hRB1z+6D9Hr03yckoVyYdG7ri?=
 =?us-ascii?Q?gDuq9Kyaxn8h4+FQ8CkX+Y/AkguGhTAJ10Xin2gQO2ZYLGqWmwAhQX8iN46n?=
 =?us-ascii?Q?DIqpOdmQILQx/Rh2+fIJrjsmIxZQRab0IXyy79q2M3q+ZsUtXVIq0Jq2ewlJ?=
 =?us-ascii?Q?77WBfWwQswrLWh954xv+fN86+AILUwZBMp141Ze1qwQD1AY7J5/Xq1Z51kL/?=
 =?us-ascii?Q?sUarzedo7L1vQ4ZWalih/4L0p/W7ry57VxDncSQcG8376qo+LMbppnFpRctD?=
 =?us-ascii?Q?eSO1C6MzQKGnV4nCC3mzEsFKXrvY0ZPpf4LpRsi9s4yPjLlKgcHSZfRWFO3T?=
 =?us-ascii?Q?GFFyLOpG93LrJEtdZIC00sw11EGnsE9AlMh2Oy+81SVKHnlexPapBHUeSsIY?=
 =?us-ascii?Q?hl8IgV9MvFLOPycpuRWmD1Nf3mPIaJtU6WdB1DXEaqmw2PRuDIgQUVuz6QRS?=
 =?us-ascii?Q?odqsnblezEwqlZt4zL/dBiF+x24+6Tlfn2A4hk8FBMMsYNX9qaRyxbHcdoEm?=
 =?us-ascii?Q?8rRI5lEt5DjmCPMBce+DUZKDUBx20O6LEpamjy7Xtd0vxTzSjHiCZ4ZpXPvT?=
 =?us-ascii?Q?1nM22zrkwHmjGpQNigcosLqvY0aXfcI0bXKpKbqWBOvgdNheoSHDk864EhQZ?=
 =?us-ascii?Q?XYM8HeFk1oELjhqroYGTHWI5qGQ4yhVC/iTN5fuaRrV5WrMiBr81z/vUPU4x?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0eMqvdpg4KWTjQLnMIaeX5D7Px3xa0wMlQZgZloMj0C7tT+xRxO0lVOKuQp7DtKW2lecobY/fxBTBqmLTbzevMF47pEsS40Mehvr0dp7jJe/DWgnvyPOKl5YH0Y08+t7AXbVdOKPWNIdMfDTjIBg2dOhyV8kxSeZ49207bPuiv/H26Tqrj/T3PeflTabUE6ModgKXXwblc4fcHJetm9YkZ4arWlLpLLmTPOlE1l/MTV/AtXoAhypou5yON8LdenqWtWyAzQyVS38StPXLLpVFFNKF7lQKWKnCz7966j9frzxtCoBwRoyPkS3vfIDCd5ZkolggpZKbBPfmxrGzhdtT+CpOwreE19Mm/9/mIRYx1kdXMeCRnx3nGcLzyOEolIHTcUhI0OeXh2UUDxJE2N32G6XZNnQsTcPE6SwbfbkxFqSZ3TgzUN9MJUHMv35WnmEotB7Bm3EFLAqaKLaugP7uJLgPUtqT6/BWErnpcYlfwsDVX7IF7uXKJoOQIjhDt8GST40FIXUFwsUevuwPz5k2AubSo+ipKEsePqqh71R7P8ypUA3Oe5tr96xLAEJ2kL8OrnPABDuJwlR2W/ebY1C92pIDznL0sJuS2L0tPe9Gtc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b4e5c2-bffe-4bbe-0e70-08dcfa83fd16
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:37.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KzssJzFyO3s8ylXQLIGCjNoDbQ/L/FmUIPW8JzpHQflAhvPImJj49JmK5OWZhTPzDeX/tU8lT2VZtcrD+9CxmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-GUID: Dpb4SuZ-UD0OGpP2MqStUGTOyvqi969B
X-Proofpoint-ORIG-GUID: Dpb4SuZ-UD0OGpP2MqStUGTOyvqi969B

Allow stacked devices to support atomic writes by aggregating the minimum
capability of all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES_STACKED is set for stacked devices which
have been enabled to support atomic writes.

Some things to note on the implementation:
- For simplicity, all bottom devices must have same atomic write boundary
  value (if any)
- The atomic write boundary must be a power-of-2 already, but this
  restriction could be relaxed. Furthermore, it is now required that the
  chunk sectors for a top device must be aligned with this boundary.
- If a bottom device atomic write unit min/max are not aligned with the
  top device chunk sectors, the top device atomic write unit min/max are
  reduced to a value which works for the chunk sectors.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c   | 115 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   4 ++
 2 files changed, 119 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c5a753f980bf..8d3a9a55462e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -496,6 +496,119 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 	return sectors;
 }
 
+/* Check if second and later bottom devices are compliant */
+static bool blk_stack_atomic_writes_tail(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/* We're not going to support different boundary sizes.. yet */
+	if (t->atomic_write_hw_boundary != b->atomic_write_hw_boundary)
+		return false;
+
+	/* Can't support this */
+	if (t->atomic_write_hw_unit_min > b->atomic_write_hw_unit_max)
+		return false;
+
+	/* Or this */
+	if (t->atomic_write_hw_unit_max < b->atomic_write_hw_unit_min)
+		return false;
+
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max,
+				b->atomic_write_hw_max);
+	t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
+				b->atomic_write_hw_unit_min);
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+				b->atomic_write_hw_unit_max);
+	return true;
+}
+
+/* Check for valid boundary of first bottom device */
+static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/*
+	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
+	 * devices store chunk sectors in t->io_min.
+	 */
+	if (b->atomic_write_hw_boundary > t->io_min &&
+	    b->atomic_write_hw_boundary % t->io_min)
+		return false;
+	if (t->io_min > b->atomic_write_hw_boundary &&
+	    t->io_min % b->atomic_write_hw_boundary)
+		return false;
+
+	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
+	return true;
+}
+
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	if (t->io_min <= SECTOR_SIZE) {
+		/* No chunk sectors, so use bottom device values directly */
+		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+		t->atomic_write_hw_max = b->atomic_write_hw_max;
+		return true;
+	}
+
+	/*
+	 * Find values for limits which work for chunk size.
+	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
+	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * So we need to find highest power-of-2 which works for the chunk
+	 * size.
+	 * As an example scenario, we could have b->unit_max = 16K and
+	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
+	 * aligned with both limits, i.e. 8K in this example.
+	 */
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	while (t->io_min % t->atomic_write_hw_unit_max)
+		t->atomic_write_hw_unit_max /= 2;
+
+	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+					  t->atomic_write_hw_unit_max);
+	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+
+	return true;
+}
+
+static void blk_stack_atomic_writes_limits(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
+		goto unsupported;
+
+	if (!b->atomic_write_unit_min)
+		goto unsupported;
+
+	/*
+	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
+	 * device, so check for compliance.
+	 */
+	if (t->atomic_write_hw_max) {
+		if (!blk_stack_atomic_writes_tail(t, b))
+			goto unsupported;
+		return;
+	}
+
+	if (!blk_stack_atomic_writes_head(t, b))
+		goto unsupported;
+	return;
+
+unsupported:
+	t->atomic_write_hw_max = 0;
+	t->atomic_write_hw_unit_max = 0;
+	t->atomic_write_hw_unit_min = 0;
+	t->atomic_write_hw_boundary = 0;
+	t->features &= ~BLK_FEAT_ATOMIC_WRITES_STACKED;
+}
+
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
@@ -656,6 +769,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+	blk_stack_atomic_writes_limits(t, b);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7bfc877e159e..272e7cd03297 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -333,6 +333,10 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
 
+/* stacked device can/does support atomic writes */
+#define BLK_FEAT_ATOMIC_WRITES_STACKED \
+	((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
-- 
2.31.1

