Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7B524633C;
	Thu, 31 Jul 2025 05:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753940215; cv=fail; b=YajTALBJEZ3l3fl+jRD4hrKKjB+3PujUtrIK6HqeJwp9tWW8ybWMGrA6L7dW6yZkL933NI4HgCyGRrRkmDoVxdWxgl6EeudBuVpEn0igGYKye1OAPwmjUhevImyeMf4zX9csPrTWVhq4f25s3SeLnHyJ67wiTt78AYAKBNoAH60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753940215; c=relaxed/simple;
	bh=z0V5SHxW9KGbftBQf6LdHWLXuQiJg1COlyP5INjBlAs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kaMNELDFU9nG78PhXhjU51XI/8hByHCFFa/0zzji8J1Q/9n1EFYNSMbrjvoeu+32xda50EKuEHEWXm59MYNoR6g+q6thksCpAfL9HUGq0n8bwbulZ7PdxFYjn463K5FZA6bzk2xgyqXrurFdYkc5HwMJAv2ygUAWSsdUG5dae1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kpQqQxGL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TrAfrL8d; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kpQqQxGL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TrAfrL8d"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fw1d021472;
	Thu, 31 Jul 2025 05:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yB3tl+Lg1J23ZNj/Kr
	U/FxPQRbiUVs5CpV+utUHxG1o=; b=kpQqQxGLB6HqS8A/7kXNotY4Yo/TvO06NB
	bS/C1aPmHHL5KB/+wwwzPcfhAuzL69SN8twjlyV0yyA5/54rG+D6b8IyRG1kj0Qm
	UpeWDVc/zTjYmyKtZpK8CdhrAgW401rjmJ1OV/Ri5KWGw62gBL+dDZaEJkcpyEoN
	L9OHi56czdrgce6jL41b0H2TPv+8DpB39zq2cM7C7swWGiF8kHD2V5q2qhXM/z5f
	mKy6d10LahzFJfMbgHn3v6bFfEd05qNS+MgNDYQJ/u8pSxQT5DxQwh3vyrFenTHr
	HcecWhZCbPz25j4wwX4Q2KZqAloUBzQbfX4Ku6UC0ntvoEX81EBA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q733d7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:36:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V4vret038474;
	Thu, 31 Jul 2025 05:36:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfbt0s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:36:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNirJJv+ORQXINJN4/+oJaFOAm3sLnQJAFpakXtKQgrBphbGNWoi3XHKHLUQmqpLfYccw9Lix6vSBzIRuknWNV0M83AB1LstTz3sD7PUMrkK/aFrjQWa2uYt6fg//bLZLWpAqh4RTwD78vF0JkA4mLqcrQoguEUEMJBCFCMjn6gJlW+yIY5W4ix2va+CjVgFJZglJkUW/T1pyrawq7M+NcoKGu8zJd7/oOPlGKw9HVaZ4AviKf7+ZNXVddo6uCv8xyDM8HF8jWvCEdtyNYm7/kDX9qAo1MuwyLdyS2oQ6rmQ9Z26RwIlZK9tc99QnkoYKcImFHYHMdxzYqerX2RbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yB3tl+Lg1J23ZNj/KrU/FxPQRbiUVs5CpV+utUHxG1o=;
 b=s0w9aFIOfvtC1YYT5Xya+VIXuxs0p8lXRw5h9z05klLFXnRrn3HpqVE4thPInJiotz1gN4uJ9mXdiZphCMA1NLzywqVYRd99Bh7Rm46cp+RgEAhyaiFAd9onriKXAyNL6cuCbZW0XQRKYEHraK2WREtG3qLXhyBgbgkPAB59sld3Vvw66qk6BagBsqfys/5R0SzcqiV6JFwmXM4El2S/3mcS0trwEd599VfBhu0LgGDhGNToOEN6wUFgQotloxj7JXSieekNJzhojg0QeAl7Hrc5Ik3aD4d7J35jMSuZHpxCrDASalz/GCpG0cjpTOReDVkyCB1wlRjZg1cfRI/9JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yB3tl+Lg1J23ZNj/KrU/FxPQRbiUVs5CpV+utUHxG1o=;
 b=TrAfrL8dllLAFsrmXeI9343lEWvOstA5E8kENu9Eupv4AvChSG7mJbKO/TBe1mThVY7gmihQqBNbiKe0V2XIkQsWfVQXSprMu0kLZ5ZKGqRyv19qC2wamna+IWQMMw8hlnSUFaS2AzK6UyzMfdu8YiIjT6b9mzSSt9yWP+9zraI=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 IA1PR10MB6781.namprd10.prod.outlook.com (2603:10b6:208:42b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.26; Thu, 31 Jul 2025 05:36:19 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%3]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 05:36:18 +0000
