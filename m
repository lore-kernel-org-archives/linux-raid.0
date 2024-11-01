Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227019DF53;
	Fri,  1 Nov 2024 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472711; cv=fail; b=QGNrc1anpEBcH4JZlyDGl/adeea72oLKcojysOAAXpu2RbgsW34mEIFKuiwt78XKfvAUdR33B07ZdqX87n7AyPBrGxwUsniG9T3xnaH6D1mQgfUjEBAOaRY7b3GVePEX5GqcjAboShtzUsRyf64r1IR76F8pnEihAAfGPGPuu3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472711; c=relaxed/simple;
	bh=x01FiqGtm5MCUVAiQu6Bcjp9oWzXh9FeJ2OAdsiUv54=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=V6rV2rpnWkWpVzkysjkfm2GWpoxBXd8sbnNIXa/HoEaqhvmckFc+5Dc2zM9pKdya+F1zIYAD9kxk9wSpXsaG9hyhunMiYlwjdTyugjvgFzCOjF2DOZLAL5NBP1hBoxISGN7yGJuAEhAY18ilUwsgGSvCcDtvNqXWldhdViT94rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JwzNihrY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G+XdwRY7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JwzNihrY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G+XdwRY7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1Ein5x026700;
	Fri, 1 Nov 2024 14:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=fphs1Zrz0qAtL9Ks
	ZgTu4G90VzxrjHDP2crdYDrHf2M=; b=JwzNihrY5ZuWG3JR54Mua7j82BlgHQDL
	TG0cxCsodU21RizGUhmqJisKkh8MkxGPdKtYCduDj8urqMAKmXYN9Yyn+tTCvat6
	Jkr1W3iHSaTFq0mOxHN7vxEekfUIrizriigOyZr/51kMF02eAzAOMuU52Zd0COS6
	xrBgkYR5stNiGJDQRlpmoP1DMlSBoGxRQxRH2XgRWkGmeiC7tAsIdZmzt/NWsb9f
	j4mtJwKozCbNyjJJnzWGAIXnCAMxecbGweLI0leHnaOJzixbNwPcu4miXKMjZ6p8
	gMBm+N10glxjXq/rnKIl1ELM6MUJjQba/yng45Da1jONSQ9G1vsS9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc94drh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1DmUa7008486;
	Fri, 1 Nov 2024 14:46:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnedjrk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+W9W+3kEWpca0TFr8Iz32kLYr8UoF8HojSNFSXcRM2vfkKDkuIkGO6LReWCsFrBdT4PkVOg4EbaRKCaDhFr/I6v6kPPT5NzW24b3dJeuOJQM7tWXIxEOnsfAPQ7Kp3S+uiiaDAg5QL+g7dKgMenZ69bQ7+FrbusTyXMY3shjBHO+Jt1CqxT01q++zc6c0gslYIUE+sZTwZTQ99qoJtPW/lVJd79Rg+K6zwlDMXpbiOmP7JNh/6iBW50ikEZvHRidh538941yWz46rsNeaL7vzNZICgeMetSjz/EPgtegeYWciyfNQfdhgWBEfSXHEXKYsXKAmXP9kb7Asrf1nmuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fphs1Zrz0qAtL9KsZgTu4G90VzxrjHDP2crdYDrHf2M=;
 b=oyY2LK2cT2BCOEU8exF/ch9se05lAjZEvUJ7cVzmb3qQwyLe21tjePlUISKI2XL1uV2GXJTO445CKncOI5rTkhJp0rcNsdeKwtY/cOsv+04pVXycni0dY2i6sLcaZpYdTvG9l+u7PesTHOOg5p8JvjfHN2xTp1l7ccCzaVnrTvoRDdM7iNuITi27rWDwq72aM2G3VvrDO0RFLs7cm8Mu0rcvONk8JrKxhNKhv8J7KpqZr7l36ozKwATagSRRI8Qk/8pXeSrEKgUmgjvHQS/8K8dinGOGfiJct70n/JPOfvbULjuUkJg4oh8YLeb7Y1lCHY6FStsgX3l7u2Ly75Oa7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fphs1Zrz0qAtL9KsZgTu4G90VzxrjHDP2crdYDrHf2M=;
 b=G+XdwRY7NTZQTARaOWi7i3lktCaKkAMDAza3ZZVTYErkaAWF4Ge/q22R2zVxWo19FCRWkt9BP8b/A9kkaxpNNwTpbXWwFxr2B4FReaUlKoOXvQG8EbpTBSodpke7s/7bCo9DV8W/dEqR0F4T7Cjyfw3/iiif9JkNmp4ZF+Hmcrw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/5] RAID 0/1/10 atomic write support
