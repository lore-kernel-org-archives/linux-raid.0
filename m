Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C1418B46C;
	Mon, 11 Nov 2024 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324150; cv=fail; b=ulvrbRUOvtBpkmc0KAsN5VgaraIbY6PyKUL6o2aV3F5Kd+G8AhVyQALAow1Hr+bgWuO20oOSy6Ht9DRw96RBP0rSu89XuMvqdTBuziEkvobyFjmckavIzhgHmYCyxbNhvw+erTVG9m4OLHC+KkCsRaJzx+DCYjngB1SDDL8f0Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324150; c=relaxed/simple;
	bh=JMXW+dpUldYfvIg5+MpV3OMmcT/Cw9gFIs07Nbm1Ph0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=AIatiMxT8XTPNr6pq6ZR1fb3+F+Cc4udSVW+BF9Lkw8ZhgruGavtLTabdauzIaaPf8d5JVDZKHl28/boP5oti6wzK5G/fKL2YpXxMYclf5BjAfVmqr7ugUUgIIxmaew8t7/BItGVSRQP8bc7d5DJtZ8FY4SzdSz3jMiBcsRnv1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YNo2wO4d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tnk8/O48; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YNo2wO4d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tnk8/O48"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9soJO016878;
	Mon, 11 Nov 2024 11:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=lW7xLJx775TW4ZmL
	a1UoEIXWqUGlXXuHzSlme/e7j0M=; b=YNo2wO4dT+VQ/IvwfQVDS7ccogh45lKV
	UIB+T0RVTHKu/0+Kgq6Espj//njCqej17LjZca3aspCGHyrQaWcBXdrtC54pfhjN
	08QOFomxUtPzruNrHNa2KwzCYc4yfR7PBCoOH2whJvZY31LgqBzq+vMWDX7225+B
	WzyNzv/pZuM8i1ZvtYJ8kTbC/zuZ0Q5a22LjfEVpR0F0FvE157PjatEJqKNsMFnJ
	zG4uGydraJrfD3vN3meRy3Q9QVgK1qjtYVLgrnQdgJP9pI2sWBR8KkSHTibMdPpp
	xVsEycrZXS8+bI63mvTFAd+WH4oO+g9szFOcSG+QT45m+l0s7vrRPw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hna7b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABB0JNo023621;
	Mon, 11 Nov 2024 11:22:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66ntxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sv5mPZOnmhChoWZNdN9feruZPaxp51OSrKpq3bxwAKDFdpEGJ7l/JrzxBhE/mxL2VKfU8LuCBuexfOrapOq3Ap/H/zW0muPoYMuXF8ZCSWGi3ru0bynuKjnI121SKMAlqyM3ixoIp9Fc4o/vq7mNyCv4UrRD6X171thPJNwqYuAOzokRvbfY05kTAG93M5bKLgjnnmC7FelYkeT/4Rpi0WefLws7N0paU/a9XeJVn1buww1675sA33hS4eTW9075HYMVispv9lkCoflMvnXhl1ZUcK3pKBD4oivLjhzRbiEeyzDvJ6CJaFxqi3R1nvqCy4/HtNahRHsPdOa8UU88nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lW7xLJx775TW4ZmLa1UoEIXWqUGlXXuHzSlme/e7j0M=;
 b=K+92eM22x8PIeVU6cUja67UTasSQWO9/TfYWU9Vg19BAQOkLNHoY1QmA6p4JP76AaICMb5Igc2rU2o7FYHKIi3s3IY9WhSx/gzJPwsHuZ3YOFI+ZjcYEtz2bJgn7Sj7mCcqKNCfZVIXomSBmVlVt5DdtrpTg38f9o899HRnmympjoHi8fTu2fO27xHBfqmB7mUJICWzyrXNDnGAU6Wrj955GSHBPoHa9l8DQX7cGz8BXguBsMR3SwQ6wnHOT8Fk1/uphcUcje3TBR7EoZ3LncJXyPO/p93qY4jOhHR4cEH8flGEC106fTVTryIKaNy+kQvRk7a9MaDB5wpa0+6OWKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lW7xLJx775TW4ZmLa1UoEIXWqUGlXXuHzSlme/e7j0M=;
 b=Tnk8/O48CFXlxERNgG1HjmbvMYT9BVhANuUJC45E5lIKMA8NvpxtSukAecrjx6hD/lqCtAOFTBjmc6ORQNgCrEchPcVRRxYMkbaAoPovyt9Vp/ipTpeGyqNr5EYea8OZ8Gm+WafBId3hI27mbSav5wDRdOR5FQ0sHL0O2ve5VfI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 0/6] bio_split() error handling rework
