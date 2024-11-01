Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A719DF53;
	Fri,  1 Nov 2024 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472422; cv=fail; b=VRjMrn0YVGXW4vlIo4ycWH91RgWmMbLLU8or6H26t0mnTOvNHp6wfYmCV/ZrFvSy/DvV0DLAZBjOe6qJijVBiv7TeAb/xMedjIhjAXqFXHxS8cHElPSAB/nOq+kBZGO5arzDunqHu4tRoh0GvbSk2oFTFt/tJ3rNgnygfaXTWRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472422; c=relaxed/simple;
	bh=JUx6i4OLcDLbtSqCsLxDX1UApTuAwuBQb3gIDTrL8W0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T1KSzQ6qo1Eqjo3zxbTW/4Iu1dhmFSY0VAANZDOQkYASsuNRyufua7hX+km/uolN50jUYyb2nx8+weiEPHzMk4TgKGv6gLq46kAtUgvM5EHuPy1XlK1CW+N9cgK2/xqJOHnUZRd+2Q7aq7XijYC2jAw1Z6l7YXNPqLVB0+PInDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XSXP18ON; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MOdSJxNW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XSXP18ON";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MOdSJxNW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1EibJg006582;
	Fri, 1 Nov 2024 14:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=; b=
	XSXP18ONSI87wl7jM2i+vNh5UTmXaqZ1t5VaImQthLDK7u3XAVjUYKsHFmQrJKz8
	YjDmtIq24s2otrBTaB+VY5b2B30+iIjoRtlAx8cjZlyrgtzNhgjqAFbMwlnuwIez
	DT0oXocoT3RuSvvKvjD5RI/TqmMwsjvN1s89te1T8zeEAE82aNCBeThxESNZV9BR
	1bUq7jedXsa7GYl6JwesLJU54Jtk891jJVH0nF/MKz9+7v+dTGbR4U87NDrz+2Ig
	nSyPQoMdXFKdwJMSPeX90Jc4S0QHkqTL+IRqqSw0cHcRNLHN8tiO6ZMhsgyJUWHb
	GPQNONR15AiAVDcFLgmllA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgwma5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1ClYJi011789;
	Fri, 1 Nov 2024 14:46:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnagmkpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doqWR9Ump7o1Le6rD3SA8NUeZVy6Ah3uxz7RKZ3rhrk2Opnwhg3/TPOQFBXXixAMwgwvLMbbnZJ9kSGZk2iVWoxx3OK6oAAoA8Hl+e1FhVcJ2csrIrhkCDrFm+ohMiyX8r3hr1cnz28ndHawZ3oW8ZAVrMsq+/2dWJknuzivyR1P8euJkESPDJ+3+y4haBv2zkuk0PHkuTqVkQ0F31VwSn2CnVupcB69vAZl7Nho3mqJVrWmg/AoQJruFQYs3/4kR3N7zzEdAVnuj6uRimXooI9m9EZzlxprjlXyf6yd6IAM8oP87AeTINlrhWh8r2JnF/HY46NVLhtN5BdUe6oBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=;
 b=X+5q654IEk09ui1e2OCey44NKiplVZUbI68G6gFGM6zfRk3YhfBhuhX1zmkvp4IrtGYqW0ZykRTAXrBfxjlrYqePkSdnTxix1ihaH4JbtwuGMAwar3gBMJ9asZDdkiiQ4x8yfTsNJc817B7nu4T6tPjsMKqxBfyecvEkK8rdms3ej+Lt2RtSK1ON/Ow93Q8Jl26IKiJTSQg+xL4jxfQk77TJbOKtIl4Nlagj7ZAHfirC7imTDYIpHEmqmhDQUWkQO+YES8hh5m77o06ryOiEBNKa+mow201j9WekDl0STCPuwqiWK2wbvtMKu2IlkeHNPjfS6ZZe7pNZSAym/dziXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=;
 b=MOdSJxNWT3TMe0p9f7P0DV5P+OuKCQbPeDm3a9jpQ57vokQ4zqrMR3I4WQoWZlyXU2el982wevIZWrBWmp2dbK+1iBFtJ92E2D4StWD3FaMBb5JeLoEZfse/cAYJQ40sLCbNpV1Y+v/YrCgkphU9zFp2pzQ9Pkn7K2vTb0Adg2I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 3/5] md/raid0: Atomic write support
