Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA1F19CD1E;
	Thu, 19 Sep 2024 09:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737847; cv=fail; b=QH1EF5ESSKfHrM3xMM5NP2un9DGu5kHs5d8VqY82IyM6OrihMk6XZsXWvRD/s5t2c2pg9PClynjdOUMaU2cKn11Hv3/YSeTWQRdIF6fMXf7xX4M3bxESBZNm0S8Z2dCapNIUa3pIX6Wa67rP2CeFLWD0+YWgeM9SUrjS+159F/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737847; c=relaxed/simple;
	bh=Z8re0RMdr69vpdP/7cGmkrIQn6PP9R7KrghbjvycA9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ij5AHWNJpxaW+D3pEqi2OZpFhfb4FM+QXDjv/V33ou9cKGm5hsqh3sCmkexJB9niz1hBOCKHOi8tvIYGg7XMVylIQ/Q1yefbNrKLF5AZiU1kPHfvwBqIoosHw/Yite2ZpsloNFWUK90C0bDgcJycig3GlBnWPdzyTZcW8LLmamQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=neuQTLEA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vL+pg5dd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="neuQTLEA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vL+pg5dd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tbJq004943;
	Thu, 19 Sep 2024 09:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=567uA2+dCFvvRcaFd4bvjf2j4G2z8F7uyWQTrfEvk+o=; b=
	neuQTLEAKHCL/SB31E42RqoKV8kJosWQyAh8g4lx0VKxwggA7ljchn4ObdSvTi7Y
	VP9MTPXW30zWt53Biv9E0ZuS0ZzUhP9dZAev9L4GxiMF4gO8A8ZX/9O/wI3X0uah
	vg/O1OaLEVg2ze8TaoqWYfC90z3b8n6A9EAAeViKD0lNUc2TDIvUerKrANloFYKR
	UWGjrTTbdMPjm0Oejp64fAq1iT8780jqRNt4w9sCcp72XQxYfpahb7AwFjSJwZtv
	6MhG0+FiYlpa6YzHTVum/C9Jb+X8UvGPh5MQYkQtpEG0rHAcNiIHoy/pP+0kXLiA
	xcyycKHawID902vGC645rw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3pdu9ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:24:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9Dk7s008942;
	Thu, 19 Sep 2024 09:24:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyfejk4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFkmae6p9V8rooMADiOEQmwJjbUfWl5jxCxCTZV3iNXVFHgDwAFnmcpQquwk5ovedQaJ+k0utQvgi/yplZIaex6OupPBPwdZT98KwZJQ/zMMrMg+eJmCzig2DbN7TTcYSMQJjztEl0T28XRLywzrKVW2fMObBhbyD5FnSWI7R2vHn4pfn5CXiumF/54v3cAMRpU6WeHA/Eb3UeloO7FLKy34r8adyI6WmBUhZ5DAXkzVFhhNHIvOhEUyojeMR81IXsGGbItxZV+u7Ayx2WQn0ElCklRXN6iVrr+TVNFvH2XnKZVE5kbTMVv9T8CrfhOPvAePueIdkeY15BfXHjzcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=567uA2+dCFvvRcaFd4bvjf2j4G2z8F7uyWQTrfEvk+o=;
 b=vDqJEaJL/IbYmo6bHnClmd/mTeX8nEQO3CXt1HJR80g0DoDJONDFDAw1FIHQMYZA+6owaWMgwsAHVbR4tBiL2ua4A9nkbuuiKKeeZmRg87jEQiU+1hLhQxiSgN6ijTZ+9DD7oBbpwIoNoo07CeelPsAb3081G4qsot/Iwr6sBm+5LWX/kII2vORkyYyYaWqeo9i6nE9f3NkJXYeyxieZWykN7I9990QBP67popmGckNSXHf4LPEPLA0ta2mOVrA/Oiz6cZGPUnOainZ+z7DWGB319eqJg8vNoNdEEJ5Ae5oH4/VBmkv/K0IExziqXuCQDVXZGqFKFk+ORgW2bL0kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=567uA2+dCFvvRcaFd4bvjf2j4G2z8F7uyWQTrfEvk+o=;
 b=vL+pg5ddeIHtbF44UGosbbLEl6GkMSEp1pELNu7oU80QyOv1mvlhInKqZZEZ9ZxC8vrqvCDZKWQV1LAAQV/hG8UzvbRHvmhSLcbS8iyuoE2GI9OBHVbvmiiZLl0bZq5HeOmgV6kj8BoogMVybWlDPkO5jC/6t9ZUpAWC9vGSRkQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 6/6] md/raid10: Handle bio_split() errors
