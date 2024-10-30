Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E486F1E25E2;
	Wed, 30 Oct 2024 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281809; cv=fail; b=oGNyy8Jj1imQv2zWsMVA3wfqDkebkDAqKvpGT7ou1a6EtMoGzrJXZUlH8rg4mCCKfHypNBzDQOeAIb/96QJuq2r2E38x/mqoSIVqHfvBKedtWFY3sUJwYvSxxq48RwJx20IGCzn6yRGKpa5KwMmYXvbSfGoG7IqqFbIckz4JTIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281809; c=relaxed/simple;
	bh=W/b94HVhJOkGYrdziLX2ZZXTJNhWhDRGNdi001c1wU0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JmYYlipBOfGGRNc3PmtSQUOOWAZnWoeT1B2xHzZwrpDckg6YYwhws/6BA5Ap9aNOZd8AsGDag9ojaZmYg8gh+kn3LJi74hDTiK8ROppSUlHjzIIKqB9Oyxb8lvaLPLKrc+XhIfVudqxh1JMdOjpwD2IviY6vOFys0OclhqEp9g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X290zP1z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aX/q+W/0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X290zP1z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aX/q+W/0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fd80021360;
	Wed, 30 Oct 2024 09:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=jO2+YpPOSGk8cpJ2
	F/530h9lWMIvUBOtsMyDGw80gSY=; b=X290zP1z2ectQKfHcrXWiBVWiAw2fEL3
	MKlrY1srWsjUjPGQHjfKEyScecANWwt23D8WwV5VJfa/2NUM99qRYbAXQ/avYIX3
	VWnLuQVzUWVNTIsmQUCRHqfnvE9wrCfd3FxPjlROYne0aRHC+1BYlO1TJVX/tca7
	tiz9DsjQwXoXWQbPCR+tT9TLu2CQmC5CVBbye6TH0tUNfk7dKRGYa9a4+i5AUAlZ
	tu/nFcM4WYzJTxGDQUcP4xvsMYQ8IFGdqPwitkB8OTx9UWj7aI+J/ZkhyMSWkctR
	3aSbnagJXX632aiecZF9+rJshbHPAkEI2Qt8V29TlUst1XgHJPhw3w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdqfh32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U8WYmO008531;
	Wed, 30 Oct 2024 09:49:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hneavcbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ulp6W6YTSP5sBrxOe6sjKoxSreojqutboX4sY6fmbNb59yNaX8yevMCr9Ao65ZCHNIbqp7DX4GgWaifm48oViMcabqFvLjbWtThvl4KnS6jikmwLK7Bjh8/UZUNniKjdpWaM3oJ59lVcvJ7qCTZdcDFaWt9IDs1FRIU1hC+asyvv7hW1pHjtgxqw0XBl6DRGXUDcffFuRUSPhNhwSE5WTgbayY5NplXO0OQg3NaYmmxJCjPqgelKzVYHmZoE4q4nh/PsW7qCBcpLOOmFKY6bXKXzzmaQYWIdUkH7XufQaRYjxDd3ZvsF/GIyuUXp/b/ox4xf7bMbyGTZDwwpCVOpcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jO2+YpPOSGk8cpJ2F/530h9lWMIvUBOtsMyDGw80gSY=;
 b=OSbQMp7SX7oAjKtlhpVwmNqIajZIoArO+Rilk8jlrRQOjE/WdaeyHExZe/l917vXEx4FrqG202n0BGYvRVg2a2bTW9RzlyauX21ks4hHDQQ3rVoFWJ4l2vBfjozL3IQkGkH6dqJgIeA4cDo57WLu5HS9golVEu9yC/8Ng6P4lOqTFwKtWrb3SKIXzXR6A/wh+ZdTVthLL790Zgb/musY99Alq2vyBlovdNCWlQ5jvotDyAeJ/eUC3+baAagHeg8VgPlZuLsXmPM82/UiphAFJhXt+2GgsQLMx5VF1i6y0+LI4J/kiFaiP2eM02ifKnVX0bF/LaUfgQPMmm2pGc0pAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jO2+YpPOSGk8cpJ2F/530h9lWMIvUBOtsMyDGw80gSY=;
 b=aX/q+W/00YX0xm7UQNJcA5RODGdzo75/qlYE+H70DhStsM+lBNMldp3AROxsJ9FGShaNlQzOwYIi0FuBhzdTdDCWAgoUpgKF3gO5e/rGvUgm9QxKjNjmF4HVdGiCrod2vSA/oxwTb4hVcwSK1XGvQsVrKUTJjqh8uKzH/XznR50=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:49:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:49:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/5] RAID 0/1/10 atomic write support
