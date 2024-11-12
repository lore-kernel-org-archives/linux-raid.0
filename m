Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C456A1FA82E;
	Tue, 12 Nov 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415474; cv=fail; b=Y9LcO43jmBoxbciLDHr1oGIuEYlyuy8jqybUnhvLuBPJHIVgRh8EECywMKijleX4kNfVFLGLFyn5NxJ/u74nWRqSnkjFqMho67C/wZGuuAUZrJ9NF5MWcz8tp5szUmlPacGJ+B2dgBN4X1S0ohTVtc5P65Fa594qVxErIMDpNJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415474; c=relaxed/simple;
	bh=l8jWHfcLWmfiyOix9ULPk9fyb0xYOjtbPQAshuwY22E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o3f3WB3rQNCGfBR/BBd+IPkyeHDTPb17zVnEGOLwT1mr2duOFSmoAqeusu3/bWrKCfW9mhLy2E7adwOhgzspU+IyyMG1r2fwqStW3NWmWxe8FMeleZfCdx3cY2esO4fHW+6bEUt0/Lj7rSIPMoCvpZoU7qFNpmSCi1Qeun2GcKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f7JYi5Gf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A5ftvaHJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f7JYi5Gf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A5ftvaHJ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfiLH017452;
	Tue, 12 Nov 2024 12:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=; b=
	f7JYi5Gfn79OGOO1N0ofgbe/iAjnSfB0VUS5vy9doSQXKJrTZHPZ8/keUOXMBswq
	EbCOYGNWDnxb5jWMKEUrsZ2Z0owCegLp9IA0zhLN/liXoASAFD04d83nNxKCMg1S
	XcjiKpV4oocaxblsten30IZ428sPzyrxEBUdwA1PgKI3uQ989kJCMhQ97xrEEu9h
	gtuDmfJ0xDAyVZgVknAXswpgY6z6RDmKRP7swbqdjsTrmBclCfem983ihNWKJ8pN
	4sMh24fMdbUdVzxWze05QGH8NqhbHo0Cnqg41dXOy5rJWvczOXXvFdD/yIXF+sMd
	QZSl677f1gWjgt4nhffFmw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbc8fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCX4Ga005677;
	Tue, 12 Nov 2024 12:43:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6825sj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NEO5N+tJ+nctnVlK+7oypYV2h6qcaiBY2dDiBeWOWnDrAzpSMPFCqZ7BVIM6on+6UtU79hc1tLA87eRNTA3g+tDuQSHrFnnU+tS0vdcx8+YBGdN0xmyOUv0stytUY8pszDCjyCqd+dLyNgA23vkfzUPLFaUF5cn731c8oMqv8WqVMOa2akGzwkZZHigCkB4GogxMdty8SlFB44AGbdI5WuquMpVjChvmXxCB17cxHISMiuTeyQwSibFWb4cDkZEn7gCYAJKs1c0mnyVeAPVaNBOYsxMuAMpsVhaT+URU/IT3xAQfmO+AE/ld8Na4uWkdVlOIjQFRhn4lin4/BkSYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=;
 b=tz9gilnOBkzvmpsdv2tqvMhqE2mYo3HvnYSBD36+LF67S2uDR/P/kovhwXEWPXDn801efxEbo6GkoatfO7kvQRZQZdIGy3fG26GxkQgjNPDrfkIcDYWCZw74jpjSy13La/L4v19H8Mp8nNTyM6Sr+a5N2s9tFRIfOpwKH5rjJqnqkgjEj7BSCVn1IiLT88wDQGW925LpfNmprXFJ+TFK/W/DMitN/1yC79CZZDh5G/9GoplqlQya/gb5j3+VoBqvzeNIjfvMns2QreWuZ+k7xZtGZtto4ULIuS4bX/v1173W6stYbSDs/Gvkv286TcA1Fz1l/WDDmfOFwp029E+PJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=;
 b=A5ftvaHJGNu6JmK2ae2l7sFDBjPsgd5ZY90QIhfidWlFXxEi20ukfVw4Lm7NNpxQRqWpUDq15Ly6suC8cq+xfqxwVYURNjF3LGpUl0iMev/u6L9TmXwchbr9iawSgQ9LHmX5KoUlGC3/scmLB3FVNmKy+zFuVqUZLfIRCF1gY+E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 12:43:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 3/5] md/raid0: Atomic write support