Date: Thu, 19 Sep 2024 09:23:02 +0000
Message-Id: <20240919092302.3094725-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0452.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f1d6f4-d201-4937-05c0-08dcd88cca91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t84Z64YMg9xt/braNI46NpRXZjJ8YcpgmqXYFqD8MoAkjg4CSNQ0PmsY919j?=
 =?us-ascii?Q?Xjc7OmywVtrFg5kjcsxWZUj1ZKNHvUy0eJ1cTpOXAEpi6fha9lTG/EBIjNpu?=
 =?us-ascii?Q?sDfssjXTOWtOcxz5tO2I5d8YUChjTxdUpMHLpnXsMcyKMU3gBWAhTAqsUoiC?=
 =?us-ascii?Q?Bt7Eh0gQIoRAKIfWxtHTHLXCnabvSBrrqJROALop/gFiHJ65V4wlxGaR3SUp?=
 =?us-ascii?Q?fVA/jh1BBMT6l9qsTsoElSrey4exsbKj36CoBz8Cs2ZUpM6yLlnYY9rp9R9Z?=
 =?us-ascii?Q?SZN1zNNeLS0KNzCoAMBCWwZ60Iipi2sgPlUBtal6gXqZAxh6KJR51DOwD8Oy?=
 =?us-ascii?Q?lFAoiWghwSBiK2J/6sSQwn4d5Q5HZGq9s3AFXY5Op8q7aZ892hvJGoh9C2Z6?=
 =?us-ascii?Q?y1p6kEq2PpSCcv4ADBvSg3jtolFilriWdaeo9s77rsLaZALf6mwZwsT3lHuw?=
 =?us-ascii?Q?Mcw/tjJokzhJKaAZoYjK65n4HxXhV5GP6fKLwPnBA7iURRQcL/B9AXMY6coy?=
 =?us-ascii?Q?ZJyMyhgI0yzcH4QdKJLCpmH6b2REq02vo66IzrtJjdO2tSg+NFHTCY7bIk5C?=
 =?us-ascii?Q?rm9WaJj0hKnyCnKjHKvS5N8o6KMFMAPKOqOHTfRjHsFvlqqI8gUZWUDw35ef?=
 =?us-ascii?Q?Bh1sY0hLmFTUMsBphXX2BSEf5w0hUBSpThXb4zBVcBr9iOdSJMwzhyJwkReJ?=
 =?us-ascii?Q?Hwy+jRVxM/ypqfN+TbJWoVt6xQ1qqcXt+S7Rnb2XSGqQiLhCMSkC3LJGyOVc?=
 =?us-ascii?Q?4wMHVvbKqm3yHnvlDDa9iHI6uCH821jK2gSjH6pTM2eBAfQk7Sloift3TuCI?=
 =?us-ascii?Q?xQZv3DSFHB5m9cS49gYUjbuqIhrsQZJVkoijbbsqxfIDU5UaCTWJGZUwHq5W?=
 =?us-ascii?Q?tqIyDqVgRCGxrO2GAW/mP8VtOmxAtri57xH+2+oJprf3GM/CKCAaP9f1zxih?=
 =?us-ascii?Q?iq6ZYIzpZHdySYNbdtdr3C3rXxGcx9r3Ny1nPwE5MrJuf7LvZAZ84Nh1/i5B?=
 =?us-ascii?Q?n/f85b24sFx9LhZ78/+uVMol2ooTOH8X5nGhEWI73Q9+Ur6DACz2dXrxjyQe?=
 =?us-ascii?Q?rNwCGH8pKl34i2OAauW2mfoyIYcO541P4sxNH0XqayaEzzvYFF0sPQSPidvr?=
 =?us-ascii?Q?FrVlg5Dk6yvRdY+O8z17g0NgK/2eSzdfYei5gFumXXbI0y0sNrCDynJtksTl?=
 =?us-ascii?Q?Y+CTsWaeMpY0TLwWfgWa7zxaIlModXjeWmT95N6sUr0v/hBMG3GcSlAcRGHO?=
 =?us-ascii?Q?I1Pf9W23XQWBQKHqUxbVZ9gVZZpI27ETMzmDJoCJfY9YQolIxDOH/BgqQUXU?=
 =?us-ascii?Q?Kv1pG23n3OV5IE1btze1q/cwqXdlCcHUsqx8GiqM0lM+bg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXxraicGT8H/pfd+WHOdwv+WDcV014ibm25Nyyct5wIydT7IyXqPCxe3OrO3?=
 =?us-ascii?Q?j21Xsv364B6IFeSLqeMxDdDe+rfoKrvBKvskdDHkd9ptr2YjjrA92mLvOhb1?=
 =?us-ascii?Q?wBfxea25cpBX1PSA49R64ONBoU+Ahj8Cp2FXKiz7suethbfe17OFhGmws4EK?=
 =?us-ascii?Q?rgpo6xBAlaY8Ba04d9JaCLaha3RTfR47wkjEUNxvRP9JXzK20btreepkcT3Q?=
 =?us-ascii?Q?RfkKC6xavMo/9DHE6MyI/Iu8RxwRUI4z135kEwV8uVxrXDSn/VzJF7PNbC18?=
 =?us-ascii?Q?CtLwYT8c5wUQAhPLyCJBA8Hu7SLIcQCm47UnjOpyS+iQoHlz+BRhcf8B+kUW?=
 =?us-ascii?Q?8VWcH3z5tlv3dFVDBpu6BBWLOa4xnyqFn7vXOQtQqj+7tyGvP4rQZarh1QGG?=
 =?us-ascii?Q?GQLNUvXVl6emk6/IaDltqtEfXEbv6CwkpzhVdeoeejXNJxuGEiDJpV+8vdzB?=
 =?us-ascii?Q?hrmKfIXLPijFJ/MxPKXJftmVrfM+f4uvz4656FuwLungnZBexk9DebCENdsc?=
 =?us-ascii?Q?HGZaVPOvgnKw8kSQmmoUVZVl+vRwg81WhtYvMOAcVEEQBkedEVjWjbHKvYl6?=
 =?us-ascii?Q?Re78rruBXilFsuwDos65wxo25qBGF7VqcYzwDdnDyTzVBayHKuTrkp7yDPDI?=
 =?us-ascii?Q?/4vR08XnITwD2crpzvghCSvf4I6iVJ4ge5ZZa0rSgWuXJhM0wgV6ZK0bRgDQ?=
 =?us-ascii?Q?XeVLRrH6Q2a423r9thUExrSCXGpOR3UzvauV2kCtE4BnZxxhGaRst6TM1wMa?=
 =?us-ascii?Q?5CtC/veTrIdcb1NoNFwp4X+my+EUuEwyDTL8PEtdA+6VjCEZ7tXuWdIvkgxp?=
 =?us-ascii?Q?V4Z0OIMTDI/xc1hSMUs00bfdNQc+fMkwYnxdvxTqi5KX38Au5ftDfh3wuUSP?=
 =?us-ascii?Q?/OvbalLkRhi1DNlEX6Ce/2VKWMueRg8xFr2lIDLBmJ1OKGzvNtTQnm60iJG+?=
 =?us-ascii?Q?NwyNAIkQhDAdjTw2MqjJnsnsdRuDuUEZB38cmG92Q3yhhy+VTRlk/r2rCP51?=
 =?us-ascii?Q?jUqMYfDFOBV5TZ/gYYdhduXLTvdwt7lsWWKv6uIhI2HNFLSmjWpX1ezyKmTC?=
 =?us-ascii?Q?9mLIgsooImzpF1h9Wkg4L+b1V4gQ/6QVLlPqWxZnzZctweD0HloOudxInhNx?=
 =?us-ascii?Q?1IxQFjbLjLJHBI7XcxZUkfv17VJsiPOFyVpG3CLKwfp93CHoiIhLUGIZw3A6?=
 =?us-ascii?Q?pSSFYPXazYGfolxDPS0HXBdgTbA9mcifescJNR1gelaE0/VBMNC30LBKK2jY?=
 =?us-ascii?Q?JGR0fhAU4cOusSEUu4GfT/zkn1DGFadE2zFW50vNU4RU132i7OhujCeP3PTG?=
 =?us-ascii?Q?OonxzUFTOupkWIlgkVlY7vKy/65UmxsY/Nx2aCD46cZhATOmQnRuBFJzl0Mk?=
 =?us-ascii?Q?j0814g9rxxKNfwNYfuqNTM6sHPH5qHBtT9iSMHA6jhLmK7OL5zqG5zfqU+DO?=
 =?us-ascii?Q?qUpoZeGvWxLwR5JlY5QbgNmGmWdQOgap1q4gsuEyLeb9tGerGShOFqKihL/O?=
 =?us-ascii?Q?GLc7iEsxmKkaz8GF4cB4JxHW9acfx55m/oNxW4g3zEz4RN5QvpijeN7hWuEE?=
 =?us-ascii?Q?pW3I9e0JdJKywC0UjCc6+ZLm7tpmrRUCf6gLAjmPaUneszxBh6b/MJAx5Kpb?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vlJPo/p8e7Y2yDQGn9BM0o54w2Ku9OrAIGL2L+3FCU3azl1NoDYq1Y9C45U8qvhvLNoE73JyD0WklA2aNKv1Zu5xPcCzUOYtVqzjEYqIj0GBM7AmI4K7irqX/6s2v5MV2E4C3gYspDkb5CMYS4qEiKfntmiqLui8pRD8weQOt9rkp746Q7VhPz6xGBKtz5usoF/LwltIn38lfMX0FtFkCrTXb3BtHFFaEXbFfCuv27gEqwiB0VinOT0hOhOvnqZfqpsZ/loXgF8njeFXnaWa8rQYCkESXhwje5eyFzVSTyhrWWVRIwLs4J+IDUOPIBhHK3jEwNKL1UhvFalEKMmrsPxDrl93LOJb32y8/2Extg3k/JsLVOMjU6dmZTaP+eP7n3kD6zi5n6ApPf6/j3d6NGEPUjB9X4wzARkQWbQ0jqbwq1fwgs+OO1Efha3i05O8rcQyIQUsA1Xc0VbaY+HEkti6AGWZNWPsGrVhgbsYeb4UvsZXFEkvjREPLFFb9mlwFKc9yxFmpkYpJEQFq/Gm8Tt3LsnmqQBt1Y4TtEnUYywob0nv0LSK8w3k1MATiUpMUz2DM9BCQJVTrzL8NnygdgikOFprZVJ5duIH8LHaPPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f1d6f4-d201-4937-05c0-08dcd88cca91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:58.7159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kZ2HkrkPMB4FSNZ+PNFJPQypMm4j1XL+7+l4vF0XwammJlXWfoW8fKPpmYWDrM4xBgmC5FBGKJNQvIkoglAcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-GUID: 9F15uFOJm0zM9pa5P88kX6pN9uQZCAiB
X-Proofpoint-ORIG-GUID: 9F15uFOJm0zM9pa5P88kX6pN9uQZCAiB

Add proper bio_split() error handling. For any read or write error, call
raid_end_bio_io() and return. For discard errors, just end the bio with
an error.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..865f063acda6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1206,6 +1206,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			raid_end_bio_io(r10_bio);
+			return;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1482,6 +1486,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			raid_end_bio_io(r10_bio);
+			return;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1644,6 +1652,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = stripe_size - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
@@ -1654,6 +1667,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = bio_sectors(bio) - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-- 
2.31.1

