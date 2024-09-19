Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A240D19922A;
	Thu, 19 Sep 2024 09:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737832; cv=fail; b=lQQhN5mbZib6+gMubDH0iN4TTO25wyueTQnnzn05p5ugimLXfD4t+6hp2nMw/OR3bzt8ctAk5NX18sqBdD3M11Q8cZyocDZZcxsWJ9ckfAtY3MpANS+qSImatbY/h81XRf58VizPpsctvdsyhNlBw5aCW62cHAtcrfqjlhUGekg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737832; c=relaxed/simple;
	bh=xfndRRfR2Jq+bHPzc/3VY/dAHbY9DcMESxxWT9aFZxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y4j/VXUDNTYXo2YP2ol9LrI6maiBcSQRfHAPtj/4qs86dlLrnJR8yjFV+T9YbZeQgwuljE9meaXNI3Ja50Wt1r/E8jlW1UdCDW0BuOIopNI/o2n26bS3XQUySSADxR3hsobVMDa2Pvurz+u8Z+UgUDZcYrh3Pi63j/591Di1kIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZO0rzcLy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kNfmOLiH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZO0rzcLy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kNfmOLiH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tWLR001460;
	Thu, 19 Sep 2024 09:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ArrDeQ6Lb0PjB3tI/2f8n47f0LRAGqU99EWV9u9uwQA=; b=
	ZO0rzcLyHRSjVlKL/DjoCLA4BY61CIoGb/HVHoNme4fPksZ4hf0Y2BGMxDNtR+jw
	XbBFOr2oamdmNy2Uv163r6dLA5Sw7VlmoIdN67Qo/bOwkCgW6UKnUrHPRLHpHCi0
	YtGV+M62+APzJpV0GxIdXLAPlKGoMeVOhGPtQNFM7ikY6fnIDQ2EdRY8Ve8o9jwU
	4t/Upet8rqwc5RAxh6/1WbV28OPkSm8DDwnQJIRkRxQGlhZik8L3tCd9JclkP+GB
	qUzBpnaT5Xn1A4pqP2GW12E5OefREMpjvrvaXK/IuAUcSyRgtlqnd55Wspl6z8uF
	AokEyWOfe8ZeijgpgILZjg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rx3g3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7gWoi040473;
	Thu, 19 Sep 2024 09:23:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nydxtetr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcjqrGEhSPXJZomI5SdcnBDliyuSICUHAhbeLjvdy3ycmYwzZNA0tp0W9But9JtG/EgIsjPZ0lttCyscFn+vcfp6wop5Q5dItDr+YM7r3XX9U2LuMLb7CIM7y6iTLAuQVv0CAkygbT+EgkG3YsEwnlAYSCvE578vUXbmhC2n0YuyRVAem+sKggbp+9NjHRD5iLwbdRRmZ2HEWZ8Bijb4uwH0Ji9Qq6JRTJnYx7JSDKLbk/oL+ocKZwFC1svHRtdsHhgi8gFBzle5NGWpPVXqmciqZHkx6v1EdlIzw95YHPRu5e3sNOZfVk0pO7iFw/Oz+ePgQBH6WA9qf4hCH1oi6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArrDeQ6Lb0PjB3tI/2f8n47f0LRAGqU99EWV9u9uwQA=;
 b=gwzz61+NosScRwvH3bkfc13q8+BeBLPMYlsgnegn8iF7enrH2To5MbqzMn9xVp9k4rVaqhPvJurPAEeRKKt1HZ1GkynnQjZe83y8JOSEWfiyV3Mw7QVQXMlOnDCkQhGkyj2Vu50uEDNURW7DvGdG8kF/ccfdZ4CIjowuz3flzHnvJ3lbWTp1rsqA3HD1YwzfMrzxaqG3AJrExwo1lgsHh/UoGRpXh6dby3YNor6Exy0530OypUyX3q3x1QDuxbGGw39jfQzZ0rJqH9Hw18SreiX2ljY/N+IOTIPLeBV/bbSMj9uEQ66db458b/nzpsJVzGGIcu6uNV+BICRYNzB15w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArrDeQ6Lb0PjB3tI/2f8n47f0LRAGqU99EWV9u9uwQA=;
 b=kNfmOLiHcoY5zZPGRsvjvhnxePyD8hQA24+r5LHmnrshh5q9HXT+s2AuHtCuTfxDrsQ0z82BCYziCuIozXHefwRrBlz/cryQpJhrwv+vTjPWLN3NV/uUkkJSKwPYPhXkJZJlshRTJjGUzQZb9eNYLXdsvcOvXvNHGHqEwyDrxe0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 1/6] block: Rework bio_split() return value