Date: Mon, 11 Nov 2024 11:21:44 +0000
Message-Id: <20241111112150.3756529-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::40) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b404dc-b7bd-4491-5358-08dd024314a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0TXfO7JUq3YYOE9ciDYI2eOwgvVXiac/3LhbXuGwWY2v104K7DxehYBPICDu?=
 =?us-ascii?Q?hs+JzjmlefZs3/OaSxHcS7ZG/H+kVQ98EHkWwwoitn3V4JQg1hupXaCwln5X?=
 =?us-ascii?Q?kus6ytG18j+dW68nFTbF0Mxj1+VNFKQDSwMEjHuCt5VzeAgjqbkrktEQ6pT0?=
 =?us-ascii?Q?/D1FCj5Hw5C3ZpnC4hGsNEeOKXtizmsdFsvHK7TCJ1Xxyv9Wr16+BaqAmb7E?=
 =?us-ascii?Q?INmsw2ZkLe8MxmLImXoR/pyHTP8LdodX66e3zqTzILDkko2rXQAKN2M86V7Z?=
 =?us-ascii?Q?Yucj86RvKaU7JJ2tJvVJV7EWISXsx9OxxrbThexh5sLYbVEWafcAm4iXhDPL?=
 =?us-ascii?Q?XQn5KPNcnWt29av5AHyJUwyRk4L08hIeZDTA2Zqkvkpa4cdKdnfmDskCzpUN?=
 =?us-ascii?Q?u4rVfekQlCfkIV1vFQSy2GyTpzhADQIgMeHJ0fp9IIIm6Itgfzg9gv5R22gS?=
 =?us-ascii?Q?GTyj7KJJ1C6YcLLJrkkI+NzF/OvV2Sx1Z7Wfh2yse/Kt1GbRpgV2Jlx687WA?=
 =?us-ascii?Q?0kBAyWvQilc/EZSHXK8/Pqqd0z9REiwE0F6S2YVjItSVkgzwiIwTSQTYvSh0?=
 =?us-ascii?Q?ZfousG9xHMb53RL/DQxv5//uG7Mhusio0NRdHDIX6KszNmDXVjTgzTFksOp5?=
 =?us-ascii?Q?w6SCyg9EzDc4k1jDJU4okQ529gfg0pm7IHWTK8JBMwdMokCJZvvv61kNMipr?=
 =?us-ascii?Q?qMVHay+nC5okTPre/GA3rRdX3jDtF8mtAvLYoi4iybLO78Igh/fhd/pyNF7w?=
 =?us-ascii?Q?OwuG5X1w3eOZNu68BcqVgo1toyiRj5ZblpouUngtkCRBasbgHMmd5QiO2GZL?=
 =?us-ascii?Q?SOWFrJxMkjQOt89wsDAp7B7PLJLdVQ0g8fJzhxxqh5tOJIjT1gP72Dpizlvj?=
 =?us-ascii?Q?xPgboC35UAMf4ETAlFjgFy3iyLsT6nnO2XpBg1YisUZ5nYvw//wNmtPTiKiJ?=
 =?us-ascii?Q?WXYQazDw8I3A2ig619qzAykg0/lx9cl5p1bhTJiy92f8vXCqnLtSPEhLFwh9?=
 =?us-ascii?Q?eyT3xyDB5Cbw8RnuL98UW0sFTddMuCSe7pmjeOJpRB/9vU50lor7e1vK14Vg?=
 =?us-ascii?Q?ULJMuJubeMgm8wOBr7Kvp1znP+YHlK/Sr8H/SF9Tw+p6jOnct0yBEtBzd5KG?=
 =?us-ascii?Q?gAOKLLb6IsGW+XthUFt9LWSmwJXQ1nQPgf23fDPOSOtBmy+nWB6EwPmbLi9B?=
 =?us-ascii?Q?6eTFfbdYjJe+iZF2ocqcwM2D13MKKd83i99xrrtz5vRzgwbGeoV5IkLPD5Yf?=
 =?us-ascii?Q?ow1FrhWIDNWsggFxdKUgSB3jX85Sq/EJ0dvDVJ49sg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i0Xx0JUV2W93KhjzOwrV8qcBQaqELth+5X8Lv+BPF510fxXBNRbRGMiwigtl?=
 =?us-ascii?Q?OpTbNGGtnnTpfYD226QiZNlbChtOnv6fXusKDlJyqCRlLzABXydk9uuUEItf?=
 =?us-ascii?Q?nGuAobl8Zre5OqahABpqlm9o1iQOhTiuylla4NoynTAHEdLi8txeSbLBnmdU?=
 =?us-ascii?Q?Uer1r3RHU7feWr6p1ARNOBmpB569V4jKwfKl70D+hNoL5gwYuuFX1DzUiskZ?=
 =?us-ascii?Q?4WH4zeZ5+1aLMhDCOKPJvrWhurQdTdaKX5QUbnN84lIUsMrKMqhzgHwY7LBJ?=
 =?us-ascii?Q?Z01gFLf8Yz+EviUdT707GFFwJi0/nftbhAyL37+Y4XUNs8Be8EVzsTRnIeuN?=
 =?us-ascii?Q?id+lxYDrC0QwlqjqwuuAiu0tqn+AR7P3ptdol4FNK8Pk+qvt2IOeZ2fRAOPe?=
 =?us-ascii?Q?Ch1Q7zphW/QGbOi7y22vfS03GF71nPXaK5G4XqQ1xd/nLSmmxYxDxjH7PbsX?=
 =?us-ascii?Q?4PupFSxvrGBIuo9I8lBy74zCyGOu+oUHybmZB9Yl3pbRH8l8dpTbEQJNSyB4?=
 =?us-ascii?Q?ERWI57Chkua5DWy8yhwlZwaX2SXKqk6AdY+dkAg7kHe2SZ+bmA1WvL6uttxT?=
 =?us-ascii?Q?XK0oDhawme16Aj4t+j7WjPdE2p7V0EuUqTdNglbg6snjeEGGebVxZ0m0C4WR?=
 =?us-ascii?Q?AXBv65G+zLdwg19fvFp2q4LehNb/0m7SLvkFakc7pxHPLQEKmZWA9UoY5o4Z?=
 =?us-ascii?Q?zLRQf07MoFi3m+vyWbu8xvGd2lUxiuN9pMTLA2hLO4ZmaaB/yC8cwmHjFEy1?=
 =?us-ascii?Q?SYjCWRMuHvAYgpPGXx44b7nyCYz6k9/3O1ednacrLgfzOrzril0rqJL9mehK?=
 =?us-ascii?Q?w8ZsTY4xSD+GiUgQVDMZfrBChjxB9Av1zXVUiWuVyv7Ib+vFrnc65e6ekZKX?=
 =?us-ascii?Q?RqsUbBAH82dhoMKrYa0BH2dUoQwLMDmalgUuFQGjw9ix1oEZYDCm0u5BDjTj?=
 =?us-ascii?Q?Xu6lgtFl/qSq+0Ax/OYF8dRv/PwKEKD9SmmppnwojimoPbINhqI3UQUpCryB?=
 =?us-ascii?Q?6sLSC6mQEcCdv8DIIMQGRlyeUCNqbzkwl0jmyQ2qPp5UFetHUwHsppM4ipft?=
 =?us-ascii?Q?7kTmK0vDApas6N8Ni5ABFVKVy0lsH3ncXacR3ToLkN4sk8wthsm+CN/rUfew?=
 =?us-ascii?Q?wkgoaYo/qgsE9+2cPU9JlAYZn/qdxn7+LexvlODWhtgrUI9FXzDsXqTRKtmk?=
 =?us-ascii?Q?5sXpVJF9A+otdTzQOHRWbNebX+iD1di2qIFWAuR4SLzIMhmciQcKoUL2SLRh?=
 =?us-ascii?Q?IUzHuvRevxlU9Man/2hI23hmgEzAEogRU/kt5kXuW91H+yYvyopZciSWWGDM?=
 =?us-ascii?Q?d0z8FckQeXigJvjMKzsMbX+ApOtD18PmB/U0D4/PfJKA79/nq37paw/oaB1u?=
 =?us-ascii?Q?7s3OLCa9n8xDYiJ6Bfz0H+VHcs+qhn0uTSG2h7C0DEijgG7Ei1o7yLCenhZO?=
 =?us-ascii?Q?lYnNraCU6lFwn0ibABHQ2o3/1Spz3nA8ynPcptqIXQY+xGYegYB3z6qCyrED?=
 =?us-ascii?Q?CRzAUUw55UBzokM4Kz9X4ORgD70SIZNu4z/xM9NtYssrfIY5LOV3Hb1YxDoA?=
 =?us-ascii?Q?JmmFFzgdnIbQUR6aS7ZwTqEmKNRBoM3KV8WO0eQjFpE5r4S9XxBSAi6X9+BK?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	spDx+9Lt0NCuB9rf3WM6CNrrxg2y8CKkXHlZ1QYaykF2Z0Q2OoTCUdSQHCV/uV1IdKufAhTzmcbJCRDiDpCVaZ72X30n94VIS0qvgNgP4Na911AUoo5eAKSjiu07GX9SmOVVm8YobCFhUet5IGK03vGhGJD0oHAcfI4ObF4g2p2YB6VvZW5O6VSAsQawRZjz5zwLDTrR69iDf/kDmxJmE+cwo2FuGqbyyfRsGY/M8Bt2in7a8Q2tF3D/GVxpsmy1jCkAc+l3VL7l35AiFkQsAtVxxzXxYJjwbUfZvCW/82TaQI5SWJ4l6ybZIuSEpbkZWtIrbIQe2ziLVsPlYnnrF3FGWUJtNr8rFGneKzaiMAnUaJFI+N/+X1StzpNla+kIhu1nFgcDhte7h5QLTc2peyv4tEy3Y03uq9TL15kH/M06cga7aciRLzDn/q/VvNia79O4SMGzDl5SS9OCe/EYRYxBTrOvGOSogee2J+Gn0y394/YB+dmuRnJkWWzn5lxsWv+m5TX3BBqTn+jzmgsltpXrfCC7jFF4clNzEQzkQv19yg3ylid26dvWcrQvYqtU4WSCvaZPNoQAnLrF5TowbGfj1Pn/lNTAxfeYEbMBhkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b404dc-b7bd-4491-5358-08dd024314a4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:09.0340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 677XaRKLW+KBoWflXk++E5FNhBUYqTtf9OVg15c7l4bcOwu2vjJLrjOJ7KsKftiFMa6E/HFoyCU/KJVFzaT/PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411110095
