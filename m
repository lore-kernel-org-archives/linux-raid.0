Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E611DCB09;
	Mon, 28 Oct 2024 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129590; cv=fail; b=GWIAxx6P/Rj7E9zrmxst1onWXeKjGqMNyEoOQm1SfNmuB9/DfDqq2X0/bQHis9Cws7h3amv57w6o1hi4MTRbAUNNJ8/Y/S/Sg18qE+xgK+XF0gGtk4VOl+lV8qcRlc/PNoqW8+RnDqtnF8qZCzC6Vs5h81EwOxIY4kUwLo2AbMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129590; c=relaxed/simple;
	bh=8WGjZZ2uUdJqXAx8ssuat2BO+LakOC7yercpb8ILtNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EiC7VLukD8ZABKmwzy7nvfANn155zrEOUSZjFoiTgyXp4/OTgfPoMW9UoEUVpeyQIz+psh1bgxOtIrq/lfUsPXfPpbOATEZKJqCodwPEHDyBAJKnNBsdU2rxTTRWNIC0y89AagYMrBe7eE0OxzqQgSL6aKkOztEcb9udXEH2RbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ayfU0pu3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uM+KlPAr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ayfU0pu3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uM+KlPAr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtdEC029653;
	Mon, 28 Oct 2024 15:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=s677yWTqAq4MHUiT5TjTqne9AHZBYCflsasBGA+1yro=; b=
	ayfU0pu3R1WB26CY6yLy7C4AphW13EHxYBy4m6qxA1DepjdQFVv40fAPF2v1aPUv
	S0P0FUTNB0JIrYG3JtqW1hFfFu61lbj+Rv5XTSVErYWvtss+d3wnnPLpWOoUnO2x
	mB0CX5vgapclh590VwatEQBmYIVk0lYQFF2Sfmqh1rOm58BPP7HXPjL2Q/89VjsG
	8gmLB0qavT9URLkBhy8rBL5enRkauhCJUbLPFZReQ6hxF/wrinaoERFwJKBK1TX7
	8MPTDA+hUm26UNkCgLArhdoQ+hdcZjP6d4Y4ib3lbMkf0xHhzU8SYIMqM3EgODDV
	CXp8XKCHUD7J6K/MI8bUCg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc1u5aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEoWrc008350;
	Mon, 28 Oct 2024 15:27:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hne82epp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7Dvcei+woKHu0/Hk5voMvnWItNOpQDSqwmkx4T56R6v+mLtydVSLKBISp93Hxx79hgXJH97rPbtpCEUcPS/TA708FdXP9vG+VqHGLPN3P5yh18vNb1tvMZrCzMDW66uhS0NTl4Ko9RAjIBGNFQeVaqPjNz2gJ5oyQLQp3zAi2UmyWEjuZ2PubB05yYxa4HgkXHdVo95LEM7g75M5cukim9hvwt7zPHHKKQqwGsCyubDQZrcITaQWxbKSsgek/7r1eAEDmjX1WYmv37ZNyerKkdywMN05oRtLuWfy/2RUvkSQQqaPeVb5/p4+LxLan0+xa06IrVcT69rLiMTzz+Zyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s677yWTqAq4MHUiT5TjTqne9AHZBYCflsasBGA+1yro=;
 b=f5CuOk342eBcnmpOvD8ehHYDrojE8T0xmPm2aFsch73n80BKr+5Z/mqX5F9/5qj0Dby6Rh7IajPBo5enoooTpTkQCkvPVS63AeOAco6Gt/FcCXGkLddLjrLXVHW/7Knisk7umcZGJ5C4cI7M4mPCZhanzF4D1PDyuZVQednr+sSJGHNRnyG1MsqydtFg6YF+SxVndOz8/C941wjHHf2G+pT1usWRKQyVJZW81fAm9YwqgWf8Zfoz+wqJvc5RCA8GIXLphv6OkEbrK+nU0CIxBOhYekxwOehXr4Ic4iw6JcxwPfpugWCJlFmx54Wu9Yb4XCqe3LGesZ3RKd74UCrGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s677yWTqAq4MHUiT5TjTqne9AHZBYCflsasBGA+1yro=;
 b=uM+KlPAr/wrm01M1EkFdwsOaGqdMwFa9LJgostCyzzimLkyQZXCuw/rxkpSzHlxwfJF6e1EknETh8k9dduLb3i64NBFgrYxg5D6lLjSwaRfgxulDItWNQQ3sICp+I9f6rlAq2EBAeh0c7lVBUxN+jmuV5eYSF1Xl8NuD/R0QG/A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 5/7] md/raid0: Handle bio_split() errors