To: linan666@huaweicloud.com
Cc: <song@kernel.org>, <yukuai3@huawei.com>, <martin.petersen@oracle.com>,
        <hare@suse.de>, <axboe@kernel.dk>, <linux-raid@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bvanassche@acm.org>,
        <hch@infradead.org>, <filipe.c.maia@gmail.com>, <yangerkun@huawei.com>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 2/3] md: allow configuring logical_block_size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250719083119.1068811-3-linan666@huaweicloud.com> (linan's
	message of "Sat, 19 Jul 2025 16:31:18 +0800")
Organization: Oracle Corporation
Message-ID: <yq1zfcleyqv.fsf@ca-mkp.ca.oracle.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
	<20250719083119.1068811-3-linan666@huaweicloud.com>
Date: Thu, 31 Jul 2025 01:36:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132E6.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::26) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|IA1PR10MB6781:EE_
X-MS-Office365-Filtering-Correlation-Id: e97c6da3-f5f1-4913-cf71-08ddcff42c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4sFNGPH51a5C60Pt1Bk0kQViEatbgeOh1Gci4gtQ4GnJWOVh0H74P3s2TIEE?=
 =?us-ascii?Q?IkHS1ubYSMGQcbK6s+phxXZDwd86Mop5qTr7JULVReTfGB74vfD0QckuIiwW?=
 =?us-ascii?Q?7FEXgYA8TTLitfQ8i9EBGAJCaojs4Xp9k1j7XrJSTSGPvB0hnQl0Zm2VhXck?=
 =?us-ascii?Q?iwGpRxqZ3P9OHTHCH2HkQ2alzZmjAKZyFvyehbtDvWfUmel6DqY9kQjYDCB7?=
 =?us-ascii?Q?KGjjzWYSZNBe66ki0+wVDZNB9g7BoKqd9fqqqKp7OyxjZT6VrtX7vi1Zpj2+?=
 =?us-ascii?Q?8KfE2u+xJxI9oRq1unxLn4x27hqVEXNY9xAs/V+Mnj51YTyF5Qbiapr4/t/g?=
 =?us-ascii?Q?BYh4KEuo1XyVvUX337bIeexOOyZ/DfbIFKTzbEHx1hpmOxd8DLuzpyRsNQvs?=
 =?us-ascii?Q?7DVi3m7Nk1I/jJL53j4il9foJIvwBQzDa/4/gY0LJoouSNrPRN+SjNla1Qxu?=
 =?us-ascii?Q?8XAuFY4l6A943BOT2xCgo/F2vmCziLF9kyBiEBZuVC+ZaEb35Gg4HtwMl1wh?=
 =?us-ascii?Q?FgALlWoLhbOny1Ez9U3mFQ1mE5bdAc6iluflHS399Y+gWYgmuFQ+6qdkhRWh?=
 =?us-ascii?Q?MtlcB5PuPpPMZh/7S1v+LNBaBFoUzapC7mo1yS6IWPd5l9eFAOMReW9tVSEV?=
 =?us-ascii?Q?zjZHlzjy2vRW/okWhryvNLD7XWQAlH3o1AJ6plwPTJupdMPqlojNdX7cg/2Q?=
 =?us-ascii?Q?AoqqP33YGINtXFlg8t66iPe0TQY2CWAOj58AQvEEx56wjPjOGqwYAmmYTWZl?=
 =?us-ascii?Q?qVbot17/6zXHLEmUIQkx8RGmt5Xri1gQv4EaiO17tiuhbblPrgHGN4nasLL/?=
 =?us-ascii?Q?B2JqxWS3PLXGUmIavpxxNmSBbS93mn4c15Xg4pke+RVv4A3ezUgXDgKTEMEZ?=
 =?us-ascii?Q?281wbXuXPgPBHMmpz+YgNtn+ATZlqpipEMT5z++iFbMh5IJXmo/4Dkspj/bC?=
 =?us-ascii?Q?/QkC805bwInbnMkzH+5xJaYZ8LFwGcEVjv+yLhE269akVAEqj+mdEpi6jZZ3?=
 =?us-ascii?Q?klSx87xXSBzIA8U3CNp1eokiZtxXOXnhaa1J89f+Nh4UL+zKrVIGDmYHAIG/?=
 =?us-ascii?Q?dtxFE6GbLkE7DWyXjbHQItfQ11VLIQToaBIWJsJIJYuGRD4VDR55+KQgnC/x?=
 =?us-ascii?Q?W0w6VprTK3QDUQzVOz8XbGT2ge5GDc7ScWkBYunDPH6UYLBIuMSVzlQjmuMY?=
 =?us-ascii?Q?hORZjwKnsDoUDH7Y4CJ3hQqRtJq6IihBfAgI4kRj8U5IKkhjC2lecnIiPC9N?=
 =?us-ascii?Q?GbF3ZTgU3FtTnh5kteddIKtcoJ0KGHv+BYbMwLa2d5J7q6l3AjtZ0nNVZcYU?=
 =?us-ascii?Q?Fj1riBVZrkNEIHHuR6MpB5MOF2cMJzl/Pxs+swIkqe81JeONdgsRhijnqNDa?=
 =?us-ascii?Q?ScLvRJGly+c2SE+mrPB0h2XmZ/R2+Mktso+0zjQVUl8juD9tFU34XIZ6P6J9?=
 =?us-ascii?Q?g0ftS/MmmsY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wDe/P5li7PSOCe7f4QuvNINEc1xypRqy5yJVcfD9x2bTIh951DzUjpAMlkFI?=
 =?us-ascii?Q?YyvGIliIeQMobh6KBr/nBMR6kW3PhvqRNX56EzTrBeDI0Sj2UI2ndl3c+/c4?=
 =?us-ascii?Q?kOvN+odFzGfeiJXFakhrrD/woJYVvL5N3D9NJfKZnBtg7ApYFepMAV8Kxvd7?=
 =?us-ascii?Q?gzC4uk7WuFP/UESUTjAPfhBN112G811Mp4ktZst+s82uBXaAX+2Klk0NYTTD?=
 =?us-ascii?Q?k8Y0RTyu5iiHxam2nMsk+RLFsGRB3abPFbjoir+PB3ZnQzmgvbMD4+xi1vYc?=
 =?us-ascii?Q?9jgJ9EeAIxQqCVeCElrass3I7PBkvKpR1eK01pNIKgr2lcnjXZAS0a5h7f+i?=
 =?us-ascii?Q?XIyEhnMhS/O8us00jKTHHs+DJ86rCNnATZPRxUP2P0sGlt94YKxYHthw9gbK?=
 =?us-ascii?Q?nsIoRoApdkIP0eA6hB93CYqO7OhD259coMPht22T7/Wzdu0NYwfDAt7LObMw?=
 =?us-ascii?Q?iBiWX55XQlf5I+fawxX3f+k9s0R+V0N8TuSUaETHJSVXQ0gwPd3vuXQrcZ3a?=
 =?us-ascii?Q?r6xLBpP+XQAPZFWyYaY519g5nainUSnvMlW36GNbVam5rYihDArdxlivX5IR?=
 =?us-ascii?Q?DJWilLBDfX4TvsXgE2gUQYsOlcS48+ksvXN73Z3TX6amUQh6LyG5rD108ofD?=
 =?us-ascii?Q?cGC/nvWXCYEgN5VTo1SzZmURmj+tGaFzztE6y6FpxLtOvT10P9BcCplFmZtv?=
 =?us-ascii?Q?8lRTd67X+AkmaLJ1MAM0qy/yL0y4VvT/cg3mVvEZf4Z1PoVU35fc9mFbF7Y8?=
 =?us-ascii?Q?IctSB3nz9OvqjhOZsTjQz7yQkgwPYf+kdEwBMkXx5V4w70XjxcZkWBDpsYat?=
 =?us-ascii?Q?daDxqBj+eHmAw8IZBbF6PlDLCYN3padsGcVkjEd1e1zUfAgbUBxtVQB4r+Zg?=
 =?us-ascii?Q?LwUal2msPT2yHqjMtOlwcuNjqXpqP1FKAOIBa4zClcUqtx4HKNhVZbMJw7bM?=
 =?us-ascii?Q?0XFLynzyMEgTBJJLvIFT1kvspCsApd+bta3LuK2BG69yUPYmeiPeHrxPHzkf?=
 =?us-ascii?Q?r4kQRoGu76+L9fpRECoE5MsXcTLyupv0wDUY0MCi/5Z4PstJmEBuRgvTx7Ag?=
 =?us-ascii?Q?HhYao2ED6dTkr3Itz+nT1w4QhHXM4GjgyI8Tz3a0qbwF4cAmpgzPB0ah+KBD?=
 =?us-ascii?Q?/na5IHzADVYLvWROJ8gxF9K3KWfLyMJG4eDGanNlt/3V91k3taFXThfQzMMh?=
 =?us-ascii?Q?495zP4pJ2Qeu5bvq2OG0tTauZFlPh4wMXb1mjUpfw7XnnoskWNxrL5qxAFp4?=
 =?us-ascii?Q?h/AK+8G1xw5qAiGgnXl4NMrGBwe9WGPUVPByUq0hhE007G2+kRPbYPgmnrI7?=
 =?us-ascii?Q?lOOrp9x1fYuFQWGEG9LE4FA/5RyA8VowCagVpEtfF6loKCq5Ip/aPs1x0fOJ?=
 =?us-ascii?Q?OAXWOFr4Ooyn38G23Jo12FqqYpkIO+gEZeAGdcgLANe9sdl3EtClDK8Oasp9?=
 =?us-ascii?Q?9TNv5qRPwkZf1JKXT0s8muHNXMDOKFAZfwKV5AO9uSpdFWkKabp7dMSxK4XZ?=
 =?us-ascii?Q?0xNTKPJKz0YvBZlPJsxmLE8ByohBg/f8XFGn0v2y0SAQRoCOWz6ieklzal7W?=
 =?us-ascii?Q?PUzfmFT5ECSQT1QETiF5lN3CkHSqnai424Axlr0so1ao1HBgMhIjDWOLtM0r?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Gr3rwBISfdBEE4aauO1Vk4IvMM4b1gDpBS0kptg9O3XVq95OZ2/4T1Iw87WPschSo/aJS2wSpN5YnH+U01R8omZotsR+KiH2Ygxn30/BGi6N8/j/RjrEbX3svG03IZTfW7LtJExIMF/eW8ZlFqbqkre1fyJ+dC0YW3Jb1jnU9yVP8olqgdyOqfks+hDNFQoK3k78avXxiQKZ6Rbz3UWDvEEhgiCtsII6ZKbsOvD0m8MgJEZhBDEEx5oKDXcVgT0MrxS1jjlCaYxgorVmNvPTLONzO00oyK7vkx3uB3JiGRFg99Y000BXYtYICUfa3KU6pdFfAI1nCB3t0SX96z5J4P6O6x1SC+iCscXOKQDGmJPNd3l49VHaNWH+yMgUyIGajTeSgl3KMTchh461TAe6egDG6yFDa8d4o5eFDIY3/Pw4DXnq/hbQieH9OpPplCy+CTwsjY+h8/nSOgiFV6ISBiy7o9GqYwwpKfIzGTA8+LOiTdyTttmgG1WoODLkNta7Khtp1maGBWj5UkyorynzzOcW9SjphzRrekximkQ9NG975VBPC+N6cxxj7dUfYzPJaa73sjbnB4lhJfIY5jrbFMYFC9BJbaxDZAoK6pFgk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97c6da3-f5f1-4913-cf71-08ddcff42c3d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 05:36:17.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmCs1dQN53fVrvXpHLRSsnEQESyt89pf+6bl2CbGe3yyDKiaBKbHBWp2N64e67WxrYkNXCWpYd9xAHBYkBwcqHFpPH30b2tq1gQhvXFHGmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=842 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507310036
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzNyBTYWx0ZWRfX9UWXUezrUBZI
 IRAqQIn1+KrreOm3IehUF4YfimVYsDsJV+ZQU3qFsssf1ESrquc+ySa8eDToS21a/BQxUHxPSgZ
 ibizXaSQFqQknQ4q+utDHlErWnHF7/CXOPjWS3UhmVXE90Nmx9+PJD35aWnRmwu9+cVB3CDM9WL
 oQ2NXg+isWE7FeIlKEO9cFsSmKBg/6PyW6fBUN/34p42IsT/uG/BVcHXW5BY8hWTGWz8h8601MM
 kPVHKVgBAHdiJM93A11LhdLNi9rz9f8tsghXokzfssrLOywEj4NdB9KDXVZ6WMQAC8Tv7cbr9SU
 Oj5lbWFw6zraxk8+Rg9ad9hYTPSa0D+6ebaKhYHVx34el5nEsUmkPnwGrnVBlKne7r8jMtMdJfd
 nj+WWQXslufKjex34eN7xKyhWXiKhlIWAucXNrE75zRN3uIAn0qEn80LuQ+YMSpB1ApIo21I
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688b00d6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=6hNKnAdGMHbZiUPP1jUA:9
X-Proofpoint-GUID: lVIW4Z2reQWUkLdSvaEEBjH8I4JW5yyj
X-Proofpoint-ORIG-GUID: lVIW4Z2reQWUkLdSvaEEBjH8I4JW5yyj


> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> only disks with 512 LBS are available currently, but later, disks with
> 4k LBS may be added to the array.

Having to have the foresight to preemptively configure a larger logical
block size at creation time also seems somewhat inflexible :)

In general I am not a big fan of mixing devices with different
properties. I have regretted stacking the logical block size on several
occasions.

I am also concerned about PI breaking if the logical block size facing
upwards does not match the actual logical block size of the component
devices below. In theory it should work with the PI interval exponent
but it is something that needs to be tested.

What if the MD device's configured logical block size is larger than the
physical block size of the underlying devices? Then we'll end up
reporting a logical block size larger than the physical block size. Ugh.

Oh, and what about atomics?

-- 
Martin K. Petersen
