Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7881FA821;
	Tue, 12 Nov 2024 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415422; cv=fail; b=FWbelgKatieMTz2oP0HT/lpq570x2GSZSGNWf7b0++blMY+liRviZVDKl/LYYADS57VD0XDZOm4SbfxWIE8YeZ0HVGUj1NxbsJkPpSxlVFrOA2fLmeaCN1+a9xtoZLpkLdGUdwB/J1GqFcnbB+ELr/6uOAqpx4Du7q8qKAO27fE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415422; c=relaxed/simple;
	bh=yIcWTxHekcb0WmkgMb7IksezlOOP8/ep6yBt4ONzNUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jYD0aQA6m9sbvp61dqCF7VdX0ZjZ2bnErNaK0LVtfWii4DitAgTG6Pe4Uvlu/p4p9EuVI3uiIkyFBibptWjKRH79dqQoxNwL2QKOqKMFrPirNAaaE567pL+7DqeqP4TJUUz4KowNS9kS4sIPy0fJdEKTJkTs5Dd1Y7opkt1JoNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q0i1SRTq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wqxRSvMX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q0i1SRTq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wqxRSvMX"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfjgm028728;
	Tue, 12 Nov 2024 12:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RN2e3hlFsTwOKqY1yBtlcCTHOQ8W+L/g/0MBuVh/mQA=; b=
	Q0i1SRTqx5A11NCq4gmTPw2CYiSd/AEdHNJo/0HEOOzDyGlnb01AFwnBxPzdUDFq
	zmT2KmnWiJr2Z1jZ7r/GJNCyTWlT66WW7eBsXVcVzAPbZXwPpIHSJP0F4oyCIFaK
	Bgk6VDaUk1bI0nHoiwvddaZb0CA17F+AYr3Ti857QEbS9feGQdVs6g+ogxEKs4LS
	jZ9Dox6ln9d3VYBFZaVDhxUC0yJReXdYyUslobkCywY6o8GKfyAFjkwiPM66fhy3
	eF5kX67+rTEnhskyKqFZhHw1wg4GKQkWIO5OfMmcs9KwOv1AYWIdIPjdG8dNVTev
	UD3gkPIH3ni9jOXRsqEY1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n4v7uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCX4GZ005677;
	Tue, 12 Nov 2024 12:43:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6825sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cfih7K1QmFK6xlZ2pmVyzeE7m3iHn1NKTljGJFoYg9/kgGA6iNmpkGJN6O4iJ05+KLXe9RwXZNkLD0Sk9WxcclhV0oXF2FLHzZ/z84CD4bUeU5W1/TsZmCqHQxHOgFXfDKyWVuou/DqLINFGcmbwCFyQz8Yj5Er3oR22h6pg2BGPxBjZHytaxJDqVtM03I2o6eC2+8lVMkfNkrov802rOdNk9HfY7Xo0X8Cljs4maMLCj5prteTwGoTpe4O0YSge8D7heyatoxsaIx2J/mXf6OrlGeMBkmaA5PU2njJNkCO3fZpdbztTm5lf6fNzmOhPtNt4nVoIUMCmPcMFwL4bSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RN2e3hlFsTwOKqY1yBtlcCTHOQ8W+L/g/0MBuVh/mQA=;
 b=U7wlKi+HJVNrgtWSDQPxcjj0YIi+dSkKuHfeYQpdlJ/s8EX9TtDNomLhuXaxHHpH/hSBEMoBMjUEb7sUBrA200Lcy8PsiAkKsgCylTyrzyR8L4URDj6yRFDsl36DbloKqwcHukiNluUJJsTiXI9zlCwr9VrfxxGi4MmERA/8eIam1LUPo50HGcPrVQQmYb+hHpniA7d5d18hL4XyziAMofPwSCmgu7XtJtz35oW7qYghQCnR1OYBiPg7UxcOfu8bviSHT6vjihwnva/d5nIfX/m1n44kR8lAiRq/HdFffthx2k7KGqdebnvpHLx4usprzZ3cIEeP0+Gg7Cl7VimC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RN2e3hlFsTwOKqY1yBtlcCTHOQ8W+L/g/0MBuVh/mQA=;
 b=wqxRSvMXB3vMcpfHsB+dwXEEAQ4SfynEUM6ltQQxF6nGHxtN08O2aROKeR20Nnc2AO93KHYkHZBLzZ5miqxEZubM9ky+rmF4DPZLWj7tvC0bRLEdDJIiCFnnatK8L8hA33UaTreXZ7i+7myf6mRbz9WACKJpyW+nL/Tr7yCRvg4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 12:43:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 2/5] block: Support atomic writes limits for stacked devices
