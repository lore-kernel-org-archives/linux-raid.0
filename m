Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93521DE3D2;
	Mon, 28 Oct 2024 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129295; cv=fail; b=dlXCPqun/IjZkSUfZY8L4sf8vTF8qYxoVwf+e9wa8lzQx0EfC0zsUWCUNkXu/gBGPkvGqZLCndfY+ShisFiM9/yVhEGMwGwn13QSNIsmsCkf9JgLghGydiCUsVVMuC/JRCBKejgN0AiaPxiGyKiu7JxCyNdRjxa5Z2Uq+q+rEwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129295; c=relaxed/simple;
	bh=WoI/r1QWjcKziwARogBwfu+3/1dypH6ZqHWD7GAU9AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pc5t0Ifq8Hjavxb7f285PJxmsGRt2mC4nHa2lKA9DdjAUgljfO3fVv8UOgzUATgvFWxgrxe0larwkbCS75WyhqARlWP4JTcdzAl5SLzXhqFLONiIUIWunhBm26dV8ctQbxEZCriJVsJ0GrZkRDqORQAI8FNuBEKb5Nqs1CtwhdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gGFDrfhv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QFmF1zDn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gGFDrfhv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QFmF1zDn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtdr2020892;
	Mon, 28 Oct 2024 15:27:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PSfIh2A/tpTl7ijGOPTvbARB0SZo71fMqtf9XqBRTiQ=; b=
	gGFDrfhvU3nXZznPw2nrZEYV4BdZ0NDNtMhnEIi7BfArdZN2K4y/JLEK7X2ZHAsl
	ZBn/WYEzXzI/A2sfJyHIYXq3rf2ZDwjlDtOhC8T/27m2MsYDrEfJGgpOjiYpIkk7
	AXKA6PA9d7FIRnlCCs+fv/D5/NHNN8bLXXxI6zA2sucMoBsWpn9etsdPi0dwX7lN
	8GZYgnhZ8kdagTvGSB2YOWzIHTDriKzd4vmvyG4Zk9/kdr5ywqoFGgPxI3FIABD/
	EtclLCAO+dRW/2DAuM4CgQxV+bTRdlgg/JJeQ+8jPXkksXkAzXILLw1qNabDuaNb
	DNg4OB/hKwdngP4hbLntmw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys35py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SECO09040341;
	Mon, 28 Oct 2024 15:27:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnamj935-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOicKrmdv+FPdaZXAvh2Jc/p8+a3NG89mkvDl4+CbkHgq2SGKPH6CIYscmHRkSemL8N/9fPLPqkcldUG4sOa9YMhnl/x0saKbIVltVA0SIQfRO207DYIzG2N2P3icyKYeU0L98Ll54HGvfQjIUcP96vYfQtM8J5MlJe4k0lK24fUa63Y2okbHJaUiZy8XndFzSRl5qaHE6N4MaiocOtmxpjjOIRdhEwbfb2oKVlUbUoERMOqhYBx1euIKp7hUg3pmarvW3gfa0QMBOc30N3eHal5dFC9TE5vWW0IH8KBXG111DrmPyUAgVqfvJhPgAW1H+4yQy3gBn1F+ly0LJXLug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSfIh2A/tpTl7ijGOPTvbARB0SZo71fMqtf9XqBRTiQ=;
 b=rxJwDZnOWKCgVlp2AYKwQViYbv07GFKY/874Alh3yVi+/0myaj8D+KHYNO3ScRBWMIvayINWbMAnpUknD6OuX2v4aakE8KDJ6XC2bEqEJj+QUhgOuPU6FFhW2OnsSb8gEVIzA5hGN13iZGkoN7mWty+X4jBpcqD2u5jMeiAu9HKPFRO10Z3C1EpBJzFGrbHCrJPWZ7xB1vdAjMYjW4Zq4Bx0s13r0LggZqi9Kn9N1okTF3Ngh9Gn26bKKIiKC/7ED+WrPAxZNLNoXnLC6HfBsbZORqg8XZO0hVbBX3G1PmIeFBm9qrFXc1MT/9yUPb065T5o2a+0jHyImqsv5M3Xhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSfIh2A/tpTl7ijGOPTvbARB0SZo71fMqtf9XqBRTiQ=;
 b=QFmF1zDngODP+im4iWkUFRT1ul6unHIKUdwu2koCYwDZM6cKqea6c3sVaQf5iU5jQ4F5fkaeEx098cEsd088fKqH0gS3u2lDjAhb0+kU5ekTwFR6QvOOu1b9Q0QddoFuaZ3dXW+mcXXz466Pd56H/2sLHoIWUjjG0ZwRGbnNvww=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
