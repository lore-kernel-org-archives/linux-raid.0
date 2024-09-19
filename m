Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1F213C9B3;
	Thu, 19 Sep 2024 09:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737865; cv=fail; b=o0ygAsrhdg573FlH8Mk4V/7VeG7MltWxVnhlXWW/iGSUBodL8yCuNgfoWqY9XbtYpjHokQiTdy9UZ49nox3EbWbk+vT/ZMvqALsup6fEljiH9+lIEZT7pwwnX4gwUvGd6D+6zPuYdjoeWQB50CjCti3N7iltbnpbmrekEZiE3aQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737865; c=relaxed/simple;
	bh=KT8bVDVywdwZiLBRvjTcJo6fjnpwC3GdLKEv+25gdlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UW19LbOPA5556mXTJf7kBhjXbKbShpmFgFolzD0qlD4FsELgiNIrXuLug/41TAzEzAdx/jOZSim6P7kmpO6zfHr4znicBkWt5ZvdzMvvOxLnXiOICUBF+k04eff0FKvWsAILQqmgLEYrq66ALfsOtAEViW9NCu6Bca3tUhDJsBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U7t3Xzbu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fRuk/6FU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U7t3Xzbu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fRuk/6FU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tYxu008069;
	Thu, 19 Sep 2024 09:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ySc3wwXatpzkf7zkGttVK3zZi0Od14WZX2lVeRDTy0E=; b=
	U7t3XzbuA3ZBSqM9SABjhwO0uREhnQp6kUudfDLhTNu9NG8kryj+P5yQ3+dHfevb
	0yp4nug6lO9mqQK+A+2SyQvPqoalp1bC4Fon4fPqx5pj4T8xnqyGCMQ/hiFmJMiS
	0utnsQKKK8JM6iusIbqyU4OA5hNvfSpnbfU9NLrSm0fiPbHXA4fiMoFgviAjzHOg
	jJhUZj/4Y7pZTe0DZXTHLE/8qIjc+9n+lRZ91zldcbZPXyHwYKW6q7tZT3mucqiu
	eUfxQh8NDZ+ddNxMU4ZxgRjUXN3sa6CHoMtNzlGaD94TRLqCF1Vu1yo1bg3nO/nk
	BzFTIBYXSJNb4QWXrC5WUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129] (may be forged))
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd3qf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J93GE9034154;
	Thu, 19 Sep 2024 09:23:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyckh7x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGW2zYBBuq5Ag4pW6bBJCBV0PlTHsa2kBHMBVmUcVMTGRCDYE4eBXwUuA+9HNtMessJNIjNQqNso5NwM2oQGCejVJWVtzgu2GNGL2pr0Iub3luvp9EULtjU5EkkaRCV2rQHx5lYZ2MVI9+eSfTIylOtfJVNqacqVujWGedor0fMqf2prHlj6/RbjgkjYjho2KCQd0cwwsoH6jdnV6bXlmxYA+Td/S9vrqDve0Qp41WTiveAVzFL7yUN1b7qVUxhEr3rRnZNDv1L4TJO+FlLmdfYV9EKtihIb25zANfFrmEoLDRSZwDXYmMV7nBGqECk/XycsRBQ7mOdNkMGFG97jWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySc3wwXatpzkf7zkGttVK3zZi0Od14WZX2lVeRDTy0E=;
 b=lMnQ8dN+9tPj2t1qYz02Tsg2LyERqMp0F4wWjxvtP99XLWLp47GM4o12MuBuUxTHmo2elRWjGUth5RJk63XFLlVJF6z+tBu/NUyki4e0Z5Z+d6mc6fxBhPTLxqWQW7v3xwMg/6YSga1ylrzxbzkqpieoj6tRBcyVvgnDwGjAG7P7qHGH/uij/rg0sQY2vE3Mv2o3LgsjK+xOnVZ9ysVOEEthpTiOIMER8dg/sKBr5lmGpLjOB9pnuTrNnre41gOc+8cXnK5ubvVZTbZduvxwmNO0o8XGZYl73BxLF+6Fk86tKbAHnprr5vCpYvNYeyIqklN0/mdebcYmAudb4rlqQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySc3wwXatpzkf7zkGttVK3zZi0Od14WZX2lVeRDTy0E=;
 b=fRuk/6FU3bVur8DmQVWh312EWF/LPTRYstDwU+MmrYPux0wVrESsoe/FqLHE7SiIVRyH2g+PGnQ+DqjXna116Z0IIiJejKyxYnaqNnFLb1O7n74ARdoVjtQhFbr+8uafGKA5c/qH4d7aY8J2+YV0R1yVWAcKxXvXPbv8xuQSuwk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 3/6] block: Handle bio_split() errors in bio_submit_split()