Date: Tue, 12 Nov 2024 12:42:53 +0000
Message-Id: <20241112124256.4106435-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c664e08-f89a-47a2-9ee7-08dd03179070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QS1VrU7/6/EXDOZPyymmEuMCPah3Hz7w8Mq2VoIyXXHJr/MbpIrNILRSpYmx?=
 =?us-ascii?Q?MA8tHrzHZwAFREMI61QBSP3UzD/hgIGoZV1JpzddAFifvX/PRe3TycJ0AwnJ?=
 =?us-ascii?Q?U26spyfJShZC5CVrAiX/LcrjOn8gpTP9qBORl17eTXZneGqQ2PbUja1AtZOI?=
 =?us-ascii?Q?Vm9Gm60/kO8tX3iqPFk5wyyJplaN2ZhS7PU+G/WcgQVSLOw+FCPCRAjLYkdt?=
 =?us-ascii?Q?TNSqajkdmUvGEqbRjnd1zOwBwbIPmjoaJfhHtWiUfIDIQYh+V5KDbZyln89s?=
 =?us-ascii?Q?JMVKW1pwrngDDGglIAiQzeQOww8ygw6KnUf0WkDQ5wLLbvShjhQbUa5aZLZd?=
 =?us-ascii?Q?lDfK23DUZZn2TVkA3rFaOxw0G2a0ndqeshl+gByWbJAKqQMyyOe6cqipeFQ9?=
 =?us-ascii?Q?h7NzTgQp0bJdgyQ6lNvmztjkFlJf3XiVatsquOaWallsSIT1WjucR0xFFMpg?=
 =?us-ascii?Q?+yA2QRK5b9wgSNPfHrSA7RR8zFkb3zRQ25l/XPPjr/PkkO0f+PQO4VrdLGES?=
 =?us-ascii?Q?xPQR/M9imIIKhTR0Heo59EGzU1YV/YfxNb0Y3NILgOnpL+kDlw5a4gCiScME?=
 =?us-ascii?Q?xt08eQJT2ZE8k4mdj4j+OIfcpICRISKzv84rNDT+ILEMHNxUJFXDluxg7RgZ?=
 =?us-ascii?Q?XRYn2kc8PXnx2pNXonqJ0S02q4x4nis7YlEcx9AiwiNuKllSCwkHB9XCpe7e?=
 =?us-ascii?Q?HzfWhnDXhkECV/K4rZYSZGow4HEzVrZQ5POgj8DvmYykXJRdLy58ZQpx7QQN?=
 =?us-ascii?Q?1qOGVSgNAueJhZqk7VzASv/qwlDcTcMz+XdUi60kqy+dXda6Aybplp+T/31Q?=
 =?us-ascii?Q?JsGsLk+zctNtdrgFkcBGcjjyCIxOUc83XvVGKj0Xs4pN6OQwnAiFnCXS6I24?=
 =?us-ascii?Q?sbjBgdeml3r9Ot2QkE+dqMCJRRf9+dEdKF5uL//mmMdHrLcx5YPWPbXTeSZS?=
 =?us-ascii?Q?2VWe/VeleC43amWw784BucNzqeB8uFaA5SOrY6ctRkXAU+ON5OzdcUEAuice?=
 =?us-ascii?Q?HkxnS1aZe0ldFuYOAYdt6JRZkAeO1nzuvnOXsUv3eRc3hWFm+77vyCOhYOWm?=
 =?us-ascii?Q?NmLPFp/X+vkaE/ZD0i3h/FXhV8WYepduDBojW0hV9xolrw7JHFZMEbzOpayw?=
 =?us-ascii?Q?wI5Otsm+Vaf36I8ewjLMlivoIQA33MJ+MLZpye5Y+I56kA6WZGEQ0HGkTQnA?=
 =?us-ascii?Q?m6K3OIr7qi2ERR3hvJYl45ZSK+qjNj9d0Qltg+HK1ajS45GoFN7YkvvKjY83?=
 =?us-ascii?Q?55Hct6xs5N9bwDLaLZIhnTBGpQSoq/dyFiupnD5dbsHeJVXVtfHjxilXYo5x?=
 =?us-ascii?Q?NTVO2KvQsWZ1XQT9w19EFcFG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rnFub/WOJ3zMYn3UFvC8Q0IuU5XMpmvANx7FnPZiQywHDKKtsI9Hh3SCpkYm?=
 =?us-ascii?Q?SjbqMB2kdoNINpQ4hK2765IabIaCtB27OWhNQe2rmCjYz0YAv7pG7j7LNEjK?=
 =?us-ascii?Q?2gPMlh8G/uBhc4NEmHknSOhOb0to3EGFeU78jdYwpAiIAAdbaVV9Zh56ICLy?=
 =?us-ascii?Q?VqrH2CMnKZ0B/zu105wiONpDF4jutlQjvadhSb+qRgrW7QKwqPlYLar6srpM?=
 =?us-ascii?Q?nEoguQQEs0iZ5izt/SlOu/Ocj+cRClQMTAR4REHxk92KkdBs7jcNiceOV0ut?=
 =?us-ascii?Q?K6XZspEC9PDohLAUrKm0ypkahImnZwXPMavBnJ0ecyZwzS4JHOry9uCY+pBs?=
 =?us-ascii?Q?vihN7zHnQsdMx9R/4O/kWEu8BICMrd3mki8TQjXZ5pmdIR4noW2zht2uwmPy?=
 =?us-ascii?Q?GJsFItH9tzUEnjFKnA/7atf8o3yQWwlw9u/lXCQy4osQpA0XP0PGd+AE/gUn?=
 =?us-ascii?Q?X0rVqfX+1NesA9P0Lnwpt4W+VTRw6YgggJNagsYLzCRJ8ZpbYJ9TpIsI8jm4?=
 =?us-ascii?Q?vVRi14OzyszQycWiBn2btZyEWtsycKAh+x9YVzCg9opBKD5OCkqVoBFp5Vx+?=
 =?us-ascii?Q?pkqMVSp1c7wze8QPm57Dv4xwhbivIeFEeo+uMqMueiXgp4D26r1W8Nwlc8u9?=
 =?us-ascii?Q?9td2zNYWi8WaLxJYPM6e54fyNCPycAdVguWcmv5W89Q4wGZfgeNdfQRIMESa?=
 =?us-ascii?Q?pk5WmMr9iy+VAT0NASAz1jBdWIWw3FUBQhgVi+PqWrX8cZbYXagoWCwb4/Xc?=
 =?us-ascii?Q?jiOztefK++BezQ2x5BrZTltkNNkslGKaw4Vm/2B+SwCFt4+9DaVYY3Dqzeob?=
 =?us-ascii?Q?/1HjB83Rs/py9fgOki0IEOH4YoM+oFHlsWPMfR76cWGqWfLUUEgzaQz1ZuHu?=
 =?us-ascii?Q?rMSbUW4hRLl5y1zve1i204HN29q2rv75Y79B5l8WqIpGJnlXsLTBgxvOOYJ9?=
 =?us-ascii?Q?ZxsbukaG2fDl+sBsYxvcSHsEOuyYyxonCuSkn5aaiOYEbp1nHfii63rO0We6?=
 =?us-ascii?Q?BuTu3m1BCZAa4KdLr7S1VQ4lEjbeUtIWavzXx4aqykwLBTY5Y+uTUvSCo4hr?=
 =?us-ascii?Q?7LsW/erctWJMyxPlKdvgTj2u2TKClc8mJSyT4x3ZPH//0v/9mX7MLdNwSjTk?=
 =?us-ascii?Q?HiqXwpk/zQjwM1bgGfBZ6dxEO/rb6kcpCygQz1uL3W7D/jk83afwDKsLoG0y?=
 =?us-ascii?Q?Evar6/VAHPf1OMtypooqW/NIJKrA5M8ZN4/d4rUE/rmoBJC3s0GPUpyJylJn?=
 =?us-ascii?Q?dJ4YBxzxs+duOMYK5fuVoLx/CEWRHSWQEONVUdHC/gP1SF1dnpSGdkpwxvoP?=
 =?us-ascii?Q?ihO4bUQ+m21TuZzJkt54ZRn5vgfnFpNOhM0NxaRfYnheTTw3PJvFgQGt1WkL?=
 =?us-ascii?Q?qfZpmhnVRQXFX2WF2AA7EUXnsm/hLnmA4XiQQwmWLG8X/A0DYTbkndYPH/Ss?=
 =?us-ascii?Q?ruXf+XUTReDYq9JgwXxIicHRsQA2IFraPU3dq+OweTCTi7rWlhpLn1LGJOpi?=
 =?us-ascii?Q?UzUqk5XZYsTZLnaH46KYVEVLIyI9r/YRo8DaP16mTtdNiCndKmzfBNsw1+Pt?=
 =?us-ascii?Q?cpMtruyqvDyjOsBuvA2MX4zdYep0ejWEKRSH+1Rf+5USRW7fDSTH4TpqYXSH?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cr2g8Kl/7K4cnQog9VzIJ7ZMwDZGRsclnIiYN2feLmD+MDWEy9wpnWLkrHJ+qnG87AyKGNBuw6cFyFiCnfLsia8GKW2QrYwiGze/CcGSEkFD0IqjVY5zaHETM4LAGFs6PMtXvSje8RpH+g0fl2Eh4H0jL5P6+BNiKXqc8p7/sPT2saPR0tYXwmZ9qeNu7OsSZd4wgrJ+iyH18o8yxigkGT/h4gnsGXNJ0hlyPvC52U5wEMIidYWVOIzd61jEklMYx+CPnLoHSxTRp3q3MPjw00AS9mJASJ7JcpUSWjXZCpN9Oui4s+0meHKmwK5yyobTu+cnrqMV5QDPVWqufdDYbvaUCs2z/UnURfevWCLbvUIpliWZ1ELVNmdoUh6aTE0aIluihBedctMmfyXV7nYqO4NPLsBmHhQz/kNcmgfQIvVL4W8Ae3wtQmWuLPjvaJ70Xl0iWXsudr/+vhi5mTGFxR3h9hiiAenuDoxNxJ7I4ZzgFUEYznt9BjzHFrAZmrJ6SYjkTo3V3Ga49KyDxdKBa+dLzHVd+1ofl4EURRU7xHaU7RqLcnWrPd/qKVrIT5GchnedBP/t5z6V708HG9QmZz0avrzj4Bqn4ay1Xzf0phg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c664e08-f89a-47a2-9ee7-08dd03179070
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:10.0353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lz+84SQRMjEQRt1PQmLwv3huin0E1spJVFQTrlzppwXdqnENBim4LJw2uH7rgVbQnjZj+n8ni4yhykL/wsDwgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120102
X-Proofpoint-ORIG-GUID: r7d1d73uWyZ9Tu1SvJKY2aBN6HIaf8Jl
X-Proofpoint-GUID: r7d1d73uWyZ9Tu1SvJKY2aBN6HIaf8Jl