X-Proofpoint-GUID: hSR9ieX28sdxchEA-KfFLjJVN4YGZQL6
X-Proofpoint-ORIG-GUID: hSR9ieX28sdxchEA-KfFLjJVN4YGZQL6

bio_split() error handling could be improved as follows:
- Instead of returning NULL for an error - which is vague - return a
  PTR_ERR, which may hint what went wrong.
- Remove BUG_ON() calls - which are generally not preferred - and instead
  WARN and pass an error code back to the caller. Many callers of
  bio_split() don't check the return code. As such, for an error we would
  be getting a crash still from an invalid pointer dereference.

Most bio_split() callers don't check the return value. However, it could
be argued the bio_split() calls should not fail. So far I have just
fixed up the md RAID code to handle these errors, as that is my interest
now.

The motivator for this series was initial md RAID atomic write support in
https://lore.kernel.org/linux-block/20241030094912.3960234-1-john.g.garry@oracle.com/T/#m5859ee900de8e6554d5bb027c0558f0147c32df8

There I wanted to ensure that we don't split an atomic write bio, and it
made more sense to handle this in bio_split() (instead of the bio_split()
caller).

Based on (block/for-6.13/block) 5fcfcd51ea1c zram: fix NULL pointer in comp_algorithm_show()

Changes since v3:
- Rebase
- Add RB tags from Hannes and Kuai (thanks!)

Changes since v2:
- Drop "block: Use BLK_STS_OK in bio_init()" change (Christoph)
- Use proper rdev indexing in raid10_write_request() (Kuai)
- Decrement rdev nr_pending in raid1 read error path (Kuai)
- Add RB tags from Christoph, Johannes, and Kuai (thanks!)

John Garry (6):
  block: Rework bio_split() return value
  block: Error an attempt to split an atomic write in bio_split()
  block: Handle bio_split() errors in bio_submit_split()
  md/raid0: Handle bio_split() errors
  md/raid1: Handle bio_split() errors
  md/raid10: Handle bio_split() errors

 block/bio.c                 | 14 +++++++----
 block/blk-crypto-fallback.c |  2 +-
 block/blk-merge.c           | 15 ++++++++----
 drivers/md/raid0.c          | 12 ++++++++++
 drivers/md/raid1.c          | 33 ++++++++++++++++++++++++--
 drivers/md/raid10.c         | 47 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 110 insertions(+), 13 deletions(-)

-- 
2.31.1