Date: Thu, 19 Sep 2024 09:22:59 +0000
Message-Id: <20240919092302.3094725-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0354.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bd68465-69b8-4258-3176-08dcd88cc50c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DAIvYHX/35+KFRyrC+CwXQlDcK1mimZoxxaDvEYo1oaIsToyoRzk0rt3k23z?=
 =?us-ascii?Q?H1YYJOWDDTme/NcZWH+ioi744WxDaJo7lWivCOSqE1P8+keUX/OlHrwPGUYp?=
 =?us-ascii?Q?bof2mO/Yxa8xiA8hDb3YHcU62zatCodAtbd3DoIclGSmTZri7BpwrR3gEQNf?=
 =?us-ascii?Q?ZlQnTCNZU0bW6pTGd1AcHlgVmNiLX5t3n4SOCDPsv3ZyCfQ9BcAll1QMl8J+?=
 =?us-ascii?Q?DsR42d1kkN+fElU/r8abUDn4OW7rN/OAETuiPiKkWhDDQdTG+TVxk4kd5yko?=
 =?us-ascii?Q?l+YxkB1Z6yj+7NFapvhkH/dCuhoLxHpqwpumio9tWel3mB/g3cHSyWwdOCOx?=
 =?us-ascii?Q?Iu7LUDGBfJY4pzNfAU1r6MmTP30YqtskQrpUoXQBfN2govD2y2Nvfdu2QEAW?=
 =?us-ascii?Q?q9QiN/BET9t8ITZGv81YDjDNr+5ViYlV2ENk9fhK9byuTxaHoNEvqx01mwJC?=
 =?us-ascii?Q?pF0w6wF8jrVIxcIm3wF/KlFPs5XbozT1Xon0DwPRyxl0KktSBIXEibWE6ysw?=
 =?us-ascii?Q?BmVtL8BZw75GZXLQyOuMcXKNR6D7ptPKfdjTxFMOteJUW7Sn2KyPhQMSJtTa?=
 =?us-ascii?Q?FAWDglgDK34AngWJGjOd0K2yE7+sjuQnZaYQl8j/20i3AbXaiCr4GSlZ374/?=
 =?us-ascii?Q?/dxJRZ7hfyQUSYagw7rLYpxti6tR6iSnB+lqibBmv7w7stUUc6d2HiDnDiIr?=
 =?us-ascii?Q?7VfJpb5FkC/AhmHrcTXDMdF14RKErkXan0Ozy04xJ5x+O34v3KihMv2/0tUG?=
 =?us-ascii?Q?5UVuePXr9RulmUVjm2xTsTl3ZdeFewHkAsYYAn56vfFxGeMA4ehOBv+IU+10?=
 =?us-ascii?Q?/Odb90SrLRNjgfWcMa/RYu5AVE93INrgviUQpBPcPgEpn1U6koaHdG9NxNLM?=
 =?us-ascii?Q?4fU3atMtwq/hWgSsrt/fvKuz9EUxT/2WYUoIfP+W4XmWDh+hUEpCA8eCTWAD?=
 =?us-ascii?Q?wwZOZjcwLK6UGp+fwAMRpQZ1Cw9sfPd7g6Fcqbm/LKmE+IDHAtmu2h3RC5vG?=
 =?us-ascii?Q?rHFVx9781wg6aeLNf7F+WwWULfrjlzdgvcOoHSg1wpsyPtMIG3i02bcWCoul?=
 =?us-ascii?Q?tds+voihvvDmvBQDrLCopcqQp5sIxEG5VWncXfa4+Ikr3ORP4K4+plrQBMwE?=
 =?us-ascii?Q?haqevUca62Te+lUbAD7Ov/jYgbo64A6eCToUz0e0KjFZO7sHqSCTk1ITA4Xf?=
 =?us-ascii?Q?0XfQJd9N/MXW3XqnO1vN4fHdi/pWwFTccBxYzwutQs0YiY3EyoKIbkkyxztn?=
 =?us-ascii?Q?WyNomeaL2QfWlw3UdMPq7hje0Tra9CHgxAwFNMv78e17j/JE55AB0pgESkxz?=
 =?us-ascii?Q?caFxz/8usBMKcazIvPQlTf/GBRiFo9T95ZUN66Ch/JoJ1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QOWFAk7F7j06/BDwiVpgrVoQfRHz3Rg1W88ZeQ2P52+NckjtIoaFmLD7n+fL?=
 =?us-ascii?Q?GYoFBt6WJyXD/dhM9hrdS3Fml2fSFIJ0LuNEcltauE078GDtjWHwiFUqkCQj?=
 =?us-ascii?Q?DOJ67RCDKeep/vQzrQuIpYm/lHTQt8q/dPpkGSTMA64yY4DruN8ljHlGMIOO?=
 =?us-ascii?Q?Ef2EJ7wG7DQhvMDVAYwC2iEnwVMAfsOUhv2TqSNgIoNX2hOPqN3lJWta5IT6?=
 =?us-ascii?Q?Ku/LHjsepSqG7C5mfQsgPpwwWFCyBMT/Mwj0gHgQVtvEz9ZaZ6kboqYQCSix?=
 =?us-ascii?Q?c5EITyQtrEgDEYVDddZdv/Absa8Loj3/L3oixUH6xLV+nnKVWuZOolbPVQlO?=
 =?us-ascii?Q?Vodi+aQ0fT9IdpYxbvGBm0eSoDNQnflgDLEPRHWbq5Cr56OCvHo37Lw4GqyG?=
 =?us-ascii?Q?5in3ArF/2r1SukS+12yLFVxRBJ77StFCc7IBVqo4CNxyXBfTyw62JmDw/ibi?=
 =?us-ascii?Q?sefxpcXzGAZmBw0/3+bv+e7nWdAH5WmMG744N4mZ3rEqwTLYfyNQNDhCx823?=
 =?us-ascii?Q?LG5K4f67WsXaHGCgLGb19cheMaEQLZ4zQh7UOBd0XZ1LjB/WBxhncO2l+l0X?=
 =?us-ascii?Q?BqEjzKYxx2pJ9Sf/O1r9GIf7z5rQeRCc2g+u+9MJhB1OY+gwsOu+fgvdWzxe?=
 =?us-ascii?Q?U8wDMqQlaJbHKkyO577iTEwDhwqJTS6I/IxPNptlpVPG/nD/5HwWxjPaDrvy?=
 =?us-ascii?Q?Xj1dP4qCcCWx0PmvvHV1IPQZ+zq3S2qEup7fACATzNqxQIUEIcVR3aWZs8Vg?=
 =?us-ascii?Q?WUlzlxs5WSa+K4TYnBVFdReJcWXlvXCSAI1BqddjvZdeBa0ENwv3O/CdGoha?=
 =?us-ascii?Q?zgEGLz15I1AvT4lfSIROVhJDOYBeE1MBphFSfjRpgdRZHL99RbAe3XFlEEDU?=
 =?us-ascii?Q?rVJHmMd2bmOqSZcoEfa4zPEUZO3n1qu5UZu37/X30kUZTWPfjHHRAxpeKxEo?=
 =?us-ascii?Q?NjUeoVXmirZB0N9jXJWexf6v9O6S57aWLFAfyFl3FEXnE8wQW7zAoq1u0PNo?=
 =?us-ascii?Q?rNLIlxmCtiJCT7RIRa3XIZpa3jTjVlkvkzb/ksnGAaHwT/kuJLnrxsgCMAf0?=
 =?us-ascii?Q?2l6fIjW7k/zrLMtfFog4kDIu5VVbUKQvZIGn+1vYr6Yts4vexV1tK6n2Mp8z?=
 =?us-ascii?Q?Gy41hwGn8QsyZb0W+CCyEcOFCBhwKJa0xI3YaYJEqy0Pnr5u295+cs6DXlHy?=
 =?us-ascii?Q?SXiFB8eXwC2fSGnvcEmOtqBIzT1K98P+zck2OfDAL8OSTFcZoKt4VUgDbx12?=
 =?us-ascii?Q?WojN9to43fTLg95vRGcDM8IKWQhg8j5KRKg5k9WImrXOqsxQOdTTQgZqB3PD?=
 =?us-ascii?Q?CzzFDxz03SontvxL3RXemIdVoPOYiw+GQpK42BKYpCrd9maPE8syCs6/vCJs?=
 =?us-ascii?Q?KGI71yCh8PjfQf8DQSP66PkUTMLV6tRI0P9SFp79/S7OSOUtVbp9J+epLB+z?=
 =?us-ascii?Q?cZrdRVlg+0i+2O01BHUfyfusdfQmAGiuR40w0KNhNlv9fFwITS5eR7fmBVDj?=
 =?us-ascii?Q?2KX6jwGASQo/U6Sy8DFqm6Jsx9j8hR3cg+F6i7CC5WDv3nipP+X/zbzf3qXy?=
 =?us-ascii?Q?Cdzn89XIl37SA0ufJ26hwD6Ac88cGqnFTECPXX8TRDph6xj+kbNcNYs+8pT+?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gfqpy1FqM7HiLHfdHAZUjl6Rdmic50q7pFnLyKp6vMzHYZdifU3NFc3Gug9hGeqIA3/Z149wswZWnYdyapjOCUsFjB2oTyNpmjWLXyFNfgU8iWzpmVzORF8H4XVX2T7K7Z4im9cTKAse51doGC2OeEwlViCBiz+M0A+8aUafPn2u2nmYV7zifV6C3pQTw4Sv6cCnywOpL3WgflJLOCnkBWIqSNDrABx7Ox5okhonJsdZ/BNeUS3IM21FjRiyHvVhQeuVfldTTtg/xY7V5W0zEGNd2XyZu8PDd8PfPwB73ghOkbgtYJbB3kq7wMsIqfpIC8XddVfrgNsXfntnYOLb7XRtkqkxtUrIOKngMyi1IyReTJCTJhCWmntRR2gcsXD23BiSVsyihsNgOn61ruy2PpBuU0gM8cZ3fduM9osfbeQ+GDqE8QSIZ6nduMA7g2bagJVAS3ZKgX2zUSJlHf2BP9yAP9fPCnBODNfCr0t98V3rZmkGXEoEeN+x/44B7nlK67Z83Y5CawliK7k8gT0309WEYvgFoWNhSMYuDq1MSrg7r4/tZiJjc+cSoVYzN3OJsZTY5DfcwsL2j4Lo/YlMhSPCPkc9ZDjb6Jlf0+87B7c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd68465-69b8-4258-3176-08dcd88cc50c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:49.3566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iUpHCNJvMEBvYlH1ikgzflESLmrV9IUrD543d3mPxIscIt2MczF/OCPB8fhSQfcjuvuXJ9Tv7I74FlURzvFBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-ORIG-GUID: aZnPloJd_ToA19Qi-vq6Er5MwPEVbvoX
X-Proofpoint-GUID: aZnPloJd_ToA19Qi-vq6Er5MwPEVbvoX

bio_split() may error, so check this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
Should we move the WARN_ON_ONCE(bio_zone_write_plugging(bio)) call (not
shown) in bio_submit_split() to bio_split()?

 block/blk-merge.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ad763ec313b6..ec7be2031819 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -118,6 +118,11 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 
 		split = bio_split(bio, split_sectors, GFP_NOIO,
 				&bio->bi_bdev->bd_disk->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return NULL;
+		}
 		split->bi_opf |= REQ_NOMERGE;
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
-- 
2.31.1

