Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0371991BB;
	Mon, 18 Nov 2024 10:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927059; cv=fail; b=scj6MhyIIQFcjFMz+uvaq0Y0OwdOPG4MsxEwStnubZvO4nKbwjJtmjjXBOfMvqmvlINoqlVfXxaNN8cRH4XZohJ95kakRDS3vHawJME5eyLaxkTjmLJSw/ZZm4LA+2RGZFuJXhbEVxmVZ4QCD16MHZlS3Cp6Q1QYBK12qX0XZeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927059; c=relaxed/simple;
	bh=QCkgkCUDb/cm1thGqeYyHCY7Z2sUEXZreRdRGpFIIEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k0xiuGMiUGqrTMleDAK12YEXAP5gx0pMLeQ0sovMe1Xi82wxjbHmp9Lx9EjLaeVz+1NFmFsW3mePjeD1AlEzE94vKoPZ/toPR4ToVahAGuSrG7TUeJtj4lVWNNmP3ZI8lZHdM9yRA8JnvTjLS+ENSqngYES6Aj4ewAmFgeCdPZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZpP7zf39; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K5XEOEn3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZpP7zf39";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K5XEOEn3"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QaXG004695;
	Mon, 18 Nov 2024 10:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Ayn8ndS6q+y5ybPwUu0Nft9UAxlsEsmFXmED9UfGcyo=; b=
	ZpP7zf39dwLyxcsTr84qcEtYh19tc/h+XQougcW/Xd4zIQRR/NLFsM0NviN40Ahn
	x1T7G5mQUV1Xqax7cA+/gtAY/zphxhHn1xovJ+QXQFhJTPCoWU9o+pJ6fMNm9SQL
	mnUB+ld74HIecILksm3meOpHcjzUwmnA+CSpNDzB+qsYEhzyyVvIz7MtO6e5zkjC
	L+CMmbOD3AouRVmQKabv27F2SmCuFOdwcC3pEs63LFaWG7VI6+dYehjvc2s2um+d
	3dUM9SNtmf4k6Qo5vZW3S9kf6Gm25BeWc3Auif6PGEFuWxEEr9HAhBcX+BYjSn6h
	n0fYRTARAv1fuAjPULtNMQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkebtd2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AIAZs8X008914;
	Mon, 18 Nov 2024 10:50:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu75sb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fQHDEI/Hxs+CGskTNM2Xgd6lMw70iQMbuN7KMIpZTBTl7OqMOcZfL0hQ2Gnh4YJnEo8CG7CsXbSI+1VXwVDpj8Z5GNYMw/Lv8nuPRHCDjZJdDC2zKgT3UPl2dTtREvP3fFQc5bzPLW/EhoO2d6AX1LtVij6VPDJR0V0KL8vTq/JG5MQH/JhZ3VHGwFp3lg5N7B55K9S7/in8T70AKns44gWjTeRg49ZKsr0BkH//Cv7RXmFjPasGykfEl3RoCtzZzgce3/rQGxe91fCEX5KtXQBZy5khwtRg9WEM7FYOSccYxvA3lqNZ6czzrDHDqwmdigNx9iOS6eK/+Yi8QMRsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ayn8ndS6q+y5ybPwUu0Nft9UAxlsEsmFXmED9UfGcyo=;
 b=A04WuwHkMFh8yTMCyzWISUNXWox679c+5YC1OFVoa9KMPJhOIcw6EkuxlqRPu3UxZVLz1kv1FFe4a6A8KdFw46jZ+JRbVy6tEnpbNgeGwqbqnatdo0PH+mMZgjSDw9Eh2uWHtks8wQ1yWnGEYLX2MCB2VF+mhM0Pxm2wA3toGglwAD8plBtTKLmoc1A8VKYFMEiqyAuqJyG8IKlJbU4y3nIsifUAZ6vNLuFYfuSny348sJVHU447jsKTQ9dDE8QSF3kcnes2SeJ58Zvrb8ByoOlQw/5/5j5HSY9kPdi/yhxEVwMeUNL2pY4pvzYCnQDi7ai3LcIZvY18Ni3jNkHgvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ayn8ndS6q+y5ybPwUu0Nft9UAxlsEsmFXmED9UfGcyo=;
 b=K5XEOEn3I0KoTgJlqbH6npntmSEGgzKDnwq7oqQAPXXU7PXe6A1H1cXQYu56qv1fWhZa3iGhoKhoayd4D7/6tca2lj0dR5wCN3sfffInzhr1ANmXO12RcOAcVtXTedV8H/91S/ioPfZbK2wmrdCIHZXinKQuCY9mce0LCJoccYU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 4/5] md/raid1: Atomic write support
