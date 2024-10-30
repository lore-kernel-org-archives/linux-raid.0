Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4129F47F69;
	Wed, 30 Oct 2024 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281811; cv=fail; b=OxQ9ZxUg33ug/0FnWqqiKvAtUNUqNUbsJwQ0DkaFSMNuvQ456zoCS/k50ya0vqSi9ElUhFqZ82IFMeD07TBOZvIo2zjYC4vDs1Q3Fv2BjfyBL1Y7goVx3GAu9hmgxRmgiSSbtAtMdr4Hr/btylQYAZZg+a48oHonG+4VKpuNYJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281811; c=relaxed/simple;
	bh=51+tbdWrGK7GeJVebgMzh24fmAtgHv3IzADiVXhq/6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLmzdkNaKCXLxBoLWv4s39rvTJuJG7q1iJjCFR6Q6bSsR4tPKfgTqhuPiBD6L3RfEGHQBE83G736f5nXGVsl1Yz8iA3xUhE/zOe3DWxdOYQDaJ6kwBL7WfyykCnbI7U6Nu76ekfkAQAy6O60cTLF2NSlAQaZZnLm7jChmVcf2VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QpIkn2XC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Pzi5Lw1C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QpIkn2XC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Pzi5Lw1C"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1gc4o022254;
	Wed, 30 Oct 2024 09:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ATUqzNGRzjQO142Qvfv6ph6blGO5ahwog0aRbhCRv6A=; b=
	QpIkn2XCR5PlKCD4A+5EcbILVh5hJ+aj+fYFp0jOORxDeWndJXxLUuSOZF687if7
	kq6Cma90u9nZW6Sl17//u6v/TavaB/6BJMDQJh0wp92whxjgYrlew7kJL5jD55CY
	0l6ljgd/91K/8uknJb1xr+rwbAMJnEVrnWV+o3TDWj7ll6u2YH7wfSIL21yxYkhh
	oh0+HbxT4HTK85A0uTWXHUoDgQnLDkEzpHbNZVJu7g8y45rjA/blnvdGjf9P6m5z
	IPb7/8t+pCGdjiAnvlAwmW0Wk+wUwddZgRA4HlIsaqmeykMTkkGwMi6F3V6JHDZt
	/YHQgPe6k9kpeJIjn09IYw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8ykaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U7TQrr011738;
	Wed, 30 Oct 2024 09:49:58 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnadsys9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLEjPaFCWKvwRPIK4Hznws+BMJa7rFL+RodBgkZ/AM7fB6/5KlYoWjAdE9AD3eyEs8s6cBmDZmxEqPR1xkNzc8VH/0i6HsJWmH6rEgTs3ZjhWWo30MWbQ5GMt3ZRyNnUM4YQtls6wVMfOeo5zEu0w94hHsoe1guzXQ1YKfO/llgvozShBi+gTAtUtUkWR0hkwM59EJrYHGVMiCNA8ZV3KYnTCF6rb7jwithrMQNNz2sf8JTWkLoYSUEUjYuv2+UNYX/kV7KkZnVtUFnXs+dQ8SPdQwBV0dRBmqF7+aCdGynRmsqmw1pbMNtoA84+8nNs8J4g8NjRF3y1WxCyEwJfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATUqzNGRzjQO142Qvfv6ph6blGO5ahwog0aRbhCRv6A=;
 b=nyeDyy88SL3S0BEwFAiUgLbFRZ63JFrReFfJx51RJAM0kGo8dFel+2rXJX6QqopritKFHaRWn9PxdXxswyVg/ta2Y52mXymupdXr4f+nDZw4YftxBC/NoK/vGHXb352kVngOdb61S9Ku0Gz2nF7syWCTrj88Uj0orHjcstGIpZpCeik7S7iAbFDtFpLh+hqWuwG+ay4e6pJvNixeTniELyjNd1IMLoR/lC66sE1ClLP8zjR9F5lVFxSzbyXvjGCsodG1Rf72XjWP2dujhdHhZ0ZyHohAgghtSEerAIEOGJGsKgFm9M2qaeqeVEKXUvf3hfMAYPgojBR89joXDvTfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATUqzNGRzjQO142Qvfv6ph6blGO5ahwog0aRbhCRv6A=;
 b=Pzi5Lw1CvCbBsoHNmnXQFYETk5qhI6tYsA3pxZe/tQFROh5UT4pHRoj8SDVPN+v++yRMA7ZLh+wp9B192P/nT1SV+aL+N/Sp5y3KmqSCtLNDMwQiGpIyd86czUVUEq83Gl1bDAvF8I/x5NjNITAWpdAOhBtTyfRNcqZjxSDt8zQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:49:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:49:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/5] block: Support atomic writes limits for stacked devices
