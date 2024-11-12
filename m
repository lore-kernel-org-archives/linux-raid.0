Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7511F7555;
	Tue, 12 Nov 2024 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415419; cv=fail; b=jhVjDXxGExfvrl3pui6JyP/0wVwjggBYosx2IbeA7vfwmZBpof7HHPXn0LgvmWPQpCNdjKziJ+hSfOXIa1NlD/HeeNFjuGa4/yA6eYDs00a+WLBeiF4wErB4Bj/tXF/P/gnov00f1UBRSrUkShfPN99t8W2F9cSEqQXD8CX0FxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415419; c=relaxed/simple;
	bh=GzBn6DsZG0F3yOhU4+gFN0pAV3ZY6VdRn6hKI2bEsmU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=M/wSkHQqTQoVKHhnHE4QsyCW+hhE2WveSOXR9cXt9SMyNnF0PLWHvhAGTIdSFwANH0IwtA1kLVz/gZN7nIaIwb/mPl9cPEmLdEI8oFWTnTxcKT6X/7/5UBcrSKKx472K9ZgX22szMUvd0d0xvojWTSBnmvC2LpC4hfWJLmk+xa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fyG7KD2k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g49ZDPUs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fyG7KD2k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g49ZDPUs"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfi1s030414;
	Tue, 12 Nov 2024 12:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=/GdC+r0WTA5yBONR
	B5h0C5uGmuFkE7K32bwY+Q164L4=; b=fyG7KD2kN/1tJKwM3tQwGl/xO/2rE2BF
	7J4L6QM2wso9LxXd7RPcWJgW0GHHpFAlMlffTAsd1j/X/abmlsG20VT7+lKCgWDO
	8mzoNBXeGtcpRSv42PxR3+GtgjMZu9qRGDg2z+dfodUMZzjBWk6ajYzCzm8YqPI8
	Gj2zf6p1DEL9cwwury9FbHYMGixJpNERDdmJv++X1cj3925v3u/nx1hzpAFQJEH3
	v/iMbIARTti5btzYFt9IRixtpph5uqbvhRkko4VDwvJP8Y+GRGnK7yRokQNxXLuk
	KD+d4cgtXpkXp/kSMhCT7pf3G+P/bYHx4pi5ZCv3oQ2aRtYtCpA+EQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kbv922-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCUS3F036106;
	Tue, 12 Nov 2024 12:43:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx67u7r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNWuC25KsyqZ8JQwL+yWebRgAanjxk/kFgQwT36HVPb0rS4UQMzeQGxcnFkhk5uBTZVw6rfHxlvNg0mJaFUar/o9FLdZpj9pTJ1ipymMMtrLTY5E9a9FQ+DfxsSChd7bGNUNT9GFZjZV/yZLbXXdjAenAs9OrADk//FKnzN+1CgzHeJHTxiQr+/YO5JRWbx++tKXt42yBGillQ/g9mdKcKASuQUcF5FRJ78jV7sAoH1Lxy8/ty2qXcD5F8XrFay+W7yCXd40nD5a5tuhSCENFXKnVJuxnRNLnkFQLabCxvO4CoL0bOe6W9rJ9sSLtn0qvh8pqLS8Dq2rdObghsc2MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GdC+r0WTA5yBONRB5h0C5uGmuFkE7K32bwY+Q164L4=;
 b=M0lPgoeXAOU+IIJpwnccMn2JmXFtAPXTvJZsPZuG9/jAc1PgIM9Hj+eiWR6//YPMlor6TlpeKjhlUhXeRCALzySTmEx1AUWw4bfnSAp7orWhKLBoqI07s3ygNdyVJpR4X7AQfJwJCtQX1YEGsW6qJpjCk6g5A8RTbcwWYzQAL/eHTwXy7aS+Gpu3IgfB2A/acX4NOS3XlnxiDMv16gq85c6cNKwk+2MkPK77hzUsBBIqm94hykVFWdK7OBhRVgf4Mgvs2mxSYCGnuevrklabjB4NCdY4JOH7AFWD2IVwO37A4FqZfnu/1LK9BaPEgz+YAY3XqQzxUIFGGp7ushK9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GdC+r0WTA5yBONRB5h0C5uGmuFkE7K32bwY+Q164L4=;
 b=g49ZDPUsPi3eegHV0GrCTCIehzZVIhIxE20jyKYPux3uqNtmliuiRDGH7xDTdIdlOfBU2oWOZConuuEgucv58KduBUHAOSgCqrZmW89HXRJoOhBZKLLYu3mhj9DeUenPyovB1udrwzpWT1ed66OTZ53Q4rSSAkEZeRrKVCw9uZU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 12:43:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 0/5] RAID 0/1/10 atomic write support
