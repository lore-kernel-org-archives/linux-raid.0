Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F019F485;
	Fri,  1 Nov 2024 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472544; cv=fail; b=fiptk4GOEn9+f7mAP3oZxwtKW9parGedDpF56MZv6WRmc8W+qxk/sFWODe8+U399ogO2M9qCo5EfaGSD2l356TYqA4wAmPf32Cbr0LPKx+u3UfGffsPMI/77tNzKyjWk5MSfF170pI/l2uCPs9HEdX2mfp/5/AYls2ygKPr5NvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472544; c=relaxed/simple;
	bh=IQJVg62Jh5W0T2x5maw5t1Kk/yhlFexGZCizSc7Mm9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NDGDEOHJUjEewV6d4/UD3T9v2lDBMnE6+avDfDGIjRGIFURTIUIwJPms3jao7eJwk+VFPD+KovcSREAPNJslVtKHwQfx6Fdm5YOoHNa+q+7oduS1sWXO4o0Txar9xziJR4b8ndILYA7bupUv4EIP4+Dg5rYk9icy2o86x8W1CWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jCuDyvSM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gec9yFN3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jCuDyvSM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gec9yFN3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1EicsY006621;
	Fri, 1 Nov 2024 14:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=o1l+lAPFDeN21lD4Xw217uBRQPDczrwmG/QblhGbUs0=; b=
	jCuDyvSMoD4RMZpsE9WpbFfUYeHbEfgt2o200+J3XDhJyubGI47MuSg++RdAjfz+
	EZhuxPC9yhutYLSFaiboMvCwFEd/JIkOrMoTYvotLYVfUl/6e6C2nAWRnuVYbQx6
	iIBoDcMUX4yeIsD78C67ROVScaqCgi1rmb8f8AsggsMuAEOG/QR6r9QkWMSz0vgH
	GhAWcZZMTxrdfNB7niqusp+ozHgKQR/0DmeotdFWH98mz7Z+s1jZjE21DI4eYULZ
	YgxyDy3Vr4MdPGa97mEyr2zgDe9T2FrXdIQryf5K5bf19FareVNFHuqxkAbEJE/X
	DlgPzmVZebcq4gvEeNYh7Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgwma5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1EIMDN011808;
	Fri, 1 Nov 2024 14:46:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnagmkq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bi8j3h40Z1sMt4u5MQt/IkGi1Ud8u8O+z76GTyQCFV2E42f+9NBykVK2EJeSedrvz8rKSpAcD0AOoTEUfMfNtGo/3lCoNTo0V8LAsODapYulDZklb5zEnvMvTU8XLciuj00B/XN8RvH+6z8ENAwciYvdEuF4j0/YvVFsqhJ9ur1SovzfOBo0Hs3N83CASiIWAJs3IBCwa5Hpls2mlezCjc8Vk5sicXohh9NyTTJrk7JC8TC5XwhuEco+Gp5Ul33VNENRjEDarL0tahNIu5qpXYKIWqyrJTfCNH2cmUxgFgQSBJKdNXJiFRMZCYwQmZvEJf9uk/wqitGmgi0FRmWjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1l+lAPFDeN21lD4Xw217uBRQPDczrwmG/QblhGbUs0=;
 b=hDrd77IxYr2LcX+wT5seAwRX2i7TlGs5NPvWMt22UrEV7p4Ek2yuXdS1fd0tmdZWHxxMOk9lJMBJWOg6Gr67LY9MuFLhFZrb3MCsLxrF//l8T3YEdDypLFqTNaNVnOQ5B3Yxxp4/WJsUZMx8I6imzP0EjOM8jPUlU+8oIoY9Ky6+IpLXyMii55wENmJD6+rOc8Wy3g+kmgYXDRVCKYnk1a92vb7H34Rex3CJnDuxw0E0FO3H0NWPrLmujNRWdEnCzS0r4vjyjDFrwhinIC3Nh9p2GCLVqfTpXSvDxw+VEpRovx3mDCLb8FgwtOWiCQjX4c14K6kDysBMNm7ZhpGkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1l+lAPFDeN21lD4Xw217uBRQPDczrwmG/QblhGbUs0=;
 b=gec9yFN35rvbhIwiJhVQjy2zF80k9wUWop75pP25VivJeeCzqKa7CNiLgXK/x2J6T1u/HRPEeBYHsX3LWAvjrJiSwTUIPt+5DdnJeerZTJxEqZg/P9+VRXhe4/2wA7S92RLmIYJAfS0AuA6VRPmCeM2/Xg5Zx4Y0RsG+Nzd8IYI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/5] md/raid1: Atomic write support