Date: Wed, 30 Oct 2024 09:49:09 +0000
Message-Id: <20241030094912.3960234-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241030094912.3960234-1-john.g.garry@oracle.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0049.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: f081622a-b285-4f08-3f77-08dcf8c8326d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LPU0oEZiNb4Ntstq4ETtnhGkvK5vv2bHBqmQcjE/rwGwOUdW/UpBX8BmCzOV?=
 =?us-ascii?Q?eR5Fhwot34PjivDTPG7rb1Dgzc/0RaYUU7KWk9cWfHDVMaJzMPtizIB6JVCZ?=
 =?us-ascii?Q?ghlkSgau/4HRLkOwkkm9hvWRbRJY6y4vay7VO77GIct/7+2pkYllXwZahL2w?=
 =?us-ascii?Q?C0HZ1LBDGJaAE7JT8CzqoaP879P1igTKCBmUcWHaaH9TMAs4vMYcKID268JZ?=
 =?us-ascii?Q?i80fvZUxZuR5lY/twYS4WAbpTa98h4qI6J8lkFMIat7mTlbTW0IxdgHpXSDi?=
 =?us-ascii?Q?KG9HlhwdtsMhDdpDZT5+acuVAxzumPlIAX/dzw5h6GBXH/os942QA0Yw3kk5?=
 =?us-ascii?Q?xrE8EVbhQBtl9Uh14MqyEFeNB8/p2PrM34QWUKYC1mUxSQ9zzoO5ZsGO5brL?=
 =?us-ascii?Q?0RSYxzbUeOvvvAJ4yb5/70NSLqHarSDnu7GHYdnPgUv+SLjZvdloF3vWq4UA?=
 =?us-ascii?Q?fhIMJv50GpT5EZ7IIV2RJQaEs4PuMa/VtU71vt/+T9DRfZcH9sonnlK2/FWw?=
 =?us-ascii?Q?C4icwZxnN8wuOudEroK9z8UX36VxUvZc7NM8aNPMWtEiFKilGUgEZMiLywtC?=
 =?us-ascii?Q?+6IMk4G0oiwrDm/b3VYS2KArz2qrY0UNptrfhLDPVuB7gRgYZfziit2Ab9Xw?=
 =?us-ascii?Q?0d2O7SHrMV1h+0cQwXm2d6W08o/L1UN6Lniyo0eE9DVE2XM76lqagLn2okzV?=
 =?us-ascii?Q?UglxBPMWlw2Q0HLofZS8BchCIDxcpUvb7cs7ODZl/1fLX6jJBGrnB4fszhLE?=
 =?us-ascii?Q?XXHj5oibzMq80ksfWXoHQPlZdRBcTqPEjOb10vw7lUeVuZd67ta4EDfNvcKO?=
 =?us-ascii?Q?76nMRVJGz9gUGulRJPcooqrhNX5DP0g4MmK9/6Vk4N+fdqLE4WHJNn2kBllg?=
 =?us-ascii?Q?q5TYnm/AuZ4YaVAQZvzlOUTiERWcnnBrvsXqh2znIUq+m3xI4pX83bDj9+XD?=
 =?us-ascii?Q?Q03Zu4X/YIqSR2xolmqvnz0YGEqMPHxcXULQ1CNZAKxTj/IGTr/lcm1mkm/9?=
 =?us-ascii?Q?CwWFLcHg/dse6sAG3i2ZvbKPhsvHd4xip58kDVNoYx6nE31frvaLWJSQeg+S?=
 =?us-ascii?Q?yNQBGm3x4sqCy7AtVr/gwlBD9OovGGv9/fveP+9Lf77WnnKwYJf87YCGhoNd?=
 =?us-ascii?Q?P7Axh0NlH4J48G+Cqw04Xg9513p3n9WWpR5VX+4uetq+SoooHCA1FPPsB1JE?=
 =?us-ascii?Q?eiEV84NIBxJH5CMDXOkaX3LWvuaOuFHTn5BxLgIAAynzkZ6rJGXUQkpJjSzx?=
 =?us-ascii?Q?nqDyEJQNzkVxC1m8AdxPXaOE7Xawsj8azCdNeynfRq/Qd+EErKVjF2ygwwKV?=
 =?us-ascii?Q?Rl5YisVfh0fMyVWCUv+tQhGC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zxgsTVEyhUDxxGpPAFNzQq5YbUT+qSScxDG20jrKp4FGITMPKcvzoJtacysA?=
 =?us-ascii?Q?2Zf6JMRGmdQRun9MNrQdK81xP359N/Ls+8W2xOQBE34t7e39XLp3oHEKNota?=
 =?us-ascii?Q?gKGkJuBugZePT9u6/RQj+yJcCxktA3rtMzbElFRlp713hmRN/P17xvLJotog?=
 =?us-ascii?Q?zl3KFD1cHmzDh0Jap4h+qHjm1xscwMOVN9RzfcPrxrc4OXip8YMIAVTHtw0D?=
 =?us-ascii?Q?4L+K2pEY5sgvKcTK1nBUWCgPaCUQprowqJbGeefqwvXm0Ca3CcPxkX3W9QyM?=
 =?us-ascii?Q?TjVhl7bNf4zMaTifJV+i1eq3L4nA8Qv7HwOdiTGRt/605c4kPCJJdHCOOdpC?=
 =?us-ascii?Q?0JaH/F07bmNbt0SxSKXTNkZzVvZq9asbl+/mvXuLbjNLQH4mCIT3iZbbp3Ck?=
 =?us-ascii?Q?8qb7j4fbbSg8RmFFfq1VvOrNbOoM4HcGINe2bm1eSxdE21UdLSTyu3icfzfQ?=
 =?us-ascii?Q?Y7zQ/GO1KU1/jNYYHjvHsACaPWHB1d9yKoItJxbn0Sz+qapoPZyB+Ho8Gmt9?=
 =?us-ascii?Q?Jwqm7UWdUwP9GSfBT1pk4SRmTuJB9TH4HgajOIfbwZr7/FOWZe9JqOBsp5TA?=
 =?us-ascii?Q?h6q5vTBEbYxS+cUYEpKHVvPcDezSGWXf36BOMGGEyw43/zsy2ndKWW+iACIK?=
 =?us-ascii?Q?A/eSwEh5lCyuLMdLr0VJuKNTcEB62pEEY+65e9/rA13DEY3F6abdPPD7Vgyw?=
 =?us-ascii?Q?fxs+cuYKKh7S+Wa8/YpmJlvFyQCoqK8Zy43nfghFLkhHwgmQhzYB93yD0YuZ?=
 =?us-ascii?Q?nQYSVBOlbfbLdeRG1z+XG4adTjb5TuWJMd7IMNCFIIJLo+zJAg131s3dCSCq?=
 =?us-ascii?Q?kophnW0CtC7pzyrYfHxWNC5lyEaUXbeJdIKDHLIqgsKdlsVEEgaoO2AdxzlZ?=
 =?us-ascii?Q?rg7mS4W0DXSZKAXAzp4MiglAdfeD6sX2V+MS/uoSM2gatxDETfRbPVRyKtle?=
 =?us-ascii?Q?Avud8avDRlEQfU2/63RCij95BouPQKEsQNaSSjNh22AcqhGohDa3lsmNWBFn?=
 =?us-ascii?Q?QjrJhS1b4hTTc/dXLXiOKjwU+YN1yzAbaxYPcx8ZLcd+QPE7kby716Rgp3DS?=
 =?us-ascii?Q?hEoxZNDre1ABHA8HrmNrYxtc5CSyVl2W2+sAPjuKDn9y6e+2IczqNJgmjeBX?=
 =?us-ascii?Q?lGVrWs21ruWfI9NTE9Q4B5XejIAt3GDIiIprIWJ0058eDhNsd1p6A859kqU2?=
 =?us-ascii?Q?OmlIIl2+agftznN+TBDlC23vcws2AbloN8gmnkg4LFLif2ITQGMIsnniGIgC?=
 =?us-ascii?Q?y6fo0eV/du7GYo00nzoZQDhWg62hBi1Jz286o/3fYmJs/N1aI9FnEwb0YsuQ?=
 =?us-ascii?Q?cUeKtY3xT2cZrp0BvaEMm/1czAdhFKLFMwTDU8zue2bM0CwKgtLGq2/apXQ2?=
 =?us-ascii?Q?Muuu2F3WVJJWAy30kp5QX8Mz6/YK64A4YzDNDKgUqaG/ys9Z/IiN2NfFidV4?=
 =?us-ascii?Q?WhUojDztxdgnLWohccaUg81YGrzNjzVnE0soO3U0zZK4TZ0Puw3sEm9gyeyh?=
 =?us-ascii?Q?HKzmh0OlQzVL0sOl3PNFJC19e8REUQZapkiyjAkDf4moj1krBbx96F6uhvjq?=
 =?us-ascii?Q?+FENv5jo+5qCp+vjaAK4iYMu5x8jF+hKN6Mj4jCRg3XUXkR54jgbtb1aVEin?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o5kMKObqikJxmJJEtTz7+OVLkqY+Xk/ogEsNeouefoyxwL/8+0OH96HTbdn5ESWMvOZh+/bJnwOkutsITjUbOlr8B6LtaJepqXOPjdz8NDUwxm7AxBzTwX0oeT3c21u/IXb6img1pHXtUShwatSK3drXNy0hgHhm8iq56OO2nqmyyzx9SpNJKH+ij9OidTGjc6hQV6vG37GHVodAvlho17SrUSprK9Wsk0LKT7tShx7PwtWn74IdO7ipyGGNaeUEfsYJA9cnp1VgiJ+yePGqTvu3/NPxD9iQqSMgCeQI3yiOYu+WgMat7du/eI1WQkoOcZi+6a2G3vpvFcZdGa0XAtmfMeD7NiMhhNfmUgeNYThW11wNiK90xaZluB0oyNUsH2RErjNBdU//WXjhC2Mwls/F3/VJ5sdTxJxjnG5HkorRgSI69bBcMLsM65FGm/IX7mOdCL2U4yqkzRsx5A4xC7MOJUhToub/o8IsnJ9IrSm0fExvY3te6EOuPM0nxChX6dFNaSM02YH/YwNQJPZrQPT3SN1KqyxwPlPbRHoLEsZFINAF7uE1iTkCpAtffFvdnuCW1qsXBHhhiXxcTp+fdjIjmDS7WX5zz7SWQJZs5TU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f081622a-b285-4f08-3f77-08dcf8c8326d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:49:50.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlqnbvyIKzaVFlttVR5qQqIEcYD4XXf4l9GeR2pgz2I7sBZKVwDbJ1XYfsbRZOwh8uxKUb03hBpNJdiMeIV2+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: yGaE37yuyipw5qlZeVyxNAyJwGlxyK0r