Date: Tue, 12 Nov 2024 12:42:54 +0000
Message-Id: <20241112124256.4106435-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 43ce4178-d3e3-451f-3f7b-08dd0317919c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t7DMIhg7UG12MCjkEL4WA6IIW1C2tcbPzyQfQk2dbJpVHzPX50A5RLpffM2o?=
 =?us-ascii?Q?Kl1DwnMbcWySe0602OwJwUvB69XwVGnPHRBvEUDzxofEjrD8VdepI67vTtMC?=
 =?us-ascii?Q?A4o10AAqx0o56aIXpvuGvGtAT1UXvCW7sCT2ookFr7ScSAOfpVfeeYbYovK6?=
 =?us-ascii?Q?4zh8HcAusdK2GQhQsV2B1tMG/CJlrIIbl7DXbAp4SAYxPUS3fgm+i1Ui41N4?=
 =?us-ascii?Q?WHsmuLOSUrfz1WRNn4Wjz2mtyAfHexqPzovwYOKWeFcP/29sISkT6CRaXTPY?=
 =?us-ascii?Q?rTRtwY6uROVqePGvqSVrJ6c3Ji604zeGIxaRQ1rbIPnI7FGD63o4s/yMEZdK?=
 =?us-ascii?Q?dkNy9LwiJy+a44+0psbBm4otQKpPXfYyVUxZR0AWrm19BqaibXupabetL3Wc?=
 =?us-ascii?Q?ZJQX4/7xgGBT2sNxIUphPqoB6PBrUVCS4GLOYJFtzq2nz7WV2/krg8nENLuJ?=
 =?us-ascii?Q?MNy0fH/wRGW9YTYBWFvUj5KSU0hjy/uEo4zWi7cl6iLu6s3y8YhfFwBjskAi?=
 =?us-ascii?Q?pX8IQGOtFONHe+9SrXRIzrb5cQKPMubzn5dYD8bbbcTQkCDMfqtKrtimjzxF?=
 =?us-ascii?Q?YD1F71+pQaLLDc2kEglm+Xp4WUMfFWFZMgaeg4mJXEtXfkH3jVYWjw4wyHes?=
 =?us-ascii?Q?MCzyyoskhI36nQNbg3Sydj1Yfit0b1GdxwewkPgSvnPBN76fCK08TpUxGACi?=
 =?us-ascii?Q?N1ZhfH6f5O0c6LzwCx7OMEnXUk5V/XNXaqQj+Ixf3x0jrClNbqLJArwtoBMO?=
 =?us-ascii?Q?7rOLdrQT+gboGAGjY6wrejWUNc1st80uFJVofglHta1p5Urqi6KBt3AsmQWu?=
 =?us-ascii?Q?ATihTV6NpIbyaLLG1xSxqCge7AmdE0ISh8/wu+TTwIJHNvHbil6gGg7HYF3X?=
 =?us-ascii?Q?hE+JA0n26YCIx4JPvsQmMpd0mfKF7fMYCLsYsCa84eA5TPZZFcljfWC7hbT9?=
 =?us-ascii?Q?I6GiHTTw6x04TRzTFyF92abKXqSCsYj1PYbXg2Y9E2eMItFNybQQ5DhaLFTY?=
 =?us-ascii?Q?d1qgifilBXXSriLKltn6vOvLToKR8Y5Ib7cYbCJBlTY9quh3ZH3poFMUWjx9?=
 =?us-ascii?Q?idVMc0880pw6+UTKmuGw4IY7lw5KMRMmQGNd2RZ84L4Oxh3yUpSZIYB81aJj?=
 =?us-ascii?Q?uLqthbYjujkqfoWs/Z5veYxkwEz7xvZa95PP18k24D2ACgGKjTD94DDEqIfR?=
 =?us-ascii?Q?10a20fBSXSed7gmrT3r/NXtkXob0D+P53eg9HnrZp7QU0dkSd1AJAGvqqAlx?=
 =?us-ascii?Q?FlRhTg+8ntZ0cOZqrlZCeabNxMJDrYQEUyldmGzLgfhgjEs9WxzdYnagmQja?=
 =?us-ascii?Q?j2G+rLtk0fYkrmwB3qNF1MT4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2SrvpC+bhb8CNHpJAf2LplCH3DOkmiFyPaR6JmDEEVD+CmSKzwUYlvs8j+gz?=
 =?us-ascii?Q?EUJCeqP/FNiHncgC/+LvmgcrYoQC8/5NsQdVnR+lu5VskyjZZcn78BW7/4od?=
 =?us-ascii?Q?jgO2mjKz3sC09Stmzr2nK7UzqoZKtoKTIQsIvArgQmmIl7GpZLzQg2s60RcQ?=
 =?us-ascii?Q?QM3Pmphoa3wO/WsUDda8yjh7EpKtn1tsW8oMMJUumyLf1Z7qscAVmClfEvLD?=
 =?us-ascii?Q?AE/5AISK/hRB9oGPPDJfD1+r4faUKnbVQuwnIMKx3jSWyRTfDLykaLabFjG0?=
 =?us-ascii?Q?Y/6SegpTLMUabxVLdnXWRon8Sf11/ok59A3iaH//CgrIS1A6Fl6TNFWLvOwh?=
 =?us-ascii?Q?y2XtzVK6PBGqY4SbEXEQnX2xrl45ZzRJ3QfHzKyv9EvUYgBKbnRH4E88Tm7Y?=
 =?us-ascii?Q?oFsufXG5rhQd0ug8cwnr4VmeDLkWRCKpcenEa/BfgPRj+wER9M0dLhpb8a6S?=
 =?us-ascii?Q?9m3/mkxzM7Vjp6KdyhsScn5gqw/PK9+rZtK3yiGYIcAkW4gLBpesJmunM0ZZ?=
 =?us-ascii?Q?clgdRkfExL8IL+0PfDQc4rot/U0FC2zLHW6mCYZOcmipa3ZPHSfaylGxNERZ?=
 =?us-ascii?Q?X+BxkR0PQjhf/twL2JvTkBEyGHNUmpQQDJQWW4gB64EMOyS9S/4za5gk6LZH?=
 =?us-ascii?Q?G9PU6dtnKYpN/NTK++Bx2uR6JKs+J+josHDTE1OANA3jOGTOwA1i7ztI8HPv?=
 =?us-ascii?Q?ccm1Do1Rdt0ngn07FlJITxttPt6RGJqXR35OtcRHnOyFoYO2MI0eauleUbry?=
 =?us-ascii?Q?/JfgYhX0Zreurlsqm+Ro6NZ8tTermLSW961/rH0sWL47t97FZjPZuaff2KEY?=
 =?us-ascii?Q?sEMZdSl3mZMk76J6+EzwjW3c5Ry4bsI19yDtb1sD3iDQru1JvaoIJTD5P0QA?=
 =?us-ascii?Q?1W/iAiJ/LOlUmTsWO7W28OYseya1YGiJBqe1dL1vejSscZ1+21UeDkBViAdF?=
 =?us-ascii?Q?xSnlDfFRf/5aUQnHOFogn3tZ4aA7lUZGiLaHTsedqvsgoiX6VhebKTfazMX6?=
 =?us-ascii?Q?XunHvdRZxQFDXLLT87mC8euzFXqPdXGZdQ0Nijd8kBnJUZemqSFkeIq0srzi?=
 =?us-ascii?Q?p+UsWwxFq2Ka/61nMGQihkS2mdZR9FjFPWuHKyFfj2XGSfGO8yoYYQCsvKoD?=
 =?us-ascii?Q?dtz5kWKiMCdkayVekA/TIDV+Ng6RzlQtVqwjVjKi+Zp+g6UjkTmHWrgi1wut?=
 =?us-ascii?Q?UkU4ZVltXHgAUu9LB4tyjCpa5uJHGTA8Q22Lh4CO+IOxqELyGSH1JDsbFjCU?=
 =?us-ascii?Q?WGRzAzwmF7MHJrABozZVHcjPfg+QoZ40unF+xjkh/o8N+1Gx9bBzXqbbptu9?=
 =?us-ascii?Q?TaXLXzunIegBwp5A6i7UKoaxY2z6C623jLNz3t5Fev8Ay6GCXjpOG1z7nMSV?=
 =?us-ascii?Q?AWgbR7z+yVmlzWRK+eZ33PcnB2pvNm0vxE757LYZDIwH0DDCgVnpiF22k4hg?=
 =?us-ascii?Q?enavirV8Ub4LP1jpNkm7gRv+SsrLPF92UiscwB2F/elJYthQR/3fNyEogEJB?=
 =?us-ascii?Q?xoeD9cNj1Xlmi0vKjwuTxPGZFxxxJHOluMuTkeVAphMfl2LOJ73v+Sv39r/3?=
 =?us-ascii?Q?C3DR5y0YIOkDhc0jvKSnexomzm3ZzGwbUPEnkqa82F2cp4uAC6HAAJQwoRDJ?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KmP9NrQIJYCsDyl3lIbyNKbL2Ul5jAeJe0uiyS2c2kvKOEr4BQgy5HAs2cJhnK6oNBghLsIdc0U8dgJeQ8bi256o9eRytm457pW4qWoedOvvu8rmfX7QzKwNKDU9bAat5ZW0KintjUQt2afgjOM4EdhJMGPT9MozZyLqB/0Y21tyZtjdiuI7Myxr56M+NPUsBQex+M5zFF7QtDzX3K1ISCaVi13/ppcIVQ7XUZ8MvDReBCuK0j3Tw+kNcC7Jks6sERlUWzdwtwtBCxEVVfColo1GQ0WtYLCceV530C9Oi3vv5CvewNHI0ekACXsJTVvRLLzlK9YuudiDbZbCQTc/km0cKTxo9d5IO/2kB+nMQJj+/FIfBIlhMpLsv0yRpYdE9Tct0fsyDtsm6TNUVOMlfpdWve6/RRWx774tKryJJskxAlHFJmF4ZbC1NVIUIkMtJHW/oOwdfUrZtvsrUauEyBgUbLdtD0O+inThEEcho5ESi/AerxtV5LphRW3H+fL3V58IqpDlG7mlH093CmqUXaiNP64BLLYmjNLPJ3GJ9GzgINqAMI11I/8BpVRsFUWUGqTzdYjmz3vsi5w5kJdYWMkTqZGNAQnEA27LBbqqgCU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ce4178-d3e3-451f-3f7b-08dd0317919c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:11.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJKDypNWb+hDNkK3IsnaJsQtFBWLWlaYdibVM6q1Erk/8ri471G6FkGXAeKt7DPW0Vqx7wdJx/LrJ+mIPnkZhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120102
X-Proofpoint-GUID: gPXgOeXhFCeqKJGO470n9ayF1rLpxr2u
X-Proofpoint-ORIG-GUID: gPXgOeXhFCeqKJGO470n9ayF1rLpxr2u

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes. All other
stacked device request queue limits should automatically be set properly.
With regards to atomic write max bytes limit, this will be set at
hw_max_sectors and this is limited by the stripe width, which we want.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index baaf5f8b80ae..7049ec7fb8eb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