Date: Fri,  1 Nov 2024 14:46:11 +0000
Message-Id: <20241101144616.497602-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 5356a621-cf20-4676-9d41-08dcfa83f958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CAo071fxgIumaMCUaMvWfRS5Rhp2u3tdSOwJ7icT/63m8xluf3fqSZT1B5R+?=
 =?us-ascii?Q?pDuVfurweapYz0fxyjPa6pdOFP/OydHqa5DSy9QIhQ3eElUUuoKaujgwpMTe?=
 =?us-ascii?Q?ybML85XBZ4LcKvh2WvHS2BkXgqh2m0Cm7pVXkSuvykKrV+sKZlHFdc/VXVT1?=
 =?us-ascii?Q?7t1KE7a1Zf9CsEAf+QNhVXM3cphS7c7UJb5HBfeNvnRrW0Z662dqF36/nKHW?=
 =?us-ascii?Q?GsizAdp7myzM0jFiZOS9xV39F3v40uLsmRqjMcoBLEnfFXyUnHmn2JaMlb+e?=
 =?us-ascii?Q?kO1/bekoeDSbqTC6KJ+2GAogH49PDhMCbRT7KPlRyp5pysArj2C3cebDEO0D?=
 =?us-ascii?Q?WUrQNaiG528PitRvHJKNH3iVHiIpLPThpXCx7jVJgE82VjeT0efuOU0mTVVK?=
 =?us-ascii?Q?ftzQ+HwrsUZRWbt7xkfhZo747TN71Bc8ZgXXp/Ae6kbxaKmQeXRBFCwklghY?=
 =?us-ascii?Q?z3GC/F1CqkdNase4zufPt5/mPXRasg+Czf8PnAlAjMDasgLr8h4dwlByg/Vj?=
 =?us-ascii?Q?O9acMC3LKIh49BT2VLA+wkrT7q3Se4MAx+Sh7bJ6kmypzPgxJhc/oLDrRXdd?=
 =?us-ascii?Q?CkOXaFFMG2MhZLl9gLqf+FXXwb8keAlovfe02aAGhig3TL75s0p0+HMJmwFm?=
 =?us-ascii?Q?aOT3L9RGPXEnEEwzoJrOzSt3YK31mAki/9qYtKMnJ8Tps89ExmynJXKW+vli?=
 =?us-ascii?Q?62P8n3yoGiVFpNzvitaIoohmeu2KJ4jdZh58KJfqDmeq+qqp24YSO99ot7D5?=
 =?us-ascii?Q?GgCvGgwfCXHc5ZdgJWjy7FCEZFMhuI206YZEVRFbpRLv59gSiAwNZrlzB5Fk?=
 =?us-ascii?Q?mC85Nh9uTtVNZj/iNNqGR3ftAc/Ltp7t+w9vCAKeZdTopi9AWdPkYg2fHmK9?=
 =?us-ascii?Q?wcHe1MZ+EWsHyiLMLbrsH1w/7GS+uWe48z7NQxyoJLlsSco093b9c/khstYk?=
 =?us-ascii?Q?ceR2iPkqYQYLya0vuXvBkiexntjsl9clqFKpurzaa8vcmJ6Qi6O+DzyhPP59?=
 =?us-ascii?Q?LspaNCruPjc1kFoBiJUbve6rzxoeh4DwiRoy2rxy3OPmmK4anQP3O+kNGOsD?=
 =?us-ascii?Q?n+8wxXsdnMEeqtyFUUWVz9DtMlQ7Dm8fd+wUx1kn1BO7rzXYnqIdVZOQEI/o?=
 =?us-ascii?Q?5I7Bqa0VLHTPCkclH8ydtV2L4uwvcy1yfhPWv/Qk+l6oPCk9228NZMGjWqcP?=
 =?us-ascii?Q?q1t49tIcwwHgfeni5r5u2vAopfGtv+8kyS5hq+9QLL7VnzAGi/5Yh0OQyxSx?=
 =?us-ascii?Q?zoj6HVDQQ/8o27ZPAgqSdPiDKBr5ucf+iq8+VxKXHCmmr/mgbzq99I6JI2XA?=
 =?us-ascii?Q?3MESaF0CVdzdf9XL83Gs79ad?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PG6Wsk/BEROCtfn9KR6Bd05qVU5JsK0wgTFYrKgo9QF2TDiFWBQt7xhuOFxN?=
 =?us-ascii?Q?prXE1siodbzME4/f8aF0G1j+o2wzDp8Sr2U4EPbInZ1wO2Z5nGHYzxiK9DUA?=
 =?us-ascii?Q?xJilTFcCo+HUj/uO0IsH+kX1zEqZLS6334Rm1tUrbfDRHIXcG3O5noYsQME/?=
 =?us-ascii?Q?JnWviYervpMi6cDzCxHttIkmwYgqrv3oq8qvypH8jXi9Rs2M/UAPcVzyAGD7?=
 =?us-ascii?Q?mZzIvs0sUyT/kb7vfgXgQzSGJwNnxpSZYkJzUIr8TP32jdf03szA8AxCt5Iq?=
 =?us-ascii?Q?TB8iVZHVsZgSkvNbq2yRphHFM+vbCtsPV3fXo9WEy9hayBeiRuy79wOIuotD?=
 =?us-ascii?Q?ILm3Ce9uLZ8OpvG5K63321iv+bJGPwS1L+WB+lEBiUVpJq7k9Uh/b52vtZ97?=
 =?us-ascii?Q?tSokQAx/eWPXqs6nvalodB6rKoZeyyfHoBiFzE4xNLCtGwdskwilPq+oWxzW?=
 =?us-ascii?Q?mkqBnnSBhxMt99mdlGEvtWIeN8pHjgSxfRF0eEo5EE+QlRcTFOr+DsTUrq09?=
 =?us-ascii?Q?rx5S01udbSPc83A0u5gF5kFYBkpVpLibSmbfyw3cpLThSDSUP444uhJypOWK?=
 =?us-ascii?Q?vqjnwmnUv1N8e7EMcssI0U6jl28q8eqPkp/4k4B4L1lbQ2F/1wkKovpNPPcR?=
 =?us-ascii?Q?QoiLX/OA4K7ikQsxUSTA3+3zHe4eT9Y3hy9OPYMSb+Drr51x7xeSTZ8gSfS7?=
 =?us-ascii?Q?A1DLRKwEQk3B1KYhRv2eV0mgCm5i/xuRO/ZyhrKuLjBbf5p8bxGD2mC5h1+n?=
 =?us-ascii?Q?zaro3chIbaKo3Wa/KLLPl6zBSzf08B1v/df8vB69kwWESToNKVn/8WY6YiKH?=
 =?us-ascii?Q?JgDPLvrdr1p/yCOBOvtDwPJ4PBWBZ8Rok7g6cPSd9L8H8QooO9F0MfpEYK4c?=
 =?us-ascii?Q?eS8tKOItYLPSDVUBkfkHBCEQ+fKP8TS0OiEi4UVBEmDiCtNTmblQx7sOAjZ+?=
 =?us-ascii?Q?FoCrsDmhO2Ju9TNxjVEe/q2eH/9xO48K4Tu5VBzKHHSHSVwT9lAAkulHBc/u?=
 =?us-ascii?Q?PjW6loT9ARdMzekm1U5pl/jf8rioHYiB7/ZtPaSjrK7r7ml+YaJ87YTHQ4Sl?=
 =?us-ascii?Q?UyGZ8phvnz3ad3IIAwb7prZQ7jcyaSkyB/mYmF+NLRakkU7XL/3BQXQj+qwM?=
 =?us-ascii?Q?Gt+UNqaSyIe0xOesfAu1PmY9xIezadYwypXZcmEMagmUYUKPNVD58Vw+/Oc1?=
 =?us-ascii?Q?3l/96L+8M86Dq1a4D2TawCaXGnj5aaCMv9aQcDqngfpm9dDnAH/wXJ8sN/0r?=
 =?us-ascii?Q?IylJi6ikqeUz6ILAu4Qas/qAXVBwhkSk3QjSAOiq/k/aCXZojQighUTYytKg?=
 =?us-ascii?Q?kL9MHTIE6GhzpmTac67xVnbVT+7KfLdyUz2ZD1LpSO/fPROYXlAetB1dY8ok?=
 =?us-ascii?Q?i5p87RP/7MOXRQikpeLxJNoD6tkc3KGmMP4C50YUqOnk9Lmyxq5lo5O8El0t?=
 =?us-ascii?Q?jfH5cSz2Pa+CxcM6o1Ahp/FU3NvP7IUamgH1T2Hey3cdHxCbTYDThY32AgY1?=
 =?us-ascii?Q?JCUP5jpk9ob0VuaeSjGmCAal3KTjZjSnavNvTpaG2p/KPfTS1JG0yF/Vg4XX?=
 =?us-ascii?Q?3G5NpANjkJS5YW3Wy7u9g2eNICYZNdiGPHy3qNQZp2a3nAbRWltgrpVTImwx?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QnUq9oieNVGaHsMMSA9ez3d7nn4jzH0oDdI+anTYsR01HYxSXnKILvfk89kHimMpjEviJ4vW36s/6MULGoq3Lghk7dIYd5lCUEqK99dYqCYct7yfyAQE02l/9Khar1aUUrSvn03v6sXuSxNpB0luJw8GqMhmjhWnb3PaIVZ+rI9V8F4xVBV/ucXhyJ6VoQ4ie9SPTOU0vxkeBahXaPD3CtMAByy5yGkwuBV4yEzfcX6Iifp1FOv5bSzI/XHyI/daIRKmGdVd58Wux76YtvLr6/gLGAQDRyzNHSMyPNv9KybqWx6S/m6eqR7mnIQIeMabELk+u2aUhzmKXmAXjmLx+8WNKQVQieyn3UIevUJRoOewggrriZBExT7v8/CTUlwyDe5ZwzXgZZjQR5VQT73yCas5dN/WSVfsfy7SvcfRuVpKZu5AVLnWyvDWEmEtIbfVHfb6TK/xPbR1x33oB0EdsRoOn/97WowhOanvk9S86bqbNaeAspnYoZnSeO7fX9CidPSLrvbevSD8wHQciOijTGT6TN+RtDMUMbpO03I0HAGvH9FogQGTrN9AR8vHcCla+PJyJn41E1yT0HOZAGbGbdYYzglmEPXiwQ1gGcSpZyM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5356a621-cf20-4676-9d41-08dcfa83f958
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:31.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/NGNT0wmCWPCNDoV7fZOnqT6zQgnT37HMvFKEUkrSfuig/EaVQGKsxAh1BaKZq9mM0UqXceQyqJ2UKHOhMjDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-GUID: wBFnNdkmkK0lq5pjoKtKHZx4JFVg4U6O
X-Proofpoint-ORIG-GUID: wBFnNdkmkK0lq5pjoKtKHZx4JFVg4U6O

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

Based on bio_split() rework at
https://lore.kernel.org/linux-block/20241031095918.99964-1-john.g.garry@oracle.com/T/#m7bed4a956a439ac4a9fa72f0bc41d1b08ca047c6

Differences to v2:
- Refactor blk_stack_atomic_writes_limits() (Christoph)
- Relocate RAID 1/10 BB check (Kaui)
- Add RB tag from Christoph (Thanks!)
- Set REQ_ATOMIC for RAID 1/10

Differences to RFC:
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

 block/blk-settings.c   | 132 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c     |   1 +
 drivers/md/raid1.c     |  14 ++++-
 drivers/md/raid10.c    |  14 ++++-
 include/linux/blkdev.h |   4 ++
 5 files changed, 161 insertions(+), 4 deletions(-)

-- 
2.31.1