Date: Tue, 12 Nov 2024 12:42:51 +0000
Message-Id: <20241112124256.4106435-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: e072b229-e2d2-4825-c3b0-08dd03178e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jgRcLFhOAexprObfUMYFuQUtyF7tq36LdXrYi/b4jdzuSZkdJF6wOXoA+KuY?=
 =?us-ascii?Q?YVJCxOAo+h5YSW2kLC0Yb+9z5m8o2dknFqXtIPrVKsHtbBLHzjV8GDpYBtet?=
 =?us-ascii?Q?23sIqDayo3W99+C4vgQ3KJTZSX18frdgfxDpP416qxaD5mdAuqHw0euE8p9+?=
 =?us-ascii?Q?l7C20qzRUVMTd5RpBc3DCsgB9uTbEQ/1uewLOFVVQeaCI9XuhU4P4+uN5ExP?=
 =?us-ascii?Q?tIKxmCZ+ky9Z3uwt9et3FnxNuNSR2j539mZXka+dTbKbxiAwGFYwQArEvfKZ?=
 =?us-ascii?Q?DfhfQSO0BtdaAmLhdkMWMtsDoaw9ZKwmcVkDHulG3VQUcBolFagEUW8R0e2c?=
 =?us-ascii?Q?9Pv8sDLKAZj1Sr/IEERSHM+OP6fAJ3Y9ctrXKy9zlI7AfJI+53gXU9M1NDVG?=
 =?us-ascii?Q?QYvtYtJnKU3HZS5BuFO0Ynf0LZrX3jE1onngiWqJQPGbQRBdS/C4nSREi7vJ?=
 =?us-ascii?Q?IVCJlC2aCT6dpNwYQn6DLTHBF4aWCU06AaHufcv8f2HKSEUZcwncy/v26AiZ?=
 =?us-ascii?Q?Rm0UXia8iRO6U9xYVHlFQ2nWlkzGytkwN+JGFveGvOLBt2miJ76jsMoycX3Y?=
 =?us-ascii?Q?LuPacqZkYU24KfQyrNq7FStkuLVUfBtQUiiwZYot+sBU3dEMuzRubTStHNtE?=
 =?us-ascii?Q?UgcnqTRQmm2O18b5QdDNh72XDHyVGSWEhFRrQhbTn3JMml+emZ+JPHygNGa9?=
 =?us-ascii?Q?vKICsZ/nQz6nGHMnxM9dBDxoteIYVC8kIWS6lrtl5DjYJzcEV1O0qPZ262+A?=
 =?us-ascii?Q?eNoJ+j3FReSbUszxsQa/ALqvvK2JGB+wqlWu2fLQDrX8RUH/KQRkxCcCMg7j?=
 =?us-ascii?Q?7Yma20/RMdGckJea4b7N1V/zaOj+zJ34JAHgHoJe0cmiLuE3+XCWHRs4/ofs?=
 =?us-ascii?Q?2KLUfGfDA40hSMgUNC7/dtL5NCTpt/zg8KWvIrvBr0DMYI/EN+JD08JPAdPd?=
 =?us-ascii?Q?vPbGjFXw0xvPszodJeit4mwc+QvH73r3kS9aWITeHF82JPb3FIOkR3dwfRsG?=
 =?us-ascii?Q?AQPHyXGKYKOOa7vJavAwv0mvU69w84BaQJlcsq+zqXqieAOlxr6VYDGe68lA?=
 =?us-ascii?Q?6qfBE5d8GD73gASK9E6qbDFnWaypAzTyNKaiwKOgo9pUQg6UMwWsGkAU2lts?=
 =?us-ascii?Q?xT4gDLN32YSP21K7RUfcD0y8k18+oBAKFnSFY3zieEoUIUZ5VJLkfu0KeTkd?=
 =?us-ascii?Q?Zoe1ayMB1OCdxZmpOsGuEry2HNfx/LBdcobI402DAaPC6NtCWJntxo8WhJgK?=
 =?us-ascii?Q?w9rlmgVd4JmTn7J5ibFzyw9IUuyxk/5gCbeJEL6EE8/owP3HHx8k2edCUwiK?=
 =?us-ascii?Q?X30TCiwddUFzHAJhtkWFiUPN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5IYaT2Vi1bbS26LOHznzMZ6lZhMRLkp59vEk3BUpQiD27UShAANWZyUvC6w0?=
 =?us-ascii?Q?5NHV9I3Lvu7PaeJRDeO9ANIvDdEBnWdHZ77TQ/BPC63MSxBYJohZRrB0Plni?=
 =?us-ascii?Q?+bivr+a+kXcN3MUbLvBw1OJIpiBNE7haMo5mc603fy83W1RZGxyt8wlYnLdy?=
 =?us-ascii?Q?VQOeP5+unUUmXcWY9hJtOJxuVUdCVsMxg+XOhhF/1hHgR1DEB9tIEPOh8iED?=
 =?us-ascii?Q?J4CPA1qkl5bHLaIPl/Fu1YKZgKBKBFSHjx2wBhdjRBvjYxwY/8/iiLgiLIie?=
 =?us-ascii?Q?V8DAFrvQPQWF1hLO6EIRlO3ktRWuJvMjarMmMsdLCH91HcP+MixFUQMXFi8X?=
 =?us-ascii?Q?tllu8zpiK9h02y6XTi1evD6T3kO2hcunuPhQ71I8+LQBrovYy4tGVffvXtAn?=
 =?us-ascii?Q?d32RZrMGJAwrXnng8DYJ7w3x+tKw2JX/CZtL2Qm0swfTrV9mDu5eowkKLj0t?=
 =?us-ascii?Q?STw0F/lj9m8aEwQ1LwNSOuPtEJwwEYpkkMIwePTVoVDpoRihn1RUjaMqGqhI?=
 =?us-ascii?Q?UaHHHiSgEj8E9RxsbtX11SB/TIBo6TPFWfKh1X/YqT3va02vHK4MOi95ttLV?=
 =?us-ascii?Q?4hgGHmGMTrya0M95pknmVm3DzF3dw0UqT0z8hhulA47NVsHRgIoNxdoxyoZA?=
 =?us-ascii?Q?bbbPOqZpz27XLUT9faWeMpr2JqvUCOOdQHWdJTZ/FaUQF8BBZ3c79wgVodE3?=
 =?us-ascii?Q?CtatKYCueyXFr4uFdCLf7Kz+puF1HZduax4XKOviVAyfFH8W/gJGJpV8Nppi?=
 =?us-ascii?Q?f4tpefrVe+w8P06gyJ1lY3v/HZS16rE3sV+DU0BLuJWsa4lITJFC7CA4Vi+5?=
 =?us-ascii?Q?UHErK3wSqQvPBwdApSi5AcjHWHbBCRTL84hOAEnDn5WuPHWydDVoy9n6OQaK?=
 =?us-ascii?Q?akgkvD25Lkq+UZFE9FBCPndrjpMCUIzurEQdgJj2vfQWxetYzxTfgZaWE3DK?=
 =?us-ascii?Q?dx7V+URSCFLPjGyYRRoR4XjTan2WDqB/EScOqs732vfVWaFBnlV6GBmNDHfy?=
 =?us-ascii?Q?3GXKDVNRhIMgDLW1Jul046w95VvgbqfaOOsb5mC3tDWrc6nG/frenAgG15fk?=
 =?us-ascii?Q?0BnTUZ4UAXAsYS1u+PRXntP8575X/X1xXkAA0TtJSgxYPApk+9Yjl6xXXTdp?=
 =?us-ascii?Q?pQQ1ymK2Azm3KoEDaPAmdwHL8RM+WEuqfOM1txlMbtAHcHoSR4zzycIJZ+eJ?=
 =?us-ascii?Q?3o1wbviVMwNXEa1uqvh8Amxvyk1ojOdD/8fk3ZunhHuCgZ5+NU0ZK+eg6XNJ?=
 =?us-ascii?Q?4M8l86lNmgDTBHk6zRpoTNTSZTZvbgMm6w+6uQRBLnUY7vTMKsExRQnEnVwr?=
 =?us-ascii?Q?j5pHZPDbE2UY384jYezZfJvLDt56kRzNhrQHKQOSby2n2t4NrpgJRfdwLZrI?=
 =?us-ascii?Q?w5njyJwqC3/NxLmtcypR1f/+rTWzRCFrgoXBX3B997AVjAOD1pZwje8tl94y?=
 =?us-ascii?Q?7VmMpLb1xOP1hPTcp++6lI43DdfFmmlZeyZoB5mirMBcs17wXt5AF6fSVaem?=
 =?us-ascii?Q?+KemKiPSvcqGPV7Q0BiCPcZi4TsVKfhiNYnPwMpku9gI1jYlM38H3iM1zxJ3?=
 =?us-ascii?Q?j1fH5d8xLhfCZwWIwjytbSdinrpEZwqKO2p+DHlpET+NiZN623yQxh9kcZoL?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cOsqFn1sXM+hWLfkzHFYDP8TF90XA+ocZTv4AyfPqxlz424dNV2qCyLwmFLHMuiNsjO4STbatMm1m4S+ZtRy6f8CemIocFoilzkw10KYxPiAw64DVArQg7XdJDBQyIjDsAzW2OaLgq/gjcoUoLMF1KgcSpbeh0ydyyhk/Ziywz1hCyfYJb2ru2HWTisLAwD1GvUFd8U7P4apFvt/YJnmgRFAUgvnultD46YEjdFPgzT+GvI+sV5NN15CPK3EJ0cFlxTpSgzbCcQn0BNDr/U7eefp48GFlNGLOKnpl4qZq4oQOMXaMFolTl9wwv9eUXPsM/S+VhgmhhpUKziGvnetByFwyFJDPG9A14RYIM4azNWWsTIoDxjC9cck6syodX0E4IWLCPWEFqfix4I4lPsuTUHUYPpLGRftpZkKhslBraHoc9wyUyjKYE2vUzBKyyd9+dsx4mnhisGqs8BpeUorApXqBtBhM7kXEnoJYPfrTmlZ/Hc3OTKqgAdw63JCrpleHjM98E8fZ0/ur82x7AlmJ1B/XNcyIn4C4YPA8/Q5BNxR/DOSmi9L+66i8qd74OZgfhFxJOUHkGk4rebF72s98XNZwIc7DQHx9Q/xEHDhxDk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e072b229-e2d2-4825-c3b0-08dd03178e17
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:06.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsJNZfebx/poJ1Dq7WSm8BequLkuL3/Jk1sfielxghC4M5SvHn6eTfW77a4OG/QEAh1V+GQOD5zt5Jqn54y1Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=984 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120102
X-Proofpoint-GUID: pm32M1Zhhuhyyn-NhdCp6z3hUbEGWDlD
X-Proofpoint-ORIG-GUID: pm32M1Zhhuhyyn-NhdCp6z3hUbEGWDlD

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

Based on 0b4ace9da58d (for-6.13/block) nvme-multipath: don't bother
clearing max_hw_zone_append_sectors

Differences to v3:
- Add RB tags from Christoph and Kuai (thanks!)
- Rebase

Differences to v2:
- Refactor blk_stack_atomic_writes_limits() (Christoph)
- Relocate RAID 1/10 BB check (Kuai)
- Add RB tag from Christoph (Thanks!)
- Set REQ_ATOMIC for RAID 1/10

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