Date: Fri,  1 Nov 2024 14:46:14 +0000
Message-Id: <20241101144616.497602-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241101144616.497602-1-john.g.garry@oracle.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:408:143::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a432842-e438-4ceb-5eed-08dcfa83fe0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p1pmYR7HxLem+vkQvf3V01KxtHW1ph6UUKVqt4GMvO3IUJ3H8TzyrQDQ1GME?=
 =?us-ascii?Q?f/kr677KEDW2GFdwt0Srb1uKfH7AE/m8nS9YC6+aqym3b27PV0m0SmdF8qWr?=
 =?us-ascii?Q?AGMUSatMYoTAi+1325lv9jJmUR9rI2HN6NX5uALf1AOjjnoGUf9BF+U6RJBu?=
 =?us-ascii?Q?f9852oiUowMUw3LrcR2sU14LWp1vwRaP7Rdyoq1gPgTgYVJe1bzXq1yKTM3K?=
 =?us-ascii?Q?eFUtho1AE4b3kH+UmAh/vDHd//GmzEN665dlVKiDRkAGJ2pSEqdipdwOfyPF?=
 =?us-ascii?Q?ra34i9fPCopBg5W60NK6gpgdWiKqi3F+OijAylt6ZLzcFQ5PtT07eZWg263G?=
 =?us-ascii?Q?1j/2F0H1s4eqMTnLoUUGzQ2qLLt1Pm+uVJxvhTzqPZBPyLjkztE1syUGY6bu?=
 =?us-ascii?Q?nDKxNMNoYsg6BdmRPXERrMNrwnX02RChVH/T+b/Rl8PCewh2zMswxOg4r278?=
 =?us-ascii?Q?GU0HhTYGyG+fEook0G/0Yxv+C7VVNFkZWiaq4/wKhkQzjWT2IOR+LbWlDXIM?=
 =?us-ascii?Q?qk7k447m1JlpTxGP+Xrj+4UT0hCCZxJO9jDZS4PrsusRVx96qFc16WjBzXB9?=
 =?us-ascii?Q?09yXwe40Zp7r106fI6h7VuJ06NfAEYDwHWQMO4OZBGhbpvtct5Djm7RGXbdp?=
 =?us-ascii?Q?3+o5P9c7nFXtja5k8QVBmmfOmvF+sElfRTtE6Vn7u44Y2NZeAHSnmYfH/nNN?=
 =?us-ascii?Q?LAivfk74r6QVtcbVF3o+K5k+3XWTw8zIdICHcoPzKg1ioeEal4Yw1s0WW+Z0?=
 =?us-ascii?Q?ehDMcZX3kwyQ5719yCYqWTlt6DT7vUH75vfiiIMUJr5PJFkF0jqcMBnIUKLj?=
 =?us-ascii?Q?QsBRv4t676bln9WkxZwCkiLnlxYF9+MxQQHLtqPEGjb5p6UtvJvGjUnVxRNE?=
 =?us-ascii?Q?XLjIkJg3yR08oqrsb1xvc5BMrEykLjVckWc/lOWzqAUI23PbC0/xK4cab4m2?=
 =?us-ascii?Q?5KINS9ofn/RiRskYnba1/xpXOAQBSNOsDzTPlFajm+Sy1RoOFlqEhyVZfoN7?=
 =?us-ascii?Q?NrNmvHliMoCuVTxBmCTvkHXQ2z5ZWBFbWLRZFtC+Heomx0JjO+iU8v6es4t9?=
 =?us-ascii?Q?uvCkjAGrdatHRWdBer1+zeULI6gBDkXXXTAcBcgp811hXNYZFIHY8kn3gqHI?=
 =?us-ascii?Q?GtjWA6shHb2h+z4tQEW0SWUVTdwi+oRo4mmvYbxWeZf6xcWQKadPEiX4GqK3?=
 =?us-ascii?Q?zd7CNpT0vqMLaZr3TopaNwvHTqvjVNrSt/iKS3QPzo0leau5Wr9f79iVCFj2?=
 =?us-ascii?Q?Wv3KMH6NbXjOpXa/r52C+tK8FRkknHDILpSuP08CDsYpcDUhp9unkcbp4dJR?=
 =?us-ascii?Q?oqaKdPdAYDYgkkuy3nYOfYSz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I2aaSVes8V8B1uZbq25UyV1o09VHVNA39yvXSulSI5wXXNFaNH5xgP25rPm7?=
 =?us-ascii?Q?XrfaqSj/yGzf1Gs22mee12SxrLgDYG1t2jS5Uf32jTQ1z338TocDUd6So99V?=
 =?us-ascii?Q?1iclQR2JqxLDSXy+yEwZY8eCJ/a8Pl16SQ2ZOoIdmzhboZJR23JpuEumJsdI?=
 =?us-ascii?Q?GPWcDHkfxymUaR50qHk95l4u9Hvj22ftrrfaWhkHrGClHREhBRAxj0by/Bg8?=
 =?us-ascii?Q?KucgE6JgSQUqP+ZxYZpSWaqeybIJV7R+1eyjsVZ/pGukz+W7bnza2+EZXUk/?=
 =?us-ascii?Q?cgAya54kAOb4z2pSqo59aZCmabElS57LN/p7csc57Fn0UkzqsmNjqZyqBjIX?=
 =?us-ascii?Q?2fjXWm2ivZkZ8gob/XRIedNM/Ph4g7o64rbbq0WXVLUgDd8M/0BZngWw9Ag1?=
 =?us-ascii?Q?olXxiLE/y33hEgvfB0JaBInYg2R6Xv0fAFfx5dyGGFsXeVT4lQGUpkbMS2lY?=
 =?us-ascii?Q?X2eY0VIfmfgxDfaa4vypfaSQZ7ze6aq5zjclR1llX1Yt4rWGFCkGfGw9hNbF?=
 =?us-ascii?Q?ua6KoTxmXW5PIPMJpK3vObLvyqhi2ZGQTf70siBl27ujp0C18METUIITblbN?=
 =?us-ascii?Q?zur7TUd9i6YBnSg+2Y7BjGoNJyFIOa3NoXz9WPkMMBV9qmfPs9Uh7cjbhYMF?=
 =?us-ascii?Q?OUmKkTau5u3U2H+BF1CTLsLbMIb1SVWvhVkT+yDIYqhbuAACDxvUp0pRIccC?=
 =?us-ascii?Q?CEj6S/G/Ee85JWsijBKr8Z4pWOjyXVJPT+TUEv7mAvsDBVWSWVx6sTvxu0Ib?=
 =?us-ascii?Q?Q+xOOi6U5z4L0Jg+5JLjG003rJ4Ye3nJljClR2JFSQ1DWzZltWGSg/zP9wMX?=
 =?us-ascii?Q?RwKOrpNU0eoRhc38WaVbzRCCH0qeOxNjrlQK+HWSGcUOHytKgaU26f1NOB4b?=
 =?us-ascii?Q?wxUO/Fsnm4kKl6ElZEpE9Fm/H1Oz3ztmD3yAzEvs7YsKn0xRraKnMSji/2/I?=
 =?us-ascii?Q?qnh8jc7QA+9kB4D0Hz5FkWjgENdUE5VStTWvLxvUFjIHEeoAhTBSlIw0oB0l?=
 =?us-ascii?Q?0gkwUXtd+3spV47p50O65QgRzy9oKKwPnH7CeCVVvRWTBbqOHzdo2mQkySQI?=
 =?us-ascii?Q?4wGJzN/cFnJn29BHn6Y1+nb6G+g3tPPwYGQKxc+xzBvwicMzE2QU3rU56nUf?=
 =?us-ascii?Q?+YjAdw+cC3y7QnqqKM7wilO45Uim45xAwKtYV7g3d/fpzWMCqDn6iWXHcvyL?=
 =?us-ascii?Q?Xe4FMIdKxIxwhKyMcnxvTUhtuV7yu19yVUbBX6wUsubAkdTmP5YgE2Nog9Ie?=
 =?us-ascii?Q?A5VCwJYj8TB8DmNmjAVbpRTj0yZIOQBxoqoIJG8X7V0f+heNx5EH0IFPHNjm?=
 =?us-ascii?Q?fi2F2Nij1FqRhLzArb/sIDmiz4owyXjJB/MYd6J5G8qRDx9oOYH25iV3o4ae?=
 =?us-ascii?Q?tB+wYOOMuZWEYTJzyCryEWVnchxjvKOXofGVNANJg5jZO1g9MW5RjDBwoWkX?=
 =?us-ascii?Q?UTjesFQh8h613dl/Inh6Ychymeg8UBCVmVT7XILMaOt6l0BTPpP6rcYGSFW+?=
 =?us-ascii?Q?rQG7LlsDalG3g9dmK7tV/aWymOKWs0cfjYlPVTZHj8SsY9CPtCgiv/8HUuLf?=
 =?us-ascii?Q?ThSsmL/v8s9ecSeV2Mimk0VTwYskx2iU88Dt6BCzQUnsSWGPvI8Cvwf2bybF?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6PMVD5Y2c/3KzlTBSztYn2XjPOZGxsT4Zv+uWBLVOlyaLnrHG3etGhU6hgvFg18N013K0g7AxlcWg6qwHbPjWXXR1LgPXc0uSGX4PY0E+wYql70V3TVJEZEsTC+2NEaqkay/L0Aqh387esnvTLV+4m537YO/SnHeJHUDB2zlCtb9WQxsmEwwn0fmBxZHMmA7W6wdhxYHC2R4g+Am8oKdF0Iu3vmLvL/XRiiVWTyhpaKrjEa+39SRIe5/6MP+uJOXCMIf9JyxsboFsE31aLzhFgHbIzxE1uVhyz4yv0J84RUqfLEkpvLgIuV9X5MYhPvVj6r7bfBJm9zqAxyZrRixYj8umc0TG8Q3ozOu478FehDbhR1IbtySnUoh1iGtTSFFQRhUih+uBDPFccXRZutz+SaB9ET6yT+CNCD50ygcvf90dzraj/DAZhq7VcahXPVPi0IvuPpYOLXrFa3a/5W+iVmL0p/Ze6PwS+dXT795pOTDBJLtR06pB1VIPNQssEMTQLPfuQH4rs1x4KQhqEcXHjcw/rZearXfJ1Z/YpJTIlbL02FhgRbxhjuZ17LAMEGnn2tTyBkrxz3TLPXmKj11Zhnn+FWct7DngziL63x6W+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a432842-e438-4ceb-5eed-08dcfa83fe0b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:39.1415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E55vT52wm/F/Xu//mwKf8C1CQN39y4nQ6u8GGalpz+HEfKAHvUbowC8pZ6quWHh+D5gcrK0QCD8MYnsNLtrfgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-ORIG-GUID: 1XoUxErWDnZqIrhX6Htxn7_cj2reDvei
X-Proofpoint-GUID: 1XoUxErWDnZqIrhX6Htxn7_cj2reDvei

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes. All other
stacked device request queue limits should automatically be set properly.
With regards to atomic write max bytes limit, this will be set at
hw_max_sectors and this is limited by the stripe width, which we want.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index baaf5f8b80ae..7049ec7fb8eb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

