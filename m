Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C29198A22;
	Thu, 31 Oct 2024 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368914; cv=fail; b=SPNZflnBu6TEiGhDin8IbqxxMCHjcZEp9gzA7gRHEVQRC5rG6jDEf4kAxU3RVsSL8PPk3kvPgB+LTbjTMjOgGEe9/5JnlwtJAyDla4qJhptDPfU6ESEcnNQmY8aHLGMNmi+QS8IR+mJIq8tMwPIygqaPBtn/SAyTYpEEC1I9dqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368914; c=relaxed/simple;
	bh=IQ8Ai2d9D6HUH04vHx/RfA9bTRvNZeNq4WJQeq0y8mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HnMd6LXEDltPZpH2CjVdJrnoukVMIvmW4Terj/N1CLCY/pdlliItEsFAMe3w9jHh3XxoG4pdpztddd3q/K4RLJcTocXJmGUNlebuZ7iJO0fIs3ZFyWLB6FaPNbrpm1nZGOtsTLJkDXWEAPYiSemXQ4pRx92rNGHEkTt7yoRgwUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MONltmRZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pPG0UIKx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MONltmRZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pPG0UIKx"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8tXph023668;
	Thu, 31 Oct 2024 09:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=c6EReUW9QYM0vi5N0RYoxOHXOcFSJKmg2fpDWnAvUmE=; b=
	MONltmRZk2j7Q2qiO6cZ8+9g0yHPMUBmCjeIHTqN/QwegQrq4f2SPiDu/lmj9eoa
	8Isp8I+EXuMb3fKnWcNf5YVax9R97QJhDECGqBNjasTimipnNY8kXZPRMxPslxqw
	pPL5sDsWerPJs+EsH0CXrvvE1agmRQLmjiey9bVczcE1IdgXrCIrLdKodqsNpb6T
	X6lxuiX5dw/+N9+8UBAGOKNiN5Q6TQtZ53i+PvnSdrFJ6E3a4c1ml435qZOQDGsM
	iT+Nf3JBd1usjJowL2rxYqPp2xvRsypCEinc9SVPyWEth9n8Og2dX+cT0GSTfodA
	Ieur+v0knot2iUgiZSl93A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmj0td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V86dKT034810;
	Thu, 31 Oct 2024 09:59:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnda7b52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GciMFW/sE+7Aqcennopag8xUvvA5nFkUzMUyiQj0Jskn0/+4j4TIZuhk/I29amp5Gd9Eb9CTAZif16FPQK4WMPYbM6Fe98Al/gp8ys4N7EuckhdSAUNQimXsIccrG7wqwamOpv7skya2MetQlNgX/VYXT/MF15PXWNOylmknRmSdb7oAxHgR+bff4kbS2nag8gN00aGfg3bF85j81nvt7usyfk6sb8uqQtbYFWuXMpCBSxl/XXEtNkOs8yJJ1GuxaOIxsI5ojTJ/Ep/8LKp9UXW68fPc4xz7srLoEIX0J39VWGjW1h2Z/51zokPOlrV9gaz+WO7g9wP3ntthM32vZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6EReUW9QYM0vi5N0RYoxOHXOcFSJKmg2fpDWnAvUmE=;
 b=bhsoYeGFYxHi00VmDSg9/qXWG6kTGlsrQBr7gn5UHOsH4FPk6SEZOxv3aUlm2E8L/777Ek8m9pUlDRM8eMvXiEtgWNIScEd9Ms24kj235uPSRFmpd2D0zKGeSPYcBkunsAxJal6/FZhlXtzRJNsq1NUYNEIuzZSX2UP8NwXve0pExVXM5vh6AyTaQwuOq0UNtCUa5whXTyjYfj+NtKHCEse2fxLlF+HUgN84O4NrQP1rw/hPlfaDZZKXfsNFoCMxerWhjGRV2pOLP9MNM/BlIdI7xOhrvMH7QvhLqbPZPjY42Q6DxMVc/6Kt0WaFo+x2esVoSiVPteQ4SxOUK2eT/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6EReUW9QYM0vi5N0RYoxOHXOcFSJKmg2fpDWnAvUmE=;
 b=pPG0UIKxCP8gXIhTlY1hZOxTMFP8j8NBv+z9VfXZkHnBVQXcnSiX5AtYWk49cgLvlOhOo2wNBCWH3UOxblnqAT+/17liOSktlgb6QUWyIwWJ/FjdDnv0YbsLcYRtS8DIG3qZk0Yd7W2RcOQapIkqEQwWu2DnS/bHM9AAIG0WjOo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 09:59:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 6/6] md/raid10: Handle bio_split() errors