Date: Fri,  1 Nov 2024 14:46:15 +0000
Message-Id: <20241101144616.497602-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241101144616.497602-1-john.g.garry@oracle.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:208:234::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: f2bc4f0a-cfec-4198-7418-08dcfa83fef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9mMpf/ECOxLSRPSi7dl7uqnEiTnfmUlGhiMHoEI3ZNlT9ujnSI989bQc12zF?=
 =?us-ascii?Q?HjJRzotA/dUtLRiT2Tquh8TQe566cG3VV1mSXYdyxUZJAWTXsxBnmPTuo0/1?=
 =?us-ascii?Q?wOEN3DTgDYqxEdoLxgehEApnJ76Levx/y5TnHb5zE6cqZ6r0VlGSoSpD6uhA?=
 =?us-ascii?Q?FDjg5L6PQZPWHgLYUeVTAeWJTR2gUKR1HdpjrSuVRKWTy91cRRBtq1nswdl1?=
 =?us-ascii?Q?8QX+xRq3j1f50oGBEKKeQ/wtuurwoS11dPAF51Cs6FcFp+yx0OnbCm5L4V9g?=
 =?us-ascii?Q?5CCyAhKdpPmkS3oC0c3D/siakGvWo6VgTo/QaKpsFpdTVZIQjjXNog2Lsn3j?=
 =?us-ascii?Q?kjTOaPavmJgppQVFZueCGCX4skP4xN7dlxjZx0WnPHjy9nYOheO8TJC3POC5?=
 =?us-ascii?Q?vdoEDcoQKSnGkxi7c6mBX0y4pzTaqJwGU3FzF+TvcdWEGRmE1Nkq+gTTMK+n?=
 =?us-ascii?Q?lVy+v4oPnYKq0eoM/+igTV/2tStCzM+2XhuPMLJdEXZoSiR8/dQ5O998PGdA?=
 =?us-ascii?Q?vtz9AM6guoqclS/O4v7tJBF+aliHkXxAj1ACaU0gXoWPWAdUD4Ew/4xbTOoG?=
 =?us-ascii?Q?dYqa1AqQtoDY0g82pUhQrdHCq4H3Q7abvqHL7X1YctELUdLSOqQc24IVTbDy?=
 =?us-ascii?Q?BAg0JYPPq/TdZz92DWWneyGYLI48w5g+b72paYBWlqYAxy5P0sTeSRztuyAt?=
 =?us-ascii?Q?Lu3QKfy8cmDgFER9V7XckHvFWx0P1ZRRE+UIq64Niyg6lPGuxyM4MoL/1FEg?=
 =?us-ascii?Q?PsNWjXKVYwDe7lPvDwfwxYS1uojt5PQSzBVJpLbxqiNejXnnmkH+IVu2ow9C?=
 =?us-ascii?Q?fIuQ4ZDdypIxXTAEhS2fiwNurfGIKz24LaYEwiU5VXpRJiBDuj2HNCk0puSN?=
 =?us-ascii?Q?ps27GdKsT44kkxkWr2nzRo1SeP47tyBEL7cbDiBU9BZq1975JctlSUyXeaXt?=
 =?us-ascii?Q?vIl0mE7BYTm9CA/ahXjhrxjuDEE/atB1nvd31S0q4pwt7rHdLamM9No+0CCP?=
 =?us-ascii?Q?bu0RAMZW8GPx++bupzB6Gy/ZWv2krSX5Owp4qt0G96vBc2rwNqHwXHkfw8J3?=
 =?us-ascii?Q?MFxQXlSSZjKtkCWRG/SY81xLc3RBwU/Wwv8alRF8Wd3YugnNm92eFPs7Lnrq?=
 =?us-ascii?Q?x9tuz/6iLOe0x15emyqXdx6Scbcg8ehvR28+x/nccNWKI4wrePjw+KisLeYm?=
 =?us-ascii?Q?+rtz4S2fKAHG/r33f4HkGIUwE6aNiXryCX+vzIT2RcuKyhpntxjK/uXO7HjK?=
 =?us-ascii?Q?RmX4SgyEq+CBlT0p6yH6Y0ZLrrt94FXaLBdcGUmTD5bam1JrA3a6NX/VEMj5?=
 =?us-ascii?Q?nU2ah6yc/0KLAoURvzTduMGB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hFeGfFAqeqXmkn91ZHZMwzuqh4PCHCv12lHu9RifvEpu29jPCP3+cehlYt+y?=
 =?us-ascii?Q?HszkOYE9hS+GXkCKoeekJ9nLygUhLYIIMgRGS0uU5uR9O3U31BY1KNKX720T?=
 =?us-ascii?Q?Sf+4agt9am5CA5NYsEKe9Hg+ccRChybxT23f6II8l9d9w+4m7MHVjszpSxvf?=
 =?us-ascii?Q?hPNHdu0mVG53qT1DsNQtAiftnoaEH8FdRnFHjQCLY1tcsU3o5xQtJJ8hygNh?=
 =?us-ascii?Q?FCsil5T6EZkhwAFoHDjX8jE1jQBCrPM+4E9B1d+hZ5HctGdp98iqFrykV0Kf?=
 =?us-ascii?Q?Jp0Misg/UtFGYpoHBf820SdLBnIxCkI/XtfC3Qt9FJDqX1b+v5aJyqK3EQvR?=
 =?us-ascii?Q?7Zi7UTuxfWkAqta8Ha0ERSeB+9maiyi2XCrYP8zJhcU919UHOF3cbvQMCNH1?=
 =?us-ascii?Q?THN/sNIaEsjteKQqcoTlhnxtaamrAaXEUbZ1wcEB/HGnJS7pzxpWBNzeAHVc?=
 =?us-ascii?Q?JLoj3sNQAsPq0tAzeVRJKoOOMjXPwKR2GHhJS1qStFjTQtNXnB0FnxiZUORI?=
 =?us-ascii?Q?7oloiJ2j+7/OgOX4je+qFZwIFd5YnuNe9FDQTn+L05L3Bpoe3eYkzpB7GlBi?=
 =?us-ascii?Q?AQtBr7MHtI+DZkCFHio0KiFiQTt/vfjcpv7Evgg+5IC6METCnnQM9CAJNklh?=
 =?us-ascii?Q?JtlGy6IujveZ3+Mc8LItFbS8In7wyAlHi1InVXnjNBOhz4QP95n0pAds6BWk?=
 =?us-ascii?Q?H2dFDmAGUCsqYtAiiERTecjOGk1SE7ZWPvOBD3hGicyxoReicq5Oos0FBPzN?=
 =?us-ascii?Q?WRdgY/M2S3QcEb0V5AwGx559g0z/m8Hp4fLQC33DTHZacq+5pEuuI+pTbKbS?=
 =?us-ascii?Q?I/Idmxv1jkG+rRK6OKRqod3rfRJEzDp3N4kdA3c6npe4M6g9mPl0G6Qr4TjF?=
 =?us-ascii?Q?DNtiAQC6AvOf6dhsKCtvMHWz6Heulm6xKTIkrxhE7ACQVGnEBwl+2EFZfjwl?=
 =?us-ascii?Q?ypRMc8n03jlp5Alz85ItNc8+Dy33TnmyofBwrnDT7YXhHHhTFoR+Y0mrC7t/?=
 =?us-ascii?Q?8OvrYWmoVudR1tyGEj4vwTM5AHVYUWVc1+Ckf/Iuq+QI4eQaDd7A6W5rFyaJ?=
 =?us-ascii?Q?FsjpeviqwoUJbEJKetqo2AsFpeLA2OIl+EVIqSDwiVdNAvXhnEEL4zyVa6qX?=
 =?us-ascii?Q?LtXw7KvlfMWTxC8/T7QU3H2jQ5fzho7yp9uReUXwMXkG2qPwaKfqFTycxTZn?=
 =?us-ascii?Q?K+3wlgoA6rR1ck35T3aR7CzJGn1bYCTeu1Qo7CrmnKcCJT2lIO70OXyPiks1?=
 =?us-ascii?Q?UdlrnjuBLCW5LRqRw0RkZKxaXabnWBAlNfVviXmb7oz+iZpD/vxjn7pUuoBF?=
 =?us-ascii?Q?P6hRUuXvpUPZOHs7qVX11IcnYEbHJMbow16LH2oxmbQaMpctMSGLxMEYjdIv?=
 =?us-ascii?Q?OstbLkcib6ckToD9L4xCw49qKWMHgnVagRYG76QmOdVvYBcUS/Kq72507/UD?=
 =?us-ascii?Q?yWbCBGSrYsjRmtbezOoovF0LFyWDVhoS0Fda7dVpAb/Bey0zp1n2q4PeEYt4?=
 =?us-ascii?Q?Qj4UubiZD3r1rRDPBfeqUpHZ7gkK/jNsnAO9aHg7cZyVvkL83vPnuRu2zIFZ?=
 =?us-ascii?Q?BDkvDD6aBHxaMb69PcxuJioZMX7DvUw7llnhU0xy9qdiH83CCrh0FdGy717M?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IAh9NhYUUu2CDvdPCL0m9tuZN6jBFpPbDJBx0eFnIhI+pLirxdPEedmn3gP2csHhlSRBuK3rZY9fH8vU2Tf/pCz4O9AkrsC/gqtJypjlVB4afFHVLB6CzvlGp8vYRejhY71KPS/+YqQmO0f8sFympdPheSM+gZOpDc8wr0qFxfE7q0kWVm+L+c0bzRTHfzHJCy9gdHjsjo9TtGWf0qb0FXV+t4vvFFYS6l8UKTIyZMafpKDOwzCRj1Uzr4ohV3+mtXGH1cl/sr6aIIzNqEa1Gm5cuZGKUOqGfnd74thLRQNdG7I98bvIP/eVjyTciwRZoTp9Iep4LWD1DNPObPUODwq7s2pq1VuN/7GrrFfYMgXqhSniKjL05+fwDLMNrEwOiOcOLJGRWda/WbyimeVSPZKWDqis9L/jbMU73z0rRSOpgrn/J7nJCjPaToOmxEw1zsTIslZMGnJLDqLrSrZ7Iwy+x65ZeA4WeXMGjbRqbXuWWm7pKNfnInbF3TXUYajlQbOeZhFfQl3oJslq55YqM7/4ORdxVcDgDNWxOoExejLYg1Wwc3oiJLlo8mimD7o1ovqOacbtA2VowbGY9cuCR+qJLeQMra+fn3yh8Uv1fF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2bc4f0a-cfec-4198-7418-08dcfa83fef7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:40.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anjoG3cnA+rE7vFD0NejtwSpgUf9TVcUKTznC7WkkrvITS4hxHYkAiW0upiU38mMtQS3+lT7zQxrbPs+VNc37g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-ORIG-GUID: Wr-ZmRIvJk16jIcqF6d0cSDCsxAHZAQ9
X-Proofpoint-GUID: Wr-ZmRIvJk16jIcqF6d0cSDCsxAHZAQ9

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7e023e9303c8..795bd0c7caff 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1547,7 +1547,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - r1_bio->sector;
+				int good_sectors;
+
+				if (bio->bi_opf & REQ_ATOMIC) {
+					/* We just cannot atomically write this ... */
+					error = -EFAULT;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - r1_bio->sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -1654,7 +1662,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
+		mbio->bi_opf = bio_op(bio) |
+			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
@@ -3221,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