Date: Mon, 18 Nov 2024 10:50:17 +0000
Message-Id: <20241118105018.1870052-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0f9e83-5306-4c71-49de-08dd07bed6ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S1VwFTm2b6lyuGmukpMclS574P73IHqjK3ZOQnTA6PcLHvmYTVmeDYagGV5b?=
 =?us-ascii?Q?tDA894SoT+M4fHS3hRegqnLy7cZYRDwxiXl8I1AkioInNFv2C3lD8SkJMopQ?=
 =?us-ascii?Q?x+Fv13GHwqy+4VOWzhmxWUSAV5RCrVVPJTCOXhr/0B+SJ4CBCFMW0LLcPoGF?=
 =?us-ascii?Q?YohCjQqYjQl59tnXrfVwOgUnsrV1nEBeEG6BqIb+m+HI+DwqqcR5bXZ0Rct7?=
 =?us-ascii?Q?Lt/gqsml6dj4CKD16u6BC6Lz5daqiLHFiF7hUwnTCYvbFIY/GKu80L6V5UXo?=
 =?us-ascii?Q?UgVs+tjzKMS91Ps+yBKOCIopu4BggIxbiSEZmMoo2plJ2M/HniVmOxL5R6Nd?=
 =?us-ascii?Q?zcpbqzlVRvDV8gS9p6N6SVLasDHRiinhpt5xB+3N2UbjJJ3eyDvut9exmwDV?=
 =?us-ascii?Q?nfAMaORMyWZneUl8aIzfn+8vCU6eZZF9/qqPqOXbd8aMsrAlJ/6t+UlaO+rb?=
 =?us-ascii?Q?uz96bvMmKfhqLlTqeWq9uOPDe/LpX6o5IF7XJV+FxGvd2eEJkmMh6R4334oG?=
 =?us-ascii?Q?1+kKqwqUas4VJUAj0NCv4zutWIralGl5lwqF1YsPnX5ZFGfcV5X95gjQVLKn?=
 =?us-ascii?Q?3amO5JU86PCQlxvP27ZpLHUaX7zXoZ3loYARLepiYAelnjCe5zkwhu/wj8v4?=
 =?us-ascii?Q?JwS8jakvAEDPkoyNH5xu7EBlRiRfShvAud8TrwjPkCBK90fP25XpP4Jo86V7?=
 =?us-ascii?Q?KLTKrbdZ7t4dS0MV3uyo9OgMmIP5TH4r4tc6HSK7ejf+Qfm4Uq49hELa8Mri?=
 =?us-ascii?Q?uiKzjw0VdK4m5uQ8Yv6qnu48ZFs+cFSbVKn7pbptUVYTaPHV7Heb71ujcBKJ?=
 =?us-ascii?Q?HCyCiw0xwMaAoFFt7g6uH+1V14k0tCuZyiS4vMPBp7Ehily0sQE37OYIzKu8?=
 =?us-ascii?Q?8krfT6klukKsNSfo3mvvkm3+VU1pOGMa9wnPtLFoKbFkfd8u48o1RYisyc3h?=
 =?us-ascii?Q?99KmIjTxjc/QvfYhm1LQJ7JL8mX0srVzHdNrMoCooBwMxZxArJ7cy2CqJAJT?=
 =?us-ascii?Q?2KDHlB/7ELcOpVTj85K16yVulpRaIAhfTKSjvhUmwbyCYhaNMqXhGZsh2gc2?=
 =?us-ascii?Q?MZAnEObTKufJFW66sBx+9ggp0AXefCVgV4mq9+M4KLN7s3IDv4zES4aZvNup?=
 =?us-ascii?Q?C503O1A6QWeK5JiAXLldENHSSbCcAyjOyH2JpZ0gY3gVy0Yzrm9/z/371mYf?=
 =?us-ascii?Q?J9xQ6vARBhEF6jag6BcfpDEyuwbBQJhQ4r9IawO/iAiMBkEP3+pppuophSM3?=
 =?us-ascii?Q?L9FoJe70Gkly9BTZZ6uPlKfku0pUO8FovGgtdCo3WgjGogRmS95RyYf50A7V?=
 =?us-ascii?Q?Rxl7K2jLH8slSoi5nLkfrKgB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ZvMwwPcluL1XP2HzLS+1XwFtTPYDC3PE64W8zmzRxB0yM8bttItTUcLqr/9?=
 =?us-ascii?Q?kt/1ilFTS9uLmPKJ3xLsWVi2P9TgTWhcHwnWikr0wGMn0qh2eX+4YeoqURBY?=
 =?us-ascii?Q?Z8udNoqZY/iiWoArljdEhS4fRuxV8cBNItq4xXVFERUvLj5+Y4cPASjrnVvE?=
 =?us-ascii?Q?Z3HpJAXIDOSWnqReUafwDrMBBkCa9dKbkedf9dYU7VkkRgI/PwZy5wV9RRCQ?=
 =?us-ascii?Q?E5gZQ+yyo81yQ/GuWiz/BpyYTz8Xu7Eze2TvtfONvLT5Fg/ejiQxlg/AdjfV?=
 =?us-ascii?Q?RUeJhB7IF4X9NYIEzrksIDDr2ww05crjEOB40dDS2A5B1VEurQO6F9njO7C3?=
 =?us-ascii?Q?0Aq0VajiuJEcD/9NsVqqCIMo/3U2S4pKWMoBlEzt2hnyAPF5TIrPlQiqIbln?=
 =?us-ascii?Q?BpUxSFA2Y14AusSjwXD6ldSgv/8v9UcuJKWSfXfTn68K/5NiDMpNds0QiZzg?=
 =?us-ascii?Q?lO3NJVpr6+qrEn4m6IWo0WlDVZkr6nGkeOsAddPDHvA69nCYIGknfgx6qdeV?=
 =?us-ascii?Q?PdXQzvFxyf0/NnEobdBBnAc8c/OEvbnKXxaREeded+QskjwoUEJ5ar5MW5uK?=
 =?us-ascii?Q?A31GvXVJ1zI4sa/3EXNR8dg9HSfoLSrqC2pATHIqJCXoervRIzACAYlShram?=
 =?us-ascii?Q?nwUPUSfx3d3cMNVt0H4N7wEyJn4dt6r7pE2OO0esa7dK6sJg/i5L+UbU9coY?=
 =?us-ascii?Q?avkG2xRPjgbVrEc6FSqHgYhsu1oN5S3+5JxtnyNUcCkF5i7W+lmA3i2LplpF?=
 =?us-ascii?Q?ZtmtVznRlO3k5UQhUi3CyTKnwSO7RYz0PJ8Bt4MQqHUyee3SO6nNmIooaJvH?=
 =?us-ascii?Q?B8iWncQXxvvd7Yo1kaL9pDaJINMAwOkmDGVTgR133il/2WhsAq3L6ti7LVu2?=
 =?us-ascii?Q?E8Jx7jie6+gmZ3LiIIsdHdCQZwWdtzFQxEd4CiKtsOJdrOLfQOeeOcY5fKIT?=
 =?us-ascii?Q?TSsHeGLZ6y76IV++/wqUrmyTomQFW+mqQ3+NLCPgDPWA2CIV6KaHCXcoyfbB?=
 =?us-ascii?Q?MmPlxcmGMfu83YhwNwjH0EJiANfci7lAKTxuhj9AsiVnwZBPAgIWxVApxOXj?=
 =?us-ascii?Q?n2MupE+1cR+aPahyWdocXBBKHXmRDynXQOzEkxDLRCP7NfnvWqXF/sW17W/P?=
 =?us-ascii?Q?NCtWJxf8lKZvbv09OvSnCgGWXC+yuiPIJ1AGJF1YJSp85eftZT2nh/X1VuUt?=
 =?us-ascii?Q?P1eg/YM+rj2mEoE4sibG9fUa62PbygM5A6VQ00Xp1wBc1KLpApNtcbZI8akD?=
 =?us-ascii?Q?f87qMm7BLHR1bvPyrbJ1dhxKV0s1udihe8t9xV/Rn25OqYuwJh8ZS2rsG8Dd?=
 =?us-ascii?Q?yq+H/SRzug4iMLub2t0Yhd90MU3n1FgiGRCwU8B56wBvf3Mc+iFqGEfnDnLz?=
 =?us-ascii?Q?FyMeAZpO7Y31i9WnMWSXZtmAs245qmXyqiz9z6pAoM3ZqIA8GKwycqM2QR8R?=
 =?us-ascii?Q?e/FCu8DfEJhOcz0PKnFCfBoflrsOXW2ywf9OK1MS9UprQ1GYL3GWClkxk05g?=
 =?us-ascii?Q?wljqxcZFAoHtePnuH1Bfxg8Gpm1Cxn6OlHWaio8ODb7gv/Bcc0l19OwllZ5V?=
 =?us-ascii?Q?tfLus6nYRTVqYJ6+nyP8Lnv7dFlVrecWw2EiGE43KRcYxau9SzUMA+Dzjlm2?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v31I6M3bUFygvUuQ/yfzl0X8wGH0VeACLofMCPNLgWsq3+ogFy8p3rNa7RYXCnMqz82fnx6jfxBh0b7LosRY+P8fzSyCK0UsSb+NWiKjQftChtL+3Vi8ZeUqc8l1rm6gNUo3gWBBqtn/EUKno9uvAubteIF7UNqRyR2ydN5qbxqyFI174N7+U2L02cWUf6DoMIuuV9va5iIM1WDNMk8gK6TohO1SzRPgyglWkiEr6g9d7XsUObySkspFG9PJhT++TfopcJqSYqEwCDhveWlMt7SR55zhQMzBGivTiRRUurOEzZC9OCT0v4E98BR9CtOPWvbjdLElBxtSHDrTectllxsYjigUARDUMHxHRohp1c4HHfIRmoJpB3g9+VnFa9IGQByNkOV6z04EJq4gYAnzjWlGeHTMBUXnbj+AM2QG6fOV77P4DRBkBrBZEbTR+6gljMUW0L1Oga9wVnvutjGeek9B2OpZVe/lGjoiHI0OAzeYaIi8eAKXKAwAfu4nGHZpqV33VKPlfBSo1o6x5lnu37EC8X9LDXK94eyudug/e6rLEVcPT4MS35OF2gqHK6IcG1vTJR1bK6AyVHk/mrenvcvKouJ05jXs4FbksVz9yh0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0f9e83-5306-4c71-49de-08dd07bed6ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:38.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbdNenQanDXTBrnwHF1C9Mxte6/i2fRO+d823WNfNxfOwW32t1Ou0uHHymzkC6uM/YHWq+h5njjAQ3P07838vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411180089
X-Proofpoint-GUID: cGcadP6izNJdGH2W6nAq3-LR8xLupMVq
X-Proofpoint-ORIG-GUID: cGcadP6izNJdGH2W6nAq3-LR8xLupMVq

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5adf08ee174..519c56f0ee3d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1571,7 +1571,21 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - r1_bio->sector;
+				int good_sectors;
+
+				/*
+				 * We cannot atomically write this, so just
+				 * error in that case. It could be possible to
+				 * atomically write other mirrors, but the
+				 * complexity of supporting that is not worth
+				 * the benefit.
+				 */
+				if (bio->bi_opf & REQ_ATOMIC) {
+					error = -EIO;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - r1_bio->sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -1657,7 +1671,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
+		mbio->bi_opf = bio_op(bio) |
+			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
@@ -3224,6 +3239,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