Date: Mon, 28 Oct 2024 15:27:29 +0000
Message-Id: <20241028152730.3377030-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0390.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 6655ea1a-6705-4c74-6b17-08dcf765185c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fMPpf8cGOz6TBd/Kfa8QnRJhIb7ue1Gf4IKCLuSVb2/8du2dqbWfuBEFBVa8?=
 =?us-ascii?Q?0IWWHHalo/GBDlBqlCwoH2GYs6O6eJQSu5+9XpVEB+9CSVG1ZSvv7ZUZYl41?=
 =?us-ascii?Q?3UukW9N22Fa1KXkQsP36+Mv/3h92U0pQxKfDvP5kmINzkuEKO/fKPr6OEYf4?=
 =?us-ascii?Q?u/inzJRA/RPgkodnyJNISVdnbvy4LViuwvmObWFioJqDGmnSABOZBK0F9uUg?=
 =?us-ascii?Q?1ZlF8QoSHmkaBFZ7AetzUN89MmefsZJlV2B7DJADaHzPMj5bjphlzPO9SveA?=
 =?us-ascii?Q?PjDEaxBAOwJWdlc24vDAOduy0mKOmHVyYheuEFQ5Rk8EQgUYn/cpSid/jSRB?=
 =?us-ascii?Q?yTUGKdAf2YgtkCQK1yzFsPPPAwLGmYRuBZ0dKDvBdpKNQimoD3g8MUuXEQ0D?=
 =?us-ascii?Q?qD4BtR6XSlDR+qfywAk22/BwIqD7mwfemDMTfoMPhuFofNKPuMQcnQ5KU0vV?=
 =?us-ascii?Q?TlhDPjV9OifzlDy0mgC5GuU6BEBP4E+xXcwXZijiXt9bNwS7kLy4c1d0chNe?=
 =?us-ascii?Q?Hc/L2zNrC784NQZVFvcLe/osH+nPhNEOHLmuz419va09ap+OLLgWhSwab8jX?=
 =?us-ascii?Q?tcKj8HzERhFVeVp6d5PKLKxV+pakej9hO8wy3vzqGIt5xE79nbV4HHrJutfX?=
 =?us-ascii?Q?2GYsjKdbEjFyu+ipCXFHoDbpc/BDRm+brbdSD4r4EFE2HrgDHPnO3iUUzrIv?=
 =?us-ascii?Q?izM7JJ7I7zkhxh6Earpaf6SR/T4Dg15XdPvegYMLE3iEIQ2+ViyJ90j8Mzwz?=
 =?us-ascii?Q?v3dwXBXEdvInZQOfJO04Izza4D29/m8dqtU7CPXuGnZSraTBckg+FPKwe+2X?=
 =?us-ascii?Q?FLMKl5oCpsLZ5cgzgCulzQ6QoCuxItZz5C9D3l4lXKUXNMDxMcg9BXofK0tU?=
 =?us-ascii?Q?LbiZhoXKtoE31BtozEGFE5oyXsk/h6jvsDvaknKYtkAiqbTAHJpujEERztBT?=
 =?us-ascii?Q?cpYcXj4v8mejxoMU2waGd0HGJJdlzXSi7Drv1DAIAHwZDmsXwgixx0ZYLZHa?=
 =?us-ascii?Q?I9REci2+bTLzIqXPnsnbJwjpxQBmqrXOMSERBFMGa7LvTDfrnX5FR12TPURL?=
 =?us-ascii?Q?T2vsBQ1rHSEZ7SbjvEaWqIk5UOy92dNywO5i8CVSZzT7HiGFirIzQ3LCoSM4?=
 =?us-ascii?Q?L/1ooG9z8mohuEpRgaqcVnZzFDnGZ0Aqk4FIQwG0sLGU0OfqwUKkjTb1HH3R?=
 =?us-ascii?Q?JC3UNlVzY4yLE7yvgm2lgo214iNfMo/Vi+KDXYx3rMhpD467kGvcMUmL0t4m?=
 =?us-ascii?Q?JiOA4aQ6Bvont+6LQeWCQC2NDWdKMgD3I/erjVsMq1MvQOnKzgrovYUvIQu9?=
 =?us-ascii?Q?F9HY4rpYmVDAhWXmo78gOeaw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rwUJhx9zp7JT/lGaQ2j7bzGGtxJDCb8W2LrsI7Evg/hSbXVzpA7yIsqzqGoM?=
 =?us-ascii?Q?X6RFTuY0Iag8vazR+EK1QnetB3xSNhIxOXrHb45FDkVc7Xncr5ImxKZaNZGB?=
 =?us-ascii?Q?PI9hQi37HwpcXk9nTLHLLtNp4vslnlZ7nz43eeza0YbLC7FWD5sG9ynUIt5X?=
 =?us-ascii?Q?2XJAH/eOLwk15TTgagBhLGToNaGbQ5urFxpdLAQY+Z0tH2WA3pngbh5sG/bT?=
 =?us-ascii?Q?chqk6gqxLRWRMbVspYgeoP75W5+UODJv7dn6zdQNaQI67OTrnQyFstuBC3lQ?=
 =?us-ascii?Q?xjUE2PUAcsU6qkqixa6ILviAp1EQV3uflud0EvZNCsqUaugbQxRoQ1Q+FB9B?=
 =?us-ascii?Q?BoXvf0oqz2CaTVoo0KpX2By9Meugt2g1UCDF1uyc7N92/brrh0ELPPXrcDn5?=
 =?us-ascii?Q?CCkDR1L7xiOteVIidIJeFcWWvYhTgE1yEn0IMnqyFv2WqU03N5arHd4DXhbp?=
 =?us-ascii?Q?Cwa96N3W42o8cNDbSuLttphB9BaNpQYwbsfduNCpil2FuMLhuC7pqeSWTEQg?=
 =?us-ascii?Q?AaeKCfA2BjQIhii7lRBuyDJdCVUguitjh8rO9fXK23XaVnAnNAbL3X5Ax5ld?=
 =?us-ascii?Q?sC+2Ni8Yrm8+L8DgbPnPNPPSu4D3DLKU5Dw98pJ9KlCdH1T1t5RWWP2Ot4CA?=
 =?us-ascii?Q?VQ80SUlQL5jP4NQv4/pzysrCoxSvi7lwWsMDnxan/adELT95P6dGsjhaUa4y?=
 =?us-ascii?Q?nvpLdo4ShVpiKpEsQCWfQcU8Er3VvleVF4m5sDFLR0YH9nm0aTpnPwrV/YTq?=
 =?us-ascii?Q?HkkzWgRLZquVsFluo+B/jaDu2S3M8EoD5ZY8JCZBd6DC8KJJjTQquIYzr+id?=
 =?us-ascii?Q?qDKYO5o0YzKA7eqRnIo2i9sQJt37ma7eR1AywconhKxmpY1HbkXPASIln0Ct?=
 =?us-ascii?Q?NM9Vf5yuVh8HtybuyIOWFEqaHELa5f6BnqKF7sHRCgnBrw87+v++Xd4qV6aL?=
 =?us-ascii?Q?E00SogI8LTIUTQC+tmS3Ov+zZg81lfwIbkZt5Lhfbfayhx6YtkASyQ51OceJ?=
 =?us-ascii?Q?W8g/5mxyIuQ6YTfHzKMMfcbvJ4p8uhZANq+OPwpQkQhuLWDYaDPv5XcurUK6?=
 =?us-ascii?Q?29LDFqb1zyv1QoIMNe0jlXGQ3sqC7Tu+SonVRjgWEQUItML7s0ZdTjencnfJ?=
 =?us-ascii?Q?RCcJ2gML0HrZK/NmUa5etHya9gROorzV+LbWR4FMPbRwrTu031+NsYaBNdF0?=
 =?us-ascii?Q?5EdbnmQhwyd0DLupGiJ1sLMaMetgA1u173hwaj/DegtSp9KCjKOkMJtxSJbz?=
 =?us-ascii?Q?/6wC973XL1QCbF8GhNiIz6LjVJ9efC6wQr01qqqvZ+XZwRqv91Z4r4tzBgKh?=
 =?us-ascii?Q?MSobZ5GdIZy9sZwznmhqe2onx+2P4nglnzWNE3XzU7Un4y65utLwgBxl4M0o?=
 =?us-ascii?Q?bX/hFrSzIKNYC84bgPRndVDT/YEFSTG79cMFtW1LXDurWUzhdM9WmVFOWwRg?=
 =?us-ascii?Q?OfleQ2liAYCuOkzarVgLOzAR6IG7RDYpL/szKkFkrHP2paZXyn0B0vNxolVX?=
 =?us-ascii?Q?Xe5dIV8pKRAIJwV9+jAFxymfkB3fcb0HgZK6R/BEAvM2RstcLdOB32Eayk0l?=
 =?us-ascii?Q?3XlhqFZwHwQhhBaVxY1Z04ln2+iX+Jp8ZnBBjFpwBHEgD0GTCZGfZEY6p8wj?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7QR1tIKT6NXK06drnLwpi6Yv/HppaUSTB36DWF2lMUWNdpIBjCNfpm7AKR3v3Mhkp/dAipxN1DoD6g40kNkL6zpxhhHT5hgubzMozOUvaNguHoZ1qqULKFNQTY9jpIgwV006Z/gWMOA+baRCJ8e+zr94kOtKjDg7tKagWyOE6pRHoVjZ7Eso4dQS+XrpJ+U23taWD/mFv0dAzDBgiAXyrc99YqT677TOaXiZt9tVk4lQVoCf3xqYqcoPlvgSQyJL/N4lazX0C+Fuw7eAm/890o4WTHJ+DfjRNIwiLXfF0hIV/k81oj5q7NlHdMVKOVZFeZzdWWtbhOpoiNPWWNRimrT+lXBx1kpKMmxEsms0rBzf5lOxd8xtT9hbBQNZ5B+WDapXksc2+f1TXA3ubIu/yLdDSj6361anMdjmPo9pY79t1Ga7ktoaUQ52qUouEJM5Fut4EWGaTaJZBuiN3IVvQmuAeowYxqwMx0zfE76gcWguMyZFpFsge6CSNgSVegq2vCcahuR5vhFqnhViterNnyjqMF1CrfWXDRQHB4MMyVQcOfSVlfypWw0R9YwAHtbz+0HkGWJG3hZ4g8fP1WVrBJzhBWa9RG9tPShJkCtMXvM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6655ea1a-6705-4c74-6b17-08dcf765185c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:55.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGuS97pJqEnB5njhAy+yNNJ618wRqs4xK91Y0yTwyqnYWy8EmnbPKxST4SMrG820857jFTHx9KLQrwIIO4XrCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-ORIG-GUID: fZztBXoHjoptEBLDejg6y-Ar02q20RZz
X-Proofpoint-GUID: fZztBXoHjoptEBLDejg6y-Ar02q20RZz

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return.

For the case of an in the write path, we need to undo the increment in
the rdev panding count and NULLify the r1_bio->bios[] pointers.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6c9d24203f39..a10018282629 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
-	int rdisk;
+	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
 
 	/*
@@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1410,6 +1415,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r1_bio;
 	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
 	submit_bio_noacct(read_bio);
+	return;
+
+err_handle:
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
@@ -1417,7 +1428,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
-	int i, disks;
+	int i, disks, k, error;
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int first_clone;
@@ -1576,6 +1587,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1660,6 +1676,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+	return;
+err_handle:
+	for (k = 0; k < i; k++) {
+		if (r1_bio->bios[k]) {
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+			r1_bio->bios[k] = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
-- 
2.31.1

