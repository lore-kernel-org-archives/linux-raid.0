Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92E2ED846
	for <linux-raid@vger.kernel.org>; Fri, 26 Sep 2025 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758891536; cv=fail; b=A74bBwSnJMasgNiRdrtiGNgcPBywr8HRloCxWRRevHL51F4oJNfVvcrSVwxT9Sr0XbOVRlSI0+dkncMIgLlGI2dB5S427F7VNX72M6xc8F5OyQySdrfjfUV13coDeeJl66ENPyAw8GZePH6d+Tj/rLdNWD6rOMR1cwN4JhjhWUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758891536; c=relaxed/simple;
	bh=6uIgDM3PQ2amWSj5fcAVVaZenhcqNBMWpBByeLXpiZM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h5g0muQYDIz1XIJwj6NohsO1riaIWY2UJDvMEQr09WnsxI1grn3auXbCnYetHLA91tSqst5FGOONA9Jsy0HYnq9uWv7TFSC+SWj77OyFbZSBeGtIe/OkR0HtXfuwWvPBMcgMRJ3mJROrYAfb2rh7J3XcQwuKeNYH5Mg3oVzCTZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jSyNRsU1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=byMn8Wra; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jSyNRsU1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="byMn8Wra"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58QCYZ35028045;
	Fri, 26 Sep 2025 12:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=hkr3qIwSvYHYb0G8
	ocNiUPltafhhkRxdr/JsbdFrn0g=; b=jSyNRsU1LJbb2qgKK2DmIIVas3HdPF9t
	NF0jt/w0L4RMqPmYyl3tAvSNjdX4tBpIo7geGls40aWA7LC+JS8yMxte2TDgkZsW
	UxCs7hMBOBws3+g/sbfGlaO1N8n9e030mES4D6kk9zJWKW7Ot/k0jIzG4IzTSkZS
	uuQ85bviiLo/W/Y+pghMgoUjkoz6izXRcWTWgy7HUdLFM5cvX4kMJ1ZtFoB8bMR4
	Bgvt7W8EvTqFNHFxoKUdMpnvAPD4B2/1lMO1YGEkNi8aTIVKPTaI+0i1qhXVSHPl
	ZBw9ZZ667A2lWS7xqimlIv8swr1uDgRo8AG/xpdOhIMHazjelZVpiA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49dtxy01bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 12:58:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58QCDnZq035355;
	Fri, 26 Sep 2025 12:58:40 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010040.outbound.protection.outlook.com [52.101.85.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49dd9u9r25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 12:58:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVjHK6Yf9pALdSAb6mEW8A5tGz5mlzwn389IcWChhveRY/SaupcMVELX1H4HT8KBqhAyGqZj7DMt7lzCRLunxaI2AeaoV2m1XNdAe8ldMGSqLtYvf/d12Q/SLXs/QaeEWfAUeQRuBKAmyt5cSV5lmxV0sD6x3ULeum11kMbKDxcMWe2QKF0fWfAlG1Ug3h1mPcRyWylMxD0ht5mg97BN2aCRehU4rgVCW8jsSy+M5HAJUEY85WrjtXIORI3hUch1IXvA82qEKWWiGLYi6ebkXP2iEcMmv38WaC0lwy+geCVq7sF061shBUNkq9Xthcmt5ZqhIN7K4DFlnrASIMtg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkr3qIwSvYHYb0G8ocNiUPltafhhkRxdr/JsbdFrn0g=;
 b=r9xjvPCSalpK3rdb9VLCVdba1llkzonKR7+Z9xPUGr0DxeTeQ/Ob/AF+d3F9ncXCKC8yukfzNO1OMqlQ5DYR4xr+nO7J9Kro69NhxjCTy9+bgkjW+KuYkuhRf6UH0t0JzBS1eOFQSfeoXAwSu3TSIAhzzSBP/ntF13RzirdYGBhoENH0Hf2KPAgAPIBlVbBonHy+OV82Ni1hePCdjr/WmZimh6mB1l5USbqONQoq72XwKG+vcBYdYmNbGrGjZCVJMMl7gaDvIV7E4pPA1WKF6w+5yJTcSGGAWkRPUkviOdLiJxav4z/+KYumuY3DKxzXalE1fJpiE4NfJoScwXhm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkr3qIwSvYHYb0G8ocNiUPltafhhkRxdr/JsbdFrn0g=;
 b=byMn8Wra/nzEh5mg3zaMTV0S77wnHf6rPpR2PnlkQt4r2R9tDWhVh7KSJhOmgA+NnisxeOUCuOhtL2do6AmKSltWIKGTQUFTGGrtZAEMyVMRuENxwqNlZlX7SO54mvWvyh6OFnWLt9v8Iftg2Y6LCzbDMM6A/iVT1R83FLTW4wU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CY8PR10MB6732.namprd10.prod.outlook.com (2603:10b6:930:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Fri, 26 Sep
 2025 12:58:36 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 26 Sep 2025
 12:58:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC] md: disable atomic writes if any bad blocks found
Date: Fri, 26 Sep 2025 12:58:25 +0000
Message-ID: <20250926125825.3015322-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CY8PR10MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 51cf0d05-6471-4665-83d0-08ddfcfc6805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|3122999003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3cGc4SNdN9q1qogjKCkqGmGOwt5SIsMs0d+5Hs3InUDo4aRjDOV1i0BSCh7P?=
 =?us-ascii?Q?L3KvPpTDkusw+rcAr+cZZkQ9GHq9Drp8A9iIpd1BokALGC+j7qzGyVAyhbkN?=
 =?us-ascii?Q?+DcekhMPnPE+sYjglMXXgpv75MJGXdJNauPkCiVYBppMI8aBpeCNj7Dv6bYa?=
 =?us-ascii?Q?hIlsMwnLseMfv1rXcXUhOixH9mQHvuPflwKAPOmLmlFUHutj6fOsZl4aaV3G?=
 =?us-ascii?Q?ECgh12l7/zLLqaWl5Rkf024wo2VTXszlpBPIqvBCQtw4c6+gfVBgzoikI61r?=
 =?us-ascii?Q?rZGq6kZtD2lZ2EVs+3H6MDJB8yZI09YiUijr7S0fnK9OGnVmIxoQSbLPQmOT?=
 =?us-ascii?Q?+OajKvhDtFPmtiBwCDi/hZ46vcErfpi6MLx24v3NMzWcWZLp2ysG6rOvrFT7?=
 =?us-ascii?Q?Bjyw7sAfL3nJHgP8FMVCyR9PC8nzg7JrKA2gkCc8sH9qpsikkwwqCkAKiuwR?=
 =?us-ascii?Q?awMtVxqq6LHVQkHdf2pkay6X4mBtK57itzZUROhoi7mfYj8939enTwJ9+uAG?=
 =?us-ascii?Q?5ylHBJGSeHgZhMYhnQ1idx+jw28wu27tEAneElaZ3JeYYZ9yzdk9V2mXp8rd?=
 =?us-ascii?Q?WN/SPlOT1H/V986l3Cg+JnSuKhb3ahOjM4BPHGzHGfF3320tvMmD6exkyszm?=
 =?us-ascii?Q?sSQfgPbgI87lxfLYNeBzuFpfQT+I5rB6rzARbmtmNNkPKxLCB/dIKSAZs9Z1?=
 =?us-ascii?Q?FzZGaIChK6zr+XOKPt/YksdCnZijgRXmfXkkWeyal9CNvGsJDP6lZJCf/hWp?=
 =?us-ascii?Q?kYya5Kb+E/NFymg8PA5Kg6d0z6XCGAlQavFu3JrUn4VhEHSxbn9PTFg0oeW9?=
 =?us-ascii?Q?Itljrhr0fOdBz6Qw/88azPE5SvnzKlqUxlyGw2PEYALTiGNhPZw3ZNPLIBNW?=
 =?us-ascii?Q?H5ooLs8ckKepX32nci3nDOoRw44xDsICtNw7kzsExABepy/wa1KqQikLGjpp?=
 =?us-ascii?Q?sEe2pU8fcNSShtQrwNgCVCafSgqD//013LiZT3hJTDMtb1aW7TeEaR5Uqabj?=
 =?us-ascii?Q?UZER+0O+4mRtnavXcPGNUdEc+iRSxyg3zwukcWzF0mUMW8a3wzoJYVzDTdTr?=
 =?us-ascii?Q?J/aSFGqG4UgQo9wWlZTL88m4hVY6brvpNteOgcJxiB1m2qxU+WHu5uycreeE?=
 =?us-ascii?Q?QOxd61MjS13//aKr0ZSjvfQtiM5LgOCf9cWnwPEDRvHhoe47X23MSiWWTL74?=
 =?us-ascii?Q?rHAvB7uspNZU/gF2GQN6BqgQJRFKN3u95mtVAHkXuNO+eWTXGvyfByh7oB1d?=
 =?us-ascii?Q?9pxcu7nNID5sbhhlcIIVjqOwTCuV3y53AfLC+v/5OHNut3zLweIk1vqX5X+Z?=
 =?us-ascii?Q?Ed9ncu46XK4BOe+X+vNOx1eFo9LGYiJOmsVScRfVlQdCefD/BAtOidfnQvsl?=
 =?us-ascii?Q?6IdAa3eTNTWiQiAlLOHTl4KdfzWeAyujwTr+YDlIPmPjOsC5CEsYqrRFoOrW?=
 =?us-ascii?Q?rVfOZPuis3E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(3122999003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?faEEHTz99myfEQu39XFFpxUo+t+2LRlLWBtDtE26KxyfHE5gVj497PEZNOpf?=
 =?us-ascii?Q?mRA9lxZtAFFQNmyGQ9fX+9oy3wMArBkomTvmlNnqO1yjcpj1NTcU8hH87Ipi?=
 =?us-ascii?Q?FiTk/vbpv0et6+kDkQY/bAYGPcZE2rVRsUhyNbwxoNbBg6Sc1Js4UMfCjVl0?=
 =?us-ascii?Q?wV9pMErW2Hbhybhwsa57VnA5O1XXgtepwErXRdkkMdV2vE8NVkCaTXflltIY?=
 =?us-ascii?Q?AWrj2JBMbbpaAJ0vNXJPvzDQFRXah3SlWc01bdI2QzXER15HjMYQw5iO/6t8?=
 =?us-ascii?Q?vEfzRE9dDaqyZYXJszC5GY83lpVyblM0+Zo5rfzn+FIkKaAC0g5hKHz4k4BK?=
 =?us-ascii?Q?R+8hBpjXXuilD7XvEboCuvJynhKePhs7weP1sEfQ1lEvrh2fLyfXVi4QO89t?=
 =?us-ascii?Q?888df0Y3o7VnVcTdmNJ9NcV7zXLK2uMcFelCxHOJPfs4tYFFbCfRly/tONbm?=
 =?us-ascii?Q?mG6WuwcQP2TnNpbmSgDM2Amm4DY/zIMeGXojMSgWtiF6ZprVlS81N6108ggq?=
 =?us-ascii?Q?SvQ9Srr8L7mfFWOhBEOfxVGZ2SzlI7uDj4oxdysKhXI2RHclLYNEfztzbVqi?=
 =?us-ascii?Q?SmBMtwjPL5j6z0Qw1lhba+juJAAS1/IsCK+xL0aH12vGz17LdlBSAU1xAGKJ?=
 =?us-ascii?Q?oVsM88y2wRw3rC3ECz4Nin0XNPu6muXBOJ0qdqTppKEXLQu+3aYzcVp/K1qX?=
 =?us-ascii?Q?aXboJyPkzLL+ztInLgUUblhq3VZ2Xb6uueFyhA/svJoiB/uaufkn38r5Tlhj?=
 =?us-ascii?Q?qXxHBb5FgLj+Xe3CVtesZAbduEwTmqX7N2J49np18bgTM+1uCjpQCcWPOlPi?=
 =?us-ascii?Q?3yRoxN1E3dbkvzB/3VVlgVCV5iBcefZEl6wZDwxIq8dD+S3fykeAmMGucXdw?=
 =?us-ascii?Q?QRmejJ+aHrgZxZchc76FIb8VBICa7nGNTMaYfgZBuyM8zPcSDFhVoUk8utAh?=
 =?us-ascii?Q?NrYJB2oR3upt3zGKWByIzhxkWhoRxPrX28mHKRkhRK2kT4sndsbKVLiWvLG0?=
 =?us-ascii?Q?hAf3DuAUxJFRD8qJtmyxhC15OV2zIb3QIDpTQGR/Va9jZUZvBtvZ/XeS/HgF?=
 =?us-ascii?Q?OJKajD3352p4lQDgbKzHJpRuhm37ihV0mXwmkoy2Bvs4mZcEWzwP71s+k7j5?=
 =?us-ascii?Q?8gtuNHg4LMkajbjN8WyVkhbCYSVzsLthehKwLqO8wf8sanzSVEHAdJ/kmJx5?=
 =?us-ascii?Q?ekOEpncV65inb7dHTvgcsxJmNc+wUd7Kzl741DPS8isImy2Evh+PF0ilcrmN?=
 =?us-ascii?Q?4+13Bq5URsY0uO8GDcGUEvBrr4dUn3kj/nmBfAZWrcM/zqx6ktSNcHAoGjDP?=
 =?us-ascii?Q?dXoyxLbZI9AHBcnW9pxjTbBzz6ucHOhcdYsMPnkf3p/xNIluNFxPWL13IRry?=
 =?us-ascii?Q?pathtMy/Vh6BeQMBlJ8hcCvZC+D5xO8SvpbOsuVqzQZ5bHOyvIZp5Sbkfe8Q?=
 =?us-ascii?Q?bIr0vXI+/acyB6pGnMbccmeKgC1u7ySXiz5LpcEPTsHl4Vb1r5jBwvuwpCsa?=
 =?us-ascii?Q?MFdDd2fYKgQOpzNY559EZO+Gw7sC7j9fs/IBSuC1SMQPc6w7PPesH6gvNbJR?=
 =?us-ascii?Q?TdmfDZ4MQec72uOQJNX7p6NjTndcuGTkAiAAySnl3jGevAZMKiSUFHgFGTs+?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ueVhTK/FUX/hGnOhlTErIZgAWYOLRSuzI2JJoPigsxcWfKBHBunIdY2w15wUmJk8yXk0SLSRlE00DIgf33Wi++Ostrsrc/QUbvfciif8QG+ljPd+2PxfbWXUhFBPkYdghuB/g0TIIlIMpSpNT0qnXJxLbo/w+ZS3P6+sTmOGeQ+PrdCcxyuAsBKjZ+2YvAPrNqqR0QzkW9RwNfx/XE5VBnEaJFzQ5boXcK/asx6DfXMdEhl4g40ZIbWKURemFPmLttb23/2rOaGN9tbRvK6eoCIXKuXUntCACV+O3x/lYy2Xj64UL1t0KR2Nucab8ciQQ13SQHF9JvsDy8jtUG4vJhyGTWgaH5XNqsdXy5yMof19mb8RoXAKrBCjTafje00o5duny+QfGcj6XOLqOMZxQE7/6yA2Je6TJmemTvRyXkwaEt3yKPYMLn20GkWyv1+WaEPXGDnqAlGyJcAUNsiYozeUBwBCWNwUg+AwwKt4kkfZB9JqqFHvRiJHKid+FRCGBOXJWerrY1dN/+YlHwDlHV0eaqBd1lUXgEjRALLPqNeSbmfA/kXjol6Im+wPQmps2jHpG5jv8CwCt8ZHfJ5fuljANWYweJGMLj+S8ZFgfgQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51cf0d05-6471-4665-83d0-08ddfcfc6805
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 12:58:36.4591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u274BY45sWT/I7aMIRByf28hFNXphCARy1L4p/Xp9Q26KnOrNDEUmaajRZgaB8tOHrNWK95sE7BEra+5o0qtNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_04,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2509260119
X-Proofpoint-GUID: DHJgjgHru1GjJ85q6PBFbklV8ZImiv8y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDExNiBTYWx0ZWRfXzXzD0tO1XuqE
 heM672HwaVMz2UYAwiPoUPzAjNRh5f3xBC7RaMFY9WbkvatISQSgQNp3vqGKqc8+EnLr30/Cj/Y
 I+AH0u6XOZMp3atDPB/tL2tVXrlOdStE1cZp2Ce4kSHMO/kah5/JqxL1wfUrJ1c+2U3+oXWqLZk
 ok85YTvEi5j2FN7EAPU6qes+ygx8nypohbiEvSRmenLMg3Emj8koZojKn7HMC3+sxAt3/ft7YUY
 p7LXDFXFJtCwdQEQK2cAicU1GXvNQsAXptdfa3EoqPqw+/66+ptX6WRPcLA8K9T4DJM1Uyfgp+i
 cETRDZ808G7TUkFBsq75aurLArsNS9DQ99OXnrJy8nAUTm4t3C9j40DIwqGNhpQelPv+f6EMKnJ
 23lJGOpUhG1k1UEto3qJxDthSGoD78BH+BNGvxLZUuAcfPeejwU=
X-Proofpoint-ORIG-GUID: DHJgjgHru1GjJ85q6PBFbklV8ZImiv8y
X-Authority-Analysis: v=2.4 cv=L8AQguT8 c=1 sm=1 tr=0 ts=68d68e01 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=htsdGjHzNLhRKl_u-eoA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 cc=ntf awl=host:13622

RAID1 and RAID10 personalities support bad blocks management. In handling
read or writing from a region which has bad blocks, the read and write bio
is split as to not access the bad block sectors.

Splitting of writes is not allowed for atomic writes. As such, bad blocks
are incompatible with atomic writes. If an atomic write ever occurs over
a region which has bad blocks, then the write is rejected.

It is not ever expected in practice that we will ever see devices which
support atomic writes and also require bad block kernel support. However
it is not proper to say that atomic writes are supported for a device
which actually has bad blocks.

md maintains a persistent feature flag to say whether bad block management
is active on the array, MD_FEATURE_BAD_BLOCKS.

If this is set, then disable atomic writes for the array. In addition, if
bad blocks are found during runtime, then atomic writes are asynchronously
disabled.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
I set this as an RFC as I am not sure if it is a satisfactory solution.
Do we need to go one set further and allow the personality to opt out of
any BB management? In that case, atomic writes would not be supported
unless we opt out.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd46..433f5cf48e753 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1229,6 +1229,7 @@ struct super_type  {
 						sector_t num_sectors);
 	int		    (*allow_new_offset)(struct md_rdev *rdev,
 						unsigned long long new_offset);
+	bool		    (*has_bb)(struct md_rdev *rdev);
 };
 
 /*
@@ -2348,6 +2349,13 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	return 1;
 }
 
+static bool super_1_has_bb(struct md_rdev *rdev)
+{
+	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
+
+	return le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS;
+}
+
 static struct super_type super_types[] = {
 	[0] = {
 		.name	= "0.90.0",
@@ -2366,9 +2374,30 @@ static struct super_type super_types[] = {
 		.sync_super	    = super_1_sync,
 		.rdev_size_change   = super_1_rdev_size_change,
 		.allow_new_offset   = super_1_allow_new_offset,
+		.has_bb		    = super_1_has_bb,
 	},
 };
 
+static bool super_has_bb(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!super_types[mddev->major_version].has_bb)
+		return false;
+	return super_types[mddev->major_version].has_bb(rdev);
+}
+
+bool md_atomic_writes_possible(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		if (super_has_bb(mddev, rdev))
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(md_atomic_writes_possible);
+
 static void sync_super(struct mddev *mddev, struct md_rdev *rdev)
 {
 	if (mddev->sync_super) {
@@ -2845,6 +2874,21 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 
+
+	if (any_badblocks_changed) {
+		struct queue_limits lim;
+
+		lim = queue_limits_start_update(mddev->gendisk->queue);
+		if (lim.features & BLK_FEAT_ATOMIC_WRITES) {
+			lim.features &= ~BLK_FEAT_ATOMIC_WRITES;
+			if (queue_limits_commit_update_frozen(
+					mddev->gendisk->queue, &lim))
+				pr_warn("could not disable atomic writes after finding bad blocks\n");
+		} else {
+			queue_limits_cancel_update(mddev->gendisk->queue);
+		}
+	}
+
 	rdev_for_each(rdev, mddev) {
 		if (test_and_clear_bit(FaultRecorded, &rdev->flags))
 			clear_bit(Blocked, &rdev->flags);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a030793..2b530c31c7a4d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -922,6 +922,7 @@ extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(struct mddev *mddev);
 extern int md_integrity_register(struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
+bool md_atomic_writes_possible(struct mddev *mddev);
 
 extern int mddev_init(struct mddev *mddev);
 extern void mddev_destroy(struct mddev *mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d30b82beeb92f..feb7129a2941f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3208,11 +3208,10 @@ static int raid1_set_limits(struct mddev *mddev)
 {
 	struct queue_limits lim;
 	int err;
-
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
-	lim.max_hw_wzeroes_unmap_sectors = 0;
-	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	if (md_atomic_writes_possible(mddev))
+		lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
-- 
2.43.5

