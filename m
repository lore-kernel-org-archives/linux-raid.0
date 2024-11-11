Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52B418B477;
	Mon, 11 Nov 2024 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324150; cv=fail; b=UwSHsFColVg0rJ6k5QmhaTvWZIsE+evtVa3y0zGBXVqpr47J2tIPA0EGdfc6W2a2V6ryIukbIuBKltClIXdm9+M7pMXOzrAbWSJjKHpOiQblbPj9Dpnsf6evNIKSgUslzQ/58MTpgNZKNec9YA0gJwgwr5/Rtg8r9DaoiRZ3kgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324150; c=relaxed/simple;
	bh=/cHOfbTG835JH6CcIrHYYYWjHtICskM0tWppthHvILE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SR+ziH8DMLOdRMT5cxOTkYg+coKtd7zIJ2ZxP8ba02wE9/Fh/QKZPvqQIJlbCQtj78ceXXgGfWLtE0IPI7QA5yG//cGelfYf6i7GePaqzU8n2mfozqn34hY/3RzTsPkt006qmduVj992fi6/mN5mMsjf25WPzLI9pSOKYIISIyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OYkMUqKU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SlGcR+8c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OYkMUqKU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SlGcR+8c"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9sp9g016893;
	Mon, 11 Nov 2024 11:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YHu9JCA4EnCLsG+rZcsG2+5GuMDIeKNW2lw0WFo48B0=; b=
	OYkMUqKUkZ/9Pf5hafQ/SJCCvwm2cq4t/3J32Ksi32LYW3ppE5MTWTtSrFO1Zx/t
	gdm7w9Mm2pBram+9P53ze5nckj234hFvG16uexDMgN48NVbn3BpwcQ24L0EjdtkY
	kOG3DMSxR9H9EMcShyj4xexTolZkWx3+DDcgHpHBC36MoRbDIjncFq6HE4KdNr/Z
	qeyLoF0+PhXnJU43j6Bvfkrueroxy0MiTv9pqQPmMvAfK/ghb3F83FeIc6frzD3s
	hkBnfyclI7YNbsvNdc7xjCy15SSi8eUBnzkJpFKFOWUiBGYL4zl0csIS+RxBmG2O
	B2zTg2kMLZLNtrIukZnMtQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hna7bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABAnmBV037166;
	Mon, 11 Nov 2024 11:22:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66wt8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOJBBYg9735vAFjpGjWyzEMBPGRvlE0ajrJyDbFSLp/YoArmDPTbCO0I028Eoo2u5Hq4v7MpQmjq9yKoit3iG85j/8t3Fp9nXBGic+E4hH3ntW0cl/7qKh7L/DlA9l6aJeFYLHs2wPQ3LQmSRumUdH71US9ytIJ9m5OPiaHpqkmmV+WmtfKOWqOC/zrOcTcbk8S0JyRMODaC0lRL+RjX+vdSnkax9kn+zz2H/6NJHkdoawcCySfZyzaLlKQvTN3juDdGQmYaNIsKi8ZvJj4rMLLAnbtByTkWVt+52DcE51SQUm28dM17ZBlFsWQACtQ/UX4xuXGaZLU9n89ThcqfLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHu9JCA4EnCLsG+rZcsG2+5GuMDIeKNW2lw0WFo48B0=;
 b=ePCSpx4tX3XahKOtN+keghepmwKz3/QmZqgIQSAVKJymTKBBVb1DZ2uMI9dkLFt7N/NXoScO95gR9WrTTAbrrBPog5exQagQRPWeKmGfV9kN7IPzu0Tn4muLU7gL830Nb/UhFGDNK2v9KPMa17pZukxlWxEvv30OlAbpH/EH9VljU7N7bxr/W3cqmH0zLO0dVZ+gvpDCPUC3UdkKyRZ2uHT10X1tI4kzVQehRbYagCmd9IqNDBkdjLlfx6tLvmuz9e56uoJWvxJkNIO4adFqK5pVL7pMA0PzYwzRfAdzifV3XVuPBfdyEKrx2oxacBVAe39T3++q9iEjdO6xK2cmpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHu9JCA4EnCLsG+rZcsG2+5GuMDIeKNW2lw0WFo48B0=;
 b=SlGcR+8cFeNH3rplXYrQw1SQ5aio7jhIY3ZwNts6VTuDzRo+Voaotn8FZQSM/het9LK0K3eh34cEc3cqdMPRsaxMUFjCdJ9WzJohsVt8Bz0Gt5fwZrgH/OTboHN/QbyEXfmATiP7+o9ripo1wSQnlAAxqbfVf3kTTOka3Md+ags=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 2/6] block: Error an attempt to split an atomic write in bio_split()