Date: Thu, 19 Sep 2024 09:22:57 +0000
Message-Id: <20240919092302.3094725-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0469.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eedf12f-f997-43fd-8b37-08dcd88cc162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hXMq34ROVk6amKaQ6COiZ3ECIEOKgwjQxB2ZINeTX7Q2mmJxb9cCg+0tH1br?=
 =?us-ascii?Q?VQQtmHTMN99ZPyR8txqCl4rp7QrXQO9cMss0bA4vgZc8fO9c74bSIIGprPRB?=
 =?us-ascii?Q?Mz4NBNVhPFXmRHI1DNgt2pMTRE9NshBvXenS/i99Pt2adHbzDQkKCjThxjwA?=
 =?us-ascii?Q?7Wp1c55cWeP5R242LXkJYIei8fPdshDADr+8MypxnsMUrPIxU7QBnq/78+7u?=
 =?us-ascii?Q?BeO06g3sRtXyDMFC3Wf0wjkmuBAFRXvozCxwfuFOt5UczzuPHZOL/6X7lVNw?=
 =?us-ascii?Q?gQLa24Arr5clpFu91rno3x1qMu/KFho/qiq6PCMgt1aEABmE/X/pYvgEJMlO?=
 =?us-ascii?Q?YAH558JoAnn5Z/HehO3t/8DT7BnhzoNm5AjhdsBZ/BsLiQQOxPLBjtco6E05?=
 =?us-ascii?Q?mlIT0vFnunIxKTrt+RBFUU8sUtFrL+/XFtgme4kXX9CDCLZZ0hOL4piD8B0G?=
 =?us-ascii?Q?4g6JsfFeKThR5fL2E0ElR/IuDx97sWpcawXFxMK8LXzQn62ZquICZSEMhFm9?=
 =?us-ascii?Q?1QDZfcF10hAe+6/tYsZKi34wwHTktwnvmJeCNrBo7/9OcMG7fR4AealjodbI?=
 =?us-ascii?Q?tBWcDZ25nMduJe7DpmhwkgKfCspiU7nXyx+vS2vGwGCOVCPk/1LF3o40jujC?=
 =?us-ascii?Q?qMwY47VJ6IDRvH31BNceMNIZHWZSxnoIELrNbBoCs6hEPdQmYCsA5g0M1H5Q?=
 =?us-ascii?Q?X4HBuNschdjOGoKNUZLPy1mfRr3OVDMHbqQTGYyEoA1csgxoZ05kzx7qjeJv?=
 =?us-ascii?Q?szy1ElRSpCEUWm2muU7P56P6C/4Q1gb3+sCGIQpbSuOGpenwLBdG5W/GTjQ+?=
 =?us-ascii?Q?4ONKaYOZgxYjzEWDf/YiKMwg8KQ8pF+zH9sDBElYcDYL/HNhRzh5t1DUQleq?=
 =?us-ascii?Q?Qn6IoJ6hw51eFvJnxoalTVE6cjb7cjevCS97p1pHNFg6vBmFuFWYOAlPK/pL?=
 =?us-ascii?Q?LpR7X/kKNHuLlMWy3siBu7mYs3vwqzMitP8+0u9ub1OXlB7tspxgU3qu3W/n?=
 =?us-ascii?Q?6F47tZk8BNurHYnev5Mdu1i0Et5vJxLSUlkPW3H+5rx2C5xADPyaKzmLy6Ty?=
 =?us-ascii?Q?yFiuWKnxixV+cmIiEDurdN9EJvB05FXfMnkUxhKHXp4rIXOaecjFWC7Eu9d8?=
 =?us-ascii?Q?jMkpCvNe++LozAS396GVGdr/YGA9qEcgRKh0axt6zoOa+bLavSCU2Vr90DQ8?=
 =?us-ascii?Q?8eZ9fZ1S2N5PzaWfmeIQdFUpi3a9wC7tai18KDGHrWcNwFI9JaMEFFM6P8dh?=
 =?us-ascii?Q?SXq45OVa2fW9gFMvcE1Y1uPngatOKMOr4leoLVJvHzZRVwnkKrq+uxdK2fvH?=
 =?us-ascii?Q?mqQHc/4a2I/YHTu4yaQJkida1QyWa/2KPM59fvx6xAwT1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VSqKLQVR2JQ4TeooPExmD0UBmZi1ZZDnjAYgVCjw0USU7eOWBFC+Mo20nK26?=
 =?us-ascii?Q?S5lVZPubSWC4bFnCMFsztRvE4Ht1aVw/doe75IvRwzfSZWVMuiKx9dCVHS6E?=
 =?us-ascii?Q?2ZRawzrmAoGfLjs6C5ZR6p3TXm8OLVtRBJgp8P9i+4sF76ZdCuRsVyz2VmHc?=
 =?us-ascii?Q?7VR2G6x1kMO6CwLuP7zFh6BeMiejaatzo9Zn/X/xTWEY+QCmbOqm350YyM06?=
 =?us-ascii?Q?/4Yo7KxIrxyTEFL21JYwh8fAIMrkkDe/SCcqP6n8LSxgfoQN9wsjsfwv05S/?=
 =?us-ascii?Q?sXg7hx0Z44Y+5TSC7GSDPk/1Wpc2K/sOCKAQIu67280OMm5FeSR+hhW8dkc9?=
 =?us-ascii?Q?LvhxZWmvXfkMCr5Iu6rQ9sMDWZ55utKwMtNWO33xAQQ/ebDl+VsMQOz7db8q?=
 =?us-ascii?Q?fh6SxthXQ7e8542LH4yGVivOmisBhpRZYpxDNQJhEA6/M5taf3TKmXk1EIOt?=
 =?us-ascii?Q?r5e9C2Wa8Z0MaUvLxu26+I3CziNxzxxjfPGPjFq4XOCG1jKHrqPLMSputfE0?=
 =?us-ascii?Q?JzSc2nxsoboFyXPdBnugGO1TD1/Y8Sr8o0nk09GpThby/mifUvTIeasWyHw5?=
 =?us-ascii?Q?Wu4gCzon+6AFuzUU71jFb+C/rfYq5NxNDllg+SYIt1rsanG3kq5PUo7Ms1S9?=
 =?us-ascii?Q?MoAya7tS4nihPUT5qb1HOmkGC8jrIq3Fy9Z3onb/QHi6yVWW4Wi0M6Xe5v4O?=
 =?us-ascii?Q?JtZL5EUmCvfkM8ErhziIIyLMLCdhf6/1fQx4AUXzqcCA7npc2MLKA71hdVpl?=
 =?us-ascii?Q?ImmIXpaXeZgukX7CI3Ckjlt7TtD16trXSqpbe369xYPezmtsyakXDc0B99PD?=
 =?us-ascii?Q?sLYBCWs+GPLMQrNhu/73NJEjZuKPvRhj+9MPV0cUjrQYHbPMGXcRXlmYUUJ1?=
 =?us-ascii?Q?hbzVAHmkMRpVi0Is0GdfNgOJ4j8LcngdwpGYHZXkw2NH7a281HMi2fuYegbH?=
 =?us-ascii?Q?uDFvLhYee3yCKqJYorauRxSMIgk8pCcinYUmWBx0Cg5qa4Xhfv+q8qB+NCuu?=
 =?us-ascii?Q?7H+8q9l//oWAFBw7Cv7ISJAkOlr9Rbc7LRJl1SAo7xpUlVT1IP+SiXAHHAoS?=
 =?us-ascii?Q?hr9H93gvU0yZVGpQ5cNJI8C0infWIu3ashQrxzNo0iS8qrzc0NU704kh+/tT?=
 =?us-ascii?Q?f3wDUX7qjoppgKFjHJbEJnpf9T/+gRTeC6Z1dGNJRuoOuTOL2Usc6kIYnu+9?=
 =?us-ascii?Q?d4Mezyv5MOjyaFKDeFKNTw+dlHWEeIzI3EODrekFsvuffn2x7YmUlzgNX85O?=
 =?us-ascii?Q?VzDG1LL9MHuZyMdFyCyo+HKhrcjH8V71k9p/CDkx4X7TG6XVfT428yCivUTv?=
 =?us-ascii?Q?j6xnHkTqs9/ixN9v4DJ5Ese0trPGg99zdupgzCBmIZSg86LWMaary5xlnRBQ?=
 =?us-ascii?Q?78noLKRiuvd+7ZjfDdfufyzBSSg5+8U3Zw/w+7WU4QK9Tvd9ZLZQzgOAHIsB?=
 =?us-ascii?Q?m20MFYjSAAjT1WarRHwIZOQnbNCFr9C4tZXcMy64quR2B0xz6UIx6LW9L9Yw?=
 =?us-ascii?Q?otWX06YWVD30L5R7Q8GFVGoEcEzp18tGn2qaE5fCCF0WqdirJB3Ol56qZ+uF?=
 =?us-ascii?Q?SdEZeJ5AgspMXRo2Z6Do248/qKNpPgIwEBGiqz/XDJBlXId+L746j9UUlHBl?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+YAuZ2iftvtS8Ogr99IMVu6h15b0+P30YjDdVKssHg1VJIvNODMiM0WjABbMQHMMUWwnAw4BwdQTct6Ec4QwS6vDPjwfuSQNheVSc4MbtcFP4pQuOGhH2Lwr0uEBTXxGHUIj42Vu+aZXLMNXGXkvU6aGQ9d1vRVuCVmgv7Klf7gExyo61mQ4BsDiGDvAmpXAxqCuzQya+TUKvL9nlflViRUvrZrpBZOXIhkDIgcH0etwqIATJJWK82eO/j46nsnrVCPGqRQmuHq17YtzKVXRYFItRuel5/lA4wqlkKDbNQiaml7vRtd1b8EUh08UrXliwKd4PU4EEWAJTzL0WSY9txWkRu3tFnspHvBDgdEwJvfYXq+/PtNuiM/dxRRjzWykRsRXUY9jud/H7r95vL+cvGYK+56Q9tqkkmhK6Uw9eug4DN6uj6WgjLY3GA2fENmzWsXnAg4s4CtS9D+kuJVcKsJZGEdEr5je/CL+TvjbNV8ZJghOWV775Fqz79HeDOL8bCumKDdBFnKwYDodqaT+1mk6KcF3CVpDdFaab8SFfwD2AM3a/5kfneVfXRhh2Za3Ev3FpGot+fDpbG7fAzeL9dCCYueXZwwcCVETmK8fXuM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eedf12f-f997-43fd-8b37-08dcd88cc162
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:43.3317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W74jc+XFR7Ze0xiYVgJCXF0+V2CvOYGdOqP7UxVMzX2TYw4Fg8TufKkxczjCXDKbiYPfixryO0SP5qDmLLFXgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409190059
X-Proofpoint-GUID: EtLUJHvjoDMwSXgssH6khVDAloNffUf8
X-Proofpoint-ORIG-GUID: EtLUJHvjoDMwSXgssH6khVDAloNffUf8

Instead of returning an inconclusive value of NULL for an error in calling
bio_split(), return a ERR_PTR() always.

Also remove the BUG_ON() calls, and WARN() instead. Indeed, since almost
all callers don't check the return code from bio_split(), we'll crash
anyway (for those failures).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c                 | 10 ++++++----
 block/blk-crypto-fallback.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ac4d77c88932..784ad8d35bd0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1728,16 +1728,18 @@ struct bio *bio_split(struct bio *bio, int sectors,
 {
 	struct bio *split;
 
-	BUG_ON(sectors <= 0);
-	BUG_ON(sectors >= bio_sectors(bio));
+	if (WARN_ON(sectors <= 0))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(sectors >= bio_sectors(bio)))
+		return ERR_PTR(-EINVAL);
 
 	/* Zone append commands cannot be split */
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	split->bi_iter.bi_size = sectors << 9;
 
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index b1e7415f8439..29a205482617 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -226,7 +226,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 
 		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
 				      &crypto_bio_split);
-		if (!split_bio) {
+		if (IS_ERR(split_bio)) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
-- 
2.31.1