Date: Wed, 30 Oct 2024 09:49:07 +0000
Message-Id: <20241030094912.3960234-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0070.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: d7531d9f-0a03-490a-f32d-08dcf8c82df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bFmNxPee2XtgiPYdbArIP84rwHm+9Bet+YA1ejrF8u90u01+LCoO4IE2dJEY?=
 =?us-ascii?Q?faItDOuix6HS0ChYAfDa3aXB4B0Quoh/yCLEqdd3/vAXwGNQPa7dvzM7QDoY?=
 =?us-ascii?Q?fOLaUgmJCIR16/fmMuPK7E5Q2P7riL8P+krlpYYF80LK9MeCrHUSBwFUKWEh?=
 =?us-ascii?Q?SjPtbkcirCTGnrIt+zYkToJZ43kxYThkEo+9T1C5lZBC5JHZ6LcUHDiuP0NF?=
 =?us-ascii?Q?2cWkVnYQ0bPVzDYQZ/NZK69qoAYoodOcWbOIMXPdZLBBZuLx/Iu0tUn3BI0K?=
 =?us-ascii?Q?oUT63SbzpsyJR+9Zud5SmSNd0A+vIizFOMN3lwzG/DDmnNq7BlpRHoFtsDCt?=
 =?us-ascii?Q?1CLIjI1CEwzDsMnW3mVEpwHoLmsU8yP72OAP7soXkuthdCsj99s5hPOVXwJw?=
 =?us-ascii?Q?hX0mIA6lYhaAqvu8LfYBHqwIeW/W4w1pKOUbqOXbrDaLUdYPn7G1pfYaAydA?=
 =?us-ascii?Q?Yavhku5pnSzEYloR6Eh5EAlQ+kP1zGFv0q06ZppY9M4QG4xwTauhzvZm/Ucy?=
 =?us-ascii?Q?y5g86hS4ckzNaR6/B9Y9VDwW59wzU7KwnTWPFpXz1Adcgm6SAiN81MN39xDj?=
 =?us-ascii?Q?47+dKFsd4JdTvYxuD3H9+aX4urOQ5RCi8hu5xL9fBYhMeHsFSlldYBgifoPH?=
 =?us-ascii?Q?FIDDkNXTHWeuu0wZlXKptg96QTC8rLc3F05XSSV/1xVmATQWPHNpTh72Il5p?=
 =?us-ascii?Q?S4zMv+AcKKmpeazxYAlbkSr5w1d8XD2+hersA4CKH9mFsj7cwGT7369Njr/a?=
 =?us-ascii?Q?zpLPJ5a4sGu3sLewScf6M9lgAPHI65LuYWlvteUSUZ1RClLn+j7vv0myW8lR?=
 =?us-ascii?Q?PSq5YkIXRMnzcT3Q2MFRmS3ltoXuhNJjplBk7++mDsHG/Th/kJ6g1ngfiL+a?=
 =?us-ascii?Q?e+Cjpo2KIWPjrnq9lVse3qYmqWobqfNGp9Bsbb6GObqWTrFmBmkBs30/UUPX?=
 =?us-ascii?Q?HarWg8cGgpJz38UM7yRfFOBNTSxPRcVzJZZ3hwDPqVSl7y1rbsWYH8OUvvxE?=
 =?us-ascii?Q?Lfjr1oRCec88U3kNveuYnJLOlkNDDShKy7Wr7+uxjFAJLxkz8YHQs7hWaJ7Y?=
 =?us-ascii?Q?0z/kjcXqpXx+r+hZpXtPizucPXPjRwUhik/Vn7DWWTUuayaIMc7vcYFVfrwH?=
 =?us-ascii?Q?oJI61hzJFQhtPDlv7FM6pTyj/D/AEXy2XnD78QkAjgLmNY5G1TYj2b3k1S2l?=
 =?us-ascii?Q?MQO6aRhJn2Y/OXV+vPg5iWeqU2lBktUGeKOsYY/83v64MXFjFi0e6lrMEacL?=
 =?us-ascii?Q?bw+krSNOLsFllgjQ+LVs2ApQvlFgw8o/QF/8VyRfDsRJ8p/TG2wGGTWZy0wb?=
 =?us-ascii?Q?EJkwL88+aRD+1xdvUtRmQwtu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?519jg1lsfAEYPagNKq34Vhca3RB1IAU0/6LR8cYRFXi/wgyIF+8IV2J+JNzB?=
 =?us-ascii?Q?pg/D97qh1VSzP3xby5G9ZhxErq+IP/99tOIVEpAv2oujUp9FjwhO3B1sw7eJ?=
 =?us-ascii?Q?PdBjy8rYRuzB0zE+iQa05041QAHW4lJ3XQxR/4G4vj32hklXZI6Xw99iFkU/?=
 =?us-ascii?Q?V5wiykp/kQoLoTyqxiPBoN09iMu2nputEXo3Te27KFC9Jvuj1hSW61PfSDxK?=
 =?us-ascii?Q?F0gZA8UEcDc4X4LfIYzA3ROTcMHdTXtCR+ZFR8VsWItOgR83ZJvuvTGbQ54y?=
 =?us-ascii?Q?mCGUbC0flXsh8KkSgPcyluqzhRivcQ1AkdDrH6jyiFPHY5mtUpw+IqGYqHVC?=
 =?us-ascii?Q?Epltf5nNC4WUZ5I6sTNuj2kVKbbwQErJiuVy0wYbH+7IsVCxaTFPx6M53J0r?=
 =?us-ascii?Q?PBbouPx8ZqhWjekwLJkUMr3IPLMoLe3umcPsLcW3FDcbOepM3bJGmM0Ec2zV?=
 =?us-ascii?Q?tnQn8bMzPQyoMJo1PivjllT+vIFlqwBXrkUCADEJ5aYZSP7jIQ0q6dJlj5z0?=
 =?us-ascii?Q?01/siYu72fGWXOIvYr3b7sm/Vj/CdpStGQPHJRIsjo/vaA9snCcek7rq4/yf?=
 =?us-ascii?Q?tSYAeKRS9m2i9hMTaZ+oQryXnRKUYHXkljRfAaqLbY32lXkGbF0jWFpv5Yur?=
 =?us-ascii?Q?X+f4vu6ttCCjMyPfCiSN75R5lLHp8o+EaQFgf35lMxlG8iGyCOaRFnmJ1cjP?=
 =?us-ascii?Q?KUvsZDyH2KVtURph84lalQPzney49PXT33mwn0vcMaoAmEzmAfNqdW+Wplz3?=
 =?us-ascii?Q?2jUpY/pdMPInb6Bah2+pU91nIBdWyv+AgQq2x3BvLM9VAU3oCWu3V6yiLFIn?=
 =?us-ascii?Q?qObsNAojkLyZinAh+m5GoCh8muObwGqI+99AKo/T0JwWAbnMFgt213hkezjW?=
 =?us-ascii?Q?iFU8f4xsHeXat69OLxQ73nngbokfyzlaOiRCTfvhqNzyBS+H/HaWJa29WGwc?=
 =?us-ascii?Q?IjSCeHxLAy2qym6F5T7JZh6NgrEIRggSOPmu+V9nXx41uIQClVerjxyYCyyu?=
 =?us-ascii?Q?0X9mLo7ctYhKQqik1evMCLvuW7WOghQO1t68EhhJq0vhEVBWJeV/CFwoxDAE?=
 =?us-ascii?Q?isaQYDeIyg9NdFVg4Gz/20LJjHIsGypJeqJqvkxdl8E0+Xaqxbb95RRicaV1?=
 =?us-ascii?Q?T9w639ypGKJ/1mEqlsmve73pwp7lsr2vgZhOfLVbfx8X9h/L+GkiY6LEhWWC?=
 =?us-ascii?Q?KQYYr/Dn29O6tQSA533iPW9fkWC8AymBX+ruuz7Qf3IfWKONsLCT+O517hF8?=
 =?us-ascii?Q?e8iKV+dWcBm7H2/w7ssc2G3ZlzQsaTp8cLw+/PJoT4aSA8H7GjxUCKFP+g+g?=
 =?us-ascii?Q?hJe0jGJmfXBs3iZznPFiAkLPRb4hCpYwEJ3SekqRojBnZEE4S85/+IimPYHu?=
 =?us-ascii?Q?nV4WXmaOyBt0eij+8aLQIAKrbNtRhnuuG7nCNdR//kndHUxMerXxKLCKHjnS?=
 =?us-ascii?Q?vYeRswPmIyoG0ki0zAiDK3NXbXRjNU5ERiYO2q9j9opyLH5xmN7BXa+3Vtqh?=
 =?us-ascii?Q?xOHp6UpF2v64qwE3FPcZVvMJMizcyMTKypCWccJPiYUW4IjhwgGoCk53xbIw?=
 =?us-ascii?Q?lDjsu+ug2Hp6Ys4WH3Im9R6XkWW9X4s+AUTUwI8Wb7583pmRv39D9RrejnVq?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4frDVCq6ZIVymBtQl0Yg/u1sgYgFjrpbeLQEuMPjDThcsQOKhg8fEKsuJH2ArU+qol6nLIJFdxefCot262YGVAToZxuHmekilP9I6SkHrVOphbaxs/tUG5jxno11B1SVkMj8g5bPFzxoVicbI2q/OoZnfPw9oa56TPFOng9DSnqBvj4Mo24Vg+KAvoay68UcpEwuQUYsiV86hY4AxkYRYaYPbOyrpQkHEo3NHrCaf8P10lrdkKgvDXe1rh9vHo5GM4mMIP7x0MRlMfXEL26lz7hxsJxtF6fdVB21EzNkuvOamCb6HKL6/TRPJmMCRUSiPupXSVoBKvDPt5SiuNzrLO0w9ta19LMvmfCUhrCCZQES9nyBf6peOhoBu9SvRBk1TmsU2Lkhb7WS/+idW4XdCfai8b1gbnkLTpJVKD8r2V9FIVmLuTR2IZXyyj8PE/RWjl1MORvBD42ygTxokVlq/WrQqQoSS/ZBaIgFeVWqNMoJxutheqLGNS2TrAw8qezzCr/WyeWipu8FClYcho4zRzbeoAY2gnQKLbs8lRvClZe0OEU3lNMcasTYZTYU/HXT7nLvAUzaMizo4bc8Qn2DnB2jGHKKk7Z21f3r5Ep1ODs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7531d9f-0a03-490a-f32d-08dcf8c82df5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:49:42.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1POiaHErd9aEk6CNs1FvTIzOb5n6VlrTHyz97+DH/fmgx5oKxOIDmfqTNn3st8js79eKfQaN3EVua+DXgB8miQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: DwzvBEG3wfCdt--x0aYM_hY0tKnuIStk