Date: Mon, 11 Nov 2024 11:21:46 +0000
Message-Id: <20241111112150.3756529-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d1645a-1773-4eef-6353-08dd02431648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YSl55J6UbuNGpNNy8ZfbSuj1jQJ+Qikmth8fqyJG9pr6qBWF8Z42Ld8duAs6?=
 =?us-ascii?Q?e4/EiZZiRIFoZ3Wp1ZDxyyZRlzB0Ielm3WH5gCxd2IUtnt1zCLunIodCc2W2?=
 =?us-ascii?Q?AURI12Ul++cXOn6B3Ixse15PlM+ALoqDCsN+judwSAPL4A8bdttL2J22poEM?=
 =?us-ascii?Q?2GA3nw8wBP03+x24jUUcwWZ2emiwCGdE257XCd44lgbhFvpe85wXwDf4mPb+?=
 =?us-ascii?Q?EuYbw3Zcir7ABfohRZdn9/BlDOZdRgUmAhJ22kqQtpQoVPzTw1tcHvS73hc4?=
 =?us-ascii?Q?SXRckTSiSmpaXSJFHGQUaOsS513NbB0ZWvcOUfXWMPxK7jKoPWgyaWH4zns0?=
 =?us-ascii?Q?caF8IETgLY94qsMC/LWZV0cCNKvchlBWG6ZCP8JI+PS40hEivVHfkk8iZb0h?=
 =?us-ascii?Q?325QiTI4PrL7I+o8dplOvdoCFX0w/6IeEoDf0igqF50mwkVZc0BEMGieSSR7?=
 =?us-ascii?Q?M4Q9iRPo7I5CBy9HVZLncUl/g7ALFrAGmK2Tga+wMkzuJDz2EAoc5daSQNpl?=
 =?us-ascii?Q?hV7R/vR91sFLqVsidHKZ/Dy2d8CD0v24wsgsja2QRTvq3jtz/ZcEyxms7/l9?=
 =?us-ascii?Q?noqsJY0hfNqpLa3aGFOZymCcwQNhflsO09p17rtPOFxOMAoRYJ4SFqZ451Oh?=
 =?us-ascii?Q?tN90kDGBf6KVFbfqC3NCF0suU60rvaiMMvyVAchNzN2gMvLazFtRDCS2GK9t?=
 =?us-ascii?Q?UQWqftNMUKvTipg0HRFm8+Y1cbltUi8YhVsDpJvmEnPKTbnvHl52JtNOxk0c?=
 =?us-ascii?Q?JTRZm0hrYWRl/hKtIOwb9k4pnwDHnBxBDgYApV/h+ymZ8WS3Wm9OxossBYrU?=
 =?us-ascii?Q?JSlUe9BY+WcUEOqqmsRPdZXsaMvhCbUeMHzTjdQUFK1f9Y4k3zS6QeQKXxdK?=
 =?us-ascii?Q?TbPILn6dqT4+LhxoH0F94z54X+aSKXWhq72rTSzNDp33cno8m2GH3EbjICqX?=
 =?us-ascii?Q?Cyjz/7/XdF47WXjf7JDG+pgr6us7r7STGGjQ7rgzIRDoLpHArKTHKmBGubDg?=
 =?us-ascii?Q?M47Hawln7/2l5ImBHTYvU4/EFhyeigejWN2C21O9yNg/BTL5D+PCF3dHBqXE?=
 =?us-ascii?Q?xUFF4KwuWdnnQ7fWY7ceyCbHRuGxcM3NMfWLboK2pcUaoN1Pd7VZsyM6/m/T?=
 =?us-ascii?Q?Rnr/7fs46USeHCPhtGwBVPvbOnOuOCiqtmLVTqXHV8e3NmvNO5TGQTaVbu4i?=
 =?us-ascii?Q?myfe7i91GusJ0OT5o65X2+1Raa0+iZcX6EL8rx2ajlwuQZbSDdx+lBHu8efk?=
 =?us-ascii?Q?RGzliQ23XWdvnVpsrug32EiHNcLybR819q/rnoAaWs/NLKC9YgaYGgciLCb+?=
 =?us-ascii?Q?mXDeDJuBb2H6dsIIlta1ssX+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kx9DhU74V4cv0BPs8WBsREpS8+unMUi3R4wjJIfj8jxa8DH4dHoZ8eaV0+IA?=
 =?us-ascii?Q?DedwwgRJyFGTtKsp9w+zHmy+iJ2Me9ZlWWuDH99XJQiMy2pEdUdjPZkoW1FO?=
 =?us-ascii?Q?kdfbsarfO0TQPynmBAgpQZFYJxJZAZAaiG5cGhZ1XrGRa1+D+fcIctEHv1bM?=
 =?us-ascii?Q?WZ6r0aWK9IumnQxrZjx7Er/EtlHie6I7B8DLcEBcfX+x+8DPAjK4ktNHRaJG?=
 =?us-ascii?Q?gANatChhs6I6pOmp3o9OS7kLqcO67uzqWYuhjg8fpUqRhbeZs8nDg30njjqd?=
 =?us-ascii?Q?vBSJtqDNBRxKALh4lNv+Oa1ZJqfYL5iqrFOwxJJ2it+oDQqqQjbqnA3H875M?=
 =?us-ascii?Q?LrSAPNbmbNNi3ACYc2mVIvNsl+AbdWAMV6t4o4iX4Zqa3a6MrEXnTjWDO3nL?=
 =?us-ascii?Q?QWh5QDf3zBAefSf2HdNSQ/Bwc6X6+35dDQ9O/C4okOFT9SktxMoDdcXIP0j+?=
 =?us-ascii?Q?h1L+duGkyI3m9U499JNPwd3TYqdsvYteY0nk059wBx09eLeXUhkWPoH08MI0?=
 =?us-ascii?Q?qwjA8FPS5TH0p4SIZ6wAgYKYt6+UhFbjAQfzJ+lXPGZPm2t/NJc1rOF2E8yB?=
 =?us-ascii?Q?GwwL0nXEyjS7JB4WlqHwS6ay0hNqWWeHju+S5+m1SkkBlQcddPPTVaGpPXta?=
 =?us-ascii?Q?sEVrTfxh9ud2xFLgI3zrZMXG2mgP9G/Sfvegkb5F3uSZFPGw/eGXcpeUTy8w?=
 =?us-ascii?Q?DGC4UVoXr4SaiR18CXzgoDKRFrLtd2IOQPUjy9BQhIgnS5Csz8fwqB30FCyt?=
 =?us-ascii?Q?G1s4HLGCMaqoyDHlYZPDCYfnSDF8vC03qs3ipP5OBKFDnvFXXlXyO3X4zsah?=
 =?us-ascii?Q?hbh+ei0PQ1Ro2JAkezJpoR0bA9ZG/oMSmCNetYV/QNywnqrKbFgbC5q3AFpC?=
 =?us-ascii?Q?jSHJp4T/adnmUDGUKhN9rwyPkfQ76hSCy0Jzqj+CQkuolR/kCgWBatkgs3SM?=
 =?us-ascii?Q?1PWIUi/BKv5yO+DZXJRLYfAME2bqpFr21PTBbYggm+pgbSKyc1G3eSUU2EIV?=
 =?us-ascii?Q?S5Qt9eu1mtjfR5+a9JG4yp1EW4uger3KacsCjRAHFfv3Px+p/XnKKMzhZCFs?=
 =?us-ascii?Q?DFIKvC40Mv4q9+aS2Xt/YsZmJZxULt4OP/WDZa/+W9A0u4zZdl0yDYkvTqbY?=
 =?us-ascii?Q?eOXFFtbkZ66JjLv/iKTXJVf1rtNoJ8il/JCJO/Tea+GebKq7JYl4jNUnLTFe?=
 =?us-ascii?Q?RxTpoxIOSIqOBi8WfKUrIu+D8dARMeS5J/y2STknjRDYy+fiVkSseQlCYass?=
 =?us-ascii?Q?0huH5si11hC+mnJFUdmTB3llyZ0gQeyWkgcOe+xT1DvlduYdDO65uNlwRIhX?=
 =?us-ascii?Q?iLkQ4x2OQn3cGGztxKFdoXWX5+c916a8uohiU94M1ULM5GRFcApgCCW1WwzP?=
 =?us-ascii?Q?mGxa/1cg8DwNNdOZCpJnWesbP62n9KKvpDZN4Z6Fn1uXEtZkAIJkKEeSofOE?=
 =?us-ascii?Q?2Y9Mi6dB5AtzMN/Cm2tj5y4GsPCaYQm1fAF3vW+fZDjzzuMD78uVAsUTSIib?=
 =?us-ascii?Q?OAyQmyW1J73P///+iCf2tBZSDFux8r+FNXfa9aetgemorZUpjjSdkj/tWYvS?=
 =?us-ascii?Q?DBzGliiVwRyM4QVu+GOtAq38HZZou90Vm9nNfIjtBsvqQbDtHfp0Kxz/VmnF?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	82t+fjaTog9BI6GWRzmoyclIjwMOhPbRKEf/ln7QApjQCIUIk4hinvWekxLbuOz7SKrzM8GvhW3O/YBBp7ab1rxQUhn11tOWsR/Mj5mr18UuSEW6Q3dPiI9qF17oLOwMDsy5HtITuufXB+jD5+cEP0RLbNmIYQ7geUBof8rH9V3foLV4oIBRd1a5YFDFuJdTDIPZgLY5tYraJft250zAr3I2Ssc+bW5cGC+fuEuZTZKoW6auR9TfvYhNttO/X0wy6HD9Igx6ZKnhAuvT+vIsDVSU1d7qWNn+xb34fC9R4OaN0hnSPRvHl4aaWMOofL5WehpL6QspQvViYiU6bIfIDkxZkznEuKy65xKFEbjL6YVQwyWJEhaCTgegdTjhS77pgxZml8/J8rkdkZ9QPffk27d+2mQVKEvA/reVwXeVtgGEHGDoS8JLsmZqr3E3+BZHcreTUQCUC3s6N+7DQDW7Zt5JfDeWPE3dn6mDSIjnniYODZ5s3qwgrzYN4IMuJu9dQwIJ/Pu8wlsbENvaw1U1uOk4HADSaJqmNdcvRgXYNMiUnKq+HjE9tXeY9OrMf5bEpmPx2TQTTrlzY3kF3krs26NI+EvU2+zQzvXhVzccA9w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d1645a-1773-4eef-6353-08dd02431648
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:11.7456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5eohu50yRAWXUngXGBqp7m+nGzeU0zAjTSs2Uud0Ht2hDpukjnVwkHVGD5gSPIcYkY8WQNpfy6vb+RO559HQ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411110095
X-Proofpoint-GUID: xtGAQxezlkusHtCxCaCwkqlAXkq1iVAA
X-Proofpoint-ORIG-GUID: xtGAQxezlkusHtCxCaCwkqlAXkq1iVAA

This is disallowed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 948b22825510..699a78c85c75 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1674,6 +1674,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
 		return ERR_PTR(-EINVAL);
 
+	/* atomic writes cannot be split */
+	if (bio->bi_opf & REQ_ATOMIC)
+		return ERR_PTR(-EINVAL);
+
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
 		return ERR_PTR(-ENOMEM);
-- 
2.31.1