Allow stacked devices to support atomic writes by aggregating the minimum
capability of all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES_STACKED is set for stacked devices which
have been enabled to support atomic writes.

Some things to note on the implementation:
- For simplicity, all bottom devices must have same atomic write boundary
  value (if any)
- The atomic write boundary must be a power-of-2 already, but this
  restriction could be relaxed. Furthermore, it is now required that the
  chunk sectors for a top device must be aligned with this boundary.
- If a bottom device atomic write unit min/max are not aligned with the
  top device chunk sectors, the top device atomic write unit min/max are
  reduced to a value which works for the chunk sectors.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c   | 115 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   4 ++
 2 files changed, 119 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 44e1148986b3..e087e5d886ce 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -495,6 +495,119 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 	return sectors;
 }
 
+/* Check if second and later bottom devices are compliant */
+static bool blk_stack_atomic_writes_tail(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/* We're not going to support different boundary sizes.. yet */
+	if (t->atomic_write_hw_boundary != b->atomic_write_hw_boundary)
+		return false;
+
+	/* Can't support this */
+	if (t->atomic_write_hw_unit_min > b->atomic_write_hw_unit_max)
+		return false;
+
+	/* Or this */
+	if (t->atomic_write_hw_unit_max < b->atomic_write_hw_unit_min)
+		return false;
+
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max,
+				b->atomic_write_hw_max);
+	t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
+				b->atomic_write_hw_unit_min);
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+				b->atomic_write_hw_unit_max);
+	return true;
+}
+
+/* Check for valid boundary of first bottom device */
+static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/*
+	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
+	 * devices store chunk sectors in t->io_min.
+	 */
+	if (b->atomic_write_hw_boundary > t->io_min &&
+	    b->atomic_write_hw_boundary % t->io_min)
+		return false;
+	if (t->io_min > b->atomic_write_hw_boundary &&
+	    t->io_min % b->atomic_write_hw_boundary)
+		return false;
+
+	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
+	return true;
+}
+
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	if (t->io_min <= SECTOR_SIZE) {
+		/* No chunk sectors, so use bottom device values directly */
+		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+		t->atomic_write_hw_max = b->atomic_write_hw_max;
+		return true;
+	}
+
+	/*
+	 * Find values for limits which work for chunk size.
+	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
+	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * So we need to find highest power-of-2 which works for the chunk
+	 * size.
+	 * As an example scenario, we could have b->unit_max = 16K and
+	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
+	 * aligned with both limits, i.e. 8K in this example.
+	 */
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	while (t->io_min % t->atomic_write_hw_unit_max)
+		t->atomic_write_hw_unit_max /= 2;
+
+	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+					  t->atomic_write_hw_unit_max);
+	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+
+	return true;
+}
+
+static void blk_stack_atomic_writes_limits(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
+		goto unsupported;
+
+	if (!b->atomic_write_unit_min)
+		goto unsupported;
+
+	/*
+	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
+	 * device, so check for compliance.
+	 */
+	if (t->atomic_write_hw_max) {
+		if (!blk_stack_atomic_writes_tail(t, b))
+			goto unsupported;
+		return;
+	}
+
+	if (!blk_stack_atomic_writes_head(t, b))
+		goto unsupported;
+	return;
+
+unsupported:
+	t->atomic_write_hw_max = 0;
+	t->atomic_write_hw_unit_max = 0;
+	t->atomic_write_hw_unit_min = 0;
+	t->atomic_write_hw_boundary = 0;
+	t->features &= ~BLK_FEAT_ATOMIC_WRITES_STACKED;
+}
+
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
@@ -655,6 +768,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+	blk_stack_atomic_writes_limits(t, b);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 65f37ae70712..b9e5b00cd825 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -333,6 +333,10 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
 
+/* stacked device can/does support atomic writes */
+#define BLK_FEAT_ATOMIC_WRITES_STACKED \
+	((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
-- 
2.31.1