X-Proofpoint-ORIG-GUID: DwzvBEG3wfCdt--x0aYM_hY0tKnuIStk

This series introduces atomic write support for software RAID 0/1/10.

The main changes are to ensure that we can calculate the stacked device
request_queue limits appropriately for atomic writes. Fundamentally, if
some bottom does not support atomic writes, then atomic writes are not
supported for the top device. Furthermore, the atomic writes limits are
the lowest common supported limits from all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES_STACKED is introduced to enable atomic writes
for stacked devices selectively. This ensures that we can analyze and test
atomic writes support per individual md/dm personality (prior to
enabling).

Based on bio_split() rework at https://lore.kernel.org/linux-block/20241028152730.3377030-1-john.g.garry@oracle.com/

Differences to RFC:
https://lore.kernel.org/linux-block/20240903150748.2179966-1-john.g.garry@oracle.com/
- Add support for RAID 1/10
- Add sanity checks for atomic write limits
- Use BLK_FEAT_ATOMIC_WRITES_STACKED, rather than BLK_FEAT_ATOMIC_WRITES
- Drop patch issue of truncating atomic writes
 - will send separately

John Garry (5):
  block: Add extra checks in blk_validate_atomic_write_limits()
  block: Support atomic writes limits for stacked devices
  md/raid0: Atomic write support
  md/raid1: Atomic write support
  md/raid10: Atomic write support

 block/blk-settings.c   | 106 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c     |   1 +
 drivers/md/raid1.c     |   8 ++++
 drivers/md/raid10.c    |   8 ++++
 include/linux/blkdev.h |   4 ++
 5 files changed, 127 insertions(+)

-- 
2.31.1