Date: Thu, 31 Oct 2024 09:59:18 +0000
Message-Id: <20241031095918.99964-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:52c::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: 49433b04-9604-423c-e726-08dcf992b9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rVyvoXpM6QMFrDTgAVpBi5wjDeRpgau+XKniEGiZByi5gWTb2FUxAmdxzW1m?=
 =?us-ascii?Q?trcYytDraZIfPULX+5b3+XzA6mi1kLg1hFl+at/NF7rThANihnRJAXu0CxSV?=
 =?us-ascii?Q?eu4XhurgomopZ/FGGl95lIooLNoVoAfNHLW+8cQb+GF9jkwFkSveisJvKfWF?=
 =?us-ascii?Q?qME9fbtrxDcu6uTOk1SfUi/ESpJo3mvdVmGjyCe1BARfG1PrwtWs/Jd9izU2?=
 =?us-ascii?Q?YXBwLWl2/ZJXT+cYJdp7PUdrkEUma5b9VlvPVyLPfpNg9GydeWqqmzQsIrQR?=
 =?us-ascii?Q?Q+JzS7B2cZXw1A2CuB/wTVMW8ccpEFePBTjyCOa3IGV3Z/G8K8tU9+ULUEhO?=
 =?us-ascii?Q?LNjBkoAXKQoHXga/qwptAxIWRYig3KfWXm5nQdY1ldTtA+TcvJNGb8dvNtAC?=
 =?us-ascii?Q?6QmG6jt4Yzmfk+YcX0RMhVM9N2VLHpKvEF+OQ09YFGNxp2/Ux0JL83jZ9VHu?=
 =?us-ascii?Q?Ah3gqXdXJiXLSQK3nkzjoe08FUEnHmqzRRI+dLyuU84LCxqLtzGRpxUE8x7E?=
 =?us-ascii?Q?KHFlmqBr5vWZujJiOr1850HItd3LvM8LXQHREvokWHMx9b1VNQRyahDsfTcg?=
 =?us-ascii?Q?IYagE/bl646S/gRiBx9LYKsSFfJEicZzys2aWE3QgfFMLE8/FM8AmdP71+uF?=
 =?us-ascii?Q?lrGf7rpfpscCjqgZy5W8UVsI6REe0ZnessPFE3JLsgCrxgBX0CuM+QD2x+Pz?=
 =?us-ascii?Q?kjAG4ZkDd4YQk8otRCiNNMSTLaFK1BAtQwnvbeZ3u7SkUJ7fRyPZznzJZufh?=
 =?us-ascii?Q?SaC/QNcN3h13xa7JP8NJksQWXb+zVpI1t6Q3J1Q9pWTvNaCdoBTj+Tudk4JE?=
 =?us-ascii?Q?UDb+ZmwAQWGYCLtOSM0OGO66Ix1bMiyYTNun+E6pbFQjl30/uXQIgRhF7tWi?=
 =?us-ascii?Q?mi7Udzw7lTo8v2EQCxyIQlYZ/veBEC6XT2zlpRt+95etpRW0xfr18zKdZHi8?=
 =?us-ascii?Q?UPRxFrJ+cUTc3myopEhjvxArjsbMYg15AZ3+ELMPdMIcSVjC9KBQ1u0F9kiL?=
 =?us-ascii?Q?J7/yM5X4jvYuz6J2m01u7gDSE5JkUsCgvkeoFXBHC1joAD127E+OE6K4sVwP?=
 =?us-ascii?Q?mD1s8IIcdbDYhs7r1a7ugLYUSdSXBzRUtt1gdb6b8W/fnsKoU9RrURpBMGIu?=
 =?us-ascii?Q?WHeeBSbcYYr+0OBTH0P2yx0QsnLq4PX3VXbe50FJ5GOWX7lXPk+wmlw6IQ1c?=
 =?us-ascii?Q?ftczxP4IbfYCMj6hR+8W0kkwg+epxHmkhQAT70kx/q9SqK2mVYcMAZqNIhvU?=
 =?us-ascii?Q?NAF1t6KGrlvRn38x8U+YJiNTd1TrmVCiZ2sTmvzG/GMNmt7Q1NPZs0WufJdR?=
 =?us-ascii?Q?sLilX7GwF4+gTSWfZb9EgSS7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ER5HoOgAjrAau2WSFT+qEMWXYoFNmNVnndZihCUm+6ZJoxNIoXggVp8pgd9y?=
 =?us-ascii?Q?e2vVFbPecRluh+J43iYg5L/ci2McsaFuc0boPCSzqLE0UoFeoBUIRis8gz6v?=
 =?us-ascii?Q?nEcqkn9zn00GLDRnCyN2UOub/sjnMmI5M0FyfT26s0x4Exq5FwaX/ScwG/au?=
 =?us-ascii?Q?H9xpu7ymDyM7hfgD2iIW1RwthcDES5BStvhTZe2235UMFiwpt3/rrJzt6Z/L?=
 =?us-ascii?Q?UQGj3p1acX89eIv+vOF28S/iCBx6zQ5biHppLsMKTVALNm/fi/jQEB6LgCR2?=
 =?us-ascii?Q?vsdkfnZDIxCQweeDXUG0Sm1qUCrNd2xW/f34rYgEfskAkWm2I5+bZwcpymVe?=
 =?us-ascii?Q?qqkY35qkmfaMnTyBfkRosExAm50Zw8RLpYIuXid14/GM9QuE5hvd36HdPq3x?=
 =?us-ascii?Q?EPZs+cuLiIUYuajfuJFV15uPOJMMj+/ck3YiJk7OzlWw07vQqoceutmRwwek?=
 =?us-ascii?Q?Dc5RW979kS3Vs7dt/XUULrs5oli2BX9T7ESAxpxHVmtqrpZfa96vjjFgLoRB?=
 =?us-ascii?Q?63Cg+cjmflIuRxBqgRVcQwZ95+JNcJS40YnaCySKGt+6iF76hbBQComBOZA/?=
 =?us-ascii?Q?C6WRnww3AmusgYpGST7TDyqPvVctdmbb5bKdF6lQRAPpKxIg12K3Urcw+Q7o?=
 =?us-ascii?Q?0G6YSgFaOvjtakDnSgY9N+3A7FHxlVkACdD4zvnLxbBHulhh0PiyTTSm18WG?=
 =?us-ascii?Q?L3lssEI5K2XG7kYRGl5/V9tfha8Vm8MMDBhSTQMZjP9NVcb3FbzpJFX7chUU?=
 =?us-ascii?Q?vTVvUaxhFUwXaHphBEAKReI6MQcqulZ5ltuaKqp9+jm78363YSzb3sBxOkWr?=
 =?us-ascii?Q?pulM0j4hddK1mLVZBz0qR6byjD0NFYDDaa/2FoFETYEcnL07OmUkBPqT3E89?=
 =?us-ascii?Q?vwfRAzR4x5rYezIstRzGVCW+FiuyEf35ofPQ+lUEP/xllzkjes9uY8pBxIB1?=
 =?us-ascii?Q?ZllZJp84sUykIJ1oZXgKnNazGvBnIqrG7gvQvudDFCBJMP7pg/IPnu5oxD+P?=
 =?us-ascii?Q?5uBqhs7PRvmfkfkdyqP4402YPDtM4tjf2bihqx5S+hmeziFxDhJNK7QCeNEa?=
 =?us-ascii?Q?y8XFtxTnaDitPQda0ctIwlgmPp0nM5O4pEIWSlaYk5XDPm169xs21HmPnPt3?=
 =?us-ascii?Q?fS35XAItR1smJBng/lJLhh666roZWeDzDyUCCvQsdyCIBRwQ+uM9pxNaMiLH?=
 =?us-ascii?Q?KFnNYH4oFs7UCWoepsghP5RgCiR2C9jocQFxm4lYErRLN028X29puRgcG6m6?=
 =?us-ascii?Q?MccKijX/AvArtaqCPYpNKGo8vxRX78BltXZUdX6fLQeV1uY1nXVjzJrOJtvm?=
 =?us-ascii?Q?asq1EzCGf0f54W6S7sDId36DjjDFWN2xKjwzbD39BaT/TFWFgOuA9umJJv6/?=
 =?us-ascii?Q?Vdx9hdJqdotKi1arD8n5X249y8IHhPZUzkoIx7OE28iuAzbTU/HTiXldQQeT?=
 =?us-ascii?Q?zIM0F46UybCV1cKBSTqPtybc8gskKU2Malo5Un7jiu0bJhehIG9u7/fPWMuG?=
 =?us-ascii?Q?X+7J2TjIAAjhayJ/gDjjUUQrP4TNWcq1nUC+f1H+yzc/uAcVI9GJ9Xkm03MY?=
 =?us-ascii?Q?/+4JWFi+2eIv/5M5IDlnPfRpOzYz2XTQNpLwBA89er8hZkmA8v79QR0T642D?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y5tHLmHVGirnAjlXOW8IdGaquhVS4Xk4LTYDZ2XzQX6jFZz6RCHFg+68lJvHNnOB2DrCbYvPon1GZhdgrh3alKdcXzarsprgRZatvaUVOCG1BM3FOhdCTsrDjnKpJ2IgzhXD62wix90+C8OV+C/+H1bml+V53Dqt+M20bk9AcFRgDJWbH2pXhsVkCBui4ZYj9Z/I6MfkPajeAUghAhuAr6P5zPA9jxJag79bm1BcMTwfUXP2yCKGSvLSe/CNgJrpsuUPcx+CEJpCMSzHdrrzY8fCE5FKRUPknLJzo6+CNm2AhKK0WJGI+mU4SPRgoNzCudCqc/UGz1SlSBPOeGIc5Wek3DL9SfjIl9ZcBFs20QzEqder8mbMsZG/nNr1vntOKMsFy9KxEf1p5l/lGyaSndK8bbmtJlINj/c1LeMLQJ9yE4kKoIcdoyc6+/joqi984/Vq56HndTBTfpsDuKL3/53nm99EtgJvFJmP8DzLjmvx8wjKUEKYKJn7fLMDfvd1PR5df3466FdsL0BL7sBtzti5U4O7oj7GS6uZPO7wQ9CEiUq2UqiDq+udT0+xr0XYBuqvotooPmyzmGWYUhnGsCRIwZAIFMDvoqqUxVQOkGk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49433b04-9604-423c-e726-08dcf992b9c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:35.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxCJXCkSAm+FUm50/n3SDiIo6rtvfpkYRJCrV8Q+n9gSMB7XrHNo9Ya5ghWknVYxSvW2YUGgyfvTKQDTZFlQBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-GUID: af5f3xDWuiOii_YXBPZv_vWtYNeEsHbA
X-Proofpoint-ORIG-GUID: af5f3xDWuiOii_YXBPZv_vWtYNeEsHbA

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return. Except for discard, where we end the bio
directly.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..ccd95459b192 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1236,6 +1241,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1347,9 +1357,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	int i;
+	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	int error;
 
 	if ((mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1482,6 +1493,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1503,6 +1518,26 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
+	return;
+err_handle:
+	for (k = 0;  k < i; k++) {
+		int d = r10_bio->devs[k].devnum;
+		struct md_rdev *rdev = conf->mirrors[d].rdev;
+		struct md_rdev *rrdev = conf->mirrors[d].replacement;
+
+		if (r10_bio->devs[k].bio) {
+			rdev_dec_pending(rdev, mddev);
+			r10_bio->devs[k].bio = NULL;
+		}
+		if (r10_bio->devs[k].repl_bio) {
+			rdev_dec_pending(rrdev, mddev);
+			r10_bio->devs[k].repl_bio = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -1644,6 +1679,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
@@ -1654,6 +1694,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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