Date: Mon, 28 Oct 2024 15:27:28 +0000
Message-Id: <20241028152730.3377030-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f3b22c9-62dc-4d14-cd8c-08dcf765170b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LDnYOzG69RtQuw+Y9A9ji/+t1tdZLgU6xu8Ldp5J0OGtJVl2FFFFuDl63VOq?=
 =?us-ascii?Q?yc6nLOGMgi0DBUGXQLUlUTD8t+YaFeSSkMP0n2kuOWDEZtBIrQcKx9tFS07X?=
 =?us-ascii?Q?fDY7UTDAIDJQX7vbHBS0qBdMSzNZnedjBf13qoPlaYR7/dpLQN9yVXFN2F5D?=
 =?us-ascii?Q?krjdS7qu0ILbboc8Rp+NH/4wXBeTLubvpN5DBACTX2R2Gzt7SSVV+9D9wN+d?=
 =?us-ascii?Q?hWmGTKgkxkgbX5qawNswFO3tgxsjrvWJ42V1JvxzWFgJopptbUJQzYNTZ93D?=
 =?us-ascii?Q?LQ8GaGwRIvBsys5O9j4LAiyTGFhNCUJdO3XG9StuH+1ctkrOR/KDO3jvIXzC?=
 =?us-ascii?Q?N7SechiwRYj3aZkdvnRGDxEwt0wQ7doba1+BmyhusLQSuF0NTLLKrFi7xFvi?=
 =?us-ascii?Q?Vu4qOCVsSCk6zVMG3IwzwG50HgFx0MGVNs0JxLIoAE5ZLU0oCk9LM9qK0rg7?=
 =?us-ascii?Q?UipqxsgXEZ30z8xEXvcMFSGNm6WodruvM0Kxd89Y10hou5zQNZqCttPxbEN9?=
 =?us-ascii?Q?9bGEy4CgM8FvJD/ES9gond7LLEVzxULXga9aKbhVivOaloleYk2aQz7knjvI?=
 =?us-ascii?Q?ddkQHV5uLV35AdOIk0R4f4I/MYt2SsG4j4Cr1GliIcM6WxU6oF0Eh62wk/Uq?=
 =?us-ascii?Q?9R6r6qM0Au6Yuc9Yr3uAxVUpwCR33jTAQ5tK+11DTxR2qx85o8AcioyQczHk?=
 =?us-ascii?Q?0r7xFzzgKx5z4dGQPNYzyZp7K0QESuzO2iFUBMT9l622dki7LtcyPvgio5P/?=
 =?us-ascii?Q?LJwdWTgT7ol75SHxlOCx/11sTVVn+ufyW7iKw2SHqLihu2xpbVPpIYXZRTfe?=
 =?us-ascii?Q?RpqWcvNrkm6aMizAnN3WD92iAfKmEtmWTfTvSMXl+v/TSvZYrqFfptnzm4w6?=
 =?us-ascii?Q?u/gjqALgcOls8ML8zfvpZF/jU5VKDEP5LL2ULCfmG10spsbvKedaeQ2og7JV?=
 =?us-ascii?Q?dxpBV+/Re0Hs7hxRIrVCK+/TS/A5MygY196JYpWz3EymgnIiHbygQ5GgCeoK?=
 =?us-ascii?Q?tEANJ2Yy0JDbGQ2rSFTVcJXynNopzz3aWC0tKSD7560MTjfY7TFpwW2wK29r?=
 =?us-ascii?Q?yTvoQgvPtfGO/eBZaCAuhdKZAClz3+XipouGpXbRAljg/qTqa+T467vSv0hE?=
 =?us-ascii?Q?mpbwLfVi7Bi+KMRFA0bzmk7xNDZp1rcv3DiUujX9Cfc3ozP7N9xMpNL12N4x?=
 =?us-ascii?Q?iSVyGUeGumUPQcSydhcl14jDPbF8db39Iz6rboofg48y9M28WCjYq+8t1PAU?=
 =?us-ascii?Q?lEOMKgfdfLjDTHplg6c/DrBqJ+Whe212ntQyaS9oA/cIBwgC7xFNNQXw5yk8?=
 =?us-ascii?Q?TKk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZKPBH+pqVAW6PmyvWSEU7D8oEi2YamqaVosxnl8ifSZFFUtop9RaLn+Cj2wr?=
 =?us-ascii?Q?UQE8+dqYutbyLkbbPZb30HKgb5LvuigYDqJ3S6w16NeVwWrqpCKkOPdjsO8h?=
 =?us-ascii?Q?GtzTpTacm0Ai+IO37krTnxwggjLuT3PAwMgWt5tNpHyDwwx6hsxnhWg39RHr?=
 =?us-ascii?Q?EGegkFR+KCb16qtnZMyYrck6jK9DlUVJgFBDzb6Fj+IaFBNXxcV4r5CDwdZ8?=
 =?us-ascii?Q?7NrxXjIgjGzRCCxQkmkcdQdrhziVYy//9j7OvzfKcgolnqI0l15oUX8l22t5?=
 =?us-ascii?Q?9vZtRHN8Jw3n28NR2gc2myxFoufGrUk5Ck0zh3Pp7VlVexKmVB8N4F4ehz/4?=
 =?us-ascii?Q?Y+2T4DNo6CEAhvYzB5DXTIWXl6oenQHSFE8xxJBtsXVkamkhuHoGkRqHrpHz?=
 =?us-ascii?Q?pIf5SRv4WmtHF8weGRZO6x8BJXZRR7NFjCl4MdONSDZA7+/Jkxml7uMfMN53?=
 =?us-ascii?Q?uXMXJjJCTXULzTos7DQtjigo2uCmJhvKMBabH1koe584GCEaJgVx5wwu05Nv?=
 =?us-ascii?Q?eFopqhI8JdNZ3nQ4BXmLLHCpXBj6dlVO4ljB/vGhNpjfu7zIuApHn4mnrXyI?=
 =?us-ascii?Q?16Xq2TnsO/ESydte9TVSEWDNqYNrVKunYr/a9vAFUE96BW/zyoEzjFNPrpUp?=
 =?us-ascii?Q?UCIUnGeml2UI1VivB/S3uVi4d5+XT/r9VI/bYTENr7b3OhWT6uLqgRS2jl4f?=
 =?us-ascii?Q?jLhBL4L6jpLqRNlPs/zCa2aNmKgA4cjwAb+67pjOJRbl8ZJR/AD0zG1rpYrg?=
 =?us-ascii?Q?g0NyLp1Dk9Zkes5XMwFmk1ZfhtQtr+8cB16GrOmidgYcJlJtW4lz4obibKMk?=
 =?us-ascii?Q?6seEVNUhSs3/ARy5pUX5hWm+DC6Wu/Np0+WhX1+zF54xZifj9T0QmH9idEeN?=
 =?us-ascii?Q?GSoWhB1nZPLbYUjdGiM8aa175Cj1700dcUOHMkxjaQdRQEmEVZn4ivZHyUbn?=
 =?us-ascii?Q?w4ox0NSKr8pDl5dK+HNfH31QX5I8NvlQ2/pfBEbJu1n1NFJb+uRPQzyBeSn4?=
 =?us-ascii?Q?EsztJp9r1ztqAMfME5pfdSEuvCZK6HkbaQNSQSunARM1innGPkHDLFp1k4hp?=
 =?us-ascii?Q?zMOE0Ll21n9hI/jNKtvVU8NWCySTIuhLNGFWyvilplexksxuq+lrhigXD2gT?=
 =?us-ascii?Q?blUIC9997XR/kqhrRI8vsSc1KlvTkUCBZPLGHEJoJCoz3ZUxWj8EdkQqS+x/?=
 =?us-ascii?Q?RarPn29n3xzcAmvKKxWXIEoasULv+3TR8t/nbGqdj+jw//p/JRTPmhIRjx7h?=
 =?us-ascii?Q?d9tFENI3uazDNV4dgPI60lJlE2STLuK28WVX3ZOp7Mx7onBwi6kHP6WyShxe?=
 =?us-ascii?Q?K15XutnZLu6JtUQ6WZB5S8NBpgjCxTnhzGto4CWaIWslQzs/Uzq9iBa9+n8s?=
 =?us-ascii?Q?kdg2XSaqzEBkAP9nuJzVl2z1Hoqzae6qxfL3VaevpjaQdZivI7xriqYNAOZr?=
 =?us-ascii?Q?rvYPJp82/rhZN+PzcMF0nWT41Hfl3f1k5VjlPx5hl8zg4wDCvnx8dLDkv0rX?=
 =?us-ascii?Q?j+nMBEwuPfMQpeNt7WxTzSV0rqlKHtWuTzYzb2ukiFYk+f2qJ2v54y3QcFwo?=
 =?us-ascii?Q?diQrTDm7LukaTxcNl/0m90UbNuUFS3z168Wv4C6Cr18ybsqzAE3MwB5WCcwP?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PH/4IO+TvrD1UnQbMtBkA80nnQRdP6/GFlpoPQ727Jx8uhWgh2hrVGh6CRINW13kjJ5c4JFxm7vLaGSyinrNlZLiqmzW8f2ZG3uFQcx2jUAeNVw+Oixkb4hGMRMaagxR6eAXxoTWOQ5G3Bc80bfr/J4JUoFYhnAeQRWgq6SroSQlimUgG9hCLXpNGZTnxEMWlS6LASGCE0JYNi711jd5xqHsiWIux5249gcBFE6VTxA7t76F3SU6WiymUC+Xx7axneACFwSmIQMeNGkLBwUbiC3GMHdkmlSkAvslYWftijbbzyXBLqGX+aeWToUVdKFNz2OOiXD0U4JotuU6cUYjblWgseGfD7fJB9qOiDehqtOGIsQZySJ/qZC0LLt85291N5SknjQUsxs6rehN064PQeSmYUAJ7Rd9RWQ/IpgGHWp0iRQ5mwcMcg5MVDB/gp2MD29+jNW3Npk+QK8blalKk+Jd63E+oQ4ZSiYtzvw8/3x2JD1vg1Bbk/e4I5CIq9WchdemtKtldbbjhzS9wIBlVsP7RH1o7bTjcZd3amhUpdfICjMAMvUFH7NLCoVWRndW/h3Fgi052jIfEzfesyeXITlc3avpQY13IwafaP0Ug+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3b22c9-62dc-4d14-cd8c-08dcf765170b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:53.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKiMwES/+Gf4yCHNo5Fit8HBOncmoR1S+7asj2PqxQ3Eo+ljA1QYEYqGxuOuBi+P2Pcorqz99hSOgxtd7Wp2FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-GUID: ib1Gd2WpcbuO_Xj_DI2Mrit6vmwj0ADl
X-Proofpoint-ORIG-GUID: ib1Gd2WpcbuO_Xj_DI2Mrit6vmwj0ADl

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

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