X-Proofpoint-ORIG-GUID: yGaE37yuyipw5qlZeVyxNAyJwGlxyK0r

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

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c   | 89 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  4 ++
 2 files changed, 93 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1642e65a6521..6a900ef86e5a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -496,6 +496,93 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 	return sectors;
 }
 
+static void blk_stack_atomic_writes_limits(struct queue_limits *t, struct queue_limits *b)
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
+		/* We're not going to support different boundary sizes.. yet */
+		if (t->atomic_write_hw_boundary != b->atomic_write_hw_boundary)
+			goto unsupported;
+
+		/* Can't support this */
+		if (t->atomic_write_hw_unit_min > b->atomic_write_hw_unit_max)
+			goto unsupported;
+
+		/* Or this */
+		if (t->atomic_write_hw_unit_max < b->atomic_write_hw_unit_min)
+			goto unsupported;
+
+		t->atomic_write_hw_max = min(t->atomic_write_hw_max,
+					b->atomic_write_hw_max);
+		t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
+						b->atomic_write_hw_unit_min);
+		t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+						b->atomic_write_hw_unit_max);
+		return;
+	}
+
+	/* Check first bottom device limits */
+	if (!b->atomic_write_hw_boundary)
+		goto check_unit;
+	/*
+	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
+	 * devices store chunk sectors in t->io_min.
+	 */
+	if (b->atomic_write_hw_boundary > t->io_min &&
+	    b->atomic_write_hw_boundary % t->io_min)
+		goto unsupported;
+	else if (t->io_min > b->atomic_write_hw_boundary &&
+		 t->io_min % b->atomic_write_hw_boundary)
+		goto unsupported;
+
+	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
+
+check_unit:
+	if (t->io_min <= SECTOR_SIZE) {
+		/* No chunk sectors, so use bottom device values directly */
+		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+		t->atomic_write_hw_max = b->atomic_write_hw_max;
+		return;
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
@@ -656,6 +743,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+	blk_stack_atomic_writes_limits(t, b);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d0a52ed05e60..bcd78634f6f2 100644
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

